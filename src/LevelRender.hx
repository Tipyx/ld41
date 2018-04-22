class LevelRender {

	var level			: Level;

	public function new(level:Level) {
		this.level = level;
	}

	public function init() {
		var tg = new h2d.TileGroup(Const.ALIB.tile);
		level.add(tg, Level.DP_COLL);

		for (y in 0...level.ld.hei)
			for (x in 0...level.ld.wid) {
				if (level.ld.hasColl(x, y, Hard)) {
					var tile : h2d.Tile = null;
					if (checkCollAround(x, y, true, true, true, true))
						tile = Const.ALIB.getTile("wall", 0);
					else if (checkCollAround(x, y, true, false, true, true))
						tile = Const.ALIB.getTile("wall", 1);
					else if (checkCollAround(x, y, false, true, true, true))
						tile = Const.ALIB.getTile("wall", 2);
					else if (checkCollAround(x, y, true, true, false, true))
						tile = Const.ALIB.getTile("wall", 3);
					else if (checkCollAround(x, y, true, false, false, true))
						tile = Const.ALIB.getTile("wall", 4);
					else if (checkCollAround(x, y, false, true, false, true))
						tile = Const.ALIB.getTile("wall", 5);
					else if (checkCollAround(x, y, true, true, true, false))
						tile = Const.ALIB.getTile("bigWall", 0);
					else if (checkCollAround(x, y, true, false, true, false))
						tile = Const.ALIB.getTile("bigWall", 1);
					else if (checkCollAround(x, y, false, true, true, false))
						tile = Const.ALIB.getTile("bigWall", 2);
					else {
						var gr = new h2d.Graphics();
						gr.beginFill(0xFF00FF);
						gr.drawRect(0, 0, Const.GRID, Const.GRID);
						gr.setPos(x * Const.GRID, y * Const.GRID);
						level.add(gr, Level.DP_COLL);
					}
					if (tile != null)
						tg.add(x * Const.GRID, y * Const.GRID - tile.height + Const.GRID, tile);
				}
			}

		// Add Missing Corner
		var tileCorner = Const.ALIB.getTile("corner");
		var tileSide = Const.ALIB.getTile("side");
		for (y in 0...level.ld.hei)
			for (x in 0...level.ld.wid) {
				if (needCornerBotRight(x, y)) {
					tg.add((x + 1) * Const.GRID - tileSide.width, (y + 1) * Const.GRID - tileSide.height, tileSide);
					tg.add((x + 1) * Const.GRID - tileCorner.width, (y + 1) * Const.GRID - tileCorner.height, tileCorner);
				}
				else if (needCornerBotLeft(x, y)) {
					tg.add(x * Const.GRID, (y + 1) * Const.GRID - tileSide.height, tileSide);
					tg.add(x * Const.GRID, (y + 1) * Const.GRID - tileCorner.height, tileCorner);
				}
				else if (needCornerTopRight(x, y))
					tg.add((x + 1) * Const.GRID - tileCorner.width, y * Const.GRID, tileCorner);
				else if (needCornerTopLeft(x, y))
					tg.add(x * Const.GRID, y * Const.GRID, tileCorner);
			}
	}

	public function checkCollAround(x:Int, y:Int, left:Bool, right:Bool, top:Bool, bot:Bool):Bool {
		return	level.ld.hasColl(x - 1, y, Hard) == left
		&&		level.ld.hasColl(x + 1, y, Hard) == right
		&&		level.ld.hasColl(x, y - 1, Hard) == top
		&&		level.ld.hasColl(x, y + 1, Hard) == bot;
	}

	public function needCornerBotRight(x:Int, y:Int) {
		return	level.ld.hasColl(x + 1, y, Hard)
		&&		level.ld.hasColl(x, y + 1, Hard)
		&&		!level.ld.hasColl(x + 1, y + 1, Hard);
	}

	public function needCornerBotLeft(x:Int, y:Int) {
		return	level.ld.hasColl(x - 1, y, Hard)
		&&		level.ld.hasColl(x, y + 1, Hard)
		&&		!level.ld.hasColl(x - 1, y + 1, Hard);
	}

	public function needCornerTopRight(x:Int, y:Int) {
		return	level.ld.hasColl(x + 1, y, Hard)
		&&		level.ld.hasColl(x, y - 1, Hard)
		&&		!level.ld.hasColl(x + 1, y - 1, Hard);
	}

	public function needCornerTopLeft(x:Int, y:Int) {
		return	level.ld.hasColl(x - 1, y, Hard)
		&&		level.ld.hasColl(x, y - 1, Hard)
		&&		!level.ld.hasColl(x - 1, y - 1, Hard);
	}

}