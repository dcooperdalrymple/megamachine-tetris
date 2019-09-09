import themidibus.*;

// Display Constants
final int ScreenWidth = 8;
final int ScreenHeight = 6;
final int ScreenScale = 64;

// Midi Constants
final String MidiDevice = "Real Time Sequencer";
final int MidiChannel = 0;
final int MidiStartNote = 36; // Screen start note at bottom left

// Game Logic Variables
final int GameFrameDelay = 1000;
final int ImageFrameDelay = 125;
int frameTime = 0;

final int GameState_Start = 1;
final int GameState_Play = 2;
final int GameState_Lose = 3;
int gameState = GameState_Start;

// Image Variables
final int GameStartWidth = 43;
final int[][] GameStartScreen = {
  { 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1 },
  { 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0 },
  { 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0 },
  { 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0 },
  { 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0 },
  { 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1 }
};
Image gameStartImage;

final int GameLoseWidth = 40;
final int[][] GameLoseScreen = {
  { 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0 },
  { 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1 },
  { 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1 },
  { 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0 },
  { 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1 },
  { 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 1 }
};
Image gameLoseImage;

// Tetromino Definitions
final int TetrominoCount = 7;
final int TetrominoSize = 4;
final int[][][] Tetrominos = {
  {
    { 0, 0, 1, 0 },
    { 0, 0, 1, 0 },
    { 0, 0, 1, 0 },
    { 0, 0, 1, 0 }
  }, {
    { 0, 0, 1, 0 },
    { 0, 1, 1, 0 },
    { 0, 1, 0, 0 },
    { 0, 0, 0, 0 }
  }, {
    { 0, 1, 0, 0 },
    { 0, 1, 1, 0 },
    { 0, 0, 1, 0 },
    { 0, 0, 0, 0 }
  }, {
    { 0, 0, 0, 0 },
    { 0, 1, 1, 0 },
    { 0, 1, 1, 0 },
    { 0, 0, 0, 0 }
  }, {
    { 0, 0, 1, 0 },
    { 0, 1, 1, 0 },
    { 0, 0, 1, 0 },
    { 0, 0, 0, 0 }
  }, {
    { 0, 0, 1, 0 },
    { 0, 0, 1, 0 },
    { 0, 1, 1, 0 },
    { 0, 0, 0, 0 }
  }, {
    { 0, 1, 0, 0 },
    { 0, 1, 0, 0 },
    { 0, 1, 1, 0 },
    { 0, 0, 0, 0 }
  }
};
Tetromino currentTetromino = null;

// Midi and Screen Objects
MidiBus midi;
Pixel[][] screen;
int[][] field;

void setup() {
  //size(screenWidth * screenScale, screenHeight * screenScale);
  size(512, 384);
  background(0);
  
  // Initialize Midi
  MidiBus.list();
  midi = new MidiBus(this, -1, MidiDevice);
  
  // Initialize Screen
  screen = new Pixel[ScreenHeight][ScreenWidth];
  int note = MidiStartNote;
  for (int i = ScreenHeight - 1; i >= 0; i--) {
    for (int j = 0; j < ScreenWidth; j++) {
      screen[i][j] = new Pixel(note++, j, i);
    }
  }
  
  // Initialize Game Field
  field = new int[ScreenHeight][ScreenWidth];
  for (int i = 0; i < ScreenHeight; i++) {
    for (int j = 0; j < ScreenWidth; j++) {
      field[i][j] = 0;
    }
  }
  
  // Initialize Images
  gameStartImage = new Image(GameStartScreen, GameStartWidth);
  gameLoseImage = new Image(GameLoseScreen, GameLoseWidth);
  
  // Setup Game for Start Screen
  currentTetromino = null;
  frameTime = millis();
  gameState = GameState_Start;
}

void draw() {  
  switch (gameState) {
    case GameState_Start:
      drawStart();
      break;
    case GameState_Lose:
      drawLose();
      break;
    case GameState_Play:
      gameUpdate();
      break;
  }
}

void drawStart() {
  if (millis() - frameTime < ImageFrameDelay) return;
  frameTime = millis();
  
  gameStartImage.display();
  
  gameStartImage.nudge();
  if (gameStartImage.getX() >= GameStartWidth) {
    gameStartImage.reset();
  }
}

void drawLose() {
  if (millis() - frameTime < ImageFrameDelay) return;
  frameTime = millis();
  
  gameLoseImage.display();
  
  gameLoseImage.nudge();
  if (gameLoseImage.getX() >= GameLoseWidth) {
    gameState = GameState_Start;
    gameStartImage.reset();
  }
}

void gameUpdate() {
  if (millis() - frameTime < GameFrameDelay) return;
  frameTime = millis();
  
  // Generate new tetromino
  if (currentTetromino == null) {
    int tetrominoIndex = floor(random(0, TetrominoCount));
    currentTetromino = new Tetromino(Tetrominos[tetrominoIndex]);
    if (tetrominoIndex == 3) { // Square
      currentTetromino.move(0, -1);      
    }
    return;
  }
  
  // Move tetromino down or place
  if (!currentTetromino.move(0, 1)) {
    currentTetromino.place();
    
    // Check for line clearing
    for (int i = 0; i < ScreenHeight; i++) {
      for (int j = 0; j < ScreenWidth; j++) {
        if (field[i][j] == 0) break;
        if (j == ScreenWidth - 1) {
          
          // Clear line and move array down
          for (int k = i; k > 0; k--) {
            arrayCopy(field[k - 1], field[k]);
          }
          
          // Clear top line
          for (int k = 0; k < ScreenWidth; k++) {
            field[0][k] = 0;
          }
          
        }
      }
    }
    
    // Check if final move
    if (currentTetromino.getY() <= 0) {
      
      // Check to see if a top pixel is active just incase top placement also cleared a line
      boolean topActive = false;
      for (int i = 0; i < ScreenWidth; i++) {
        if (field[0][i] == 1) {
          topActive = true;
          break;
        }
      }
      
      if (topActive == true) {
        // Game Over
        gameState = GameState_Lose;
        return;
      }
      
    }
    
    // Redraw screen and ensure that we're still playing
    for (int i = 0; i < ScreenHeight; i++) {
      for (int j = 0; j < ScreenWidth; j++) {
        screen[i][j].write(field[i][j]);
      }
    }
    
    // Reset Tetromino
    currentTetromino = null;
    frameTime = millis() - GameFrameDelay;
    
  }
}

void keyPressed() {
  //if (key != CODED) return;
  
  switch (gameState) {
    case GameState_Start:
      if (keyCode == ENTER || keyCode == java.awt.event.KeyEvent.VK_SPACE) {
        gameState = GameState_Play;
        resetGame();
      }
      break;
    case GameState_Play:
      if (currentTetromino == null) return;
      
      switch (keyCode) {
        case UP:
          currentTetromino.rotate();
          break;
        case DOWN:
          while (currentTetromino.move(0, 1)) { }
          frameTime = millis() - GameFrameDelay;
          break;
        case RIGHT:
          currentTetromino.move(1, 0);
          break;
        case LEFT:
          currentTetromino.move(-1, 0);
          break;
      }
      break;
  }
}

void resetGame() {
  currentTetromino = null;
  frameTime = millis() - GameFrameDelay;
  for (int i = 0; i < ScreenHeight; i++) {
    for (int j = 0; j < ScreenWidth; j++) {
      field[i][j] = 0;
      screen[i][j].write(field[i][j]);
    }
  }
}

class Pixel {
  private int _active;
  private int _note;
  private int _x, _y;
  
  Pixel(int note, int x, int y) {
    _note = note;
    _x = x;
    _y = y;
    
    _active = 0;
    display();
    midi();
  }
  
  public void write(int active) {
    write(active, false);
  }
  public void write(int active, boolean force) {
    if (_active != active || force == true) {
      // Write midi and screen
      display(active);
      midi(active);
    }
    _active = active;
  }
  
  public int read() {
    return _active;
  }
  
  private void midi() {
    midi(_active);
  }
  private void midi(int active) {
    midi(_note, active);
  }
  private void midi(int note, int active) {
    if (active == 1) {
      midi.sendNoteOn(MidiChannel, note, 127);
    } else {
      midi.sendNoteOff(MidiChannel, note, 127);
    }
  }
  
  private void display() {
    display(_active);
  }
  private void display(int active) {
    display(active, _x, _y);
  }
  private void display(int active, int x, int y) {
    noStroke();
    fill(active == 1 ? 255 : 0);
    rect(x * ScreenScale, y * ScreenScale, ScreenScale, ScreenScale);
  }
}

class Tetromino {
  private int[][] _matrix;
  private int _x;
  private int _y;
  
  Tetromino(int[][] matrix) {
    _x = floor(ScreenWidth / 2 - TetrominoSize / 2);
    _y = 0;
    _matrix = matrix;
    display();
  }
  
  // Properties
  
  public int getX() {
    return _x;
  }
  public int getY() {
    return _y;
  }
  
  // Translation and Rotation
  
  public boolean rotate() {
    return rotateRight();
  }
  private boolean rotateRight() {
    int[][] clone = new int[TetrominoSize][TetrominoSize];
    for (int i = 0; i < TetrominoSize; i++) {
      arrayCopy(_matrix[i], clone[i]); 
    }
    
    for (int i = 0; i < TetrominoSize; i++) {
      for (int j = 0; j < TetrominoSize; j++) {
        clone[i][j] = _matrix[TetrominoSize - j - 1][i];
      }
    }
    
    // Check if rotated piece fits
    if (!doesFit(clone)) return false;
    
    // Wipe screen and rewrite rotated matrix
    clear();
    _matrix = clone;
    display();
    
    return true;
  }
  private boolean rotateLeft() {
    int[][] clone = new int[TetrominoSize][TetrominoSize];
    for (int i = 0; i < TetrominoSize; i++) {
      arrayCopy(_matrix[i], clone[i]); 
    }
    
    for (int i = 0; i < TetrominoSize; i++) {
      for (int j = 0; j < TetrominoSize; j++) {
        clone[i][j] = _matrix[j][TetrominoSize - i - 1];
      }
    }
    
    if (!doesFit(clone)) return false;
    
    // Wipe screen and rewrite rotated matrix
    clear();
    _matrix = clone;
    display();
    
    return true;
  }
  
  public boolean move(int dX, int dY) {
    if (!doesFit(_x + dX, _y + dY)) return false;
    
    // Clear and update
    clear();
    _x += dX;
    _y += dY;
    display();
    
    return true;
  }
  
  // Collision
  
  private boolean doesFit(int[][] matrix) {
    return doesFit(matrix, _x, _y);
  }
  private boolean doesFit(int x, int y) {
    return doesFit(_matrix, x, y);
  }
  private boolean doesFit(int[][] matrix, int x, int y) {
    for (int i = y; i < y + TetrominoSize; i++) {
      for (int j = x; j < x + TetrominoSize; j++) {
        if (matrix[i - y][j - x] == 0) continue;
          
        // Check boundaries
        if (j < 0 || j >= ScreenWidth || i >= ScreenHeight) {
          return false;
        }
        
        // Check playfield
        if (i >= 0 && field[i][j] == 1) {
          return false;
        }
      }
    }
    
    return true;
  }
  
  // Playfield
  
  public void place() {
    place(_x, _y);
  }
  private void place(int x, int y) {
    for (int i = y; i < y + TetrominoSize; i++) {
      for (int j = x; j < x + TetrominoSize; j++) {
        if (_matrix[i - y][j - x] == 0) continue;
        
        // Check boundaries
        if (j < 0 || j >= ScreenWidth || i < 0 || i > ScreenHeight) continue;
        
        // Write to playfield
        field[i][j] = 1;
      }
    }
  }
  
  // Display
  
  public void display() {
    display(1);
  }
  public void clear() {
    display(0);
  }
  private void display(int active) {
    for (int i = max(_y, 0); i < _y + TetrominoSize && i < ScreenHeight; i++) {
      for (int j = max(_x, 0); j < _x + TetrominoSize && j < ScreenWidth; j++) {
        if (_matrix[i - _y][j - _x] == 1) {
          screen[i][j].write(active);
        }
      }
    }
  }
}

class Image {
  private int[][] _image;
  private int _width;
  private int _x;
  
  Image(int[][] image, int width) {
    _image = image;
    _width = width;
    _x = -ScreenWidth;
  }
  
  public int getX() {
    return _x;
  }
  public void setX(int x) {
    _x = x;
  }
  
  public void nudge() {
    _x++;
  }
  
  public void reset() {
    _x = -ScreenWidth;
  }
  
  public void display() {
    for (int i = 0; i < ScreenHeight; i++) {
      for (int j = 0; j < ScreenWidth; j++) {
        if (j + _x >= 0 && j + _x < _width) {
          screen[i][j].write(_image[i][j + _x]);
        } else {
          screen[i][j].write(0);
        }
      }
    }
  }
  
}
