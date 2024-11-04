while brick.TouchPressed(2) == 0
    distance = brick.UltrasonicDist(4);
    brick.MoveMotor('AB', 50 * (20 - distance));
end
brick.MoveMotor('AB', 0);
