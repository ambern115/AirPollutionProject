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
ParticleSystem emitter; // emits all of the smoke particles

// object to store the data
Table pollutionData;

// set variables regarding the map latitude and longitude
Float minLat = 44.876780; //bottom
Float maxLat = 44.998441; //top
Float minLong = -93.228638; //left
Float maxLong = -92.989036; //right
int maxX = 5581;
int maxY = 4000;

PImage smoke;
PImage arrow;

PFont font;


void setup() {
  // fullscreen...
  size(1320, 660, P3D);
  surface.setTitle("Community Engagement for Air Pollution Reduction in St. Paul");
  startTime = millis();

  smoke = loadImage("smoke.png");
  arrow = loadImage("arrow.png");
  arrow.resize(40,40);

  font = createFont("AGaramondPro-Regular.otf", 22);

  pollutionData = loadTable("PointSourceAirEmissionsInventory/MPCA_PointSourceEmissionInventory_Ramsey.csv", "header");

  mapsample = loadImage("sample.png");

  int num_sources = pollutionData.getRowCount();
  int real_num_sources = 0; // actual number of unique pollution sources
  emitter = new ParticleSystem(color(0,0,0), num_sources);
  
  for (int i=0; i < num_sources; i++) {
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
      
      if (!checkForSource(x,y)) { // if source does not already exist, add it
        // add new coordinates and emission amount to the emitter
        emitter.addSource(x,y,emissionsTons); // TODO: emissionsTons needs to be standardized
        real_num_sources++;
      }
    }
  }
  
  emitter.shrinkArrays(real_num_sources);
}

// checks to see if source exists or not
boolean checkForSource(float x, float y) {
  for (int i=0; i < emitter.source_idx; i++) { 
    if (emitter.x_coordinates[i] == x && emitter.y_coordinates[i] == y) {
      return true;
    }
  }
  return false;
}

boolean space_hit = false;

void keyPressed() {
  if (keyCode == ENTER && !sim_started) {
    sim_started = !sim_started;
  } else if (keyCode == 32) {
      space_hit = !space_hit;
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
  //fill(0,0,0);
  //rect(400, 45, 50, 50);
  //image(arrow,415,50);
  
  //fill(246, 246, 246);
  //rect(200, 20, 225, 750, 7);

  //textFont(font);

  //fill(230, 230, 230);
  //rect(210, 35, 206, 270, 7);
  //fill(72, 73, 150);
  //rect(210, 35, 206, 30, 7, 7, 0, 0);
  //textSize(20);
  //fill(246, 246, 246);
  //text("Clean Air Act", 258, 57);

  //fill(230, 230, 230);
  //rect(210, 325, 206, 114, 7);
  //fill(150, 69, 69);
  //rect(210, 325, 206, 30, 7, 7, 0, 0);
  //fill(246, 246, 246);
  //text("Health & Lead", 250, 347);
  
  
  fill(0,0,0);
  circle(1000,600,50);
}

int max_p_count = 0;

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

  // previous map z value was at -10
  // 3400 x 4000 --> 5581 x 4000
  
  //beginShape(); 
  //texture(mapsample);
  //vertex(0, 0, -10, 0);
  //vertex(5581, 0, -10, mapsample.width, 0);
  //vertex(5581, 4000, -10, mapsample.width, mapsample.height);
  //vertex(0, 4000, -10, 0, mapsample.height);
  //endShape();

  pushMatrix();
    emitter.run();
  popMatrix(); 
  
  //if (emitter.num_p > max_p_count) {
  //  max_p_count = emitter.num_p;
  //}
  //println(max_p_count);
 //  pushMatrix();
  //    for (int i=0; i < emitters.size(); i++) {
  //      emitters.get(i).applyForce(new Vector(0,0,0));
  //    }
  //  popMatrix();
  //}
  
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
