#include <WiFi.h>
#include <Firebase_ESP_Client.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Airtel_Aman Kansal"
#define WIFI_PASSWORD "@d1r2m3a4n5"

/* 2. Define the API Key */
#define API_KEY "AIzaSyA27lgwgBhByNuye_b5hVOZTeK7IjLLbis"

/* 3. Define the RTDB URL */
#define DATABASE_URL "https://saarthi-84622-default-rtdb.asia-southeast1.firebasedatabase.app/" 

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "naman.saarthi@gmail.com"
#define USER_PASSWORD "12345678"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

const int indexPin = 13;
const int middlePin = 12;
const int ringPin = 14;
const int pinkyPin = 27;

bool indexState = false;
bool middleState = false;
bool ringState = false;
bool pinkyState = false;

void updateFirebase(String path, bool state) {
  int firebaseValue = state ? 1 : 0;  // Use 1 for Touched and 0 for Not Touched
  Serial.print(firebaseValue);
  Firebase.RTDB.setInt(&fbdo, path, firebaseValue);  
}

void setup()
{
  pinMode(indexPin, INPUT_PULLUP);
  pinMode(middlePin, INPUT_PULLUP);
  pinMode(ringPin, INPUT_PULLUP);
  pinMode(pinkyPin, INPUT_PULLUP);

  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  // Comment or pass false value when WiFi reconnection will control by your code or third party library e.g. WiFiManager
  Firebase.reconnectNetwork(true);

  // Since v4.4.x, BearSSL engine was used, the SSL buffer need to be set.
  // Large data transmission may require larger RX buffer, otherwise connection issue or data read time out can be occurred.
  fbdo.setBSSLBufferSize(4096 /* Rx buffer size in bytes from 512 - 16384 */, 1024 /* Tx buffer size in bytes from 512 - 16384 */);

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;
}

void loop()
{
  // Firebase.ready() should be called repeatedly to handle authentication tasks.
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();

//  int ledState;
//   if(Firebase.RTDB.setInt(&fbdo, "/led/state", 100)){
//    digitalWrite(ledPin, ledState);
//   }else{
//    Serial.println(fbdo.errorReason().c_str());
//   }

//  // Check each finger pin state
  bool newIndexState = digitalRead(indexPin) == LOW;  // Touched if LOW
  bool newMiddleState = digitalRead(middlePin) == LOW;
  bool newRingState = digitalRead(ringPin) == LOW;
  bool newPinkyState = digitalRead(pinkyPin) == LOW;

  // Update Firebase if the state changes for any finger pin
  if (newIndexState != indexState) {
    indexState = newIndexState;
    updateFirebase("/gesture/index", indexState);
    Serial.println(indexState ? "Index Touched" : "Index Not Touched");
  }

  if (newMiddleState != middleState) {
    middleState = newMiddleState;
    updateFirebase("/gesture/middle", middleState);
    Serial.println(middleState ? "Middle Touched" : "Middle Not Touched");
  }

  if (newRingState != ringState) {
    ringState = newRingState;
    updateFirebase("/gesture/ring", ringState);
    Serial.println(ringState ? "Ring Touched" : "Ring Not Touched");
  }

  if (newPinkyState != pinkyState) {
    pinkyState = newPinkyState;
    updateFirebase("/gesture/pinky", pinkyState);
    Serial.println(pinkyState ? "Pinky Touched" : "Pinky Not Touched");
  }

  delay(100);  // Add a small delay to avoid rapid Firebase updates
  }
} 
