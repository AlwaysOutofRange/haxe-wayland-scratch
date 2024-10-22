package messages;

import cpp.Stdlib;
import haxe.io.Bytes;

class DamageMessage extends WaylandMessage {
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;

	public function new(header:HeaderLE, x:Int, y:Int, width:Int, height:Int) {
		super(header);
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	override public function toBytes():Bytes {
		var bytes = Bytes.alloc(Stdlib.sizeof(DamageMessage));
		bytes.set(0, this.header.id);
		bytes.set(4, this.header.op);
		bytes.set(6, this.header.size);
		bytes.set(8, this.x);
		bytes.set(12, this.y);
		bytes.set(16, this.width);
		bytes.set(20, this.height);
		return bytes;
	}
}
