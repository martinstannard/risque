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

  var Country = function Country(country, colour, map) {
    var name = country.name;
    var map = map;
    var x = country.x_position;
    var y = country.y_position;
    var armies = country.armies;
    var radius = 5 + 3 * armies;
    var colour = colour;
    var dx = 0, dy = 0;
    var links = [];
    var group = null; 
    var font = {"font-size": "9px", "font-family": "Arial", fill: "#fff"};
    var obj = {
      name: name,
      x: function () {
        return x;
      },
      y: function () {
        return y;
      },
      linkTo: function (other) {
        if (other === this) return;
        var line = r.path({stroke: "#aaa"}).moveTo(this.x(), this.y()).lineTo(other.x(), other.y());
        line[0].parentNode.insertBefore(line[0], line[0].parentNode.firstChild); // move to back
        var link = {
          start: this,
          end: other,
          line: line
        };
        links.push(link);
        other.linkFrom(link);
      },
      unlink: function (link) {
        if (this === link.start) {
          if (links.indexOf(link) >= 0) {
            links.remove(link);
          }
          link.end.unlink(link);
          $(link.line[0]).remove();
        } 
      },
      remove: function () {
        group.node.remove();
      },
      draw: function () {
        group = map.group();
        group.circle(x, y, radius).attr({fill:'#'+colour, stroke: "#fff", "stroke-width": "2px", opacity: 0.7});
        group.text(x, y+radius+10, name + ' (' + armies + ')').attr(font).show();
      }
    };
    return obj;
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
  };

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

  // replace and draw country on map
  this.createAndDrawCountry = function(json) {
    var country = json.country;
    this.countries[country.id].remove();
    delete this.countries[country.id];
    var colour = this.players[country.game_player_id].colour.colour.hex;
    this.countries[country.id] = new Country(countries[i], colour, this.map);
    this.countries[country.id].draw();
  }


  // draw one country on the map
  this.drawCountry = function(country_json) {
    this.countries[country_json.country.id].draw();
  };

  // Draw all the countries
  this.drawCountries = function() {
    for (i in this.countries) {
      this.countries[i].draw();
    }
  };

  this.createCountry = function(country) {
    var colour = this.players[country.game_player_id].colour.colour.hex;
    this.countries[country.id] = new Country(country, colour, this.map);
  }

  this.createCountries = function(countries) {
    for (i in countries) {
      var country = countries[i].country;
      this.createCountry(country);
    }
    this.drawCountries();
  };

  this.settings = $.extend({
    // Dimensions
    width: 1000,
    height: 700,
    leftGutter: 30,
    bottomGutter: 20,
    topGutter: 20,
    // Label Style
    labelColor: "#f00",
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

/*
jQuery(function ($) {
  var r = new Raphael(document.getElementById("map_holder"), 800, 600);
  var components = [];
  var countries = {};
  var borders = {};

  var Country = function Country(name) {
    var x = 0;
    var y = 0;
    var armies = 48;
    var colour = "ffffff";
    var dx = 0, dy = 0;
    var links = [];
    var obj = {
      name: name,
      x: function () {
        return x;
      },
      y: function () {
        return y;
      },
      moveTo: function (nx, ny) {
        x = nx;
        y = ny;
        for (var l = 0; l<links.length; l++) {
          links[l].line[0].pathSegList.getItem(0).x = this.cx();
          links[l].line[0].pathSegList.getItem(0).y = this.cy();
        }
        for (var l = 0; l<incomingLinks.length; l++) {
          incomingLinks[l].line[0].pathSegList.getItem(1).x = this.cx();
          incomingLinks[l].line[0].pathSegList.getItem(1).y = this.cy();
        }
      },
      linkTo: function (other) {
        if (other === this) return;
        var line = r.path({stroke: "#aaa"}).moveTo(this.x(), this.y()).lineTo(other.x(), other.y());
        line[0].parentNode.insertBefore(line[0], line[0].parentNode.firstChild); // move to back
        var link = {
          start: this,
          end: other,
          line: line
        };
        links.push(link);
        other.linkFrom(link);
      },
      unlink: function (link) {
        if (this === link.start) {
          if (links.indexOf(link) >= 0) {
            links.remove(link);
          }
          link.end.unlink(link);
          $(link.line[0]).remove();
        } 
      },
      remove: function () {
        while (links.length > 0) {
          links[0].start.unlink(links[0]);
        }
        components.remove(this);
        delete countries[username];
      },
      update: function () {
      },
      draw: function () {}
    };
    return obj;
  };

};
*/
