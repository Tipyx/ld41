class Helper {

	public static function pointNextTo(p1:PathPoint, p2:PathPoint) {
		return	(p1.cx == p2.cx && p1.cy == p2.cy + 1)
		||		(p1.cx == p2.cx && p1.cy == p2.cy - 1)
		||		(p1.cx == p2.cx - 1 && p1.cy == p2.cy)
		||		(p1.cx == p2.cx + 1 && p1.cy == p2.cy);
	}

}