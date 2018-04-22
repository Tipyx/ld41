import h2d.Console;


@:allow(DebugInfo)
class Main extends hxd.App {

	static var num					= 0;
	public static var DP_GAME		= num++;
	public static var DP_UI			= num++;
	public static var DP_TRANSITION	= num++;
	public static var DP_DEBUG		= num++;
	public static var DP_CONSOLE	= num++;

	public static var ME		: Main;

	var game			: Game;
	public var console	: h2d.Console;

	var end				: ui.End;
	var title			: ui.Title;
	
	var dbgInfo			: DebugInfo;

	public var transition	: Transition;

	override function init() {
		super.init();
		
		ME = this;
		Const.INIT();

		wantedFPS = Const.FPS;
		
		console = new h2d.Console(hxd.res.DefaultFont.get());
		// console =  new h2d.Console(Assets.ME.dbgFont);
		console.addCommand("level", "go to Level XXX", [{name:"ID", t:AString}], function(t:String) {
			for (l in DCDB.lvl.all)
				if (l.id.toString() == t) {
					game.goToLevel(l.id);
					return;
				}

			throw "Wrong Level Id";
		});
		s2d.add(console, DP_CONSOLE);
		haxe.Log.trace = function(v, ?i) console.log(i.className + "@" + i.lineNumber + " : " + v);

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
		s2d.add(dbgInfo, DP_DEBUG);
		#end

		transition = new Transition();
		s2d.add(transition, DP_TRANSITION);

		title = new ui.Title();
		s2d.add(title, DP_UI);
	}

	public function newGame() {
		if (title != null) {
			title.destroy();
			s2d.removeChild(title);
			title = null;
		}

		if (game != null)
			game.destroy();

		game = new Game();
		s2d.add(game, DP_GAME);
	}

	public function showEnd(totalShots:Int) {
		if (game != null) {
			game.destroy();
			game = null;
		}

		end = new ui.End(totalShots);
		s2d.add(end, DP_UI);
	}

	override function onResize() {
		super.onResize();

		game.onResize();
	}
	
	var slowMo			: Bool;
	var megaSlowMo		: Bool;
	var speedMo			: Bool;

	override public function update(dt:Float) {
		super.update(dt);

		#if debug
		if (hxd.Key.isPressed(hxd.Key.NUMPAD_SUB))
			slowMo = !slowMo;
		if (hxd.Key.isPressed(hxd.Key.NUMPAD_MULT))
			megaSlowMo = !megaSlowMo;
		speedMo = hxd.Key.isDown(hxd.Key.NUMPAD_ADD);
		
		if (hxd.Key.isPressed(hxd.Key.ESCAPE))
			newGame();
		#end

		transition.update(dt);
		
		if (game != null)
			game.update(dt * (speedMo ? 5 : megaSlowMo ? 0.1 : slowMo ? 0.5 : 1));

		if (end != null)
			end.update(dt);

		if (title != null)
			title.update(dt);

		dbgInfo.update(dt);
		dbgInfo.x = Const.STG_WIDTH - dbgInfo.outerWidth;
	}

	static function main() {
		#if (hl && debug)
		hxd.Res.initLocal();
		#else
		hxd.Res.initEmbed();
		#end

		DCDB.load(hxd.Res.data.entry.getBytes().toString());

		new Main();
	}
}
