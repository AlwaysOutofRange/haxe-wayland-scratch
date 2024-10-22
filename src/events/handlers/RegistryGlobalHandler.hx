package events.handlers;

import haxe.io.Bytes;
import utils.BytesUtils;

class RegistryGlobalHandler implements EventHandler {
	var socket:WaylandSocket;

	public function new(socket:WaylandSocket) {
		this.socket = socket;
	}

	public function handle(data:Bytes):Void {
		var name = data.getUInt16(0);
		var interface_name = BytesUtils.bytesToString(data.sub(4, data.length - 8));
		var version = data.getUInt16(data.length - 4);

		Sys.println("Unknown global: name = " + name + ", interface = " + interface_name + ", version = " + version);

		switch (interface_name) {
			case "wl_compositor":
				var compositor = new objects.WlCompositor(this.socket, this.socket.interface_ids.registry);
				compositor.bind(name, interface_name, version);
				this.socket.interface_objects.compositor = compositor;

				var surface = compositor.createSurface();
				surface.bind(name, interface_name, version);
				this.socket.interface_objects.surface = surface;

			case "xdg_wm_base":
				if (this.socket.interface_objects.surface == null) {
					Sys.println("Can't create a surface without wl_surface.");
					return;
				}
				var xdg_wm_base = new objects.XdgWmBase(this.socket, this.socket.interface_ids.registry, this.socket.interface_objects.surface);
				xdg_wm_base.bind(name, interface_name, version);
				this.socket.interface_objects.xdg_wm_base = xdg_wm_base;

				var xdg_surface = this.socket.interface_objects.xdg_wm_base.getXdgSurface();
				xdg_surface.bind(name, interface_name, version);
				this.socket.interface_objects.xdg_surface = xdg_surface;

				var xdg_toplevel = this.socket.interface_objects.xdg_surface.getToplevel();
				xdg_toplevel.bind(name, interface_name, version);
				this.socket.interface_objects.xdg_toplevel = xdg_toplevel;
		}
	}
}
