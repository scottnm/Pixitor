import controlP5.*;

public class Layer {
    Layer(ControlP5 ctrl, PImage image) {
        m_visible = ctrl.addToggle(NameGenerator.getNextId())
                        .setState(true)
                        .setCaptionLabel("");
        m_delete_btn = ctrl.addButton(NameGenerator.getNextId())
                        .setCaptionLabel("X")
                        .setId(ControllerID.DELETE_LAYER);
        m_image = image;
    }

    boolean withinCheckbox(int x, int y) {
        float cbx = Controller.x(m_visible.getPosition());
        float cby = Controller.y(m_visible.getPosition());
        int cbw = m_visible.getWidth();
        int cbh = m_visible.getHeight();
        return x >= cbx && x <= (cbx + cbw) && y >= cby && y <= (cby + cbh);
    }

    boolean withinDeleteButton(int x, int y) {
        float cbx = Controller.x(m_delete_btn.getPosition());
        float cby = Controller.y(m_delete_btn.getPosition());
        int cbw = m_delete_btn.getWidth();
        int cbh = m_delete_btn.getHeight();
        return x >= cbx && x <= (cbx + cbw) && y >= cby && y <= (cby + cbh);
    }

    Toggle m_visible;
    Button m_delete_btn;
    PImage m_image;
}
