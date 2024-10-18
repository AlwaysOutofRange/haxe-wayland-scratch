package messages;

import haxe.io.Bytes;

class BindMessage extends WaylandMessage {
	public var name:Int;
	public var interface_:String;
	public var version:Int;

	public function new(header:HeaderLE, name:Int, interface_:String, version:Int) {
		super(header);
		this.name = name;
		this.interface_ = interface_;
		this.version = version;
	}

	override public function toBytes():Bytes {
		var bytes = Bytes.alloc(12 + this.interface_.length);
		bytes.set(0, this.header.id);
		bytes.set(4, this.header.op);
		bytes.set(6, this.header.size);
		bytes.set(8, this.name);
		bytes.blit(12, Bytes.ofString(this.interface_), 0, this.interface_.length);
		bytes.set(12 + this.interface_.length, this.version);

		return bytes;
	}
}
