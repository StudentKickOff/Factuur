Feature: Using the address book

  Background:
    Given the following contacts exist:
      | name | address |
      | Jan Janssens | Straatdink 1 |

  @wip
  Scenario: Adding a new address
    Given the user is on the new address page
    When the user fills in the form for a new address
    Then a new address is created
    And the user is redirected to the address book overview
