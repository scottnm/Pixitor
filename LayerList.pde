class LayerList {

    LayerList () {
        m_layers = new ArrayList<Layer>();
        m_top_layer_index = 0;
        m_active_layer = 0;
    }
 
    void add(Layer l) {
        if (m_layers.size() == 0) {
            m_active_layer = 0;
        }
        m_layers.add(l);
    }

    void remove(Layer l) {
        m_layers.remove(l);
        if (m_active_layer >= m_layers.size()) {
            m_active_layer = m_layers.size() - 1;
        }
    }

    void remove(int i) {
        m_layers.remove(i);
        if (m_active_layer >= m_layers.size()) {
            m_active_layer = m_layers.size() - 1;
        }
    }

    int size() {
        return m_layers.size();
    }

    Layer get(int i) {
        return m_layers.get(i);
    }

    int indexOf(Layer l) {
        return m_layers.indexOf(l);
    }

    Layer getFromTop(int i) {
        return m_layers.get(i + m_top_layer_index);
    }

    int topOffset(int i) {
        return m_top_layer_index + i;
    }

    boolean isActiveLayer(int i) {
        return i == m_active_layer;
    }

    Layer getActiveLayer() {
        return m_layers.get(m_active_layer);
    }

    public ArrayList<Layer> m_layers;
    public int m_active_layer;
    public int m_top_layer_index;
}
