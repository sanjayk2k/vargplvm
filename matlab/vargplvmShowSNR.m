function SNR = vargplvmShowSNR(model, displ)

if nargin < 2
    displ = true;
end

%%


if isfield(model, 'mOrig')
    varY = var(model.mOrig(:));
else
    varY = var(model.m(:));
end
beta = model.beta;
SNR = varY * beta;
if displ
    fprintf('     %f  (varY=%f, 1/beta=%f)\n',  SNR, varY, 1/beta)
end

