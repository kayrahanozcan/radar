#include <Servo.h> // Servo kütüphanesini ekler

// Ultrasonik sensörün Trigger ve Echo pinlerini tanımlar
const int trigPin = 10;
const int echoPin = 11;

// Süre ve mesafe için değişkenler
long duration;
int distance;

Servo myServo; // Servo motoru kontrol etmek için bir servo nesnesi oluşturur

void setup() {
  pinMode(trigPin, OUTPUT); // trigPin pinini çıkış olarak ayarlar
  pinMode(echoPin, INPUT); // echoPin pinini giriş olarak ayarlar
  Serial.begin(9600); // Seri haberleşmeyi başlatır
  myServo.attach(12); // Servo motorun bağlı olduğu pini tanımlar
}

void loop() {
  // Servo motoru 15 dereceden 165 dereceye döndürür
  for(int i=0; i<=180; i++){  
    myServo.write(i); // Servo motoru i derecesine döndürür
    delay(30); // 30 ms bekler
    distance = calculateDistance(); // Ultrasonik sensör tarafından ölçülen mesafeyi hesaplayan fonksiyonu çağırır
    
    Serial.print(i); // Mevcut açıyı seri porttan gönderir
    Serial.print(","); // İşleme IDE'sinde indeksleme için gerekli olan ek karakteri gönderir
    Serial.print(distance); // Mesafe değerini seri porttan gönderir
    Serial.print("."); // İşleme IDE'sinde indeksleme için gerekli olan ek karakteri gönderir
  }
  // Önceki satırları 165 dereceden 15 dereceye kadar tekrarlar
  for(int i=180; i>0; i--){  
    myServo.write(i); // Servo motoru i derecesine döndürür
    delay(30); // 30 ms bekler
    distance = calculateDistance(); // Ultrasonik sensör tarafından ölçülen mesafeyi hesaplayan fonksiyonu çağırır
    
    Serial.print(i); // Mevcut açıyı seri porttan gönderir
    Serial.print(","); // İşleme IDE'sinde indeksleme için gerekli olan ek karakteri gönderir
    Serial.print(distance); // Mesafe değerini seri porttan gönderir
    Serial.print("."); // İşleme IDE'sinde indeksleme için gerekli olan ek karakteri gönderir
  }
}

// Ultrasonik sensör tarafından ölçülen mesafeyi hesaplayan fonksiyon
int calculateDistance(){ 
  digitalWrite(trigPin, LOW); // trigPin'i LOW yapar
  delayMicroseconds(2); // 2 mikro saniye bekler
  
  // trigPin'i 10 mikro saniye boyunca HIGH yapar
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10); // 10 mikro saniye bekler
  digitalWrite(trigPin, LOW); // trigPin'i LOW yapar
  
  duration = pulseIn(echoPin, HIGH); // echoPin'i okur ve ses dalgasının seyahat süresini mikro saniye cinsinden döndürür
  distance = duration * 0.034 / 2; // Süreyi mesafeye çevirir (cm cinsinden)
  
  return distance; // Mesafeyi döndürür
}