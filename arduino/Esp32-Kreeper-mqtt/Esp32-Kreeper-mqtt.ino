//#include <NewPing.h>
#include <ArduinoJson.h>
#include <ESP32Servo.h>
#include <WiFi.h>
#include <PubSubClient.h>

//-------------------------------------------------------------------
//Defined of constants sensor approximited HC-SR04
//-------------------------------------------------------------------
//#define TRIG_PIN 23
//#define ECHO_PIN 22
//#define MAX_DISTANCE 400
//NewPing sonar(TRIG_PIN, ECHO_PIN, MAX_DISTANCE); 
//-------------------------------------------------------------------
// With this timer, the movement speed of the entire robot is set, the lower the number, the faster
//-------------------------------------------------------------------

int Time=120;

//-------------------------------------------------------------------
//  Definition of the initial position constants of each servo
//-------------------------------------------------------------------

#define FLB_centro      1100     //Front_Left_body_center    23
#define FRB_centro      1700     //Front_Right_body_center   32
#define BLB_centro      1800     //Back_Left_body_center     15
#define BRB_centro      1250     //Back_Right_body_center    13

#define FLK_centro      800      //Front_Left_knee_center    22
#define FRK_centro      800      //Front_Right_knee_center   33
#define BLK_centro      700      //Back_Left_knee_center     2
#define BRK_centro      600      //Back_Right_knee_center    12

//-------------------------------------------------------------------
// Definition of the Arduino Pins for each servo 
// FLB (FRONT LEFT BODY) FRB (FRONT RIGHT BODY)
// BLB (BACK LEFT BODY) BRB (BACK RIGHT BODY)
// FLK (FRONT LEFT KNEE) BRK (BACK RIGHT KNEE)
//------------------ Body --------------------------------------------
#define FLB_GPIO23 23    // Pin Front_Left_body
#define FRB_GPIO32 32      // Pin Front_Right_body
#define BLB_GPIO15 15    // Pin Back_Left_body
#define BRB_GPIO13 13      // Pin Back_Right_body
//---------------- Knee ---------------------------------------------
#define FLK_GPIO22 22      // Pin Front_Left_knee
#define FRK_GPIO33 33        // Pin Front_Right_knee
#define BLK_GPIO2  2      // Pin Back_Left_knee
#define BRK_GPIO12 12      // Pin Back_Right_knee
//-------------------------------------------------------------------

int movement_left;
int movement_right;
int levanta=-400;
int pos = 90;

int max_right = 0;
int max_left = 0;

int variable_sit=800;
int variable_swim=1200;

const int time_between_servo=5;
const int time_sit=50;
const int time_swim=50;

//-------------------------------------------------------------------
//       I define how I am going to call each servo
//-------------------------------------------------------------------
//------------------ Body -------------------------------------------
#define FLB_GPIO23 4    // Pin Front_Left_body
#define FRB_GPIO32 32      // Pin Front_Right_body
#define BLB_GPIO15 15    // Pin Back_Left_body
#define BRB_GPIO13 13      // Pin Back_Right_body
//---------------- Knee ---------------------------------------------
#define FLK_GPIO22 14      // Pin Front_Left_knee
#define FRK_GPIO33 33        // Pin Front_Right_knee
#define BLB_GPIO2  2      // Pin Back_Left_knee
#define BRK_GPIO12 12      // Pin Back_Right_knee

Servo FLB_servo;  // Servomotor Front_Right_body  (23)
Servo FRB_servo;  // Servomotor Front_Left_body   (32)
Servo BLB_servo;  // Servomotor Back_Left_body    (15)
Servo BRB_servo;  // Servomotor Back_Right_body   (13)
//---------------- Knee ---------------------------------------------
Servo FLK_servo;  // Servomotor Front_Left_knee   22)
Servo FRK_servo;  // Servomotor Front_Right_knee  (33)
Servo BLK_servo;  // Servomotor Back_Left_knee    (02)
Servo BRK_servo;  // Servomotor Back_Right_knee   (12)


// ********************************
// *********** MQTT CONFIG ********
// ********************************

const char *mqttServer = "192.168.0.5";
const int mqttPort = 1883;
const char *mqttUser = "";
const char *mqttPass = "";
const char *rootTopicSubscribe = "spider/movement";
const char *rootTopicPublish = "human/message";
const char *rootRegisterTopicPublish = "human/register/spider";

// ********************************
// *********** WIFI CONFIG ********
// ********************************

const char* ssid = "Iturralde";
const char* pass = "ITURRALDE123";
String macEsp32;    // the MAC address of your Wifi shield


// ********************************
// *********** GLOBALS ************
// ********************************

WiFiClient espClient;
PubSubClient client(espClient);
char msg[25];
String clientName;
String clientId;
// Create the JSON object
DynamicJsonDocument doc(128); // JSON object size (adjust according to your needs)

// ********************************
// *********** FUNCTIONS **********
// ********************************

void callback(char* topic, byte* payload, unsigned int length) {
  doc.clear();
  String jsonPayload = "";
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i=0;i<length;i++) {
    jsonPayload += (char)payload[i];
  }
  jsonPayload.trim();
  Serial.println("Message -> "+jsonPayload);
  // Parse the received JSON
  DeserializationError error = deserializeJson(doc, jsonPayload);
  if (error) {
    Serial.print("Error al analizar JSON: ");
    Serial.println(error.c_str());
    return;
  }

  // Read the values ​​of the JSON object
  const char* id = doc["client_id"];
  const int command = doc["command"];

  // Show data received
  Serial.print("ID: ");
  Serial.println(id);
  Serial.print("Command: ");
  Serial.println(command);
  moveKreeper(id, command);
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Create client ID
    clientName = "Lara";
    //clientName = "JeanRoldan";
    clientId = clientName;// + "_" + String(random(0xffff), HEX);
    // Attempt to connect
    doc.clear();
    if (client.connect(clientId.c_str(),mqttUser, mqttPass)) {
      Serial.println("connected!");
      doc["id"] = macEsp32;
      doc["client_id"] = clientId;
      doc["client_name"] = clientName;
      doc["status"] = true;
      publishTopic(rootRegisterTopicPublish);
      if(client.subscribe(rootTopicSubscribe)){
        Serial.println("Subscribe OK");
      }else{
        Serial.println("Fail Subscribe");
      }
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      doc["id"] = macEsp32;
      doc["client_id"] = clientId;
      doc["client_name"] = clientName;
      doc["status"] = false;
      publishTopic(rootRegisterTopicPublish);
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void setupWifi(){
  delay(10);
  Serial.println();
  Serial.print("Conecting a ssid: ");
  Serial.println(ssid);
  WiFi.begin(ssid, pass);
  while (WiFi.status() != WL_CONNECTED){
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("Conected to red WiFi!");
  Serial.println("Address IP: ");
  Serial.println(WiFi.localIP());
  Serial.print("ESP32 MAC Address: ");
  macEsp32 = WiFi.macAddress();
  Serial.println(macEsp32);
}

//-------------------------------------------------------------------
//                 Setting of inputs, outputs and functions
//-------------------------------------------------------------------

void setup()
{
  Serial.begin(115200);                   // Initializing the serial connection for debugging
  setupWifi();
  client.setServer(mqttServer, mqttPort);
  client.setCallback(callback);

  //-------------------------------------------------------------------
  // I initialize the servos with the names and what is their associated pin
  //-------------------------------------------------------------------
  FLB_servo.attach(FLB_GPIO23);           //define the servos with their pin 
  FRB_servo.attach(FRB_GPIO32); 
  BLB_servo.attach(BLB_GPIO15);  
  BRB_servo.attach(BRB_GPIO13);  
//---------------- Knee ---------------------------------------------  
  FLK_servo.attach(FLK_GPIO22);  
  FRK_servo.attach(FRK_GPIO33);  
  BLK_servo.attach(BLK_GPIO2);  
  BRK_servo.attach(BRK_GPIO12);
  moveInitialPosition();  
  delay(3000);                                    
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
}

//-------------------------------------------------------------------
//         Publish Topic
//-------------------------------------------------------------------
  
void publishTopic(const char* topic){
   if (client.connected()) {
      // Convert the JSON object to a string
      String jsonString;
      serializeJson(doc, jsonString);
      // Publish the JSON string to MQTT
      client.publish(topic, jsonString.c_str());
      delay(300);
    }
}

//-------------------------------------------------------------------
//         I start all the servos in their initial positions
//-------------------------------------------------------------------
  
void moveInitialPosition(){
  FLB_servo.writeMicroseconds(FLB_centro);       // send servo to its initial position
  delay(time_between_servo);
  FRB_servo.writeMicroseconds(FRB_centro); 
  delay(time_between_servo); 
  BLB_servo.writeMicroseconds(BLB_centro);  
  delay(time_between_servo);
  BRB_servo.writeMicroseconds(BRB_centro);  
  delay(time_between_servo);
  FLK_servo.writeMicroseconds(FLK_centro);  
  delay(time_between_servo);
  FRK_servo.writeMicroseconds(FRK_centro);  
  delay(time_between_servo);
  BLK_servo.writeMicroseconds(BLK_centro);  
  delay(time_between_servo);
  BRK_servo.writeMicroseconds(BRK_centro); 
  delay(time_between_servo);
}

void moveKreeper(const char* id,const int command){
  // Convert the String to a char array
  char charClientId[clientId.length() + 1];
  clientId.toCharArray(charClientId, sizeof(charClientId));
  bool isOK  = strcmp(id, charClientId) == 0 || strcmp(id, "all") == 0;
  if(isOK){
    // Use the switch statement with the char array
    switch (command) {
      case 0: 
        Serial.println("Initial Position");
        moveInitialPosition();
        break;
      case 1:
        Serial.println("Forward");
        walkForward(); 
        break;
      case 2:
        Serial.println("Back");
        walkBack();
        break;
      case 3:
        Serial.println("Right"); 
        turnRight();
        break; 
      case 4:
        Serial.println("Left"); 
        turnLeft();
        break;     
      case 5:
        Serial.println("Tragedy"); 
        tragedy();
        break;  
      case 6:
        Serial.println("Sit");
        sit();
        break;
      case 7:
        Serial.println("Greet"); 
        greet();
        break;  
      default:
        Serial.println("command unknown");
      }  
  }
}

//-------------------------------------------------------------------
//             Go forward
//-------------------------------------------------------------------

void walkForward()
{
   movement_left=300;
   movement_right=300;
   walk();
   walk();
}

//-------------------------------------------------------------------
//               Go back
//-------------------------------------------------------------------

void walkBack()
{
   movement_left=-300;
   movement_right=-300;
   walk();
   walk();
}

  
//-------------------------------------------------------------------
//                 Turn right
//-------------------------------------------------------------------


void turnRight() 
{
   movement_left=300;
   movement_right=-300;
   walk();
   walk();
}  

//-------------------------------------------------------------------
//                 Turn Left
//-------------------------------------------------------------------

void turnLeft() 
{
   movement_left=-300;
   movement_right=300;
   walk();
   walk();
}

//-------------------------------------------------------------------
//             Walking
//-------------------------------------------------------------------
void walk()
{
  FRK_servo.writeMicroseconds(FRK_centro-levanta);                // Raise the front right leg
  delay(time_between_servo);
  BLK_servo.writeMicroseconds(BLK_centro-levanta);                // Raise left rear leg
  delay(time_between_servo);
  FLB_servo.writeMicroseconds(FLB_centro-movement_left);          // move the front left leg back
  delay(time_between_servo);
  BRB_servo.writeMicroseconds(BRB_centro+movement_right);         // move right rear leg back
  delay(Time/2);
  FRB_servo.writeMicroseconds(FRB_centro-movement_right);         // move the front right leg forward
  delay(time_between_servo);
  BLB_servo.writeMicroseconds(BLB_centro+movement_left);          // move left rear leg forward
  delay(Time);
  FRK_servo.writeMicroseconds(FRK_centro);                        // lower front of right leg
  delay(time_between_servo);
  BLK_servo.writeMicroseconds(BLK_centro);                        // left rear lower leg
  delay(Time);
  FLK_servo.writeMicroseconds(FLK_centro-levanta);                // Raise left front leg
  delay(time_between_servo);
  BRK_servo.writeMicroseconds(BRK_centro-levanta);                // Raise right back leg
  delay(time_between_servo);
  FRB_servo.writeMicroseconds(FRB_centro+movement_right);         // Move the right front leg back
  delay(time_between_servo);
  BLB_servo.writeMicroseconds(BLB_centro-movement_left);          // Move the left rear leg back
  delay(Time/2);
  FLB_servo.writeMicroseconds(FLB_centro+movement_left);          // Move the left front leg forward
  delay(time_between_servo);
  BRB_servo.writeMicroseconds(BRB_centro-movement_right);         // Move the right back leg forward
  delay(Time);
  FLK_servo.writeMicroseconds(FLK_centro);                        // lower left front leg
  delay(time_between_servo);
  BRK_servo.writeMicroseconds(BRK_centro);                        // lower right rear leg
  delay(Time);  
}

//-------------------------------------------------------------------
//                  Tragedy
//-------------------------------------------------------------------
void tragedy()
{
  FLK_servo.writeMicroseconds(FLK_centro);                   // center servos
  delay(time_between_servo); 
  FRK_servo.writeMicroseconds(FRK_centro); 
  delay(time_between_servo);
  FLB_servo.writeMicroseconds(FLB_centro);  
  delay(time_between_servo);
  FRB_servo.writeMicroseconds(FRB_centro);  
  delay(time_between_servo);
  BLK_servo.writeMicroseconds(BLK_centro); 
  delay(time_between_servo); 
  BRK_servo.writeMicroseconds(BRK_centro); 
  delay(time_between_servo);
  BLB_servo.writeMicroseconds(BLB_centro);                      
  delay(time_between_servo);
  BRB_servo.writeMicroseconds(BRB_centro); 
  delay(time_between_servo);

  FLK_servo.writeMicroseconds(FLK_centro+variable_swim/3);  //it pulls little by little
  delay(time_swim);
  FRK_servo.writeMicroseconds(FRK_centro+variable_swim/3);
  delay(time_swim);
  BRK_servo.writeMicroseconds(BRK_centro+variable_swim/3);
  delay(time_swim);
  BLK_servo.writeMicroseconds(BLK_centro+variable_swim/3);
  delay(time_swim);

  FLK_servo.writeMicroseconds(FLK_centro+variable_swim/2);  //it pulls little by little
  delay(time_swim);
  FRK_servo.writeMicroseconds(FRK_centro+variable_swim/2);
  delay(time_swim);
  BRK_servo.writeMicroseconds(BRK_centro+variable_swim/2);
  delay(time_swim);
  BLK_servo.writeMicroseconds(BLK_centro+variable_swim/2);
  delay(time_swim);
  
  FLK_servo.writeMicroseconds(FLK_centro+variable_swim);   //it is finished throwing
  delay(time_swim);
  FRK_servo.writeMicroseconds(FRK_centro+variable_swim);
  delay(time_swim);
  BRK_servo.writeMicroseconds(BRK_centro+variable_swim);
  delay(time_swim);
  BLK_servo.writeMicroseconds(BLK_centro+variable_swim);
  delay(time_swim);

  int maximo=500;
  int repeticiones=6;
  int time_swim=80;

for(int i=0; i<=repeticiones; i++)
{
  
  for(int j=0;j<maximo;j=j+100)
    {
      BRB_servo.writeMicroseconds(BRB_centro+j);   // RIGHT BACK
      FRB_servo.writeMicroseconds(FRB_centro+j);   // RIGHT FRONT 

      BLB_servo.writeMicroseconds(BLB_centro-j);   // LEFT BACK
      FLB_servo.writeMicroseconds(FLB_centro-j);   // LEFT FRONT 
       
      delay(time_swim);
    }

  for(int j=maximo;j>0;j=j-100)
  {
     BRB_servo.writeMicroseconds(BRB_centro+j);   // RIGHT BACK
     FRB_servo.writeMicroseconds(FRB_centro+j);   // RIGHT FRONT
     BLB_servo.writeMicroseconds(BLB_centro-j);   // LEFT BACK
     FLB_servo.writeMicroseconds(FLB_centro-j);   // LEFT FRONT
     delay(time_swim);
  }

  for(int j=0;j<maximo;j=j+100)
  {
     BRB_servo.writeMicroseconds(BRB_centro-j);   // RIGHT BACK
     FRB_servo.writeMicroseconds(FRB_centro-j);   // RIGHT FRONT  
     BLB_servo.writeMicroseconds(BLB_centro+j);   // LEFT BACK 
     FLB_servo.writeMicroseconds(FLB_centro+j);   // LEFT FRONT
     delay(time_swim);
  }

  for(int j=maximo;j>0;j=j-100)
  {
     BRB_servo.writeMicroseconds(BRB_centro-j);   // RIGHT BACK
     FRB_servo.writeMicroseconds(FRB_centro-j);   // RIGHT FRONT
     BLB_servo.writeMicroseconds(BLB_centro+j);   // LEFT BACK
     FLB_servo.writeMicroseconds(FLB_centro+j);   // LEFT FRONT 
     delay(time_swim);
  }

}  
 
  delay(2500);                                      //wait 2,5 seconds
  
  FLK_servo.writeMicroseconds(FLK_centro);         // center servos
  delay(time_between_servo); 
  FRK_servo.writeMicroseconds(FRK_centro); 
  delay(time_between_servo);
  FLB_servo.writeMicroseconds(FLB_centro);  
  delay(time_between_servo);
  FRB_servo.writeMicroseconds(FRB_centro);  
  delay(time_between_servo);
  BLK_servo.writeMicroseconds(BLK_centro); 
  delay(time_between_servo); 
  BRK_servo.writeMicroseconds(BRK_centro); 
  delay(time_between_servo);
  BLB_servo.writeMicroseconds(BLB_centro);                      
  delay(time_between_servo);
  BRB_servo.writeMicroseconds(BRB_centro); 
  delay(500);
}  


//-------------------------------------------------------------------
//                  Sit
//-------------------------------------------------------------------
void sit()
{
  
  FRB_servo.writeMicroseconds(FRB_centro);
  delay(time_between_servo);
  FLB_servo.writeMicroseconds(FLB_centro);
  delay(time_between_servo);

  
  BRB_servo.writeMicroseconds(BRB_centro+variable_sit/3);  //it pulls little by little 
  delay(time_sit);
  BLB_servo.writeMicroseconds(BLB_centro-variable_sit/3);
  delay(time_sit);
  BRK_servo.writeMicroseconds(BRK_centro+variable_sit/3);
  delay(time_sit);
  BLK_servo.writeMicroseconds(BLK_centro+variable_sit/3);
  delay(time_sit);

  BRB_servo.writeMicroseconds(BRB_centro+variable_sit/2);  //it pulls little by little 
  delay(time_sit);
  BLB_servo.writeMicroseconds(BLB_centro-variable_sit/2);
  delay(time_sit);
  BRK_servo.writeMicroseconds(BRK_centro+variable_sit/2);
  delay(time_sit);
  BLK_servo.writeMicroseconds(BLK_centro+variable_sit/2);
  delay(time_sit);
  
  BRB_servo.writeMicroseconds(BRB_centro+variable_sit);   //it is finished throwing
  delay(time_sit);
  BLB_servo.writeMicroseconds(BLB_centro-variable_sit);
  delay(time_sit);
  BRK_servo.writeMicroseconds(BRK_centro+variable_sit);
  delay(time_sit);
  BLK_servo.writeMicroseconds(BLK_centro+variable_sit);
  delay(time_sit);
  
  delay(2500);                //wait 2,5 seconds
  
  FLK_servo.writeMicroseconds(FLK_centro); 
  delay(time_between_servo); 
  FRK_servo.writeMicroseconds(FRK_centro); 
  delay(time_between_servo);
  FLB_servo.writeMicroseconds(FLB_centro);  
  delay(time_between_servo);
  FRB_servo.writeMicroseconds(FRB_centro);  
  delay(time_between_servo);
  BLK_servo.writeMicroseconds(BLK_centro); 
  delay(time_between_servo); 
  BRK_servo.writeMicroseconds(BRK_centro); 
  delay(time_between_servo);
  BLB_servo.writeMicroseconds(BLB_centro);                      // center servos
  delay(time_between_servo);
  BRB_servo.writeMicroseconds(BRB_centro); 
  delay(500);
}  

//-------------------------------------------------------------------
//                  Greet
//-------------------------------------------------------------------

void greet(void)
{
  
  FRB_servo.writeMicroseconds(FRB_centro);
  delay(time_between_servo);
  FLB_servo.writeMicroseconds(FLB_centro);
  delay(time_between_servo);

  BRB_servo.writeMicroseconds(BRB_centro+variable_sit);  //it throws himself to the floor on his side
  delay(time_between_servo);
  BLB_servo.writeMicroseconds(BLB_centro-variable_sit);
  delay(time_between_servo);

  FRK_servo.writeMicroseconds(2550);
  delay(time_sit);
  BRK_servo.writeMicroseconds(BRK_centro+variable_sit/3);
  delay(time_sit);
  BLK_servo.writeMicroseconds(BLK_centro+variable_sit/3);
  delay(time_sit);
  BLK_servo.writeMicroseconds(BLK_centro+variable_sit/2);
  delay(time_sit);
  BLK_servo.writeMicroseconds(BLK_centro+variable_sit);
  delay(time_sit);

  moveKneeFront();
  moveKneeFront();
  delay(1000);
  
  FLK_servo.writeMicroseconds(FLK_centro);     // center servos
  delay(time_between_servo); 
  FRK_servo.writeMicroseconds(FRK_centro); 
  delay(time_between_servo);
  FLB_servo.writeMicroseconds(FLB_centro);  
  delay(time_between_servo);
  FRB_servo.writeMicroseconds(FRB_centro);  
  delay(time_between_servo);
  BLK_servo.writeMicroseconds(BLK_centro); 
  delay(time_between_servo); 
  BRK_servo.writeMicroseconds(BRK_centro); 
  delay(time_between_servo);
  BLB_servo.writeMicroseconds(BLB_centro);                      
  delay(time_between_servo);
  BRB_servo.writeMicroseconds(BRB_centro); 
  
  delay(500);
}  

//-------------------------------------------------------------------
//                  Move Paw in Front
//-------------------------------------------------------------------

void moveKneeFront(void)
{
  int maximo=500;
  int tiempo_saluda=80;
  
  for(int j=0;j<maximo;j=j+100)
  {
  FRB_servo.writeMicroseconds(FRB_centro+j);  
  delay(tiempo_saluda);
  }

  for(int j=maximo;j>0;j=j-100)
  {
  FRB_servo.writeMicroseconds(FRB_centro+j);  
  delay(tiempo_saluda);
  }

  for(int j=0;j<maximo;j=j+100)
  {
  FRB_servo.writeMicroseconds(FRB_centro-j);  
  delay(tiempo_saluda);
  }

  for(int j=maximo;j>0;j=j-100)
  {
  FRB_servo.writeMicroseconds(FRB_centro-j);  
  delay(tiempo_saluda);
  }
}

//-------------------------------------------------------------------
//               End program
//-------------------------------------------------------------------
