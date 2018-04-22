package;

/**
 * ...
 * @author Tipyx
 */
 
class LevelData
{
	var level						: Level;
	
	var lk							: DCDB.LvlKind;
	var lvlInfos					: DCDB.Lvl;
	public var wid(get, never)		: Int;					inline function get_wid() { return lvlInfos.width; }
	public var hei(get, never)		: Int;					inline function get_hei() { return lvlInfos.height; }
	
	public var colls				: Array<CollData>;
	public var markers				: Array<Marker>;

	public var pathPoints			: Array<PathPoint>;

	public function new(level:Level, lk:DCDB.LvlKind) {
		this.level = level;
		this.lk = lk;
		
		colls = [];
		markers = [];
		pathPoints = [];
		
		lvlInfos = DCDB.lvl.get(lk);
		
		for (l in lvlInfos.layers) {
			if (l.name == "col") {
				var layerData = l.data.data.decode();
				var pos = 0;
				for (c in layerData) {
					switch (c) {
						case 0 : 	// No Coll
						case 1 :	// HARD
							setColl(pos % wid, Std.int(pos / wid), Hard);
					}
					pos++;
				}
			}
			else if (l.name == "pathEnemy") {
				initPaths(l);
			}
		}
		
		for (m in lvlInfos.markers)
			markers.push({kind:m.markerId, cx:m.x, cy:m.y, customId:m.customId});
	}

	public inline function initPaths(l:DCDB.Lvl_layers) {
		var layerData = l.data.data.decode();
		var pos = 0;

		var allPaths : Array<PathPoint> = [];

		// Init Paths point
		for (c in layerData) {
			switch(c) {
				case 0		: // No Path
				case 1		: // Path
					allPaths.push(new PathPoint(pos % wid, Std.int(pos / wid)));
			}
			pos++;
		}

		if (allPaths.length == 0)
			return;

		// Set pathPoint
		function isInArray(p:PathPoint, ar:Array<PathPoint>):Bool {
			for (cp in ar) if (p == cp) return true;
			return false;
		}

		while (allPaths.length > 0) {
			var p = allPaths.pop();
			for (pc in allPaths) {
				if (p != pc && Helper.pointNextTo(p, pc)) {
					p.nextTo.push(pc);
					pc.nextTo.push(p);
				}
			}

			pathPoints.push(p);
		}
	}

	public function getPP(cx:Int, cy:Int):PathPoint {
		for (p in pathPoints)
			if (p.cx == cx && p.cy == cy)
				return p;

		return null;
	}

	public inline function setColl(x:Int, y:Int, type:CollType) {
		var col = getCollData(x, y);
		if (col == null)
			colls.push({cx:x, cy:y, ct:type});
		else
			col.ct = type;
	}
	
	public inline function removeColl(cx:Int, cy:Int) {
		for (c in colls)
			if (c.cx == cx && c.cy == cy) {
				colls.remove(c);
				break;
			}
	}
	
	public function getColl(cx:Int, cy:Int):Null<CollType> {
		for (c in colls)
			if (c.cx == cx && c.cy == cy)
				return c.ct;
				
		return null;
	}
	
	public function hasColl(cx:Int, cy:Int, ct:CollType):Bool {
		return getColl(cx, cy) == ct || cx >= wid || cx < 0 || cy >= hei || cy < 0;
	}
	
	public function getCollData(cx:Int, cy:Int):Null<CollData> {
		for (c in colls)
			if (c.cx == cx && c.cy == cy)
				return c;
				
		return null;
	}
	
	public function getMarker(id:DCDB.LevelMarkerKind, skipable:Bool = false):Null<Marker> {
		for (m in markers)
			if (m.kind == id)
				return m;
		
		if (skipable)
			return null;
		else
			throw "You forget to add the marker " + id + " in level " + lk;
	}

	public function getMarkers(id:DCDB.LevelMarkerKind):Array<Marker> {
		var out = [];

		for (m in markers)
			if (m.kind == id)
				out.push(m);

		return out;
	}
	
}