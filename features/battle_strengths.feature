Feature: Battle Strengths
  In order to have a battle
  The countries need to have armies 
  In order to send them into battle

  Scenario: The attacker has more armies than the defender
    Given there is an attacking country with 10 armies
    And the defending country has 8 armies
    When the player attacks with 10 dice
    Then the battle strengths should be 8, 8

  Scenario: The attacker has the same number of armies as the defender
    Given there is an attacking country with 10 armies
    And the defending country has 10 armies
    When the player attacks with 10 dice
    Then the battle strengths should be 10, 9

  Scenario: The attacker has less armies than the defender
    Given there is an attacking country with 10 armies
    And the defending country has 20 armies
    When the player attacks with 10 dice
    Then the battle strengths should be 10, 9
