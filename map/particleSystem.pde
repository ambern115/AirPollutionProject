class ParticleSystem {
  ArrayList<Particle> particles;
  Vector origin;
  Vector gravity = new Vector(0,0.1,0);
  int num_p;
  float start_time;
  float genRate = 2;
  float upVel;
  float outVel1;
  float outVel2;
  float zVel1;
  float zVel2;
  
  float x_vel = 0, y_vel = 0;
  float density = 0.5;
  float transp = 255;
  color p_color = color(0,0,0);
  
  float location_x;
  float location_y;
  
  
  ParticleSystem(float upv, float outv1, float outv2, float zv1, float zv2) {
    upVel = upv;
    outVel1 = outv1;
    outVel2 = outv2;
    zVel1 = zv1;
    zVel2 = zv2;
    particles = new ArrayList();
    num_p = 0;
    start_time = millis();
    
  }
  
  ParticleSystem(float upv) {
    upVel = upv;
    particles = new ArrayList();
    num_p = 0;
    start_time = millis();
    
  }
  
  ParticleSystem(float x_v, float y_v, color c, float trans, float dens, float x, float y) {
    x_vel = x_v;
    y_vel = y_v;
    transp = trans;
    density = dens;
    upVel = 0;
    location_x = x;
    location_y = y;
    
    p_color = c;
    
    particles = new ArrayList();
    num_p = 0;
    
    start_time = millis();
  }
  
  void addParticle() {
    //PtVector vel = randomVel(); //<>//
    //vel.addVec(new PtVector(0,-1,0));
    Vector randPos = randomPosDisk(.5,location_x,location_y);
    //Vector vel = getCircPoint(.3,100,-300);
    Vector vel = new Vector(0,0,0);
    pushMatrix();
    Particle p = new Particle(randPos,vel,p_color);
    //p.applyForce(new PtVector(gravity.x,gravity.y,gravity.z)); // always apply gravity
    translate(0,0,35);
    particles.add(p); //<>//
    popMatrix();
    num_p++;
  }
  
  // can be used for wind
  void applyForce(Vector f) {
    for (int i = 0; i < num_p; i++) {
      particles.get(i).applyForce(new Vector(f.x,f.y,f.z));
    }
  }
  
  // uniform rectangle/square sample for initial position
  Vector randomPos(float w, float h) { 
    float x = w * random(1.01);
    float z = h * random(1.01);
    // or y...
    return new Vector(x, 0, z);
  }
  
  // generates a random point along the circumference of a circle
  Vector getCircPoint(float r, float cx, float cz) {
    float angle = random(1.01)*PI*2;
    float newx = cos(angle)*r;
    float newz = sin(angle)*r;
    return new Vector(newx, upVel, newz);
  }
  
  Vector randomPosDisk(float r, float cx, float cy) {
    float a = random(1.01);
    float b = random(1.01);
    float x = cx + r*sqrt(a) * cos(2*PI*b);
    float y = cy + r*sqrt(a) * sin(2*PI*b);
    return new Vector(x,y,0);
  }
  
  Vector randomVel() {
    // along an arc or disk!
   // PtVector vel
   Vector vel = new Vector(0, random(upVel-1,upVel), 0); // initial up vector
   //perturb velocity
   vel.addV(new Vector(random(outVel1,outVel2),0,random(zVel1,zVel2)));
   return vel;
  }
  
  void spawnParticles() { //<>//
    float num_p_to_gen = 3; //number of particles to generate
    
    if (random(1.01) < num_p_to_gen) {
      num_p_to_gen += 1; 
    }
    for (int i=0; i < num_p_to_gen; i++) {
      addParticle();
    }
  }
  
  int getPCount() {
    return num_p;
  }
  
  void run() {
    spawnParticles();
    for (int i = 0; i < num_p; i++) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
        i--; num_p--;
      }
    }
  }
}
