function xDot = COVIDFun(t,y,u)   %#ok

%   { COVID-19 Dynamic Model Function Based on State Space }

    global beta alpha lambda kessi zeta eta gamma delta

    NV = 8;                     % Number of Variables

    xDot = zeros(NV,1);         % Initial Vectorization

    %% The State Variables Are As Follows :

    % S :  Suceptible Class corrosponds to                  {y1}
    % E :  Exposed Corrosponds to                           {y2}
    % I :  Infectious without intervention Corrosponds to   {y3}
    % Q :  Recovered corrosponds to                         {y4}
    % H :  Hospitalized corrosponds to                      {y5}
    % R :  Quarantined corrosponds to                       {y6}
    % D :  Decesead People corrosponds to                   {y7}
    % P :  Insuceptible Class Corrosponds to                {y8}
    
    %% Also The Control Inputs Are As Follows :
    
    % sigma : Social Distancing corrosponds to                       {u1}
    % Tow   : Hospitalization & Treatment rate corropspond to        {u2}
    % v     : Vaccination Rate corrosponds to                        {u3}

    %% NonLinear Dynamic Of the Model is as follows: 
    
    xDot(1) = -beta*y(1)*y(3)*(1-u(1))-alpha*y(1)-u(3)*y(1);        % Sdot
    xDot(2) =  beta*y(1)*y(3)*(1-u(1))-gamma*y(2);                  % Edot
    xDot(3) = gamma*y(2)-delta*y(3)-u(2)*y(3);                      % Idot
    xDot(4) = delta*y(3)-lambda*y(4)-kessi*y(4);                    % Qdot
    xDot(5) = u(2)*y(3)-zeta*y(5)-eta*y(5)  ;                       % Hdot 
    xDot(6) = lambda*y(4)+u(3)*y(1)+zeta*y(5);                      % Rdot
    xDot(7) = kessi*y(4)+eta*y(5);                                  % Ddot
    xDot(8) = alpha*y(1);                                           % Pdot

end

