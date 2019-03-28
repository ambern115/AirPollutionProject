class Particle {
  
  Vector location;
  Vector velocity;
  Vector acceleration;
  
  color p_color;
  float mass = 2;
  float radius = 3;
  
  float life_span = 245;
  boolean start_death = false;
  PShape particle;
  float start_time;
  
  float fade = 0;
  boolean edge = false;

  // default
  Particle() {
    location = new Vector(width/2,10,random(-2,0));
    acceleration = new Vector(0,0.05,0);
    velocity = new Vector(random(-1,1),random(-2,0),random(-4,0));

    start_time = millis();
  }
  
  // given a starting location
  Particle(Vector l) {
    location = l;
    acceleration = new Vector(0,0.05,0);
    velocity = new Vector(random(-1,1),random(-2,0),random(-4,0));
    start_time = millis();
  }
  
  // given a starting location, starting velocity, and color
  Particle(Vector l, Vector vel, color c) {
    location = l;
    acceleration = new Vector(0,0.05,0);
    velocity = vel;
    particle = createShape(ELLIPSE,0, 0, radius, radius+4);
    
    float randx = random(0.1,1);
    float randy = random(0.1,1);
    
    p_color = c;
    
    applyForce(new Vector(randx,randy,0));
    
    if (randx > 0.8 && randy <0.4 || randx < 0.4 && randy > 0.8 ) {
      edge = true;
    } 
    
    start_time = millis();
  }
  
  // given a starting location and color
  Particle(Vector l, color c) {
    location = l;
    acceleration = new Vector(0,0.05,0);
    velocity = new Vector(random(-1,1),random(-2,0),random(-4,0));
   
    start_time = millis();
  }
  
  // deterimines if the particle should be deleted
  boolean isDead() {
    if (life_span < 0.0) {
      return true;
    } else {
      return false;
    }
  }
  
  // apply a force to particle
  void applyForce(Vector force) {
    Vector f = force;
    f.divByCon(mass);
    acceleration.addV(f);
  }
  
  
  Vector gravity = new Vector(0,0.2,0);
  
  
  
  void update() {
    float dt = millis() - start_time; // why is this not used, how is this working?
    
    float chance = random(0,0.05);
    if (chance > 0.03) {
      float xchance = random(0,1);
      if (xchance > 0.5) {
        velocity.x += chance;
      } else {
        velocity.y += chance;
      }
    }

    velocity.addV(acceleration);
   
    location.addV(velocity); 
    
    //velocity.addV(gravity); <-- this kind of constant could be wind
    acceleration.multByCon(0.0);
    
    life_span--;
  }
  
  float shrink = 0;
  void display() {
    
    pushMatrix();      
      translate(location.x, location.y, location.z);
      fill(p_color,255-fade);
      //tint(255,255-fade);
      ellipse(0, 0, radius-shrink, radius-shrink);
    popMatrix();
    
    if (edge && life_span < 160) {
      fade += 2;
    } else if (life_span < 75) {
      fade += 3.4;
    }
    
    if (life_span < 100) {
      shrink += radius/100;
    }
  }
  
  void run() {
    update();
    display();
  }
}
