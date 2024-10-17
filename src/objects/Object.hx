package objects;

import cpp.Stdlib;
import constants.ObjectID;
import constants.OpCode;
import messages.BindMessage;
import messages.HeaderLE;
import WaylandSocket;

class Object {
	var socket:WaylandSocket;
	var id:Int;

	public function new(socket:WaylandSocket, id:Int) {
		this.socket = socket;
	}

	public function bind(globalId:Int, interface_:String, version:Int, newId:Int):Void {
		var msg = new BindMessage(new HeaderLE(cast(ObjectID.WL_REGISTRY, Int), // wayland_wl_registry_object_id
			cast(OpCode.BIND, Int), // wayland_wl_object_bind_opcode
			Stdlib.sizeof(BindMessage)), globalId, interface_, version, newId);

		socket.write(msg.toBytes());
	}
}