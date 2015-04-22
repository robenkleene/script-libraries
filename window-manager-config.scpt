JsOsaDAS1.001.00bplist00�Vscript_�WindowManagerLibrary = Library('window-manager');

var gridSize = { width: 6, height: 3 };

function performWindowAdjustment(windowAdjustment) {
  var windowFrame = WindowManagerLibrary.getFrameForFocusedWindow();
  var screenFrame = WindowManagerLibrary.getScreenForWindowFrame(windowFrame);
  var gridCoordinates = WindowManagerLibrary.nearestGridCoordinatesForFrame(windowFrame, screenFrame, gridSize)
  windowAdjustment(gridCoordinates);
  gridCoordinates = WindowManagerLibrary.validGridCoordinates(gridCoordinates, gridSize);

  var frame = WindowManagerLibrary.frameForGridCoordinates(gridCoordinates, screenFrame, gridSize);
  WindowManagerLibrary.setFrameForFocusedWindow(frame);
}



// Move

function moveFocusedWindowLeft() {
  var windowAdjustment = function(gridCoordinates) { gridCoordinates.x--; };
  performWindowAdjustment(windowAdjustment);
}

function moveFocusedWindowRight() {
  var windowAdjustment = function(gridCoordinates) { gridCoordinates.x++; };
  performWindowAdjustment(windowAdjustment);
}

function moveFocusedWindowUp() {
  var windowAdjustment = function(gridCoordinates) { gridCoordinates.y--; };
  performWindowAdjustment(windowAdjustment);
}

function moveFocusedWindowDown() {
  var windowAdjustment = function(gridCoordinates) { gridCoordinates.y++; };
  performWindowAdjustment(windowAdjustment);
}


// Resize

function resizeFocusedWindowLeft() {
  var windowAdjustment = function(gridCoordinates) { gridCoordinates.width--; };
  performWindowAdjustment(windowAdjustment);
}

function resizeFocusedWindowRight() {
  var windowAdjustment = function(gridCoordinates) { gridCoordinates.width++; };
  performWindowAdjustment(windowAdjustment);
}

function resizeFocusedWindowUp() {
  var windowAdjustment = function(gridCoordinates) { gridCoordinates.height--; };
  performWindowAdjustment(windowAdjustment);
}

function resizeFocusedWindowDown() {
  var windowAdjustment = function(gridCoordinates) { gridCoordinates.height++; };
  performWindowAdjustment(windowAdjustment);
}                              � jscr  ��ޭ