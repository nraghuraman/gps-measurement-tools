function PlotAdrResids(adrResid,gnssMeas,prFileName,colors)
% PlotAdrResids(adrResid,gnssMeas,[prFileName],[colors])
% plot the Accumulated Delta Range residuals for the 5 sats with most valid adr
%
% adrResid.FctSeconds = Nx1 time vector, same as gnssMeas.FctSeconds
%         .Svid0      = reference satellite for single differences
%         .Svid       = 1xM vector of all svid
%         .ResidM     = [NxM] adr residuals (adr = -k*carrier) 
%
% gnssMeas, the measurements (from ProcessGnssMeas) used to get adrResids
%
% Optional inputs: prFileName = string with file name
%                  colors, Mx3 color matrix
%                  if colors is not Mx3, it will be ignored

%Author: Frank van Diggelen
%Open Source code for processing Android GNSS Measurements

% Just look at all of the satellites
K = size(adrResid.Svid, 2); %number of satellites to plot 
if isempty(adrResid) || ~any(any(isfinite(adrResid.ResidM))) %Nothing but NaNs
    fprintf(' No adr residuals to plot\n'), return
end
if nargin<2
    prFileName = '';
end

M = length(adrResid.Svid);
N = length(adrResid.FctSeconds);
if nargin<3 || any(size(colors)~=[M,3])
    bGotColors = false;
else
    bGotColors = true;
end

timeSeconds =adrResid.FctSeconds-adrResid.FctSeconds(1);%elapsed time in seconds

% find the K sats with most data
numValid = zeros(1,M);
for j=1:M
    numValid(j) = sum(isfinite(adrResid.ResidM(:,j)));
end
[~,jSorted] = sort(numValid,'descend');
hK=zeros(1,K); %initialize plot handle
cycle_slip_info=zeros(K, 3);
for k=1:K
   hK(k) = subplot(K,1,k);
   jSv = jSorted(k); %index into correct adrResid.Svid, and columns of .ResidM
   svid = adrResid.Svid(jSv); 
   cycle_slip_info(k, 1)=svid;
   h = plot(timeSeconds,adrResid.ResidM(:,jSv)); grid on, hold on
   j = find(gnssMeas.Svid == svid); %index into gnssMeas columns
   if bGotColors
       set(h,'Color',colors(j,:));
   end
   %get cycle slip flags
   %From gps.h:
    % #define GPS_ADR_STATE_CYCLE_SLIP                (1<<2)
   % Note that the number of cycle slips is not affected by anything that
   % we did in GpsAdrResiduals.m.
   iCs = find(bitand(gnssMeas.AdrState(:,j),2^2));
   numCs = length(iCs);
   if numCs
       h=plot(timeSeconds(iCs),zeros(numCs,1),'xk');
       set(h,'MarkerSize',5)
   end
   cycle_slip_info(k, 2)=numCs;
   cycle_slip_info(k, 3)=numCs/timeSeconds(end);
   ts=sprintf('Svids %d - %d',svid,adrResid.Svid0);
   title(ts)
   ylabel('(meters)');
end
disp("Cycle slip info: first col is svid, second is # cycle slips, third is # cycle slips/second");
disp("Sorted in order of amount of data for a particular satellite");
disp("Note that Matlab may factor out 1e3 or another factor, in which case");
disp("You'd need to multiply every value by that factored-out value");
disp(cycle_slip_info);
xs = sprintf('time (seconds)\n%s',prFileName);
xlabel(xs,'Interpreter','none')
linkaxes(hK,'x');

subplot(K,1,1)
svid = adrResid.Svid(jSorted(1)); % Might have to change this
ts=sprintf('ADR single difference residuals. No iono or tropo correction. Svids %d - %d',...
    svid,adrResid.Svid0);
title(ts)
ax=axis;
ht=text(ax(1),ax(3),' ''x'' = declared cycle slip');
set(ht,'VerticalAlignment','bottom','FontSize',8);

end %end of function PlotAdrResids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Copyright 2016 Google Inc.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
