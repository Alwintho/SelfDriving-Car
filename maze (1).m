InitKeyboard();

targetAngle = 0;
brick.GyroCalibrate(1);
brick.SetColorMode(3, 4);
color = 0;

power = 0.5;
turnPower = 0.75;

finished = 0;

targetColor = 2;

targetAngle = cast(0, "like", 0.0);

colorOutput = [0, 0];

while targetColor ~= 1

    % get sensor data
    gyroAngle = brick.GyroAngle(1);
    distance = brick.UltrasonicDist(4);

    % move straight
    brick.MoveMotor('A', power * (-100 - turnPower*((targetAngle - gyroAngle))));
    brick.MoveMotor('B', power * (-100 + turnPower*((targetAngle - gyroAngle))));

    % if it hits a wall
    if brick.TouchPressed(2) == 1
        brick.MoveMotor('AB', 0);
        brick.MoveMotor('AB', 100 * power);
        pause(1.2);
        brick.MoveMotor('AB', 0);
        targetAngle = targetAngle - 91;                                                                                                                                                                                                                                 
        tic;
        while toc < 0.4
            gyroAngle = brick.GyroAngle(1);
            brick.MoveMotor('A', power * (-100 - turnPower*((targetAngle - gyroAngle))));
            brick.MoveMotor('B', power * (-100 + turnPower*((targetAngle - gyroAngle))));
        end

        % if the button is still pressed, terminate program (kill switch)
        if brick.TouchPressed(2) == 1 
            break;
        end

        while toc < 1
            gyroAngle = brick.GyroAngle(1);
            brick.MoveMotor('A', power * (-100 - turnPower*((targetAngle - gyroAngle))));
            brick.MoveMotor('B', power * (-100 + turnPower*((targetAngle - gyroAngle))));
        end

    end

    % if there is a gap to the right
    if distance > 45
        pause(0);
        targetAngle = targetAngle + 91;
        tic;
        while toc < 1.7
            gyroAngle = brick.GyroAngle(1);
            brick.MoveMotor('A', power * (-100 - turnPower*((targetAngle - gyroAngle))));
            brick.MoveMotor('B', power * (-100 + turnPower*((targetAngle - gyroAngle))));
            color = getColor(brick.ColorRGB(3));
            [a, b] = colors(color, brick, targetColor, targetAngle);
            targetColor = a;
            targetAngle = b;
        end
    end

    brick.ColorRGB(3)
    color = getColor(brick.ColorRGB(3));
    [a, b] = colors(color, brick, targetColor, targetAngle);
    targetColor = a;
    targetAngle = b;

end

% stop
brick.MoveMotor('AB', 0);
CloseKeyboard();

function [targetColor, targetAngle] = colors(color, brick, targetColor, targetAngleIn)
    targetAngle = targetAngleIn;
    % color sensing

    % 0 	No color (Unknown color) 
    % 1 	Black 
    % 2 	Blue 
    % 3 	Green 
    % 4 	Yellow 
    % 5 	Red 
    % 6 	White 
    % 7 	Brown
    
    % red line
    if color == 5 
        brick.StopAllMotors();
        pause(1);
    end
    
    % blue square
    if color == 2 && targetColor == 2
        brick.StopAllMotors();
        % keyboard control
        targetColor = 3;
        targetAngle = cast(kbControl(brick), "like", 0.0);
    end
    
    % green square
    if color == 3 && targetColor == 3
        brick.StopAllMotors();
        % keyboard control
        targetColor = 4;
        targetAngle = cast(kbControl(brick), "like", 0.0);
    end
    
    % yellow square
    if color == 4 && targetColor == 4
        brick.StopAllMotors();
        targetColor = 1;
        pause(1);
    end
end

function color = getColor(colorRgb)
    % color    r   g   b
    % blue     19  82  87
    % green    26  95  24
    % yellow   140 110 22
    % red      97  24  13

   % blue
    if colorRgb(1) < 40 && colorRgb(1) > 0 && colorRgb(2) < 100 && colorRgb(2) > 0 && colorRgb(3) < 110 && colorRgb(3) > 60
        color = 2;
        return;
    end

    % green
    if colorRgb(1) < 45 && colorRgb(1) > 5 && colorRgb(2) < 115 && colorRgb(2) > 75 && colorRgb(3) < 45 && colorRgb(3) > 5
        color = 3;
        return;
    end

    % yellow
    if colorRgb(1) < 170 && colorRgb(1) > 120 && colorRgb(2) < 130 && colorRgb(2) > 80 && colorRgb(3) < 42 && colorRgb(3) > 2
        color = 4;
        return;
    end

    % red
    if colorRgb(1) < 140 && colorRgb(1) > 60 && colorRgb(2) < 54 && colorRgb(2) > 0 && colorRgb(3) < 33 && colorRgb(3) > 0
        color = 5;
        return;
    end

    color = 0;
   
end

function rotation = kbControl(brick) 
    global key;
    while 1
        pause(0.1);
        switch key
            case 'w'
                brick.MoveMotor('A', -15);
                brick.MoveMotor('B', -17);
    
            case 'a'
                brick.MoveMotor('A', 15);
                brick.MoveMotor('B', -15);
    
            case 's'
                brick.MoveMotor('A', 15);
                brick.MoveMotor('B', 17);
    
            case 'd'
                brick.MoveMotor('A', -15);
                brick.MoveMotor('B', 15);

            case 'k'
                brick.MoveMotor('D', 15);

            case 'j'
                brick.MoveMotor('D', -15);
    
            case 0
                brick.StopAllMotors();
    
            case 'backspace'
                break;
        end

        % rotation = int32((brick.GyroAngle(1)) / 90) * 90
        rotation = brick.GyroAngle(1);

    end

end