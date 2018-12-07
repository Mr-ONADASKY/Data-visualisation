/*
  Source: minim examples, processing examples
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

int waveYPosition = HEIGHT / 2 - 50; // The y position for the wave

float mainTextX = 150, mainTextY = 50, mainTextFontSize = 30; // The coordinates & size from the text in the main ui
color mainTextColor = color(255, 255, 255); // The color from the main text

float frequencyTextX = WIDTH - 250, frequencyTextY = HEIGHT - 20, frequencyTextFontSize = 20; // The coordinates & size from the text in the main ui
color frequencyTextColor = color(255, 255, 255); // The color from the main text

int menuButtonX = 50, menuButtonY = 30, menuButtonWidth = 80, menuButtonHeight = 40, menuButtonTextSize = 20; // define the menu button x, y, size, height & textSize
color menuButtonColor = color(240, 20, 15); // The menu button color 
color menuButtonHoverColor = color(150, 15, 10); // The menu button hover color
color menuButtonTextColor = color(255, 255, 255); // The menu button text color

int coin1ButtonX = WIDTH / 2 - 150, coin1ButtonY = HEIGHT - 30, coin1ButtonWidth = 80, coin1ButtonHeight = 40, coin1ButtonTextSize = 20; // define the first coin button x, y, size, height & textSize
color coin1ButtonColor = color(232, 151, 44); // The first coin button color 
color coin1ButtonHoverColor = color(172, 111, 28); // The first coin button hover color
color coin1ButtonTextColor = color(255, 255, 255); // The first coin button text color
String coin1Name = "Bitcoin"; // The name from the first coin

int coin2ButtonX = WIDTH / 2, coin2ButtonY = HEIGHT - 30, coin2ButtonWidth = 100, coin2ButtonHeight = 40, coin2ButtonTextSize = 20; // define the second coin button x, y, size, height & textSize
color coin2ButtonColor = color(92, 214, 255); // The second coin button color 
color coin2ButtonHoverColor = color(62, 154, 185); // The second coin button hover color
color coin2ButtonTextColor = color(255, 255, 255); // The second coin button text color
String coin2Name = "Ethereum"; // The name from the second coin

int coin3ButtonX = WIDTH / 2 + 150, coin3ButtonY = HEIGHT - 30, coin3ButtonWidth = 80, coin3ButtonHeight = 40, coin3ButtonTextSize = 20; // define the third coin button x, y, size, height & textSize
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

HScrollbar playBar; // The play bar
int playBarX = 50, playBarY = HEIGHT - 120, playBarWidth = WIDTH - 100, playBarHeight = 20;
color playBarColor = color(240, 45, 42), playBarHandleColor = color(180, 35, 32), playBarHandleLockColor = color(140, 25, 25);
float playBarMin, playBarMax; // Min & max frequency possible to set with minFreqbar

int backwardsplayX = WIDTH / 2 - 50, backwardsPlayY = HEIGHT - 80, backwardsPlayWidth = 40, backwardsPlayHeight = 40; 
color backwardsPlayFillColor = color(240, 45, 42), backwardsPlayHoverColor = color(180, 35, 32), backwardsPlaySymbolFillColor = color(255, 255, 255), backwardsPlaySymbolStrokeColor = color(255, 255, 255);
float backwardsPlaySymbolStrokeWeight = 0, backwardsPlaySymbolSize = 1;
int backwardsPlayHoverAction = 6, backwardsPlaySymbol = 1;

int pauseX = WIDTH / 2, pauseY = HEIGHT - 80, pauseyWidth = 40, pauseHeight = 40; 
color pauseFillColor = color(240, 45, 42), pauseHoverColor = color(180, 35, 32), pauseSymbolFillColor = color(255, 255, 255), pauseSymbolStrokeColor = color(255, 255, 255);
float pauseSymbolStrokeWeight = 0, pauseSymbolSize = 1;
int pauseHoverAction = 7, pauseSymbol = 2;

int forwardsplayX = WIDTH / 2 + 50, forwardsPlayY = HEIGHT - 80, forwardsPlayWidth = 40, forwardsPlayHeight = 40; 
color forwardsPlayFillColor = color(240, 45, 42), forwardsPlayHoverColor = color(180, 35, 32), forwardsPlaySymbolFillColor = color(255, 255, 255), forwardsPlaySymbolStrokeColor = color(255, 255, 255);
float forwardsPlaySymbolStrokeWeight = 0, forwardsPlaySymbolSize = 1;
int forwardsPlayHoverAction = 8, forwardsPlaySymbol = 3;

int sinX = WIDTH / 2 - 350, sinY = HEIGHT - 80, sinWidth = 40, sinHeight = 40; 
color sinFillColor = color(240, 45, 42), sinHoverColor = color(180, 35, 32), sinSymbolFillColor = color(255, 255, 255), sinSymbolStrokeColor = color(255, 255, 255);
float sinSymbolStrokeWeight = 1, sinSymbolSize = 1;
int sinHoverAction = 9, sinSymbol = 4;

int triangleX = WIDTH / 2 - 300, triangleY = HEIGHT - 80, triangleWidth = 40, triangleHeight = 40; 
color triangleFillColor = color(240, 45, 42), triangleHoverColor = color(180, 35, 32), triangleSymbolFillColor = color(255, 255, 255), triangleSymbolStrokeColor = color(255, 255, 255);
float triangleSymbolStrokeWeight = 1, triangleSymbolSize = 1;
int triangleHoverAction = 10, triangleSymbol = 5;

int sawX = WIDTH / 2 - 250, sawY = HEIGHT - 80, sawWidth = 40, sawHeight = 40; 
color sawFillColor = color(240, 45, 42), sawHoverColor = color(180, 35, 32), sawSymbolFillColor = color(255, 255, 255), sawSymbolStrokeColor = color(255, 255, 255);
float sawSymbolStrokeWeight = 1, sawSymbolSize = 1;
int sawHoverAction = 11, sawSymbol = 6;

int squareX = WIDTH / 2 - 200, squareY = HEIGHT - 80, squareWidth = 40, squareHeight = 40; 
color squareFillColor = color(240, 45, 42), squareHoverColor = color(180, 35, 32), squareSymbolFillColor = color(255, 255, 255), squareSymbolStrokeColor = color(255, 255, 255);
float squareSymbolStrokeWeight = 1, squareSymbolSize = 1;
int squareHoverAction = 12, squareSymbol = 7;

int quarterPulseX = WIDTH / 2 - 150, quarterPulseY = HEIGHT - 80, quarterPulseWidth = 40, quarterPulseHeight = 40; 
color quarterPulseFillColor = color(240, 45, 42), quarterPulseHoverColor = color(180, 35, 32), quarterPulseSymbolFillColor = color(255, 255, 255), quarterPulseSymbolStrokeColor = color(255, 255, 255);
float quarterPulseSymbolStrokeWeight = 1, quarterPulseSymbolSize = 1;
int quarterPulseHoverAction = 13, quarterPulseSymbol = 8;

int muteX = WIDTH / 2 + 150, muteY = HEIGHT - 80, muteWidth = 40, muteHeight = 40; 
color muteFillColor = color(240, 45, 42), muteHoverColor = color(180, 35, 32), muteSymbolFillColor = color(255, 255, 255), muteSymbolStrokeColor = color(255, 255, 255);
float muteSymbolStrokeWeight = 1, muteSymbolSize = 1;
int muteHoverAction = 14, muteSymbol = 9;

int loopButtonX = WIDTH / 2 + 250, loopButtonY = HEIGHT - 80, loopButtonWidth = 80, loopButtonHeight = 40, loopButtonTextSize = 20, loopButtonHoverAction = 15; // define the loop button x, y, size, height & textSize
color loopButtonColor = color(240, 20, 15); // The loop button color 
color loopButtonHoverColor = color(150, 15, 10); // The loop button hover color
color loopButtonTextColor = color(255, 255, 255); // The loop button text color

int playbackSpeedButtonX = WIDTH / 2 + 350, playbackSpeedButtonY = HEIGHT - 80, playbackSpeedButtonWidth = 80, playbackSpeedButtonHeight = 40, playbackSpeedButtonTextSize = 20, playbackSpeedButtonHoverAction = 16; // define the playbackSpeed button x, y, size, height & textSize
color playbackSpeedButtonColor = color(240, 20, 15); // The playbackSpeed button color 
color playbackSpeedButtonHoverColor = color(150, 15, 10); // The playbackSpeed button hover color
color playbackSpeedButtonTextColor = color(255, 255, 255); // The playbackSpeed button text color

HScrollbar minFreqBar, maxFreqBar;  // Initialize minimum & max frequencybar
int minFreqBarX = 50, minFreqBarY = HEIGHT / 2 - 50, minFreqBarWidth = WIDTH - 200, minFreqBarHeight = 20;
color minFreqBarColor = color(240, 45, 42), minFreqBarHandleColor = color(180, 35, 32), minFreqBarHandleLockColor = color(140, 25, 25);
float minFreqBarMin = 10, minFreqBarMax = 20000; // Min & max frequency possible to set with minFreqbar

int maxFreqBarX = 50, maxFreqBarY = HEIGHT / 2 + 50, maxFreqBarWidth = WIDTH - 200, maxFreqBarHeight = 20;
color maxFreqBarColor = color(240, 45, 42), maxFreqBarHandleColor = color(180, 35, 32), maxFreqBarHandleLockColor = color(140, 25, 25);
float maxFreqBarMin = 10, maxFreqBarMax = 20000; // Min & max frequency possible to set with maxFreqbar

float minFreqBarTextX = 50, minFreqBarTextY = HEIGHT / 2 - 75, minFreqBarTextFontSize = 30; // The coordinates & size from the text in the minFreqBar ui
color minFreqBarTextColor = color(255, 255, 255); // The color from the minFreqBar text

float maxFreqBarTextX = 50, maxFreqBarTextY = HEIGHT / 2 + 25, maxFreqBarTextFontSize = 30; // The coordinates & size from the text in the minFreqBar ui
color maxFreqBarTextColor = color(255, 255, 255); // The color from the minFreqBar text

float menuTitleTextX = WIDTH / 2, menuTitleTextY = 50, menuTitleTextFontSize = 30; // The coordinates & size from the text in the main ui
color menuTitleTextColor = color(255, 255, 255); // The color from the main text

float menuVersionTextX = WIDTH - 250, menuVersionTextY = HEIGHT - 40, menuVersionTextFontSize = 20; // The coordinates & size from the text in the main ui
color menuVersionTextColor = color(255, 255, 255); // The color from the main text
String menuVersionText = "Version 1.4.1";

float menuDeveloperTextX = WIDTH - 250, menuDeveloperTextY = HEIGHT - 10, menuDeveloperTextFontSize = 20; // The coordinates & size from the text in the main ui
color menuDeveloperTextColor = color(255, 255, 255); // The color from the main text
String menuDeveloperText = "Made by Ninjawulf98";

// DO NO CHANGE !!!! TEMP GLOBAL VALUES!!!

float maxCoinVal; // Global storage for the maximum coin value
float minCoinVal; // Global storage for the minimum coin value

String currentCoinName; // The name from the currentCoin;

float currentFrequency; // The current frequency

boolean pause = false;
boolean forWardsPlay = true;
boolean mute = false;
boolean loop = true;
float playBackSpeed = 1;
String playbackSpeedString = "X 1";
float pureTableIndex = 0;

// Call once on program startup
void setup()
{
  
   // Load the tables  
   coin1 = loadTable("data/Bitcoin.csv", "header");
   coin2 = loadTable("data/Ethereum.csv", "header");
   coin3 = loadTable("data/Ripple.csv", "header");
   
   minFreqBar = new HScrollbar(minFreqBarX, minFreqBarY, minFreqBarWidth, minFreqBarHeight, 16, minFreqBarColor, minFreqBarHandleColor, minFreqBarHandleLockColor, minFreqBarMin, minFreqBarMax, minFreq);
   maxFreqBar = new HScrollbar(maxFreqBarX, maxFreqBarY, maxFreqBarWidth, maxFreqBarHeight, 16, maxFreqBarColor, maxFreqBarHandleColor, maxFreqBarHandleLockColor, maxFreqBarMin, maxFreqBarMax, maxFreq);

   
   currentTable = coin1;
   currentCoinName = coin1Name;
   
   playBar = new HScrollbar(playBarX, playBarY, playBarWidth, playBarHeight, 16, playBarColor, playBarHandleColor, playBarHandleLockColor, 0, currentTable.getRowCount(), 0);
   
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
      drawMenuUi();
    break;
    
    default: break;
    
  }
}

// Draw the mainUI and call the necessary functions to do it
void drawMainUI () {
  background(0);
  stroke(255);
  strokeWeight(1);
 
 if(!pause) {
   if(forWardsPlay){
    pureTableIndex += playBackSpeed;
    tableIndex = round(pureTableIndex);
    if(tableIndex >= currentTable.getRowCount()){
       pureTableIndex = 0;
       tableIndex = round(pureTableIndex);
       if (loop) {
         pause = true;
         wave.unpatch( out ); 
      }
    }
   } else {
     pureTableIndex -= playBackSpeed;
     tableIndex = round(pureTableIndex);
    if(tableIndex < 0){
      pureTableIndex = 0;
        tableIndex = round(pureTableIndex);
        if (loop) {
         pause = true;
         wave.unpatch( out ); 
      }
    }
   }
 }
  TableRow currentRow = currentTable.getRow(tableIndex);
  String date = currentRow.getString(tableDate);
  float price = currentRow.getFloat(tableCoinValue);
     drawMainUiWave(price);
     drawMainUiButtons();
     drawMainUiTexts(date, price);
}

// Draw the main UI buttons
void drawMainUiButtons() {
   drawButton(menuButtonX, menuButtonY, menuButtonWidth, menuButtonHeight, menuButtonColor, menuButtonHoverColor, menuButtonTextColor, menuButtonTextSize, "Menu", 1);
   drawButton(coin1ButtonX, coin1ButtonY, coin1ButtonWidth, coin1ButtonHeight, coin1ButtonColor, coin1ButtonHoverColor, coin1ButtonTextColor, coin1ButtonTextSize, coin1Name, 3);
   drawButton(coin2ButtonX, coin2ButtonY, coin2ButtonWidth, coin2ButtonHeight, coin2ButtonColor, coin2ButtonHoverColor, coin2ButtonTextColor, coin2ButtonTextSize, coin2Name, 4);
   drawButton(coin3ButtonX, coin3ButtonY, coin3ButtonWidth, coin3ButtonHeight, coin3ButtonColor, coin3ButtonHoverColor, coin3ButtonTextColor, coin3ButtonTextSize, coin3Name, 5);
   drawButton(playbackSpeedButtonX, playbackSpeedButtonY, playbackSpeedButtonWidth, playbackSpeedButtonHeight, playbackSpeedButtonColor, playbackSpeedButtonHoverColor, playbackSpeedButtonTextColor, playbackSpeedButtonTextSize, playbackSpeedString, playbackSpeedButtonHoverAction);
   drawButton(loopButtonX, loopButtonY, loopButtonWidth, loopButtonHeight, loopButtonColor, loopButtonHoverColor, loopButtonTextColor, loopButtonTextSize, "Loop", loopButtonHoverAction);

   drawSymbolButton(backwardsplayX, backwardsPlayY, backwardsPlayWidth, backwardsPlayHeight, backwardsPlayFillColor, backwardsPlayHoverColor, backwardsPlaySymbolFillColor, backwardsPlaySymbolStrokeColor, backwardsPlaySymbolStrokeWeight, backwardsPlaySymbolSize, backwardsPlayHoverAction, backwardsPlaySymbol);
   drawSymbolButton(pauseX, pauseY, pauseyWidth, pauseHeight, pauseFillColor, pauseHoverColor, pauseSymbolFillColor, pauseSymbolStrokeColor, pauseSymbolStrokeWeight, pauseSymbolSize, pauseHoverAction, pauseSymbol);
   drawSymbolButton(forwardsplayX, forwardsPlayY, forwardsPlayWidth, forwardsPlayHeight, forwardsPlayFillColor, forwardsPlayHoverColor, forwardsPlaySymbolFillColor, forwardsPlaySymbolStrokeColor, forwardsPlaySymbolStrokeWeight, forwardsPlaySymbolSize, forwardsPlayHoverAction, forwardsPlaySymbol);
   drawSymbolButton(sinX, sinY, sinWidth, sinHeight, sinFillColor, sinHoverColor, sinSymbolFillColor, sinSymbolStrokeColor, sinSymbolStrokeWeight, sinSymbolSize, sinHoverAction, sinSymbol);
   drawSymbolButton(triangleX, triangleY, triangleWidth, triangleHeight, triangleFillColor, triangleHoverColor, triangleSymbolFillColor, triangleSymbolStrokeColor, triangleSymbolStrokeWeight, triangleSymbolSize, triangleHoverAction, triangleSymbol);
   drawSymbolButton(sawX, sawY, sawWidth, sawHeight, sawFillColor, sawHoverColor, sawSymbolFillColor, sawSymbolStrokeColor, sawSymbolStrokeWeight, sawSymbolSize, sawHoverAction, sawSymbol);
   drawSymbolButton(squareX, squareY, squareWidth, squareHeight, squareFillColor, squareHoverColor, squareSymbolFillColor, squareSymbolStrokeColor, squareSymbolStrokeWeight, squareSymbolSize, squareHoverAction, squareSymbol);
   drawSymbolButton(quarterPulseX, quarterPulseY, quarterPulseWidth, quarterPulseHeight, quarterPulseFillColor, quarterPulseHoverColor, quarterPulseSymbolFillColor, quarterPulseSymbolStrokeColor, quarterPulseSymbolStrokeWeight, quarterPulseSymbolSize, quarterPulseHoverAction, quarterPulseSymbol);
   drawSymbolButton(muteX, muteY, muteWidth, muteHeight, muteFillColor, muteHoverColor, muteSymbolFillColor, muteSymbolStrokeColor, muteSymbolStrokeWeight, muteSymbolSize, muteHoverAction, muteSymbol);


   if(!playBar.locked) {
       playBar.updateValue(pureTableIndex);
   } else {
    pureTableIndex = round(playBar.value); 
   }
   
   playBar.update();
   playBar.display();
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


// Draw a button with the given variableswith text
void drawButton (int x, int y, int width, int height, color buttonColor, color buttonHoverColor, color textColor, int textSize, String text, int hoverAction) {
  rectMode(CENTER);
  textAlign(CENTER, CENTER); 
  textSize(textSize);
  noStroke();
  
  if(overButton(x, y, width, height)) {
    fill(buttonHoverColor);
    currentHoverAction = hoverAction;
  } else {
    fill(buttonColor);
    if(currentHoverAction == hoverAction) {
      currentHoverAction = 0;
    }
  }
  
  rect(x, y, width, height);
  fill(textColor);
  text(text, x, y);
}

// Draw a button with the given variables with a symbol
void drawSymbolButton (int x, int y, int width, int height, color buttonColor, color buttonHoverColor, color symbolFillColor, color symbolStrokeColor, float symbolStrokeWeight, float symbolSize, int hoverAction, int symbols) {
  noStroke();
  
  if(overButton(x, y, width, height)) {
    fill(buttonHoverColor);
    currentHoverAction = hoverAction;
  } else {
    fill(buttonColor);
    if(currentHoverAction == hoverAction) {
      currentHoverAction = 0;
    }
  }
  rect(x, y, width, height);
  drawSymbol(x, y, width, height, symbolSize, symbolFillColor, symbolStrokeColor, symbolStrokeWeight, symbols);
}

// Draw a symbol
void drawSymbol(int x, int y, int width, int height, float symbolSize, color fillColor, color strokeColor, float strokeWeight, int symbol) {
 int centerX = x;
 int centerY = y;
  switch(symbol) {
     case 1:
       strokeWeight(strokeWeight);
       stroke(strokeColor);
       fill(fillColor);
       triangle(centerX - 5 * symbolSize, centerY, centerX + 5 * symbolSize, centerY + 5 * symbolSize, centerX + 5 * symbolSize, centerY - 5 * symbolSize);
     break;
      
     case 2:
       strokeWeight(strokeWeight);
       stroke(strokeColor);
       fill(fillColor);
       
       quad(centerX - 6 * symbolSize, centerY + 5 * symbolSize, centerX - 2 * symbolSize, centerY + 5 * symbolSize, centerX - 2 * symbolSize, centerY - 5 * symbolSize, centerX - 6 * symbolSize, centerY - 5 * symbolSize);
       quad(centerX + 6 * symbolSize, centerY + 5 * symbolSize, centerX + 2 * symbolSize, centerY + 5 * symbolSize, centerX + 2 * symbolSize, centerY - 5 * symbolSize, centerX + 6 * symbolSize, centerY - 5 * symbolSize);
     break;
     
     case 3:
       strokeWeight(strokeWeight);
       stroke(strokeColor);
       fill(fillColor);
       
       triangle(centerX + 5 * symbolSize, centerY, centerX - 5 * symbolSize, centerY + 5 * symbolSize, centerX - 5 * symbolSize, centerY - 5 * symbolSize);
     break;
     
     case 4:
       strokeWeight(strokeWeight);
       stroke(strokeColor);
       noFill();
     
       for(float i = 0; i < TWO_PI; i += PI / 20.0) {
         point(centerX + symbolSize * i * 20 / TWO_PI - symbolSize * 10, centerY + 5 * symbolSize *  sin(i));
       }
     break;
     
     case 5:
       strokeWeight(strokeWeight);
       stroke(strokeColor);
       noFill();
       beginShape();
       vertex(centerX - 9 * symbolSize, centerY - 4 * symbolSize);
       vertex(centerX - 3 * symbolSize, centerY + 4 * symbolSize);
       vertex(centerX + 3 * symbolSize, centerY - 4 * symbolSize);
       vertex(centerX + 9 * symbolSize, centerY + 4 * symbolSize);
       endShape();
     break;
     
     case 6:
       strokeWeight(strokeWeight);
       stroke(strokeColor);
       noFill();
       beginShape();
       vertex(centerX - 9 * symbolSize, centerY - 4 * symbolSize);
       vertex(centerX, centerY + 4 * symbolSize);
       vertex(centerX, centerY - 4 * symbolSize);
       vertex(centerX + 9 * symbolSize, centerY + 4 * symbolSize);
       endShape();
     break;
     
     case 7:
       strokeWeight(strokeWeight);
       stroke(strokeColor);
       noFill();
       beginShape();
       vertex(centerX - 9 * symbolSize, centerY - 4 * symbolSize);
       vertex(centerX - 9 * symbolSize, centerY + 4 * symbolSize);
       vertex(centerX, centerY + 4 * symbolSize);
       vertex(centerX, centerY - 4 * symbolSize);
       vertex(centerX + 9 * symbolSize, centerY - 4 * symbolSize);
       vertex(centerX + 9 * symbolSize, centerY + 4 * symbolSize);
       endShape();
     break;
     
     case 8:
       strokeWeight(strokeWeight);
       stroke(strokeColor);
       noFill();
       beginShape();
       vertex(centerX - 12 * symbolSize, centerY - 4 * symbolSize);
       vertex(centerX - 12 * symbolSize, centerY + 4 * symbolSize);
       vertex(centerX - 6 * symbolSize, centerY + 4 * symbolSize);
       vertex(centerX - 6 * symbolSize, centerY - 4 * symbolSize);
       vertex(centerX + 6 * symbolSize, centerY - 4 * symbolSize);
       vertex(centerX + 6 * symbolSize, centerY + 4 * symbolSize);
       vertex(centerX + 12 * symbolSize, centerY + 4 * symbolSize);
       vertex(centerX + 12 * symbolSize, centerY - 4 * symbolSize);
       endShape();
     break;
     
     case 9:
       strokeWeight(strokeWeight);
       stroke(strokeColor);
       fill(fillColor);
       beginShape();
       vertex(centerX - 4 * symbolSize, centerY + 2 * symbolSize);
       vertex(centerX - 4 * symbolSize, centerY - 2 * symbolSize);
       vertex(centerX, centerY - 2 * symbolSize);
       vertex(centerX + 4 * symbolSize, centerY - 6 * symbolSize);
       vertex(centerX + 4 * symbolSize, centerY + 6 * symbolSize);
       vertex(centerX, centerY + 2 * symbolSize);
       endShape(CLOSE);
     break;
       
     default:
     break;
    
  }
  
}

// Draw the menu and call all the necessary functions
void drawMenuUi() {
  background(0);
  drawMenuButtons();
  minFreq = minFreqBar.value;
  maxFreq = maxFreqBar.value;
  drawMenuText();
}

// Draw all the text in the menu
void drawMenuText() {
  textAlign(CENTER, CENTER);
  fill(menuTitleTextColor);
  textSize(menuTitleTextFontSize);
  text("Menu", menuTitleTextX, menuTitleTextY);
  
  textAlign(LEFT);
  fill(minFreqBarTextColor);
  textSize(minFreqBarTextFontSize);
  text(minFreq, minFreqBarTextX, minFreqBarTextY);
  
  fill(maxFreqBarTextColor);
  textSize(maxFreqBarTextFontSize);
  text(maxFreq, maxFreqBarTextX, maxFreqBarTextY);
  
  fill(menuVersionTextColor);
  textSize(menuVersionTextFontSize);
  text(menuVersionText, menuVersionTextX, menuVersionTextY);
  
  fill(menuDeveloperTextColor);
  textSize(menuDeveloperTextFontSize);
  text(menuDeveloperText, menuDeveloperTextX, menuDeveloperTextY);
}

// Draw all the menu buttons
void drawMenuButtons() {
  drawButton(menuButtonX, menuButtonY, menuButtonWidth, menuButtonHeight, menuButtonColor, menuButtonHoverColor, menuButtonTextColor, menuButtonTextSize, "Exit", 2);
  minFreqBar.update();
  maxFreqBar.update();
  minFreqBar.display();
  maxFreqBar.display();
}

// Check if over the current button is hovered
boolean overButton(int x, int y, int width, int height)  {
  if (mouseX >= x - width / 2 && mouseX <= x + width / 2 && 
      mouseY >= y - width / 2 && mouseY <= y + height / 2) {
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
  if(forWardsPlay){
       playBar.updateBar(0, currentTable.getRowCount() - 1,0);
     }else {
       playBar.updateBar(0, currentTable.getRowCount() - 1, currentTable.getRowCount() - 1);
     }
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
   case 1:
     currentUi = 2;
     wave.unpatch(out);
   break;
   
   case 2:
     currentUi = 1;
     if(!pause) {
       wave.patch(out);
     }
    break;
    
   case 3:
     currentTable = coin1;
     currentCoinName = coin1Name;
     onTableChange();
   break;
   
   case 4:
     currentTable = coin2;
     currentCoinName = coin2Name;
     onTableChange();
   break;
   
   case 5:
     currentTable = coin3;
     currentCoinName = coin3Name;
     onTableChange();
   break;
   
   case 6:
     forWardsPlay = false;
     if(pause) {
       pause = false;
       wave.patch( out );
     }
     if(tableIndex == 0) {
        tableIndex = currentTable.getRowCount() - 1; 
     }
   break;
   
   case 7:
     pause = true;
     wave.unpatch( out ); 
   break;
   
   case 8:
     forWardsPlay = true;
     if(pause) {
       pause = false;
       wave.patch( out );
     }
     if(tableIndex >= currentTable.getRowCount() - 1) {
       tableIndex = 0;
     }
   break;
   
   case 9:
     wave.setWaveform( Waves.SINE);
   break;
   
   case 10:
     wave.setWaveform( Waves.TRIANGLE);
   break;
   
   case 11:
     wave.setWaveform( Waves.SAW);
   break;
   
   case 12:
     wave.setWaveform( Waves.SQUARE);
   break;
   
   case 13:
     wave.setWaveform( Waves.QUARTERPULSE);
   break;
   
   case 14:
     mute = !mute;
      if(mute) {
        out.mute();
      } else {
        out.unmute();
      }
   break;
   
   case 15:
     loop = !loop;
   break;
   
   case 16:
     switchPlayBackSpeed();
   break;
   
   default:
   break;
  }
} 

void switchPlayBackSpeed() {
   if(playBackSpeed == 1) {
     playBackSpeed = 2;
     playbackSpeedString = "X 2";
   } else if(playBackSpeed == 2) {
     playBackSpeed = 5;
     playbackSpeedString = "X 5";
   } else if(playBackSpeed == 5) {
     playBackSpeed = .25;
     playbackSpeedString = "X .25";
   } else if(playBackSpeed == .25) {
     playBackSpeed = .5;
     playbackSpeedString = "X .5";
   } else if(playBackSpeed == .5) {
     playBackSpeed = 1;
     playbackSpeedString = "X 1";
   }
}
