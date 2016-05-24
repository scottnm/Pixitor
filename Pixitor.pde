import controlP5.*;

ControlP5 ctrl;
ColorSelectWindow color_select;
CanvasWindow canvas;
LayerSelectWindow layer_select;
Slider scale_slider;
Button new_layer_button;
RadioButton tool_select;
Toggle grid_line_toggle;
Button render_btn;
Button load_file_btn;

boolean pen_selected;

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
    grid_line_toggle = ctrl.addToggle("Grid")
        .setSize(15, 15)
        .setState(true)
        .setPosition(43, 500)
        .setId(ControllerID.TOGGLE_GRID);
    tool_select  = ctrl.addRadioButton("toolSelect")
        .setPosition(20, 400)
        .setSize(15, 15)
        .addItem("Draw", 0)
        .addItem("Erase", 1)
        .setNoneSelectedAllowed(false);
    tool_select.activate(0);
    pen_selected = true;
    render_btn = ctrl.addButton("flatRender")
        .setPosition(20, 550)
        .setCaptionLabel("Render");
    load_file_btn = ctrl.addButton("loadFile")
        .setPosition(20, 600)
        .setCaptionLabel("Load image");
}

void draw() {
    fill(color(200));
    rect(0,0,800,700);
    color_select.drawWindow();
    canvas.m_pixel_preview = pen_selected ? color_select.getColor() : color(0, 0, 0, 1);
    canvas.drawWindow();
    layer_select.drawWindow();
}

void mousePressed() {
    if (canvas.withinWindow(mouseX, mouseY)) {
        canvas.paint(mouseX, mouseY,
                pen_selected ? color_select.getColor() : color(0, 0, 0, 1));
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
        if (pen_selected) {
            color c = color_select.getColor();
            for(int r = 1; r <= 20; ++r) {
                int xt = ((del_x * r) / 20) + (pmouseX);
                int yt = ((del_y * r) / 20) + (pmouseY);
                canvas.paint(xt, yt, c);
            }
        }
        else {
            for(int r = 1; r <= 20; ++r) {
                int xt = ((del_x * r) / 20) + (pmouseX);
                int yt = ((del_y * r) / 20) + (pmouseY);
                canvas.paint(xt, yt, color(0, 0, 0, 1));
            }
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
            canvas.updateGridLines();
            break;
        case ControllerID.TOGGLE_GRID:
            canvas.m_grid_active = grid_line_toggle.getState();
            break;
        case ControllerID.DELETE_LAYER:
            layer_select.deleteLayer(evt.getController().getName());
            break;
        default:
            color_select.injectControlEvent(evt);
            break;
    }
}

void toolSelect(int selectedTool) {
    pen_selected = selectedTool == 0;
}

void flatRender() {
    PGraphics pg = createGraphics(700, 700);
    pg.beginDraw();
    canvas.renderWindow(pg, false);
    pg.endDraw();
    pg.save("renders/render.png");
    println("Render finished");
}

void loadFile() {
    selectInput("Select an image to load to a layer:",
            "loadFileCallback");
}

void loadFileCallback(File selection) {
    canvas.addImageLayer(selection.getAbsolutePath());
    layer_select.onNewLayer();
}
