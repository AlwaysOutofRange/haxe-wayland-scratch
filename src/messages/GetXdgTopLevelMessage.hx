package messages;

import cpp.Stdlib;
import haxe.io.Bytes;

class GetXdgToplevelMessage extends WaylandMessage {
	public var new_id:Int;

	public function new(header:HeaderLE, new_id:Int) {
		super(header);
		this.new_id = new_id;
	}

	override public function toBytes():Bytes {
		var bytes = Bytes.alloc(Stdlib.sizeof(GetXdgToplevelMessage));
		bytes.set(0, this.header.id);
		bytes.set(4, this.header.op);
		bytes.set(6, this.header.size);
		bytes.set(8, this.new_id);
		return bytes;
	}
}
