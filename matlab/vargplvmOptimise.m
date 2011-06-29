function model = vargplvmOptimise(model, display, iters);

% VARGPLVMOPTIMISE Optimise the VARGPLVM.
% FORMAT
% DESC takes a given GP-LVM model structure and optimises with
% respect to parameters and latent positions. 
% ARG model : the model to be optimised.
% ARG display : flag dictating whether or not to display
% optimisation progress (set to greater than zero) (default value 1). 
% ARG iters : number of iterations to run the optimiser
% for (default value 2000).
% RETURN model : the optimised model.
%
% SEEALSO : vargplvmCreate, vargplvmLogLikelihood,
% vargplvmLogLikeGradients, vargplvmObjective, vargplvmGradient
% 
% COPYRIGHT : Michalis K. Titsias, 2009
% 
% COPYRIGHT : Neil D. Lawrence, 2005, 2006

% VARGPLVM


if nargin < 3
  iters = 2000;
  if nargin < 2
    display = 1;
  end
end


params = vargplvmExtractParam(model);

options = optOptions;
options(2) = 0.1*options(2); 
options(3) = 0.1*options(3);

if display
  options(1) = 1;
  if length(params) <= 100
    options(9) = 1;
  end
end
options(14) = iters;

if isfield(model, 'optimiser')
  optim = str2func(model.optimiser);
else
  optim = str2func('scg');
end


if strcmp(func2str(optim), 'optimiMinimize')
  % Carl Rasmussen's minimize function 
  params = optim('vargplvmObjectiveGradient', params, options, model);
else
  % NETLAB style optimization.
   params = optim('vargplvmObjective', params,  options,  'vargplvmGradient', model);
  
  % Comment the previous command and uncomment the following to use the ObjectiveGradient where possible.
  % This only works for the locally stored 'scg.m' which has been altered a bit so that in certain points
  % we can take advantage of the precomputations done for calculating the Objective so as to use them
  % (without recomputing them) for the calculation of the gradient. Having the modified optimiser with the
  % same name 'scg.m' is only a temporary solution, in the future we should define a new optimiser, e.g.
  % scg2.m and modify our demos to choose that from the options. 

  % params = optim('vargplvmObjectiveGradient', params,  options,  'vargplvmGradient', model);
end

model = vargplvmExpandParam(model, params);

