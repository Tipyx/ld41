package;

/**
 * ...
 * @author Tipyx
 */

enum CollType {
	Hard;
}

typedef CollData = {
	var cx		: Int;
	var cy		: Int;
	var ct		: CollType;
}

typedef Marker = {
	var kind	: DCDB.LevelMarkerKind;
	var cx		: Int;
	var cy		: Int;
}
 
class Types
{
	
}