% This is an example file that illustrates how to run nonlocal means with cluster trees with some given
% parameters

img = double(imread('../images/parrot.png'));
sigma = 25;
y = addWGN(img,sigma,0);

h = 3.0; % Smoothing parameter - higher means more smoothing
K = 10; % Number of clusters

% Main function call
z_e = klld_osa(img,y,sigma,K,h);

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
