class Fx {

	var level				: Level;

	public function new(level:Level) {
		this.level = level;
	}

	var flash			: Null<ASprite>;

	public function redFlash() {
		flash = new ASprite(Const.ALIB, "ww");
		flash.color.setColor(0xFFFF0000);
		flash.alpha = 0.25;
		flash.scaleX = Const.STG_WIDTH;
		flash.scaleY = Const.STG_HEIGHT;
		Game.ME.add(flash, Game.DP_FX);
	}

	public function update(dt:Float) {
		if (flash != null) {
			flash.alpha -= 0.01 * dt;
			if (flash.alpha < 0) {
				flash.remove();
				flash = null;
			}
		}
	}
}