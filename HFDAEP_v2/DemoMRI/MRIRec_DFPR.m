function [map,psnr_psnr,ssim_ssim ,psnr_hfen] = MRIRec_DFPR(Im, degraded, mask, sigma_d, params)
% Implements stochastic gradient descent (SGD) maximum-a-posteriori for image deblurring described in:
% S. A. Bigdeli, M. Zwicker, "Image Restoration using Autoencoding Priors".
%实现图像去模糊的随机梯度下降的最大后验
%
% Input:
% degraded: Observed degraded RGB input image in range of [0, 255].
% kernel: Blur kernel (internally flipped for convolution).
% sigma_d: Noise standard deviation.
% params: Set of parameters.
% params.net: The DAE Network object loaded from MatCaffe.
%
% Optional parameters:
% params.sigma_net: The standard deviation of the network training noise. default: 25
% params.num_iter: Specifies number of iterations.
% params.gamma: Indicates the relative weight between the data term and the prior. default: 6.875
% params.mu: The momentum for SGD optimization. default: 0.9
% params.alpha the step length in SGD optimization. default: 0.1
%
%
% Outputs:
% map: Solution.


% if ~any(strcmp('net1',fieldnames(params)))
%     error('Need a DAE network in params.net!');
% end

if ~any(strcmp('sigma_net',fieldnames(params)))
    params.sigma_net1 = 20; params2.sigma_net = 20;
end

if ~any(strcmp('num_iter',fieldnames(params)))
    params.num_iter = 400;params2.num_iter = 400;
end

if ~any(strcmp('gamma',fieldnames(params)))
    params.gamma = 6.875; params2.gamma = 6.875;
end

if ~any(strcmp('mu',fieldnames(params)))
    params.mu = .9; params2.mu = .9;
end

if ~any(strcmp('alpha',fieldnames(params)))
    params.alpha = .1; params2.alpha = .1;
end


disp(params)

params.gamma = params.gamma * 4; params2.gamma = params2.gamma * 4;
pad = [0, 0];
map = padarray(Im, pad, 'replicate', 'both');

% sigma_eta = sqrt(2) * params.sigma_net;
% relative_weight = params.gamma/(sigma_eta^2)/(params.gamma/(sigma_eta^2) + 1/(sigma_d^2));

step = zeros(size(map));

if any(strcmp('gt',fieldnames(params)))
    psnr = computePSNR(abs(params.gt), abs(map), pad);
    disp(['Initialized with PSNR: ' num2str(psnr)]);
end
psnr_psnr = zeros(params.num_iter,1);
ssim_ssim = zeros(params.num_iter,1);
psnr_hfen = zeros(params.num_iter,1);
rec_con = zeros([size(map),6]);
for iter = 1:params.num_iter
    if any(strcmp('gt',fieldnames(params)))   disp(['Running iteration: ' num2str(iter)]);    tic();   end
    prior_err_sum = zeros(size(repmat(map,1,1,3)));
    repeat_num = 3;  %3;   %8;  %1; %12;
    for iiii = 1:repeat_num
        % compute prior gradient 1
        
        npd = 1 ; fltlmbd = 1000; [slr_image1, shr_image1] = lowpass(real(map), fltlmbd, npd); labels(:,:,1) = shr_image1;
        npd = 1 ; fltlmbd = 200; [slr_image2, shr_image2] = lowpass(real(map), fltlmbd, npd); labels(:,:,3) = shr_image2;
        npd = 1 ; fltlmbd = 50; [slr_image3, shr_image3] = lowpass(real(map), fltlmbd, npd); labels(:,:,5) = shr_image3;

        npd = 1 ; fltlmbd = 1000; [sli_image1, shi_image1] = lowpass(imag(map), fltlmbd, npd); labels(:,:,2) = shi_image1;
        npd = 1 ; fltlmbd = 200; [sli_image2, shi_image2] = lowpass(imag(map), fltlmbd, npd); labels(:,:,4) = shi_image2;
        npd = 1 ; fltlmbd = 50; [sli_image3, shi_image3] = lowpass(imag(map), fltlmbd, npd); labels(:,:,6) = shi_image3;
        noise = randn(size(labels)) * params.sigma_net1;
        rec = params.net1.forward({labels+noise}); 
        rec_con(:,:,1:2) = rec{1,1};rec_con(:,:,3:4) = rec{2,1};rec_con(:,:,5:6) = rec{3,1}; %%%%%%%%%%%%%%元胞数组，输出看一下结构
        prior_err = labels - rec_con;
        rec = params.net1.backward({-prior_err(:,:,1:2),-prior_err(:,:,3:4),-prior_err(:,:,5:6)});  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        prior_err = prior_err + rec{1}; %%%%%%%%%%%%%%%
        prior_err1 = prior_err;  %%%%%%%%%%%%%%%%
        
        prior_err_sum = prior_err_sum + cat(3,prior_err1(:,:,1)+sqrt(-1)*prior_err1(:,:,2),prior_err1(:,:,3)+sqrt(-1)*prior_err1(:,:,4),prior_err1(:,:,5)+sqrt(-1)*prior_err1(:,:,6));
    end
    
    prior_err = prior_err_sum/repeat_num;
    
    % sum the gradients
    err = prior_err;  
    err = mean(err,3);
    % update
    step = params.mu * step - params.alpha * err;
    map = map + step;
    
    temp_FFT = fft2(map);
    temp_FFT(mask==1) = degraded(mask==1);  %
    map = ifft2(temp_FFT);
    %if mod(iter,10)==0, figure(200+iter);imshow([abs(map)],[]);end
    
    if any(strcmp('gt',fieldnames(params)))
        psnr = computePSNR(abs(params.gt), abs(map), pad);
        disp(['PSNR is: ' num2str(psnr) ', iteration finished in ' num2str(toc()) ' seconds']);
        [psnr4, ssim4, fsim4, ergas4, sam4] = MSIQA(abs(params.gt), abs(map));
        hfen4 = norm(imfilter(abs(params.gt/255),fspecial('log',15,1.5)) - imfilter(abs(map/255),fspecial('log',15,1.5)),'fro');
        psnr_psnr(iter,1)=psnr4;
        ssim_ssim(iter,1)=ssim4;
        psnr_hfen(iter,1)  = hfen4;
    end
    
end
