import controlP5.*;

public class Layer {
    Layer(ControlP5 ctrl, PImage image) {
        m_visible = ctrl.addToggle(CheckboxNameGenerator.getNextId())
                        .setState(true);
        m_image = image;
    }

    boolean withinCheckbox(int x, int y) {
        float cbx = Controller.x(m_visible.getPosition());
        float cby = Controller.y(m_visible.getPosition());
        int cbw = m_visible.getWidth();
        int cbh = m_visible.getHeight();
        return x >= cbx && x <= (cbx + cbw) && y >= cby && y <= (cby + cbh);
    }

    Toggle m_visible;
    PImage m_image;
}
