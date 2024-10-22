package messages;

import haxe.io.BytesBuffer;
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
		this.interface_ = this.interface_ + this.version;

		// Maybe this will work
		var buffer = new BytesBuffer();
		buffer.addByte(this.header.id);
		buffer.addByte(this.header.op);
		buffer.addByte(this.header.size);
		buffer.addByte(this.name);
		buffer.addString(this.interface_);

		/*
			Why thats not working idk
				var bytes = Bytes.alloc(Stdlib.sizeof(BindMessage) + this.interface_.length + 2);
				bytes.set(0, this.header.id);
				bytes.set(4, this.header.op);
				bytes.set(6, this.header.size);
				bytes.set(8, this.name);
				bytes.blit(10, Bytes.ofString(this.interface_), 0, this.interface_.length);
		 */
		return buffer.getBytes();
	}
}
