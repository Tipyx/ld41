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

	var forceMax			: Float;

    public function new(level:Level, cx:Int, cy:Int) {
        this.level = level;

        this.cx = cx;
        this.cy = cy;

        rx = ry = 0.5;
        dx = dy = 0;

        dbgGr = new h2d.Graphics();
        dbgGr.beginFill(0x21ccda);
        dbgGr.drawCircle(0, 0, Const.GRID >> 1);
        level.add(dbgGr, Level.DP_HERO);

		label = new h2d.Text(hxd.res.DefaultFont.get());
		label.textAlign = Center;
		#if debug
		Game.ME.add(label, Level.DP_DEBUG);
		#end

		forceMax = Const.getDataValue0(DCDB.DataKind.forceMax);
    }

	public inline function setLabel(d:Dynamic) {
		label.text = Std.string(d);
	}

	public inline function isMoving():Bool return dx != 0 || dy != 0;

	public function move(ang:Float, force:Float) {
		dx = Math.cos(ang) * force * forceMax;
		dy = Math.sin(ang) * force * forceMax;

		// trace(ang + " " + dx + " " + dy);
	}

	inline function checkLeftCollision():Bool {
		return dx < 0 && rx < 0.5 && level.ld.hasColl(cx - 1, cy, Hard);
	}

	inline function checkRightCollision():Bool {
		return dx > 0 && rx > 0.5 && level.ld.hasColl(cx + 1, cy, Hard);
	}

	inline function checkTopCollision():Bool {
		return dy < 0 && ry < 0.5 && level.ld.hasColl(cx, cy - 1, Hard);
	}

	inline function checkBotCollision():Bool {
		return dy > 0 && ry > 0.5 && level.ld.hasColl(cx, cy + 1, Hard);
	}

    public function update(dt:Float) {
		// Physix

		{	// X
			rx += dx * dt;

			if (checkLeftCollision() || checkRightCollision())
				dx = -dx;
			
			while (rx >= 1) {
				rx -= 1;
				cx += 1;
			}
			while (rx < 0) {
				rx += 1;
				cx -= 1;
			}
		}

		{	// Y
			ry += dy * dt;

			if (checkTopCollision() || checkBotCollision())
				dy = -dy;
			
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
			
		if (dx > -Const.getDataValue0(minD) * dt && dx < Const.getDataValue0(minD) * dt
		&&	dy > -Const.getDataValue0(minD) * dt && dy < Const.getDataValue0(minD) * dt)
			dx = dy = 0;

		// Render
        dbgGr.setPos(wx, wy);

		label.setPos(globalX, globalY);

		// setLabel(tipyx.Lib.prettyFloat(dx, 3) + " " + tipyx.Lib.prettyFloat(dy, 3));
		// setLabel(dx + " " + dy);
    }
}