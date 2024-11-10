% Gain = 0.8;
Roomsize = 0.7;
Mix = 1;
damp = 0.2;
d1 = 20;
feedback = 0.84;

h = hadamard(4)./2;
o = [0,1,1,0;-1,0,0,-1;1,0,0,-1;0,1,-1,0];

% T60 Delay / Sample rate at 192kHz
%d1 = 192 * 1000 * 0.7;

% T60 Delay / Sample rate at 44.1kHz
%d1 = 44.1 * 1000 * 0.7;

% Delay start at 48ms / Sample rate at 44.1kHz
%d1 = round(44.1 * 1000 * 0.048);

