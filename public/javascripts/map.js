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

  // save the players so we can draw the countries with the correct colours
  this.players = {};

  // countries
  this.countries = {};

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


  var r = Raphael(target, this.settings.width, this.settings.height);

  // Draw a grid to paint points over
  this.drawMap = function() {

    // It's assumed that the X Axis remains static over multiple values of Y, so this code stays where it is
    this.X            = (this.settings.width - this.settings.leftGutter) / this.labels.length;
    this.leftGridEdge = this.settings.leftGutter + this.X * this.settings.mysteryFactor;
    this.topGridEdge  = this.settings.topGutter;
    this.gridWidth    = this.settings.width - this.settings.leftGutter - this.X;
    this.columns      = this.labels.length - 1; 

  };

  // setup the players so we can use the colours when we draw the map and connectors
  this.setPlayers = function(players) {
    for (var i = 0, ii = players.length; i < ii; i++) {
      this.players[players[i].game_player.id] = players[i].game_player;
    }
  }

  // Plot points on the graph
  this.plot = function(countries) {
    var label            = [],
        is_label_visible = false,
        leave_timer;

    // Line path
    var path = r.path({stroke: this.settings.lineColor, "stroke-width": this.settings.lineWidth, "stroke-linejoin": this.settings.lineJoin}); 

    // Fill path
    var bgp = r.path({stroke: "none", fill: this.settings.fillColor, opacity: this.settings.fillOpacity})
      .moveTo(this.settings.leftGutter + this.X * this.settings.mysteryFactor, this.settings.height - this.settings.bottomGutter);

    var dots  = r.group(),
        cover = r.group();

    // Plot the points
    for (var i = 0, ii = countries.length; i < ii; i++) {
      var country = countries[i].country;
      var country_player = country.game_player_id;
      var colour = this.players[country_player].colour.colour.hex;
      var y = Math.round(this.settings.height - this.settings.bottomGutter - country.y_position),
          x = Math.round(this.settings.leftGutter + country.x_position);
      var radius = this.settings.countryRadius + this.settings.countryIncRadius * country.armies;
      var dot  = dots.circle(x, y, radius).attr({fill:'#'+colour, stroke: "#fff", strokewidth: 2});
      var text = dots.text(x, y+radius+10, country.name + ' (' + country.armies + ')').attr(this.hoverLabelStyle).show();
    }
  };

  this.setStyleDefaults = function() {
    // X and Y axis labels and captions default to global style if not provided
    // - X Axis Labels
    if (!this.settings.xAxisLabelColor) {
    this.settings.xAxisLabelColor = this.settings.labelColor;
    }
    if (!this.settings.xAxisLabelFont) {
    this.settings.xAxisLabelFont = this.settings.labelFont;
    }
    if (!this.settings.xAxisLabelFontSize) {
    this.settings.xAxisLabelFontSize = this.settings.labelFontSize;
    }
    // - Y Axis Labels
    if (!this.settings.yAxisLabelColor) {
      this.settings.yAxisLabelColor = this.settings.labelColor;
    }
    if (!this.settings.yAxisLabelFont) {
      this.settings.yAxisLabelFont = this.settings.labelFont;
    }
    if (!this.settings.yAxisLabelFontSize) {
      this.settings.yAxisLabelFontSize = this.settings.labelFontSize;
    }
    // - Y Axis Caption
    if (!this.settings.yAxisCaptionColor) {
      this.settings.yAxisCaptionColor = this.settings.labelColor;
    }
    if (!this.settings.yAxisCaptionFont) {
      this.settings.yAxisCaptionFont = this.settings.labelFont;
    }
    if (!this.settings.yAxisCaptionFontSize) {
      this.settings.yAxisCaptionFontSize = this.settings.labelFontSize;
    }
    // - Hover Labels - Labels from the X Axis that appear when hovering over points in the graph
    if (!this.settings.hoverLabelColor) {
      this.settings.hoverLabelColor = this.settings.labelColor;
    }
    if (!this.settings.hoverLabelFont) {
      this.settings.hoverLabelFont = this.settings.labelFont;
    }
    if (!this.settings.hoverLabelFontSize) {
      this.settings.hoverLabelFontSize = this.settings.labelFontSize;
    }
    // - Hover Values - Values from the Y Axis that appear when hovering over points in the graph
    if (!this.settings.hoverValueColor) {
      this.settings.hoverValueColor = this.settings.labelColor;
    }
    if (!this.settings.hoverValueFont) {
      this.settings.hoverValueFont = this.settings.labelFont;
    }
    if (!this.settings.hoverValueFontSize) {
      this.settings.hoverValueFontSize = this.settings.labelFontSize;
    }
    // Label Styles
    // - General
    this.labelStyle = {
      font: this.settings.labelFontSize + '"' + this.settings.labelFont + '"', 
      fill: this.settings.labelColor
    };
    // - Hover Labels
    this.hoverLabelStyle = {
      font: this.settings.hoverLabelFontSize + '"' + this.settings.hoverLabelFont + '"', 
      fill: this.settings.hoverLabelColor
    };
    // - Hover Values
    this.hoverValueStyle = {
      font: this.settings.hoverValueFontSize + '"' + this.settings.hoverValueFont + '"', 
      fill: this.settings.hoverValueColor
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

  this.setStyleDefaults();
  this.setPenColor();
}

