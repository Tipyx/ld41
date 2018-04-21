package en;

class Hero {

    var level           : Level;

    // ------------ PHYSIX ------------
	
	public var cx			: Int;
	public var cy			: Int;
	
	public var rx			: Float;
	public var ry			: Float;
	
	public var wx(get, never) 	: Float;
	public var wy(get, never)	: Float;
	
	inline function get_wx() return (cx + rx) * Const.GRID;
	inline function get_wy() return (cy + ry) * Const.GRID;
	
	public var width		: Int;
	public var height		: Int;
	
	public var globalX(get, never)		: Int;
	public var globalY(get, never)		: Int;
	
	inline function get_globalX():Int return Std.int(this.wx * level.scaleX + level.x);
	inline function get_globalY():Int return Std.int((this.wy - Const.GRID * 0.5) * level.scaleY + level.y);
	
	var dx					: Float;
	var dy					: Float;
	
	// public var hasPhysix	: Bool;

    // ------------ Others ------------

	public var label		: h2d.Text;

    var dbgGr               : h2d.Graphics;

    public function new(level:Level, cx:Int, cy:Int) {
        this.level = level;

        this.cx = cx;
        this.cy = cy;

        rx = ry = 0.5;
        dx = dy = 0;

		// DBG

        dbgGr = new h2d.Graphics();
        dbgGr.beginFill(0x21ccda);
        dbgGr.drawCircle(0, 0, 10);
        level.add(dbgGr, Level.DP_HERO);

		label = new h2d.Text(hxd.res.DefaultFont.get());
		label.textAlign = Center;
		Game.ME.add(label, Level.DP_DEBUG);
    }

	public function move(ang:Float, force:Float) {
		dx = Math.cos(ang);
		dy = Math.sin(ang);

		trace(ang + " " + dx + " " + dy);
	}

    public function update(dt:Float) {
		// Physix

		{	// X
			rx += dx * dt;
			
			while (rx >= 1) {
				rx -= 1;
				cx += 1;
			}
			while (rx < 0) {
				rx += 1;
				cx -= 1;
			}
		}
		// Physix

		{	// Y
			ry += dy * dt;
			
			while (ry >= 1) {
				ry -= 1;
				cy += 1;
			}
			while (ry < 0) {
				ry += 1;
				cy -= 1;
			}
		}

		dx *= Math.pow(Const.getDataValue0(DCDB.DataKind.frict), dt);
		dy *= Math.pow(Const.getDataValue0(DCDB.DataKind.frict), dt);

		// Render
        dbgGr.setPos(wx, wy);

		label.setPos(globalX, globalY);
    }
}