function allocate_armies(game_id,game_player_id) {
  $.post("/games/allocate_armies",{game_id: game_id, game_player_id: game_player_id, country_id: $('#country_id').val(), armies: $('#armies').val(),authenticity_token: global_token}, function(data) {
      $("#out").html(data);
      //$("#map-image").attr("src", "/games/map/" + game_id + "?time=" + (new Date));
      //draw_map();
      })
  var armies = $('#armies option:selected').text();
  var country_id = $('#country_id').val();

  var xy = getXY(country_id);
  resize(country_id, armies);
  country_armies(country_id, armies, xy);
  highlight(country_id);
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
      draw_map();
      })
}

function draw_svg (game_id) {
  $('#svgholder').load("/games/svg/" + game_id);
}

function highlight(country_id) {
  countries[country_id].attr("stroke", "#f00");
  countries[country_id].attr("stroke-width", 4);
}

function unhighlight(country_id) {
  countries[country_id].attr("stroke", "#fff");
  countries[country_id].attr("stroke-width", 2);
}

function scale(country_id, size) {
  countries[country_id].scale(size);
}

function resize(country_id, size) {
  countries[country_id].attr("r", parseInt(size) * 10);
}

function country_armies(country_id, armies, xy) {
  var attr = {"font": '20px "Verdana"', opacity: 0.8};
  console.log(country_id);
  //armies[country_id][0].remove();
  $('text').remove();
  var txt = paper.text(xy[0], xy[1], armies);
  console.log(txt);
}

function getXY(country_id) {
  bbox = countries[country_id].getBBox();
  console.log(bbox);
  var xy = [bbox.x + bbox.width/2, bbox.y + bbox.height/2];
  console.log(xy);
  return xy;
}

  //var attr = {"font": '12px "Verdana"', opacity: 0.8}; 
  //countries[country_id].text(x_pos, y_pos - 20, name).attr(attr).attr("fill", "#0f0");

var countries = {};
var armies = {};
var paper;

$(document).ready(function() {

    draw_map();

});
