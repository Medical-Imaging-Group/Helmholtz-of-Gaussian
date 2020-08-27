
clc;
clear all;
close all;

% make sure value=1 and values are 
Im = zeros(400,400);
c1 = 200;c2 = 200;radius = 30;
Imedge = drawOvalFrame(Im, [c1-radius c2-radius c1+radius c2+radius],255,1);
figure;imshow(Imedge);title('true edge image');
Im(:,:) = 0;
value =1;

choice =3;
switch choice
    case 1
        %PSNR value = 40dB
        v=0.004;
        
    case 2
        %PSNR value = 30
        v= 0.1;
    case 3
        %PSNR value = 22
        v= 1;
        
end

%%  modelled image 
xc = 200;
yc = 200;
xc = int16(xc);
yc = int16(yc);

%radius = 10;
x = int16(0);
y = int16(radius);
d = int16(1 - radius);

Im(xc, yc+y) = value;
Im(xc, yc-y) = value;
Im(xc+y, yc) = value;
Im(xc-y, yc) = value;

while ( x < y - 1 )
    x = x + 1;
    if ( d < 0 ) 
        d = d + x + x + 1;
    else 
        y = y - 1;
        a = x - y + 1;
        d = d + a + a;
    end
  Im( -x+xc:x+xc, -y+yc:y+yc) = value;
  Im( -y+xc:y+xc, -x+yc:x+yc) = value;
    end 

 
Imorg = Im;
clear Im;
%% calculating the PSNR value
Im= imnoise(Imorg,'speckle',v);
M = size(Im);
PSNR_VAL = psnr(Imorg,Im,M(1),M(2))

figure;imshow(Im);title('Noisy image');

%% setting the parameters 
%sigma = 2;filtsize = 91;
%sigma = 2;filtsize = ceil(sigma*3)*2+1; 
sigma =2;filtsize = ceil(sigma*3)*2+1; 
%filtsize = filtsize*6;



N = filtsize;
hlap = fspecial('log', [N N],sigma);  
[BW3 thresh] = edge(Im,'zerocross',[],hlap);

%BWCanny= edge(Imorg,'canny',thresh,sigma);
BWCannyshow = edge(Im,'canny',thresh,sigma);
figure;imshow(BWCannyshow);title('Canny')

LoGfilt =LoG_2D(sigma,filtsize*6);

BW4 = edge(Im,'zerocross',thresh,LoGfilt);
figure;imshow(BW4);title('LoG')


% [HoGfiltnew k]= HoG2D_new(sigma,filtsize*10)
% BW5 = edge(Im,'zerocross',thresh,HoGfiltnew);
% figure ; imshow(BW5);
% title('HoG NEW Output');


corr_len =  sigma/2;
HoGfilt =HoG2D(sigma,corr_len,filtsize*6);
BW5 = edge(Im,'zerocross',thresh,HoGfilt);
figure;imshow(BW5);title('HoG')


HoGfilt_max = max(max(HoGfilt));
HoGfilt_min = min(min(HoGfilt));
HoGfilt_diff = HoGfilt_max - HoGfilt_min ;

%% Performance 

%1) number of edge pixels (edgels) correctly detected as `true positives': N(TP) = Sum(pixels){D .AND. G};
%2) number of edge pixels (edgels) incorrectly detected as `false positives': N(FP) = Sum(pixels){D .AND. G'}, where G' is the complement of G (ie. .NOT. G);
%3) total number of edge pixels, N(E) = Sum(pixels){G},
%4) total number of background pixels, N(B) = Sum(pixels){G'}
% for HoG Performance
tot_no_pix = size(Im);
%tot_no_pix size of the image
total_pixels = tot_no_pix(1)*tot_no_pix(2);
%canny edgels

edgels = find(Imedge);
NE = size(edgels);
num_bck = total_pixels - NE(1);

%% HoG performance
%true postives 
TP_HoG = and(Imedge,BW5);
HoG_edgels = find(TP_HoG);
NTP_HoG = size(HoG_edgels);
%false positives
%HoG_not = not(BW5);
FP_HoG = Imedge-BW5; 
FP_HoG_edgels = find(FP_HoG);
NFP_HoG = size(FP_HoG_edgels);

%Prob(True Postives) = N(TP)/N(E)
ProbTruePos_HoG = NTP_HoG(1)/NE(1)

%pixels detected as belonging to an edge being incorrect: P(FP) = N(FP)/N(B)
ProbFalsePos_HoG = NFP_HoG(1)/num_bck
%% LoG performance
%true postives for LoG
TP_LoG = and(Imedge,BW4); %figure;imshow(TP_LoG);title('LoG true positives');
LoG_edgels = find(TP_LoG);
NTP_LoG = size(LoG_edgels);
%false positives
%LoG_not = not(BW4);
%FP_LoG = and(BWCanny,LoG_not);% figure;imshow(NFP_LoG);title('NFPLoG');
FP_LoG = Imedge-BW4;
FP_LoG_edgels = find(FP_LoG);
NFP_LoG = size(FP_LoG_edgels);

%Prob(True Postives) = N(TP)/N(E)
ProbTruePos_LoG = NTP_LoG(1)/NE(1)

%pixels detected as belonging to an edge being incorrect: P(FP) = N(FP)/N(B)
ProbFalsePos_LoG = NFP_LoG(1)/num_bck


%% Cannyshow
%true postives 
TP_Canny = and(Imedge,BWCannyshow); %figure;imshow(TP_HoG);title('HoG true positives');
canny_edgels = find(TP_Canny);
NTP_Canny = size(canny_edgels);
%false positives
%Canny_not = not(BWCannyshow);
%FP_Canny = and(BWCanny,Canny_not); %figure;imshow(NFP_HoG);title('HoG false positives');
FP_Canny = Imedge - BWCannyshow;
FP_Canny_edgels = find(FP_Canny);
NFP_Canny= size(FP_Canny_edgels);

%Prob(True Postives) = N(TP)/N(E)
ProbTruePos_Canny = NTP_Canny(1)/NE(1)

%pixels detected as belonging to an edge being incorrect: P(FP) = N(FP)/N(B)
ProbFalsePos_Canny = NFP_Canny(1)/num_bck

%% corr coefficients

corr_LoG = corr2(Imedge,BW4)
corr_HoG = corr2(Imedge,BW5)
corr_Canny = corr2(Imedge,BWCannyshow)


EVAL = Evaluate(BW5(:),Imedge(:))
EVAL = Evaluate(BW4(:),Imedge(:))

EVAL = Evaluate(BWCanny(:),Imedge(:))






