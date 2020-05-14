psnr_sum = 0;
for i = 1:31
test_save = ['test_data_' num2str(i,'%02d')];
load(['./result_1sigma_25_L1000_800_400_50/' test_save 'cart_85_1.mat']);  %%%%%%%%
psnr_sum = psnr_sum + psnr4;
end
psnr = psnr_sum / 31