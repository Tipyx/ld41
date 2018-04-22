package en;

class Enemy extends Entity {

    var spr					: ASprite;
    var light               : h2d.Graphics;

	var destPP				: PathPoint;
	var prevPP				: PathPoint;

	var ang					: Float;
	var radius				: Float;

	var sightDistance		: Float;
	var lAng				: Float;

	public function new(level:Level, cx:Int, cy:Int, ?dir:Null<String>) {
		super(level, cx, cy);

		radius = Const.GRID >> 1;

		spr = new ASprite(Const.ALIB, "foe");
		spr.setCenterRatio(0.5, 0.5);
        level.add(spr, Level.DP_ENM);

		level.enemies.push(this);

		prevPP = null;
		if (dir != null)
			getFirstDestPP(dir)
		else
			destPP = level.ld.getPP(cx, cy);

		ang = Math.atan2(destPP.wy - wy, destPP.wx - wx);

		light = new h2d.Graphics();
		level.add(light, Level.DP_ENM);

		sightDistance = Const.getDataValue0(sighDistanceEnemy);

		lAng = Math.PI / 10;

		light.beginFill(0xf7f8b8, 0.4);
		light.moveTo(0, 0);
		light.lineTo(Math.cos(lAng) * sightDistance, Math.sin(lAng) * sightDistance);
		light.lineTo(Math.cos(lAng) * sightDistance, -Math.sin(lAng) * sightDistance);
	}

	function getFirstDestPP(dir:String) {
		prevPP = level.ld.getPP(cx, cy);
		destPP = switch (dir) {
			case "left"		: level.ld.getPP(cx - 1, cy);
			case "right"	: level.ld.getPP(cx + 1, cy);
			case "top"		: level.ld.getPP(cx, cy - 1);
			case "bot"		: level.ld.getPP(cx, cy + 1);
			default			: throw dir + " is not handled as a first direction";
		}
	}

	inline function angToHero() return Math.atan2(level.hero.wy - wy, level.hero.wx - wx);

	function heroIsVisible():Bool {
		return (Math.abs(Lib.angularDist(angToHero(), ang)) < lAng && Lib.distance(wx, wy, level.hero.wx, level.hero.wy) <= sightDistance)
		||		Lib.distance(wx, wy, level.hero.wx, level.hero.wy) <= radius + level.hero.radius;
	}

	function changeLightColor() {
		light.clear();

		light.beginFill(0xe64545, 0.4);
		light.moveTo(0, 0);
		light.lineTo(Math.cos(lAng) * sightDistance, Math.sin(lAng) * sightDistance);
		light.lineTo(Math.cos(lAng) * sightDistance, -Math.sin(lAng) * sightDistance);
	}

	override public function destroy() {
		super.destroy();

		spr.remove();
		light.remove();
	}

	override public function update(dt:Float) {
		if (!level.isCaught) {
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
		}
		else {
			ang += (Lib.angularDist(Math.atan2(level.hero.wy - wy, level.hero.wx - wx), ang) / Const.getDataValue0(speedAngEnemy)) * dt;
		}

		super.update(dt);

		if (!level.isCaught && heroIsVisible()) {
			changeLightColor();
			level.onCaught();
		}

		// RENDER

		spr.setPos(wx, wy);
		// spr.rotation = ang;

		light.setPos(wx, wy);
		light.rotation = ang;
	}
}