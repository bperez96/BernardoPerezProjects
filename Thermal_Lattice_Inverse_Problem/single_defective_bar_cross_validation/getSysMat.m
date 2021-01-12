function [Mcoeff,xvec,scaled_pred_noise_norm,fit_norm,scaled_noise_norm] = ...
    getSysMat(Gmat,Dmat,ub,fb,mInt,mb,h,elements,gg_values,def_xmin,def_xmax,def_ymin,def_ymax,muTarget,it_idx)
%this function computes the map L as defined in the reports. This will be
%used to construct map A in functions called here

%the following lines identify the set of interior bars which are candidates
%for defective bars
xprod = (mInt(:,1)-def_xmin).*(mInt(:,1)-def_xmax);
yprod = (mInt(:,2)-def_ymin).*(mInt(:,2)-def_ymax);
xNdSet = xprod<0.0;
yNdSet = yprod<0.0;
xAndyNdSetVoid = xNdSet&yNdSet;
search.layer1Indices = find(xAndyNdSetVoid);
search.num_layer1Indices = size(search.layer1Indices,1);
xNdSet = xprod<0.0;
yprod = (mInt(:,2)-def_ymax);
yNdSet = yprod==0.0;
xAndyNdSet1 = xNdSet&yNdSet;
xNdSet = xprod==0.0;
yNdSet = yprod<0.0;
xAndyNdSet2 = xNdSet&yNdSet;
xAndyNdSetDef = xAndyNdSet1|xAndyNdSet2;
search.layer2Indices = find(xAndyNdSetDef);
search.num_layer2Indices = size(search.layer2Indices,1);
search.allIndices = [search.layer2Indices;search.layer1Indices];
nAllBars = size(elements.interior,1);
indices1 = elements.interior(:,1);
indices2 = elements.interior(:,2);
Li1 = ismember(indices1,search.allIndices);
Li2 = ismember(indices2,search.allIndices);
containedBar = Li1 & Li2;
nSearchBars = sum(containedBar);

%now we create MmatbSearch which is our L map from dimension of mu to
%boundary nodes
nb = size(mb,1);
MmatbSearch = zeros(nb,nSearchBars);
searchIndices1 = zeros(nSearchBars,1);
searchIndices2 = searchIndices1;
k=1;

%recover the node indices of the interior bars
for i=1:nAllBars
    if containedBar(i)
        searchIndices1(k) = indices1(i);
        searchIndices2(k) = indices2(i);
        k=k+1;
    end
end

%compute the components of map L below
for i = 1:nb
    coordmn1 = abs(mInt(searchIndices2,1) - mb(i,1))/h;
    coordmn2 = abs(mInt(searchIndices2,2) - mb(i,2))/h;
   
    %function get_LGF_2D returns 2D lattice greens function solution given
    %the position of the solution and position of source
    
    Gplus = get_LGF_2D(coordmn1,coordmn2,gg_values);
    coordmn1 = abs(mInt(searchIndices1,1) - mb(i,1))/h;
    coordmn2 = abs(mInt(searchIndices1,2) - mb(i,2))/h;
    Gminus = get_LGF_2D(coordmn1,coordmn2,gg_values);
    MmatbSearch(i,:) = Gminus - Gplus;
end
%call for assignment of noise, predicted noise and to compute matrix A and
%vector b as introduced in report
[Mcoeff,xvec, scaled_pred_noise_norm,fit_norm,scaled_noise_norm] = ...
    noise_system_return_function(MmatbSearch,mb,Gmat,Dmat,ub,fb,muTarget, it_idx);

end

