package messages;

import haxe.Exception;
import haxe.io.Bytes;

class WaylandMessage {
	public var header:HeaderLE;

	public function new(header:HeaderLE) {
		this.header = header;
	}

	public function toBytes():Bytes {
		throw new Exception("'toBytes()' must be override by the subclass!");
	}
}
