
% program to Implement the Laplacian of Gaussian filter in 2D
% sd - standard deviation, is the full width half maximum of the gaussian function 
% knlsize - filter size 
% h1 - Laplacian of Gaussian filter in 2D
function h1 = LoG_2D(sd,knlsize)
 

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
     
     h     = exp(arg);
   

     h(h<eps*max(h(:))) = 0;

     sumh = sum(h(:));
     if sumh ~= 0,
        h  = h/sumh;
     end;

     % now calculate Laplacian     
     h1 = h.*(x.*x + y.*y - 2*std2)/(std2^2);
h   = h1 - sum(h1(:))/prod(p2); % make the filter sum to zero

     

% ppos = find(h1 > 0);
% pneg = find(h1 < 0);
% pos = sum(h1(ppos));
% neg = abs(sum(h1(pneg)));
% meansum = (pos+neg)/2;
% 
%  pos = pos / meansum;
%  neg = neg / meansum;
%     
%     h1(pneg) = pos*h1(pneg); h1(ppos) = neg*h1(ppos); 
