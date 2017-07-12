class Invoice
  include Mongoid::Document
  # created_at, updated_at
  include Mongoid::Timestamps

  # Invoices should be immutable and never changed.
  validate :force_immutable
  before_create :generate_and_set_pdf

  field :description, type: String
  field :_id, type: String, default: -> { Invoice.next_id }
  field :generated_pdf, type: BSON::Binary

  def self.generate(params = {})
    res = nil
    Dir.mktmpdir do |dir|
      # TODO: Put this in a config
      # command = 'electron-pdf'
      command = 'node_modules/electron-pdf/cli.js'
      input_file = "#{dir}/input.html"
      output_file = "#{dir}/output.pdf"

      s = ApplicationController.render(
        'invoices/invoice_pdf',
        layout: 'paper',
        locals: {
          # TODO: make this ready for production
          base_url: 'http://localhost:3000',
          **params
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

    results = where(:created_at.gte => boy).and(:created_at.lte => eoy)
    idx = if results.empty?
            '01'
          else
            format('%02i', results.last.id.split('-')[1].to_i + 1)
          end

    "#{dt.year}-#{idx}"
  end

  private

  def generate_and_set_pdf
    self.generated_pdf = BSON::Binary.new(Invoice.generate(netto: 500))
  end

  def force_immutable
    return if !changed? || !persisted?

    errors.add(:base, :immutable)
    reload
  end
end
