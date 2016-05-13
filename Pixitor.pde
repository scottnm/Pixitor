import controlP5.*;

ControlP5 ctrl;
ColorSelectWindow color_select;
CanvasWindow canvas; 

void setup() {
  size(800, 700);
  ctrl = new ControlP5(this);
  color_select = new ColorSelectWindow(ctrl, 0, 0, 100, 200);
  canvas = new CanvasWindow(100, 0, 700, 700);
}
void draw() {
  color_select.drawWindow();
  canvas.drawWindow();
}

void mousePressed() {
  color_select.injectMousePressed(mouseX, mouseY);
}

void controlEvent(ControlEvent evt) {
  color_select.injectControlEvent(evt);
}