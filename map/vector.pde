import java.lang.*; //for Math.sqrt and Math.acos, they work with doubles

class Vector {
  
  float x;
  float y;
  float z;
  
  Vector() {
    x = 0;
    y = 0;
    z = 0;
  }
  
  Vector(float newX, float newY, float newZ) {
    x = newX;
    y = newY;
    z = newZ;
  }
  
  //returns a string representation for the vector
  String toString() {
    return "(" + x + ", " + y + ", " + z + ")";
  }
  
  // magnitude
  float getLen() {
    return (float)Math.sqrt(x*x + y*y + z*z);
  }
  
  void addV(Vector v) {
    x += v.x;
    y += v.y;
    z += v.z;
  }
  
  Vector getAddV(Vector v) {
    float newX = x+v.x;
    float newY = y+v.y;
    float newZ = z+v.z;
    Vector newV = new Vector(newX,newY,newZ);
    return newV;
  }
  
  void multV(Vector v) {
    x = x*v.x;
    y = y*v.y;
    z = z*v.z;
  }
    
  Vector getMultV(Vector v) {
    float newX = x*v.x;
    float newY = y*v.y;
    float newZ = z*v.z;
    Vector newV = new Vector(newX,newY,newZ);
    return newV;
  }
  
  // multiple vector by a constant
  void multByCon(float n) {
    x *= n;
    y *= n;
    z *= n;
  }
  
  // multiple vector by a constant
  Vector getMultByCon(float n) {
    float newx = x*n;
    float newy = y*n;
    float newz = z*n;
    return new Vector(newx,newy,newz);
  }
  
  Vector getSquared() {
    float newx = x*x;
    float newy = y*y;
    float newz = z*z;
    return new Vector(newx,newy,newz);
  }
  
  // divide vector by a constant
  void divByCon(float n) {
    x = x/n;
    y = y/n;
    z = z/n;
  }
  
  // divide vector by a constant
  Vector getDivByCon(float n) {
    float newX = x/n;
    float newY = y/n;
    float newZ = z/n;
    return new Vector(newX, newY, newZ);
  }
  
  // scalar projection of this vector onto v...
  // informally measures vector "similarity"
  float dotV(Vector v) {
    return x*v.x + y*v.y + z*v.z;
  }
  
  // returns angle between this and another vector
  double getTheta(Vector v) {
    return Math.acos(this.dotV(v) / (this.getLen() * v.getLen()));
  }
  
  // component of this vector in the direction of v
  float vectorProject(Vector v) {
    return this.dotV(v) * v.getLen();
  }
  
  void normalizeV() {
    float len = this.getLen();
    x = x/len;
    y = y/len;
    z = z/len;
  }
  
  Vector getNormalizeV() {
    float len = this.getLen();
    return new Vector(x/len, y/len, z/len);
  }
  
  void crossP(Vector v) {
    float newX = y*v.z - z*v.y;
    float newY = z*v.x - x*v.z;
    float newZ = x*v.y - y*v.x;
    x = newX;
    y = newY;
    z = newZ;
  }
  
  // returns vector perpendicular (orthogonal) to both this vector and v
  Vector getCrossP(Vector v) {
    float newX = y*v.z - z*v.y;
    float newY = z*v.x - x*v.z;
    float newZ = x*v.y - y*v.x;
    Vector newV = new Vector(newX,newY,newZ);
    return newV;
  }
  
  //returns a brand new vector with the other subtracted from it
  Vector getSubV(Vector other) {
    float newX = this.x - other.x;
    float newY = this.y - other.y;
    float newZ = this.z - other.z;
    return new Vector(newX, newY, newZ);
  }  
  
  //subtracts other from this vector
  void subV(Vector other) {
    this.x -= other.x;
    this.y -= other.y;
    this.z -= other.z;
  }
  
  // subtracts constant from this vector
  Vector subConstant(float constant) {
    float newX = this.x - constant;
    float newY = this.y - constant;
    float newZ = this.z - constant;
    return new Vector(newX, newY, newZ);
  }
  
  // returns distance between this and another point, in 2D (x,y)
  float distance(Vector point) {
    float tempx = x - point.x;
    float tempy = y - point.y;
    
    return (float) sqrt(tempx*tempx + tempy*tempy);
  }
}
