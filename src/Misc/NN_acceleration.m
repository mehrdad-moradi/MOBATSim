function [Y,Xf,Af] = NN_acceleration(X,~,~)
%NN_ACCELERATION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 06-Mar-2019 14:51:05.
% 
% [Y] = NN_acceleration(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = 2xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 1xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [0;1.00182819318876];
x1_step1.gain = [0.0869644830210879;0.0740790900328825];
x1_step1.ymin = -1;

% Layer 1
b1 = [-9.0443677953660071;-6.2492551551083029;-18.227467326440816;1.7184064751941237;7.6378306740116457];
IW1_1 = [-1.8070473299181711 -8.7697471966803775;9.3635775382569584 -2.4739862655616713;-18.28855845108485 -22.292425671424947;0.67755052486848522 -10.254704382435524;16.297936430836742 -3.5738816319865694];

% Layer 2
b2 = -7.58209787181279;
LW2_1 = [-5.2769728930121342 -1.3465118194900134 6.1771977681980834 -5.8645197160924214 0.51236149538725884];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 5.09268411295854;
y1_step1.xoffset = 0.00121917889387027;

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX, X = {X}; end;

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
  Q = size(X{1},2); % samples/series
else
  Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS

    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = tansig_apply(repmat(b2,1,Q) + LW2_1*a1);
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
end

% Final Delay States
Xf = cell(1,0);
Af = cell(2,0);

% Format Output Arguments
if ~isCellX, Y = cell2mat(Y); end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
  y = bsxfun(@minus,x,settings.xoffset);
  y = bsxfun(@times,y,settings.gain);
  y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
  x = bsxfun(@minus,y,settings.ymin);
  x = bsxfun(@rdivide,x,settings.gain);
  x = bsxfun(@plus,x,settings.xoffset);
end
