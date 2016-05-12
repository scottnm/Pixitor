ColorSelectWindow color_select;

void setup() {
  size(800, 800);
  color_select = new ColorSelectWindow(0, 0, 200, 200);
}

void draw() {
  color_select.drawWindow();
}

void mousePressed() {
  color_select.injectMousePressed(mouseX, mouseY);
}