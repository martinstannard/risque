function allocate_armies(game_id,game_player_id) {
  $.post("/games/allocate_armies",{game_id: game_id, game_player_id: game_player_id, country_id: $('#country_id').val(), armies: $('#armies').val(),authenticity_token: global_token}, function(data) {
    $("#out").html(data);
  })
}

function get_neighbours(game_player_id, game_id) {
	$.post("/games/get_neighbours",{game_id: game_id, game_player_id: game_player_id, country_id: $('#attacker_country_id').val(),authenticity_token: global_token}, function(data){
		$("#attack_target").html(data);
	})
}

function attack(game_id,attacker_country_id, target_country_id,armies) {
  $.post("/games/attack",{game_id: game_id, attacker_country_id: attacker_country_id, target_country_id: target_country_id, armies: armies,authenticity_token: global_token}, function(data) {
    $("#out").html(data);
  })
}