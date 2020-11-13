%Summary:
%This code approximates the displacement solution of a one dimensional bar subjected to exponential axial forces 
%Solutions experience singularities for alpha<0. Error convergence rates
%are plotted. The integrability of the solution plays a role in determining
%the convergence rate.
%

clear all
deg = input("Degree of approximants");
a = input("Input alpha: ");
elems = [2,4,8,16];
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
       
        globalF = zeros(elems(j)+1, 1);
%define values of the elemtnwise stiffness matrix for a uniform 1-D mesh
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
            xl=h*(i-1);
            xr=h*i;
            globalK(i,i) = globalK(i,i) +  k_e(1,1);
            globalK(i,i+1) = globalK(i,i+1) +  k_e(1,2);
            globalK(i+1,i) = globalK(i+1,i) +  k_e(2,1);
            globalK(i+1,i+1) = globalK(i+1,i+1) +  k_e(2,2);
            fun = @(s) h/2*(0.5*(h*s + xl + xr)).^(a-1)*-a*0.5.*(1-s);
            globalF(i) = globalF(i) + (integral(fun,-1,1));
            fun = @(s) h/2*(0.5*(h*s + xl + xr)).^(a-1)*-a*0.5.*(1+s);
            globalF(i+1) = globalF(i+1) + (integral(fun,-1,1));
        end
      
        redK=globalK(2:end , 2:end);
      
        redF=globalF(2:end);
        redF(end,end)=redF(end,end)+1;
%solve for nodal values of displacement
        nodalU = redK\redF;
        completeNod=horzcat(0,nodalU');
        figure() 
        plot(nodes, completeNod,'r')
        hold on 
        x = [0:0.01:1];
        plot(x, 1/(1+a)*x.^(1+a), 'k' )
        title( strcat("Rod, Singular source alpha=",num2str(a)," Linear FEM vs exact Disp. sol, num elems: ",int2str(elems(j)) ))
        xlabel("Normalized position")
        ylabel("Normalized Disp.")
        legend("True sol.","FEM sol")
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
            fun = @(s) h/2*(1/(1+a)*(0.5*(h*s + xl + xr)).^(1+a) -0.5*(completeNod(n)*(1-s)+completeNod(1+n)*(1+s))).^2;
            iterrorL2 = iterrorL2+(integral(fun,-1,1));
        end
        errorL2(j)=(iterrorL2)^0.5;
        if a>-0.5   
            for n=1:elems(j)
                xl=h*(n-1);
                xr=h*(n);
                slopeC = (completeNod(n+1)-completeNod(n))/h;
                fun = @(t) ((t).^(a)-slopeC).^2;
                iterrorH2 = iterrorH2+(integral(fun,xl,xr));
            end
            errorH2(j)=(iterrorL2+iterrorH2)^0.5;
        end
   
        hold on
        x=0:0.1:1;
        plot(x,x.^a,'k')
        title( strcat("Rod, Singular source alpha=",num2str(a)," Linear FEM vs exact strain, num elems: ",int2str(elems(j)) ))
        xlabel("Normalized position")
        ylabel("Normalized Strain")
    
        disp([strcat('For linear approx, h=1/',int2str(elems(j))),' Error at nodes u_ex-u_app:'])
        disp((nodes-sinh(nodes)/sinh(1))-completeNod)
        femStrainE(j)=dot(nodalU,redK*nodalU);
    end
        
    
    
    if deg==2
        app = 'Quad.';
        globalK = zeros(2*elems(j)+1,2*elems(j)+1);
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
         
            
            fun = @(s) h/2*(0.5*(h*s + xl + xr)).^(a-1)*-a*0.5.*s.*(s-1);
         
            globalF(i) = globalF(i) + (integral(fun,-1,1));
            fun = @(s) h/2*(0.5*(h*s + xl + xr)).^(a-1)*-a.*(1-s.^2);
            globalF(i+1) = globalF(i+1) +(integral(fun,-1,1));
            fun = @(s) h/2*(0.5*(h*s + xl + xr)).^(a-1)*-a*0.5.*s.*(s+1);
            globalF(i+2) =  globalF(i+2) +(integral(fun,-1,1));
        end
        redK=globalK(2:end, 2:end);
   
       
        redF=globalF(2:end);
        redF(end)=redF(end)+1;
%solve for nodal values of displacement
        nodalU = redK\redF;
        completeNod=horzcat(0,nodalU');
        figure() 
        
        
        x = [0.01:0.01:1];
        plot(x,1/(1+a)*x.^(1+a), 'k' )
        for i=1:elems(j)
            xl=h*(i-1);
            xr=h*(i);  
          
            x=xl:0.001:xr;
            hold on
            plot(x,0.5/h*(2*x-xr-xl)*completeNod(2*i-1).*((2*x-xr-xl)/h-1)+(1-((2*x-xr-xl)/h).^2)*completeNod(2*i)+0.5/h*(2*x-xr-xl)*completeNod(2*i+1).*((2*x-xr-xl)/h+1),'r')
            
        end
        title( strcat("Rod, Singular source alpha=", num2str(a) , " Quad. FEM vs exact Disp. sol, num elems: ",int2str(elems(j)) ))
        xlabel("Normalized position")
        ylabel("Normalized Disp.")
        legend("True sol","FEM sol.")
        
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
        plot(x,x.^a,'k')
        title( strcat("Rod, Singular source alpha=",num2str(a)," Quad. FEM vs exact strain, num elems: ",int2str(elems(j)) ))
        xlabel("Normalized position")
        ylabel("Normalized Strain")
        
        disp('Error at nodes u_ex-u_app:')
        disp((nodes-sinh(nodes)/sinh(1))-completeNod)
     
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
            fun = @(s) h/2*(1/(1+a)*(0.5*(h*s + xl + xr)).^(1+a) -(0.5*completeNod(nl)*(s.^2-s)+completeNod(nc)*(1-s.^2)+completeNod(nr)*0.5*(s+s.^2))).^2;
            iterrorL2 = iterrorL2+(integral(fun,-1,1));
        end
        errorL2(j)=(iterrorL2)^0.5;
        if a>-0.5
            for n=1:elems(j)
                nl = 2*n-1;
                nc = 2*n;
                nr = 2*n+1;
                xl=h*(n-1);
                xc=h*(n-0.5);
                xr=h*(n);
                fun = @(s) h/2*( (0.5*(h*s + xl + xr)).^(a)-2/h*(completeNod(nl)*(s-1/2)+completeNod(nc)*(-2*s)+completeNod(nr)*(1/2+s))).^2;
                iterrorH2 = iterrorH2+(integral(fun,-1,1));
            
            end
            errorH2(j)=(iterrorL2+iterrorH2)^0.5;
      
    end
    
    end
end


if deg ==1
    figure()
    plot(log10(1./elems),log10(errorL2),'b')
    hold on
%plot([log10(1./elems(end)),log10(1./elems(end))-log10(1./elems(1))/2],[log10(errorL2(end)),log10(errorL2(end))-3*log10(1./elems(1))/2],'r')
%     if a>-0.5   
    m=min([1,a+3/2-1]);
%    plot([log10(1./elems(end)),log10(1./elems(end))+1],[log10(errorL2(end)),log10(errorL2(end))+m],'r')
    plot([log10(1./elems(end)),log10(1./elems(end))-log10(1./elems(1))/2],[log10(errorL2(end)),log10(errorL2(end))-(m+1)*log10(1./elems(1))/2],'r')
    title( strcat("Rod, Singular source alpha=",num2str(a)," Linear FEM L2 error vs h" ))
    xlabel("log(h)")
    ylabel("log(error)")
    legend("L2 error", strcat("Slope-",num2str(m+1)))
     if a>-0.5
         figure()
         plot(log10(1./elems),log10(errorH2),'b')
         hold on
         plot([log10(1./elems(end)),log10(1./elems(end))-log10(1./elems(1))/2],[log10(errorH2(end)),log10(errorH2(end))-m*log10(1./elems(1))/2],'r')
         title( strcat("Rod, Singular source alpha=",num2str(a)," Linear FEM Energy error vs h" ))
        xlabel("log(h)")
        ylabel("log(error)")
         legend("Energy error", strcat("Slope-",num2str(m)))
    
     end 

end

if deg ==2
    figure()
    plot(log10(1./elems),log10(errorL2),'b')
    hold on
%plot([log10(1./elems(end)),log10(1./elems(end))-log10(1./elems(1))/2],[log10(errorL2(end)),log10(errorL2(end))-3*log10(1./elems(1))/2],'r')
%     if a>-0.5   
    m=min([2,a+3/2-1]);
%    plot([log10(1./elems(end)),log10(1./elems(end))+1],[log10(errorL2(end)),log10(errorL2(end))+m],'r')
    plot([log10(1./elems(end)),log10(1./elems(end))-log10(1./elems(1))/2],[log10(errorL2(end)),log10(errorL2(end))-(m+1)*log10(1./elems(1))/2],'r')
    title( strcat("Rod, Singular source a=",num2str(a)," Quad. FEM L2 error vs h" ))
    xlabel("log(h)")
    ylabel("log(error)")
     legend("L2 error", strcat("Slope-",num2str(m+1)))
    %     else
%         plot([log10(1./elems(end)),log10(1./elems(end))-log10(1./elems(1))/2],[log10(errorL2(end)),log10(errorL2(end))-log10(1./elems(1))/2],'r')
%     end
     if a>-0.5
         %m=min([1,a+3/2-1]);
        figure()
        plot(log10(1./elems),log10(errorH2),'b')
         hold on
         plot([log10(1./elems(end)),log10(1./elems(end))-log10(1./elems(1))/2],[log10(errorH2(end)),log10(errorH2(end))-m*log10(1./elems(1))/2],'r')
        title( strcat("Rod, Singular source alpha= ",num2str(a),": Quad FEM Energy error vs h" ))
        xlabel("log(h)")
        ylabel("log(error)")
         legend("Energy error", strcat("Slope-",num2str(m)))
     end%plot([log10(1./elems(end)),log10(1./elems(end))],[log10(errorH2(end))+0.5,log10(errorH2(end))+1],'r')
% 
% end
end