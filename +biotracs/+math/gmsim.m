function [ xsim, ysim ] = gmsim( mu, sigma, weight, xsim, varargin )
% mu : k-by-1 matrix that gives the mean of each components of the mixture
% sigma: 1-by-1 matrix that gives the standard deviation of all the mixtures
% weight: k-by-1 matrix that gives the weight of each component
% xsim: n-by-1 vector that give the sampling time of the simulation
	 
	 p = inputParser();
	 p.addParameter('regularize',false,@islogical);
	 p.KeepUnmatched = true;
	 p.parse(varargin{:});
	 
	 if isempty(xsim)
		  ysim = [];
		  return
	 elseif ~isempty(find(diff(xsim) < 0, 1))
		  error('Vector xsim must contain increasing values');
	 end
	 
	 if ~isempty(find(sigma <= 0, 1))
		  error('Standard deviation sigma must be positive');
	 end
	 
	 xsim = xsim(:);
	 weight = weight(:);
	 ysim = zeros(length(xsim), 1 );

	 d = size(mu);
	 ncomp = d(1);
	 
	 if ncomp == 0
		  return
	 end
	 
	 %sqrt_of_2pi = sqrt(2*pi);
	 
%	  obj = gmdistribution(mu,sigma^2,weight);
%	  ysim = pdf(obj,xsim);
%	  ysim = ysim * max(weight) / max(ysim);
	 
	 for k=1:ncomp
		  mu_k = mu(k);
		  sigma_k = sigma(1);
		  weight_k = weight(k); 
		  g_k = exp( -((xsim - mu_k)./(2*sigma_k)).^2  ) ; % ./ (sigma_k*sqrt_of_2pi);
		  
		  if p.Results.regularize
				%set negligible values to zero
				zero_index =  g_k <= 0.0497870683678639; % exp(-6/2) : regularization at 6*sigma
				g_k(zero_index) = 0;
		  end
		  
		  g_k = g_k * weight_k;
		  ysim = ysim + g_k;
	 end	 
end