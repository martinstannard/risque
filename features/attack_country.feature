Feature: Attack Country
  In order to take over another country
  The player needs to
  Attack a target country from one of his countries

  Scenario: A player is attacking 
    Given there is an attacking country
    And there is a defending country
    When the player attacks with 3 armies
    Then the result should be a string containing 3

