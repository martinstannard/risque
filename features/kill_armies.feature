Feature: Kill Armies
  In order to take over a country
  Armies need to be killed on the attacker and defender
  so we can see if the war is finished

  Scenario: The attacker has won 5 battles
    Given there is an attacking country with 10 armies
    And the defending country has 10 armies
    When the killing is all on the defender
    Then then attacker should have 10 armies left
    Then then defender should have 5 armies left

  Scenario: The defender has won 5 battles
    Given there is an attacking country with 10 armies
    And the defending country has 10 armies
    When the country kills armies
    Then then attacker should have 5 armies left
    Then then defender should have 10 armies left
