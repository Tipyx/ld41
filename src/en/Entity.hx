package en;

class Entity {
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

	// Various

	var cd					: Cooldown;

	public var label		: h2d.Text;

	public function new(level:Level, cx:Int, cy:Int) {
        this.level = level;

        this.cx = cx;
        this.cy = cy;

        rx = ry = 0.5;
        dx = dy = 0;

		label = new h2d.Text(hxd.res.DefaultFont.get());
		label.textAlign = Center;
		#if debug
		Game.ME.add(label, Level.DP_DEBUG);
		#end

		cd = new Cooldown();
	}

	public inline function setLabel(d:Dynamic) {
		label.text = Std.string(d);
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
		cd.update(dt);

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
		
		label.setPos(globalX, globalY);
	 }
}