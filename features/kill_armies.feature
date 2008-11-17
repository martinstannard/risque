Feature: Kill Armies
  In order to take over a country
  Armies need to be killed on the attacker and defender
  so we can see if the war is finished

  Scenario: The attacker has won 5 battles
    Given there is an attacking country with 10 armies
    And the defending country has 10 armies
    When 5 of 5 attacks succeed
    Then the attacker should have 10 armies left
    And the defender should have 5 armies left

  Scenario: The defender wins all battles
    Given there is an attacking country with 10 armies
    And the defending country has 10 armies
    When 0 of 5 attacks succeed
    Then the attacker should have 5 armies left
    And the defender should have 10 armies left
    And the defender should be owned by the attacker
