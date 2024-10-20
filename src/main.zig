// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 600;

pub fn main() anyerror!void {
    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Big Bosta");
    defer rl.closeWindow();

    // AUDIO
    rl.initAudioDevice();

    const music = rl.loadMusicStream("resources/music.mp3");

    rl.playMusicStream(music);

    var timePlayed: f32 = 0.0;
    var pause = false;

    // LOAD TEXTURES

    const hitcircleImage = rl.loadImage("resources/hitcircle.png");
    const hitcircleTexture = rl.loadTextureFromImage(hitcircleImage);
    const default_1 = rl.loadImage("resources/default-1.png");
    const num1Texture = rl.loadTextureFromImage(default_1);
    const approachCircleImage = rl.loadImage("resources/approachcircle.png");
    const approachCircleTexture = rl.loadTextureFromImage(approachCircleImage);

    const score: i32 = 1000000;

    // MAIN GAME LOOP
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);
        rl.hideCursor();

        rl.updateMusicStream(music);

        if (rl.isKeyPressed(rl.KeyboardKey.key_space)) {
            pause = !pause;

            if (pause) {
                rl.pauseMusicStream(music);
            } else {
                rl.resumeMusicStream(music);
            }
        }

        timePlayed = rl.getMusicTimePlayed(music) / rl.getMusicTimeLength(music);

        rl.drawFPS(700, 580);

        hitcircle(200, 300, hitcircleTexture, num1Texture, approachCircleTexture);

        //TODO implementar score de algum jeito

        rl.drawText(rl.textFormat("Score: %d", .{score}), 10, 10, 40, rl.Color.white);
        rl.drawRectangle(10, 50, @intFromFloat(timePlayed * 200), 12, rl.Color.white);

        keyCounter();

        //Cursor
        //true or false to toggle hit explosion
        cursorInit(true);
    }

    rl.unloadImage(hitcircleImage);
    rl.unloadImage(default_1);
    rl.unloadImage(approachCircleImage);
    rl.unloadMusicStream(music);
    rl.closeAudioDevice();
}

var xKeyCount: i32 = 0;
var zKeyCount: i32 = 0;

fn keyCounter() void {
    const rightSquarePosition = rl.Vector2.init(770, 265);
    const leftSquarePosition = rl.Vector2.init(770, 305);
    const squareSize = rl.Vector2.init(30, 30);
    const rightKeyPosition = rl.Vector2.init(778, 268);
    const leftKeyPosition = rl.Vector2.init(778, 308);

    //Right key
    rl.drawRectangleV(rightSquarePosition, squareSize, rl.Color.white);
    if (rl.isKeyDown(rl.KeyboardKey.key_x)) rl.drawRectangleV(rightSquarePosition, squareSize, rl.Color.magenta);
    if (rl.isKeyPressed(rl.KeyboardKey.key_x)) xKeyCount += 1;
    rl.drawTextEx(rl.getFontDefault(), rl.textFormat("%d", .{xKeyCount}), rightKeyPosition, 15, 1, rl.Color.black);

    //Left key
    rl.drawRectangleV(leftSquarePosition, squareSize, rl.Color.white);
    if (rl.isKeyDown(rl.KeyboardKey.key_z)) rl.drawRectangleV(leftSquarePosition, squareSize, rl.Color.magenta);
    if (rl.isKeyPressed(rl.KeyboardKey.key_z)) zKeyCount += 1;
    rl.drawTextEx(rl.getFontDefault(), rl.textFormat("%d", .{zKeyCount}), leftKeyPosition, 15, 1, rl.Color.black);
}

fn cursorInit(activateHitExplosion: bool) void {
    var cursorPosition = rl.Vector2.init(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    cursorPosition = rl.getMousePosition();
    rl.drawCircleV(cursorPosition, 20, rl.Color.yellow);

    if (activateHitExplosion) {
        hitExplosion(cursorPosition);
    }
}

fn hitExplosion(cursorPosition: rl.Vector2) void {
    //Right key
    if (rl.isKeyDown(rl.KeyboardKey.key_x)) {
        rl.drawCircleV(cursorPosition, 80, rl.fade(rl.Color.pink, 0.1));
    }
    //Left key
    if (rl.isKeyDown(rl.KeyboardKey.key_z)) {
        rl.drawCircleV(cursorPosition, 80, rl.fade(rl.Color.green, 0.1));
    }
}

fn hitcircle(posX: f32, posY: f32, hitcircleTexture: rl.Texture2D, num1Texture: rl.Texture2D, approachCircleTexture: rl.Texture2D) void {
    const hitcirclePosition = rl.Vector2.init(posX, posY);

    rl.drawTextureV(hitcircleTexture, hitcirclePosition, rl.Color.green);
    hitcircleNumber(posX, posY, num1Texture);
    approachCircle(posX, posY, approachCircleTexture);
}

fn hitcircleNumber(posX: f32, posY: f32, num1Texture: rl.Texture2D) void {
    const numberPosition = rl.Vector2.init(posX + 37, posY + 35);

    rl.drawTextureV(num1Texture, numberPosition, rl.Color.white);
}

fn approachCircle(posX: f32, posY: f32, approachCircleTexture: rl.Texture2D) void {
    const approachCirclePosition = rl.Vector2.init(posX, posY);

    rl.drawTextureV(approachCircleTexture, approachCirclePosition, rl.Color.white);
}
