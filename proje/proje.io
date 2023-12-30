
#include "config.h"
#include <Servo.h>

Servo servo;
#define yagmur A0
int su_miktari ;
int digital2IsActive=1;
int uyari = 0 ;  
AdafruitIO_Feed *digital = io.feed("digital");
AdafruitIO_Feed *digital2 = io.feed("digital2");


void setup() {
  servo.attach(5); 
  servo.write(0);

  Serial.begin(115200);

  while(!Serial);

  Serial.print("Connecting to Adafruit IO");
  io.connect();

  digital->onMessage(handleMessage);
    digital2->onMessage(handleMessage2);

  while(io.status() < AIO_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  Serial.println();
  Serial.println(io.statusText());
  digital->get();
    digital2->get();

}

void loop() {
 io.run();
if(digital2IsActive==0)
{
  su_miktari = analogRead(yagmur);
   su_miktari = su_miktari - 1024;
   delay(200);
   Serial.print("su miktarı : ");
   Serial.println(su_miktari);
   if(su_miktari<-10)
   {
    servo.write(180);
    }
   else{
    servo.write(0);
    }
  }
  
}

void handleMessage(AdafruitIO_Data *data) {
   Serial.print("received <- ");

  if (data->toPinLevel() == HIGH) {
    Serial.println("HIGH");//manuel
    Serial.println(data->toPinLevel());
    digital2IsActive=data->toPinLevel();
    
  } else {
    
    Serial.println("LOW");//otomatik

   
   Serial.println(data->toPinLevel());
   digital2IsActive=data->toPinLevel();
  }
}
void handleMessage2(AdafruitIO_Data *data) {//manuel durum
   Serial.print("received <- ");
if(digital2IsActive==1){
  if (data->toPinLevel() == HIGH) {
    Serial.println("HIGH");
    servo.write(180);

    
  } else {
    
    Serial.println("LOW");
    servo.write(0);

  }
  }
else{
  Serial.println("çalışamaz");}
  
}


   
