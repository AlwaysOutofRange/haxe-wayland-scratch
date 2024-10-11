# Paths
HAXE_BUILD = build.hxml
TARGET = ./bin

all: build run

build:
	haxe $(HAXE_BUILD)

run:
	$(TARGET)/Main

clean:
	rm -f $(TARGET)

