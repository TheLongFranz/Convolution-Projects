%% Script Initialisation
% Reset the project to default state
clear;clc;close
% Add the dependencies to the project path relative to the project folder
addpath('Functions')
addpath('AudioSamples')

[x1, fs] = audioread("AudioSamples/Gunshot Short.wav"); % MP5 gunshot sample
% The MP5 has a rate of fire of
x2proto = kroneckerDelta(2, .05, fs); % Rate of fire
x2 = [x2proto; x2proto]                      % burst (if applicable)
x2 = [x2; x2; x2; x2;]              % Length of shooting

[x1Mid, x1Side] = midSideEncode(x1);
x1Mid = 10^(-3/20)*(x1Mid/max(abs(x1Mid))); % Normalise Gain
[x2Mid, x2Side] = midSideEncode(x2);
x2Mid = 10^(-3/20)*(x2Mid/max(abs(x2Mid))); % Normalise Gain

%% Processing
y = conv(x1Mid, x2Mid, 'full');

%% Gain Matching (Peak normalisation = valueIndB * x/max(abs(x)))
y = 10^(-3/20)*(y/max(abs(y)));

maxX = 20*log10(max(abs(x2Mid/1)));
maxY = 20*log10(max(abs(y/1)));
%% Playback
sound(y, fs)

