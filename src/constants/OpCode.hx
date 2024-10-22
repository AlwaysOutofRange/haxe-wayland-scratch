package constants;

enum abstract OpCode(Int) {
	var UNKNOWN = -1;
	var DISPLAY_ERROR = 0;
	var REGISTRY_GLOBAL = 0;
	var GET_REGISTRY = 1;
	var BIND = 0;
	var CREATE_SURFACE = 0;
	var COMMIT = 6;
	var DAMAGE = 2;
	var ATTACH = 1;
	var GET_XDG_SURFACE = 2;
	var GET_XDG_TOPLEVEL = 1;
	var SET_TITLE = 2;
}
