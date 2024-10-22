package messages;

import cpp.Stdlib;
import haxe.io.Bytes;

class CommitMessage extends WaylandMessage {
	public function new(header:HeaderLE) {
		super(header);
	}

	override public function toBytes():Bytes {
		var bytes = Bytes.alloc(Stdlib.sizeof(CommitMessage));
		bytes.set(0, this.header.id);
		bytes.set(4, this.header.op);
		bytes.set(6, this.header.size);
		return bytes;
	}
}
