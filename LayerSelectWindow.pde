import controlP5.*;

public class LayerSelectWindow {
    LayerSelectWindow(ControlP5 cp5, ArrayList<Layer> layers, int pos_x, int pos_y, int _width, int _height) {
        m_ctrl = cp5;
        m_layers = layers;
        m_pos_x = pos_x;
        m_pos_y = pos_y;
        m_width = _width;
        m_height = _height;
    }

    void drawWindow() {
        pushStyle();
        pushMatrix();
        translate(m_pos_x, m_pos_y);
        fill(255);
        rect(0, 0, m_width, m_height);
        popMatrix();
        popStyle();
    }

    ControlP5 m_ctrl;
    ArrayList<Layer> m_layers;
  
    int m_pos_x;
    int m_pos_y;
    int m_width;
    int m_height;
}
