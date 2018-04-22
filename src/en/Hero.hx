package en;

class Hero extends Entity {
	
	var spr					: ASprite;
	var lockSpr				: ASprite;

	var forceMax			: Float;

	public var radius(default, null)		: Float;

    public function new(level:Level, cx:Int, cy:Int) {
		super(level, cx, cy);

		radius = Const.GRID >> 1;

		spr = new ASprite(Const.ALIB, "hero");
		spr.setCenterRatio(0.5, 0.5);
		spr.play("hero", -1);
		spr.speed = 10;
        level.add(spr, Level.DP_HERO);

		lockSpr = new ASprite(Const.ALIB, "lock");
		lockSpr.setCenterRatio(0.5, 0.5);
        level.add(lockSpr, Level.DP_HERO);

		forceMax = Const.getDataValue0(DCDB.DataKind.forceMax);
    }

	public inline function isMoving():Bool return dx != 0 || dy != 0;

	public function stopMove() {
		dx = dy = 0;
	}

	public function move(ang:Float, force:Float) {
		dx = Math.cos(ang) * force * forceMax;
		dy = Math.sin(ang) * force * forceMax;
	}

    override public function update(dt:Float) {
		super.update(dt);

		// Render
        lockSpr.setPos(wx, wy);
		lockSpr.visible = isMoving();

        spr.setPos(wx, wy);

		if (isMoving())
			spr.rotation = Math.atan2(dy, dx) + Math.PI / 2;
		spr.speed = (Math.abs(dx) + Math.abs(dy)) * 100;
		// setLabel(Lib.prettyFloat(spr.speed));

    }
}