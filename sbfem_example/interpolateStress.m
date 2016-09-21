function [interStress] = interpolateStress(sampleX, sampleStress, interX, orderP)
	% sampleX = [2;7;13];
	% sampleStress = [5;10;20];
	% interX = [0; 4; 10; 15];

	sampleX = sampleX(:);
	interX = interX(:);
    
	% assembly P depend on order P
	if orderP == 1
		P = [ones(numel(sampleX), 1), sampleX];
		interP = [ones(numel(interX), 1), interX];
	elseif orderP == 2
		P = [ones(numel(sampleX), 1), sampleX, sampleX.^2, sampleX.^3, sampleX.^4];		
		interP = [ones(numel(interX), 1), interX, interX.^2, interX.^3, interX.^4];
	end



	A = P'*P;
	b = P'*sampleStress;

	a = A\b;

	interStress = interP * a;
    figure;
	plot(sampleX, sampleStress(:,1), 'x'); grid on;
	hold on;
	plot(interX, interStress(:,1), 'o-'); grid on;
end