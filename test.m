brick.SetColorMode(3, 4);  % Set Color Sensor connected to Port 1 to Color Code Mode

while brick.TouchPressed(2) == 0
    color_rgb = brick.ColorRGB(3);  % Get Color on port 1.
    %print color of object
    fprintf("\tRed: %d\n", color_rgb(1));
    fprintf("\tGreen: %d\n", color_rgb(2));
    fprintf("\tBlue: %d\n", color_rgb(3));
end