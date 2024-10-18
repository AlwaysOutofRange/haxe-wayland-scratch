package objects;

import cpp.Stdlib;
import constants.ObjectID;
import constants.OpCode;
import messages.BindMessage;
import messages.HeaderLE;

class Object {
	var socket:WaylandSocket;
	var id:Int;

	public function new(socket:WaylandSocket, id:Int) {
		this.socket = socket;
	}

	public function bind(name:Int, interface_:String, version:Int):Void {
		var msg = new BindMessage(new HeaderLE(cast(ObjectID.WL_REGISTRY, Int), // wayland_wl_registry_object_id
			cast(OpCode.BIND, Int), // wayland_wl_object_bind_opcode
			Stdlib.sizeof(BindMessage)), name, interface_, version);

		socket.write(msg.toBytes());
	}
}
