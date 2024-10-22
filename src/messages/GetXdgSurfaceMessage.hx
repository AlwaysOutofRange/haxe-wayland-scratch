package messages;

import cpp.Stdlib;
import haxe.io.Bytes;

class GetXdgSurfaceMessage extends WaylandMessage {
	public var new_id:Int;
	public var wl_surface_id:Int;

	public function new(header:HeaderLE, new_id:Int, wl_surface_id:Int) {
		super(header);
		this.new_id = new_id;
		this.wl_surface_id = wl_surface_id;
	}

	override public function toBytes():Bytes {
		var bytes = Bytes.alloc(Stdlib.sizeof(GetXdgSurfaceMessage));
		bytes.set(0, this.header.id);
		bytes.set(4, this.header.op);
		bytes.set(6, this.header.size);
		bytes.set(8, this.new_id);
		bytes.set(12, this.wl_surface_id);
		return bytes;
	}
}
