class Main extends hxd.App {

	public static var ME		: Main;

	var game			: Game;
	public var console	: h2d.Console;

	override function init() {
		super.init();
		
		ME = this;
		Const.INIT();
		
		console = new h2d.Console(hxd.res.DefaultFont.get());
		// console =  new h2d.Console(Assets.ME.dbgFont);
		s2d.add(console, 999);
		
		haxe.Log.trace = function(v, ?i) console.log(v);

		hxd.Res.data.watch(function() {
			DCDB.load(hxd.Res.data.entry.getBytes().toString());
			console.log("Cdb reloaded !");
		});
		#if hl
			#if debug
			hxd.res.Resource.LIVE_UPDATE = true;
			trace("hl + debug");
			#else
			trace("hl + release");
			#end
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

	override public function update(dt:Float) {
		super.update(dt);

		#if debug
		if (hxd.Key.isPressed(hxd.Key.R))
			newGame();
		#end

		game.update(dt);
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
