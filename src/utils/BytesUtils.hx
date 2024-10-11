package utils;

import haxe.io.Bytes;

class BytesUtils {
	public static function bytesToString(bytes:Bytes):String {
		return [for (b in bytes.getData()) if (b >= 32 && b <= 126) String.fromCharCode(b)].join("");
	}
}
