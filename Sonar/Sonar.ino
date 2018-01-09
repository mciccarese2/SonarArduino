#include <Servo.h>         //including the servo library
Servo sg90;                //Variable for servo
const int echo_pin = 11;   // Initializing echo pin for distance sensor
const int trig_pin = 10;   // initializing trigger pin for distance sensor
unsigned long distance = 0; //Variable to store the distance value
unsigned long distance_cm = 0; //variable to store the distance in cm
int servo_pin = 12; //initializing servo pin
int i = 0;
int j = 0;
int total = 0;
int average = 0;

void setup() {
  sg90.attach(servo_pin);    //Arduino will take the servo value from this pin
  pinMode(trig_pin, OUTPUT); //declaring trig pin as output pin
  pinMode(echo_pin, INPUT);  //declaring echo pin as input pin
  Serial.begin(9600);        //Setting the baudrate at 9600 for serial communication
}

void loop() {
  for (i = 0; i < 180; i++) { //Moving the servo from left to right
    sg90.write(i);
    distanceVal();
  }

  for (i = 180; i > 0; i--) { //Moving the servo from right to left
    sg90.write(i);
    distanceVal();
  }
}

//Function to calculate the distance
void distanceVal()
{
  for (j = 0; j <= 10; j++) {
    digitalWrite(trig_pin, LOW);
    delayMicroseconds(50);
    digitalWrite(trig_pin, HIGH); //setting the trig pin to generate a wave
    delayMicroseconds(50);
    digitalWrite(trig_pin, LOW);
    distance = pulseIn(echo_pin, HIGH); //setting the echo pin high to receive the wave
    distance_cm = distance / 58; //converitng the distance into cm
    total = total + distance_cm;
    delay(10);
  }
  average = total / 10;
  if (j >= 10) {
    j = 0;
    total = 0;
  }
  Serial.print("X");
  Serial.print(i);
  Serial.print("V");
  Serial.println(average);
}
