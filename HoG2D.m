
% program to Implement the Helmholtz of Gaussian filter in 2D
% sd - standard deviation, is the full width half maximum of the gaussian function 
% knlsize - filter size 
% l = 1/k, where k = wavenumber
% filt - Helmholtz of Gaussian filter in 2D
function filt = HoG2D(sd,l,knlsize)
k=1/l;
ksq = k*k;
if (round(knlsize/2)*2 == knlsize)
knlsize = knlsize + 1;
end
p2=[];
siz(1) = (knlsize-1)/2;
siz(2) = (knlsize-1)/2;
p2(1) = knlsize;
p2(2) = knlsize;

std2 = sd*sd;
 
     [x,y] = meshgrid(-siz(2):siz(2),-siz(1):siz(1));
     arg   = -(x.*x + y.*y)/(2*std2);
     
     %arg_exp     = exp(arg);
     h = exp(arg);
     h(h<eps*max(h(:))) = 0;

     sumh = sum(h(:));
     if sumh ~= 0,
        h  = h/sumh;
     end;
  
     % now calculate Laplacian     
     h1 = h.*(x.*x + y.*y - 2*std2)/(std2^2);
     
     
     %delx =(x.*x + y.*y);
     %const_term = (ksq*delx/(sd*sqrt(2*pi)));
     const_term  = ksq;
     feed =  h.*const_term;
     filt = h1 -feed;
  filt  = filt - sum(filt(:))/prod(p2); % make the filter sum to zero

  
%   ppos = find(filt > 0);
% pneg = find(filt < 0);
% pos = sum(filt(ppos));
% neg = abs(sum(filt(pneg)));
% meansum = (pos+neg)/2;
% 
%  pos = pos / meansum;
%  neg = neg / meansum;
%     
%   filt(pneg) = pos*filt(pneg); filt(ppos) = neg*filt(ppos); 

