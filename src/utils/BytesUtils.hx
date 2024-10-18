package utils;

import haxe.io.Bytes;

class BytesUtils {
	/**
	 * Convert a bytes object to a string.
	 *
	 * @param bytes The bytes object to convert.
	 * @return A string representation of the bytes object.
	**/
	public static function bytesToString(bytes:Bytes):String {
		// Filter out all bytes that are not printable ASCII characters
		// (i.e. bytes >= 32 and <= 126, excluding "/")
		var str = [
			for (b in bytes.getData())
				if (b >= 32 && b <= 126 && b != 47 && b != 38) String.fromCharCode(b)
		].join("");

		// Replace any non-ASCII characters with nothing
		str = ~/[^\x00-\x7F]+/g.replace(str, "");

		// Replace any special characters with nothing
		str = ~/[!*'(]+/g.replace(str, "");

		return str;
	}
}
