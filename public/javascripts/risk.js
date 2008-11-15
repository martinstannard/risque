function allocate_armies(game_id,game_player_id) {
  $.post("/games/allocate_armies",{game_id: game_id, game_player_id: game_player_id, country_id: $('#country_id').val(), armies: $('#armies').val(),authenticity_token: global_token}, function(data) {
    $("#out").html(data);
  })
}

function attack(game_id,attacker_country_id, target_country_id) {
  $.post("/games/attack",{game_id: game_id, game_player_id: game_player_id, attacker_country_id: $('#attacker_country_id').val(), target_country_id: $('#target_country_id').val(), armies: $('#armies').val(),authenticity_token: global_token}, function(data) {
    $("#out").html(data);
  })
}