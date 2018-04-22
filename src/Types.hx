package;

/**
 * ...
 * @author Tipyx
 */

enum CollType {
	Hard;
}

typedef CollData = {
	var cx		: Int;
	var cy		: Int;
	var ct		: CollType;
}

typedef Marker = {
	var kind		: DCDB.LevelMarkerKind;
	var cx			: Int;
	var cy			: Int;
	var customId	: Null<String>;
}

class PathPoint {
	public var cx		: Int;
	public var cy		: Int;
	public var nextTo	: Array<PathPoint>;

	public var wx(get, never)		: Int;				inline function get_wx() return Std.int((cx + 0.5) * Const.GRID);
	public var wy(get, never)		: Int;				inline function get_wy() return Std.int((cy + 0.5) * Const.GRID);

	public function new(cx:Int, cy:Int) {
		this.cx = cx;
		this.cy = cy;

		nextTo = [];
	}

	public function toString() return cx + " " + cy;
}
 
class Types
{
	
}