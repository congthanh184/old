function [deltaerror, energyStress, nitaError]= error_calculate3(sigma_star, pf, localfine, supelf, uf)

	%prog for ref sol using the pseudo code in book
	%start with 
	nel     = supelf.nel;
	nnel    = supelf.nnel;
	nnode   = supelf.nnode;
	emodule = supelf.emodule;
	poisson = supelf.poisson; 

	% [localfine,supelf,uf]= today3(p+ones(nel,1));
	cf = supelf(1).c;
	eigvalf = supelf(1).values;
	sdoff = nnode*2 + 2*(sum(pf)-nel);

	%uniform refined mesh all upgrade to p+1, using this as the correct solution to derived energyStress for coarse mesh and define which to refine
	ngl=16; %can go up to 10 N'*N*det(J) ~ 3*p
	[p64,w64] = sbfeglqd1(ngl);
	[matmtrx,G] = sbfematisolq(1,emodule,poisson);
	D = G*matmtrx;
	invD = inv(D);

	energyStress = zeros(nel,1);% contribution of each ele in energyStress eq 6.6
	deltaerror = zeros(nel,1); % energyStress rate for each ele eq 6.5
    
	for iel=1:nel		
		sig_star_el = 0; 
		err_star_el = 0;
		
		% sigma has 3 entries
		sig_star_idx = 1 + (iel-1)*3;

		for i=1:(sdoff-2) %compute sig_star_el    FINE mesh
			for j=1:(sdoff-2)
				for int=1:ngl
					nita = p64(int); 
					wt = w64(int);
					[N,shapelq,dhdnitalq,Nder]= lobatto(nita,pf(iel));%row-vectors
					[modij, invmodij]=sbfemodijcirlipa(nnel,supelf(1).centrecoord(iel).coord,shapelq,dhdnitalq,localfine(iel).xcrd,localfine(iel).ycrd);   
					[b1, b2, B1, B2]=sbfederiv2(nnel,shapelq,dhdnitalq,invmodij);
					
					si = D * (-eigvalf(i) *B1 +B2) * localfine(iel).phi(:,i) ;
					sj = D * (-eigvalf(j) *B1 +B2) * localfine(iel).phi(:,j) ;
					
					% shape function for sigma need to have size 3x6 as sigma has 3 entries - assump p only 1
					N_for_sigma = [diag(ones(1, 3)*shapelq(1)), diag(ones(1, 3)*shapelq(end))];
					si_star = N_for_sigma * sigma_star(sig_star_idx:sig_star_idx+5, i);
					sj_star = N_for_sigma * sigma_star(sig_star_idx:sig_star_idx+5, j);
					ei = si_star - si;
					ej = sj_star - sj;
					
					sig_star_el = sig_star_el + wt * (cf(i)*cf(j)/(eigvalf(i)+eigvalf(j))) * transpose(si_star) * invD * sj_star * det(modij);
					err_star_el = err_star_el + wt * (cf(i)*cf(j)/(eigvalf(i)+eigvalf(j))) * transpose(ei) * invD * ej * det(modij);
				end
			end    
		end
		
		energyStress(iel)= real(-(sig_star_el)); %LHS of eq 6.6
		
		deltaerror(iel) = (real(-err_star_el)); 
		
	end

	% RHS of equation 6.5 in book
	% rhs65= (1/3)*max(deltaerror);
	% % RHS of equation 6.6 in book
	% rhs66= 10*mean(energyStress);

	% %check to see which element need to be refined
	% refineIndex= zeros(nel,1);
	% for iel=1:nel
	% 	if or(deltaerror(iel) > rhs65, energyStress(iel) > rhs66)
	% 		refineIndex(iel)=1;%if =1 need to be refined
	% 	end
	% end
    sqrt(sum(deltaerror))/sqrt(sum(energyStress))
	totalEnergy = sqrt( mean(energyStress) );
	nitaError = sqrt(deltaerror) ./ totalEnergy;
end