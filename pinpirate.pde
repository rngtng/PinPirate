
int val[128];

int samples = 128;
int delays = 1;

void setup()
{
  Serial.begin(115200);
  for(int k = 2; k <= 13; k++ ) {
    pinMode(k, INPUT); 
  }
}


void loop()
{ 
  for(int z = 0; z < samples; z = z+2) {
    val[z] = PIND & B11111100; //252
    val[z+1] = PINB;
    if(delays > 0 ) {
      delay(delays);
    }
  }
  
  for(int z = 0; z < samples; z++) {
    Serial.print(val[z]);
    Serial.print(" ");
  }
  //Serial.println("");
}

/*
void loop()
{ 
  for(int z = 0; z < 64; z++) {
    val[z] = 0;
    for(int k = 0; k < 8; k++) {
      val[z] = val[z] | (digitalRead(inPin) << k);
    }
  }
  for(int z = 0; z < 64; z++) {
    Serial.print(val[z]);
    Serial.print(" ");
  }
  Serial.println("");
}

*/
