class ParticleSystem {
  ArrayList<Particle> particles; // all particles in this simulation 
  
  // x and y corresponding indexes are paired (x,y)
  Float[] x_coordinates; // x coordinates to generate particles from
  Float[] y_coordinates; // y coordinates to generate particles from
  Float[] amount_to_gen; // number of particles to generate for each source based on emission data
  String[] company_names;
  String[] main_pollutants; //3 pollutants getting released the most from the source
  
  ArrayList<ArrayList<ArrayList<String>>> pollutant_search; // temporary. Used to detmine top 3 biggest pollutants
  
   
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
    company_names = new String[num_sources];
    pollutant_search = new ArrayList();
    main_pollutants = new String[num_sources];
    
    particles = new ArrayList(); // variable amount of particles
    
    p_color = c;
    num_p = 0;
    start_time = millis();
  }
  
  void addSource(float x, float y, float n_to_spawn, String name, String pollutant) {
    if (source_idx >= num_sources) {
      println("Error! Tried adding too many sources");
    } else {
      x_coordinates[source_idx] = x;
      y_coordinates[source_idx] = y;
      amount_to_gen[source_idx] = n_to_spawn;
      company_names[source_idx] = name;
      
      ArrayList<ArrayList<String>> pairs = new ArrayList();
      ArrayList<String> name_amt_pair = new ArrayList();
      name_amt_pair.add(pollutant);
      name_amt_pair.add(str(n_to_spawn));
      pairs.add(name_amt_pair);
      pollutant_search.add(pairs); 
      
      source_idx++;
    }
  }
  
  // returns string of the top 3 biggest pollutants for a source
  String findMainPollutants(int idx) {
    float n1 = 0; String s1 = "";
    float n2 = 0; String s2 = "";
    float n3 = 0; String s3 = "";
    
    for (int i=0; i < pollutant_search.get(idx).size(); i++) {
      if (float(pollutant_search.get(idx).get(i).get(1)) > n1) {
        n1 = float(pollutant_search.get(idx).get(i).get(1));
        s1 = pollutant_search.get(idx).get(i).get(0);
      } else if (float(pollutant_search.get(idx).get(i).get(1)) > n2) {
        n2 = float(pollutant_search.get(idx).get(i).get(1));
        s2 = pollutant_search.get(idx).get(i).get(0);
      } else if (float(pollutant_search.get(idx).get(i).get(1)) > n3) {
        n3 = float(pollutant_search.get(idx).get(i).get(1));
        s3 = pollutant_search.get(idx).get(i).get(0);
      }
    }
    
    String three_pollutants = s1;
    if (s2 != "") {
      three_pollutants += ", " + s2;
    } 
    if (s3 != "") {
      three_pollutants += ", " + s3;
    }
    
    return three_pollutants;
  }
  
  // reduces the size of the 3 main arrays to save on memory
  void shrinkArrays(int real_n_sources) {
    // copy the existing arrays
    Float[] temp_x_coordinates = new Float[real_n_sources];
    Float[] temp_y_coordinates = new Float[real_n_sources];
    Float[] temp_amount_to_gen = new Float[real_n_sources];
    String[] temp_company_names = new String[real_n_sources];
    
    for (int i=0; i < real_n_sources; i++) {
      temp_x_coordinates[i] = x_coordinates[i];
      temp_y_coordinates[i] = y_coordinates[i];
      temp_amount_to_gen[i] = amount_to_gen[i];
      temp_company_names[i] = company_names[i];
    }
    
    // empty and resize main 3 arrays, and copy these values back over
    x_coordinates = new Float[real_n_sources];
    y_coordinates = new Float[real_n_sources];
    amount_to_gen = new Float[real_n_sources];
    company_names = new String[real_n_sources];
    main_pollutants = new String[real_n_sources];
    
    for (int i=0; i < real_n_sources; i++) {
      x_coordinates[i] = temp_x_coordinates[i];
      y_coordinates[i] = temp_y_coordinates[i];
      amount_to_gen[i] = temp_amount_to_gen[i];
      company_names[i] = temp_company_names[i];
      main_pollutants[i] = findMainPollutants(i);
    }
    
    num_sources = real_n_sources;
    pollutant_search = new ArrayList(); // clear memory
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
    
    //if (num_to_gen > 1) {
    //  temp_num_to_gen = num_to_gen/2; // even it o
    //}
    
    if (num_to_gen > 10000) {
      num_to_gen = 10;
    } else if (num_to_gen > 7000) {
      num_to_gen = 6;
    } else if (num_to_gen > 3000) {
      num_to_gen = 4;
    } else if (num_to_gen > 100) {
      num_to_gen = 2;
    } else if (num_to_gen < 1) {
      num_to_gen = 0.5;
    } else {
      num_to_gen = 1.5;
    }
    
    
    //find a way to standardize size
    
   
    ////float num_p_to_gen = .25; //number of particles to generate
    //float rand = random(1.01);
    //if (rand < temp_num_to_gen) {
    //  temp_num_to_gen += 1; 
    //}
    
    for (int i=0; i < (int)num_to_gen; i++) {
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
