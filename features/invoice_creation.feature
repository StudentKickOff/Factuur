Feature: Working with invoices

Scenario: trying to edit an invoice
  Given an invoice has been created
  When we try to edit the invoice
  Then saving should not succeed

Scenario: an invoice should generate a pdf file
  Given an invoice has been created
  Then a pdf should have been generated alongside it

Scenario: Creating an invoice
  Given the user is on the page to create a new invoice
  When the user clicks on the submit button
  Then an invoice is created
  And the user should see the new invoice

@wip
Scenario: Incrementing invoice numbers
