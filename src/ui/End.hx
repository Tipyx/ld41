package ui;

class End extends h2d.Layers {

	var tweener			: Tweener;
	var delayer			: Delayer;

	public function new(totalShots:Int) {
		super();

		tweener = new Tweener();
		delayer = new Delayer(Const.FPS);
		
		var bg = new ASprite(Const.ALIB, "end");
		this.addChild(bg);

		var flow = new h2d.Flow();
		flow.verticalAlign = Middle;
		flow.horizontalAlign = Middle;
		flow.verticalSpacing = 20;
		flow.maxWidth = Const.STG_WIDTH >> 1;
		flow.maxHeight = Const.STG_HEIGHT >> 1;
		flow.isVertical = true;
		this.addChild(flow);

		var t1 = new h2d.Text(hxd.res.DefaultFont.get(), flow);
		t1.textColor = 0;
		t1.setScale(3);
		t1.textAlign = MultilineCenter;
		t1.text = "Thank you for playing my game !";

		var t2 = new h2d.Text(hxd.res.DefaultFont.get(), flow);
		t2.textColor = 0;
		t2.textAlign = MultilineCenter;
		t2.setScale(2);
		t2.text = "You completed it in " + totalShots + " shots!";

		var t3 = new h2d.Text(hxd.res.DefaultFont.get(), flow);
		t3.textColor = 0;
		t3.textAlign = MultilineCenter;
		t3.text = "Don't hesitate to rate it on the Ludum Dare website if you liked it, and to say us your final highscore in the comments!";

		var t4 = new h2d.Text(hxd.res.DefaultFont.get(), flow);
		t4.textColor = 0;
		t4.text = "- Tipyx";
		flow.getProperties(t4).horizontalAlign = Right;

		// flow.debug = true;
		flow.reflow();
		flow.x = (Const.STG_WIDTH - flow.outerWidth) >> 1;
		flow.y = (Std.int(Const.STG_HEIGHT * 0.85) - flow.outerHeight) >> 1;

		t1.alpha = 0;
		tweener.create(Const.FPS, t1.alpha, 1);

		t2.alpha = 0;
		delayer.setS(1, ()->tweener.create(Const.FPS, t2.alpha, 1));
		
		t3.alpha = 0;
		delayer.setS(2, ()->tweener.create(Const.FPS, t3.alpha, 1));
		
		t4.alpha = 0;
		delayer.setS(3, ()->tweener.create(Const.FPS, t4.alpha, 1));

		delayer.setS(4, function() {
			for (i in 0...4) {
				var gp = new ASprite(Const.ALIB, "hero");
				gp.setCenterRatio(0.5, 0.5);
				gp.setScale(4);
				gp.rotation = Math.PI / 2;
				gp.play("hero", -1);
				gp.speed = 15;

				gp.y = Std.int(Const.STG_HEIGHT * 0.85);
				gp.x = Const.STG_WIDTH / 5 * (i + 1) - Const.STG_WIDTH;

				tweener.create(Const.FPS * 2, gp.x, gp.x + Const.STG_WIDTH);

				this.addChild(gp);
			}
		});
	}

	public function update(dt:Float) {
		tweener.update();
		delayer.update(dt);
	}

}