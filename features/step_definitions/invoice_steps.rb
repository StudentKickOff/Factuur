# frozen_string_literal: true

Given(/^an invoice with id "([^"]*)"$/) do |id|
  @invoice = Invoice.create(id: id, contact: @contact)
end

Given(/^a contact named "([^"]*)"$/) do |name|
  data = {
    name: name,
    vatnumber: 'BE1382041234',
    address: {
      beneficiary: 'Foo',
      street: 'Bar',
      zip_code: 'Bar',
      city: 'Bar',
      country: 'Bar'
    }
  }
  @contact = Contact.create(data)
end

When(/^we try to edit the invoice$/) do
  @invoice.contact = nil
end

Then(/^saving should not succeed$/) do
  expect(@invoice.save).to be false
end

Then(/^a pdf should have been generated alongside it$/) do
  expect(@invoice.generated_pdf).to_not be nil
  expect(MimeMagic.by_magic(@invoice.generated_pdf.data).type).to eq('application/pdf')
end

Given(/^the user is on the page to create a new invoice$/) do
  visit '/invoices/new'
end

When(/^the user fills in the invoice information$/) do
  fill_in 'Netto', with: 30
end

When(/^the user clicks on the submit button$/) do
  click_on 'Submit'
end

Then(/^an invoice is created$/) do
  expect(Invoice.count).to eq(2)
end

Then(/^the user should see the new invoice$/) do
  expect(page).to have_current_path(invoice_path(id: Invoice.last.id))
end

Given(/^the year is (\d+)$/) do |year|
  Timecop.freeze(Time.new(year))
end

When(/^we create a new invoice$/) do
  Invoice.create
end

Then(/^the invoice id should be (.+)$/) do |id|
  Invoice.last.id == id
end
