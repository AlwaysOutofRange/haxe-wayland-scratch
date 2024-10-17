import cpp.Stdlib;
import unix.UnixSocket;
import messages.GetRegistryMessage;
import messages.HeaderLE;
import events.EventIterator;
import events.handlers.DisplayErrorHandler;
import events.handlers.RegistryGlobalHandler;
import events.EventDispatcher;
import constants.ObjectID;
import constants.OpCode;

class Main {
	static public function main():Void {
		var env = new WaylandEnv();
		var waylandSocket = new WaylandSocket(env.getSocketPath());
		var dispatcher = setupEventDispatcher(waylandSocket);
		waylandSocket.connect();

		getRegistry(waylandSocket);

		while (true) {
			var res = waylandSocket.read(4096);
			var it = new EventIterator(res, dispatcher);
			while (it.hasNext()) {
				it.next();
			}
		}

		waylandSocket.close();
	}

	static function setupEventDispatcher(socket:WaylandSocket):EventDispatcher {
		var dispatcher = new EventDispatcher();
		dispatcher.registerHandler(ObjectID.WL_DISPLAY, OpCode.DISPLAY_ERROR, new DisplayErrorHandler());
		dispatcher.registerHandler(ObjectID.WL_REGISTRY, OpCode.REGISTRY_GLOBAL, new RegistryGlobalHandler(socket));
		return dispatcher;
	}

	static function getRegistry(socket:WaylandSocket):Void {
		var msg = new GetRegistryMessage(new HeaderLE(cast(ObjectID.WL_DISPLAY, Int), // wayland_display_object_id
			cast(OpCode.GET_REGISTRY, Int), // wayland_wl_display_get_registry_opcode
			Stdlib.sizeof(GetRegistryMessage)), socket.allocateId());

		socket.write(msg.toBytes());
	}
}
