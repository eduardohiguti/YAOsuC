// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 600;

pub fn main() anyerror!void {
    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Big Bosta");
    const font = rl.loadFont("resources/comic.ttf");
    defer rl.closeWindow();

    // AUDIO
    rl.initAudioDevice();

    const music = rl.loadMusicStream("resources/music.mp3");

    rl.playMusicStream(music);

    var timePlayed: f32 = 0.0;
    var pause = false;

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

        rl.drawFPS(700, 580);

        hitcircle(200, 300, 40);

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
        cursorInit(true);
    }

    rl.unloadMusicStream(music);
    rl.closeAudioDevice();
    rl.unloadFont(font);
}

fn cursorInit(ActivateHitExplosion: bool) void {
    var cursorPosition = rl.Vector2.init(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    cursorPosition = rl.getMousePosition();
    rl.drawCircleV(cursorPosition, 20, rl.Color.yellow);

    if (ActivateHitExplosion) {
        hit_explosion(cursorPosition);
    }
}

fn hit_explosion(cursorPosition: rl.Vector2) void {
    //Right key
    if (rl.isKeyDown(rl.KeyboardKey.key_x)) {
        rl.drawCircleV(cursorPosition, 80, rl.fade(rl.Color.pink, 0.1));
    }
    //Left key
    if (rl.isKeyDown(rl.KeyboardKey.key_z)) {
        rl.drawCircleV(cursorPosition, 80, rl.fade(rl.Color.green, 0.1));
    }
}

fn hitcircle(posX: f32, posY: f32, radius: f32) void {
    const HitCirclePosition = rl.Vector2.init(posX, posY);
    rl.drawCircleV(HitCirclePosition, radius, rl.Color.white);

    hitcircleNumber(posX, posY);

    approachCircle(posX, posY, radius);
}

fn hitcircleNumber(posX: f32, posY: f32) void {
    const default_1 = rl.loadImage("resources/default-1.png");
    const num1 = rl.loadTextureFromImage(default_1);
    const numberPosition = rl.Vector2.init(posX - 20, posY - 25);

    rl.drawTextureV(num1, numberPosition, rl.Color.black);
    rl.unloadImage(default_1);
}

fn approachCircle(posX: f32, posY: f32, radius: f32) void {
    const ApproachCirclePosition = rl.Vector2.init(posX, posY);
    const innerRadius = radius;
    const outerRadius = radius + 5;
    const startAngle = 0.0;
    const endAngle = 360.0;
    const segments = 0.0;

    rl.drawRing(ApproachCirclePosition, innerRadius, outerRadius, startAngle, endAngle, segments, rl.Color.maroon);
}
