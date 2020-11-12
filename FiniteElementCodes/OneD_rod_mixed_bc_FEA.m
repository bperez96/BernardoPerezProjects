%Summary:
%This code solves the 1d problem of a bar subjected to constant axial load
%using linear finite elements.
%Displacements, internal stresses, and strain energy of the bar are approximated using different numbers of elements.
%Results are plotted vs the exact solution


clear all
%number of elements
elems = [2,4,8,16];
%we will assume all dimensional parameters have a magnitude of 1 to
%consider a normalized solution
L = 1;
%initialize array storing approx strain energies
femStrainE=zeros(length(elems),1);

for j=1:length(elems)
    h = L/elems(j);
%initialize the global stiffness matrix/force vector    
    globalK = zeros(elems(j)+1,elems(j)+1);
    globalF = zeros(elems(j)+1, 1);
%define values of the elementwise stiffness matrix for a uniform 1-D mesh
%using linear shape functions
    k_e = zeros(2,2);
    k_e(1,1) = 1/h;
    k_e(1,2) = -1/h;
    k_e(2,1) = -1/h;
    k_e(2,2) = 1/h;
%define postition values for mesh in physical space for plotting 
    nodes = [0: h: L];
%assemble elementwise values of stiffness/force to the global vector/matrix  
    for i = 1:elems(j)
        globalK(i,i) = globalK(i,i) +  k_e(1,1);
        globalK(i,i+1) = globalK(i,i+1) +  k_e(1,2);
        globalK(i+1,i) = globalK(i+1,i) +  k_e(2,1);
        globalK(i+1,i+1) = globalK(i+1,i+1) +  k_e(2,2);
        globalF(i) = globalF(i) + h/2;
        globalF(i+1) = globalF(i+1) + h/2;
    end
%add to global stiffness the contribution due to the mixed bc term in the
%problem weakform
    globalK(elems(j)+1,elems(j)+1) = 4 +globalK(elems(j)+1,elems(j)+1);
%consider mixed  BC contribution to K separately, used later on for strain energy calc. 
    M = zeros(elems(j)+1,elems(j)+1);
    M(elems(j)+1,elems(j)+1) = 4;
%solve for nodal values of displacement
    nodalU = globalK\globalF;
%initialize array to store elemtwise values for internal force
    intF = zeros(elems(j)-1);
%compute internal force(which is constant over each linear element)    
    for p=1:length(nodalU)-1
        intF(p) = (1/h)*(nodalU(p+1)-nodalU(p));        
    end
%plot displacements
    figure() 
    plot(nodes, nodalU,'r')
    hold on 
    x = [0:0.1:1];
    plot(x, 1/4*(3-2*(x.^2)), 'k' )
    title( strcat("Rod/Spring system: FEM vs exact Disp. sol, h: ",int2str(elems(j)) ))
    xlabel("Normalized position")
    ylabel("Normalized Disp.")
    legend("FEM sol","True sol.")
    
    figure()
%plot constant int force values over each element in domain 
    currPt=0;
    for n=1:length(nodalU)-1
        hold on
        plot([currPt, currPt+h],[intF(n), intF(n)],'r')
        currPt=currPt+h;   
    end
    
    hold on 
    plot(x, -x, 'k')
    title(strcat("Rod/Spring system: FEM vs exact Int. Force sol, h: ",int2str(elems(j))))
    xlabel("Normalized position")
    ylabel("Normalized Int. Force")
    text(0.65,-0.25,"Red- FEM Sol; Black- True sol")
%compute approx strain energy for the given disccretization    
    strainE=0.5*dot(nodalU,globalF-M*nodalU);
    femStrainE(j)=strainE;
end
%plot approximate strain energies
figure()
plot(elems,femStrainE,'r')
hold on
plot([elems(1),elems(length(elems))],[1/6,1/6],'k')
title("Rod/Spring system: FEM vs exact Strain Energy sol")
xlabel("Num. of elements")
ylabel("Normalized Stain energy")
legend('FEM Sol.','True sol.')