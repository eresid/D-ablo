module world.Player;

/**
 * original file:
 *      player.cpp (07.01.2016)
 *      player.h (07.01.2016)
 */
class Player : Actor {

    // these "Fmt" vars are just used by getCurrentAnim
    private string mFmtClassName;
    private string mFmtClassCode;
    private string mFmtArmourCode;
    private string mFmtWeaponCode;
    private bool mFmtInDungeon = false;

    private Inventory mInventory;

    public this() {
        mAnimTimeMap[AnimState.dead] = 10;
        mAnimTimeMap[AnimState.walk] = 10;
        mAnimTimeMap[AnimState.attack] = 16;
        mAnimTimeMap[AnimState.idle] = 10;

        mWorld.getInstance().registerPlayer(this);
    }

    public void destroy() {
        super.destroy();
        mWorld.getInstance().deregisterPlayer(this);
    }

    public void setSpriteClass(string className) {
        mFmtClassName = className;
        mFmtClassCode = className[0];
    }

    public bool attack(Actor enemy) {

    }

    public bool attack(Player enemy) {

    }

    public bool talk(Actor actor) {

    }

    public FASpriteGroup getCurrentAnim() {

    }

    public void updateSpriteFormatVars() {

    }

    public void setLevel(GameLevel level) {
        setLevel(level);
    }

    public int getBasePriority() {
        return 10;
    }
}