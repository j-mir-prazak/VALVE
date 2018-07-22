/*     Arduino Rotary Encoder Tutorial
 *      
 *  by Dejan Nedelkovski, www.HowToMechatronics.com
 *  
 */

 #include <avr/wdt.h>

 #define analogA A0
 #define analogB A1
 
 #define outputA 8
 #define outputB 9

 #define outputC 2
 #define outputD 3
 
 
 String counter1; 
 String counter2;
 
 String incomingString;
 
 int aState;
 int bState;
 
 int cState;
 int dState;
 
 int aLastState;  
 int cLastState;

 int currAB;
 int currAA;


 
 void setup() { 
   pinMode (outputA,INPUT);
   pinMode (outputB,INPUT);

   pinMode (outputC,INPUT);
   pinMode (outputD,INPUT);

   
   Serial.begin (9600);
    while (!Serial) {
      ; // wait for serial port to connect. Needed for native USB
       }
     if (Serial) { Serial.println("system:serialready"); }
   
   // Reads the initial state of the outputA
   aLastState = digitalRead(outputA);   
   cLastState = digitalRead(outputC);


 } 
 void loop() { 
  
   aState = digitalRead(outputA); // Reads the "current" state of the outputA
   bState = digitalRead(outputB);

   cState = digitalRead(outputC); // Reads the "current" state of the outputA
   dState = digitalRead(outputD);

    if (Serial.available() > 0) {
            // read the incoming byte:
            incomingString = Serial.readString();

            // say what you got:
            Serial.print("system:received:");
            Serial.println(incomingString);
            if (incomingString == "ready?") {
                 Serial.println("system:connected");
                 Serial.println("system:encoders:2");
            }
            else if (incomingString == "reset-now") {
              reset();
            }
    }

    //If the previous and the current state of the outputA are different, that means a Pulse has occured
   if (aState != aLastState){     
      //If the outputB state is different to the outputA state, that means the encoder is rotating clockwise
     if (digitalRead(outputB) != aState) { 
       counter1="+";
     } else {
       counter1="-";
     }
     Serial.print("A: ");
     Serial.println(aState);
     Serial.print("B: ");
     Serial.println(bState);
     Serial.print("encoder:1:");
     Serial.println(counter1);
     Serial.println("-----"); 

   }


   if (cState != cLastState){     
      //If the outputB state is different to the outputA state, that means the encoder is rotating clockwise
     if (digitalRead(outputD) != cState) { 
       counter2="+";
     } else {
       counter2="-";
     }
     Serial.print("C: ");
     Serial.println(cState);
     Serial.print("D: ");
     Serial.println(dState);
     Serial.print("encoder:2:");
     Serial.println(counter2);
     Serial.println("-----"); 

   }
   
//   button code
//   if ( cState == HIGH && cLastState != cState) {
//      Serial.println("High");
//    
//   }
//   else if (cState == LOW && cLastState != cState) {
//      currAA = analogRead(analogA);
//      currAB = analogRead(analogB);
//      
//      Serial.println("Low");
//      Serial.println(currAA);
//      Serial.println(currAB);
//    
//   }


   aLastState = aState; // Updates the previous state of the outputA with the current state
   cLastState = cState;
 }

 void reset(){
  Serial.println("system:reset");
  wdt_enable(WDTO_4S);
  
}

