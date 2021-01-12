function [muVec,scaled_noise_norm ,key_idx, bestSol ] = ...
    errFunc_cross_validation_solve(mInt,mb,h,elements,Dmat,Gmat, ub, fb,~,~,gg_values,~,msMinus,msPlus, muTarget,iter_idx)

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

%call function to create map A, vector \bar{b}, assign noise
[coeffMat,yvec,~,~,scaled_noise_norm]= ...
    getSysMat(Gmat,Dmat,ub,fb,mInt,mb,h,elements,gg_values,def_xmin,def_xmax,def_ymin,def_ymax,muTarget,iter_idx);

%creates a structure of options with default value
opts = glmnetSet;
%assign the number of lambda values to be used to solve the problem
opts.nlambda = 100;
%assign the converge threshold for coordinate descent updates
opts.thresh = 1.0e-7;
%parameter alpha is set to 1 to employ L1 regularization (no L2 regularization) 
opts.alpha = 1.0; 
%resets options to custom values assigned above
options = glmnetSet(opts);
%assign the number of instances the problem will be solved for. In this
%case we will solve the problem llength(fb) number of times with one missing row per instance 
num_folds = length(fb);
%pass map A and \bar{b} to solve the inverse problem via the
%functional in the report and coordinate descent
%returnt the mean squared prediction error for 100 values of lamda by
%performing generalized cross validation
%also returns the mu solution for each of those lamda value 
muCrossVFit = cvglmnet(coeffMat,yvec,'gaussian',options,'deviance',num_folds);
%the value of lambda which produced the lowest mean squared prediction error
ideal_lamb = muCrossVFit.lambda_min;
%the following object stores the array of mu solutions for the 100 tested
%lambda solutions and the value of lambda themselves
muGlobalFit = muCrossVFit.glmnet_fit;
%below we have a logical array with 100 columns for each mu solution, this
%indicator will contain 1 for defective bars and 0 for non-defective bars
supportSetL = abs(muGlobalFit.beta)>1.0e-10;

%assign the number of lambda iterated when solution is found 
key_idx=1;
%iterate through lambda solutions until lambda corresponding to min. cross
%validation prediction error is found. Once found assign the best solution
%to the mu corresponding to tht lambda
for i=1:length(muGlobalFit.lambda)
    curr_lamb=muGlobalFit.lambda(i);
    if curr_lamb==ideal_lamb
        key_idx=i;
        found_lamb=1;
        bestSol = find(supportSetL(:,i));
        muVec=muGlobalFit.beta(:,i);
        break
    end
end
        
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
end

end



