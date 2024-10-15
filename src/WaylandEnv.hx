class WaylandEnv {
	public var xdgRuntimeDir:String;
	public var waylandDisplay:String;

	public function new() {
		this.xdgRuntimeDir = Sys.getEnv("XDG_RUNTIME_DIR");
		if (xdgRuntimeDir == null) {
			trace("XDG_RUNTIME_DIR not set");
			Sys.exit(-1);
		}

		this.waylandDisplay = Sys.getEnv("WAYLAND_DISPLAY");
		if (waylandDisplay == null) {
			trace("WAYLAND_DISPLAY not set");
			Sys.exit(-1);
		}
	}

	public function getSocketPath():String {
		return this.xdgRuntimeDir + "/" + this.waylandDisplay;
	}
}