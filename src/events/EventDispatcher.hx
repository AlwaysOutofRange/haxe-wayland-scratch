package events;

import constants.ObjectID;
import constants.OpCode;
import haxe.io.Bytes;

class EventDispatcher {
	private var handlers:Map<ObjectID, Map<OpCode, EventHandler>>;

	public function new() {
		this.handlers = new Map();
	}

	public function registerHandler(objectID:ObjectID, opcode:OpCode, handler:EventHandler):Void {
		if (!this.handlers.exists(objectID)) {
			handlers.set(objectID, new Map<OpCode, EventHandler>());
		}

		var handlerMap = this.handlers.get(objectID);
		handlerMap.set(opcode, handler);
	}

	public function dispatch(objectID:ObjectID, opcode:OpCode, data:Bytes):Void {
		var handlerMap = this.handlers.get(objectID);

		if (handlerMap != null) {
			var handler = handlerMap.get(opcode);
			if (handler != null) {
				handler.handle(data);
			} else {
				trace("No handler for objectID = " + objectID + ", opcode = " + opcode);
			}
		} else {
			trace("No handler for objectID = " + objectID);
		}
	}
}
