package objects;

import cpp.Stdlib;
import messages.HeaderLE;
import messages.CreateSurfaceMessage;
import constants.OpCode;
import constants.ObjectID;

class WlCompositor extends Object {
	public function new(socket:WaylandSocket, id:Int) {
		super(socket, id);
	}

	public function createSurface():WlSurface {
		var wl_surface_id = this.socket.allocateId();
		var msg = new CreateSurfaceMessage(new HeaderLE(cast(ObjectID.WL_COMPOSITOR, Int), cast(OpCode.CREATE_SURFACE, Int),
			Stdlib.sizeof(CreateSurfaceMessage)), wl_surface_id);

		this.socket.write(msg.toBytes());

		return new WlSurface(this.socket, wl_surface_id);
	}
}
