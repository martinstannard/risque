Feature: Takeover Country
  In order to win a game
  The countries need be able to take over other countries 
  at the end of a battle

  Scenario: The defender has 0 armies and the attacker has some armies
    Given there is an attacking country with 10 armies
    And the defending country has 0 armies
    When the attacker tried to takeover the defender
    Then the takeover should succeed
    And the target should have 10 armies moved into it
    And the target should be owned by the attacker

