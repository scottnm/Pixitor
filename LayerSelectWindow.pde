import controlP5.*;

public class LayerSelectWindow {
    LayerSelectWindow(ControlP5 cp5, LayerList layers, int pos_x, int pos_y, int _width, int _height) {
        m_ctrl = cp5;
        m_layerlist = layers;
        m_id_layer_map = new HashMap<String, Layer>();
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
            .setId(ControllerID.SCROLL_LAYER_SCROLL_UP);
        m_scroll_colors.assignColorsToController(m_scroll_up_btn, false);

        m_scroll_down_btn = m_ctrl.addButton("v")
            .setPosition(m_pos_x, m_pos_y + m_height * 0.95)
            .setSize(m_width, (int)(m_height * 0.05))
            .setId(ControllerID.SCROLL_LAYER_SCROLL_DOWN);
        m_scroll_colors.assignColorsToController(m_scroll_down_btn, false);

        onNewLayer();
    }

    void drawWindow() {
        pushStyle();
        pushMatrix();
        translate(m_pos_x, m_pos_y);
        fill(255);
        rect(0, 0, m_width, m_height);
        int num_layers = m_layerlist.size();
        for(int i = 0; i < 4 && i + m_layerlist.m_top_layer_index < num_layers; ++i) {
            pushMatrix();
            PImage preview_img = m_layerlist.getFromTop(i).m_image;
            int scaled_height = m_width * preview_img.height / preview_img.width;
            int h_offset = (int)(m_height * (i * 0.225 + 0.1625) - scaled_height * 0.5);
            translate(0, h_offset);
            image(preview_img, 0, 0, m_width, scaled_height);
            Toggle layer_tgl = m_layerlist.getFromTop(i).m_visible;
            boolean this_layer_active = m_layerlist.isActiveLayer(m_layerlist.topOffset(i));
            m_toggle_colors.assignColorsToController(layer_tgl, this_layer_active);
            popMatrix();
        }
        popMatrix();
        popStyle();
    }

    void onNewLayer() {
        updateScrollButtons();
        final int size = (m_height - m_scroll_up_btn.getHeight() -
                m_scroll_down_btn.getHeight()) / 40;
        Layer new_layer = m_layerlist.get(m_layerlist.size() - 1);
        new_layer.m_visible.setSize(size, size);
        new_layer.m_delete_btn.setSize(size, size);
        m_id_layer_map.put(new_layer.m_delete_btn.getName(), new_layer);
        updateLayerGUI();
    }

    void deleteLayer(String name) {
        int index = m_layerlist.indexOf(m_id_layer_map.get(name));
        m_layerlist.get(index).m_delete_btn.hide();
        m_layerlist.get(index).m_visible.hide();
        m_layerlist.remove(index);
        m_id_layer_map.remove(name);

        // handle deleting causing excess space at the bottom of the layer select
        if (m_layerlist.size() >= 4 &&
                (m_layerlist.size() - m_layerlist.m_top_layer_index) < 4) {
            onLayerScrollUp();
        }

        updateScrollButtons();
        updateLayerGUI();
    }

    void onLayerScrollUp() {
        if (!m_scroll_up_enabled) {
            return;
        }
        --m_layerlist.m_top_layer_index;
        updateScrollButtons();
        updateLayerGUI();
    }

    void onLayerScrollDown() {
        if (!m_scroll_down_enabled) {
            return;
        }
        ++m_layerlist.m_top_layer_index;
        updateScrollButtons();
        updateLayerGUI();
    }

    void updateScrollButtons() {
        m_scroll_up_enabled = m_layerlist.m_top_layer_index != 0;
        m_scroll_colors.assignColorsToController(m_scroll_up_btn,
                m_scroll_up_enabled);

        m_scroll_down_enabled = ((m_layerlist.size() - 1) - m_layerlist.m_top_layer_index) >= 4;
        m_scroll_colors.assignColorsToController(m_scroll_down_btn,
                m_scroll_down_enabled);
    }

    void updateLayerGUI() {
        for(int i = 0; i < m_layerlist.m_top_layer_index; ++i) {
            m_layerlist.get(i).m_visible.hide();
            m_layerlist.get(i).m_delete_btn.hide();
        }

        final int offset = m_pos_y + m_scroll_up_btn.getHeight();
        final int layer_window_height = (m_height - m_scroll_up_btn.getHeight() - m_scroll_down_btn.getHeight()) / 4;
        final int cbx = m_pos_x + (int)(m_width * 0.1);

        int i;
        for(i = m_layerlist.m_top_layer_index; i < m_layerlist.size() && i < m_layerlist.m_top_layer_index + 4; ++i) {
            Toggle tgl = m_layerlist.get(i).m_visible;
            tgl.show();
            int index_in_window = i - m_layerlist.m_top_layer_index;
            int cby = offset + (int)((layer_window_height * index_in_window) + (0.5 * layer_window_height) - tgl.getHeight() / 2);
            tgl.setPosition(cbx, cby);
            m_layerlist.get(i).m_delete_btn.setPosition(cbx + 31, cby);
            m_layerlist.get(i).m_delete_btn.show();
        }

        for(; i < m_layerlist.size(); ++i) {
            m_layerlist.get(i).m_visible.hide();
            m_layerlist.get(i).m_delete_btn.hide();
        }
    }

    boolean withinWindow(int x, int y) {
        for(Layer l : m_layerlist.m_layers) {
            if (l.withinCheckbox(x, y) || l.withinDeleteButton(x, y)) {
                return false;
            }
        }
        return x >= m_pos_x
            && x < (m_pos_x + m_width)
            && y >= (m_pos_y + m_scroll_up_btn.getHeight())
            && y < (m_pos_y + m_height - m_scroll_down_btn.getHeight());
    }

    int getLayerAt(int y) {
        final int inner_window_height = m_height - m_scroll_up_btn.getHeight() -
            m_scroll_down_btn.getHeight();

        int y_offset = (y - m_pos_y) - m_scroll_up_btn.getHeight();
        int lsize = m_layerlist.size();
        if (y_offset < inner_window_height / 4) {
            return lsize >= 1 ? m_layerlist.m_top_layer_index : -2;
        }
        else if (y_offset < inner_window_height / 2) {
            return lsize >= 2 ? m_layerlist.m_top_layer_index + 1 : -2;
        }
        else if (y_offset < inner_window_height * 0.75) {
            return lsize >= 3 ? m_layerlist.m_top_layer_index + 2 : -2;
        }
        else {
            return lsize >= 4 ? m_layerlist.m_top_layer_index + 3 : -2;
        }
    }

    ControlP5 m_ctrl;
    LayerList m_layerlist;
    HashMap<String, Layer> m_id_layer_map;
  
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

}
