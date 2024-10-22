package constants;

enum abstract ObjectID(Int) {
	var UNKNOWN = -1;
	var WL_DISPLAY = 1;
	var WL_REGISTRY = 2;
	var WL_COMPOSITOR = 4;
	var WL_SURFACE = 14;
	var XDG_WM_BASE = 1;
	var XDG_SURFACE = 3;
	var XDG_TOPLEVEL = 4;
}
