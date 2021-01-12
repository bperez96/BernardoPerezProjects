%this function will run to collect mu solutions to 100 different levels of
%noise for the same defective lattice (with one missing bar) with the same applied boundary
%temperature across all cases; cross validation will be used to solve each
%case

%clear any stored variables
clear
%load save variabls corresponding to boundary data of the defective lattice
%and maps such as K and V
load('err_func_variable_def_center_bar_validation.mat')
%vector to store if each cases at least identitfied the correct defective
%bar in the set of predicted defective bars
number_bars_correctly_predicted=zeros(100,1);
%vector to store the number of predicted defective bars
number_predicted_bars=zeros(100,1);
%storage for noise norm of each case 
noise_norms=zeros(100,1);

%results are stores in text file
 fname=strcat('cases_num_predicted_bar_and _noise.txt');
%keep track of the number of cases where the predicted bars corresponds to
%the correct solution
 number_correct=0;
 %a varaible to keep track the number of cases that identitfied the
 %defective bars (cases could have deceted multiple bars)
 number_cases_predicted_the_bar=0;
 %write in the file the variables to be save for each of the 100 cases
 dlmwrite(fname,'Num of predicted defective bars, defective bar numbers,scaled noise norm','delimiter','');
%loop to solve 100 different noise cases for the defective lattice
 for j=1:100
    iter_idx=j;
    %call the function that returns the solution to the inverse problem via
    %cross validation for a given noise
    [muVec,scaled_noise_norm ,key_idx, bestSol ] = ....
    errFunc_cross_validation_solve(mInt,mb,h,elements,Dmat,Gmat, dub, dfb,ub0,fb0,gg_values,normals,msMinus,msPlus, muTarget,iter_idx);
    %record the number of defective bars predicted by the inversion, the
    %set of predicted defective bars, and the scaled norm of the noise for
    %a particular case    
    casenum=  strcat('Case:' ,int2str(j));   
    dlmwrite(fname,casenum,'-append','delimiter','');
    dlmwrite(fname,'Num def bars: ','-append','delimiter','');
    dlmwrite(fname,[length(bestSol)],'-append');
    dlmwrite(fname,'Def bar numbers: ','-append','delimiter','');
    dlmwrite(fname,[bestSol],'-append');
    dlmwrite(fname,'Scaled noise norm ','-append','delimiter','');
    dlmwrite(fname,[scaled_noise_norm],'-append');
    noise_norms(j)=scaled_noise_norm;
    number_predicted_bars(j)=length(bestSol);
   %record if current case was correctly solved
    if length(bestSol)==1 && bestSol==886
        number_correct=number_correct+1;
    end
    %record if current case at least identified the defective bar
    if ismember(886,bestSol)
        number_cases_predicted_the_bar=number_cases_predicted_the_bar+1;
    end
    %store if the case at least predicted the defective bar in its set of
    %predcited defective bars
    number_bars_correctly_predicted(j)= norm(double(ismember([886],bestSol)),1);
 end

  %plot the number of defective bars predicted versus the sclaed noise norm for
 %each case
figure()
scatter(log10(noise_norms),number_predicted_bars)
title("Number of predicted bars vs Case Normalized Noise Norm: Single defective bar// Cross-validation", 'FontSize', 12)
xlabel(['Norm of noise: $\log\left[\frac{\|\mathbf{n}\|_1}{\|\mathbf{f_1}\|_1}\right]$'],'Interpreter','latex', 'FontSize', 18)
ylabel('Number of predicted defective bars', 'FontSize', 12)