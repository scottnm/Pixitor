import controlP5.*;

public class LayerSelectWindow {
    LayerSelectWindow(ControlP5 cp5, ArrayList<Layer> layers, int pos_x, int pos_y, int _width, int _height) {
        m_ctrl = cp5;
        m_layers = layers;
        m_pos_x = pos_x;
        m_pos_y = pos_y;
        m_width = _width;
        m_height = _height;

        m_disabled_color = color(100, 100, 100, 100);
        m_enabled_active_color = color(0, 170, 255);
        m_enabled_bg_color = color(0, 45, 90);
        m_enabled_fg_color = color(0, 116, 217);

        m_scroll_up_disabled = true;
        m_scroll_down_disabled = m_layers.size() <= 4;

        m_scroll_up_button = m_ctrl.addButton("^")
            .setPosition(m_pos_x, m_pos_y)
            .setSize(m_width, (int)(m_height * 0.05))
            .setId(ButtonID.SCROLL_LAYER_SCROLL_UP)
            .setColorBackground(m_disabled_color)
            .setColorActive(m_disabled_color)
            .setColorForeground(m_disabled_color);

        m_scroll_down_button = m_ctrl.addButton("v")
            .setPosition(m_pos_x, m_pos_y + m_height * 0.95)
            .setSize(m_width, (int)(m_height * 0.05))
            .setId(ButtonID.SCROLL_LAYER_SCROLL_DOWN)
            .setColorBackground(m_disabled_color)
            .setColorActive(m_disabled_color)
            .setColorForeground(m_disabled_color);

        m_top_layer_index = 0;
        onNewLayer();
    }

    void drawWindow() {
        pushStyle();
        pushMatrix();
        translate(m_pos_x, m_pos_y);
        fill(255);
        rect(0, 0, m_width, m_height);
        int num_layers = m_layers.size();
        for(int i = 0; i < 4 && i + m_top_layer_index < num_layers; ++i) {
            pushMatrix();
            translate(0, m_height * (i * .225 + 0.05));
            image(m_layers.get(i + m_top_layer_index).m_image,
                    0, 0, m_width, m_height * .225);
            popMatrix();
        }
        popMatrix();
        popStyle();
    }

    void onNewLayer() {
        // 1/5 of the size of a single layer window
        updateScrollButtons();

        final int size = (m_height - m_scroll_up_button.getHeight() - m_scroll_down_button.getHeight()) / 40;
        m_layers.get(m_layers.size() - 1).m_visible.setSize(size, size);

        updateToggles();
    }

    void onLayerScrollUp() {
        if (m_scroll_up_disabled) {
            return;
        }
        --m_top_layer_index;
        updateScrollButtons();
        updateToggles();
    }

    void onLayerScrollDown() {
        if (m_scroll_down_disabled) {
            return;
        }
        ++m_top_layer_index;
        updateScrollButtons();
        updateToggles();
    }

    void updateScrollButtons() {
        if (m_top_layer_index == 0) {
            m_scroll_up_disabled = true;
            m_scroll_up_button.setColorBackground(m_disabled_color);
            m_scroll_up_button.setColorActive(m_disabled_color);
            m_scroll_up_button.setColorForeground(m_disabled_color);
        }
        else {
            m_scroll_up_disabled = false;
            m_scroll_up_button.setColorBackground(m_enabled_bg_color);
            m_scroll_up_button.setColorActive(m_enabled_active_color);
            m_scroll_up_button.setColorForeground(m_enabled_fg_color);
        }

        if (((m_layers.size() - 1) - m_top_layer_index) < 4) {
            m_scroll_down_disabled = true;
            m_scroll_down_button.setColorBackground(m_disabled_color);
            m_scroll_down_button.setColorActive(m_disabled_color);
            m_scroll_down_button.setColorForeground(m_disabled_color);
        }
        else {
            m_scroll_down_disabled = false;
            m_scroll_down_button.setColorBackground(m_enabled_bg_color);
            m_scroll_down_button.setColorActive(m_enabled_active_color);
            m_scroll_down_button.setColorForeground(m_enabled_fg_color);
        }
    }

    void updateToggles() {
        for(int i = 0; i < m_top_layer_index; ++i) {
            m_layers.get(i).m_visible.hide();
        }

        final int offset = m_pos_y + m_scroll_up_button.getHeight();
        final int layer_window_height = (m_height - m_scroll_up_button.getHeight() - m_scroll_down_button.getHeight()) / 4;
        final int cbx = m_pos_x + (int)(m_width * 0.1);

        int i;
        for(i = m_top_layer_index; i < m_layers.size() && i < m_top_layer_index + 4; ++i) {
            Toggle tgl = m_layers.get(i).m_visible;
            tgl.show();
            int index_in_window = i - m_top_layer_index;
            int cby = offset + (int)((layer_window_height * index_in_window) + (0.5 * layer_window_height) - tgl.getHeight() / 2);
            tgl.setPosition(cbx, cby);
        }

        for(; i < m_layers.size(); ++i) {
            m_layers.get(i).m_visible.hide();
        }
    }

    boolean withinWindow(int x, int y) {
        return x >= m_pos_x
            && x < (m_pos_x + m_width)
            && y >= (m_pos_y + m_scroll_up_button.getHeight())
            && y < (m_pos_y + m_height - m_scroll_down_button.getHeight());
    }

    int getLayerAt(int y) {
        final int inner_window_height = m_height - m_scroll_up_button.getHeight() - m_scroll_down_button.getHeight();

        int ly = (y - m_pos_y) - m_scroll_up_button.getHeight();
        int lsize = m_layers.size();
        if (ly < inner_window_height / 4) {
            return lsize >= 1 ? m_top_layer_index : -1;
        }
        else if (ly < inner_window_height / 2) {
            return lsize >= 2 ? m_top_layer_index + 1 : -1;
        }
        else if (ly < inner_window_height * 0.75) {
            return lsize >= 3 ? m_top_layer_index + 2 : -1;
        }
        else {
            return lsize >= 4 ? m_top_layer_index + 3 : -1;
        }
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
    color m_enabled_bg_color;
    color m_enabled_active_color;
    color m_enabled_fg_color;
    color m_disabled_color;

    int m_top_layer_index;
}
