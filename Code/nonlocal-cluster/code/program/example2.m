% This is an example file that illustrates how to run K-LLD with letting
% the code decide on the best smoothing parameter for a given image, by
% selecting a range of values to search over.
% Note: this may take a long time, depending on parameter space to sweep
% over, and the image size. 


img = double(imread('../images/parrot.png'));
sigma = 25;
y = addWGN(img,sigma,0);

K = 10;
h_range = [2.8:0.2:3.2];

[h_opt, z_e] = getBestKLLDParam(img,y,h_range,sigma,K);

% Compute MSE
y_mse = mean2((img - y).^2);
z_mse = mean2((img - z_e(:,:,end)).^2);

display(strcat('Initial noisy MSE : ', num2str(y_mse)));
display(strcat('MSE after denoising : ', num2str(z_mse)));

% Display figures
figure;
subplot(1,3,1); imagesc(uint8(img)); axis image; colormap gray; caxis([0 255]);
title('Original image');
subplot(1,3,2); imagesc(uint8(y)); axis image; colormap gray; caxis([0 255]);
title('Noisy image');
subplot(1,3,3); imagesc(uint8(z_e)); axis image; colormap gray; caxis([0 255]);
title('Denoised image');
