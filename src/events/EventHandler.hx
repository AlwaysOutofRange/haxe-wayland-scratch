package events;

import haxe.io.Bytes;

interface EventHandler {
	public function handle(data:Bytes):Void;
}
