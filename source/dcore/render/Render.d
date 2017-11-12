module dcore.render.Render;

/**
 * original file:
 *      render.h (10.01.2015)
 */
public class Render {

    int WIDTH;
    int HEIGHT;

    enum TileHalf {
        left,
        right
    }

    // Tile mesasured in indexes on tile grid
    struct Tile {
        int x;
        int y;
        TileHalf half;

        this(int xArg, int yArg, TileHalf halfArg = TileHalf.left) {
            this.x = xArg;
            this.y = yArg;
            this.half = halfArg;
        }
    }

    /**
     * Render settings for initialization.
     */
    struct RenderSettings {
        int windowWidth;
        int windowHeight;
        bool fullscreen;
    }

    struct NuklearGraphicsContext {
        //nk_gl_device dev;
        //nk_font_atlas atlas;
    }
}