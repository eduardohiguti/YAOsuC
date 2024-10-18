// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 600;

pub fn main() anyerror!void {
    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Big Bosta");
    const font = rl.loadFont("resources/comic.ttf");
    defer rl.closeWindow();

    const center = rl.Vector2.init(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    const numbersPosition = rl.Vector2.init((SCREEN_WIDTH / 2) - 20, (SCREEN_HEIGHT / 2) - 25);
    var cursorPosition = center;

    const innerRadius = 60.0;
    const outerRadius = 65.0;

    const startAngle = 0.0;
    const endAngle = 360.0;
    const segments = 0.0;

    // IMAGE
    const default_1 = rl.loadImage("resources/default-1.png");
    const num1 = rl.loadTextureFromImage(default_1);
    rl.unloadImage(default_1);

    // AUDIO
    rl.initAudioDevice();

    const music = rl.loadMusicStream("resources/music.mp3");

    rl.playMusicStream(music);

    var timePlayed: f32 = 0.0;
    var pause = false;

    // SCORE

    rl.setTargetFPS(144);

    while (!rl.windowShouldClose()) {
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

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.drawFPS(0, 0);

        rl.drawCircleV(center, 60, rl.Color.white);
        rl.drawRing(center, innerRadius, outerRadius, startAngle, endAngle, segments, rl.Color.maroon);
        rl.drawTextureV(num1, numbersPosition, rl.Color.black);

        //Right key
        if (rl.isKeyDown(rl.KeyboardKey.key_x)) rl.drawCircleV(center, 80, rl.fade(rl.Color.pink, 0.1));
        //Left key
        if (rl.isKeyDown(rl.KeyboardKey.key_z)) rl.drawCircleV(center, 80, rl.fade(rl.Color.green, 0.1));

        //TODO implementar score de algum jeito
        //const score = 50;
        rl.drawText("1,000,000", 10, 10, 40, rl.Color.white);
        rl.drawRectangle(10, 50, @intFromFloat(timePlayed * 200), 12, rl.Color.white);

        //Right key
        const rightKey = rl.Vector2.init(774, 265);
        var rightKeyCount: i32 = 0;
        rl.drawRectangle(765, 265, 30, 30, rl.Color.white);
        if (rl.isKeyDown(rl.KeyboardKey.key_x)) {
            rl.drawRectangle(763, 263, 34, 34, rl.Color.magenta);
            rightKeyCount += 1;
        }
        rl.drawTextEx(font, "0", rightKey, 30, 20, rl.Color.black);

        //Left key
        const leftKey = rl.Vector2.init(774, 305);
        var leftKeyCount: i32 = 0;
        rl.drawRectangle(765, 305, 30, 30, rl.Color.white);
        if (rl.isKeyDown(rl.KeyboardKey.key_z)) {
            rl.drawRectangle(763, 303, 34, 34, rl.Color.magenta);
            leftKeyCount += 1;
        }
        rl.drawTextEx(font, "0", leftKey, 30, 20, rl.Color.black);

        //Cursor
        cursorPosition = rl.getMousePosition();
        rl.drawCircleV(cursorPosition, 20, rl.Color.yellow);
    }

    rl.unloadMusicStream(music);
    rl.closeAudioDevice();
    rl.unloadFont(font);
}
