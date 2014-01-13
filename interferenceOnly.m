%Gaussian interference
nAntennas = 2;
nSamples = 1000;
interferenceToNoiseRatioDb = 10;
nSimulations = 3000;
interferenceToNoiseRatio = 10^(interferenceToNoiseRatioDb/10);
nSamplesValues = [2 4 6 8 10];

out = zeros(nSimulations, 5);
for iValue=1:5
    nSamples = nSamplesValues(iValue);
%     nSamples = 4;
    for iSimulation = 1:nSimulations
        INTERFERENCE = (randn(nSamples, 1) + 1i*randn(nSamples, 1))/sqrt(2);
    %     INTERFERENCE = zeros(nSamples, 1);
        channelCoefficients = randn(1, nAntennas) + 1i*randn(1, nAntennas);
        Z = bsxfun(@times, channelCoefficients, INTERFERENCE);

        N = (1/sqrt(2*interferenceToNoiseRatio))*(randn(nSamples, nAntennas) + 1i*randn(nSamples, nAntennas));
%         IN = 10*log10(signalPower(INTERFERENCE)/signalPower(N(:,1)))
        X = Z+N;

        %W

        R = correlationMatrix(permute(X, [2 1]));
%         R = corrcoef(X);
        
        [V, D] = eig(R);
        [~, index] = min(abs(diag(D)));
        W = V(:, index);
        YZ = Z*W;
        YN = N*W;


        noisePower = signalPower(YN);
        out(iSimulation, iValue) = 10*log10((signalPower(YZ)+noisePower)/noisePower);
    end
end
result = mean(out, 1);
plot(nSamplesValues, result);
grid on