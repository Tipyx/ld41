package en;

class Hero extends Entity {
	
	var shadow				: ASprite;
	var spr					: ASprite;
	var dizzy				: ASprite;

	var forceMax			: Float;

	public var radius(default, null)		: Float;

    public function new(level:Level, cx:Int, cy:Int) {
		super(level, cx, cy);

		radius = Const.GRID >> 1;

		shadow = new ASprite(Const.ALIB, "shadow");
		shadow.setCenterRatio(0.5, 0);
		shadow.alpha = 0.5;
        level.add(shadow, Level.DP_HERO);

		spr = new ASprite(Const.ALIB, "hero");
		spr.setCenterRatio(0.5, 0.5);
		spr.play("hero", -1);
		spr.speed = 10;
        level.add(spr, Level.DP_HERO);

		dizzy = new ASprite(Const.ALIB, "dizzy");
		dizzy.setCenterRatio(0.5, 0.5);
        level.add(dizzy, Level.DP_HERO);

		forceMax = Const.getDataValue0(DCDB.DataKind.forceMax);
    }

	public inline function disappear() {
		shadow.visible = false;
		level.tweener.create(Const.FPS * 0.5, spr.alpha, 0);
	}

	public inline function isTooFast() {
		return Math.abs(dx) > 0.12 || Math.abs(dy) > 0.12;
	}

	public inline function isMoving():Bool return dx != 0 || dy != 0;

	public function stopMove() {
		dx = dy = 0;
	}

	public function move(ang:Float, force:Float) {
		dx = Math.cos(ang) * force * forceMax;
		dy = Math.sin(ang) * force * forceMax;
	}

	override public function destroy() {
		super.destroy();

		spr.remove();
		shadow.remove();
	}

    override public function update(dt:Float) {
		super.update(dt);

		// Render
        dizzy.setPos(wx, wy - Const.GRID);
		dizzy.rotation -= 0.1 * dt;
		dizzy.visible = isMoving();

        shadow.setPos(wx, wy);
        spr.setPos(wx, wy);

		if (isMoving())
			spr.rotation = Math.atan2(dy, dx) + Math.PI / 2;
		spr.speed = (Math.abs(dx) + Math.abs(dy)) * 100;

		// setLabel(Lib.prettyFloat(dx) + " " + Lib.prettyFloat(dy));

    }
}