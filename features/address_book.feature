Feature: Using the address book

@wip
Scenario: Viewing the address book
  When navigating to the address book
  Then the user gets shown all the addresses in the system

@wip
Scenario: Adding a new address
  Given the user is on the new address page
  When the user fills in the form for a new address
  Then a new address is created
  And the user is redirected to the address book overview
