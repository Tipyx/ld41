package en;

class Hero extends Entity {
	
    var dbgGr               : h2d.Graphics;

	var forceMax			: Float;

	public var radius(default, null)		: Float;

    public function new(level:Level, cx:Int, cy:Int) {
		super(level, cx, cy);

		radius = Const.GRID >> 1;

        dbgGr = new h2d.Graphics();
        dbgGr.beginFill(0x21ccda);
        dbgGr.drawCircle(0, 0, radius);
        level.add(dbgGr, Level.DP_HERO);

		forceMax = Const.getDataValue0(DCDB.DataKind.forceMax);
    }

	public inline function isMoving():Bool return dx != 0 || dy != 0;

	public function move(ang:Float, force:Float) {
		dx = Math.cos(ang) * force * forceMax;
		dy = Math.sin(ang) * force * forceMax;
	}

    override public function update(dt:Float) {
		super.update(dt);

		// Render
        dbgGr.setPos(wx, wy);
    }
}