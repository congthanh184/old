function [N, NN, dNN] = lagrangian2(n, p)
	if p == 1
		NN = [	0.5 * (1 - n), ...
				0.5 * (1 + n) ];
		dNN = [ -0.5, ...
				0.5 ];

	elseif p == 2		
	    NN = [  -0.5 * n * (1 - n), ...
	            (1 + n) * (1 - n), ...
	            0.5 * n * (1 + n) ];
		dNN = [ -0.5 + n, ...
				-2 * n, ...
				0.5 + n ];
	end

	% [p1, w1] = sbfeglqd1(p+1);
	% p1 = linspace(-1, 1, p+1);
    % [p1] = lglnodes(p);
    
	% NN = [];
	% for idxP = 1:p+1
	% 	N_temp = 1;
	% 	for jdxP1 = 1:numel(p1)
	% 		if idxP ~= jdxP1
	% 			N_temp = N_temp*(n-p1(jdxP1))/(p1(idxP) - p1(jdxP1));
	% 		end
	% 	end
	% 	NN = [NN, N_temp];
	% end

	N = [];
	for idN = 1:numel(NN)
		N = [N, eye(2)*NN(idN)];
	end
end