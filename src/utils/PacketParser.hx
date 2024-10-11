package utils;

import cpp.UInt16;
import cpp.UInt32;
import cpp.Int16;
import haxe.io.Bytes;
import haxe.Exception;

class PacketParser {
	var buffer:Bytes;

	public function new(buffer:Bytes) {
		this.buffer = buffer;
	}

	public function getU32():UInt32 {
		if (this.buffer.length < 4) {
			throw new Exception("Not enough bytes in buffer to read u32. Buffer length: " + this.buffer.length);
		}

		var val = cast(this.buffer.sub(0, 4), UInt32);
		this.consume(4);

		return val;
	}

	public function getU16():UInt16Int16 {
		if (this.buffer.length < 2) {
			throw new Exception("Not enough bytes in buffer to read u16. Buffer length: " + this.buffer.length);
		}

		var val = cast(this.buffer.sub(0, 2), UInt16);
		this.consume(2);

		return val;
	}

	public function getString():String {
		if (this.buffer.length < 4) {
			throw new Exception("Not enough bytes in buffer to read string length. Buffer length: " + this.buffer.length);
		}

		var len = cast(this.buffer.sub(0, 4), Int);
		var consume_len = 4 + this.roundup(len, 4);
		var s = this.buffer.sub(4, 4 + len);

		if (consume_len > this.buffer.length) {
			throw new Exception("Not enough bytes in buffer to read string. Buffer length: " + this.buffer.length);
		}

		this.consume(consume_len);

		return [for (b in s.getData()) if (b >= 32 && b <= 126) String.fromCharCode(b)].join("")
	}

	private function consume(len:Int):Void {
		if (this.buffer.length == len) {
			this.buffer = Bytes.alloc(0);
		} else {
			this.buffer = this.buffer.sub(len, this.buffer.length - len);
		}
	}

	private function roundup(val:Int, mul:Int):Int {
		return ((val - 1) / mul + 1) * mul;
	}
}
