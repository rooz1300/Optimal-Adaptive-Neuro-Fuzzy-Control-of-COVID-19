function Objective_Function = OptimFun(y,u)

    Normalization_Factor  = (max(y(:,1))).^2;
    
    Objective_Function = trapz((y(:,end-1).^2+...
        y(:,3).^2+y(:,2).^2+y(:,4).^2)./Normalization_Factor+...
        (u(1).^2+u(2).^2+u(3).^2));

end