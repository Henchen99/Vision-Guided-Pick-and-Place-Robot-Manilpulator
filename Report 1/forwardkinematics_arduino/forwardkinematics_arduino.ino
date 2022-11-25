////////////////////////
// Forward Kinematics //
////////////////////////
#include <Servo.h>
// Arm Servo pins
#define Joint1Pin 2
#define Joint2Pin 3
#define Joint3Pin 4
#define Joint4Pin 10
#define GripperPin 11
// Servo Objects
Servo Joint1;
Servo Joint2;
Servo Joint3;
Servo Joint4;
Servo Gripper;
// Starting Joint Angles
int Joint1Angle = 90; // Theta 1
int Joint2Angle = 90; // Theta 2
int Joint3Angle = 90; // Theta 3
int Joint4Angle = 0; // Leave constant
int GripperOpen = 60; // Open gripper; Need to tune value
int GripperClose = 120; // Close gripper; Need to tune value
// Joint Angle Offsets
int Joint1Offset = 9; // Offset measured from previously
int Joint2Offset = 0; // Offset measured from previously
int Joint3Offset = 6; // Offset measured from previously
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

 delay(5000); // 5 seconds before loop function
}
void loop()
{
 Joint1.write(Joint1Angle+Joint1Offset);
 Joint2.write(Joint2Angle+Joint2Offset);
 Joint3.write(Joint3Angle+Joint3Offset);
 Joint4.write(Joint4Angle);
 Gripper.write(GripperOpen); // Open gripper

 delay(10);
}
