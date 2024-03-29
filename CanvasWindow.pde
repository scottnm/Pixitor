public class CanvasWindow {
    CanvasWindow(ControlP5 ctrl, int pos_x, int pos_y, int _width, int _height) {
        m_ctrl = ctrl;
        m_pos_x = pos_x;
        m_pos_y = pos_y;
        m_width = _width;
        m_height = _height;

        m_layerlist = new LayerList();
        m_pixel_preview = color(0);

        m_brush_scale = 1;

        PImage canvasBuffer = createImage(m_width, m_height, ARGB);
        canvasBuffer.loadPixels();
        for(int i = 0; i < canvasBuffer.pixels.length; ++i) {
            canvasBuffer.pixels[i] = color(0,0,0,1);
        }
        canvasBuffer.updatePixels();
        m_layerlist.add(new Layer(m_ctrl, canvasBuffer));

        m_transparency_buf = createImage(m_width, m_height, ARGB);
        loadTransparencyGridIntoBuffer(m_transparency_buf);

        m_grid_buf = createImage(m_width, m_height, ARGB);        
        updateGridLines();
        m_grid_active = true;
    } 

    void drawWindow() {
        pushStyle();
        pushMatrix();
        translate(m_pos_x, m_pos_y);
        image(m_transparency_buf, 0, 0);

        if (m_layerlist.size() > 0 && withinWindow(mouseX, mouseY)) {
            int localx = (mouseX - m_pos_x) / (7 * m_brush_scale);
            int localy = (mouseY - m_pos_y) / (7 * m_brush_scale);
            LayerSave save = new LayerSave(
                    m_layerlist.getActiveLayer().m_image, localx, localy, m_brush_scale);
            paint(m_layerlist.getActiveLayer().m_image, mouseX, mouseY, m_pixel_preview);
            renderWindow(g, m_grid_active);
            save.restore(m_layerlist.getActiveLayer().m_image);
        }
        else {
            renderWindow(g, m_grid_active);
        }

        popMatrix();
        popStyle();
    }

    void renderWindow(PGraphics render_target, boolean renderGrid) {
        for(Layer l : m_layerlist.m_layers) {
            if (l.m_visible.getState()) {
                render_target.image(l.m_image, 0, 0);
            }
        }
        if (renderGrid) {
            render_target.image(m_grid_buf, 0, 0);
        }
    }

    void updateGridLines() {
        int inc = 7 * m_brush_scale;
        for (int row = 0; row < m_height; ++row) {
            for (int col = 0; col < m_width; ++col) {
               m_grid_buf.set(col, row, color(0, 0, 0, 1)); 
            }
        }
        for (int row = 0; row < m_height; row += inc) {
            for (int col = 0; col < m_width; ++col) {
               m_grid_buf.set(col, row, color(0)); 
            }
        }
        for (int row = 0; row < m_height; ++row) {
            for (int col = 0; col < m_width; col += inc) {
               m_grid_buf.set(col, row, color(0)); 
            }
        }
    }
    
    boolean withinWindow(int x, int y) {
        return x >= m_pos_x && x <= (m_pos_x + m_width)
            && y >= m_pos_y && y <= (m_pos_y + m_height);
    }

    void paint(int x, int y, color c) {
        if (m_layerlist.size() > 0) {
            int localx = (x - m_pos_x) / (7 * m_brush_scale);
            int localy = (y - m_pos_y) / (7 * m_brush_scale);
            draw7x7square(m_layerlist.getActiveLayer().m_image,
                localx, localy, m_brush_scale, c);
        }
    }

    void paint(PImage buf, int x, int y, color c) {
        int localx = (x - m_pos_x) / (7 * m_brush_scale);
        int localy = (y - m_pos_y) / (7 * m_brush_scale);
        draw7x7square(buf, localx, localy, m_brush_scale, c);
    }

    void addColoredLayer(color c) {
        PImage canvasBuffer = createImage(m_width, m_height, ARGB);
        canvasBuffer.loadPixels();
        for(int i = 0; i < canvasBuffer.pixels.length; ++i) {
            canvasBuffer.pixels[i] = c;
        }
        canvasBuffer.updatePixels();
        m_layerlist.add(new Layer(m_ctrl, canvasBuffer));
    }

    void addImageLayer(String s) {
        PImage layer_buf = createImage(m_width, m_height, ARGB);
        PImage _img = loadImage(s);
        if (_img.width > _img.height) {
            _img.resize(m_width, 0);
        }
        else {
            _img.resize(0, m_height);
        }
        layer_buf.copy(_img, 0, 0, _img.width, _img.height,
                (m_width - _img.width) / 2, (m_height - _img.height) / 2,
                _img.width, _img.height);
        m_layerlist.add(new Layer(m_ctrl, layer_buf));
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

    private class LayerSave {
        LayerSave(PImage buf, int x, int y, int scale) {
            int gridlock = 7 * scale;

            lx = x * gridlock;
            ux = (x + 1) * gridlock;
            ly = y * gridlock;
            uy = (y + 1) * gridlock;

            int num_cols = ux - lx;
            int num_rows = uy - ly;
            save_buf = new color[num_cols * num_rows];
            for (int r = 0; r < num_rows; ++r) {
                for (int c = 0; c < num_cols; ++c) {
                    save_buf[r * num_cols + c] = buf.get(c + lx, r + ly);
                }
            }
        }

        void restore(PImage buf) {
            int num_cols = ux - lx;
            int num_rows = uy - ly;
            for (int r = 0; r < num_rows; ++r) {
                for (int c = 0; c < num_cols; ++c) {
                    buf.set(c + lx, r + ly, save_buf[r * num_cols + c]);
                }
            }
        }

        private int lx;
        private int ux;
        private int ly;
        private int uy;
        private color[] save_buf;
    }

    private ControlP5 m_ctrl;
    private PImage m_transparency_buf;
    private PImage m_grid_buf;
    public boolean m_grid_active;
    public LayerList m_layerlist;
    public int m_brush_scale;
    public color m_pixel_preview;

    private int m_pos_x;
    private int m_pos_y;
    private int m_width;
    private int m_height;

    /* vector of layers to draw; draw each one on top of the other
     if pixel exists in next layer override old pixel */
    // function to draw the grid on top of the window
}
