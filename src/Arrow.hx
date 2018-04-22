class Arrow extends h2d.Sprite {

	var level				: Level;

	var outline				: ASprite;

	var mask				: h2d.CachedBitmap;
	var maxWidMask			: Int;
	var gauge				: ASprite;

	public function new(level:Level) {
		super();

		this.level = level;

		outline = new ASprite(Const.ALIB, "arrowOutline", this);
		outline.setCenterRatio(0, 0.5);

		maxWidMask = outline.tile.width;

		mask = new h2d.CachedBitmap(this, maxWidMask, maxWidMask);
		mask.y = - outline.tile.height >> 1;

		gauge = new ASprite(Const.ALIB, "arrowGauge", mask);
	}

	public function updateGauge(force:Float) {
		// gauge.scaleX = force;
		mask.width = Std.int(force * maxWidMask);
	}
}