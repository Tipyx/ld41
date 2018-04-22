package ui;

class Title extends h2d.Layers {

	var tweener			: Tweener;
	var delayer			: Delayer;

	var clicDone		: Bool;

	public function new() {
		super();

		clicDone = false;

		tweener = new Tweener();
		delayer = new Delayer(Const.FPS);
		
		var bg = new ASprite(Const.ALIB, "title");
		this.addChild(bg);

		var t1 = new h2d.Text(hxd.res.DefaultFont.get(), this);
		t1.textColor = 0;
		t1.setScale(2);
		t1.text = "- Click to play -";
		t1.textAlign = Center;
		t1.setPos(Std.int(Const.STG_WIDTH) >> 1, Std.int(Const.STG_HEIGHT * 0.75));

		t1.alpha = 0;
		delayer.setS(1, ()->tweener.create(Const.FPS, t1.alpha, 1));
	}

	public function destroy() {
		removeChildren();
	}

	public function update(dt:Float) {
		tweener.update();
		delayer.update(dt);

		if (!clicDone && hxd.Key.isReleased(hxd.Key.MOUSE_LEFT)) {
			clicDone = true;
			Main.ME.transition.init(() -> Main.ME.newGame());
		}
	}

}