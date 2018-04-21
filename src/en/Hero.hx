package en;

class Hero {

    var level           : Level;

    public function new(level:Level) {
        this.level = level;

        var dbgGr = new h2d.Graphics();
        dbgGr.beginFill(0x21ccda);
        dbgGr.drawCircle(0, 0, 25);
        level.add(dbgGr, Level.DP_HERO);
    }

    public function update() {
        
    }
}