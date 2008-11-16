Feature: World creation 
  In order to play the game of Risque
  The game needs a
  world map of countries to battle on 

  Scenario: A world is created
    Given a world exists
    Then the world should contain at least 2 regions
    And the world should have a name

