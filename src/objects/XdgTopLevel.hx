package objects;

import messages.SetTitleMessage;
import messages.HeaderLE;
import constants.OpCode;
import constants.ObjectID;
import cpp.Stdlib;

class XdgTopLevel extends Object {
	public function new(socket:WaylandSocket, id:Int) {
		super(socket, id);
	}

	public function setTitle(title:String):Void {
		var msg = new SetTitleMessage(new HeaderLE(cast(ObjectID.XDG_TOPLEVEL, Int), cast(OpCode.SET_TITLE, Int), Stdlib.sizeof(SetTitleMessage)), title);

		socket.write(msg.toBytes());
	}
}
