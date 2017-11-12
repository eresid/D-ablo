module gameengine.ThreadManager;

import std.stdio;
import std.datetime;

import dcore.utils.Queue;
import render.RenderState;

class ThreadManager {

    private Queue mQueue; // TODO add capacity 100 elements
    private RenderState mRenderState;
    private AudioManager mAudioManager;

    private static ThreadManager mInstance;

    private this() {
        mQueue = new Queue!Message();
    }

    public static synchronized ThreadManager getInstance() {
        if (mInstance is null) {
            mInstance = new ThreadManager;
        }

        return mInstance;
    }

    enum ThreadState {
        PLAY_MUSIC,
        PLAY_SOUND,
        STOP_SOUND,
        RENDER_STATE
    }

    struct Message {
        ThreadState type;

        union data {
            string musicPath;
            string soundPath;
            RenderState renderState;
        }
    }

    public void run() {
        immutable int MAXIMUM_DURATION_IN_MS = 1000;
        InputManager inputManager = InputManager.getInstance();
        Renderer renderer = Renderer.getInstance();

        Message message;

        auto last = Clock.currTime().toUnixTime();
        int numFrames = 0;

        while(true) {
            while(mQueue.pop(message)) {
                handleMessage(message);
            }

            inputManager.poll();

            if(!renderer.renderFrame(mRenderState)) {
                break;
            }

            auto now = Clock.currTime().toUnixTime();
            numFrames++;

            long duration = now - last;

            if(duration >= MAXIMUM_DURATION_IN_MS) {
                writeln("FPS: ", ((float)numFrames) / (((float)duration)/MAXIMUM_DURATION_IN_MS));
                numFrames = 0;
                last = now;
            }
        }

        renderer.cleanup();
    }

    public void playMusic(string path) {
        Message message;
        message.type = ThreadState.PLAY_MUSIC;
        message.data.musicPath = path;

        mQueue.push(message);
    }

    public void playSound(string path) {
        Message message;
        message.type = ThreadState.PLAY_SOUND;
        message.data.soundPath = path;

        mQueue.push(message);
    }

    public void stopSound() {
        Message message;
        message.type = ThreadState.STOP_SOUND;
        mQueue.push(message);
    }

    public void sendRenderState(RenderState state) {
        Message message;
        message.type = ThreadState.RENDER_STATE;
        message.data.renderState = state;

        mQueue.push(message);
    }

    private void handleMessage(immutable Message message) {
        switch(message.type)
        {
            case ThreadState.PLAY_MUSIC: {
                mAudioManager.playMusic(message.data.musicPath);
                delete message.data.musicPath;
                break;
            }

            case ThreadState.PLAY_SOUND: {
                mAudioManager.playSound(message.data.soundPath);
                delete message.data.soundPath;
                break;
            }

            case ThreadState.STOP_SOUND: {
                mAudioManager.stopSound();
                break;
            }

            case ThreadState.RENDER_STATE: {
                if (mRenderState && mRenderState != message.data.renderState)
                    mRenderState.ready = true;

                mRenderState = message.data.renderState;
                break;
            }
        }
    }
}