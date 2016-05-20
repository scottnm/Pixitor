import controlP5.*;

public class ColorSelectWindow{
    ColorSelectWindow(ControlP5 cp5, int pos_x, int pos_y, int _width, int _height) {    
    ctrl = cp5;

    PFont font = createFont("arial", 14);

    ctrl.addTextfield("R")
        .setPosition(pos_x + 10, pos_y + 50)
        .setSize(70, 20)
        .setFont(font)
        .setAutoClear(false)
        .setText("0")
        .setInputFilter(ControlP5.INTEGER);

    ctrl.addTextfield("G")
        .setPosition(pos_x + 10, pos_y + 100)
        .setSize(70, 20)
        .setFont(font)
        .setAutoClear(false)
        .setText("0")
        .setInputFilter(ControlP5.INTEGER);

    ctrl.addTextfield("B")
        .setPosition(pos_x + 10, pos_y + 150)
        .setSize(70, 20)
        .setFont(font)
        .setAutoClear(false)
        .setText("0")
        .setInputFilter(ControlP5.INTEGER);

        m_pos_x = pos_x;
        m_pos_y = pos_y;
        m_width = _width;
        m_height = _height;
    }

    void drawWindow() {
        pushStyle();
        pushMatrix();
        translate(m_pos_x, m_pos_y);
        fill(80);
        rect(0, 0, m_width, m_height);

        // color preview
        fill(m_r, m_g, m_b);
        rect(0, 0, m_width, 30);

        popMatrix();
        popStyle();
    }

    void injectControlEvent(ControlEvent evt) {
        m_r = getColorFromTextField("R");
        m_g = getColorFromTextField("G");
        m_b = getColorFromTextField("B");
    }

    private int getColorFromTextField(String colorTextField) {
        String color_text = ctrl.get(Textfield.class, colorTextField).getText();
        if (color_text.equals("")) {
            return 0;
        }
        return Integer.parseInt(color_text);
    }

    color getColor() {
        return color(m_r, m_g, m_b);
    }

    ControlP5 ctrl;

    private int m_pos_x;
    private int m_pos_y;
    private int m_width;
    private int m_height;

    // color
    private int m_r;
    private int m_g;
    private int m_b;
}
