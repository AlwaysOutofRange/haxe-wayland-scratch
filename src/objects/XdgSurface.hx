package objects;

import messages.GetXdgTopLevelMessage.GetXdgToplevelMessage;
import messages.HeaderLE;
import constants.OpCode;
import constants.ObjectID;
import cpp.Stdlib;

class XdgSurface extends Object {
	public function new(socket:WaylandSocket, id:Int) {
		super(socket, id);
	}

	public function getToplevel():XdgTopLevel {
		var xdg_toplevel_id = this.socket.allocateId();
		var msg = new GetXdgToplevelMessage(new HeaderLE(cast(ObjectID.XDG_SURFACE, Int), cast(OpCode.GET_XDG_TOPLEVEL, Int),
			Stdlib.sizeof(GetXdgToplevelMessage)), xdg_toplevel_id);

		this.socket.write(msg.toBytes());

		return new XdgTopLevel(this.socket, xdg_toplevel_id);
	}
}
