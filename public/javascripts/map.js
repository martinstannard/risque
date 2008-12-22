/*
 * Map for risque
 *
 * Copyright (c) 2008 Martin Stannard
 * 
 * Based on the SimpleGraph code by Ben Askin
 *
 * Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) license.
 */


function Map(target) {
  // Target div
  this.target = target;

  // Save the players so we can draw the countries with the correct colours
  this.players = {};

  // countries
  this.countries = {};

  // borders
  this.borders = {};

  // setup the players so we can use the colours when we draw the map and connectors
  this.setPlayers = function(players) {
    for (var i = 0, ii = players.length; i < ii; i++) {
      this.players[players[i].game_player.id] = players[i].game_player;
    }
  };


  this.borderColour = function(from, to) {
    var from_player = from.game_player_id;
    var to_player = to.game_player_id;
    var colour;
    if (from_player == to_player) {
      colour = this.players[from_player].colour.colour.hex;
    }
    else {
      colour = 'ddd';
    }
    return colour;
  }

  // draw one border on the map
  this.drawBorder = function(border_json) {
    var border = border_json.neighbour;
    var from = this.countries[border.country_id];
    var to = this.countries[border.neighbour_id];
    //$("g:contains('"+border.name+"')").remove();
    //var colour = this.players[border.game_player_id].colour.hex;
    this.borders[border.id] = border;
    var group = this.map.group();
    var colour = this.borderColour(from, to);
    group.path({stroke: "#"+colour, opacity: 0.25, "stroke-width": "2px"}).moveTo(from.x_position, from.y_position).lineTo(to.x_position, to.y_position);
    this.borders[border.id+'group'] = group;
  };

  // Draw all the borders
  this.drawBorders = function(borders) {
    for (var i = 0, ii = borders.length; i < ii; i++) {
      this.drawBorder(borders[i]);
    }
  };

  // draw one country on the map
  this.drawCountry = function(country_json) {
    var country = country_json.country;
    var country_id = country.id;
    $("g:contains('"+country.name+"')").remove();
    var colour = this.players[country.game_player_id].colour.colour.hex;
    var y = Math.round(country.y_position),
        x = Math.round(country.x_position);
    var radius = this.settings.countryRadius + this.settings.countryIncRadius * country.armies;
    this.countries[country_id] = country;
    var group = this.map.group();
    group.circle(x, y, radius).attr({fill:'#'+colour, stroke: "#fff", "stroke-width": "4px", opacity: 0.7});
    group.text(x, y+radius+10, country.name + ' (' + country.armies + ')').attr(this.labelStyle).show();
  };

  // Draw all the countries
  this.drawCountries = function(countries) {
    for (var i = 0, ii = countries.length; i < ii; i++) {
      this.drawCountry(countries[i]);
    }
  };
  this.settings = $.extend({
    // Dimensions
    width: 1000,
    height: 600,
    leftGutter: 30,
    bottomGutter: 20,
    topGutter: 20,
    // Label Style
    labelColor: "#fff",
    labelFont: "Arial",
    labelFontSize: "9px",
    // Grid Style
    gridBorderColor: "#ccc",
    // -- Y Axis Captions
    yAxisOffset: 0,
    // -- Countries
    drawPoints: true,
    countryStrokeColour: "#fff",
    countryStrokeWidth: 2,
    countryRadius: 10,    
    countryIncRadius: 2,    
    activePointRadius: 10,    
    // -- Line
    drawLine: true,
    lineColor: "#000",
    lineWidth: 3,
    lineJoin: "round",
    // -- Fill
    fillUnderLine: false,
    fillColor: "#888",
    fillOpacity: 0.2,
    // -- Hover
    addHover: true,
    // Mystery Factor - originaly hardcoded to .5 throughout code, need to talk to Dmitry to demystify
    mysteryFactor: 0
  }, (arguments[3] || {}) );


  this.setStyleDefaults = function() {
    // Label Styles
    // - General
    this.labelStyle = {
      font: this.settings.labelFontSize + '"' + this.settings.labelFont + '"', 
      fill: this.settings.labelColor
    };
    // - Countries
    this.countryCircleStyle = {
      stroke: this.settings.countryCircleStroke, 
      fill: this.settings.labelColor
    };
  };

  this.setPenColor = function() {
    if (this.settings.penColor) {
      this.settings.lineColor  = this.settings.penColor;
      this.settings.pointColor = this.settings.penColor;
      this.settings.fillColor  = this.settings.penColor;
    }
  };

  this.map = Raphael(target, this.settings.width, this.settings.height);
  this.setStyleDefaults();
  this.setPenColor();
}

