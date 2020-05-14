function [reconstruction,pwls,psnr_psnr] = CTRec_DFRP(original_image, reconstruction, SystemMatrix, maxvalue_exchange,pre_pwls,params)
for i = 1 : params.iter
    % pwls reconstruction
    if i < 40 % a little trick to accelerate the convergence
        pwls = split_hscg(reconstruction, params.proj, reconstruction, SystemMatrix, params.beta, params.pwls_iter);
    else
        pwls = split_hscg(pwls, params.proj, reconstruction, SystemMatrix, params.beta, params.pwls_iter);
    end
    pwls(pwls<0) = 0;
    fprintf('iter:%d, pwls = %f,', i, psnr(original_image,pwls));
    fprintf(params.result, 'iter:%d, pwls = %f,', i, psnr(original_image,pwls));
    psnr_num = psnr(original_image,pwls);
    psnr_psnr(i,1)=psnr_num;
    
    %% descent gradient of REDAEP
    uub_tmp = pwls * maxvalue_exchange ;
    prior_err_sum = zeros(size(repmat(uub_tmp,1,1,3)));
    rec_con = zeros(size(prior_err_sum));
    repeat_num = 3;
    for iiii = 1:repeat_num
        % compute prior gradient 1
        npd = 1; fltlmbd = 1000;   [sl_image1_real, sh_image1_real] = lowpass(uub_tmp, fltlmbd, npd);  input1 = repmat(sh_image1_real,1,1,3);
        npd = 1; fltlmbd = 200;   [sl_image2_real, sh_image2_real] = lowpass(uub_tmp, fltlmbd, npd);  input1(:,:,2) = sh_image2_real;
        npd = 1; fltlmbd = 50;   [sl_image3_real, sh_image3_real] = lowpass(uub_tmp, fltlmbd, npd);  input1(:,:,3) = sh_image3_real;
        %%%%%
        noise = randn(size(input1)) * params.sigma_net;
        rec = params.net.forward({input1+noise});
        rec_con(:,:,1) = rec{1,1};rec_con(:,:,2) = rec{2,1};rec_con(:,:,3) = rec{3,1};
        
        prior_err = input1 - rec_con;
        rec = params.net.backward({-prior_err(:,:,1),-prior_err(:,:,2),-prior_err(:,:,3)});
        prior_err = prior_err + rec{1};
        prior_err1 = prior_err;
        prior_err_sum = prior_err_sum + prior_err1;
    end
    prior_err = prior_err_sum/repeat_num;
    
    % sum the gradients
    err = prior_err;  %relative_weight*prior_err + (1-relative_weight)*data_err;  %
    err = mean(err,3) / maxvalue_exchange;
    
    reconstruction = double(pwls-params.gradient_beta*err);
    reconstruction(reconstruction<0) = 0;
    fprintf('recon_psnr = %f\n',psnr(original_image,reconstruction));
    fprintf(params.result,'recon_psnr = %f\r\n',psnr(original_image,reconstruction));
    % stop criteria
    diff = (pre_pwls-pwls).^2;
    if sqrt(sum(diff(:))) < 5e-4
        break;
    end
    pre_pwls = pwls;
end
end