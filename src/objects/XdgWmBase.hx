package objects;

import messages.GetXdgSurfaceMessage;
import messages.HeaderLE;
import constants.OpCode;
import constants.ObjectID;
import cpp.Stdlib;

class XdgWmBase extends Object {
	var wl_surface:WlSurface;

	public function new(socket:WaylandSocket, id:Int, wl_surface:WlSurface) {
		super(socket, id);

		this.wl_surface = wl_surface;
	}

	public function getXdgSurface():XdgSurface {
		var xdg_surface_id = this.socket.allocateId();
		var msg = new GetXdgSurfaceMessage(new HeaderLE(cast(ObjectID.XDG_WM_BASE, Int), cast(OpCode.GET_XDG_SURFACE, Int),
			Stdlib.sizeof(GetXdgSurfaceMessage)), xdg_surface_id,
			this.wl_surface.getId());

		this.socket.write(msg.toBytes());

		return new XdgSurface(this.socket, xdg_surface_id);
	}
}
