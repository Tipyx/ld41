@:allow(DebugInfo)
class Main extends hxd.App {

	public static var ME		: Main;

	var game			: Game;
	public var console	: h2d.Console;
	

	var dbgInfo			: DebugInfo;

	override function init() {
		super.init();
		
		ME = this;
		Const.INIT();

		wantedFPS = 60;
		
		console = new h2d.Console(hxd.res.DefaultFont.get());
		// console =  new h2d.Console(Assets.ME.dbgFont);
		s2d.add(console, 999);
		
		haxe.Log.trace = function(v, ?i) console.log(v);

		hxd.Res.data.watch(function() {
			DCDB.load(hxd.Res.data.entry.getBytes().toString());
			console.log("Cdb reloaded !");

			newGame();
		});

		#if hl
			#if debug
			hxd.res.Resource.LIVE_UPDATE = true;
			trace("hl + debug");
			#else
			trace("hl + release");
			#end
		#end

		dbgInfo = new DebugInfo();
		#if debug
		s2d.add(dbgInfo, 99);
		#end

		newGame();
	}

	function newGame() {
		if (game != null)
			game.destroy();

		game = new Game();
		s2d.addChild(game);
	}

	override function onResize() {
		super.onResize();

		game.onResize();
	}
	
	var slowMo			: Bool;
	var megaSlowMo		: Bool;

	override public function update(dt:Float) {
		super.update(dt);

		#if debug
		if (hxd.Key.isPressed(hxd.Key.NUMPAD_SUB))
			slowMo = !slowMo;
		if (hxd.Key.isPressed(hxd.Key.NUMPAD_MULT))
			megaSlowMo = !megaSlowMo;
		
		if (hxd.Key.isPressed(hxd.Key.ESCAPE))
			newGame();
		#end
		
		if (game != null)
			game.update(dt * (megaSlowMo ? 0.1 : slowMo ? 0.5 : 1));

		dbgInfo.update(dt);
		dbgInfo.x = Const.STG_WIDTH - dbgInfo.outerWidth;
	}

	static function main() {
		#if hl
		hxd.Res.initLocal();
		#else
		hxd.Res.initEmbed();
		#end

		DCDB.load(hxd.Res.data.entry.getBytes().toString());

		new Main();
	}
}
