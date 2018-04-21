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

	public function new(level:Level, lk:DCDB.LvlKind) {
		this.level = level;
		this.lk = lk;
		
		colls = [];
		markers = [];
		
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
		}
		
		for (m in lvlInfos.markers)
			markers.push({kind:m.markerId, cx:m.x, cy:m.y});
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
	
	public function hasColl(cx:Int, cy:Int, ct:CollType):Bool return getColl(cx, cy) == ct;
	
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
	
}