import controlP5.*;

ControlP5 ctrl;
ColorSelectWindow color_select;

void setup() {
  size(800, 800);
  ctrl = new ControlP5(this);
  color_select = new ColorSelectWindow(ctrl, 0, 0, 100, 200);
}
void draw() {
  color_select.drawWindow();
}

void mousePressed() {
  color_select.injectMousePressed(mouseX, mouseY);
}

void controlEvent(ControlEvent evt) {
  color_select.injectControlEvent(evt);
}