class Helper {

	public static function pointNextTo(p1:PathPoint, p2:PathPoint) {
		return	(p1.cx == p2.cx && p1.cy == p2.cy + 1)
		||		(p1.cx == p2.cx && p1.cy == p2.cy - 1)
		||		(p1.cx == p2.cx - 1 && p1.cy == p2.cy)
		||		(p1.cx == p2.cx + 1 && p1.cy == p2.cy);
	}

	public static function distBetweenEnt(e1:en.Entity, e2:en.Entity) {
		return Lib.distance(e1.wx, e1.wy, e2.wx, e2.wy);
	}

	public static function angBetweenEnt(e1:en.Entity, e2:en.Entity) {
		return Math.atan2(e2.wy - e1.wy, e2.wx - e1.wx);
	}
}