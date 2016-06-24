module levelgen.Room;

/**
 * original file:
 *      levelgen.cpp (11.04.2016)
 */
public class Room {
    public:
        real xPos;
        real yPos;
        real width;
        real height;

        public this(real _xPos, real _yPos, real _width, real _height) {
            xPos = _xPos;
            yPos = _yPos;
            width = _width;
            height = _height;
        }

        bool intersects(const Room& other) const
        {
            return !(yPos+height <= other.yPos+1 || yPos >= other.yPos+other.height-1 || xPos+width <= other.xPos+1 || xPos >= other.xPos+other.width-1);
        }

        bool onBorder(size_t xCoord, size_t yCoord)
        {
            // Draw x oriented walls
            for(real x = 0; x < width; x++)
            {
                if((xCoord == x + xPos && yCoord == yPos) ||
                   (xCoord == x + xPos && yCoord == height-1 + yPos))
                    return true;
                //level[x + room.xPos][room.yPos] = wall;
                //level[x + room.xPos][room.height-1 + room.yPos] = wall;
            }

            // Draw y oriented walls
            for(size_t y = 0; y < height; y++)
            {
                if((xCoord == xPos && yCoord == y + yPos) ||
                   (xCoord == width-1 + xPos && yCoord == y + yPos))
                    return true;


                //level[room.xPos][y + room.yPos] = wall;
                //level[room.width-1 + room.xPos][y + room.yPos] = wall;
            }

            return false;
        }

        std::pair<int32_t, int32_t> centre() const
        {
            return std::pair<int32_t, int32_t>(xPos + (width/2), yPos + (height/2));
        }

        size_t area() const
        {
            return width*height;
        }

        size_t distance(const Room& other) const
        {
            return sqrt((float)((centre().first - other.centre().first)*(centre().first - other.centre().first) + (centre().second - other.centre().second)*(centre().second - other.centre().second)));
    }
}