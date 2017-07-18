Feature: Working with invoices

  Background:
    Given a contact named "Jantje"
    And an invoice with id "2017-06"

  Scenario: Invoices are immutable
    When we try to edit the invoice
    Then saving should not succeed

  Scenario: An invoice should generate a pdf file
    Then a pdf should have been generated alongside it

  Scenario: Creating an invoice
    Given the user is on the page to create a new invoice
    When the user fills in the invoice information
    And the user clicks on the submit button
    Then an invoice is created
    And the user should see the new invoice

  Scenario Outline: Incrementing invoice numbers
    Given the year is <year>
    When we create a new invoice
    Then the invoice id should be <id>

    Examples:
      | year | id |
      | 2017 | 2017-07 |
      | 2018 | 2018-01 |
