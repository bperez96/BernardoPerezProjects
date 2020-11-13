%Summary:
%This code approximates the displacement solution of a one dimensional bar subjected to linear axial forces 
%and a Winkler Foundation. Linear and quadratic shape functions are used. The approximations are plotted versus the exact solution. 
%The convergence rate of the error is computed using varying mesh sizes.

clear all
deg = input("Degree of approximants");
elems = [2,4,6];
%we will assume all dimensional parameters have a magnitude of 1 to
%consider a normalized solution
L = 1;
%initialize array storing approx strain energies
femStrainE=zeros(1,length(elems));
errorL2=zeros(1,length(elems));
errorH2=zeros(1,length(elems));
for j=1:length(elems)
    h = L/elems(j);
%initialize the global stiffness matrix/force vector    
    if deg==1
        app = 'Linear';
        globalK = zeros(elems(j)+1,elems(j)+1);
        globalM = zeros(elems(j)+1,elems(j)+1);
        globalF = zeros(elems(j)+1, 1);
%define values of the elemtnwise stiffness matrix for a uniform 1-D mesh
%using linear shape functions
        k_e = zeros(2,2);
        k_e(1,1) = 1/h;
        k_e(1,2) = -1/h;
        k_e(2,1) = -1/h;
        k_e(2,2) = 1/h;
        m_e = zeros(2,2);
        m_e(1,1) = h/3;
        m_e(1,2) = h/6;
        m_e(2,1) = h/6;
        m_e(2,2) = h/3;
%define postition values for mesh in physical space for plotting 
        nodes = [0: h: L];                                                    
%assemble elementwise values of stiffness/force to the global vector/matrix  
        for i = 1:elems(j)
            xl=h*(i-1);
            xr=h*i;
            globalK(i,i) = globalK(i,i) +  k_e(1,1);
            globalK(i,i+1) = globalK(i,i+1) +  k_e(1,2);
            globalK(i+1,i) = globalK(i+1,i) +  k_e(2,1);
            globalK(i+1,i+1) = globalK(i+1,i+1) +  k_e(2,2);
            globalM(i,i) = globalM(i,i) +  m_e(1,1);
            globalM(i,i+1) = globalM(i,i+1) +  m_e(1,2);
            globalM(i+1,i) = globalM(i+1,i) +  m_e(2,1);
            globalM(i+1,i+1) = globalM(i+1,i+1) +  m_e(2,2);
            globalF(i) = globalF(i) + (-h^2/12+h*xl/4+h*xr/4);
            globalF(i+1) = globalF(i+1) + (h/12*(h+3*(xl+xr)));
        end
        lhsMat=globalK+globalM;
        redK=globalK(2:elems(j), 2:elems(j));
        redMat=lhsMat(2:elems(j), 2:elems(j));
        redF=globalF(2:elems(j));
%solve for nodal values of displacement
        nodalU = redMat\redF;
        completeNod=horzcat(0,nodalU',0);
        figure() 
        plot(nodes, completeNod,'r')
        hold on 
        x = [0:0.1:1];
        plot(x, (x-sinh(x)/sinh(1)), 'k' )
        title( strcat("Bar Winkler Found.: Linear FEM vs exact Disp. sol, num elems: ",int2str(elems(j)) ))
        xlabel("Normalized position")
        ylabel("Normalized Disp.")
        legend("FEM sol","True sol.")
        intF = zeros(elems(j)-1);
        figure()
        for p=1:length(completeNod)-1
            intF(p) =(1/h)*(completeNod(p+1)-completeNod(p)); 
            hold on
            plot([nodes(p),nodes(p+1)],[intF(p), intF(p)],'r')
        end
        iterrorL2=0;
        iterrorH2=0;
        
        for n=1:elems(j)
            xl=h*(n-1);
            xr=h*(n);
            fun = @(s) h/2*(0.5*(h*s + xl + xr) - csch(1)* sinh(0.5*(h*s + xl + xr))-0.5*(completeNod(n)*(1-s)+completeNod(1+n)*(1+s))).^2;
            iterrorL2 = iterrorL2+(integral(fun,-1,1));
        end
        errorL2(j)=(iterrorL2)^0.5;
        for n=1:elems(j)
            xl=h*(n-1);
            xr=h*(n);
            slopeC = (completeNod(n+1)-completeNod(n))/h;
            fun = @(t) ((1-cosh(t)*csch(1))-slopeC).^2;
            iterrorH2 = iterrorH2+(integral(fun,xl,xr));
        end
        errorH2(j)=(iterrorL2+iterrorH2)^0.5;
        
   
        hold on
        x=0:0.1:1;
        plot(x,1-cosh(x)*csch(1),'k')
        title( strcat("Bar Winkler Found.: Linear FEM vs exact strain, num elems: ",int2str(elems(j)) ))
        xlabel("Normalized position")
        ylabel("Normalized Strain")
    
        disp([strcat('For linear approx, h=1/',int2str(elems(j))),' Error at nodes u_ex-u_app:'])
        disp((nodes-sinh(nodes)/sinh(1))-completeNod)
        femStrainE(j)=dot(nodalU,redK*nodalU);
    end
        
    
    
    if deg==2
        app = 'Quad.';
        globalK = zeros(2*elems(j)+1,2*elems(j)+1);
        globalM = zeros(2*elems(j)+1,2*elems(j)+1);
        globalF = zeros(2*elems(j)+1, 1);
%define values of the elemtnwise stiffness matrix for a uniform 1-D mesh
%using linear shape functions
        k_e = zeros(3,3);
        k_e(1,1) = 7/(3*h);
        k_e(1,2) = -8/(3*h);
        k_e(2,1) = -8/(3*h);
        k_e(2,2) = 16/(3*h);
        k_e(1,3) = 1/(3*h);
        k_e(3,1) = 1/(3*h);
        k_e(2,3) = -8/(3*h);
        k_e(3,2) = -8/(3*h);
        k_e(3,3) = 7/(3*h);
        m_e = zeros(3,3);
        m_e(1,1) = 4*h/30;
        m_e(1,2) = 2*h/30;
        m_e(2,1) = 2*h/30;
        m_e(2,2) = 8*h/15;
        m_e(1,3) = -h/30;
        m_e(3,1) = -h/30;
        m_e(3,2) = 2*h/30;
        m_e(2,3) = 2*h/30;
        m_e(3,3) = 4*h/30;
%define postition values for mesh in physical space for plotting 
        nodes = [0: h/2: L];      
        it=0;
%assemble elementwise values of stiffness/force to the global vector/matrix  
        for i = 1:2:2*elems(j) 
            it=it+1;
            xl=h*(it-1);
            xr=h*it;
            globalK(i,i) = globalK(i,i) +  k_e(1,1);
            globalK(i,i+1) = globalK(i,i+1) +  k_e(1,2);
            globalK(i+1,i) = globalK(i+1,i) +  k_e(2,1);
            globalK(i+1,i+1) = globalK(i+1,i+1) +  k_e(2,2);
            globalK(i,i+2) = globalK(i,i+2) +  k_e(1,3);
            globalK(i+2,i) = globalK(i+2,i) +  k_e(3,1);
            globalK(i+2,i+2) = globalK(i+2,i+2) +  k_e(3,3);
            globalK(i+1,i+2) = globalK(i+1,i+2) +  k_e(2,3);
            globalK(i+2,i+1) = globalK(i+2,i+1) +  k_e(3,2);
            
            globalM(i,i) = globalM(i,i) +  m_e(1,1);
            globalM(i,i+1) = globalM(i,i+1) +  m_e(1,2);
            globalM(i+1,i) = globalM(i+1,i) +  m_e(2,1);
            globalM(i+1,i+1) = globalM(i+1,i+1) +  m_e(2,2);
            globalM(i,i+2) = globalM(i,i+2) +  m_e(1,3);
            globalM(i+2,i) = globalM(i+2,i) +  m_e(3,1);
            globalM(i+2,i+2) = globalM(i+2,i+2) +  m_e(3,3);
            globalM(i+1,i+2) = globalM(i+1,i+2) +  m_e(2,3);
            globalM(i+2,i+1) = globalM(i+2,i+1) +  m_e(3,2);
            
         
            globalF(i) = globalF(i) + -5/60*h^2+5/60*h*xl+5/60*h*xr;
            globalF(i+1) = globalF(i+1) + 1/3*h*(xl+xr);
            globalF(i+2) =  globalF(i+2) + 5/60*h*(h+xl+xr);
        end
        lhsMat=globalK+globalM;
   
        redMat=lhsMat(2:2*elems(j), 2:2*elems(j));
        redF=globalF(2:2*elems(j));
%solve for nodal values of displacement
        nodalU = redMat\redF;
        completeNod=horzcat(0,nodalU',0);
        figure() 
        plot(nodes, completeNod,'r')
        hold on 
        x = [0:0.1:1];
        plot(x, (x-sinh(x)/sinh(1)), 'k' )
        title( strcat("Bar Winkler Found.: Quad. FEM vs exact Disp. sol, num elems: ",int2str(elems(j)) ))
        xlabel("Normalized position")
        ylabel("Normalized Disp.")
        legend("FEM sol","True sol.")
        
        figure()
        for w=1:elems(j)
            xl=h*(w-1);
            xr=h*(w);
            x=xl:0.001:xr;
            u_prime_elem=(completeNod(2*w-1)*(-(1/2) +(2*x-xl -xr)/h)+-completeNod(2*w)*((2*(2*x - xl - xr))/h)+completeNod(2*w+1)*(1/2 + (2*x - xl - xr)/h))*2/h;
            hold on
            plot(x,u_prime_elem,'r')
        end
        hold on
        x=0:0.1:1;
        plot(x,1-cosh(x)*csch(1),'k')
        title( strcat("Bar Winkler Found.: Quad. FEM vs exact strain, num elems: ",int2str(elems(j)) ))
        xlabel("Normalized position")
        ylabel("Normalized Strain")
        
        disp('Error at nodes u_ex-u_app:')
        disp((nodes-sinh(nodes)/sinh(1))-completeNod)
        redK=globalK(2:2*elems(j), 2:2*elems(j));
        femStrainE(j)=dot(nodalU,redK*nodalU);
        
        iterrorL2=0;
        iterrorH2=0;
        
        for n=1:elems(j)
            nl = 2*n-1;
            nc = 2*n;
            nr = 2*n+1;
            xl=h*(n-1);
            xc=h*(n-0.5);
            xr=h*(n);
            fun = @(s) h/2*(0.5*(h*s + xl + xr) - csch(1)* sinh(0.5*(h*s + xl + xr))-(0.5*completeNod(nl)*(s.^2-s)+completeNod(nc)*(1-s.^2)+completeNod(nr)*0.5*(s+s.^2))).^2;
            iterrorL2 = iterrorL2+(integral(fun,-1,1));
        end
        errorL2(j)=(iterrorL2)^0.5;
        for n=1:elems(j)
            nl = 2*n-1;
            nc = 2*n;
            nr = 2*n+1;
            xl=h*(n-1);
            xc=h*(n-0.5);
            xr=h*(n);
            fun = @(s) h/2*( 1- csch(1)* cosh(0.5*(h*s + xl + xr))-2/h*(completeNod(nl)*(s-1/2)+completeNod(nc)*(-2*s)+completeNod(nr)*(1/2+s))).^2;
            iterrorH2 = iterrorH2+(integral(fun,-1,1));
            
        end
        errorH2(j)=(iterrorL2+iterrorH2)^0.5;
      
    end
    
end
figure()
plot([elems(1),elems(end)],[0.0185485,0.018548] )
hold on
plot(elems, femStrainE)
title( strcat("Bar Winkler Found:, ", app," FEM vs exact Strain energy vs num of elems"))

xlabel("Num elems")
ylabel("Normalized Strain E.")
legend("True Strain E","FEM Strain E.")

figure()
plot(log10(1./elems),log10(errorL2),'b')
hold on
plot([log10(1./elems(end)),log10(1./elems(end))-log10(1./elems(1))/2],[log10(errorL2(end)),log10(errorL2(end))-3*log10(1./elems(1))/2],'r')

figure()
plot(log10(1./elems),log10(errorH2),'b')
hold on
plot([log10(1./elems(end)),log10(1./elems(end))-log10(1./elems(1))/2],[log10(errorH2(end)),log10(errorH2(end))-log10(1./elems(1))],'r')