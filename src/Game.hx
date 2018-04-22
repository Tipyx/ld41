class Game extends h2d.Layers {

	public static var ME			: Game;

	static var num					= 0;
	public static var DP_BG			= num++;
	public static var DP_LVL		= num++;
	public static var DP_FX			= num++;
	public static var DP_TRNS		= num++;
	public static var DP_DEBUG		= num++;

	var levels						: Array<DCDB.LvlKind>;
	var level						: Level;

	public var tCaught				: TransitionCaught;

	public function new() {
		super();

		ME = this;

		var bg = new h2d.Graphics();
		bg.beginFill(0xb1b9be);
		bg.drawRect(0, 0, Const.STG_WIDTH, Const.STG_HEIGHT);
		bg.endFill();
		this.add(bg, DP_BG);

		levels = [];
		for (lvl in DCDB.lvl.all)
			if (lvl.group == DCDB.Lvl_group.Main)
				levels.push(lvl.id);
	
		#if debug
		// level = new Level(this, TestLevel);
		level = new Level(this, Test);
		#else
		level = new Level(this, levels[0]);
		#end
		this.add(level, DP_LVL);

		tCaught = new TransitionCaught(resetLevel);
		this.add(tCaught, DP_TRNS);
	}

	public function resetLevel() {
		if (level != null) {
			level.destroy();
			removeChild(level);
		}

		level = new Level(this, level.id);
		this.add(level, DP_LVL);
	}

	public function goToLevel(id:DCDB.LvlKind) {
		if (level != null) {
			level.destroy();
			removeChild(level);
		}

		level = new Level(this, id);
		this.add(level, DP_LVL);
	}

	public function goToNextLevel() {
		if (level == null)
			throw "goToNextLevel : not supposed to happened here";

		if (levels.indexOf(level.id) == levels.length - 1)
			throw "TODO : reach last level";
		else
			goToLevel(levels[levels.indexOf(level.id) + 1]);
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

		tCaught.update(dt);
	}
}
