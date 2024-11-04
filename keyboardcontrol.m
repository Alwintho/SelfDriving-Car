global key;
InitKeyboard();

while 1
    pause(0.1);
    switch key
        case 'w'
            disp('w');

        case 'a'
            disp('a');

        case 's'
            disp('s');

        case 'd'
            disp('d');

        case 0
            disp('no key is being pressed');

        case 'backspace'
            break;
    end
end

CloseKeyboard();