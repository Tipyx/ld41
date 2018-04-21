class DebugInfo extends h2d.Flow {

	var fps				: h2d.Text;
	var speed			: h2d.Text;

	public function new() {
		super();

		horizontalAlign = Right;
		isVertical = true;

		fps = new h2d.Text(hxd.res.DefaultFont.get());
		this.addChild(fps);

		speed = new h2d.Text(hxd.res.DefaultFont.get());
		this.addChild(speed);
	}

	public function update(dt:Float) {
		fps.text = Std.string(Main.ME.engine.fps);
		speed.text =	Main.ME.megaSlowMo ? "MegaSlowMo" :
						Main.ME.slowMo ? "SlowMo" : "Normal";
		speed.textColor = 	Main.ME.megaSlowMo ? 0xe69a28 :
							Main.ME.slowMo ? 0xc5cf47 : 0xFFFFFF;
	}
}