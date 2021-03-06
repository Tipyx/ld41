package en;

class Exit extends Entity {

	var spr						: ASprite;

	public function new(level:Level, cx:Int, cy:Int) {
		super(level, cx, cy);
		
		spr = new ASprite(Const.ALIB, "exit");
		spr.setCenterRatio(0.5, 0.5);
		level.add(spr, Level.DP_EXIT);
	}

	override public function destroy() {
		super.destroy();

		spr.remove();
	}

	override public function update(dt:Float) {
		super.update(dt);

		spr.setPos(wx, wy);

		var ang = Helper.angBetweenEnt(level.hero, this);
		var dist =Helper.distBetweenEnt(level.hero, this);
		@:privateAccess level.hero.dx += (Math.cos(ang) / 100) * dt * (dist < 8 ? dist / 8 : 0);
		@:privateAccess level.hero.dy += (Math.sin(ang) / 100) * dt * (dist < 8 ? dist / 8 : 0);
	}

}