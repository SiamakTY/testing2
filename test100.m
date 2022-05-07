clear
clc

tic
n_array = exp(normrnd(-3.725,0.27,10,100)) ; % An array containing random values for Manning coefficients which is generated using its statistical properties (sigma_ln(Manning coefficient) = 0.27 & mean_ln(Manning coefficient) = -3.725)
Q = transpose(linspace(0.1,850,1000)) ; % ten thousand arbitrary values for discharge (Q)
S = 0.002 ;
b = 11 ;
rectifier_coefficient = 0.95 ; % By multiplying this value to the first guess, we try to correct it (0< rectifier_coefficient< 1). If this value does not solve the problem, choose a value closer to 1 (i.e. 0.99, 0.999, etc.)
% Choosing a value close to 1 will cause longer calculations for sure.

y0_values = zeros(size(Q,1),size(n_array,1)) ; % Solved y0 values will be stored in this array. y0 for Manning number jj and Q ii will be saved in the row ii and column jj of this matrix 

for jj = 1:1:size(n_array,1) 
    str = ['Calculation is running for column ',num2str(jj),' from ',num2str(size(n_array,1))] ; disp(str)
    n = n_array(jj,1) ;
    for ii=1:1:size(Q,1)
        q = Q(ii,1) ;
        first_guess = q ; % Let us put the first guess equal to discharge as depth can never be greater than discharge.  
        f = @(y0)((b*y0/n)*((b*y0/(b + 2*y0))^0.67)*sqrt(S) - q) ; % Equation (13) of Wang et al. research
        y0 = fzero(f,first_guess) ;
        NaN_control = isnan(y0) ; % Control to see if the result is valid
        if NaN_control == 1 % If not valid, let us correct it by gradually decreasing the first guess value
            while NaN_control == 1
                first_guess = rectifier_coefficient*first_guess ; % Gradually rectify the first guess
                f = @(y0)((b*y0/n)*((b*y0/(b + 2*y0))^0.67)*sqrt(S) - q) ; 
                y0 = fzero(f,first_guess) ;
                NaN_control = isnan(y0) ;
            end
        end
        y0_values(ii,jj) = y0 ; 
     end 
end

% This block is only to make sure no NaN value exists
clc
NaN_data = 0 ;
for jj = 1:1:size(n_array,1) 
    for ii = 1:1:size(y0_values,1)
        if isnan(y0_values(ii,jj)) == 1
            str = ['y0 value at row ',num2str(ii),' & column ',num2str(jj),' is not valid.'] ; disp(str)
            NaN_data = NaN_data + 1 ;
        end
    end
end
if  NaN_data == 0
    str = 'Hooora!!! All calculated y0 values are valid :)))' ; disp(str)
end
toc
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


