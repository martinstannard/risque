Feature: Region creation 
  In order to play the game of Risque
  The world needs a
  Region to hold countries to battle on 

  Scenario: A region is created
    Given a region exists
    Then the region should contain at least 2 countries
    And the region should have a name

