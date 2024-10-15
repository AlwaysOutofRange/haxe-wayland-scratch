package utils;

import haxe.io.Bytes;
import cpp.Stdlib;
import haxe.Exception;

enum abstract ObjectID(Int) {
	var WL_DISPLAY = 1;
	var WL_REGISTRY = 2;
}

enum abstract OpCode(Int) {
	var DISPLAY_ERROR = 0;
	var REGISTRY_GLOBAL = 0;
	var GET_REGISTRY = 1;
}

class EventIterator {
	var buffer:Bytes;

	public function new(buffer:Bytes) {
		this.buffer = buffer;
	}

	public function next():Void {
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
		var res = {header: header, data: data};

		this.processEvent(res);

		this.consume(header.size);
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

	private function processEvent(ev:{header:HeaderLE, data:Bytes}):Void {
		var objectID = this.castID(ev.header.id);
		var opcode = this.castOpcode(objectID, ev.header.op);

		switch (objectID) {
			case ObjectID.WL_DISPLAY:
				switch (opcode) {
					case OpCode.DISPLAY_ERROR: this.handleDisplayError(ev.data);
					default: trace("Unknown opcode for wl_display: " + opcode);
				}

			case objectID.WL_REGISTRY:
				switch (opcode) {
					case OpCode.REGISTRY_GLOBAL: this.handleRegistryGlobal(ev.data);
					default: trace("Unknown opcode for wl_registry: " + opcode);
				}
			default:
				trace("Unknown object ID: " + objectID);
		}
	}

	private function castID(id:Int):ObjectID {
		return switch (id) {
			case 1: ObjectID.WL_DISPLAY;
			case 2: ObjectID.WL_REGISTRY;
			default: throw new Exception("Unknown object ID: " + id);
		}
	}

	private function castOpcode(objectID:ObjectID, opcode:Int):OpCode {
		return switch (objectID) {
			case ObjectID.WL_DISPLAY:
				switch (opcode) {
					case 0: OpCode.DISPLAY_ERROR;
					default: throw new Exception("Unknown opcode for wl_display: " + opcode);
				}
			case ObjectID.WL_REGISTRY:
				switch (opcode) {
					case 0: OpCode.REGISTRY_GLOBAL;
					default: throw new Exception("Unknown opcode for wl_registry: " + opcode);
				}
			default:
				throw new Exception("Unknown object ID while casting opcode");
		}
	}

	private function handleDisplayError(data:Bytes):Void {
		var object_id = data.getUInt16(0);
		var code = data.getUInt16(2);
		var message = BytesUtils.bytesToString(data.sub(6, data.length - 6));

		trace("Display error: object_id = " + object_id + ", code = " + code + ", message = " + message);
	}

	private function handleRegistryGlobal(data:Bytes):Void {
		var name = data.getUInt16(0);
		var interface_name = BytesUtils.bytesToString(data.sub(4, data.length - 8));
		var version = data.getUInt16(data.length - 4);

		trace("Registry: name = " + name + ", interface = " + interface_name + ", version = " + version);
	}
}
