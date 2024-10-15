package events.handlers;

import haxe.io.Bytes;
import utils.BytesUtils;

class DisplayErrorHandler implements EventHandler {
	public function new() {}

	public function handle(data:Bytes):Void {
		var object_id = data.getUInt16(0);
		var code = data.getUInt16(2);
		var message = BytesUtils.bytesToString(data.sub(6, data.length - 6));

		Sys.println("Display error: object_id = " + object_id + ", code = " + code + ", message = " + message);
	}
}
