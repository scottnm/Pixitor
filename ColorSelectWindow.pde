class ColorSelectWindow {
  ColorSelectWindow(int pos_x, int pos_y, int _width, int _height) {
    m_pos_x = pos_x;
    m_pos_y = pos_y;
    m_width = _width;
    m_height = _height;
  }
  
  void injectMousePressed(float mouse_pos_x, float mouse_pos_y) {
  }
  
  void drawWindow() {
    pushStyle();
    fill(80);
    rect(m_pos_x, m_pos_y, m_width, m_height);
    popStyle();
  }
  
  int m_pos_x;
  int m_pos_y;
  int m_width;
  int m_height;
}