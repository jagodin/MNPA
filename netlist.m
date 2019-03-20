% netlist.m: 
%
% ELEC4700, PA-9
% Author: Jacob Godin
% Date: 2019/03/19
%--------------------------------------------------------------------------

clc; close all; clear all;

global G C b num_nodes; % define global variables

num_nodes = 6; % number of nodes in circuit

G = zeros(num_nodes,num_nodes); % Define G, 4 node circuit (do not include additional variables)
C = zeros(num_nodes,num_nodes); % Define C, 4 node circuit (do not include additional variables)
b = zeros(num_nodes,1); % Define b, 4 node circuit (do not include additional variables)

%--------------------------------------------------------------------------
% List of the components and values (netlist):
%--------------------------------------------------------------------------

R1 = 1;
R2 = 2;
R3 = 10;
R4 = 0.1;
R0 = 1000;
Cap = 0.25;
L = 0.2;
alpha = 100;

res(1,2,R1);
res(4,5,R4);
res(5,0,R0);
res(2,0,R2);
res(3,6,R3)
cap(1,2,Cap);

% Additional rows/columns stamps
vol(1,0,1);
ind(2,3,L);
%ccvs(nd1,nd2,ni1,ni2,val)
ccvs(4,0,6,0,alpha);

G
C
b

%--------------------------------------------------------------------------
% b) Plot of Vin vs Vout
%--------------------------------------------------------------------------

% For DC analysis, C = 0

C_store = C;
C = 0;

Nrpt = 10000; % Number of points
OutputNode = 5;
Vin = linspace(-10,10,Nrpt);

Vout = zeros(1,Nrpt);
V3 = zeros(1,Nrpt);

for i=1:Nrpt
    b(7) = Vin(i);
    
    x = G\b;
    
    Vout(i) = x(OutputNode);
    V3(i) = x(3);
end

figure('Name','Vin-vs-Vout-and-V3-Response');
plot(Vin, Vout,'LineWidth',3);
hold on;
plot(Vin, V3,'LineWidth',3);
grid;
title('Vin vs. Vout/V3', 'FontSize',12);
xlabel('Vin  (Volts)','FontSize',20);
ylabel('Vout  (Volts)','FontSize',20);
legend('Vout', 'V3');

%--------------------------------------------------------------------------
% c) Plot of Vout as a function of w
%--------------------------------------------------------------------------

C = C_store;

f = linspace(0,100,Nrpt);

V1 = zeros(1,Nrpt);

for i=1:Nrpt
    w = 2*pi*f(i);
    s=1i*w;
    
    A = G+s.*C;
    
    x = A\b;
    
    Vout(i) = x(OutputNode);
    V1(i) = x(1);
end

amplitude = Vout./V1;
gaindB = 20*log10(amplitude);

figure('Name','Vout-Function-of-w');
semilogx(f, Vout,'LineWidth',3);
grid;
title('Vout as a Function of w', 'FontSize',12);
xlabel('w','FontSize',20);
ylabel('Vout  (Volts)','FontSize',20);

figure('Name','Gain-Function-of-w');
plot(f, gaindB,'LineWidth',3);
grid;
title('Gain as a Function of w', 'FontSize',12);
xlabel('w','FontSize',20);
ylabel('Gain  (dB)','FontSize',20);

%--------------------------------------------------------------------------
% d) Plot of Vout as a Function Random Pertubations of C
%--------------------------------------------------------------------------

d = size(G,1);
std = 0.05;
x_plot = zeros(1,Nrpt);
count = 0;

for i=1:Nrpt
    w = 2*pi*f(i);
    s=1i*w;
    
    for row=1:d
        for col=1:d
            Cn = pi+rand()*std;
            C(row,col) = Cn;
        end
    end
    
    x_plot(i)=count+1;
    
    A = G+s.*C;
    
    x = A\b;
    
    Vout(i) = x(OutputNode);
    V1(i) = x(1);
end





