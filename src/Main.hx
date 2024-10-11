import cpp.Stdlib;
import unix.UnixSocket;
import messages.GetRegistryMessage;
import utils.HeaderLE;
import utils.EventIterator;
import utils.BytesUtils;

class Main {
	static public function main():Void {
		var id = 2;

		var xdg_runtime_dir = Sys.getEnv("XDG_RUNTIME_DIR");
		if (xdg_runtime_dir == null) {
			trace("XDG_RUNTIME_DIR not set");
			Sys.exit(-1);
		}

		var wayland_display = Sys.getEnv("WAYLAND_DISPLAY");
		if (wayland_display == null) {
			trace("WAYLAND_DISPLAY not set");
			Sys.exit(-1);
		}

		var socket = new UnixSocket(xdg_runtime_dir + "/" + wayland_display);
		socket.init();
		socket.connect();

		getRegistry(socket, id);
		var res = socket.readBytes(4096);

		var it = new EventIterator(res.data.sub(0, res.len));
		while (it.hasNext()) {
			var e = it.next();

			Sys.println("HeaderLE{id: " + e.header.id + ", op: " + e.header.op + ", size: " + e.header.size + "}, Registry: "
				+ BytesUtils.bytesToString(e.data));
		}

		socket.close();
	}

	static function getRegistry(socket:UnixSocket, new_id:Int):Void {
		var msg = new GetRegistryMessage(new HeaderLE(1, // wayland_display_object_id
			1, // wayland_wl_display_get_registry_opcode
			Stdlib.sizeof(GetRegistryMessage)), new_id);

		socket.writeBytes(msg.toBytes());
	}
}
