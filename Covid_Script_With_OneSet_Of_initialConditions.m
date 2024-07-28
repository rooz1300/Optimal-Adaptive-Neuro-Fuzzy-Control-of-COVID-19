clc;clear;close all;

% { COVID-19 Main Script Based on the written Function }

global beta alpha lambda kessi zeta eta gamma delta

MinDay = 0;                                         % Minimum number of Days
MaxDay = 100;                                       % Maximum number of days
NumberOfSamples = 200;                              % Number of Samples for ODE45 

t = linspace(MinDay,MaxDay,NumberOfSamples);        % Time Vector

%% Define the Numerical Values of Parameters 

alpha = 0.172;                                      % Protection rate
beta = 1;                                           % Transmission rate
gamma = 2;                                          % Latent time
delta = 0.1;                                        % Quarantine time
lambda = 0.025;                                     % Cure rate of Quarantined people
kessi = 0.004;                                      % Mortality rate of Quarantined people
zeta = 0.92;                                        % Cure rate of Hospitalized people
eta = 0.08;                                         % Mortality rate of Hospitalized people

u = [0 0 0];                                        % Initial Values for Control Inputs

%% Define The Initial Conditions of the States 

Ics = round([37.5*1e6 35000 34500 40000 40000 47000 7000 37500]);
    

%% Solve with ODE 45

[~,States] = ode45(@(t,x)TESTFUN(t,x,u),t,Ics);

%% Optimization
                                                             
LB =[0.5 0 0.02]';                                                    % Lower Bound for Control Inputs
UB = [1 0.25 0.06]';                                                  % Upper Bound for Control Inputs
PopSize = 30;                                                         % Number of Population

Options = gaoptimset('PopulationSize',PopSize);                       % GA options

[U,FU] = ga(@(u)OptimFun(States,u),3,[],[],[],[],LB,UB,[],Options);
[~,NewStates] = ode45(@(t,x)TESTFUN(t,x,U),t,Ics);

%% Plot Results

NV = 8;                                    % Number of Variables
Colors = hsv(NV);                          % Number of Colors
c = 0;      

for k=1:size(States,2)
    
    c = c+1;
    plot(t,NewStates(:,k),'LineWidth',2,'color',Colors(c,:))
    hold on 
    grid on
    
    
end

xlabel('Time(Day')
ylabel('States')
legend('S','E','I','Q','H','R','D','P')
legend show

