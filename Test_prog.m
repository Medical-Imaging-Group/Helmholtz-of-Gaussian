
% program to Test the perfomance of the LoG and HoG kernel using real
% images 
% filename - the desired image to be tested 
% corr_LoG, ProbTruePos_LoG, ProbFalsePos_LoG
% corr_HoG, ProbTruePos_HoG, ProbFalsePos_HoG



clc
clear all;
close all;



Im = imread('IM1.tif');

figure; imshow((Im));

tot_no_pix = size(Im);
 %kernel Parameters
sigma =1;filtsize = ceil(sigma*3)*2+1

N=filtsize;
hlog = fspecial('log', [N N],sigma); 


[BW3 thresh] = edge(Im,'zerocross',[],hlog);
%LOG constructed 
LoGfilt =LoG_2D(sigma,N);
BW4 = edge(Im,'zerocross',thresh,LoGfilt);
figure;imshow(BW4);
title('LoG Output');
%HOG constructed 

corr_len=sigma/2;
HoGfilt =HoG2D(sigma,corr_len,filtsize);
BW5 = edge(Im,'zerocross',thresh,HoGfilt);
figure ; imshow(BW5);
title('HoG Output');




BWLoG = conv2(double(Im),LoGfilt);
figure;imshow(BWLoG,[]);title('BWLoG');

BWHoG = conv2(double(Im),HoGfilt);
figure;imshow(BWHoG,[]);title('BWHoG');


figure;n= 87
plot(Im(:,n),'c'); hold on ;
plot(BWLoG(:,n),'b-.');
hold on ;plot(BWHoG(:,n),'m--');
legend('ORG','LoG','HoG')
xlim([0 515])


BWCanny = edge(Im,'canny',thresh,sigma);
figure ; imshow(BWCanny);
title('Canny Output');

%% Performance 

%1) number of edge pixels (edgels) correctly detected as `true positives': N(TP) = Sum(pixels){D .AND. G};
%2) number of edge pixels (edgels) incorrectly detected as `false positives': N(FP) = Sum(pixels){D .AND. G'}, where G' is the complement of G (ie. .NOT. G);
%3) total number of edge pixels, N(E) = Sum(pixels){G},
%4) total number of background pixels, N(B) = Sum(pixels){G'}
% for HoG Performance

%tot_no_pix size of the image
total_pixels = tot_no_pix(1)*tot_no_pix(2);
%canny edgels
canny_edgels = find(BWCanny);
NE = size(canny_edgels);
num_bck = total_pixels - NE(1);


%true postives 
TP_HoG = and(BWCanny,BW5); %figure;imshow(TP_HoG);title('HoG true positives');
HoG_edgels = find(TP_HoG);
NTP_HoG = size(HoG_edgels);
%false positives
HoG_not = not(BW5);
FP_HoG = and(BWCanny,HoG_not); %figure;imshow(NFP_HoG);title('HoG false positives');
FP_HoG_edgels = find(FP_HoG);
NFP_HoG = size(FP_HoG_edgels);

%Prob(True Postives) = N(TP)/N(E)
ProbTruePos_HoG = NTP_HoG(1)/NE(1)

%pixels detected as belonging to an edge being incorrect: P(FP) = N(FP)/N(B)
ProbFalsePos_HoG = NFP_HoG(1)/num_bck

%true postives for LoG
TP_LoG = and(BWCanny,BW4); %figure;imshow(TP_LoG);title('LoG true positives');
LoG_edgels = find(TP_LoG);
NTP_LoG = size(LoG_edgels);
%false positives
LoG_not = not(BW4);
FP_LoG = and(BWCanny,LoG_not);% figure;imshow(NFP_LoG);title('NFPLoG');
FP_LoG_edgels = find(FP_LoG);
NFP_LoG = size(FP_LoG_edgels);

%Prob(True Postives) = N(TP)/N(E)
ProbTruePos_LoG = NTP_LoG(1)/NE(1)

%pixels detected as belonging to an edge being incorrect: P(FP) = N(FP)/N(B)
ProbFalsePos_LoG = NFP_LoG(1)/num_bck


corr_LoG = corr2(BWCanny,BW4)
corr_HoG = corr2(BWCanny,BW5)


