package en;

class Enemy extends Entity {

    var dbgGr               : h2d.Graphics;
    var light               : h2d.Graphics;

	var destPP				: PathPoint;
	var prevPP				: PathPoint;

	var ang					: Float;

	var sightDistance		: Float;
	var lAng				: Float;

	public function new(level:Level, cx:Int, cy:Int) {
		super(level, cx, cy);

        dbgGr = new h2d.Graphics();
        dbgGr.beginFill(0xd3302c);
        dbgGr.drawCircle(0, 0, Const.GRID >> 1);
        level.add(dbgGr, Level.DP_HERO);

		level.enemies.push(this);

		prevPP = null;
		destPP = level.ld.getPP(cx, cy);

		ang = Math.atan2(destPP.wy - wy, destPP.wx - wx);

		light = new h2d.Graphics();
		level.add(light, Level.DP_ENM);

		sightDistance = Const.getDataValue0(sighDistanceEnemy);

		lAng = Math.PI / 10;

		light.beginFill(0xf7f8b8, 0.1);
		light.moveTo(0, 0);
		light.lineTo(Math.cos(lAng) * sightDistance, Math.sin(lAng) * sightDistance);
		light.lineTo(Math.cos(lAng) * sightDistance, -Math.sin(lAng) * sightDistance);
	}

	inline function angToHero() return Math.atan2(level.hero.wy - wy, level.hero.wx - wx);

	function heroIsVisible():Bool {
		return Math.abs(Lib.angularDist(angToHero(), ang)) < lAng && Lib.distance(wx, wy, level.hero.wx, level.hero.wy) <= sightDistance;
	}

	override public function update(dt:Float) {
		if (Lib.distance(wx, wy, destPP.wx, destPP.wy) < 5 && level.ld.getPP(cx, cy) == destPP) {
			for (np in destPP.nextTo)
				if (np != prevPP || destPP.nextTo.length == 1) {
					if (destPP.nextTo.length == 1)
						cd.setS("lockAI", Const.getDataValue0(lockAIEnemy));
					prevPP = destPP;
					destPP = np;
					break;
				}
		}
		else if (!cd.has("lockAI")) {
			// ang += Lib.normalizeAng((Lib.normalizeAng(Math.atan2(destPP.wy - wy, destPP.wx - wx)) - Lib.normalizeAng(ang))) / 10;
			ang += (Lib.angularDist(Math.atan2(destPP.wy - wy, destPP.wx - wx), ang) / Const.getDataValue0(speedAngEnemy)) * dt;
			dx = Const.getDataValue0(DCDB.DataKind.speedEnemy) * Math.cos(ang);
			dy = Const.getDataValue0(DCDB.DataKind.speedEnemy) * Math.sin(ang);
		}

		super.update(dt);

		if (heroIsVisible())
			Game.ME.resetLevel();

		// RENDER

		dbgGr.setPos(wx, wy);
		dbgGr.rotation = ang;

		light.setPos(wx, wy);
		light.rotation = ang;
	}
}