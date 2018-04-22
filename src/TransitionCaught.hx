class TransitionCaught extends h2d.Sprite {

	var mask					: ASprite;

	var inc						: Bool;
	var isStopped				: Bool;

	var cb						: Void->Void;

	var alphaSpeed				: Float;

	public function new(cb:Void->Void) {
		super();

		this.cb = cb;

		inc = true;
		isStopped = true;
		
		mask = new ASprite(Const.ALIB, "ww");
		mask.color.setColor(0xFF000000);
		mask.alpha = 0;
		mask.scaleX = Const.STG_WIDTH;
		mask.scaleY = Const.STG_HEIGHT;
		this.addChild(mask);
	}

	public function init() {
		mask.alpha = 0;
		inc = true;
		isStopped = false;

		alphaSpeed = Const.getDataValue0(alphaSpeedTCaught);
	}

	public function update(dt:Float) {
		mask.visible = !isStopped;
		if (isStopped)
			return;

		if (inc) {
			mask.alpha += alphaSpeed * dt;
			if (mask.alpha >= 1) {
				mask.alpha = 1;
				inc = false;
				cb();
			}
		}
		else {
			mask.alpha -= alphaSpeed * dt;
			if (mask.alpha <= 0)
				isStopped = true;
		}
	}
}