import controlP5.*;

public class LayerSelectWindow {
    LayerSelectWindow(ControlP5 cp5, ArrayList<Layer> layers, int pos_x, int pos_y, int _width, int _height) {
        m_ctrl = cp5;
        m_layers = layers;
        m_pos_x = pos_x;
        m_pos_y = pos_y;
        m_width = _width;
        m_height = _height;

        m_scroll_up_disabled = true;
        m_scroll_down_disabled = m_layers.size() <= 4;

        m_scroll_up_button = m_ctrl.addButton("^")
            .setPosition(m_pos_x, m_pos_y)
            .setSize(m_width, (int)(m_height * 0.05))
            .setId(ButtonID.SCROLL_LAYER_SELECT_UP);

        m_scroll_down_button = m_ctrl.addButton("v")
            .setPosition(m_pos_x, m_pos_y + m_height * 0.95)
            .setSize(m_width, (int)(m_height * 0.05))
            .setId(ButtonID.SCROLL_LAYER_SELECT_DOWN);

        m_enabled_color = m_scroll_up_button.getColor().getBackground();
        m_disabled_color = color(100, 100, 100, 100);
    }

    void drawWindow() {
        m_scroll_up_button.setLock(m_scroll_up_disabled);
        m_scroll_up_button.setColorBackground(m_scroll_up_disabled ? m_disabled_color : m_enabled_color);
        m_scroll_down_button.setLock(m_scroll_down_disabled);
        m_scroll_down_button.setColorBackground(m_scroll_down_disabled ? m_disabled_color : m_enabled_color);

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

    Button m_scroll_up_button;
    boolean m_scroll_up_disabled;
    Button m_scroll_down_button;
    boolean m_scroll_down_disabled;
    color m_enabled_color;
    color m_disabled_color;
}
