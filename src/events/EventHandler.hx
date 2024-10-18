package events;

import haxe.io.Bytes;

interface EventHandler {
	function handle(data:Bytes):Void;
}
