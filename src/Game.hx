class Game extends h2d.Layers {

	public static var ME			: Game;

	static var num					= 0;
	public static var DP_BG			= num++;
	public static var DP_LVL		= num++;
	public static var DP_DEBUG		= num++;

	var level						: Level;

	public function new() {
		super();

		ME = this;

		var bg = new h2d.Graphics();
		bg.beginFill(0x585858);
		bg.drawRect(0, 0, Const.STG_WIDTH, Const.STG_HEIGHT);
		bg.endFill();
		this.add(bg, DP_BG);

		level = new Level(this, Test);
		this.add(level, DP_LVL);
	}

	public function resetLevel(id:Null<DCDB.LvlKind> = null) {
		if (level != null)
			level.destroy();

		level = new Level(this, id);
		this.add(level, DP_LVL);
	}

	public function onResize() {
		if (level != null)
			level.onResize();
	}

	public function destroy() {
		ME = null;

		removeChildren();
	}

	public function update(dt:Float) {
		if (level != null)
			level.update(dt);
	}
}
