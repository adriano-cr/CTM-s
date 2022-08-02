clearvars
close all
clc

delete(gcp('nocreate'));
parpool('threads')
disp('==============================')
disp('-- Optimization analysis ')

path = "H:\Il mio Drive\Tesi magistrale\Python\CTM-s\data\opti_data_i-j-delta-beta-priority.csv";

addpath(path)
warning('off')

plots = 1;

%% extract data
T = readtable(path);

varname=T.Properties.VariableNames;
A = table2array(T);
cell_in = A(:, 1);
cell_out = A(:, 2);
delta = A(:, 3);
beta = A(:, 4);
priority = A(:,5);
integral=A(:,6);
pi_greco = A(:, 8);
fit_name=["poly11","poly12","poly21","poly22","poly13","poly31","poly23","poly32","poly33", ...
          "poly14","poly41","poly24","poly42","poly34","poly43","poly44",...
          "poly15","poly51","poly25","poly52","poly35","poly53","poly45","poly54","poly55"];

%% 1 - Integral with different i, j and delta fixed
disp("1 - Integral with different i, j and delta fixed")
fixed_delta = 480;
x = [];
y = [];
z = [];
parfor i=1:length(cell_in)
    if(delta(i)==fixed_delta)
        x=[x cell_in(i)]; %i
        y=[y cell_out(i)]; %j
        z=[z integral(i)]; %integral
    end
end
x=x'; 
y=y'; 
z=z';

[f, gof] = fit([x, y],z,fit_name(1),'Normalize', 'on', 'Robust','Bisquare');
f_best=f;
gof_best=gof;
adjrsq_best = gof_best.adjrsquare;
sse_best = gof_best.sse;
for i=2:length(fit_name)
    [f, gof] = fit([x, y],z,fit_name(i), 'Normalize', 'on', 'Robust','Bisquare');
    if(gof.adjrsquare > adjrsq_best && gof.sse < sse_best)
        f_best=f;
        gof_best=gof;
        adjrsq_best = gof_best.adjrsquare;
        sse_best = gof_best.sse;
    end
end

if(plots>0)
    figure()
    plot(f_best,[x y],z, 'Exclude', z < 100)
    zlim([0 max(z)]);
    xlabel('x - Cell IN')
    ylabel('y - Cell OUT')
    zlabel("Integral")
    title("Integral VS i, j")
    legend(type(f_best))
    grid on
end

%% 2 - Integral with different i, delta(10-120 min) and j fixed
disp('2 - Integral with different i, delta(10-120 min) and j fixed')
j = 2;
x = [];
y = [];
z = [];
parfor i=1:length(cell_in)
    if(cell_out(i)==cell_in(i)+j)
        x=[x cell_in(i)]; %i
        y=[y delta(i)]; %delta
        z=[z integral(i)]; %integral
    end
end
x=x'; 
y=y'; 
z=z';
[f, gof] = fit([x, y],z,fit_name(1),'Normalize', 'on', 'Robust','Bisquare');
f_best=f;
gof_best=gof;
adjrsq_best = gof_best.adjrsquare;
sse_best = gof_best.sse;
for i=2:length(fit_name)
    [f, gof] = fit([x, y],z,fit_name(i), 'Normalize', 'on', 'Robust','Bisquare');
    if(gof.adjrsquare > adjrsq_best && gof.sse < sse_best)
        f_best=f;
        gof_best=gof;
        adjrsq_best = gof_best.adjrsquare;
        sse_best = gof_best.sse;
    end
end

if(plots>0)
    figure()
    plot(f_best,[x y],z,'Exclude', z < 100)
    zlim([0 max(z)]);
    xlabel('x - Cell IN')
    ylabel('y - Delta (timesteps)')
    yticks(0:min(y):max(y))
    zlabel("Integral")
    title("Integral VS i, delta")
    legend(type(f_best))
    grid on
end


%% 3 - Pi with different i, delta(10-120 min) and j fixed
disp('3 - Pi with different i, delta(10-120 min) and j fixed')
j = 2;
x = [];
y = [];
z = [];
parfor i=1:length(cell_in)
    if(cell_out(i)==cell_in(i)+j)
        x=[x cell_in(i)]; %i
        y=[y delta(i)]; %delta
        z=[z pi_greco(i)]; %pi
    end
end
x=x'; 
y=y'; 
z=z';
[f, gof] = fit([x, y],z,fit_name(1),'Exclude', z < 0);
f_best=f;
gof_best=gof;
adjrsq_best = gof_best.adjrsquare;
sse_best = gof_best.sse;
for i=2:length(fit_name)
    [f, gof] = fit([x, y],z,fit_name(i), 'Exclude', z < 0);
    if(gof.adjrsquare > adjrsq_best && gof.sse < sse_best)
        f_best=f;
        gof_best=gof;
        adjrsq_best = gof_best.adjrsquare;
        sse_best = gof_best.sse;
    end
end

if(plots>0)
    figure()
    plot(f_best,[x y],z, 'Exclude', z < 0)
    zlim([-1 1]);
    xlabel('x - Cell IN')
    ylabel('y - Delta (timesteps)')
    yticks(0:min(y):max(y))
    zlabel("PI")
    title("PI VS i, delta")
    legend(type(f_best))
    grid on
end

%% 4 - Integral with different i, beta and j fixed
disp('4 - Integral with different i, beta and j fixed')
j = 2;
x = [];
y = [];
z = [];

parfor i=1:length(cell_in)
    if(cell_out(i)==cell_in(i)+j)
        x=[x cell_in(i)]; %i
        y=[y beta(i)]; %beta
        z=[z integral(i)]; %integral
    end
end
x=x'; 
y=y'; 
z=z';
[f, gof] = fit([x, y],z,fit_name(1));
f_best=f;
gof_best=gof;
adjrsq_best = gof_best.adjrsquare;
sse_best = gof_best.sse;
for i=2:length(fit_name)
    [f, gof] = fit([x, y],z,fit_name(i));
    if(gof.adjrsquare > adjrsq_best && gof.sse < sse_best)
        f_best=f;
        gof_best=gof;
        adjrsq_best = gof_best.adjrsquare;
        sse_best = gof_best.sse;
    end
end

if(plots>0)
    figure()
    plot(f_best,[x y],z, 'Exclude', z < 100)
     zlim([0 max(z)]);
    xlabel('x - Cell IN')
    ylabel('y - Beta')
    zlabel("Integral")
    title("Integral VS i, beta")
    legend(type(f_best))
    grid on
end
%% 5 - Pi with different i, beta and j fixed
disp('5 - Pi with different i, beta and j fixed')
j = 2;
x = [];
y = [];
z = [];
parfor i=1:length(cell_in)
    if(cell_out(i)==cell_in(i)+j)
        x=[x cell_in(i)]; %i
        y=[y beta(i)]; %beta
        z=[z pi_greco(i)]; %pi
    end
end
x=x'; 
y=y'; 
z=z';
[f, gof] = fit([x, y],z,fit_name(1));
f_best=f;
gof_best=gof;
adjrsq_best = gof_best.adjrsquare;
sse_best = gof_best.sse;
for i=2:length(fit_name)
    [f, gof] = fit([x, y],z,fit_name(i));
    if(gof.adjrsquare > adjrsq_best && gof.sse < sse_best)
        f_best=f;
        gof_best=gof;
        adjrsq_best = gof_best.adjrsquare;
        sse_best = gof_best.sse;
    end
end


if(plots>0)
    figure()
    plot(f_best,[x y],z, 'Exclude', z < 0)
    zlim([-1 1]);
    xlabel('x - Cell IN')
    ylabel('y - Beta')
    zlabel("PI")
    title("PI VS i, beta")
    legend(type(f_best))
    grid on
end

%% 6 - Pi with different delta, beta
disp('6 - Pi with different delta, beta')

x = [];
y = [];
z = [];
parfor i=1:length(cell_in)
    x=[x delta(i)]; %delta
    y=[y beta(i)]; %beta
    z=[z pi_greco(i)]; %pi
end
x=x'; 
y=y'; 
z=z';
[f, gof] = fit([x, y],z,fit_name(1),'Normalize', 'on', 'Robust','Bisquare');
f_best=f;
gof_best=gof;
adjrsq_best = gof_best.adjrsquare;
sse_best = gof_best.sse;
for i=2:length(fit_name)
    [f, gof] = fit([x, y],z,fit_name(i), 'Normalize', 'on', 'Robust','Bisquare');
    if(gof.adjrsquare > adjrsq_best && gof.sse < sse_best)
        f_best=f;
        gof_best=gof;
        adjrsq_best = gof_best.adjrsquare;
        sse_best = gof_best.sse;
    end
end

if(plots>0)
    figure()
    plot(f_best,[x y],z, 'Exclude', z < 0)
    zlim([-1 1]);
    xlabel('x - Delta')
    xticks(0:min(x):max(x))
    ylabel('y - Beta')
    zlabel("PI")
    title("PI VS Delta, beta")
    legend(type(f_best))
    grid on
end
%% 7 - Integral with different delta, beta 
disp('7 - Integral with different delta, beta ')

x = [];
y = [];
z = [];
parfor i=1:length(cell_in)
    x=[x delta(i)]; %delta
    y=[y beta(i)]; %beta
    z=[z integral(i)]; %integral
end
x=x'; 
y=y'; 
z=z';

[f, gof] = fit([x, y],z,fit_name(1),'Normalize', 'on', 'Robust','Bisquare');
f_best=f;
gof_best=gof;
adjrsq_best = gof_best.adjrsquare;
sse_best = gof_best.sse;
for i=2:length(fit_name)
    [f, gof] = fit([x, y],z,fit_name(i), 'Normalize', 'on', 'Robust','Bisquare');
    if(gof.adjrsquare > adjrsq_best && gof.sse < sse_best)
        f_best=f;
        gof_best=gof;
        adjrsq_best = gof_best.adjrsquare;
        sse_best = gof_best.sse;
    end
end

if(plots>0)
    figure()
    plot(f_best,[x y],z, 'Exclude', z < 100)
     zlim([0 max(z)]);
    xlabel('x - Delta')
    xticks(0:min(x):max(x))
    ylabel('y - Beta')
    zlabel("Integral")
    title("Integral VS Delta, beta")
    legend(type(f_best))
    grid on
end
%% 8 - Pi with different beta, priority 
disp('8 - Pi with different beta, priority ')

x = [];
y = [];
z = [];
parfor i=1:length(cell_in)
    x=[x beta(i)]; %beta
    y=[y priority(i)]; %priority
    z=[z pi_greco(i)]; %pi
end
x=x'; 
y=y'; 
z=z';
[f, gof] = fit([x, y],z,fit_name(1),'Normalize', 'on', 'Robust','Bisquare','Exclude', z < 0);
f_best=f;
gof_best=gof;
adjrsq_best = gof_best.adjrsquare;
sse_best = gof_best.sse;
for i=2:length(fit_name)
    [f, gof] = fit([x, y],z,fit_name(i), 'Normalize', 'on', 'Robust','Bisquare','Exclude', z < 0);
    if(gof.adjrsquare > adjrsq_best && gof.sse < sse_best)
        f_best=f;
        gof_best=gof;
        adjrsq_best = gof_best.adjrsquare;
        sse_best = gof_best.sse;
    end
end

if(plots>0)
    figure()
    plot(f_best,[x y],z, 'Exclude', z < 0)
    zlim([-1 1]);
    xlabel('x - beta')
    ylabel('y - priority')
    zlabel("PI")
    title("PI VS Beta, priority")
    legend(type(f_best))
    grid on
end
%% 9 - Integral with different beta, priority 
disp('9 - Integral with different beta, priority ')

x = [];
y = [];
z = [];
parfor i=1:length(cell_in)
    x=[x beta(i)]; %beta
    y=[y priority(i)]; %priority
    z=[z integral(i)]; %integral
end
x=x'; 
y=y'; 
z=z';

[f, gof] = fit([x, y],z,fit_name(1),'Normalize', 'on', 'Robust','Bisquare');
f_best=f;
gof_best=gof;
adjrsq_best = gof_best.adjrsquare;
sse_best = gof_best.sse;
for i=2:length(fit_name)
    [f, gof] = fit([x, y],z,fit_name(i), 'Normalize', 'on', 'Robust','Bisquare');
    if(gof.adjrsquare > adjrsq_best && gof.sse < sse_best)
        f_best=f;
        gof_best=gof;
        adjrsq_best = gof_best.adjrsquare;
        sse_best = gof_best.sse;
    end
end

if(plots>0)
    figure()
    plot(f_best,[x y],z, 'Exclude', z < 100)
     zlim([0 max(z)]);
    xlabel('x - beta')
    ylabel('y - priority')
    zlabel("Integral")
    title("Integral VS Beta, priority")
    legend(type(f_best))
    grid on
end
%%
disp('==============================')