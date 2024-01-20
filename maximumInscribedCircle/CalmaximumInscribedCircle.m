boundary = importdata('.\boundary.mat');
[r,c] = maximumInscribedCircle(boundary);


function[r,c] = maximumInscribedCircle(boundary)
%%
% Author Shen ChangQing 625372005@qq.com
% Maximum Inscribed Circle using Voronoi Diagram/Delaunay Triangulation.
% Modify according to: Tolga Birdal (2024). Maximum Inscribed Circle using Voronoi Diagram (https://www.mathworks.com/matlabcentral/fileexchange/32543-maximum-inscribed-circle-using-voronoi-diagram), MATLAB Central File Exchange. Retrieved January 20, 2024.
% Less code and faster computations.
% Input: boundary - boundary of multiple connected regions, Cell containing
% arraies of size 2 * n_idx. the number of points in each boundary is n_idx.
% Output: r, radius of the maximum inscribed circle, 
% Output: c, coordinates of the maximum inscribed circle.
% Complexity: O(nlogn), the number of points in the cell is n.
%%
    sizeBoundary=size(boundary,2);
    allBoundaryPt=[];
    for i=1:sizeBoundary
        allBoundaryPt = [allBoundaryPt;boundary{i}];
    end
    
    dt=delaunayTriangulation(allBoundaryPt);
    [cc,r] =circumcenter(dt);
    
    ccInBoundary=inpolygon(cc(:,1),cc(:,2), boundary{1}(:,1), boundary{1}(:,2));
    
    for i=2:sizeBoundary
        ccNotInBoundary=inpolygon(cc(:,1),cc(:,2), boundary{i}(:,1), boundary{i}(:,2));
        ccInBoundary=ccInBoundary&~ccNotInBoundary;
    end
    
    cc=cc(find(ccInBoundary==1),:);
    r=r(find(ccInBoundary==1),:);
    [r n] = max(r);
    c = cc(n,:);

    if 1 % plot
        figure()
        hold on
        axis equal
        aplha=0:pi/40:2*pi;
        x=r*cos(aplha)+c(1,1);
        y=r*sin(aplha)+c(1,2);
        plot(x,y,'-');
        plot(c(1),c(2),'g*')
        for idx = 1:length(boundary)
            plot(boundary{idx}(:,1), boundary{idx}(:,2));
        end
    end
end
