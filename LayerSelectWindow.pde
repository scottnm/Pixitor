public class LayerSelectWindow {
    LayerSelectWindow(ArrayList<Layer> layers, int pos_x, int pos_y, int _width, int _height) {
        m_layers = layers;
        m_pos_x = pos_x;
        m_pos_y = pos_y;
        m_width = _width;
        m_height = _height;
    }

    ArrayList<Layer> m_layers;
  
    int m_pos_x;
    int m_pos_y;
    int m_width;
    int m_height;
}
