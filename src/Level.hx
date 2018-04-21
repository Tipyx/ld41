class Level extends h2d.Layers {

	static var num					= 0;
	public static var DP_BG			= num++;
	public static var DP_HERO		= num++;
	public static var DP_ARROW		= num++;
	public static var DP_DEBUG		= num++;

    var hero                        : en.Hero;
	var arrow						: h2d.Graphics;

	var mouseX(get, never)			: Int;				inline function get_mouseX():Int return Std.int(hxd.Stage.getInstance().mouseX / scaleX);
	var mouseY(get, never)			: Int;				inline function get_mouseY():Int return Std.int(hxd.Stage.getInstance().mouseY / scaleY);
	
	public var ld					: LevelData;
    
    public function new() {
        super();

        this.setScale(Const.PIXEL_RATIO);

        // --------- DEBUG ---------

        ld = new LevelData(this, DCDB.LvlKind.Test);

        var mHero = ld.getMarker(DCDB.LevelMarkerKind.Hero);
        hero = new en.Hero(this, mHero.cx, mHero.cy);

        arrow = new h2d.Graphics();
		this.add(arrow, DP_ARROW);
    }

	public function updateArrow() {
		var dist = tipyx.Lib.distance(hero.wx, hero.wy, mouseX, mouseY);
		var ang = Math.atan2(mouseY - hero.wy, mouseX - hero.wx);

		if (hxd.Key.isReleased(hxd.Key.MOUSE_LEFT))
			hero.move(ang, 1);

		if (!hxd.Key.isDown(hxd.Key.MOUSE_LEFT)) {
			arrow.visible = false;
			return;
		}

		arrow.visible = true;
		arrow.clear();
		arrow.lineStyle(5, 0x00ff00);
		arrow.moveTo(hero.wx, hero.wy);
		arrow.lineTo(mouseX, mouseY);

		// hero.label.text = Std.string(tipyx.Lib.prettyFloat(dist) + " " + tipyx.Lib.prettyFloat(ang));
	}

    public function onResize() { }

    public function update(dt:Float) {
        // Controller

		updateArrow();

        // Entity
        hero.update(dt);
    }
}