package messages;

import cpp.Stdlib;
import haxe.io.Bytes;

class AttachMessage extends WaylandMessage {
	public var x:Int;
	public var y:Int;

	public function new(header:HeaderLE, x:Int, y:Int) {
		super(header);
		this.x = x;
		this.y = y;
	}

	override public function toBytes():Bytes {
		var bytes = Bytes.alloc(Stdlib.sizeof(AttachMessage) + 8);
		bytes.set(0, this.header.id);
		bytes.set(4, this.header.op);
		bytes.set(6, this.header.size);
		bytes.set(8, 0);
		bytes.set(12, this.x);
		bytes.set(16, this.y);
		return bytes;
	}
}
