class Level extends h2d.Layers {

	static var num					= 0;
	public static var DP_BG			= num++;
	public static var DP_COLL		= num++;
	public static var DP_EXIT		= num++;
	public static var DP_ENM		= num++;
	public static var DP_HERO		= num++;
	public static var DP_ARROW		= num++;
	public static var DP_FX			= num++;
	public static var DP_DEBUG		= num++;
	
	var game						: Game;
	var fx							: Fx;

	public var id					: DCDB.LvlKind;
	public var ld					: LevelData;

    public var hero                 : en.Hero;
	public var enemies				: Array<en.Entity>;
	public var exit					: {cx:Int, cy:Int, spr:ASprite};

	var arrow						: h2d.Graphics;

	var mouseX(get, never)			: Int;				inline function get_mouseX():Int return Std.int((hxd.Stage.getInstance().mouseX - this.x) / scaleX);
	var mouseY(get, never)			: Int;				inline function get_mouseY():Int return Std.int((hxd.Stage.getInstance().mouseY - this.y) / scaleY);

	var tweener						: Tweener;
	public var cd					: Cooldown;
	var delayer						: Delayer;
	
	var camX						= 0.;
	var camY						= 0.;

	// GP

	var force						: Float;
	var df							: Float;
	var fInc						: Bool;

	public var isCaught				: Bool;
    
    public function new(game:Game, id:DCDB.LvlKind) {
        super();
		
		this.game = game;
		this.id = id;

		fx = new Fx(this);

        this.setScale(Const.PIXEL_RATIO);

        ld = new LevelData(this, id);

		// Draw World
		for (x in 0...ld.wid)
			for (y in 0...ld.hei) {
				if (ld.hasColl(x, y, Hard)) {
					var gr = new h2d.Graphics();
					gr.beginFill(0x222222);
					gr.drawRect(0, 0, Const.GRID, Const.GRID);
					gr.setPos(x * Const.GRID, y * Const.GRID);
					this.add(gr, DP_COLL);
				}
			}

		// Draw Entities
		enemies = [];

		for (m in ld.getMarkers(DCDB.LevelMarkerKind.Enemy))
			enemies.push(new en.Enemy(this, m.cx, m.cy, m.customId));

        var mHero = ld.getMarker(DCDB.LevelMarkerKind.Hero);
        hero = new en.Hero(this, mHero.cx, mHero.cy);

		var mExit = ld.getMarker(Exit);
		var sprExit = new ASprite(Const.ALIB, "exit");
		sprExit.setCenterRatio(0.5, 0.5);
		sprExit.setPos((mExit.cx + 0.5) * Const.GRID, (mExit.cy + 0.5) * Const.GRID);
		this.add(sprExit, DP_EXIT);
		exit = {cx:mExit.cx, cy:mExit.cy, spr:sprExit};

        arrow = new h2d.Graphics();
		arrow.beginFill(0x00ff00);
		arrow.drawRect(0, -5, 50, 10);
		this.add(arrow, DP_ARROW);

		// GP
		force = 0;
		df = 0;
		fInc = true;

		isCaught = false;

		tweener = new Tweener();
		cd = new Cooldown(Const.FPS);
		delayer = new Delayer(Const.FPS);
    }

	public function updateArrow(dt:Float) {
		if (hero.isMoving() || isCaught)
			return;

		df = (Const.getDataValue0(DCDB.DataKind.forceBase) + (Const.getDataValue0(DCDB.DataKind.forceDelta) * (force / 1))) * dt;
		force += df * (fInc ? 1 : -1);
		if (force >= 1 && fInc) {
			force = 1;
			fInc = false;
		}
		else if (force <=0 && !fInc) {
			force = 0;
			fInc = true;
		}

		var ang = Math.atan2(mouseY - hero.wy, mouseX - hero.wx);

		if (hxd.Key.isReleased(hxd.Key.MOUSE_LEFT))
			hero.move(ang, force);

		if (!hxd.Key.isDown(hxd.Key.MOUSE_LEFT)) {
			arrow.visible = false;
			df = 0;
			force = 0;
			return;
		}

		arrow.visible = true;
		arrow.setPos(hero.wx, hero.wy);
		arrow.scaleX = force;
		arrow.rotation = ang;

		// hero.label.text = Std.string(tipyx.Lib.prettyFloat(dist) + " " + tipyx.Lib.prettyFloat(ang));
		// hero.label.text = Std.string(tipyx.Lib.prettyFloat(force));
	}

	public function updateCamera() {
		camX = -(hero.wx * this.scaleX + (hero.radius * 0.5) - Const.STG_WIDTH * 0.5);
		this.x += (camX - this.x) * Const.getDataValue0(speedCam);

		camY = -(hero.wy * this.scaleY + (hero.radius * 0.5) - Const.STG_HEIGHT * 0.5);
		this.y += (camY - this.y) * Const.getDataValue0(speedCam);
		
		if (this.x > 0)
			this.x = 0;
		if (this.x < -(ld.wid * Const.GRID * this.scaleX - Const.STG_WIDTH))
			this.x = -(ld.wid * Const.GRID * this.scaleX - Const.STG_WIDTH);
		
		if (this.y > 0)
			this.y = 0;
		if (this.y < -(ld.hei * Const.GRID * this.scaleY - Const.STG_HEIGHT))
			this.y = -(ld.hei * Const.GRID * this.scaleY - Const.STG_HEIGHT);
	}

	public function onCaught() {
		isCaught = true;

		hero.stopMove();

		fx.redFlash();

		var caughtText = new h2d.Text(hxd.res.DefaultFont.get());
		caughtText.text = "Caught!";
		caughtText.textAlign = Center;
		caughtText.setScale(scaleX);
		game.add(caughtText, DP_FX);

		caughtText.setPos((Const.STG_WIDTH >> 1), -(Const.STG_HEIGHT >> 1));
		tweener.create(Const.FPS * 0.5, caughtText.y, Const.STG_HEIGHT >> 1);

		delayer.setS("tCaught", 1.5, function() {
			game.tCaught.init();
			caughtText.remove();
		});
	}

    public function onResize() {
	}

	public function destroy() {
		removeChildren();
	}

    public function update(dt:Float) {
		cd.update(dt);
		delayer.update(dt);

		updateArrow(dt);

        // Entity
        hero.update(dt);
		for (e in enemies)
			e.update(dt);

		if (hero.cx == exit.cx && hero.cy == exit.cy)
			game.goToNextLevel();

		tweener.update();

		updateCamera();
		fx.update(dt);
    }
}