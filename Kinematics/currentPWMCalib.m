% currents
I = [13 22 32 42 56 72 89 100 125 152 169 200 229 263 308 367 468 567 659 744 824]*1e-3;
% 8 bit pwm value
Duty = 0:10:10*(numel(I)-1);

% assume a quadratic functoin
a = 0.0000195;
y = a*Duty.*Duty;

plot(Duty,I,Duty,y)
xlabel('PWM 8 bit value');
ylabel('I (A)')