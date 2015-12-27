% Example file to run nonlocal means filter using cluster trees in batch mode. This code reads in all images
% from a particular directory, adds noise, performs denoising, and stores
% the results.

imdir = '../images/'; % Place images to denoise here
outFile = '../results/klld_osa_mc_data.csv'; % MSE values and parameters will be stored here
numMC = 5; % Number of noise realizations to use for each case
K = 5; % Number of clusters

ofp = fopen(outFile,'at');
fd = dir(imdir);
img_num = size(fd,1);

for fnum = 3:img_num
        
    display(strcat('Processing : ',fd(fnum).name));
    img = imread(strcat(imdir,fd(fnum).name));
    [N M C] = size(img);
    if(C==3)
        img = rgb2gray(img);
    end
    
    img = double(img);
    
    
   for sigma = 5:5:25 % Range of noise standard deviations to use
       
        mse_est = zeros(numMC,1);
        y = addWGN(img,sigma,0);
        
        [h_opt, z_e] = getBestKLLDParam(img,[1.6:0.2:3.6],sigma);

        if(h_opt==0) %Skip if best param not found
            continue;
        end
        
        z_est = zeros(size(img,2),size(img,2),numMC);
        z_est(:,:,1) = z_e; 
        mse(1) = mean2((img - z_e).^2);
        clear z_e;
        
        for i=2:numMC
            
            y = addWGN(img,sigma,i-1);
            
            z_e = klld_osa(img,y,sigma,K,h_opt); z_e = z_e(:,:,end);
            mse_est(i) = mean((z_e(:) - img(:)).^2);
            z_est(:,:,i) = z_e;
            close all;
        end
        
        save(strcat('../results/',fd(fnum).name,'_ns_',num2str(sigma),'_h_',num2str(h_opt),'.mat'),'z_est');
        clear z_est;
        
        mse_mean = mean(mse_est);
        mse_std = std(mse_est)/sqrt(numMC);


        fprintf(ofp,strcat(fd(fnum).name,',%1.2f,%3.3f,%2.3f\n'),h_opt,mse_mean, mse_std);
        clear mse_mean mse_std h_opt;
   end

       close all;
end
   
fclose(ofp);
display('All done');
