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
PImage mapsample;

// particle system variables

int p_count = 0;
ArrayList<ParticleSystem> emitters; // can initialize to a constant size once data is in


// object to store the data
Table pollutionData;

// set variables regarding the map latitude and longitude
Float minLat = 44.876780; //bottom
Float maxLat = 44.998441; //top
Float minLong = -93.228638; //left
Float maxLong = -92.989036; //right
int maxX = 3400;
int maxY = 4000;

PImage smoke;
PImage arrow;

PFont font;


void setup() {
  // fullscreen
  size(1200, 800, P3D);
  surface.setTitle("Community Engagement for Air Pollution Reduction in St. Paul");
  startTime = millis();

  smoke = loadImage("smoke.png");
  arrow = loadImage("arrow.png");
  arrow.resize(40,40);

  font = createFont("AGaramondPro-Regular.otf", 22);

  pollutionData = loadTable("PointSourceAirEmissionsInventory/MPCA_PointSourceEmissionInventory_Ramsey.csv", "header");

  mapsample = loadImage("sample.png");

  emitters = new ArrayList();

  // initialize all of the particle emitters

  //ParticleSystem ps1 = new ParticleSystem(0,0,color(130,50,50),255,1,500,500);
  //ParticleSystem ps2 = new ParticleSystem(0,0,color(0,0,0),255,1,200,200);
  //ParticleSystem ps3 = new ParticleSystem(0,0,color(130,50,50),255,1,150,50);

  //emitters.add(ps1);
  //emitters.add(ps2);
  //emitters.add(ps3);


  for (int i=0; i<pollutionData.getRowCount(); i++) {
    TableRow row = pollutionData.getRow(i);
    int year = row.getInt("YEAR");
    String facility = row.getString("FACILITY_NAME");
    String pollutant = row.getString("POLLUTANT");
    Float emissionsTons = row.getFloat("EMISSIONS (TONS)");
    String county = row.getString("COUNTY");
    Float longitude = row.getFloat("LONGITUDE");
    Float latitude = row.getFloat("LATITUDE");
    if (latitude < maxLat && latitude > minLat && longitude < maxLong && longitude > minLong
      && year == 2017) {
      Float x = ((longitude-minLong)/(maxLong-minLong))*maxX;
      Float y = ((maxLat-latitude)/(maxLat-minLat))*maxY;
      if (checkForSource(x, y)) {
        emitters.add(new ParticleSystem(0, 0, color(0, 0, 0), 255, 1, x, y));
      }
    }
  }
}

// checks to see if source exists or not?
boolean checkForSource(float x, float y) {
  ParticleSystem temp_ps;
  for (int i=0; i < emitters.size(); i++) {
    temp_ps = emitters.get(i);
    if (temp_ps.location_x == x && temp_ps.location_y == y) {
      return false;
    }
  }
  return true;
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
  zoom = e*-18+zoom;
}

// translates the camera on x and y axis
void translate_cam() {
  if (mouse_lf_pressed) {
    move_x = (mouseX - x_start)*0.8; // distance mouse moved in x direction
    move_y = (mouseY - y_start)*0.8; // distance mouse mvoed in y direction
  }
}

// displays everything that overlays the screen 
void displayHUD() {
  fill(0,0,0);
  rect(400, 45, 50, 50);
  image(arrow,415,50);
  
  fill(246, 246, 246);
  rect(200, 20, 225, 750, 7);

  textFont(font);

  fill(230, 230, 230);
  rect(210, 35, 206, 270, 7);
  fill(72, 73, 150);
  rect(210, 35, 206, 30, 7, 7, 0, 0);
  textSize(20);
  fill(246, 246, 246);
  text("Clean Air Act", 258, 57);

  fill(230, 230, 230);
  rect(210, 325, 206, 114, 7);
  fill(150, 69, 69);
  rect(210, 325, 206, 30, 7, 7, 0, 0);
  fill(246, 246, 246);
  text("Health & Lead", 250, 347);
}

void draw() {
  elapsedTime = (millis() - startTime) / 1000.0;
  startTime = millis();
  background(220, 220, 220);

  if (zoom > -18) {
    zoom = -18;
  }

  noStroke();

  translate_cam();

  beginCamera();
  float camz = (height/2.0) / tan(PI*30.0 / 180.0);
  camera(width/2.0, height/2.0, camz, 
    width/2.0, height/2.0, 0, 
    0, 1, 0);
  // increase vision distance
  perspective(PI/3.0, width/height, camz/10.0, camz*20.0);
  displayHUD();
  translate(cam_pos_x+move_x, cam_pos_y+move_y, zoom);
  endCamera();

  beginShape(); 
  texture(mapsample);
  vertex(0, 0, -10, 0);
  vertex(3400, 0, -10, mapsample.width, 0);
  vertex(3400, 4000, -10, mapsample.width, mapsample.height);
  vertex(0, 4000, -10, 0, mapsample.height);
  endShape();

  pushMatrix();
  for (int i=0; i < emitters.size(); i++) {
    emitters.get(i).run();

    p_count += emitters.get(i).getPCount();
  }
  popMatrix();



  //beginShape(); //(1,4)
  //  texture(map1);
  //  vertex(0,0,-10,0,0);
  //  vertex(514,0,-10,map1.width,0);
  //  vertex(514,648,-10,map1.width,map1.height);
  //  vertex(0,648,-10,0,map1.height);
  //endShape();
  //beginShape(); //(2,4)
  //  texture(map2);
  //  vertex(514,0,-10,0,0);
  //  vertex(1028,0,-10,map1.width,0);
  //  vertex(1028,648,-10,map1.width,map1.height);
  //  vertex(514,648,-10,0,map1.height);
  //endShape();
  //beginShape(); //(2,4)
  //  texture(map3);
  //  vertex(1028,0,-10,0,0);
  //  vertex(1542,0,-10,map1.width,0);
  //  vertex(1542,648,-10,map1.width,map1.height);
  //  vertex(1028,648,-10,0,map1.height);
  //endShape();
}
