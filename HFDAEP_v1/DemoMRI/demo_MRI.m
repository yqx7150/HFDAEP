clear;
getd = @(p)path(path,p);% Add some directories to the path
getd('./需要比较的图片和mask\');
getd('./需要比较的图片和mask_015\');
getd('./quality_assess\');
getd('./model/');
getd('./ultilies/');
getd('../');
getd('../demo_multihighfreq/');

% set to 0 if you want to run on CPU (very slow)
use_gpu = 1;

for ii = 1:1
    switch ii
        case 1
           load mask_radial90;
           mask = eval('mask_radial90');
           mask_name = '_radial_90';
        case 2
            load mask_radial80;
            mask = eval('mask_radial80');
            mask_name = '_radial_80';
        case 3
            load mask_radial75;
            mask = eval('mask_radial75');
            mask_name = '_radial_75';
        case 4
            load mask_radial70;
            mask = eval('mask_radial70');
            mask_name = '_radial_70';
        case 5
            load mask_random015;
            mask = eval('mask_random015');
            mask_name = 'random_85';
        case 6
            load mask_cart85;
            mask = eval('mask_cart85');
            mask_name = 'cart_85';
        case 7
            load mask_radial85;
            mask = eval('mask_radial85');
            mask_name = 'radial_85';
        case 8
            load mask_random_25;
            %mask = eval('mask_radial85');
            mask_name = 'mask_random_25';
        case 9
            load mask_random_90;
           % mask = eval('mask_radial85');
            mask_name = 'mask_random_90';
    end
n = size(mask,2);
fprintf(1, 'n=%d, k=%d, Unsamped=%f\n', n, sum(sum(mask)),1-sum(sum(mask))/n/n); %
for i = 1:31
    Imgpath = ['test_data_' num2str(i,'%02d') '.mat'];
    savepath = ['test_data_' num2str(i,'%02d')];
    test_save = ['test_data_' num2str(i, '%02d')];
    load (Imgpath);
gt = 255*Img./max(abs(Img(:)));

%% step3 #######%%%%% generate K-data %%%%
sigma_d = 0 * 255;
noise = randn(size(gt));
degraded = mask.*(fft2(gt) + noise * sigma_d + (0+1i)*noise * sigma_d); %
Im = ifft2(degraded); 
% figure(335);imshow(abs(Im),[]);

%% step4 #######%%%%% run EDAEPRec %%%%
% load network for solver
params.net1 = loadNet([size(gt),3], use_gpu);%%%%%%%%%%   model
params.gt = gt;

% run EDAEPRec
params.sigma_net1 = 25;   %%%%%%%%%%%%%%%%%%%%%%%   noise_level
params.num_iter = 400;
[map_Rec,psnr_psnr,ssim_ssim,psnr_hfen] = MRIRec(Im, degraded, mask, sigma_d, params);

[psnr4, ssim4, fsim4, ergas4, sam4] = MSIQA(abs(gt), abs(map_Rec));
hfen4 = norm(imfilter(abs(gt/255),fspecial('log',15,1.5)) - imfilter(abs(map_Rec/255),fspecial('log',15,1.5)),'fro');
[psnr4, ssim4, hfen4,fsim4, ergas4, sam4]
save(['./result_1sigma_25_L1000_800_400_50/' test_save mask_name '_1'],'psnr4','psnr_psnr','ssim_ssim','psnr_hfen','map_Rec');
end
end

%% step5 #######%%%%% display Recon result %%%%
% figure(666);
% subplot(2,3,[4,5,6]);imshow([abs(Im-gt)/255,abs(map_Rec-gt)/255],[]); title('Recon-error');colormap(jet);colorbar;
% subplot(2,3,1);imshow(abs(gt)/255); title('Ground-truth');colormap(gray);
% subplot(2,3,2);imshow(abs(Im)/255); title('Zero-filled');colormap(gray);
% subplot(2,3,3);imshow(abs(map_Rec)/255); title('Net-recon');colormap(gray);
% figure(667);imshow([real(gt)/255,imag(gt)/255,abs(gt)/255],[]); 
% figure(668);imshow([abs(Im-gt)/255,abs(map_Rec-gt)/255],[]); colormap(jet);colorbar;

