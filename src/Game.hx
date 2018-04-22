class Game extends h2d.Layers {

	public static var ME			: Game;

	static var num					= 0;
	public static var DP_BG			= num++;
	public static var DP_LVL		= num++;
	public static var DP_FX			= num++;
	public static var DP_UI			= num++;
	public static var DP_HUD		= num++;
	public static var DP_DEBUG		= num++;

	var levels						: Array<DCDB.LvlKind>;
	var level						: Level;

	public var hud					: ui.HUD;

	var tutoText					: h2d.Text;

	// GP

	public var totalShots			: Int;

	public function new() {
		super();

		ME = this;

		var bg = new h2d.Graphics();
		bg.beginFill(0xc3c3c3);
		bg.drawRect(0, 0, Const.STG_WIDTH, Const.STG_HEIGHT);
		bg.endFill();
		this.add(bg, DP_BG);

		hud = new ui.HUD(this);
		this.add(hud, DP_HUD);

		levels = [];
		for (lvl in DCDB.lvl.all)
			if (lvl.group == DCDB.Lvl_group.Main)
				levels.push(lvl.id);
	
		#if debug
		// level = new Level(this, TestLevel);
		// level = new Level(this, Test);
		level = new Level(this, levels[levels.length - 1]);
		#else
		level = new Level(this, levels[0]);
		showTuto();
		#end
		this.add(level, DP_LVL);

		totalShots = 0;
	}

	public function showTuto() {
		tutoText = new h2d.Text(hxd.res.DefaultFont.get());
		tutoText.textAlign = Center;
		tutoText.maxWidth = Const.STG_WIDTH >> 1;
		tutoText.text = "Use your mouse to move the guinea pig in the ball!";
		tutoText.text += "\n\n" + "You can set the angle and the power of the shoot, but be careful, after every shot, your guinea pig will be a little dizzy.";
		tutoText.text += "\n\n" + "Lead him to the exit of the laboratory, and avoid the security robot, good luck!";
		tutoText.x = Std.int(tutoText.maxWidth) >> 1;
		tutoText.y = 20;
		this.add(tutoText, DP_UI);
	}

	public function resetLevel() {
		if (tutoText != null) {
			tutoText.remove();
			tutoText = null;
		}
		
		if (level != null) {
			level.destroy();
		}

		level = new Level(this, level.id);
		this.add(level, DP_LVL);
	}

	public function goToLevel(id:DCDB.LvlKind) {
		if (tutoText != null) {
			tutoText.remove();
			tutoText = null;
		}

		if (level != null) {
			level.destroy();
		}

		level = new Level(this, id);
		this.add(level, DP_LVL);
	}

	public function goToNextLevel() {
		if (level == null)
			throw "goToNextLevel : not supposed to happened here";

		totalShots += level.numShots;

		if (levels.indexOf(level.id) == levels.length - 1)
			Main.ME.showEnd(totalShots);
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
	}
}
