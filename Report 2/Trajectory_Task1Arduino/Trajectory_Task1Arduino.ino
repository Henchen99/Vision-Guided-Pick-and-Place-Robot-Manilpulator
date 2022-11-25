#include <Servo.h>
#include <math.h> 

#define Joint1Pin 2
#define Joint2Pin 3
#define Joint3Pin 4
#define Joint4Pin 10
#define GripperPin 11
#define pi 3.14159265358979323846

int XPin = A1;
int YPin = A2;
int ZPin = A3;


// Servo Objects
Servo Joint1;
Servo Joint2;
Servo Joint3;
Servo Joint4;
Servo Gripper;

// Starting Joint Angles
int Joint1Angle = 90;
int Joint2Angle = 90;
int Joint3Angle = 90; 
int Joint4Angle = 90; 

int GripperOpen = 20; 
int GripperClose = 160; 

// Joint Angle Offsets
int Joint1Offset = 9; // Your value may be different
int Joint2Offset = 0; // Your value may be different
int Joint3Offset = 6; // Your value may be different

// Link lengths
float L2 = 93;
float L3 = 105;
float L4 = 74;
float L34 = 179;


void setup()
{
 Serial.begin(9600);
 Joint1.attach(Joint1Pin);
 Joint2.attach(Joint2Pin);
 Joint3.attach(Joint3Pin);
 Joint4.attach(Joint4Pin);
 Gripper.attach(GripperPin);
 
 Joint1.write(Joint1Angle+Joint1Offset);
 Joint2.write(Joint2Angle+Joint2Offset);
 Joint3.write(Joint3Angle+Joint3Offset);
 Joint4.write(Joint4Angle);
 Gripper.write(GripperOpen); // Open gripper

 delay(10000);
}
void loop()
{
 
float Xstart = 0;
float Ystart = 171.5;
float Zstart = 97.5;

float XPosition = 0;
float YPosition = 0;
float ZPosition = 0;

float Xobject = 32.5664;
float Yobject = 218.0603;
float Zobject = 0.4304;

float Xnew = 89.94;
float Ynew = Yobject;
float Znew = Zobject;

int i;
//first movement
  float u0x = Xstart, ufx = Xobject, u0y = Ystart, ufy = Yobject, u0z = Zstart, ufz = Zobject, tf = 5, t[51];
   
  float a0x = u0x;
  float a1x = 0;
  float a2x = (3/(tf*tf)) * (ufx - u0x);
  float a3x = (-2/(tf*tf*tf)) * (ufx-u0x);

  float a0y = u0y;
  float a1y = 0;
  float a2y = (3/(tf*tf)) * (ufy - u0y);
  float a3y = (-2/(tf*tf*tf)) * (ufy-u0y);
  
  float a0z = u0z;
  float a1z = 0;
  float a2z = (3/(tf*tf)) * (ufz - u0z);
  float a3z = (-2/(tf*tf*tf)) * (ufz-u0z);


// placing object in new position
  float ufx2 = Xnew, ufy2 = Ynew, ufz2 = Znew;
   
  float a0x2 = u0x;
  float a1x2 = 0;
  float a2x2 = (3/(tf*tf)) * (ufx2 - u0x);
  float a3x2 = (-2/(tf*tf*tf)) * (ufx2-u0x);

  float a0y2 = u0y;
  float a1y2 = 0;
  float a2y2 = (3/(tf*tf)) * (ufy2 - u0y);
  float a3y2 = (-2/(tf*tf*tf)) * (ufy2-u0y);
  
  float a0z2 = u0z;
  float a1z2 = 0;
  float a2z2 = (3/(tf*tf)) * (ufz2 - u0z);
  float a3z2 = (-2/(tf*tf*tf)) * (ufz2-u0z);
  
  float ok = 0;
  for(i = 0; i < 51; i++){
    t[i] = ok;
    ok = ok + 0.1;
  }

  //grabbing the object
  for(i = 0; i < 51; i++){
    XPosition = a0x + a1x*t[i] + a2x * t[i] * t[i] + a3x*t[i] * t[i] * t[i];
    YPosition = a0y + a1y*t[i] + a2y * t[i] * t[i] + a3y*t[i] * t[i] * t[i];
    ZPosition = a0z + a1z*t[i] + a2z * t[i] * t[i] + a3z*t[i] * t[i] * t[i];

    //theta1
    float theta1 = atan2(YPosition,XPosition) * 180 / pi;
    
    //theta2   
    float I1 = sqrt(XPosition * XPosition + YPosition * YPosition + ZPosition * ZPosition);
    float alpha = asin(ZPosition / I1);
    float beta = acos((I1 * I1 + 93.0 * 93.0 - 179.0 * 179)/(2 * I1 * 93.0));
    float theta2 = (alpha + beta) * 180 / pi;
  
   
  
    //theta3
    float a = sqrt(XPosition * XPosition + YPosition * YPosition + ZPosition * ZPosition);
    float theta3 = (pi - acos(((93) * 93.0 + (179) * 179 - a * a) / (2.0 * 93 * 179))) * 180/pi;
 

 
   Joint1.write(theta1+Joint1Offset);
   Joint2.write(theta2+Joint2Offset);
   Joint3.write(theta3+Joint3Offset);
   Joint4.write(Joint4Angle);
   delay(100); 
  }
  
  delay(1000);
  Gripper.write(GripperClose);
  delay(2000);

  //bringing back to initial position
  for(i = 50; i >= 0; i--){
    XPosition = a0x + a1x*t[i] + a2x * t[i] * t[i] + a3x*t[i] * t[i] * t[i];
    YPosition = a0y + a1y*t[i] + a2y * t[i] * t[i] + a3y*t[i] * t[i] * t[i];
    ZPosition = a0z + a1z*t[i] + a2z * t[i] * t[i] + a3z*t[i] * t[i] * t[i];

    //theta1
    float theta1 = atan2(YPosition,XPosition) * 180 / pi;
    
    //theta2   
    float I1 = sqrt(XPosition * XPosition + YPosition * YPosition + ZPosition * ZPosition);
    float alpha = asin(ZPosition / I1);
    float beta = acos((I1 * I1 + 93.0 * 93.0 - 179.0 * 179)/(2 * I1 * 93.0));
    float theta2 = (alpha + beta) * 180 / pi;
  
   
  
    //theta3
    float a = sqrt(XPosition * XPosition + YPosition * YPosition + ZPosition * ZPosition);
    float theta3 = (pi - acos(((93) * 93.0 + (179) * 179 - a * a) / (2.0 * 93 * 179))) * 180/pi;
 

 
   Joint1.write(theta1+Joint1Offset);
   Joint2.write(theta2+Joint2Offset);
   Joint3.write(theta3+Joint3Offset);
   Joint4.write(Joint4Angle);
   delay(100); 
  }

  delay(2000);

  //bringing to new position
  for(i = 0; i < 51; i++){
    XPosition  = a0x2 + a1x2*t[i] + a2x2 * t[i] * t[i] + a3x2*t[i] * t[i] * t[i];
    YPosition = a0y2 + a1y2*t[i] + a2y2 * t[i] * t[i] + a3y2*t[i] * t[i] * t[i];
    ZPosition = a0z2 + a1z2*t[i] + a2z2 * t[i] * t[i] + a3z2*t[i] * t[i] * t[i];

    //theta1
    float theta1 = atan2(YPosition,XPosition) * 180 / pi;
    
    //theta2   
    float I1 = sqrt(XPosition * XPosition + YPosition * YPosition + ZPosition * ZPosition);
    float alpha = asin(ZPosition / I1);
    float beta = acos((I1 * I1 + 93.0 * 93.0 - 179.0 * 179)/(2 * I1 * 93.0));
    float theta2 = (alpha + beta) * 180 / pi;
  
   
  
    //theta3
    float a = sqrt(XPosition * XPosition + YPosition * YPosition + ZPosition * ZPosition);
    float theta3 = (pi - acos(((93) * 93.0 + (179) * 179 - a * a) / (2.0 * 93 * 179))) * 180/pi;
 

 
   Joint1.write(theta1+Joint1Offset);
   Joint2.write(theta2+Joint2Offset);
   Joint3.write(theta3+Joint3Offset);
   Joint4.write(Joint4Angle);
   delay(100); 
  }
  
  Gripper.write(GripperOpen);
  delay(2000);

    //bringing to initial position again
  for(i = 50; i >= 0; i--){
    XPosition  = a0x2 + a1x2*t[i] + a2x2 * t[i] * t[i] + a3x2*t[i] * t[i] * t[i];
    YPosition = a0y2 + a1y2*t[i] + a2y2 * t[i] * t[i] + a3y2*t[i] * t[i] * t[i];
    ZPosition = a0z2 + a1z2*t[i] + a2z2 * t[i] * t[i] + a3z2*t[i] * t[i] * t[i];

    //theta1
    float theta1 = atan2(YPosition,XPosition) * 180 / pi;
    
    //theta2   
    float I1 = sqrt(XPosition * XPosition + YPosition * YPosition + ZPosition * ZPosition);
    float alpha = asin(ZPosition / I1);
    float beta = acos((I1 * I1 + 93.0 * 93.0 - 179.0 * 179)/(2 * I1 * 93.0));
    float theta2 = (alpha + beta) * 180 / pi;
  
    //theta3
    float a = sqrt(XPosition * XPosition + YPosition * YPosition + ZPosition * ZPosition);
    float theta3 = (pi - acos(((93) * 93.0 + (179) * 179 - a * a) / (2.0 * 93 * 179))) * 180/pi;

 
   Joint1.write(theta1+Joint1Offset);
   Joint2.write(theta2+Joint2Offset);
   Joint3.write(theta3+Joint3Offset);
   Joint4.write(Joint4Angle);
   delay(100); 
  }

  delay(2000);
}
