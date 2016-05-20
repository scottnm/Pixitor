import controlP5.*;

public class Layer {
    Layer(ControlP5 ctrl, PImage image) {
        m_visible = ctrl.addToggle(CheckboxNameGenerator.getNextId())
                        .setState(true);
        m_image = image;
    }

    Toggle m_visible;
    PImage m_image;
}
