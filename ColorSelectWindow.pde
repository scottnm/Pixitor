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
    pushMatrix();
    translate(m_pos_x, m_pos_y);
    fill(80);
    rect(0, 0, m_width, m_height);
    
    // draw the text
    fill(0);
    textSize(32);
    text("R:", 10, 80);
    text("G:", 10, 130);
    text("B:", 10, 180);
    
    // color preview
    fill(m_r, m_g, m_b);
    rect(0, 0, m_width, 30);

    popMatrix();
    popStyle();
  }
  
  int m_pos_x;
  int m_pos_y;
  int m_width;
  int m_height;
  
  // color spec
  int m_r;
  int m_g;
  int m_b;
}