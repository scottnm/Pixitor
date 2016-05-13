public class CanvasWindow {
  CanvasWindow(int pos_x, int pos_y, int _width, int _height) {
    m_pos_x = pos_x;
    m_pos_y = pos_y;
    m_width = _width;
    m_height = _height;
  }
  
  void drawWindow() {
    pushStyle();
    pushMatrix();
    translate(m_pos_x, m_pos_y);
    fill(255);
    rect(0, 0, m_width, m_height);
    popMatrix();
    popStyle();
  }
  
  int m_pos_x;
  int m_pos_y;
  int m_width;
  int m_height;
  
  // vector of layers to draw
}