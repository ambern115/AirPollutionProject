class ParticleSystem {
  ArrayList<Particle> particles; // all particles in this simulation 
  
  // x and y corresponding indexes are paired (x,y)
  Float[] x_coordinates; // x coordinates to generate particles from
  Float[] y_coordinates; // y coordinates to generate particles from
  Float[] amount_to_gen; // number of particles to generate for each source based on emission data
  int num_sources; // number of sources 
  int source_idx = 0; // index used in adding x and y coordinates to the emitter
                                 
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
  
  ParticleSystem(color c, int source_count) {
    x_vel = 0;
    y_vel = 0;
    upVel = 0;
    
    num_sources = source_count;
    
    x_coordinates = new Float[num_sources];
    y_coordinates = new Float[num_sources];
    amount_to_gen = new Float[num_sources];
    particles = new ArrayList(); // variable amount of particles
    
    p_color = c;
    num_p = 0;
    start_time = millis();
  }
  
  void addSource(float x, float y, float n_to_spawn) {
    if (source_idx >= num_sources) {
      println("Error! Tried adding too many sources");
    } else {
      x_coordinates[source_idx] = x;
      y_coordinates[source_idx] = y;
      amount_to_gen[source_idx] = n_to_spawn;
      source_idx++;
    }
  }
  
  // reduces the size of the 3 main arrays to save on memory
  void shrinkArrays(int real_n_sources) {
    // copy the existing arrays
    Float[] temp_x_coordinates = new Float[real_n_sources];
    Float[] temp_y_coordinates = new Float[real_n_sources];
    Float[] temp_amount_to_gen = new Float[real_n_sources];
    
    for (int i=0; i < real_n_sources; i++) {
      temp_x_coordinates[i] = x_coordinates[i];
      temp_y_coordinates[i] = y_coordinates[i];
      temp_amount_to_gen[i] = amount_to_gen[i];
    }
    
    // empty and resize main 3 arrays, and copy these values back over
    x_coordinates = new Float[real_n_sources];
    y_coordinates = new Float[real_n_sources];
    amount_to_gen = new Float[real_n_sources];
    
    for (int i=0; i < real_n_sources; i++) {
      x_coordinates[i] = temp_x_coordinates[i];
      y_coordinates[i] = temp_y_coordinates[i];
      amount_to_gen[i] = temp_amount_to_gen[i];
    }
    
    num_sources = real_n_sources;
  }
  
  void addParticle(float x, float y) {
    //PtVector vel = randomVel(); //<>//
    //vel.addVec(new PtVector(0,-1,0));
    Vector randPos = randomPosDisk(.5,x,y);
    //Vector vel = getCircPoint(.3,100,-300);
    Vector vel = new Vector(0,0,0);
    pushMatrix();
      Particle p = new Particle(randPos,vel,p_color);
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
  
  void spawnParticles(float x, float y, float num_to_gen) {   //<>//
    float temp_num_to_gen = num_to_gen; 
    
    if (num_to_gen > 1) {
      temp_num_to_gen = num_to_gen/2; // even it o
    }
    
    println(num_to_gen);
    //float num_p_to_gen = .25; //number of particles to generate
    
    if (random(1.01) < num_to_gen) {
      temp_num_to_gen += 1; 
    }
    for (int i=0; i < temp_num_to_gen; i++) {
      addParticle(x,y);
    } 
  }
  
  int getPCount() {
    return num_p;
  }
  
  void run() {
    // spawn particles for each x,y coordinate pair 
    for (int i=0; i < num_sources; i++) {
      spawnParticles(x_coordinates[i],y_coordinates[i],amount_to_gen[i]);
    }
    
    // run each particle
    for (int i = num_p-1; i > -1; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
        i--; num_p--;
      }
    }
  }
}
