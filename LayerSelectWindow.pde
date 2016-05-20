import controlP5.*;

public class LayerSelectWindow {
    LayerSelectWindow(ControlP5 cp5, ArrayList<Layer> layers, int pos_x, int pos_y, int _width, int _height) {
        m_ctrl = cp5;
        m_layers = layers;
        m_pos_x = pos_x;
        m_pos_y = pos_y;
        m_width = _width;
        m_height = _height;

        m_scroll_colors = new ControlP5ColorSet(
                    color(0, 45, 90), color(0, 116, 217), color(0, 170, 255),
                    color(100, 100), color(100, 100), color(100, 100)
                );

        m_toggle_colors = new ControlP5ColorSet(
                    color(86, 90, 0), color(210, 217, 0), color(255, 255, 0),
                    color(0, 45, 90), color(0, 116, 217), color(0, 170, 255)
                );

        m_scroll_up_btn = m_ctrl.addButton("^")
            .setPosition(m_pos_x, m_pos_y)
            .setSize(m_width, (int)(m_height * 0.05))
            .setId(ButtonID.SCROLL_LAYER_SCROLL_UP);
        m_scroll_colors.assignColorsToController(m_scroll_up_btn, false);

        m_scroll_down_btn = m_ctrl.addButton("v")
            .setPosition(m_pos_x, m_pos_y + m_height * 0.95)
            .setSize(m_width, (int)(m_height * 0.05))
            .setId(ButtonID.SCROLL_LAYER_SCROLL_DOWN);
        m_scroll_colors.assignColorsToController(m_scroll_down_btn, false);

        m_top_layer_index = 0;
        m_active_layer = 0;
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
            PImage preview_img = m_layers.get(i + m_top_layer_index).m_image;
            int scaled_height = m_width * preview_img.height / preview_img.width;
            int h_offset = (int)(m_height * (i * 0.225 + 0.1625) - scaled_height * 0.5);
            translate(0, h_offset);
            image(preview_img, 0, 0, m_width, scaled_height);
            Toggle layer_tgl = m_layers.get(i + m_top_layer_index).m_visible;
            boolean this_layer_active = i + m_top_layer_index == m_active_layer;
            m_toggle_colors.assignColorsToController(layer_tgl, this_layer_active);
            popMatrix();
        }
        popMatrix();
        popStyle();
    }

    void onNewLayer() {
        // 1/5 of the size of a single layer window
        updateScrollButtons();

        final int size = (m_height - m_scroll_up_btn.getHeight() - m_scroll_down_btn.getHeight()) / 40;
        m_layers.get(m_layers.size() - 1).m_visible.setSize(size, size);

        updateToggles();
    }

    void onLayerScrollUp() {
        if (!m_scroll_up_enabled) {
            return;
        }
        --m_top_layer_index;
        updateScrollButtons();
        updateToggles();
    }

    void onLayerScrollDown() {
        if (!m_scroll_down_enabled) {
            return;
        }
        ++m_top_layer_index;
        updateScrollButtons();
        updateToggles();
    }

    void updateScrollButtons() {
        m_scroll_up_enabled = m_top_layer_index != 0;
        m_scroll_colors.assignColorsToController(m_scroll_up_btn,
                m_scroll_up_enabled);

        m_scroll_down_enabled = ((m_layers.size() - 1) - m_top_layer_index) >= 4;
        m_scroll_colors.assignColorsToController(m_scroll_down_btn,
                m_scroll_down_enabled);
    }

    void updateToggles() {
        for(int i = 0; i < m_top_layer_index; ++i) {
            m_layers.get(i).m_visible.hide();
        }

        final int offset = m_pos_y + m_scroll_up_btn.getHeight();
        final int layer_window_height = (m_height - m_scroll_up_btn.getHeight() - m_scroll_down_btn.getHeight()) / 4;
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
        for(Layer l : m_layers) {
            if (l.withinCheckbox(x, y)) {
                return false;
            }
        }
        return x >= m_pos_x
            && x < (m_pos_x + m_width)
            && y >= (m_pos_y + m_scroll_up_btn.getHeight())
            && y < (m_pos_y + m_height - m_scroll_down_btn.getHeight());
    }

    int getLayerAt(int y) {
        final int inner_window_height = m_height - m_scroll_up_btn.getHeight() - m_scroll_down_btn.getHeight();

        int ly = (y - m_pos_y) - m_scroll_up_btn.getHeight();
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

    Button m_scroll_up_btn;
    boolean m_scroll_up_enabled;
    Button m_scroll_down_btn;
    boolean m_scroll_down_enabled;

    ControlP5ColorSet m_scroll_colors;
    ControlP5ColorSet m_toggle_colors;

    int m_top_layer_index;
    int m_active_layer;
}
