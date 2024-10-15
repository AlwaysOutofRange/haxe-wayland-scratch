package events.handlers;

import haxe.io.Bytes;
import utils.BytesUtils;

class RegistryGlobalHandler implements EventHandler {
	public function new() {}

	public function handle(data:Bytes):Void {
		var name = data.getUInt16(0);
		var interface_name = BytesUtils.bytesToString(data.sub(4, data.length - 8));
		var version = data.getUInt16(data.length - 4);

		Sys.println("Registry: name = " + name + ", interface = " + interface_name + ", version = " + version);
	}
}
