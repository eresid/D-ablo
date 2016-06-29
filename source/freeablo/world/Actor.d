module world.Actor;

/**
 * original file:
 *      actor.cpp (07.01.2016)
 *      actor.h (07.01.2016)
 */
class Actor { // TODO extend NetObject

    enum AnimState {
        walk,
        idle,
        attack,
        dead,
        hit
    }

    alias Destination = Tuple!(int, "index", int, "value");

    private ActorStats mActorStats;
    private World mWorld;

    protected AnimState mAnimState;
    protected GameLevel mLevel = null;

    protected bool mIsDead = false;
    protected bool mCanTalk = false;
    protected bool mIsEnemy;

    public Position mPos;
    //private: //TODO: fix this
    public FARender::FASpriteGroup mWalkAnim = FARender::getDefaultSprite();
    public FARender::FASpriteGroup mIdleAnim = FARender::getDefaultSprite();
    public FARender::FASpriteGroup mDieAnim = FARender::getDefaultSprite();
    public FARender::FASpriteGroup mAttackAnim = FARender::getDefaultSprite();
    public FARender::FASpriteGroup mHitAnim = FARender::getDefaultSprite();

    private string mActorId;
    private long mId;
    private NetManager mNetManager;
    private Destination mDestination;

    public AnimState[int] mAnimTimeMap;
    public ActorStats mStats = null;
    public int mFrame;
    public bool mAnimPlaying = false;
    public bool isAttacking = false;
    public bool isTalking = false;

    public this(const string walkAnimPath="",
                 const string idleAnimPath="",
                 const Position pos = new Position(0,0),
                 const string dieAnimPath="",
                 ActorStats stats=nullptr) {

    }

    protected void destroy() {
        if (mStats != nullptr) {
            // old variant: delete mStats
            mStats = null;
        }
    }

    public void update(bool noclip, int ticksPassed);
    public void setStats(ActorStats stats);
    public abstract string getDieWav(){return "";}
    public abstract string getHitWav(){return "";}
    public abstract void setSpriteClass(string className) {

    }
    public abstract void takeDamage(double amount);
    public abstract int getCurrentHP();
    public abstract FARender::FASpriteGroup* getCurrentAnim();
    public void setAnimation(AnimState::AnimState state, bool reset=false);
    public void setWalkAnimation(const string path);
    public void setIdleAnimation(const string path);
    public AnimState::AnimState getAnimState();

    public abstract bool attack(Actor enemy) {
        return false;
    }

    public abstract bool talk(Actor actor) {
        return false;
    }

    public abstract void die() {
        setAnimation(AnimState.dead);
        mIsDead = true;
        ThreadManager.getInstance().playSound(getDieWav());
    }

    protected bool canIAttack(Actor actor) {
        return actor != null &&
               this != actor &&
               actor.isEnemy() &&
               !actor.isDead() &&
               mPos.distanceFrom(actor.mPos) < 2 &&
               !isAttacking;
    }

    protected bool canTalkTo(Actor actor) {
        return actor != null &&
               this != actor &&
               mPos.distanceFrom(actor->mPos) < 2 &&
               actor.canTalk() &&
               !isTalking;
    }

    // Getters and Setters

    public long getId() {
        return mId;
    }

    public abstract void setLevel(GameLevel level) {
        mLevel = level;
    }

    public GameLevel getLevel() {
        return mLevel;
    }

    public Destination getDestination() {
        return mDestination;
    }

    public bool isDead() {
        return mIsDead;
    }

    public bool isEnemy() {
        return mIsEnemy;
    }

    public string getActorId() {
        return mActorId;
    }

    public void setActorId(string id) {
        mActorId = id;
    }

    public bool canTalk() {
        return mCanTalk;
    }

    public void setCanTalk(bool canTalk) {
        mCanTalk = canTalk;
    }
}