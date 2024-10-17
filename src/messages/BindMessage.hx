package messages;

import haxe.io.BytesBuffer;
import cpp.Stdlib;
import haxe.io.Bytes;

class BindMessage extends WaylandMessage {
	public var globalId:Int;
	public var interface_:String;
	public var version:Int;
	public var newId:Int;

	public function new(header:HeaderLE, globalId:Int, interface_:String, version:Int, newId:Int) {
		super(header);
		this.globalId = globalId;
		this.interface_ = interface_;
		this.version = version;
		this.newId = newId;
	}

	override public function toBytes():Bytes {
		var buffer = new BytesBuffer();
		buffer.addByte(this.header.id);
		buffer.addByte(this.header.op);
		buffer.addInt32(this.header.size);
		buffer.addInt32(this.globalId);
		buffer.addInt32(this.interface_.length);
		buffer.add(Bytes.ofString(this.interface_));
		buffer.addInt32(this.version);
		return buffer.getBytes();
	}
}
