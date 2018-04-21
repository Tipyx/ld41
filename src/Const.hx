class Const {

	public static var STG_WIDTH			: Int;
	public static var STG_HEIGHT		: Int;

	public static var PIXEL_RATIO			: Int;

	public static function INIT() {
		PIXEL_RATIO = 2;
		
		RESIZE();
	}
	
	public static function RESIZE() {
		STG_WIDTH = Main.ME.engine.width;
		STG_HEIGHT = Main.ME.engine.height;
	}
}
