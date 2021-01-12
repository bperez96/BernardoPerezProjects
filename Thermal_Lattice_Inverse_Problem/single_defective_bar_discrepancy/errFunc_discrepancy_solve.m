function [scaled_noise_norm ,key_idx, bestSol ] = ...
    errFunc_discrepancy_solve(mInt,mb,h,elements,Dmat,Gmat, ub, fb,~,~,gg_values,~,msMinus,msPlus, muTarget,iter_idx)

%this function picks the regularization paramater lambda using the predicted
%noise and map A and vector \bar{b} for a given noise assignment. It
%returns the solution mu after implementing the discrepancy theorem

%true support is a vector with bar indices corresonding to defective bars
%(the correct set of defective bars we look to solve for via inversion)
trueSupport = find(abs(muTarget)>1.0e-10);

%assign geometric information of the lattice to create maps 
indices1 = elements.interior(:,1);
indices2 = elements.interior(:,2);

def_xmin = -1.0;
def_xmax = 1.0;
def_ymin = -1.0;
def_ymax = 1.0;

%call function to create map A, vector \bar{b}, assign noise and compute
%the approximated noise
[coeffMat,yvec,scaled_pred_noise_norm,fit_norm,scaled_noise_norm]= ...
    getSysMat(Gmat,Dmat,ub,fb,mInt,mb,h,elements,gg_values,def_xmin,def_xmax,def_ymin,def_ymax,muTarget,iter_idx);

%creates a structure of options with default values
opts = glmnetSet;
%assign the number of lambda values to be used to solve the problem
opts.nlambda = 100;
%assign the converge threshold for coordinate descent updates
opts.thresh = 1.0e-7;
%parameter alpha is set to 1 to employ L1 regularization (no L2 regularization) 
opts.alpha = 1.0; 
%resets options to custom values assigned above
options = glmnetSet(opts);

%pass map A and \bar{b} to solve the inverse problem via the
%functional in the report and coordinate descent
%returns a set of solutions mu for 100 values of lambda
muGlobalFit = glmnet(coeffMat,yvec,'gaussian',options);

%matrix containing 100 columns for all solutions and row dimension equal to
%dimesion of mu, 0 set for indices of pristine bars, 1 for defective bars
supportSetL = abs(muGlobalFit.beta)>1.0e-10;
%number of lambdas used to solve
numLambdas = size(supportSetL,2);
%initialize the vector where the best mu solution will be stored
bestSol = [];
%initialize matrix to store sets of defective bar indices for all lambda
%solutions
%create a vector to store the residual norm for the mu solution for each
%lambda
resNorms = zeros(100);
%considering first solution is mu=0 for the first lambda, the residual is equal to the vector
%\bar{b} which is yvec
resNorms(1) = norm(yvec); 
%plot the problem domain and the defective bars in red.    
xplt = [msMinus(:,1)';msPlus(:,1)'];
yplt = [msMinus(:,2)';msPlus(:,2)'];
if iter_idx==1
    f2 = figure;
    plot(xplt,yplt,'color','k')
    hold on
    xDef = [mInt(indices1(trueSupport),1)';mInt(indices2(trueSupport),1)'];
    yDef = [mInt(indices1(trueSupport),2)';mInt(indices2(trueSupport),2)'];
    plot(xDef,yDef,'color','r','LineWidth',3)
    title("Problem domain- Defective bar plot")
    saveas(f2,'probDef.png')
    close(f2)
end

found_lamb=0;

%initilize the lambda iteration at which the optimal solution is found
key_idx=1;
% start from highest lambda and decrease lambda
for i=1:numLambdas
    
    %identify if any defective bars were found for the current mu solution 
    supportSetI = find(supportSetL(:,i));
    if isempty(supportSetI), continue, end % skip empty sets
    %compute the residual for the mu solution for the current lamda
    resNorms(i) = norm(yvec-coeffMat*muGlobalFit.beta(:,i),1)/fit_norm;
    %find the solution with the largest residual that satisfies the discrepancy theorem 
    if resNorms(i)<2.5*scaled_pred_noise_norm+0.06 && found_lamb==0
            found_lamb=1;  
            %assign the best solution to the current mu solution 
            bestSol = find(supportSetL(:,i));
            %identify the lambda iteration where the solution was found
            key_idx=i;
     end
end
    
%display when no solution is found satisfying the discrepancy theorem
if found_lamb==0
    disp('No solution found')
end

end



