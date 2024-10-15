import unix.UnixSocket;
import haxe.io.Bytes;

class WaylandSocket {
	private var socket:UnixSocket;
	private var current_id:Int = 2;

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

	public function getCurrentId():Int {
		return this.current_id;
	}

	public function allocateId():Int {
		return this.current_id++;
	}
}
