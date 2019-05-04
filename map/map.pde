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

// define images
PImage smoke_1, smoke_2, smoke_3, smoke_4, smoke_5;
PImage smoke_6, smoke_7, smoke_8, smoke_9, smoke_10;
PImage smoke_11, smoke_12, smoke_13, smoke_14;
PImage arrow;

// set up variables to print regarding locations
String printFacility = "";
String printPollutant = "";
Float printEmissions = 0.0;

// set up fonts
PFont font;
PFont subFont;


void setup() {
  // fullscreen...
  size(1590, 795, P3D);
  surface.setTitle("Community Engagement for Air Pollution Reduction in St. Paul");
  startTime = millis();

  smoke_1 = loadImage("smoke.png");
  smoke_2 = loadImage("smoke.png");
  smoke_3 = loadImage("smoke.png");
  smoke_4 = loadImage("smoke.png");
  smoke_5 = loadImage("smoke.png");
  smoke_6 = loadImage("smoke.png");
  smoke_7 = loadImage("smoke.png");
  smoke_8 = loadImage("smoke.png");
  smoke_9 = loadImage("smoke.png");
  smoke_10 = loadImage("smoke.png");
  smoke_11 = loadImage("smoke.png");
  smoke_12 = loadImage("smoke.png");
  smoke_13 = loadImage("smoke.png");
  smoke_14 = loadImage("smoke.png");
  
  smoke_1.resize(10,10);
  smoke_2.resize(15,15);
  smoke_3.resize(20,20);
  smoke_4.resize(26,26);
  smoke_5.resize(37,37);
  smoke_6.resize(48,48);
  smoke_7.resize(58,58);
  smoke_8.resize(70,70);
  smoke_9.resize(81,82);
  smoke_10.resize(92,92);
  smoke_11.resize(100,100);
  smoke_12.resize(108,108);
  smoke_13.resize(116,116);
  smoke_14.resize(124,124);
  
  arrow = loadImage("arrow.png");
  arrow.resize(40,40);

  font = createFont("AGaramondPro-Regular.otf", 22);
  subFont = createFont("AGaramondPro-Regular.otf", 14);

  pollutionData = loadTable("PointSourceAirEmissionsInventory/MPCA_PointSourceEmissionInventory_Ramsey.csv", "header");

  mapsample = loadImage("sample.png");

  int num_sources = pollutionData.getRowCount();
  int real_num_sources = 0; // actual number of unique pollution sources
  emitter = new ParticleSystem(color(0,0,0), num_sources);
  
  for (int i=0; i < num_sources; i++) {
    TableRow row = pollutionData.getRow(i);
    int year = row.getInt("YEAR");
    Float emissionsTons = row.getFloat("EMISSIONS (TONS)");
    Float longitude = row.getFloat("LONGITUDE");
    Float latitude = row.getFloat("LATITUDE");
    String company = row.getString("FACILITY_NAME");
    String pollutant = row.getString("POLLUTANT");
    if (latitude < maxLat && latitude > minLat && longitude < maxLong && longitude > minLong
      && year == 2017) {
      Float x = ((longitude-minLong)/(maxLong-minLong))*maxX;
      Float y = ((maxLat-latitude)/(maxLat-minLat))*maxY;
      
      if (!checkForSource(x,y,emissionsTons,company,pollutant)) { // if source does not already exist, add it
        // add new coordinates and emission amount to the emitter
        emitter.addSource(x,y,emissionsTons,company,pollutant); 
        real_num_sources++;
      }
    }
  }
  
  emitter.shrinkArrays(real_num_sources);
}

// checks to see if source exists or not
boolean checkForSource(float x, float y, float e, String name, String pollutant) {
  for (int i=0; i < emitter.source_idx; i++) { 
    if (emitter.x_coordinates[i] == x && emitter.y_coordinates[i] == y) {
      // add the emission amount to the already existing emissions amt for this source
      emitter.amount_to_gen[i] += e;
      
      ArrayList<String> temp_al = new ArrayList();
      temp_al.add(pollutant); 
      temp_al.add(name);
      emitter.pollutant_search.get(i).add(temp_al);
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
    
    Float minDistance = 999999.0;
    String minFacility = "";
    String minPollutant = "";
    Float minEmissions = 0.0;
    
    float true_x = (mouseX-(cam_pos_x))/zoom;
    float true_longitude = (true_x * (maxLong-minLong))/maxX + minLong;
    float true_y = (mouseY-(cam_pos_y))/zoom;
    float true_latitude = -1*((true_y*(maxLat-minLat))/maxY)+maxLat;
    println(true_latitude + ", " + true_longitude);
    
    
  }
    
  //  for (int i=0; i<pollutionData.getRowCount(); i++) {
  //    TableRow row = pollutionData.getRow(i);
  //    int year = row.getInt("YEAR");
  //    String facility = row.getString("FACILITY_NAME");
  //    String pollutant = row.getString("POLLUTANT");
  //    Float emissionsTons = row.getFloat("EMISSIONS (TONS)");
  //    Float longitude = row.getFloat("LONGITUDE");
  //    Float latitude = row.getFloat("LATITUDE");
  //    if (latitude < maxLat && latitude > minLat && longitude < maxLong && longitude > minLong
  //      && year == 2017) {
  //      Float x = ((longitude-minLong)/(maxLong-minLong))*maxX;
  //      Float y = ((maxLat-latitude)/(maxLat-minLat))*maxY;
  //      Float distance = sqrt(pow((mouseX-x),2)+pow((mouseY-y),2));
  //      if(distance < minDistance) {
  //        print("mousex: " + mouseX + ", mousey: " + mouseY + "\n");
  //        print("x: " + x + ", y: " + y + "\n");
  //        minFacility = facility;
  //        minPollutant = pollutant;
  //        minEmissions = emissionsTons;
  //        minDistance = distance;
  //      }
  //    }
  //  }
  //  printFacility = minFacility;
  //  printPollutant = minPollutant;
  //  printEmissions = minEmissions;
  //}
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
  //initial panel setup
  fill(246, 246, 246);
  rect(0, 0, 225, 660);

  //personal actions box
  //header
  fill(47, 48, 94);
  rect(9, 10, 207, 30, 0, 0, 0, 0);
  textFont(font);
  fill(246, 246, 246);
  text("Personal Actions", 40, 32);
  //box
  fill(230, 230, 230);
  rect(9, 40, 207, 270);
  textFont(subFont);
  fill(0,0,0);
  text("- Bike, Walk, Take Public Transit", 15, 60);
  text("- Install Solar Panels", 15, 80);
  text("- Don't Burn Leaves/Trash", 15, 100);
  text("- Plant Trees", 15, 120);
  text("- Choose Energy-Efficient Appliances", 15, 140);
  text("- Limit City Campfires", 15, 160);
  text("- Advocate for Education/Programs:", 15, 180);
  text("   - Small Business Environmental", 15, 200);
  text("     Assistance Program", 15, 220);
  text("   - GreenStep Cities", 15, 240);
  text("   - Minnesota GreenCorps", 15, 260);
  text("- More Information At:", 15, 280);
  text("  https://bit.ly/2vygYfg", 15, 300);

  //health impacts box
  //header
  fill(104, 104, 104);
  rect(9, 325, 207, 30, 0, 0, 0, 0);
  textFont(font);
  fill(246, 246, 246);
  text("Health Effects", 55, 348);
  //box
  fill(230, 230, 230);
  rect(9, 355, 207, 114);
  textFont(subFont);
  fill(0,0,0);
  text("Air pollution can trigger issues for those with asthma or COPD and can increase risk of respiratory infections, heart disease, stroke, and lung cancer. More info at: https://bit.ly/2VA6j2d",15,362,200,110);
  
  //box upon click
  //header
  fill(212, 119, 119);
  rect(9, 485, 207, 30, 0, 0, 0, 0);
  textFont(font);
  fill(246, 246, 246);
  text("Location Information", 18, 506);
  //box
  fill(230, 230, 230);
  rect(9, 515, 207, 135);
  textFont(subFont);
  fill(0,0,0);
  text("Facility:", 15, 525, 200, 130);
  text(printFacility, 15, 545, 200, 130);
  text("Pollutant:", 15, 565, 200, 130);
  text(printPollutant, 15, 585, 200, 130);
  text("Emissions (Tons):", 15, 605, 200, 130);
  text(str(printEmissions), 15, 625, 200, 130);
  
  //compass
  fill(0,0,0);
  circle(1250,600,50);
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
  

  beginShape();
  tint(255,255,255,255);
  texture(mapsample);
  vertex(0, 0, -10, 0);
  vertex(5581, 0, -10, mapsample.width, 0);
  vertex(5581, 4000, -10, mapsample.width, mapsample.height);
  vertex(0, 4000, -10, 0, mapsample.height);
  endShape();


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
