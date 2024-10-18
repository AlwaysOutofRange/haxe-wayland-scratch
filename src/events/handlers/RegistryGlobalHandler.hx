package events.handlers;

import haxe.io.Bytes;
import utils.BytesUtils;

class RegistryGlobalHandler implements EventHandler {
	var socket:WaylandSocket;

	public function new(socket:WaylandSocket) {
		this.socket = socket;
	}

	public function handle(data:Bytes):Void {
		var name = data.getUInt16(0);
		var interface_name = BytesUtils.bytesToString(data.sub(4, data.length - 8));
		var version = data.getUInt16(data.length - 4);

		switch (interface_name) {
			case "wl_compositor":
				var compositor = new objects.WlCompositor(this.socket, this.socket.getCurrentId());
				compositor.bind(name, interface_name, version);
			default:
				Sys.println("Registry: name = " + name + ", interface = " + interface_name + ", version = " + version);
		}
	}
}
