package messages;

import haxe.io.BytesBuffer;
import haxe.io.Bytes;

class SetTitleMessage extends WaylandMessage {
	public var title:String;

	public function new(header:HeaderLE, title:String) {
		super(header);
		this.title = title;
	}

	override public function toBytes():Bytes {
		var bytes = new BytesBuffer();
		bytes.addByte(this.header.id);
		bytes.addByte(this.header.op);
		bytes.addByte(this.header.size);
		bytes.addString(this.title);
		return bytes.getBytes();
	}
}
