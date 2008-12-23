function allocate_armies(game_id,game_player_id) {
  $.post("/games/allocate_armies",{game_id: game_id, game_player_id: game_player_id, country_id: $('#country_id').val(), armies: $('#armies').val(),authenticity_token: global_token}, function(data) {
      $("#out").html(data);
      });
  draw_country($('#country_id').val());
}

function pass_turn(game_id,game_player_id) {
  $.post("/games/pass_turn",{game_id: game_id, game_player_id: game_player_id, authenticity_token: global_token}, function(data) {
      $("#out").html(data);
      })
}

function get_neighbours(game_player_id, game_id) {
  $.post("/games/get_neighbours",{game_id: game_id, game_player_id: game_player_id, country_id: $('#attacker_country_id').val(),authenticity_token: global_token}, function(data){
      $("#attack_target").html(data);
      })
}

function attack(game_id,game_player_id,attacker_country_id, target_country_id,armies) {
  $.post("/games/attack",{game_id: game_id, game_player_id: game_player_id, attacker_country_id: attacker_country_id, target_country_id: target_country_id, armies: armies,authenticity_token: global_token}, function(data) {
      $("#out").html(data);
      });
  draw_country(attacker_country_id);
  draw_country(target_country_id);
}

function draw_svg (game_id) {
  $('#svgholder').load("/games/svg/" + game_id);
}

var map;

// draw one country on the map
function draw_country(country_id) {
  $.getJSON("/countries/" + country_id, function(data) { map.createAndDrawCountry(data)} );
}

// draw all the countries
function initialise() {
  $.getJSON("/games/" + game_id + "/countries", function(data) { map.createCountries(data)} );
}

// draw all the countries
function draw_map() {
  draw_countries();
//  draw_borders();
}

// draw all the countries
function draw_borders() {
  $.getJSON("/borders/" + game_id, function(data) { map.drawBorders(data)} );
}

// draw all the countries
function draw_countries() {
  map.drawCountries();
}

function set_players() {
  $.getJSON("/games/" + game_id + "/players", function(data) { map.setPlayers(data)} );
}

$(document).ready(function() {

    map = new Map("map_holder");
    set_players();
    initialise();

});
