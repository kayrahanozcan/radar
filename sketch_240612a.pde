import processing.serial.*; // Seri haberleşme için gerekli kütüphaneyi içe aktarır
import java.awt.event.KeyEvent; // Seri porttan veri okumak için gerekli kütüphaneyi içe aktarır
import java.io.IOException;
Serial myPort; // Seri portu tanımlar
// Değişkenleri tanımlar
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;
PFont orcFont;

void setup() {
  size(1200, 700); // Ekran boyutunu ayarlar
  smooth();
  myPort = new Serial(this, "COM6", 9600); // Seri iletişimi başlatır
  myPort.bufferUntil('.'); // Seri porttan '.' karakterine kadar veri okur
}

void draw() {
  fill(98,245,31);
  noStroke();
  fill(0,4); 
  rect(0, 0, width, height-height*0.065); // Hareket bulanıklığını ve yavaş solmayı simüle eder
  
  fill(98,245,31); // Yeşil renk
  drawRadar(); // Radar çizim fonksiyonunu çağırır
  drawLine(); // Çizgi çizim fonksiyonunu çağırır
  drawObject(); // Nesne çizim fonksiyonunu çağırır
  drawText(); // Metin çizim fonksiyonunu çağırır
}

void serialEvent(Serial myPort) { // Seri porttan veri okuma işlevi
  data = myPort.readStringUntil('.'); // Seri porttan '.' karakterine kadar veri okur ve "data" değişkenine atar
  data = data.substring(0, data.length()-1); // Son karakteri ('.') çıkarır
  
  index1 = data.indexOf(","); // ',' karakterinin konumunu bulur ve "index1" değişkenine atar
  angle = data.substring(0, index1); // Veriyi "index1" konumuna kadar okur ve açı değeri olarak ayırır
  distance = data.substring(index1 + 1, data.length()); // "index1" konumundan sonuna kadar okur ve mesafe değeri olarak ayırır
  
  iAngle = Integer.parseInt(angle); // Açı değerini Integer'a çevirir
  iDistance = Integer.parseInt(distance); // Mesafe değerini Integer'a çevirir
}

void drawRadar() {
  pushMatrix();
  translate(width/2, height - height*0.074); // Başlangıç koordinatlarını yeni konuma taşır
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  arc(0, 0, (width - width*0.0625), (width - width*0.0625), PI, TWO_PI); // Yay çizgilerini çizer
  arc(0, 0, (width - width*0.27), (width - width*0.27), PI, TWO_PI);
  arc(0, 0, (width - width*0.479), (width - width*0.479), PI, TWO_PI);
  arc(0, 0, (width - width*0.687), (width - width*0.687), PI, TWO_PI);
  line(-width/2, 0, width/2, 0); // Açı çizgilerini çizer
  line(0, 0, (-width/2)*cos(radians(30)), (-width/2)*sin(radians(30)));
  line(0, 0, (-width/2)*cos(radians(60)), (-width/2)*sin(radians(60)));
  line(0, 0, (-width/2)*cos(radians(90)), (-width/2)*sin(radians(90)));
  line(0, 0, (-width/2)*cos(radians(120)), (-width/2)*sin(radians(120)));
  line(0, 0, (-width/2)*cos(radians(150)), (-width/2)*sin(radians(150)));
  line((-width/2)*cos(radians(30)), 0, width/2, 0);
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width/2, height - height*0.074); // Başlangıç koordinatlarını yeni konuma taşır
  strokeWeight(9);
  stroke(255,10,10); // Kırmızı renk
  pixsDistance = iDistance * ((height - height*0.1666) * 0.025); // Mesafeyi cm'den piksele çevirir
  if(iDistance < 40) { // Mesafeyi 40 cm ile sınırlar
    line(pixsDistance*cos(radians(iAngle)), -pixsDistance*sin(radians(iAngle)), (width - width*0.505)*cos(radians(iAngle)), -(width - width*0.505)*sin(radians(iAngle))); // Nesneyi açı ve mesafeye göre çizer
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);
  translate(width/2, height - height*0.074); // Başlangıç koordinatlarını yeni konuma taşır
  line(0, 0, (height - height*0.12)*cos(radians(iAngle)), -(height - height*0.12)*sin(radians(iAngle))); // Açıya göre çizgi çizer
  popMatrix();
}


void drawText() {
  pushMatrix();
  if(iDistance > 40) { // Mesafe 40 cm'den büyükse
    noObject = "Out of Range"; // "Out of Range" mesajını göster
  } else { // Mesafe 40 cm'den küçükse
    noObject = "In Range"; // "In Range" mesajını göster
  }
  fill(0,0,0); // Siyah renk ile doldur
  noStroke(); // Kenarlık yok
  rect(0, height - height*0.0648, width, height); // Arka plan kutusunu çizer
  fill(98,245,31); // Yeşil renk
  textSize(25);
  
  // Mesafe etiketlerini çizer
  text("10cm", width - width*0.3854, height - height*0.0833);
  text("20cm", width - width*0.281, height - height*0.0833);
  text("30cm", width - width*0.177, height - height*0.0833);
  text("40cm", width - width*0.0729, height - height*0.0833);

  textSize(40);
  // Başlık ve açı/metin bilgilerini çizer
  text("Gömülü Sistemler Ödev ", width - width*0.875, height - height*0.0277);
  text("Açı: " + iAngle + " °", width - width*0.48, height - height*0.0277);
  text("Cm: ", width - width*0.26, height - height*0.0277);

  if(iDistance < 40) { // Mesafe 40 cm'den küçükse
    text("        " + iDistance + " cm", width - width*0.225, height - height*0.0277);
  }

  textSize(25);
  fill(98,245,60); // Açık yeşil renk

  // Açı etiketlerini çizer ve döndürerek yerleştirir
  translate((width - width*0.4994) + width/2*cos(radians(30)), (height - height*0.0907) - width/2*sin(radians(30)));
  rotate(-radians(-60));
  text("30°", 0, 0);

  resetMatrix();
  translate((width - width*0.503) + width/2*cos(radians(60)), (height - height*0.0888) - width/2*sin(radians(60)));
  rotate(-radians(-30));
  text("60°", 0, 0);

  resetMatrix();
  translate((width - width*0.507) + width/2*cos(radians(90)), (height - height*0.0833) - width/2*sin(radians(90)));
  rotate(radians(0));
  text("90°", 0, 0);

  resetMatrix();
  translate(width - width*0.513 + width/2*cos(radians(120)), (height - height*0.07129) - width/2*sin(radians(120)));
  rotate(radians(-30));
  text("120°", 0, 0);

  resetMatrix();
  translate((width - width*0.5104) + width/2*cos(radians(150)), (height - height*0.0574) - width/2*sin(radians(150)));
  rotate(radians(-60));
  text("150°", 0, 0);

  popMatrix();
}
