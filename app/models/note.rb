require 'open3'
require 'tmpdir'

class Note
  include Mongoid::Document
  # created_at, updated_at
  include Mongoid::Timestamps
  # Soft delete
  include Mongoid::Paranoia
  # Factuurtypes
  include Mongoid::Enum

  enum :kind, [:invoice, :credit, :income]

  # Notes should be immutable and never changed.
  validate :force_immutable

  # First: calculate totals
  # Second: generate pdf (needs those totals)
  before_create :calculate_and_set_totals, :generate_and_set_pdf

  field :_id, type: String, default: -> { Note.next_id }
  field :generated_pdf, type: BSON::Binary
  field :vat_percentage, type: BigDecimal, default: 21.0

  # These fields are automatically calculated before creation
  # They could be methods, but because the costs are immutable, we can
  # just as well just calculate them once.
  field :net_total, type: BigDecimal
  field :vat_total, type: BigDecimal
  field :gross_total, type: BigDecimal

  embeds_many :costs
  accepts_nested_attributes_for :costs

  belongs_to :contact

  validates_presence_of :contact, :vat_percentage

  validates_length_of :costs, minimum: 1

  def generate_pdf
    res = nil
    Dir.mktmpdir do |dir|
      # TODO: Put this in a config
      # command = 'electron-pdf'
      exe = 'node_modules/.bin/electron-pdf'
      exe.prepend('xvfb-run -n 9 ') if Rails.env.production?
      input_file = "#{dir}/input.html"
      output_file = "#{dir}/output.pdf"

      s = ApplicationController.render(
        'notes/note_pdf',
        layout: 'paper',
        locals: {
          note: self
        }
      )
      File.write(input_file, s)

      logger.info '======'
      command = "#{exe} #{input_file} #{output_file}"
      logger.info "Running '#{command}'"
      Open3.popen3(command) do |_, out, err, wait_thr|
        logger.info "STDOUT: #{out.read}"
        logger.info "STDERR: #{err.read}"

        if wait_thr.value == 0
          res = File.binread(output_file)
        else
          errors.add :generated_pdf, 'Error creating PDF. Check logs.'
        end
      end
      logger.info '======'
    end

    res
  end

  def self.next_id
    dt = Date.today
    boy = dt.beginning_of_year
    eoy = dt.end_of_year

    results = unscoped.where(:created_at.gte => boy).and(:created_at.lte => eoy)
    idx = if results.empty?
            '01'
          else
            format('%02i', results.last.id.split('-')[1].to_i + 1)
          end

    "#{dt.year}-#{idx}"
  end

  # Because mongoid-enums doesn't to I18N
  def self.kind_i18n_select_options
    Note::KIND.map do |k, _|
      [I18n.t("mongoid.enums.#{model_name.i18n_key}.kind.#{k}"), k]
    end
  end

  private

  def calculate_and_set_totals
    self.net_total = costs.map(&:amount).sum
    self.vat_total = (net_total * (vat_percentage/100)).round(2)
    self.gross_total = net_total + vat_total
  end

  def generate_and_set_pdf
    self.generated_pdf = BSON::Binary.new(generate_pdf)
  end

  def force_immutable
    return if !changed? || !persisted?

    errors.add(:base, :immutable)
    reload
  end
end

class Cost
  include Mongoid::Document

  field :description, type: String
  field :date, type: Date, default: -> { Date.today }
  field :amount, type: BigDecimal, default: 0

  validates_presence_of :description, :date, :amount
end
