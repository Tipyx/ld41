class Game extends h2d.Layers {
	public function new() {
		super();

		var bg = new h2d.Graphics();
		bg.beginFill(0x6098f7);
		bg.drawRect(0, 0, Const.STG_WIDTH, Const.STG_HEIGHT);
		bg.endFill();
		this.add(bg, 0);
	}

	public function update() {

	}
}
