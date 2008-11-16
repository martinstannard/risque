Feature: Game creation 
  In order to play the game of Risque
  Players need a
  game object to mediate playing on

  Scenario: Create a world
    Given there are no games yet
    And there are 4 players
    When I press the begat world button
    Then there should be 1 game created
    And the game should have a world

