// navigation variables
boolean mouse_lf_pressed = false; // left mouse button
float x_start, y_start;
float zoom;
float move_x, move_y;
float cam_pos_x, cam_pos_y;

boolean sim_started = false; // starts the visualization
double startTime; // time of start of visulization
double elapsedTime;

// map pieces
PImage map1;

void setup() {
  // fullscreen
  size(1000, 600, P3D);
  surface.setTitle("Community Engagement for Air Pollution Reduction in St. Paul");
  startTime = millis();
  
  map1 = loadImage("map1.JPG");
}

void keyPressed() {
  if (keyCode == ENTER && !sim_started) {
    sim_started = !sim_started;
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    mouse_lf_pressed = true;
    x_start = mouseX;
    y_start = mouseY;
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    mouse_lf_pressed = false;
    cam_pos_x += move_x;
    cam_pos_y += move_y;
    move_x = 0;
    move_y = 0;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom = e*-50+zoom;
}

// translates the camera on x and y axis
void translate_cam() {
  if (mouse_lf_pressed) {
    move_x = (mouseX - x_start)*2; // distance mouse moved in x direction
    move_y = (mouseY - y_start)*2; // distance mouse mvoed in y direction
  }
}

// displays everything that overlays the screen 
void displayHUD() {
  textSize(14);
  fill(0,0,0);
  text("                          test",500,500);
}

void draw() {
  elapsedTime = (millis() - startTime) / 1000.0;
  startTime = millis();
  background(230,230,230);
  
  noStroke();
  
  translate_cam();
  
  beginCamera();
    float camz = (height/2.0) / tan(PI*30.0 / 180.0);
    camera(width/2.0, height/2.0, camz,  
          width/2.0, height/2.0,  0,
            0, 1, 0);
    // increase vision distance
    //perspective(PI/3.0, width/height, camz/10.0, camz*20.0);
    displayHUD();
    translate(cam_pos_x+move_x,cam_pos_y+move_y,zoom);
  endCamera();
  
  beginShape(); //map1
    texture(map1);
    vertex(0,0,-500,0,0);
    vertex(800,0,-500,map1.width,0);
    vertex(800,600,-500,map1.width,map1.height);
    vertex(0,600,-500,0,map1.height);
  endShape();
}
