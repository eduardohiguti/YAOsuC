// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 600;

pub fn main() anyerror!void {
    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Big Bosta");
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

    rl.setTargetFPS(60);

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

        rl.drawCircleV(center, 60, rl.Color.white);
        rl.drawRing(center, innerRadius, outerRadius, startAngle, endAngle, segments, rl.Color.maroon);
        rl.drawTextureV(num1, numbersPosition, rl.Color.black);

        if (rl.isKeyDown(rl.KeyboardKey.key_x)) rl.drawCircleV(center, 80, rl.fade(rl.Color.pink, 0.1));
        if (rl.isKeyDown(rl.KeyboardKey.key_z)) rl.drawCircleV(center, 80, rl.fade(rl.Color.green, 0.1));

        cursorPosition = rl.getMousePosition();
        rl.drawCircleV(cursorPosition, 20, rl.Color.yellow);

        const score = 50;
        rl.drawText(rl.textFormat("Score: %i", score), 10, 10, 40, rl.Color.white);
        rl.drawRectangle(10, 50, @intFromFloat(timePlayed * 200), 12, rl.Color.white);
    }

    rl.unloadMusicStream(music);
    rl.closeAudioDevice();
}
