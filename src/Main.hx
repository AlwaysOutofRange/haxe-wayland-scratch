import cpp.Stdlib;
import messages.GetRegistryMessage;
import messages.HeaderLE;
import events.EventIterator;
import events.handlers.DisplayErrorHandler;
import events.handlers.RegistryGlobalHandler;
import events.EventDispatcher;
import constants.ObjectID;
import constants.OpCode;

/**
 * @link https://wayland.app/protocols/wayland
**/
class Main {
	static public function main():Void {
		var env = new WaylandEnv();
		var waylandSocket = new WaylandSocket(env.getSocketPath());
		var dispatcher = setupEventDispatcher(waylandSocket);
		waylandSocket.connect();

		getRegistry(waylandSocket);

		var commited = false;
		var res = waylandSocket.read(4096);
		var it = new EventIterator(res, dispatcher);

		while (true) {
			while (it.hasNext()) {
				it.next();
			}

			if (waylandSocket.interface_objects.surface != null && !commited) {
				waylandSocket.interface_objects.surface.attach(0, 0);
				waylandSocket.interface_objects.surface.damage(0, 0, 600, 800);
				waylandSocket.interface_objects.xdg_toplevel.setTitle("Haxe");
				waylandSocket.interface_objects.surface.commit();
				commited = true;
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
		var registry_id = socket.allocateId();
		var msg = new GetRegistryMessage(new HeaderLE(cast(ObjectID.WL_DISPLAY, Int), // wayland_display_object_id
			cast(OpCode.GET_REGISTRY, Int), // wayland_wl_display_get_registry_opcode
			Stdlib.sizeof(GetRegistryMessage)), registry_id);

		socket.interface_ids.registry = registry_id;
		socket.write(msg.toBytes());
	}
}
