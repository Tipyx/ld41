package ui;

class HUD extends h2d.Layers {

	var game				: Game;

	var tShot				: h2d.Text;
	var tTotal				: h2d.Text;

	public function new(game:Game) {
		super();

		this.game = game;

		var sprCount = new ASprite(Const.ALIB, "shotCounter", this);
		sprCount.setScale(2);

		tShot = new h2d.Text(hxd.res.DefaultFont.get(), this);
		tShot.text = "Shots: 0";
		tShot.setPos(10, 20);

		tTotal = new h2d.Text(hxd.res.DefaultFont.get(), this);
		tTotal.text = "Total: 0";
		tTotal.setPos(10, tShot.y + tShot.textHeight + 20);
	}

	public function updateStatus(numShots:Int) {
		tShot.text = "Shots: " + numShots;

		tTotal.text = "Total: " + (game.totalShots + numShots);
	}
}