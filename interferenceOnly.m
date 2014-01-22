%Gaussian interference
nAntennas = 2;
nSamples = 10000;
interferenceToNoiseRatioDb = 20;
nSimulations = 10000;
interferenceToNoiseRatio = 10^(interferenceToNoiseRatioDb/10);
nEstimationSamplesValues = [2 4 6 8 10];
% nEstimationSamplesValues = 10;
tic
out = zeros(nSimulations, 5);


noiseCoefficient = 1/(sqrt(2*interferenceToNoiseRatio));
sqrt2 = sqrt(2);

for iValue=1:size(nEstimationSamplesValues,2)
    nEstimationSamples = nEstimationSamplesValues(iValue);
%     nEstimationSamples = 4;
    for iSimulation = 1:nSimulations
        INTERFERENCE = (randn(nSamples, 1) + 1i*randn(nSamples, 1))/sqrt2;
    %     INTERFERENCE = zeros(nSamples, 1);
%         channelCoefficients = (randn(1, nAntennas) + 1i*randn(1, nAntennas))/(5*sqrt(2));
        channelCoefficients = (randn(1, nAntennas) + 1i*randn(1, nAntennas));
        channelCoefficients = [1, 1i];
        channelCoefficients = channelCoefficients/(sqrt(sum(abs(channelCoefficients).^2)));
        Z = bsxfun(@times, channelCoefficients, INTERFERENCE);

        N = noiseCoefficient*(randn(nSamples, nAntennas) + 1i*randn(nSamples, nAntennas));
%         N = zeros(size(N));
%         IN = 10*log10(signalPower(INTERFERENCE)/signalPower(N(:,1)))
        X = Z+N;

        %W

        R = correlationMatrix(permute(X(1:nEstimationSamples,:), [2 1]));
%         R = corrcoef(X);
        
        [V, D] = eig(R);
        [~, index] = max(abs(diag(D)));
        W = V(:, index);
%         W(2) = -W(2);
        YZ = Z*W;
%         signalPower(YZ)
        YN = N*W;
%         YZ = Z;
%         YN = N;


        noisePower = signalPower(YN);
        out(iSimulation, iValue) = 10*log10(signalPower(YZ)/noisePower+1);
    end
end
toc
result = mean(out, 1);
plot(nEstimationSamplesValues, result);
grid on