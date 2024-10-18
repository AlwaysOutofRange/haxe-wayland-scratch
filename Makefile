# Paths
HAXE_BUILD = build.hxml
TARGET = ./bin

all: build run

build:
	haxe $(HAXE_BUILD)

run:
	$(TARGET)/Main

lint:
	haxelib run checkstyle -s src

clean:
	rm -f $(TARGET)

