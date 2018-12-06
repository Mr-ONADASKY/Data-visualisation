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

String tableDate = "Date", tableCoinValue = "Close**";

int amplitude = 100; // The amplitude from the sine waves

int waveYPosition = HEIGHT / 2; // The y position for the wave

float mainTextX = 150, mainTextY = 50, mainTextFontSize = 30; // The coordinates & size from the text in the main ui
color mainTextColor = color(255, 255, 255); // The color from the main text

float frequencyTextX = WIDTH - 250, frequencyTextY = HEIGHT - 20, frequencyTextFontSize = 20; // The coordinates & size from the text in the main ui
color frequencyTextColor = color(255, 255, 255); // The color from the main text


int menuButtonX = 20, menuButtonY = 20, menuButtonWidth = 80, menuButtonHeight = 40, menuButtonTextSize = 20; // define the menu button x, y, size, height & textSize
color menuButtonColor = color(240, 20, 15); // The menu button color 
color menuButtonHoverColor = color(150, 15, 10); // The menu button hover color
color menuButtonTextColor = color(255, 255, 255); // The menu button text color

int coin1ButtonX = WIDTH / 2 - 150, coin1ButtonY = HEIGHT - 50, coin1ButtonWidth = 80, coin1ButtonHeight = 40, coin1ButtonTextSize = 20; // define the first coin button x, y, size, height & textSize
color coin1ButtonColor = color(232, 151, 44); // The first coin button color 
color coin1ButtonHoverColor = color(172, 111, 28); // The first coin button hover color
color coin1ButtonTextColor = color(255, 255, 255); // The first coin button text color
String coin1Name = "Bitcoin"; // The name from the first coin

int coin2ButtonX = WIDTH / 2, coin2ButtonY = HEIGHT - 50, coin2ButtonWidth = 100, coin2ButtonHeight = 40, coin2ButtonTextSize = 20; // define the second coin button x, y, size, height & textSize
color coin2ButtonColor = color(92, 214, 255); // The second coin button color 
color coin2ButtonHoverColor = color(62, 154, 185); // The second coin button hover color
color coin2ButtonTextColor = color(255, 255, 255); // The second coin button text color
String coin2Name = "Ethereum"; // The name from the second coin

int coin3ButtonX = WIDTH / 2 + 150, coin3ButtonY = HEIGHT - 50, coin3ButtonWidth = 80, coin3ButtonHeight = 40, coin3ButtonTextSize = 20; // define the third coin button x, y, size, height & textSize
color coin3ButtonColor = color(107, 84, 255); // The third coin button color 
color coin3ButtonHoverColor = color(69, 54, 165); // The third coin button hover color
color coin3ButtonTextColor = color(255, 255, 255); // The third coin button text color
String coin3Name = "Ripple"; // The name from the third coin

int currentHoverAction = 0; // Which action should be called when clicked on a button, 0 = undefined

Table coin1; // The table for bitcoin
Table coin2; // The table for ethereum
Table coin3; // The table for ripple 

int currentUi = 1; // 1: Main Ui, 2: Menu

int tableIndex = 0; // The index in the array

Table currentTable; // 0: Bitcoin, 1: Ethereum, 2: Ripple

float minFreq = 50; // The minimum sound frequency
float maxFreq = 10000; // The maximum sound frequency

// DO NO CHANGE !!!! TEMP GLOBAL VALUES!!!

float maxCoinVal; // Global storage for the maximum coin value
float minCoinVal; // Global storage for the minimum coin value

String currentCoinName; // The name from the currentCoin;

float currentFrequency; // The current frequency

// Call once on program startup
void setup()
{
   // Load the tables
   
   coin1 = loadTable("data/Bitcoin.csv", "header");
   coin2 = loadTable("data/Ethereum.csv", "header");
   coin3 = loadTable("data/Ripple.csv", "header");
   
   currentTable = coin1;
   currentCoinName = coin1Name;
   onTableChange();
  
  size(1024, 400, P3D);
  
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  wave = new Oscil( 440, 0.5f, Waves.SINE );
  // patch the Oscil to the output
  wave.patch( out );
}

// Call on each frame
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

// Draw the mainUI and call the necessary functions to do it
void drawMainUI () {
   background(0);
  stroke(255);
  strokeWeight(1);

  tableIndex++;
  if(tableIndex >= currentTable.getRowCount()){
      tableIndex = 0;
  }
  TableRow currentRow = currentTable.getRow(tableIndex);
  String date = currentRow.getString(tableDate);
  float price = currentRow.getFloat(tableCoinValue);
  
     drawMainUiWave(price);
     drawMainUiTexts(date, price);
     drawMainUiButtons();
  
}

// Draw the main UI buttons
void drawMainUiButtons() {
   drawButton(menuButtonX, menuButtonY, menuButtonWidth, menuButtonHeight, menuButtonColor, menuButtonHoverColor, menuButtonTextColor, menuButtonTextSize, "Menu", 1);
   drawButton(coin1ButtonX, coin1ButtonY, coin1ButtonWidth, coin1ButtonHeight, coin1ButtonColor, coin1ButtonHoverColor, coin1ButtonTextColor, coin1ButtonTextSize, coin1Name, 2);
   drawButton(coin2ButtonX, coin2ButtonY, coin2ButtonWidth, coin2ButtonHeight, coin2ButtonColor, coin2ButtonHoverColor, coin2ButtonTextColor, coin2ButtonTextSize, coin2Name, 3);
   drawButton(coin3ButtonX, coin3ButtonY, coin3ButtonWidth, coin3ButtonHeight, coin3ButtonColor, coin3ButtonHoverColor, coin3ButtonTextColor, coin3ButtonTextSize, coin3Name, 4);
}

// Draw the texts in the main UI
void drawMainUiTexts(String date, float price) {
  noStroke();
  fill(mainTextColor);
  
  textAlign(LEFT); 
  textSize(mainTextFontSize);
  text("On " + date + " the price for " + currentCoinName + " was " + price , mainTextX, mainTextY);
  
  fill(frequencyTextColor);
  textSize(frequencyTextFontSize);
  float frequency =  roundNumber((map(price,minCoinVal, maxCoinVal, minFreq, maxFreq)), 2);
  text("Frequency: " + frequency + " Hz", frequencyTextX, frequencyTextY);
}

// Draw the wave
void drawMainUiWave(float price) {
  
  wave.setFrequency(map(price,minCoinVal, maxCoinVal, minFreq, maxFreq)); // Set the frequence based on mapping between the minimum and max coinValue
  
   // draw the waveform of the output
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, waveYPosition - out.left.get(i)*amplitude,  i+1, waveYPosition - out.left.get(i+1)*amplitude );
  }
}


// Draw a button with the given variables
void drawButton (int x, int y, int width, int height, color buttonColor, color buttonHoverColor, color textColor, int textSize, String text, int hoverAction) {
  textAlign(CENTER, CENTER); 
  textSize(textSize);
  noStroke();
  
  if(overButton(x, y, width, height)) {
    fill(buttonHoverColor);
    currentHoverAction = hoverAction;
  } else {
    fill(buttonColor);
    if(currentHoverAction == hoverAction) {
      hoverAction = 0;
    }
  }
  
  rect(x, y, width, height);
  fill(textColor);
  text(text, x + width / 2, y + height / 2);
}

// Draw the menu
void drawMenu() {
  
}

// Check if over the current button is hovered
boolean overButton(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

// Executer when the table changes
void onTableChange() {
  tableIndex = 0;
  maxCoinVal = 0;
  minCoinVal = 0;
  for (TableRow currentRow : currentTable.rows()) {
    float price = currentRow.getFloat(tableCoinValue);
    if(minCoinVal > price || minCoinVal == 0) {
       minCoinVal = price; 
    }
    
    if(maxCoinVal < price || maxCoinVal == 0) {
       maxCoinVal = price; 
    }
  }
  
}

// Round the number on a certain amount of digits
float roundNumber (float number, int digits) {
   
  float tempNumber = number * pow(10, digits);
  return round(tempNumber) / pow(10, digits);
}

// Event handler for mouse button click
void mouseClicked(){
  switch(currentHoverAction) {
   case 2:
     currentTable = coin1;
     currentCoinName = coin1Name;
     onTableChange();
   break;
   
   case 3:
     currentTable = coin2;
     currentCoinName = coin2Name;
     onTableChange();
   break;
   
   case 4:
     currentTable = coin3;
     currentCoinName = coin3Name;
     onTableChange();
   break;
    
   default:
   break;
  }
}


// Event handler for key press
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
