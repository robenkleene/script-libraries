JsOsaDAS1.001.00bplist00ÑVscript_)&(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.WindowManager = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Grid = (function() {
  function Grid(horizontalBlocks, verticalBlocks, screenBounds) {
    this.horizontalBlocks = horizontalBlocks;
    this.verticalBlocks = verticalBlocks;
    this.screenBounds = screenBounds;
    this.blockWidth = this.screenBounds.width / this.horizontalBlocks
    this.blockHeight = this.screenBounds.height / this.verticalBlocks
  }

  Grid.prototype.nearestGridCoordinatesForBounds = function(bounds) {
    var gridCoordinates = {};
    gridCoordinates.x = Math.round((bounds.x - this.screenBounds.x) / this.blockWidth);
    gridCoordinates.y = Math.round((bounds.y - this.screenBounds.y) / this.blockHeight);
    gridCoordinates.width = Math.max(1, Math.round(bounds.width / this.blockWidth));
    gridCoordinates.height = Math.max(1, Math.round(bounds.height / this.blockHeight));
    return gridCoordinates;
  };

  Grid.prototype.boundsForGridCoordinates = function(gridCoordinates) {
    var x = Math.round(gridCoordinates.x * this.blockWidth + this.screenBounds.x);
    var y = Math.round(gridCoordinates.y * this.blockHeight + this.screenBounds.y);
    var w = Math.round(gridCoordinates.width * this.blockWidth);
    var h = Math.round(gridCoordinates.height * this.blockHeight);
    return { x: x, y: y, width: w, height: h }
  };

  Grid.prototype.validGridCoordinates = function(gridCoordinates) {
    gridCoordinates.x = Math.min(gridCoordinates.x, this.horizontalBlocks - gridCoordinates.width);
    gridCoordinates.x = Math.max(gridCoordinates.x, 0);
    gridCoordinates.y = Math.min(gridCoordinates.y, this.verticalBlocks - gridCoordinates.height);
    gridCoordinates.y = Math.max(gridCoordinates.y, 0);
    gridCoordinates.width = Math.min(gridCoordinates.width, this.horizontalBlocks - gridCoordinates.x)
    gridCoordinates.width = Math.max(gridCoordinates.width, 1)
    gridCoordinates.height = Math.min(gridCoordinates.height, this.verticalBlocks - gridCoordinates.y)
    gridCoordinates.height = Math.max(gridCoordinates.height, 1)
    return gridCoordinates;
  };

  Grid.prototype.boundsHacked = function(bounds) {
    // bounds.y += this.screenBounds.y;
    // bounds.height -= this.screenBounds.y;
    return bounds;
  };

  return Grid;
})();
module.exports = Grid;
},{}],2:[function(require,module,exports){
ObjC.import('AppKit');

// var MENUBAR_HEIGHT = $.NSMenuView.menuBarHeight();
var MENUBAR_HEIGHT = 23;

exports.bounds = function() {
  var screenOne = $.NSScreen.mainScreen;
  // The main screen is not necessarily the same screen that contains the menu bar or has its origin at (0, 0). The main screen refers to the screen containing the window that is currently receiving keyboard events. It is the main screen because it is the one with which the user is most likely interacting.
  // var screenOne = $.NSScreen.screens.objectAtIndex(0);
  var frame = screenOne.visibleFrame;
  x = frame.origin.x;
  y = frame.origin.y + MENUBAR_HEIGHT;
  width = frame.size.width;
  height = frame.size.height;
  return {
    x: x, 
    y: y, 
    width: width, 
    height: height
  };
};
},{}],3:[function(require,module,exports){
var Grid = require('./grid');
var Window = require('./window');

var DEFAULT_HORIZONTAL_BLOCKS = 6;
var DEFAULT_VERTICAL_BLOCKS = 3;

var WindowManager = (function() {
  function WindowManager(horizontalBlocks, verticalBlocks, Screen) {

    if (!horizontalBlocks) {
      horizontalBlocks = DEFAULT_HORIZONTAL_BLOCKS;
    }

    if (!verticalBlocks) {
      verticalBlocks = DEFAULT_VERTICAL_BLOCKS;
    }

    if (!Screen) {
      Screen = require("./screen");
    }

    var screenBounds = Screen.bounds();
    this.grid = new Grid(horizontalBlocks, verticalBlocks, screenBounds);
  };


  // Move Window

  WindowManager.prototype.moveFocusedWindowDown = function() {
    var window = Window.focusedWindow();
    var bounds = this.boundsMovedDown(window.bounds());
    bounds = this.grid.boundsHacked(bounds);
    window.bounds = bounds;
  };

  WindowManager.prototype.moveFocusedWindowUp = function() {
    var window = Window.focusedWindow();
    var bounds = this.boundsMovedUp(window.bounds());
    bounds = this.grid.boundsHacked(bounds);
    window.bounds = bounds;
  };

  WindowManager.prototype.moveFocusedWindowLeft = function() {
    var window = Window.focusedWindow();
    var bounds = this.boundsMovedLeft(window.bounds());
    bounds = this.grid.boundsHacked(bounds);
    window.bounds = bounds;
  };

  WindowManager.prototype.moveFocusedWindowRight = function() {
    var window = Window.focusedWindow();
    var bounds = this.boundsMovedRight(window.bounds());
    bounds = this.grid.boundsHacked(bounds);
    window.bounds = bounds;
  };


  // Resize Window

  WindowManager.prototype.resizeFocusedWindowDown = function() {
    var window = Window.focusedWindow();
    var bounds = this.boundsResizedDown(window.bounds());
    bounds = this.grid.boundsHacked(bounds);
    window.bounds = bounds;
  };

  WindowManager.prototype.resizeFocusedWindowUp = function() {
    var window = Window.focusedWindow();
    var bounds = this.boundsResizedUp(window.bounds());
    bounds = this.grid.boundsHacked(bounds);
    window.bounds = bounds;
  };

  WindowManager.prototype.resizeFocusedWindowLeft = function() {
    var window = Window.focusedWindow();
    var bounds = this.boundsResizedLeft(window.bounds());
    bounds = this.grid.boundsHacked(bounds);
    window.bounds = bounds;
  };

  WindowManager.prototype.resizeFocusedWindowRight = function() {
    var window = Window.focusedWindow();
    var bounds = this.boundsResizedRight(window.bounds());
    bounds = this.grid.boundsHacked(bounds);
    window.bounds = bounds;
  };



  // Move Bounds

  WindowManager.prototype.boundsMovedDown = function(bounds) {
    var gridCoordinates = this.grid.nearestGridCoordinatesForBounds(bounds);
    gridCoordinates.y++;
    gridCoordinate = this.grid.validGridCoordinates(gridCoordinates);
    var bounds = this.grid.boundsForGridCoordinates(gridCoordinates);
    return bounds;
  };

  WindowManager.prototype.boundsMovedUp = function(bounds) {
    var gridCoordinates = this.grid.nearestGridCoordinatesForBounds(bounds);
    gridCoordinates.y--;
    gridCoordinate = this.grid.validGridCoordinates(gridCoordinates);
    var bounds = this.grid.boundsForGridCoordinates(gridCoordinates);
    return bounds;
  };

  WindowManager.prototype.boundsMovedRight = function(bounds) {
    var gridCoordinates = this.grid.nearestGridCoordinatesForBounds(bounds);
    gridCoordinates.x++;
    gridCoordinate = this.grid.validGridCoordinates(gridCoordinates);
    var bounds = this.grid.boundsForGridCoordinates(gridCoordinates);
    return bounds;
  };

  WindowManager.prototype.boundsMovedLeft = function(bounds) {
    var gridCoordinates = this.grid.nearestGridCoordinatesForBounds(bounds);
    gridCoordinates.x--;
    gridCoordinate = this.grid.validGridCoordinates(gridCoordinates);
    var bounds = this.grid.boundsForGridCoordinates(gridCoordinates);
    return bounds;
  };
  
  // Resize Bounds

  WindowManager.prototype.boundsResizedDown = function(bounds) {
    var gridCoordinates = this.grid.nearestGridCoordinatesForBounds(bounds);
    gridCoordinates.height++;
    gridCoordinate = this.grid.validGridCoordinates(gridCoordinates);
    var bounds = this.grid.boundsForGridCoordinates(gridCoordinates);
    return bounds;
  };

  WindowManager.prototype.boundsResizedUp = function(bounds) {
    var gridCoordinates = this.grid.nearestGridCoordinatesForBounds(bounds);
    gridCoordinates.height--;
    gridCoordinate = this.grid.validGridCoordinates(gridCoordinates);
    var bounds = this.grid.boundsForGridCoordinates(gridCoordinates);
    return bounds;
  };

  WindowManager.prototype.boundsResizedRight = function(bounds) {
    var gridCoordinates = this.grid.nearestGridCoordinatesForBounds(bounds);
    gridCoordinates.width++;
    gridCoordinate = this.grid.validGridCoordinates(gridCoordinates);
    var bounds = this.grid.boundsForGridCoordinates(gridCoordinates);
    return bounds;
  };

  WindowManager.prototype.boundsResizedLeft = function(bounds) {
    var gridCoordinates = this.grid.nearestGridCoordinatesForBounds(bounds);
    gridCoordinates.width--;
    gridCoordinate = this.grid.validGridCoordinates(gridCoordinates);
    var bounds = this.grid.boundsForGridCoordinates(gridCoordinates);
    return bounds;
  };

  return WindowManager;
})();
module.exports = WindowManager;
},{"./grid":1,"./screen":2,"./window":4}],4:[function(require,module,exports){

function frontmostApp() {
  var filtered = Application("System Events").processes.whose({ frontmost: true });
  var appOne = filtered[0];
  var app = Application(appOne.name());
  // app.includeStandardAdditions = true
  return app
}

exports.focusedWindow = function focusedWindow() {
  var frontmostApplication = frontmostApp();
  var windowOne = frontmostApplication.windows()[0];
  if (typeof windowOne == 'undefined') {
    return null;
  }
  return windowOne;
};
},{}]},{},[3])(3)
});

var windowManager = new WindowManager(null, null, null);

function moveFocusedWindowRight() {
  windowManager.moveFocusedWindowRight();
}

function moveFocusedWindowLeft() {
  windowManager.moveFocusedWindowLeft();
}

function moveFocusedWindowUp() {
  windowManager.moveFocusedWindowUp();
}

function moveFocusedWindowDown() {
  windowManager.moveFocusedWindowDown();
}

function resizeFocusedWindowRight() {
  windowManager.resizeFocusedWindowRight();
}

function resizeFocusedWindowLeft() {
  windowManager.resizeFocusedWindowLeft();
}

function resizeFocusedWindowUp() {
  windowManager.resizeFocusedWindowUp();
}

function resizeFocusedWindowDown() {
  windowManager.resizeFocusedWindowDown();
}
                              )<jscr  úÞÞ­