%
% Deconvolve 30 Sec Sweep
%

clear all
close all

% Import original sweep audio
fs = 48000;
x = kroneckerDelta(1, 1, fs);

% [G,Fs] = audioread('[putfilenamehere]');
G = x;
G = flipud(G(:,1));

% Start and stop frequencies of the sweep:
f1 = 22;
f2 = 22000;

% Read in the RECORDING

H = audioread('AudioSamples/SilverVerb_IR.wav');
H = H(:,1);

% An amplitude envelope is then applied, to compensate for higher levels of
% energy generated at lower frequencies. This step is important!
% The envelope reduces the amplitude by 6 dB for every octave

env_linspace=linspace(0,(-6*(log(f2/f1)./log(2))),length(G));

env_log=10.^(env_linspace./20);

G=G.*env_log';

G = [G;zeros(length(H)-length(G),1)];

RIR = ifft(fft(H).*fft(G));

RIR = RIR./max(abs(RIR+0.0001));

figure(1)
plot(RIR)
xlabel('Time (Samples)')
ylabel('Amplitude (Normalised)')

figure(2)
plot(linspace(0,44100,length(RIR)),20*log10(abs(fft(RIR))));
xlabel('Frequency (Hz)')
ylabel('Magnitude (dBFS)')





