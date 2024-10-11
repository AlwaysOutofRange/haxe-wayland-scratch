package utils;

class HeaderLE {
	public var id:Int;
	public var op:Int;
	public var size:Int;

	public function new(id:Int, op:Int, size:Int) {
		this.id = id;
		this.op = op;
		this.size = size;
	}
}
