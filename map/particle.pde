class Particle {
  
  Vector location;
  Vector velocity;
  Vector acceleration;
  
  // used to identify what source this particle is connected to
  String source = ""; // name of it's source company
  float x_spawn, y_spawn; // x,y location this particle spawned at 
  
  color p_color;
  float mass = 2;
  float radius = 3;
  
  float life_span = 545;
  boolean start_death = false;
  PShape particle;
  float start_time;
  
  float rotation_direction;
  
  float fade = 240;
  boolean edge = false;
  boolean visible = true;
  

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
    acceleration = new Vector(0,0,0);
    //velocity = vel;
    particle = createShape(ELLIPSE,0, 0, radius, radius+4);
    
    float randx = random(0,2);
    float randy = random(0,2);
    
    velocity = new Vector(randx,randy,0);
    
    p_color = c;
    
    //applyForce(new Vector(randx,randy,0));
    
    if (randx > 0.65 && randy <0.35 || randx < 0.35 && randy > 0.65 ) {
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
    if (life_span <= 0) {
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
    
    //float chance = random(0,0.05);
    //if (chance > 0.03) {
    //  float xchance = random(0,1);
    //  if (xchance > 0.5) {
    //    velocity.x += chance;
    //  } else {
    //    velocity.y += chance;
    //  }
    //}

    velocity.addV(acceleration);
   
    location.addV(velocity); 
    
    //velocity.addV(gravity); <-- this kind of constant could be wind
    acceleration.multByCon(0.0);
    
    life_span--;
  }
  
  int size = 0;
  void display() {
    
    pushMatrix();      
      translate(location.x, location.y, location.z+1);
      //rotateZ((life_span/PI)*-0.01);
      //fill(p_color,255-fade);
      tint(200,200,200,255-fade);
      //smoke.resize(40-(int)shrink,40-(int)shrink);
      //size = (int) (50*(life_span/245)) + 5;
      //println(60-size);
      //smoke.resize(70-size,65-size);
      //scale(size);

      if (life_span > 540) {
        image(smoke_1,0,0);
      } else if (life_span > 534) {
        image(smoke_2,0,0);
      } else if (life_span > 528) {
        image(smoke_3,0,0);
      } else if (life_span > 522) {
        image(smoke_4,0,0);
      } else if (life_span > 516) {
        image(smoke_5,0,0);
      } else if (life_span > 510) {
        image(smoke_6,0,0);
      } else if (life_span > 504) {
        image(smoke_7,0,0);
      } else if (life_span > 495) {
        image(smoke_8,0,0);
      } else if (life_span > 485) {
        image(smoke_9,0,0);
      } else if (life_span > 475) {
        image(smoke_10,0,0);
      } else if (life_span > 465) {
        image(smoke_11,0,0);
      } else if (life_span > 455) {
        image(smoke_12,0,0);
      } else if (life_span > 445) {
        image(smoke_13,0,0);
      } else {
        image(smoke_14,0,0);
      }


      //ellipse(0, 0, 55-size, 55-size);
    popMatrix();
    
    
    // controls rate particle fades
    if (life_span < 525 && edge) {
      fade += 0.28;
    } else if (life_span < 300) {
      fade += 0.05;
    } 
    
    //if (edge && life_span < 382) {
    //  fade += 1.4;
    //} else if (life_span < 255) {
    //  fade += 1;
    //}
    
    //if (edge && life_span < 160) {
    //  fade += 2;
    //} else if (life_span < 75) {
    //  fade += 3.4;
    //}
    
    //if (fade > 258) {
    //  visible = false;
    //} 
    

  }
  
  void run() {
    update();
    display();
  }
}
