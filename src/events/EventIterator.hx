package events;

import haxe.io.Bytes;
import cpp.Stdlib;
import haxe.Exception;
import messages.HeaderLE;
import constants.ObjectID;
import constants.OpCode;
import utils.BytesUtils;

class EventIterator {
	var buffer:Bytes;
	var dispatcher:EventDispatcher;

	public function new(buffer:Bytes, dispatcher:EventDispatcher) {
		this.buffer = buffer;
		this.dispatcher = dispatcher;
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
		var header = new HeaderLE(header_id, header_op, header_size);

		if (this.buffer.length < header.size) {
			throw new Exception("Not enough bytes in buffer to read event data. Buffer length: " + this.buffer.length + ", header size: " + header.size);
		}

		var data = this.buffer.sub(8, header.size - 8);

		var objectID = this.castID(header.id);
		var opcode = this.castOpcode(objectID, header.op);

		this.dispatcher.dispatch(objectID, opcode, data);

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
}
