/*
  Source: minim examples
  Data Source: https://coinmarketcap.com/
  
*/
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim       minim;
AudioOutput out;
Oscil       wave;

int WIDTH = 1024; // The width from the window
int HEIGHT = 400; // The height from the window

int amplitude = 50; // The amplitude from the sine waves

int waveYPosition = HEIGHT / 2; // The y position for the wave

float mainTextX = 150, mainTextY = 50, mainTextFontSize = 30; // The size from the text in the main ui
color mainTextColor = color(255, 255, 255); // The color from the main text


int menuButtonX = 20, menuButtonY = 20, menuButtonWidth = 80, menuButtonHeight = 40, menuButtonTextSize = 20; // define the menu button x, y, size, height & textSize
color menuButtonColor = color(240, 20, 15); // The menu button color 
color menuButtonHoverColor = color(150, 15, 10); // The menu button hover color
color menuButtonTextColor = color(255, 255, 255); // The menu button text color

Table bitcoin; // The table for bitcoin
Table ethereum; // The table for ethereum
Table ripple; // The table for ripple 

int currentUi = 1; // 1: Main Ui, 2: Menu

int index = 0; // The index in the array

Table currentTable; // 0: Bitcoin, 1: Ethereum, 2: Ripple

void setup()
{
   // Load the tables
   
   bitcoin = loadTable("data/Bitcoin.csv", "header");
   ethereum = loadTable("data/Ethereum.csv", "header");
   ripple = loadTable("data/Ripple.csv", "header");
   
   currentTable = bitcoin;
  
  size(1024, 400, P3D);
  
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  wave = new Oscil( 440, 0.5f, Waves.SINE );
  // patch the Oscil to the output
  wave.patch( out );
}

void draw()
{
  switch(currentUi) {
    case 1:
      drawMainUI();
    break;
     
    case 2:
      drawMenu();
    break;
    
    default: break;
    
  }
}

void drawMainUI () {
  background(0);
  stroke(255);
  strokeWeight(1);

  index++;
  if(index >= bitcoin.getRowCount()){
      index = 0;
  }
  TableRow currentRow = currentTable.getRow(index);
  String date = currentRow.getString("Date");
  float price = currentRow.getFloat("Close**");
  
  wave.setFrequency(price);
  println("On " + date + " the price for Bitcoin was " + price); 
  
  // draw the waveform of the output
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, waveYPosition - out.left.get(i)*amplitude,  i+1, waveYPosition - out.left.get(i+1)*amplitude );
  }
  
   drawButton(menuButtonX, menuButtonY, menuButtonWidth, menuButtonHeight, menuButtonColor, menuButtonHoverColor, menuButtonTextColor, menuButtonTextSize, "Menu");
  
  noStroke();
  fill(mainTextColor);
  
  textAlign(LEFT); 
  textSize(mainTextFontSize);
  text("On " + date + " the price for Bitcoin was " + price , mainTextX, mainTextY);
}

void drawButton (int x, int y, int width, int height, color buttonColor, color buttonHoverColor, color textColor, int textSize, String text) {
  textAlign(CENTER, CENTER); 
  textSize(textSize);
  noStroke();
  
  if(overButton(x, y, width, height)) {
    fill(buttonHoverColor);
  } else {
    fill(buttonColor);
  }
  
  rect(x, y, width, height);
  fill(textColor);
  text(text, x + width / 2, y + height / 2);
}

void drawMenu() {
  
}

boolean overButton(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void keyPressed()
{ 
  switch( key )
  {
    case '1': 
      wave.setWaveform( Waves.SINE );
      break;
     
    case '2':
      wave.setWaveform( Waves.TRIANGLE );
      break;
     
    case '3':
      wave.setWaveform( Waves.SAW );
      break;
    
    case '4':
      wave.setWaveform( Waves.SQUARE );
      break;
      
    case '5':
      wave.setWaveform( Waves.QUARTERPULSE );
      break;
     
    default: break; 
  }
  }
