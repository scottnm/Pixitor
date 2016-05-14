import controlP5.*;

ControlP5 ctrl;
ColorSelectWindow color_select;
CanvasWindow canvas;
Slider scale_slider;
static color empty;

void setup() {
  size(800, 700);
  ctrl = new ControlP5(this);
  color_select = new ColorSelectWindow(ctrl, 0, 0, 100, 200);
  canvas = new CanvasWindow(100, 0, 700, 700);
  scale_slider = ctrl.addSlider("Scale", 1, 4, 1, 20, 200, 60, 200)
      .showTickMarks(true)
      .snapToTickMarks(true)
      .setColorTickMark(color(0,0,0,255))
      .setNumberOfTickMarks(4);
  empty = color(200);
}

void draw() {
  fill(empty);
  rect(0,0,800,700);
  color_select.drawWindow();
  canvas.drawWindow();
}

void keyPressed() {
  canvas.addColoredLayer(color(255, 0, 0));
}

void mousePressed() {
  if (canvas.withinWindow(mouseX, mouseY)) {
    canvas.paint(mouseX, mouseY, (int)scale_slider.getValue(), color_select.getColor());
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
      canvas.paint(xt, yt, (int)scale_slider.getValue(), c);
    }
  }
}

void controlEvent(ControlEvent evt) {
  color_select.injectControlEvent(evt);
  
}