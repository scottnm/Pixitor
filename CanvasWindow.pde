public class CanvasWindow {
    CanvasWindow(ControlP5 ctrl, int pos_x, int pos_y, int _width, int _height) {
        m_ctrl = ctrl;
        m_pos_x = pos_x;
        m_pos_y = pos_y;
        m_width = _width;
        m_height = _height;

        m_layers = new ArrayList<Layer>();
        m_active_layer = 0;

        m_brush_scale = 1;

        PImage canvasBuffer = createImage(m_width, m_height, RGB);
        canvasBuffer.loadPixels();
        for(int i = 0; i < canvasBuffer.pixels.length; ++i) {
            canvasBuffer.pixels[i] = color(0,0,0,1);
        }
        canvasBuffer.updatePixels();
        m_layers.add(new Layer(m_ctrl, canvasBuffer));

        transparencyBuffer = createImage(m_width, m_height, RGB);
        loadTransparencyGridIntoBuffer(transparencyBuffer);
    } 

    void drawWindow() {
        pushStyle();
        pushMatrix();
        translate(m_pos_x, m_pos_y);
        image(transparencyBuffer, 0, 0);
        for(Layer l : m_layers) {
            if (l.m_visible.getState()) {
                image(l.m_image, 0, 0);
            }
        }
        popMatrix();
        popStyle();
    }
    
    boolean withinWindow(int x, int y) {
        return x >= m_pos_x && x <= (m_pos_x + m_width)
            && y >= m_pos_y && y <= (m_pos_y + m_height);
    }

    void paint(int x, int y, color c) {
        int localx = (x - m_pos_x) / (7 * m_brush_scale);
        int localy = (y - m_pos_y) / (7 * m_brush_scale);
        draw7x7square(m_layers.get(m_active_layer).m_image,
            localx, localy, m_brush_scale, c);
    }

    void addColoredLayer(color c) {
        PImage canvasBuffer = createImage(m_width, m_height, RGB);
        canvasBuffer.loadPixels();
        for(int i = 0; i < canvasBuffer.pixels.length; ++i) {
            canvasBuffer.pixels[i] = c;
        }
        canvasBuffer.updatePixels();
        m_layers.add(new Layer(m_ctrl, canvasBuffer));
    }

    private void loadTransparencyGridIntoBuffer(PImage buf) {
        color onColor;
        color offColor;
        for(int i = 0; i < 100; ++i) {
            if (i % 2 == 0) {
                onColor = color(100, 100, 100, 100);;
                offColor = color(200, 200, 200, 100);
            }
            else {
                onColor = color(200, 200, 200, 100);
                offColor = color(100, 100, 100, 100);;
            }

            for(int j = 0; j < 100; j+=2) {
                draw7x7square(buf, i, j, 1, onColor);
            }

            for(int j = 1; j < 100; j+=2) {
                draw7x7square(buf, i, j, 1, offColor);
            }
        }
    }

    private void draw7x7square(PImage buf, int _x, int _y, int _scale, color c) {
        int gridlock = 7 * _scale;
        int ibound = (_x * gridlock) + gridlock;
        int jbound = (_y * gridlock) + gridlock;
        for (int i = _x * gridlock; i < ibound; ++i) {
            for (int j = _y * gridlock; j < jbound; ++j) {
                buf.set(i, j, c);
            }
        }
    }

    private ControlP5 m_ctrl;
    private PImage transparencyBuffer;
    public ArrayList<Layer> m_layers;
    public int m_active_layer;
    public int m_brush_scale;

    private int m_pos_x;
    private int m_pos_y;
    private int m_width;
    private int m_height;

    /* vector of layers to draw; draw each one on top of the other
     if pixel exists in next layer override old pixel */
    // function to draw the grid on top of the window
}
