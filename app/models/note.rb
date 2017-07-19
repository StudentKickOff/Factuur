class Note
  include Mongoid::Document
  # created_at, updated_at
  include Mongoid::Timestamps
  # Soft delete
  include Mongoid::Paranoia
  # Factuurtypes
  include Mongoid::Enum

  enum :kind, [:note, :credit, :income]

  # Notes should be immutable and never changed.
  validate :force_immutable
  before_create :generate_and_set_pdf

  field :_id, type: String, default: -> { Note.next_id }
  field :generated_pdf, type: BSON::Binary
  field :vat_percentage, type: BigDecimal, default: 21.0

  embeds_many :costs
  accepts_nested_attributes_for :costs

  belongs_to :contact

  validates_presence_of :contact

  def net_total
    costs.map(&:amount).sum
  end

  def generate_pdf
    res = nil
    Dir.mktmpdir do |dir|
      # TODO: Put this in a config
      # command = 'electron-pdf'
      command = 'node_modules/electron-pdf/cli.js'
      input_file = "#{dir}/input.html"
      output_file = "#{dir}/output.pdf"

      s = ApplicationController.render(
        'notes/note_pdf',
        layout: 'paper',
        locals: {
          # TODO: make this ready for production
          base_url: 'http://localhost:3000',
          note: self
        }
      )
      File.write(input_file, s)

      `#{command} #{input_file} #{output_file}`

      res = File.binread(output_file)
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

  private

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
  field :date, type: Date
  field :amount, type: Integer

  validates_presence_of :description, :date, :amount
end
