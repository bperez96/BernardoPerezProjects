function [ Gvec ] = get_LGF_2D( m1,m2, g2_values )
%   Compute 2D Laplace Lattice Green's Function
%   Based on values of m1 & m2 either uses lookup
%   table or uses asymptotic formula (O(1/r^8) accurate)
%   (assumes isotropic lattice)
    % use asymptotic expansion by default

    mp2 = m1.*m1;
    np2 = m2.*m2;
    mp4 = mp2.*mp2;
    np4 = np2.*np2;
    mp6 = mp2.*mp4;
    np6 = np2.*np4;
    mp8 = mp4.*mp4;
    np8 = np4.*np4;
    mp12 = mp6.*mp6;
    np12 = np6.*np6;
    rsq = mp2 + np2;
    rsqp3 = rsq.*rsq.*rsq;
    g0 = -log(rsq)./(4*pi)-0.257343426413643;
    g1 = ((mp4-6*mp2.*np2+np4)./rsqp3)./(24*pi);
    g2 = ((43.*mp8 - 772.*mp6.*np2 + 1570*mp4.*np4 - ...
            772.*mp2.*np6 + 43.*np8)./rsq.^6)./(480*pi);
    g3 = ((949.*(mp12+np12)-44724.*(m1.^10.*np2+mp2.*m2.^10)+ ...
        249435.*(mp8.*np4+mp4.*np8)-414204.*(mp6.*np6))./ ...
        rsq.^9)./(2016*pi);
    Gvec = g0 + g1 + g2 + g3;
    
    % replace with direct values for close field points
     logical1 = m1<30;
     logical2 = m2<30;
%     idxNear = intersect(idx1,idx2);
    idxNear = find((logical1 & logical2)>0);
    m1(idxNear) = int32(m1(idxNear))+1;
    m2(idxNear) = int32(m2(idxNear))+1;
    if ~isempty(idxNear)
        for j = 1:size(idxNear,1)
            Gvec(idxNear(j)) = g2_values(m1(idxNear(j)),m2(idxNear(j)));
        end
    end

end

