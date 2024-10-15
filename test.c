#include <stdio.h>
#include <stdlib.h>
#include <wayland-client.h>

// Callback function when a global object is added to the registry
static void registry_global(void *data, struct wl_registry *registry,
                            uint32_t name, const char *interface,
                            uint32_t version) {
  printf("Registry: name = %d, interface = %s, version = %d\n", name, interface,
         version);
}

// Callback function when a global object is removed from the registry
static void registry_global_remove(void *data, struct wl_registry *registry,
                                   uint32_t name) {
  printf("Registry: name = %d removed\n", name);
}

// The interface for wl_registry_listener that contains the callback functions
static const struct wl_registry_listener registry_listener = {
    .global = registry_global,
    .global_remove = registry_global_remove,
};

int main(int argc, char **argv) {
  struct wl_display *display = NULL;
  struct wl_registry *registry = NULL;

  // Connect to the Wayland display (compositor)
  display = wl_display_connect(NULL);
  if (!display) {
    fprintf(stderr, "Failed to connect to the Wayland display.\n");
    return -1;
  }

  printf("Connected to Wayland display.\n");

  // Get the registry
  registry = wl_display_get_registry(display);
  if (!registry) {
    fprintf(stderr, "Failed to get Wayland registry.\n");
    wl_display_disconnect(display);
    return -1;
  }

  // Add registry listener to get global objects
  wl_registry_add_listener(registry, &registry_listener, NULL);

  // Roundtrip to ensure all events are processed
  wl_display_roundtrip(display);

  // Enter the event loop to keep the connection alive
  while (wl_display_dispatch(display) != -1) {
    // Loop through and dispatch Wayland events
  }

  // Clean up and disconnect
  wl_display_disconnect(display);
  printf("Disconnected from Wayland display.\n");

  return 0;
}
