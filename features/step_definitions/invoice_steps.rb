Given(/^an invoice has been created$/) do
  @invoice = Invoice.create
end

When(/^we try to edit the invoice$/) do
  @invoice.description = 'Testing'
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

When(/^the user clicks on the submit button$/) do
  click_on 'Submit'
end

Then(/^an invoice is created$/) do
  expect(Invoice.count).to eq(1)
end

Then(/^the user should see the new invoice$/) do
  expect(page).to have_current_path(invoice_path(id: Invoice.last.id))
end
