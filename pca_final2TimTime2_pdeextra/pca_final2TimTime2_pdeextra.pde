

import g4p_controls.*;

//// data
int hour = 1;
int min = 1;
long lastUpdate = 0;
long updateInterval = 20;
String kitID = "13777";
char c1;
char c2;
String c3;
int c4 = 0;
char d1;
char d2;
String d3= "";
String d4 = "";
String resourceURL = "http://data.smartcitizen.me/v0/devices/"+kitID;


/// For reading historical data from smart citizen api - takes average of readings every 'rollup' hour intervals between 'startdate' and 'enddate'
import java.net.*;
import java.io.*; 
int sensorID = 55; // temp - thinking of using battery when on solar, sensorID =10
int rollup = 4; // number of hours between readings
String startdate = "";   // in format YYYY-MM-DD or YYYY-M-D - will be today's date less numberofdays perhaps use year(), month(), day() as these are int and easier to -3
String enddate = "";   // in format YYYY-MM-DD or YYYY-M-D - end date has to be tomorrow to get today's readings! today + 1
int numberofdays = 3;
String readingsURL = "https://api.smartcitizen.me/v0/devices/"+kitID+"/readings?sensor_id="+sensorID+"&rollup="+rollup+"h&from="+startdate+"&to="+enddate;
int[] ypoints = new int[0];       //creating an empty array for y plots
int[] xpoints = new int[0];      // creating an empty array for x plots

//// text
GTextField txf1;

//// API data
String hardware = "";
String city = "";
String country = "";
String locate = "";
String exposure = "";
String tag = "";
String tag1 = "";    //one will be inside /outside
String tag2 = "";    //one will be online/offline
float lat = 0.0;
float lon = 0.0;
int woe = 44418;
String localtimestamp = "";
String metaweatherqueryURL = "https://www.metaweather.com/api/location/search/?lattlong="+lat+","+lon; // api to serch location and retrieve 'woeid'
String metaweatherwoeidURL = "https://www.metaweather.com/api/location/"+woe; // api to query time from location search ressult
int tagarraylen = 0;



////////time
char tadjustplus_minus; 
char tadjust1;
char tadjust2;
String tadjust = "";
String lastupdatelocal = "";

//// sensors
String timeStamp = "";
float light = 0;
float temp = 0;
float hum = 0;
float pressure = 0;
float c02 = 0;
float pm1 = 0;
float pm25 = 0;
float pm10 = 0;
float noise = 0;
float vol = 0;
float bat = 0;

/// sky
float g = 0;
float sRed = 0;
float sGreen = sRed;
float sBlue = 0;
color skyCol=color(sRed,sGreen,sBlue);
float night=0;

//// temp
float tRed = 0;
float tGreen = tRed;
float tBlue = 0;
color tempCol=color(tRed,tGreen,tBlue);

////moon
float moonX = 0;
float moonY = 0;

////sun
float sunshine = 0;
int rgb;
PImage circle_grad;
float sunX = 0;
float sunY = 0;

//// land
float yoff = 0.0;
float yoff2 = 0.0;
float slope = random(0.03);
float slope2 = noise/1000;
float hillCol = 70;

//// rain
float rain=0;

//// flare
float ex1 = 0;
float ey1 = 0;
float ex2 = 0;
float ey2 = 0;
float ex3 = 0;
float ey3 = 0;
float ex4 = 0;
float ey4 = 0;
float targetX = 0;
float targetY = 0;
float speed1 =0.01;
float speed2 =0.01;
float speed3 =0.01;
float speed4 =0.01;
float size1 = 2;
float size2 = 4;
float size3 = 10;
color  flare1 = color(0,255,0,100);
color  flare2= color(100+random(150), 100+random(150), 100+random(150),100);
color  flare3 = color(255, 255, 100,0);


void setup(){
  
  getData();
  
  fullScreen();
  //size(640, 360);

  txf1 = new GTextField(this, 20, 20, 40, 20);
  txf1.setText(""+kitID); 
  
  targetX = width/2;
  targetY = height;
  
   ex1 = targetX;
   ey1 = targetY-5;
   ex2 = targetX;
   ey2 = targetY-5;
   ex3 = targetX;
   ey3 = targetY-5;
   ex4 = targetX;
   ey4 = targetY-5;
  
}
 


void draw(){
 
 //// data
 
 if (millis() - lastUpdate > (updateInterval*1000)) {
    getData(); 
 }
 
 if (keyPressed && key == ENTER) {
     kitID= txf1.getText(); 
     getData();
  }
  
 //// sky
 
 drawSky();
 
 
 //// moon 

  if (hour>=16 && hour<=19 && rain<=0){
   moonY=((height/1.35-(hour-15)*(height/7))); 
   moonX = ((hour-15)*width/10);
   drawMoon();
      
 }
 
  if (hour>=-5 && hour<=1 && rain<=0){
   moonY=((hour+7)*(height/16));
   moonX = (width/4)+(hour+7)*(width/10);
   drawMoon();
 }


//// sun

  if (hour>=1 && hour<=7 && rain<=0) {
    sunY=(height/1.35)-hour*(height/12);
    drawSun();
  }
  if (hour>7 && hour<=16 && rain<=0) {
    sunY=(hour-6)*(height/16);
    drawSun();
  }
 
 
 //// land background
 drawLand();


 //// gas
 drawC02();
 drawVol();
 drawPm1();
 drawPm25();
 drawPm10();
 
 //// land forground
// drawLand2();
 
 
 //// land fade
 drawLandFade();
 //// interface
 
 drawInterface();
 
 //// rain
  if (hum>=80 && pressure<100.8){
    drawRain();
  }
  
 //// flare  
  if (hour>=1 && hour<=16 && rain<=0) { 
    drawFlare();
  }
 ////////location
 drawLocation();
 
}



void drawSky(){
  
  g =102-pressure;
  
  sRed = ((g*15)+50)-night/2;
  sGreen = sRed;
  sBlue = (255-((g*3)*25))-night/2;
  
  if (g>2) {
    sBlue=sRed;
  }

  if (light<=255){    
    night=255-light;
  }else{
    night=0;
  }
  
  skyCol=color(sRed,sGreen,sBlue);
  background(skyCol);
  
}




void drawMoon(){
  
  float red = temp-25;
  
  /// moon 
  
  fill(255, 255-(red*25),255-(temp*8),255-(g*90));
  ellipse(moonX, moonY, height/25, height/25);
  fill(skyCol);
  ellipse(moonX-height/140, moonY-height/140, height/25, height/25);
  
  
  //// moon temp
  
  color  moon1 = color(255,255-(red*25),255-(temp*10),150);
  color  moon2 = color(skyCol,0);
   
  noStroke();

  float radius = (height/10)*g;

  for (float r = radius; r > 0; r--) {
   float inter = map(r, 0,(height/10)*g, 0, 1); 
   color c = lerpColor(moon1, moon2, inter); 
   fill(c,10-(g*2));
   ellipse(moonX+height/100, moonY+height/100, r, r);
    
  }
  
}


void drawSun() {
  
  sunshine = light/1000;
  
  //sunX = hour*width/16;
  sunX = (hour-5)*width/16;   //  5 or 4 as this made it in the middle of the screen at 12 5 is probably right considering daylight saving!
  //// sun brightness

  color  sun1 = color(225, 225, 255);
  color  sun2 = color(sRed+40, sGreen+40, sBlue+40);
  color  sun3 = color(skyCol, 0);


  noStroke();

  circle_grad = createImage(width, height, ARGB);
  circle_grad.loadPixels();

  for (int y=0; y<circle_grad.height; y++) {
    for (int x=0; x<circle_grad.width; x++) {

    float dis = dist(x, y, sunX, sunY);
    dis = map(dis, 0, circle_grad.width, 0, 12-sunshine);

   if (dis<2) {
       if (dis>1) { 
          rgb = lerpColor(sun2, sun3, dis-1);
        } else { 
          rgb = lerpColor(sun1, sun2, dis);
        }
       } else { 
        rgb=0x00000000;
       }
      circle_grad.pixels[x+circle_grad.width*y]=rgb;
    } 

  }

  image(circle_grad, 0, 0);
  
  
  //// sun temp
  
  float red = temp-25;

  color  moon1 = color(255,255-(red*25),255-(temp*10),150);
  color  moon2 = color(255,255,255,0);
   
  noStroke();

  float radius = height/10;

  for (float r = radius; r > 0; r--) {
   float inter = map(r, 0,height/10, 0, 1); 
   color c = lerpColor(moon1, moon2, inter); 
   fill(c,50);
   ellipse(sunX, sunY, r+random(30), r+random(30));
    
  }

  //// sun elipse

  noStroke();
  fill(255);
  ellipse(sunX, sunY, height/25, height/25);

}



////////////////lets try and draw the land to reflect the sensor over the last 4 days/////////////
void drawLand(){
  //fill(sRed-hillCol,sGreen-hillCol,sBlue-hillCol);
  fill(255,255,255);
  beginShape();   
  noStroke();
  int numberofvertex = ypoints.length;
 
  beginShape();
  curveVertex(xpoints[0],ypoints[0]);  //first is to be duplicated as per instructions..
  for (int i = 0; i < numberofvertex; i++){
    curveVertex(xpoints[i], ypoints[i]);
  }
  curveVertex(xpoints[numberofvertex-1], ypoints[numberofvertex-1]);  //last is to be duplicated too
  endShape();
  
  
  
/*  fill(sRed-hillCol,sGreen-hillCol,sBlue-hillCol);
  beginShape();   
  noStroke();
  float xoff = 0;       
  // Iterate over horizontal pixels
  for (float x = 0; x <= width+20; x += 10) {
    // Calculate a y value according to noise, map to 
    float y = map(noise(xoff, yoff), 0, 1, height/1.2,height/2); //original
    // Set the vertex
    vertex(x, y);
    // Increment x dimension for noise
    xoff += slope;
  }
  // increment y dimension for noise
  //yoff += 0.01;
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);*/
  
}


void drawLand2(){
  
  slope2 = noise/1000;    //this one is the noise one in the front noise variable not noise function...
  
  noStroke();
  
  fill(0);

  beginShape(); 
  
  float xoff2 = 0;     

  for (float x = 0; x <= width+20; x += 10) {

    float y = map(noise(xoff2, yoff2), 0, 1, height/1,height/3);
    vertex(x, y); 
    xoff2 += slope2;
  }

  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
   
}





void drawC02(){

  noStroke();

color c022 = color(skyCol,0);
//color c021 = color(255,255,255,255); /// change colour of gases
color c021 = color(0,255,0,255);

float gradientSteps = 70;//how detailed will the gradient be
float gradientHeight = (c02/10)/gradientSteps;//compute how many strips of the same width we'll need to fill the sketch

for(int i = 0; i < gradientSteps; i++){
  float t = map(i,0,gradientSteps,0.0,1.0);           // 
  color interpolatedColor = lerpColor(c021,c022,t);  //fades the colour 
  fill(interpolatedColor, 40);
  rect(0,(height/1.35)-i*gradientHeight,width,(height/50)-(c02/50));

}   
}

void drawPm1(){
  
  noStroke();

color PM2 = color(255,0,0,0);
color PM1 = color(255,0,0);

float gradientSteps = 50;
float gradientHeight = (pm1/2)/gradientSteps;

for(int i = 0; i < gradientSteps; i++){
  float t = map(i,0,gradientSteps,0.0,1.0);
  color interpolatedColor = lerpColor(PM1,PM2,t); 
  fill(interpolatedColor, 10);
  rect(0,(height/1.34)-i*gradientHeight,width,(height/200)-(pm1/2));

}
}


void drawPm25(){
  
  noStroke();

color PM252 = color(255,142,175,0);
color PM25 = color(255,142,175);

float gradientSteps = 40;
float gradientHeight = (pm25)/gradientSteps;

for(int i = 0; i < gradientSteps; i++){
  float t = map(i,0,gradientSteps,0.0,1.0);
  color interpolatedColor = lerpColor(PM25,PM252,t); 
  fill(interpolatedColor, 5);
  rect(0,(height/1.35)-i*gradientHeight,width,(height/200)-(pm25));

} 
}


void drawPm10(){
    
  noStroke();

color PM102 = color(172,0,255,0);
color PM10 = color(172,0,255);

float gradientSteps = 30;
float gradientHeight = (pm10/2)/gradientSteps;

for(int i = 0; i < gradientSteps; i++){
  float t = map(i,0,gradientSteps,0.0,1.0);
  color interpolatedColor = lerpColor(PM10,PM102,t); 
  fill(interpolatedColor, 20);
  rect(0,(height/1.35)-i*gradientHeight,width,(height/200)-(pm10/2));

}   
}



void drawVol(){

  noStroke();

//color vol2 = color(0,255,0,0);
//color vol0 = color(0,255,0);
color vol2 = color(255,255,255,0);
color vol0 = color(255,255,255);


float gradientSteps = 30;
float gradientHeight = (vol/3)/gradientSteps;

for(int i = 0; i < gradientSteps; i++){
  float t = map(i,0,gradientSteps,0.0,1.0);
  color interpolatedColor = lerpColor(vol0,vol2,t); 
  fill(interpolatedColor, 10);
  rect(0,(height/1.35)-i*gradientHeight,width,(height/200)-(vol/3));

}   
}





void drawLandFade(){
   
  noStroke();

  color c022 = color(0,0);
  color c021 = color(0);

  float gradientSteps = 70;//how detailed will the gradient be
  float gradientHeight = 220/gradientSteps;//compute how many strips of the same width we'll need to fill the sketch

 for(int i = 0; i < gradientSteps; i++){
   float t = map(i,0,gradientSteps,0.0,1.0);
   color interpolatedColor = lerpColor(c021,c022,t); 
   fill(interpolatedColor);
   rect(0,(height)-i*gradientHeight,width,(height/50));
} 

}
 


void drawInterface(){
  
textAlign(CENTER);
  fill(255);
  textSize(width/113.8);
  text("Last Update, local time: "+lastupdatelocal+" | Light: "+light+" lux  |  Temp: "+temp+" C  |  Hum: "+hum+" %  |  BP: "+pressure+" Kpa  |  c02: "+c02+" ppm | PM1: "+pm1+" ug/m3 | PM2.5: "+pm25+" ug/m3 | PM10: "+pm10+" ug/m3 | Noise: "+noise+" db | TV0C: "+vol+" ppb ", width/2, height-50);
  text(city+" | "+country+" | "+tag1+" | "+tag2+ " | ", width/2, height-30);
}




void drawRain(){
  
  strokeWeight(random(2));
  
  rain=(int)hum-80;
 
  for (int i = 0; i < rain; i++) {
   float rX = random(width);
   float rY = random(height);
   float rL = rY+random(rain*8)+rain;
   stroke(random(255), random(255));
   line(rX, rY, rX, rL);
} 
}




void drawFlare(){
  
  ex1 = lerp(ex1,targetX, speed1);
  ey1 = lerp(ey1,targetY, speed1);
  ex2 = lerp(ex2,targetX, speed2/2);
  ey2 = lerp(ey2,targetY, speed2/2);
  ex3 = lerp(ex3,targetX, speed3/3);
  ey3 = lerp(ey3,targetY, speed3/3);
  ex4 = lerp(ex4,targetX, speed4/4);
  ey4 = lerp(ey4,targetY, speed4/4);

  stroke(150+random(100), 150+random(100), 0, 20);
  fill(200+random(50), 200+random(50), 255, 15);
  strokeWeight(3);
  ellipse(ex1,ey1,ey1/size1,ey1/size1);
  
  float radius = (height/20);

  for (float r = radius; r > 0; r--) {
    float inter = map(r, 0, (height/20), 0, 1);
    color c = lerpColor(flare2, flare3, inter); 
    color c2 = lerpColor(flare1, flare1, inter);
    noStroke();
    fill(c, 30);
    ellipse(ex2,ey2,ey2/r/1.4,ey2/r/1.4);
    fill(c2, 20);
    ellipse(ex3,ey3,ey3/r/8,ey3/r/8);
    fill(c2, 25);
    ellipse(ex4,ey4,ey4/r/8,ey4/r/8);
  }
  
  if (ey1<sunY+50 || ey2<sunY+50){
   targetX = width/2;
   targetY = height;
   size1 =random(10)+5;
   size2 =random(20)+5;
   speed1=random(0.01);
   speed2=random(0.05);
   speed3=random(0.01);
   speed4=random(0.05);
   flare1 = color(200+random(50), 200+random(50), 0, 150);
   flare2= color(100+random(150), 100+random(150), 100+random(150), 10+random(100));
  }
  
 if (ey1>height-5 || ey2>height-15){
   targetX = sunX;
   targetY = sunY;
   size1 =random(10)+5;
   size2 =random(20)+5;
   speed1=random(0.01);
   speed2=random(0.01);
   speed3=random(0.05);
   speed4=random(0.01);
   flare1 = color(0, 200+random(50), 200+random(50), 100); 
   flare2= color(100+random(150), 100+random(150), 100+random(150), 10+random(100));
  }
  
   if (ey3<sunY+70 || ey3<sunY+50){
   size1 =random(10)+5;
   size2 =random(20)+5;
   speed1=random(0.05);
   speed2=random(0.01);
   speed3=random(0.05);
   speed4=random(0.05);
   flare1 = color(150+random(100), 150+random(100), 150+random(100), 100);
   flare2= color(100+random(150), 100+random(150), 100+random(150), 10+random(100));
  }
  
 if (ey3>height-5 || ey4>height-5){
   size2 =random(10)+5;
   speed1=random(0.01);
   speed2=random(0.05);
   speed3=random(0.01);
   speed4=random(0.01);
   flare1 = color(200+random(50), 100+random(50),100+random(50), 100);
   flare2= color(100+random(150), 100+random(150), 100+random(150), 10+random(100));
  }

}
  
void drawLocation(){
  textAlign(RIGHT);
  fill(255);
  textSize(width/80);
  text(city,width-40,40);
}

void createtimes(){
  //// taking the time difference out of the localtimestamp from weather api
  tadjustplus_minus = localtimestamp.charAt(26); 
  tadjust1 = localtimestamp.charAt(27);
  tadjust2 = localtimestamp.charAt(28);
  tadjust = ""+tadjust1  + tadjust2;
  
  //// taking the hours and minutes out of the UTC time of last recorded data from smart citizen api
  c1 = timeStamp.charAt(11);
  c2 = timeStamp.charAt(12);
  d1 = timeStamp.charAt(14);
  d2 = timeStamp.charAt(15);
  c3 = ""+c1+c2;
 
  if (c1+c2==23){
    c4 = 0;

  }else{
    c4 = int(c3);
  }
  //println(localtimestamp);
  //println(c4);
  //println(tadjust);

  if (tadjustplus_minus=='+'){
    hour = c4 + int(tadjust);
    //println("adjust is plus");
  }else{
    hour = c4 - int(tadjust);
    //println("adjust is minus");
  }

  d3 = ""+d1;
  d4 = ""+d2;
  //min = d4;
  //hour = c4-5;
  lastupdatelocal = hour + ":" + d3 + d4;
  
}
///////////////////////////////////this is the function to get historical readings from api as array readings, adapted from processing forum post as it didn't work the other way //////////////////////////////////
void getreadings(){
  startdate = year()+"-"+month()+"-"+(day()-numberofdays);
  enddate = year()+"-"+month()+"-"+(day()+1);     //tomorrow
    
  //readingsURL = "https://api.smartcitizen.me/v0/devices/"+kitID+"/readings?sensor_id="+sensorID+"&rollup="+rollup+"h&from="+startdate+"&to="+enddate;
  
  String txt=getreadings("https://api.smartcitizen.me/v0/devices/"+kitID+"/readings?sensor_id="+sensorID+"&rollup="+rollup+"h&from="+startdate+"&to="+enddate);  
  JSONObject json = parseJSONObject(txt);  
  //println(txt);
  
  
  /////get the readings and check the length////////
  JSONArray readings = json.getJSONArray("readings");
  //println(readings);
  int readingslen = 0;
  readingslen = readings.size();
  //println(readingslen);
  
  ////////////making an array of the readings to use as y values///////////////
  //int[] ypoints = new int[readingslen];       //creating the array
  ypoints = expand(ypoints, readingslen);  // expand the ypoints array to match the number of readings
  Float apoint = 0.0;
  
  for (int i = 0; i < readingslen; i++){
    JSONArray readingi = readings.getJSONArray(i);
    apoint = readingi.getFloat(1);
    ypoints[i] = int(apoint)*20;    // *50 to get a decent value of y - for temp being 20ish x is 1000.....not good like this
   }
  
  ////////////making an array of x values///////////
  xpoints = expand(xpoints, readingslen);
  xpoints[0] = 0;  ///first point always 0 left of screen
  for ( int i = 1; i < (readingslen-1); i++){
    xpoints[i] = (width/readingslen)*i;
  }
  xpoints[readingslen-1] = width;
  println(ypoints);
  println(xpoints);
}


String getreadings(String urlsite){
  
  String htmlText="";;   

  try {
    // Create a URL object
    URL url = new URL(urlsite);
    URLConnection conn = url.openConnection();
    conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB;     rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13 (.NET CLR 3.5.30729)");
    // Read all of the text returned by the HTTP server
    BufferedReader in = new BufferedReader
      (new InputStreamReader(conn.getInputStream(), "UTF-8"));
 
    String readLine;
 
    while ( (readLine = in.readLine ()) != null) {
      // Keep in mind that readLine() strips the newline characters
      //System.out.println(readLine);
      htmlText = htmlText+'\n'+readLine;
    }
    in.close();
  } 
  catch (MalformedURLException e) {
    e.printStackTrace();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
  
  return htmlText;
}  
  
///////////////////////////////////End  of functions to get historical readings from api  ///////////////////////////////////////
 
void getData(){
  
  resourceURL = "http://data.smartcitizen.me/v0/devices/"+kitID;
  
  JSONObject sckData = loadJSONObject(resourceURL);
  
  JSONObject version = sckData.getJSONObject("hardware_info");  //object with hardware info
  
  JSONArray systemtags = sckData.getJSONArray("system_tags");  //object with system tags info
  
  JSONObject data = sckData.getJSONObject("data");  // object with location object and sensors array
  
  JSONObject location = data.getJSONObject("location"); // object within data with location

// pulling UTC timestamp of last recorded sensor values
  timeStamp = data.getString("recorded_at");

// pulling hardware
  //hardware = version.getString("hw_ver");
  
// pulling system tags for indoor/outdoor and online/offline
  
  tagarraylen = systemtags.size();
  for ( int i = 0; i < tagarraylen; i++){
    tag = systemtags.getString(i);
    if (tag == "new"){
      i++;
    }else{
      tag1 = systemtags.getString(i);
      tag2 = systemtags.getString(i+1);
      break;
    }
  }

  
// pulling city and country  
  city = location.getString("city");
  country  = location.getString("country");
  //exposure = location.getString("exposure");
  lat = location.getFloat("latitude");
  lon = location.getFloat("longitude");
 
  JSONArray sensors = data.getJSONArray("sensors");   // You can get general device information from here

  JSONObject noiseSensor = sensors.getJSONObject(4);     // You can get properties from an specific datapoint to do whatever you want.
  noise = noiseSensor.getFloat("value");
  
  JSONObject lightSensor = sensors.getJSONObject(2);     // You can get properties from an specific datapoint to do whatever you want.
  light = lightSensor.getFloat("value");

  JSONObject co2 = sensors.getJSONObject(1);     // You can get properties from an specific datapoint to do whatever you want.
   c02 = co2.getFloat("value");

  JSONObject tempSensor = sensors.getJSONObject(10);     // You can get properties from an specific datapoint to do whatever you want.
  temp = tempSensor.getFloat("value");
  
  JSONObject humSensor = sensors.getJSONObject(9);     // You can get properties from an specific datapoint to do whatever you want.
   hum = humSensor.getFloat("value");

  JSONObject batSensor = sensors.getJSONObject(3);     // You can get properties from an specific datapoint to do whatever you want.
   bat = batSensor.getFloat("value");

  JSONObject pressureSensor = sensors.getJSONObject(5);     // You can get properties from an specific datapoint to do whatever you want.
   pressure = pressureSensor.getFloat("value");

  JSONObject part2Sensor = sensors.getJSONObject(8);     // You can get properties from an specific datapoint to do whatever you want.
   pm25 = part2Sensor.getFloat("value");
  
  JSONObject part10Sensor = sensors.getJSONObject(7);     // You can get properties from an specific datapoint to do whatever you want.
   pm10 = part10Sensor.getFloat("value");
  
  JSONObject part1Sensor = sensors.getJSONObject(10);     // You can get properties from an specific datapoint to do whatever you want.
   pm1 = part1Sensor.getFloat("value");
   
  JSONObject volSensor = sensors.getJSONObject(0);     // You can get properties from an specific datapoint to do whatever you want.
   vol = volSensor.getFloat("value");
   
   
  ///added for fetching local time
  
  String metaweatherqueryURL = "https://www.metaweather.com/api/location/search/?lattlong="+lat+","+lon; // api to search location and retrieve 'woeid'
  
  JSONArray query = loadJSONArray(metaweatherqueryURL);
  
  JSONObject result = query.getJSONObject(0);
   woe = result.getInt("woeid");
  
  metaweatherwoeidURL = "https://www.metaweather.com/api/location/"+woe; // api to query time from location search ressult
  
  JSONObject request = loadJSONObject(metaweatherwoeidURL);
    localtimestamp = request.getString("time");

  createtimes();
  getreadings();
  
  
  println("lastPost >> " + timeStamp + " Temp: " + temp + " ªC | C02: " + c02 + " ppm | BP " + pressure + " k Pa | Bat " + bat + " % | Light " + light + " lux | PM2.5 "  + pm25 + " ug/m3 | PM10 "  + pm10 + " ug/m3 | PM1 "  + pm1 + " ug/m3| Hum " + hum + " % Rel | Noise " + noise + " db | Vol "+ vol +" ppm");
  println(lastupdatelocal);
  lastUpdate = millis();
  
}
