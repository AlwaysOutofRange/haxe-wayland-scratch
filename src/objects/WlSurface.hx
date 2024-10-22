package objects;

import messages.CommitMessage;
import messages.AttachMessage;
import messages.DamageMessage;
import messages.HeaderLE;
import constants.OpCode;
import constants.ObjectID;
import cpp.Stdlib;

class WlSurface extends Object {
	public function new(socket:WaylandSocket, id:Int) {
		super(socket, id);
	}

	public function commit():Void {
		var msg = new CommitMessage(new HeaderLE(cast(ObjectID.WL_SURFACE, Int), cast(OpCode.COMMIT, Int), Stdlib.sizeof(CommitMessage)));

		socket.write(msg.toBytes());
	}

	public function attach(x:Int, y:Int):Void {
		var msg = new AttachMessage(new HeaderLE(cast(ObjectID.WL_SURFACE, Int), cast(OpCode.ATTACH, Int), Stdlib.sizeof(AttachMessage)), x, y);

		socket.write(msg.toBytes());
	}

	public function damage(x:Int, y:Int, width:Int, height:Int):Void {
		var msg = new DamageMessage(new HeaderLE(cast(ObjectID.WL_SURFACE, Int), cast(OpCode.DAMAGE, Int), Stdlib.sizeof(DamageMessage)), x, y, width, height);

		socket.write(msg.toBytes());
	}
}
