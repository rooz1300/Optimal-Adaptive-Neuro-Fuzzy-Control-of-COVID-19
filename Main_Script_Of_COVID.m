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

Ics = [round([37.5*1e6 35000 34500 40000 40000 47000 7000 37500]./10000)
       round([37.5*1e5 20000 25000 25000 35000 40000 6000 30000]./5000)
       round([37.5*1e4 10000 17000 9000 40000 28000 8000 20000]./2000)];        % Initial Conditions of the States

%% Solve The Nonlinear Equation

States = cell(1,size(Ics,1));

for w=1:size(Ics,1)
    [~,states] = ode23(@(t,x)COVIDFun(t,x,u),t,Ics(w,:));                       % ODE23 Solver
    States{w} = states;
end

%% Optimization
                                                             
LB =[0.5 0 0.02]';                                                    % Lower Bound for Control Inputs
UB = [1 0.25 0.06]';                                                  % Upper Bound for Control Inputs
PopSize = 30;                                                         % Number of Population

Options = gaoptimset('PopulationSize',PopSize);                       % GA options

NewStates = cell(1,size(Ics,1));                                      % Initial Vectorization
NewU = cell(1,size(Ics,1));                                           % Initial Vectorization
NewF_U = cell(1,size(Ics,1));                                         % Initial Vectorization

for i =1:size(Ics,1)
    
    [U,F_U] = ga(@(u)OptimFun(States{i},u),3,[],[],[],[],LB,UB,[],Options);
    NewU{i} = U;
    NewF_U{i} = F_U;
    [~,newStates] = ode23(@(t,x)COVIDFun(t,x,U),t,Ics(i,:));
    NewStates{i} = newStates;

end

%% Plot results

j = 0;                                     % Iteration For Subplot
NV = 8;                                    % Number of States
Colors = hsv(NV);                          % Number of Colors
c = 0;                                     % Iteration for Color
set(gcf, 'Position',  [100, 100, 1000, 500])
for I=1:size(Ics,1)
    
    j = j+1;
    subplot(3,1,I)
    X = NewStates{j};
    
    for k=1:size(X,2)
        c = c+1;
       plot(t,X(:,k),'LineWidth',2,'color',Colors(c,:))
       hold on
       grid on  
       xlabel('Time(Day)')
       ylabel('States')
       
    end
    c = 0;
end
grid minor
legend('S','E','I','Q','H','R','D','P')


movegui(gcf,"southeast")
saveas(gcf, 'fig.png')
