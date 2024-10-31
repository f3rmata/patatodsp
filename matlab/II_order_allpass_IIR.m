fb = 300;       %该数值即为相位器陷波点，单位Hz
fs = 192000;    %全通滤波器采样率，单位Hz
BW = 7680*8;   %0.04*fs

c = (tan(pi*BW/fs)-1)/(tan(pi*BW/fs)+1);
d = -cos(2*pi*fb/fs);


cons = d*(1-c);