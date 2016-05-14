public class CanvasWindow {
  CanvasWindow(int pos_x, int pos_y, int _width, int _height) {
    m_pos_x = pos_x;
    m_pos_y = pos_y;
    m_width = _width;
    m_height = _height;
    
    canvasBuffer = createImage(m_width, m_height, RGB);
    canvasBuffer.loadPixels();
    for(int i = 0; i < canvasBuffer.pixels.length; ++i) {
      canvasBuffer.pixels[i] = color(0,0,0,1);
    }
    canvasBuffer.updatePixels();
    
    transparencyBuffer = createImage(m_width, m_height, RGB);
    loadTransparencyGridIntoBuffer(transparencyBuffer);
  } 
  
  void drawWindow() {
    pushStyle();
    pushMatrix();
    translate(m_pos_x, m_pos_y);
    image(transparencyBuffer, 0, 0);
    image(canvasBuffer, 0, 0);
    popMatrix();
    popStyle();
  }
  
  boolean withinWindow(int x, int y) {
    return x >= m_pos_x && x <= (m_pos_x + m_width)
      && y >= m_pos_y && y <= (m_pos_y + m_height);
  }
  
  void paint(int x, int y, color c) {
    int localx = (x - m_pos_x) / 7;
    int localy = (y - m_pos_y) / 7;
    System.out.printf("painting at (%d, %d)\n", localx, localy);
    draw7x7square(canvasBuffer, localx, localy, c);
  }
  
  private void loadTransparencyGridIntoBuffer(PImage buf) {
    color onColor;
    color offColor;
    for(int i = 0; i < 100; ++i) {
      if (i % 2 == 0) {
        onColor = color(100, 100, 100, 100);;
        offColor = color(200, 200, 200, 100);
      }
      else {
        onColor = color(200, 200, 200, 100);
        offColor = color(100, 100, 100, 100);;
      }
      
      for(int j = 0; j < 100; j+=2) {
        draw7x7square(buf, i, j, onColor);
      }
      
      for(int j = 1; j < 100; j+=2) {
        draw7x7square(buf, i, j, offColor);
      }
      
    }
  }
  
  private void draw7x7square(PImage buf, int _x, int _y, color c) {
    int ibound = (_x*7) + 7;
    int jbound = (_y*7) + 7;
    for (int i = _x * 7; i < ibound; ++i) {
      for (int j = _y * 7; j < jbound; ++j) {
        buf.set(i, j, c);
      }
    }
  }
  
  private PImage transparencyBuffer;
  private PImage canvasBuffer;
  
  private int m_pos_x;
  private int m_pos_y;
  private int m_width;
  private int m_height;
  
  /* vector of layers to draw; draw each one on top of the other
     if pixel exists in next layer override old pixel */
  // function to draw the grid on top of the window
}