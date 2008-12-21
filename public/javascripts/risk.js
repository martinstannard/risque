function allocate_armies(game_id,game_player_id) {
  $.post("/games/allocate_armies",{game_id: game_id, game_player_id: game_player_id, country_id: $('#country_id').val(), armies: $('#armies').val(),authenticity_token: global_token}, function(data) {
      $("#out").html(data);
      });
  plot_map();
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
  plot_map();
}

function draw_svg (game_id) {
  $('#svgholder').load("/games/svg/" + game_id);
}

var map;

function plot_map() {
  $.getJSON("/games/" + game_id + "/countries", function(data) { map.plot(data)} );
}

function set_players() {
  $.getJSON("/games/" + game_id + "/players", function(data) { map.setPlayers(data)} );
}

$(document).ready(function() {

    map = new Map("map_holder");
    set_players();
    plot_map();

});
