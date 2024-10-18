package constants;

enum abstract OpCode(Int) {
	var UNKNOWN = -1;
	var DISPLAY_ERROR = 0;
	var REGISTRY_GLOBAL = 0;
	var GET_REGISTRY = 1;
	var BIND = 0;
}
