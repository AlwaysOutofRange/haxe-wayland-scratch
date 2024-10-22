import objects.WlSurface;
import objects.XdgWmBase;
import objects.XdgSurface;
import objects.XdgTopLevel;
import objects.WlCompositor;
import unix.UnixSocket;
import haxe.io.Bytes;

typedef InterfaceIds = {
	var registry:Int;
}

typedef InterfaceObjects = {
	var compositor:WlCompositor;
	var surface:WlSurface;
	var xdg_wm_base:XdgWmBase;
	var xdg_surface:XdgSurface;
	var xdg_toplevel:XdgTopLevel;
}

class WaylandSocket {
	var socket:UnixSocket;
	var current_id:Int = 1;

	public var interface_ids:InterfaceIds = {
		registry: -1,
	};

	public var interface_objects:InterfaceObjects = {
		compositor: null,
		surface: null,
		xdg_wm_base: null,
		xdg_surface: null,
		xdg_toplevel: null,
	};

	public function new(socketPath:String) {
		socket = new UnixSocket(socketPath);
	}

	public function connect():Void {
		socket.init();
		socket.connect();
	}

	public function write(msg:Bytes):Void {
		socket.writeBytes(msg);
	}

	public function read(maxLen:Int):Bytes {
		var res = socket.readBytes(maxLen);
		return res.data.sub(0, res.len);
	}

	public function close():Void {
		socket.close();
	}

	public function allocateId():Int {
		return ++this.current_id;
	}
}
