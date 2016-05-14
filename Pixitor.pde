import controlP5.*;

ControlP5 ctrl;
ColorSelectWindow color_select;
CanvasWindow canvas;
static color empty;

void setup() {
  size(800, 700);
  ctrl = new ControlP5(this);
  color_select = new ColorSelectWindow(ctrl, 0, 0, 100, 200);
  canvas = new CanvasWindow(100, 0, 700, 700);
  empty = color(200);
}
void draw() {
  fill(empty);
  rect(0,0,800,700);
  color_select.drawWindow();
  canvas.drawWindow();
}

void mouseDragged() {
  /*
  if (canvas.withinWindow(pmouseX, pmouseY)) {
    int del_x = mouseX - pmouseX;
    int del_y = mouseY - pmouseY;
    color c = color_select.getColor();
    
    if (del_x == 0 && del_y == 0) {
      println("del x and y == 0");
      canvas.paint(mouseX, mouseY, c);
    }
    
    else if (del_x == 0) {
      println("del x is 0");
      if (del_y > 0) {
        int inc = max(del_y / 10, 1);
        for(int y = pmouseY; y < mouseY; y += inc) {
          canvas.paint(mouseX, y, c);
        }
      }
      else {
        int dec = min(del_y / 10, -1);
        for(int y = pmouseY; y > mouseY; y += dec) {
          canvas.paint(mouseX, y, c);
        }
      }
    }
    else {
      int m = del_y / del_x;
      int b = mouseY - (m * mouseX);
      println("m,b is (%d, %d)", m, b);

      for(int r = 1; r <= 10; ++r) {
        int delxt = (del_x * r) / 10;
        int delytplusb = ((del_y * r) / 10) + b;
        canvas.paint(delxt, delytplusb, c);
      }
    }
  }
  */
  canvas.paint(pmouseX, pmouseY, color_select.getColor());
}

void controlEvent(ControlEvent evt) {
  color_select.injectControlEvent(evt);
}