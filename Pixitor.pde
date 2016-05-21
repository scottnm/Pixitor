import controlP5.*;

ControlP5 ctrl;
ColorSelectWindow color_select;
CanvasWindow canvas;
LayerSelectWindow layer_select;
Slider scale_slider;
Button new_layer_button;
static color empty;

void setup() {
    size(900, 700);
    ctrl = new ControlP5(this);
    color_select = new ColorSelectWindow(ctrl, 0, 0, 100, 200);
    canvas = new CanvasWindow(ctrl, 100, 0, 700, 700);
    layer_select = new LayerSelectWindow(ctrl, canvas.m_layers, 800, 0, 100, 700);
    scale_slider = ctrl.addSlider("Scale", 1, 4, 1, 30, 250, 40, 100)
        .showTickMarks(true)
        .snapToTickMarks(true)
        .setColorTickMark(color(0,0,0,255))
        .setNumberOfTickMarks(4)
        .setId(ControllerID.SCALE_SLIDER);
    new_layer_button = ctrl.addButton("New Layer")
        .setPosition(20, 650)
        .setId(ControllerID.NEW_LAYER);
    empty = color(200);
}

void draw() {
    fill(empty);
    rect(0,0,800,700);
    color_select.drawWindow();
    canvas.drawWindow();
    layer_select.drawWindow();
}

void mousePressed() {
    if (canvas.withinWindow(mouseX, mouseY)) {
        canvas.paint(mouseX, mouseY, color_select.getColor());
    }
    else if (layer_select.withinWindow(mouseX, mouseY)) {
        int layer = layer_select.getLayerAt(mouseY);
        if (layer != -1) {
            canvas.m_active_layer = layer;
            layer_select.m_active_layer = layer;
        }
    }
}

void mouseDragged() {
    if (canvas.withinWindow(pmouseX, pmouseY)) {
        int del_x = mouseX - pmouseX;
        int del_y = mouseY - pmouseY;
        color c = color_select.getColor();
        for(int r = 1; r <= 20; ++r) {
            int xt = ((del_x * r) / 20) + (pmouseX);
            int yt = ((del_y * r) / 20) + (pmouseY);
            canvas.paint(xt, yt, c);
        }
    }
}

void controlEvent(ControlEvent evt) {
    if (!evt.isController()) {
        return;
    }
    switch (evt.getController().getId()) {
        case ControllerID.NEW_LAYER:
            canvas.addColoredLayer(color_select.getColor());
            layer_select.onNewLayer();
            break;
        case ControllerID.SCROLL_LAYER_SCROLL_UP:
            layer_select.onLayerScrollUp();
            break;
        case ControllerID.SCROLL_LAYER_SCROLL_DOWN:
            layer_select.onLayerScrollDown();
            break;
        case ControllerID.SCALE_SLIDER:
            canvas.m_brush_scale = (int)(scale_slider.getValue());
            break;
        default:
            color_select.injectControlEvent(evt);
            break;
    }
}
