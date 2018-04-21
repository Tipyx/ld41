class Const {

	public static var STG_WIDTH			: Int;
	public static var STG_HEIGHT		: Int;

	public static var PIXEL_RATIO		: Int;

	public static var GRID				: Int;	

	public static function INIT() {
		RESIZE();
	}

	public static function getDataValue0(id:DCDB.DataKind) {
		return DCDB.data.get(id).v0;
	}
	
	public static function RESIZE() {
		STG_WIDTH = Main.ME.engine.width;
		STG_HEIGHT = Main.ME.engine.height;

		PIXEL_RATIO = Std.int(getDataValue0(DCDB.DataKind.pixelScale));
		GRID = Std.int(getDataValue0(DCDB.DataKind.grid));
	}
}
