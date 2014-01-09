%Gaussian interference
nAntennas = 2;
nSamples = 10;
interferenceToNoiseRatioDb = 10;
nSimulations = 10000;
interferenceToNoiseRatio = 10*(interferenceToNoiseRatioDb/10);

out = zeros(nSimulations, 1);
for iSimulation = 1:nSimulations
    INTERFERENCE = randn(nSamples, 1);% + 1i*randn(nSamples, 1);
    channelCoefficients = randn(1, nAntennas) + 1i*randn(1, nAntennas);
    Z = bsxfun(@times, channelCoefficients, INTERFERENCE);
    N = (1/sqrt(interferenceToNoiseRatio))*(randn(nSamples, nAntennas) + 1i*randn(nSamples, nAntennas));
    X = Z+N;

    %W

    R = corrcoef(X);
    [V, D] = eig(R);
    [~, index] = min(abs(diag(D)));
    W = V(:, index);
    YZ = Z*W;
    YN = N*W;


    out(iSimulation) = 10*log10(((std(YZ)+std(YN))/std(YN))^2);
end
mean(out)