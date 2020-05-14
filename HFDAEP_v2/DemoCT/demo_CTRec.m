clear;
getd = @(p)path(path,p);% Add some directories to the path
getd('./quality_assess\');
getd('./model/');
getd('./ultilies/');
getd('../');
tic
for ImgNo = 1:2
switch ImgNo
    case 1
        imageName = 'abdominal';
    case 2
        imageName = 'thoracic';
end
load(strcat('Test_Images/', imageName, '.mat'));
[rows, cols] = size(original_image);

% load the system matrix
img_size = rows;
for pro_views = [48,64,80]

bins = 512;
switch pro_views
    case 48 
        load proMatrix_48_256
    case 64
        load SysMat_ImgSize_256_Views_64_Bins_512
    case 80
        load proMatrix_80_256
end
params.proj = SystemMatrix * original_image(:);

% load the filter
filter_size = 10;
filter_num = 32;
filter_lambda = 0.005;
filter = strcat('mayo_filtersize_',num2str(filter_size), ...
    '_num_',num2str(filter_num),...
    '_lambda_',num2str(filter_lambda));
load(strcat('Filter/',filter,'.mat'));

% params of pwls
params.beta = 0.005;
params.pwls_iter = 20;
pwls = zeros(size(original_image));
reconstruction = zeros(size(original_image));

% params of cscgr
lambda = 0.005;
rho = 100 * lambda + 1;
tau = 0.06;
params.iter = 2500;

% create folder to save the results
filename = strcat(num2str(pro_views),'_alpha_',num2str(params.beta),'_lambda_',num2str(lambda),'_rho_',num2str(rho),'_mu_',num2str(tau));
path = strcat('Result\',filter,'\',imageName,'\',filename);
if ~exist(path,'dir')
    mkdir(path);
end

% the file used to record the psnrs
if exist(strcat(path,'\result.txt'),'file')
    delete(strcat(path,'\result.txt'));
end
params.result = fopen(strcat(path,'\result.txt'),'a+');

% save filter
save(strcat(path,'\',filter,'.mat'),'D');
pre_pwls = zeros(size(original_image));
params.gradient_beta = 1;
maxvalue_exchange = 255/max(original_image(:));

use_gpu = 1;   % set to 0 if you want to run on CPU (very slow)
%% step4 #######%%%%% run EDAEPRec %%%%
% load network for solver
params.net = loadNet_DFRP([rows,cols,3], use_gpu);%%%%%%%%%%   model
% run EDAEPRec
params.sigma_net = 9;   %%%%%%%%%%%%%%%%%%%%%%%   noise_level

[reconstruction,pwls,psnr_psnr] = CTRec_DFRP(original_image, reconstruction, SystemMatrix, maxvalue_exchange,pre_pwls,params);
toc
fclose('all');

% show the results
switch ImgNo
    case 1
        disp_win = [850/3000 1250/3000];
    case 2
        disp_win = [0/3000 1250/3000];
end

figure;
subplot(1, 3, 1);
imshow(original_image, disp_win, 'border', 'tight');
subplot(1, 3, 2);
imshow(pwls,disp_win, 'border', 'tight');
subplot(1, 3, 3);
imshow(reconstruction,disp_win, 'border', 'tight');

path1 = strcat(path, '/', pro_views, '_pwls_psnr_', num2str(psnr(original_image, pwls)),'_pwls_ssim_',num2str(cal_ssim(original_image, pwls,0,0)));
save(strcat('./DRFP_result/DRFP_',imageName,'_',num2str(pro_views),'_image'),'pwls');
path2 = strcat(path, '/',pro_views, '_csc_psnr_', num2str(psnr(original_image, reconstruction)),'_csc_ssim_',num2str(cal_ssim(original_image, reconstruction,0,0)));
save(strcat(path,'/',filter,'.mat'),'D');
save(strcat(path1, '.mat'), 'pwls');
save(strcat(path2, '.mat'), 'reconstruction');
save(strcat('./DRFP_result/DRFP_',imageName,'_',num2str(pro_views),'_psnr'),'psnr_psnr')
disp('End of PWLS-CSCGR');
clear psnr_psnr;
end
end