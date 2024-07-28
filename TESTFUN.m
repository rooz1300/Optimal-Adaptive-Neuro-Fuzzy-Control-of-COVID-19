function xDot = TESTFUN(t,x,u)   %#ok

%   { COVID-19 Dynamic Model Function Based on State Space }

    global beta alpha lambda kessi zeta eta gamma delta

    NV = 8;                     % Number of Variables

    xDot = zeros(NV,1);         % Initial Vectorization

    %% The State Variables Are As Follows :

    % S :  Suceptible Class corrosponds to                  {x1}
    % E :  Exposed Corrosponds to                           {x2}
    % I :  Infectious without intervention Corrosponds to   {x3}
    % Q :  Recovered corrosponds to                         {x4}
    % H :  Hospitalized corrosponds to                      {x5}
    % R :  Quarantined corrosponds to                       {x6}
    % D :  Decesead People corrosponds to                   {x7}
    % P :  Insuceptible Class Corrosponds to                {x8}
    
    %% Also The Control Inputs Are As Follows :
    
    % sigma : Social Distancing corrosponds to                       {u1}
    % Tow   : Hospitalization & Treatment rate corropspond to        {u2}
    % v     : Vaccination Rate corrosponds to                        {u3}

    %% NonLinear Dynamic Of the Model is as follows: 
    
    xDot(1) = -beta*x(1)*x(3)*(1-u(1).^2)-alpha*x(1)-u(3).^2*x(1);        % Sdot
    xDot(2) =  beta*x(1)*x(3)*(1-u(1).^2)-gamma*x(2);                     % Edot
    xDot(3) = gamma*x(2)-delta*x(3)-u(2).^2*x(3);                         % Idot
    xDot(4) = delta*x(3)-lambda*x(4)-kessi*x(4);                          % Qdot
    xDot(5) = u(2).^2*x(3)-zeta*x(5)-eta*x(5)  ;                          % Hdot 
    xDot(6) = lambda*x(4)+u(3).^2*x(1)+zeta*x(5);                         % Rdot
    xDot(7) = kessi*x(4)+eta*x(5);                                        % Ddot
    xDot(8) = alpha*x(1);                                                 % Pdot

end
