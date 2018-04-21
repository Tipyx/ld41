class Level extends h2d.Layers {

	static var num					= 0;
	public static var DP_BG			= num++;
	public static var DP_HERO		= num++;

    var hero                        : en.Hero;

    public function new() {
        super();

        this.setScale(Const.PIXEL_RATIO);

        hero = new en.Hero(this);
    }

    public function update() {
        hero.update();

        
    }
}