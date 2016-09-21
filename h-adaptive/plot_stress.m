function plot_stress(local, rec_str)
    figure; 
    x = [];
    y = [];
    strx = [];
    recx = [];
    for iEle = 1:size(local, 2)
        x = [x; local(iEle).x];    
        y = [y; local(iEle).y];
        strx = [strx; local(iEle).strx];
        recx = [recx; rec_str(iEle).rec_strx];
    end
%     mesh(x, y, recx);
    contour(x, y, recx, 40);
%     figure;
%     contour(x, y, strx, 40);
%     contour(x, y, strx, 40);
end