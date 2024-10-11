package utils;

import haxe.io.Bytes;
import cpp.Stdlib;
import haxe.Exception;

class EventIterator {
	var buffer:Bytes;
	var packetParser:PacketParser;

	public function new(buffer:Bytes) {
		this.buffer = buffer;
		this.packetParser = new PacketParser(buffer);
	}

	public function next():{header:HeaderLE, data:Bytes} {
		var header_size = Stdlib.sizeof(HeaderLE);

		if (this.buffer.length < header_size) {
			throw new Exception("Not enough bytes in buffer to allocate header size. Buffer length: "
				+ this.buffer.length
				+ ", header size: "
				+ header_size);
		}

		var header_bytes = this.buffer.sub(0, header_size);

		var header_id = header_bytes.getUInt16(0);
		var header_op = header_bytes.getUInt16(4);
		var header_size = header_bytes.getUInt16(6);
		if (header_size == 0) {
			throw new Exception("Invalid header size");
		}
		var header = new HeaderLE(header_id, header_op, header_size);

		if (this.buffer.length < header.size) {
			throw new Exception("Not enough bytes in buffer to read event data. Buffer length: " + this.buffer.length + ", header size: " + header.size);
		}

		var data = this.buffer.sub(8, header.size - 8);

		this.consume(header.size);

		return {header: header, data: data};
	}

	public function hasNext():Bool {
		return this.buffer.length >= Stdlib.sizeof(HeaderLE);
	}

	public function setBuffer(buffer:Bytes):Void {
		this.buffer = buffer;
	}

	private function consume(len:Int):Void {
		if (this.buffer.length == len) {
			this.buffer = Bytes.alloc(0);
		} else {
			this.buffer = this.buffer.sub(len, this.buffer.length - len);
		}
	}
}
