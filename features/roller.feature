Feature: Roller
  In order to have a battle
  The countries need to roll dice
  In order to determine which armies to kill

  Scenario: The attacker has one more army than the defender
    Given is at battle strength is 5,4
    When the country rolls the dice
    Then the result length should be 4

  Scenario: The attacker has the same number of armies as the defender
    Given is at battle strength is 3,3
    When the country rolls the dice
    Then the result length should be 3
