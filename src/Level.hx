class Level extends h2d.Layers {

	static var num					= 0;
	public static var DP_BG			= num++;
	public static var DP_COLL		= num++;
	public static var DP_HERO		= num++;
	public static var DP_ARROW		= num++;
	public static var DP_DEBUG		= num++;

	var game						: Game;

    var hero                        : en.Hero;
	var arrow						: h2d.Graphics;

	var mouseX(get, never)			: Int;				inline function get_mouseX():Int return Std.int(hxd.Stage.getInstance().mouseX / scaleX);
	var mouseY(get, never)			: Int;				inline function get_mouseY():Int return Std.int(hxd.Stage.getInstance().mouseY / scaleY);
	
	public var ld					: LevelData;

	// GP

	var force						: Float;
	var df							: Float;
	var fInc						: Bool;
    
    public function new(game:Game) {
        super();

		this.game = game;

        this.setScale(Const.PIXEL_RATIO);

        // --------- DEBUG ---------

        ld = new LevelData(this, DCDB.LvlKind.Test);

		// Draw World
		for (x in 0...ld.wid)
			for (y in 0...ld.hei) {
				if (ld.hasColl(x, y, Hard)) {
					var gr = new h2d.Graphics();
					gr.beginFill(0x000000);
					gr.drawRect(0, 0, Const.GRID, Const.GRID);
					gr.setPos(x * Const.GRID, y * Const.GRID);
					this.add(gr, DP_COLL);
				}
			}

		// Draw Entities
        var mHero = ld.getMarker(DCDB.LevelMarkerKind.Hero);
        hero = new en.Hero(this, mHero.cx, mHero.cy);

        arrow = new h2d.Graphics();
		arrow.beginFill(0x00ff00);
		arrow.drawRect(0, -5, 50, 10);
		this.add(arrow, DP_ARROW);

		// GP
		force = 0;
		df = 0;
		fInc = true;
    }

	public function updateArrow(dt:Float) {
		if (hero.isMoving())
			return;

		df = (Const.getDataValue0(DCDB.DataKind.forceBase) + (Const.getDataValue0(DCDB.DataKind.forceDelta) * (force / 1))) * dt;
		force += df * (fInc ? 1 : -1);
		if (force >= 1 && fInc) {
			force = 1;
			fInc = false;
		}
		else if (force <=0 && !fInc) {
			force = 0;
			fInc = true;
		}

		var dist = tipyx.Lib.distance(hero.wx, hero.wy, mouseX, mouseY);
		var ang = Math.atan2(mouseY - hero.wy, mouseX - hero.wx);

		if (hxd.Key.isReleased(hxd.Key.MOUSE_LEFT))
			hero.move(ang, force);

		if (!hxd.Key.isDown(hxd.Key.MOUSE_LEFT)) {
			arrow.visible = false;
			df = 0;
			force = 0;
			return;
		}

		arrow.visible = true;
		arrow.setPos(hero.wx, hero.wy);
		arrow.scaleX = force;
		arrow.rotation = ang;

		// hero.label.text = Std.string(tipyx.Lib.prettyFloat(dist) + " " + tipyx.Lib.prettyFloat(ang));
		// hero.label.text = Std.string(tipyx.Lib.prettyFloat(force));
	}

    public function onResize() { }

    public function update(dt:Float) {
        // Controller

		updateArrow(dt);

        // Entity
        hero.update(dt);
    }
}