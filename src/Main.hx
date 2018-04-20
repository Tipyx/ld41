class Main extends hxd.App {

	public static var ME		: Main;

	var game			: Game;

	override function init() {
		super.init();
		
		ME = this;

		Const.INIT();

		game = new Game();
		s2d.addChild(game);
	}

	override function onResize() {
		super.onResize();
	}

	override public function update(dt:Float) {
		super.update(dt);

		game.update();
	}

	static function main() {
		hxd.Res.initEmbed();

		new Main();
	}
}
