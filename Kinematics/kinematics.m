%% pantograph kinematics
clear;
clc;
syms a1 a2 a3 a4 a5
syms t1 t5
p2 = [a1*cos(t1);a1*sin(t1)];
p4 = [a4*cos(t5)-a5;a4*sin(t5)];

% intermediate equation
p4_p2_2 = transpose(p4-p2)*(p4-p2);
p4_p2 = sqrt(p4_p2_2);
% 3
p2_ph = (a2^2-a3^2+p4_p2_2)/2/p4_p2;
% 4
ph = p2 + p2_ph/p4_p2*(p4-p2);
% 5
p3_ph = sqrt(a2^2-p2_ph^2);

% end effector
xh = ph(1);
yh = ph(2);
x2 = p2(1);
y2 = p2(2);
x4 = p4(1);
y4 = p4(2);

x3 = xh + p3_ph/p4_p2*(y4-y2);
y3 = yh - p3_ph/p4_p2*(x4-x2);

x3 = subs(x3,{a4,a3},{a1,a2});
y3 = subs(y3,{a4,a3},{a1,a2});

%% compute jacobian
J = [diff(x3,t1) diff(x3,t5);
     diff(y3,t1) diff(y3,t5)];

%% adding in length info
a1_v = 170e-3;
a2_v = 220e-3;
a3_v = 220e-3;
a4_v = 170e-3;
a5_v = 100e-3;

x3_v = subs(x3,{a1,a2,a3,a4,a5},{a1_v,a2_v,a3_v,a4_v,a5_v});
y3_v = subs(y3,{a1,a2,a3,a4,a5},{a1_v,a2_v,a3_v,a4_v,a5_v});
p2_v = subs(p2,{a1,a2,a3,a4,a5},{a1_v,a2_v,a3_v,a4_v,a5_v});
p4_v = subs(p4,{a1,a2,a3,a4,a5},{a1_v,a2_v,a3_v,a4_v,a5_v});

J_v = subs(J,{a1,a2,a3,a4,a5},{a1_v,a2_v,a3_v,a4_v,a5_v});

%% actuator info
N = 17;
tc1 = 15.6e-3*N;
tc2 = 15.6e-3*N;
T = [-tc1 -tc2;
     -tc1 +tc2;
     +tc1 +tc2;
     +tc1 -tc2];

%% workspace and force
% useful workspace
cent = [-a5_v/2;0.25];
rx = 210e-3;
ry = 148e-3;

t1Range = linspace(deg2rad(-10),deg2rad(100), 15);
t5Range = linspace(deg2rad(80),deg2rad(190), 15);
P = zeros(numel(t1Range)*numel(t5Range),4);
Y = zeros(numel(t1Range)*numel(t5Range),5);
k = 1;
m = 1;

for i = 1:numel(t1Range)
   for j = 1:numel(t5Range)
       t1_v = t1Range(i);
       t5_v = t5Range(j);
       x3_v_ = double(subs(x3_v,{t1,t5},{t1_v,t5_v}));
       y3_v_ = double(subs(y3_v,{t1,t5},{t1_v,t5_v}));
       p2_v_ = double(subs(p2_v,{t1,t5},{t1_v,t5_v}));
       p4_v_ = double(subs(p4_v,{t1,t5},{t1_v,t5_v}));
       
       p23a = atan2(y3_v_-p2_v_(2),x3_v_-p2_v_(1));
       p43a = atan2(y3_v_-p4_v_(2),x3_v_-p4_v_(1));
       
       a = 0;
       if(p23a > 0 && t1_v > 0 && p23a > t1_v)
           a = 1;
       elseif(p23a > 0 && t1_v < 0)
           a = 1;
       end
       
       if(p43a > 0 && t5_v > 0 && t5_v > p43a)
           a = 1;
       elseif(p43a > 0 && t5_v < 0)
           a = 1;    
       end
       
       if(a > 0)
           P(k,1) = x3_v_;
           P(k,2) = y3_v_;
           P(k,3) = t1_v;
           P(k,4) = t5_v;
           k = k+1;
           
           % torque capacity in useful workspace
           if(x3_v_ <= cent(1)+rx/2 && x3_v_ >= cent(1)-rx/2 && ...
              y3_v_ <= cent(2)+ry/2 && y3_v_ >= cent(2)-ry/2)
                J_v_ = double(subs(J_v,{t1,t5},{t1_v,t5_v}));
                J_v_it = inv(transpose(J_v_));
                F = J_v_it*transpose(T);
                r = 1; %compute2DForceRadius(F(:,1),F(:,2),F(:,3),F(:,4));
                Y(m,1) = x3_v_;
                Y(m,2) = y3_v_;
                Y(m,3) = r;
                Y(m,4) = t1_v;
                Y(m,5) = t5_v;
                m = m+1;          
           end
       end
   end
end

%% plot
figure(10)
hold on
plot(P(1:(k-1),1),P(1:(k-1),2),'g.')
line([cent(1)-rx/2 cent(1)-rx/2],[cent(2)-ry/2 cent(2)+ry/2],'Color','k', 'LineStyle','--');
line([cent(1)-rx/2 cent(1)+rx/2],[cent(2)+ry/2 cent(2)+ry/2],'Color','k', 'LineStyle','--');
line([cent(1)+rx/2 cent(1)+rx/2],[cent(2)+ry/2 cent(2)-ry/2],'Color','k', 'LineStyle','--');
line([cent(1)+rx/2 cent(1)-rx/2],[cent(2)-ry/2 cent(2)-ry/2],'Color','k', 'LineStyle','--');
% force
c_map = colormap;
for k1 = 1:m-1
    %[x,y]=DrawCircle([Y(k1,1),Y(k1,2)],Y(k1,3)/500);
    %c_index = ceil(Y(k1,3)/5*size(c_map,1));
    %patch(x,y,c_map(c_index,:));
end
%colorbar('YTickLabel',{'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5'})
box
axis equal
%hold off