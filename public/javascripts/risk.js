function allocate_armies(game_id,game_player_id) {
  $.post("/games/allocate_armies",{game_id: game_id, game_player_id: game_player_id, country_id: $('#country_id').val(), armies: $('#armies').val(),authenticity_token: global_token}, function(data) {
      $("#out").html(data);
      $("#map-image").attr("src", "/games/map/" + game_id + "?time=" + (new Date));
      })
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
      $("#map-image").attr("src", "/games/map/" + game_id + "?time=" + (new Date));
      })
}

$(document).ready(function() {

    var paper = Raphael("map", 320, 200);
    // Creates circle at x = 50, y = 40, with radius 10
    var circle = paper.circle(50, 40, 10);

    // Sets the fill attribute of the circle to red (#f00)
    circle.attr("fill", "#f00");
    // Sets the stroke attribute of the circle to white (#fff)
    circle.attr("stroke", "#fff");


});
