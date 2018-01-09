import processing.serial.*; //importing the serial library for serial communication between arduino and processing
Serial port; //declaring a variable for serial communication 
int[] sensor_value = new int[181]; //Variable to store the value of the sensor
int[] previous_value = new int[181];//Variable to store the previous value of sensor 
PFont text; //Variable for setting the font size and type 
int radarDist = 0; 
int radius = 350; //declaring a variable for setting the radius of objects
int widthh = 300; //declaring a variable for setting the width of objects 
int position = 0; //Declaring a variable for storing position state (left or right) 
int motion = 0; 
float x_coordinate; //declaring a Variable for storing the x co-ordinate value 
float y_coordinate; //declaring a Variable for storing the y co-ordinate value
int value; 
String data ; //String to recieve value from the serial port
String servo_value; //String for storing the servo position
String sensor_val; //String for storing the sensor value

void setup() {
  size(720, 380); //Setting the size of the output window
  port = new Serial(this, "COM3", 9600); /*Setting the COM port and baudrate for serial 
   communication. Set the baudrate here according to Arduino IDE's baudrate */
  text = createFont("calibri", 15); //Setting the text size and type
  background (0); //Setting the colour of background. '0' for black background
  textFont(text);
}

//Below function will make all the shapes for output window
void draw() {
  fill(0); //black background for the following shape
  noStroke(); //No outline for the below shape
  ellipse(radius, radius, 1080, 720); //Drawing a ellipse
  rectMode(CENTER); //drawing a rectangle at the center of ellipse
  rect(350, 402, 1080, 720); //size of rectangle
  drawradar();
  drawshape();
  drawvalues();
  drawgridlines();
  drawtext();
}

void serialEvent (Serial port) {
  data = port.readStringUntil('\n'); //This will wait until the data is received
  if (data != null) { 
    data = trim(data); //trim the empty space
    servo_value = data.substring(1, data.indexOf("V")); //Storing the servo value
    sensor_val = data.substring(data.indexOf("V")+1, data.length()); //Storing the sensor value
    position = Integer.parseInt(servo_value); //storing values in position variable
    value = Integer.parseInt(sensor_val);
    previous_value[position] = sensor_value[position]; //storing values in array
    sensor_value[position] = value;
  }
}

void drawradar()
{
  if ( position >= 179) { //animation will move from right to left
    motion = 1;
  }
  if (position <= 1) { //animation will move from left to right 
    motion = 0;
  }
  strokeWeight(6); //Seting the thickness of lines 
  if (motion == 0) { //Move left to right
    for (int i = 0; i <= 20; i++) { //drawing 20 lines 
      stroke(255, 255, 0); //setting the colour of lines
      line(radius, radius, radius + cos(radians(position+(180+i)))*widthh, radius + sin(radians(position+(180+i)))*widthh); //Start and end point of the line
    }
  } else { //move right to left 
    for (int i = 20; i >= 0; i--) { //draw 20 lines
      stroke(255, 255, 0); //Setting the colour of lines
      line(radius, radius, radius + cos(radians(position+(180+i)))*widthh, radius + sin(radians(position+(180+i)))*widthh); //Start and end point of the line
    }
  }
}

//Drawing the shapes of the sensor values
void drawshape()
{
  //First round
  noStroke(); //No outline for theses values 
  fill(255, 0, 0); //set the colour
  beginShape(); //make the shape
  for (int i = 0; i < 180; i++) { 
    x_coordinate = radius + cos(radians((180+i)))*((previous_value[i])); //make x co-ordinate
    y_coordinate = radius + sin(radians((180+i)))*((previous_value[i])); //make y co-rdinate
    vertex(x_coordinate, y_coordinate);
  }
  endShape(); 

  //Second Round
  fill(255, 0, 0);
  beginShape();
  for (int i = 0; i < 180; i++) {
    x_coordinate = radius + cos(radians((180+i)))*(sensor_value[i]);
    y_coordinate = radius + sin(radians((180+i)))*(sensor_value[i]);
    vertex(x_coordinate, y_coordinate);
  }
  endShape();
}

void drawvalues()
{ 
  for (int i = 0; i <=6; i++) { //Loop for making rings
    noFill();
    strokeWeight(3); //Thickness of rings
    stroke(0, 0, 255); //color of rings
    ellipse(radius, radius, (100*i), (100*i)); //drawing the rings
    fill(0, 0, 255);
    noStroke();
    text(Integer.toString(radarDist+50), 380, (305-radarDist), 50, 50); //Settings the values for each ribg
    radarDist+=50;
  }
  radarDist = 0;
}

void drawgridlines()
{
  for (int i = 0; i <= 6; i++) { //loop for drawing the grid lines
    strokeWeight(1); //thickness of lines
    stroke(0, 0, 255); // color of lines
    line(radius, radius, radius + cos(radians(180+(30*i)))*widthh, radius + sin(radians(180+(30*i)))*widthh); //values at which these will be drawn
    fill(0, 0, 255);
    noStroke();
    if (180+(30*i) >= 300) {
      text(Integer.toString(0+(30*i)), (radius+10) + cos(radians(180+(30*i)))*(widthh+10), (radius+10) + sin(radians(180+(30*i)))*(widthh+10), 25, 50); //giving value for each line
    } else {
      text(Integer.toString(0+(30*i)), radius + cos(radians(180+(30*i)))*widthh, radius + sin(radians(180+(30*i)))*widthh, 60, 40); //giving value for each line
    }
  }
}

//Below function will show the Angle and distance values below the radar
void drawtext()
{
  noStroke();
  fill(0);
  rect(290, 370, 500, 50);
  fill(255, 0, 0);
  text("Angle: "+Integer.toString(position), 100, 380, 100, 50); 
  text("Distance: "+Integer.toString(value), 540, 380, 250, 50);
}