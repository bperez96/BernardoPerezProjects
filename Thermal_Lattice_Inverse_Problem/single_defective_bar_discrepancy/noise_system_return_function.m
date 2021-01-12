function [Mcoeff,xvec,scaled_pred_noise_norm,normFit,scaled_noise_norm] =...
    noise_system_return_function(MmatbSearch,mb,Gmat,Dmat,ub,fb,~,i_idx)
%This function returns -A and -\bar{b} as defined in the code report, recall we
%try to solve A.mu =b.
%The function also returns the norm of the noise and the predicted norm of the noise
%which is used for regularization. 

%nb number of boundary nodes
nb = size(mb,1);

%Dprime corresponds to the map K in the report
Dprime = eye(nb)+Dmat;

%multiplying product (I+K)*u
b0 = Dprime*ub;

%now the result of -V^{-1}*(I+K)*u
d1 = -Gmat\b0;

%the prediction factor is the known factor of the standard deviation of the
%noise relative to the absolute value of the measured source;
%100 cases tested with different factor values
prediction_factor = 0;

%assign noise from normal distribution depending on the iteration index
 if i_idx<11
    noise = normrnd(0.0, 10^-1*abs(fb));
    prediction_factor = 0.1;
 elseif i_idx<21
    noise = normrnd(0.0, 10^-2*abs(fb));
    prediction_factor = 10^-2;
 elseif i_idx<31
    noise = normrnd(0.0, 10^-3*abs(fb));
    prediction_factor = 10^-3;
 elseif i_idx<41
    noise = normrnd(0.0, 10^-4*abs(fb));
    prediction_factor = 10^-4;
 elseif i_idx<51
    noise = normrnd(0.0,10^-5*abs(fb));
    prediction_factor = 10^-5;
 elseif i_idx<61
    noise = normrnd(0.0,10^-6*abs(fb));
    prediction_factor = 10^-6;
  elseif i_idx<71
    noise = normrnd(0.0, 10^-7*abs(fb));
    prediction_factor = 10^-7;
  elseif i_idx<81
    noise = normrnd(0.0, 10^-8*abs(fb));
   prediction_factor = 10^-8;
  elseif i_idx<91
    noise = normrnd(0.0, 10^-9*abs(fb));
    prediction_factor = 10^-9;
 elseif i_idx<100
    noise = normrnd(0.0, 0.05*abs(fb));
    prediction_factor = 0.05;
 elseif i_idx<=100
    noise = zeros(length(fb),1);
    prediction_factor=0;
 end    
 
%the measurement of boundary fluxes without noise
meas = fb;
%the scaled measurement of the noise 
scaled_noise_norm = norm(noise,1)/norm(meas,1);
%final measurement with noise
meas_with_noise = meas + noise;

%xvec correpsonds to -V^{-1}.(I+K).u+bar(f)=-\bar{b} as defined in the
%report
xvec =  meas_with_noise + d1; % d1 is known boundary effect due to unknown mu's
%norm of the vector bar b which we will use to fit
normFit = norm(xvec,1);
%the scaled predicted noise (approximated noised used for picking regularization parameter)
scaled_pred_noise_norm=prediction_factor*norm(meas_with_noise ,1)/normFit;
%here Mcoeff corresponds to map -A which is computed by
%taking -V^-1.L, -Gmat is our map V Mmatb is our map L

Mcoeff = -Gmat\MmatbSearch ; 
end

