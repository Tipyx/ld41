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
		bg.beginFill(0x727272);
		bg.drawRect(0, 0, Const.STG_WIDTH, Const.STG_HEIGHT);
		bg.endFill();
		this.add(bg, DP_BG);

		level = new Level(this);
		this.add(level, DP_LVL);
	}

	public function onResize() {
		level.onResize();
	}

	public function destroy() {
		ME = null;

		removeChildren();
	}

	public function update(dt:Float) {
		level.update(dt);
	}
}
