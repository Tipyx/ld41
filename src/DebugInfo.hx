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
		speed.text =	Main.ME.speedMo ? "SpeedMo" :
						Main.ME.slowMo ? "SlowMo" :
						Main.ME.megaSlowMo ? "MegaSlowMo" : "Normal";
		speed.textColor = 	Main.ME.speedMo ? 0x45de4d :
							Main.ME.slowMo ? 0xc5cf47 :
							Main.ME.megaSlowMo ? 0xe69a28 : 0xFFFFFF;
	}
}