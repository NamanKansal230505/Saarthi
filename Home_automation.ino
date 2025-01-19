#include <WiFi.h>
#include <Firebase_ESP_Client.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Airtel_M-1102"
#define WIFI_PASSWORD "amc@m1102"

/* 2. Define the API Key */
#define API_KEY "AIzaSyA27lgwgBhByNuye_b5hVOZTeK7IjLLbis"

/* 3. Define the RTDB URL */
#define DATABASE_URL "https://saarthi-84622-default-rtdb.asia-southeast1.firebasedatabase.app/"

/* 4. Define the user Email and password that already registered or added in your project */
#define USER_EMAIL "naman.saarthi@gmail.com"
#define USER_PASSWORD "12345678"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

const int ledPin1 = 16;
const int ledPin2 = 17;
const int ledPin3 = 18;
const int ledPin4 = 19;

void setup()
{
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
  pinMode(ledPin3, OUTPUT);
  pinMode(ledPin4, OUTPUT);
  digitalWrite(ledPin1, HIGH);
  digitalWrite(ledPin2, HIGH);
  digitalWrite(ledPin3, HIGH);
  digitalWrite(ledPin4, HIGH);

//  pinMode(PIR_SENSOR_PIN, INPUT); // Initialize PIR sensor pin as input

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
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();

    // Handle /index/hom
    int indexHom = 0;
    if (Firebase.RTDB.getInt(&fbdo, "/gesture/index/hom", &indexHom))
    {
      Serial.print("Index Hom: ");
      Serial.println(indexHom);

      if (indexHom == 1)
      {
        Serial.println("Led 1 Turned ON");
        digitalWrite(ledPin1, LOW);
      }
      else if (indexHom == 0)
      {
        Serial.println("Led 1 Turned OFF");
        digitalWrite(ledPin1, HIGH);
      }
    }
    else
    {
      Serial.print("Failed to read /index/hom: ");
      Serial.println(fbdo.errorReason().c_str());
    }

    // Handle /middle/hom
    int middleHom = 0;
    if (Firebase.RTDB.getInt(&fbdo, "/gesture/middle/hom", &middleHom))
    {
      Serial.print("Middle Hom: ");
      Serial.println(middleHom);

      if (middleHom == 1)
      {
        Serial.println("Led 2 Turned ON");
        digitalWrite(ledPin2, LOW);
      }
      else if (middleHom == 0)
      {
        Serial.println("Led 2 Turned OFF");
        digitalWrite(ledPin2, HIGH);
      }
    }
    else
    {
      Serial.print("Failed to read /middle/hom: ");
      Serial.println(fbdo.errorReason().c_str());
    }

    // Handle /ring/hom
    int ringHom = 0;
    if (Firebase.RTDB.getInt(&fbdo, "/gesture/ring/hom", &ringHom))
    {
      Serial.print("Ring Hom: ");
      Serial.println(ringHom);

      if (ringHom == 1)
      {
        Serial.println("Led 3 Turned ON");
        digitalWrite(ledPin3, LOW);
      }
      else if (ringHom == 0)
      {
        Serial.println("Led 3 Turned OFF");
        digitalWrite(ledPin3, HIGH);
      }
    }
    else
    {
      Serial.print("Failed to read /ring/hom: ");
      Serial.println(fbdo.errorReason().c_str());
    }

    // Handle /pinky/hom
    int pinkyHom = 0;
    if (Firebase.RTDB.getInt(&fbdo, "/gesture/pinky/hom", &pinkyHom))
    {
      Serial.print("Pinky Hom: ");
      Serial.println(pinkyHom);

      if (pinkyHom == 1)
      {
        Serial.println("Led 4 Turned ON");
        digitalWrite(ledPin4, LOW);
      }
      else if (pinkyHom == 0)
      {
        Serial.println("Led 4 Turned OFF");
        digitalWrite(ledPin4, HIGH);
      }
    }
    else
    {
      Serial.print("Failed to read /pinky/hom: ");
      Serial.println(fbdo.errorReason().c_str());
    } 
  }
}
