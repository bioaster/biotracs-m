function [ xsim, ysim, mu, sigma, weight ] = gmwrap( peaks, varargin )
	 % peaks : list of peaks
	 % xsim: n-by-1 vector that give the sampling time of the simulation
	 
	 if isempty(peaks)
		  xsim = []; ysim = [];
		  return
	 end
	 
	 p = inputParser();
	 p.addParameter('xsim',[],@isnumeric);
	 p.addParameter('Range',[],@isnumeric);
	 p.addParameter('step',[],@isnumeric);
	 p.addParameter('sigma',[],@isnumeric);
	 p.KeepUnmatched = true;
	p.parse(varargin{:});
	 
	 
	 minbin = min(diff(peaks(:,1)));
	 if ~isempty(p.Results.step)
		  step = p.Results.step;
	 else
		  step = minbin/12;
	 end
		  
	 if ~isempty(p.Results.xsim)
		  if isempty(p.Results.xsim)
				xsim = []; ysim = []; return
		  end
		  xsim = p.Results.xsim;
		  components = 1:length(peaks(:,1));
	 elseif ~isempty(p.Results.Range)
		  if isempty(p.Results.Range)
				xsim = []; ysim = []; return
		  end
		  xmin = p.Results.Range(1);
		  xmax = p.Results.Range(2);
		  xsim = xmin:step:xmax;
		  components = peaks(:,1) >= xmin & peaks(:,1) <= xmax;
	 else
		  xmin = min(peaks(:,1));
		  xmax = max(peaks(:,1));
		  xsim = xmin:step:xmax;
		  components = 1:length(peaks(:,1));
	 end

	 if isempty(components)
		  ysim = zeros(length(xsim),1);
		  return
	 end
		  
	 %gaussian setting
	 mu = peaks(components,1);
	 if isempty(p.Results.sigma)
		  sigma = minbin/12;
	 else
		  sigma = p.Results.sigma;
	 end
	 weight = peaks(components,2);
	 [~, ysim] = biotracs.math.gmsim(mu, sigma, weight, xsim, varargin{:});
	  
	 end