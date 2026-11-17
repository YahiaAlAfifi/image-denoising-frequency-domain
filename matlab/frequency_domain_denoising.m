%% Read the original grayscale image
img = imread('cameraman.tif');
img = double(img);

%% Add Gaussian noise
noise_sigma = 20;
noise = noise_sigma * randn(size(img));
noisy_img = img + noise;

%% Display Original and Noisy Images
figure;
subplot(2,3,1);
imshow(uint8(img));
title('Original Image');

subplot(2,3,2);
imshow(uint8(noisy_img));
title('Noisy Image');

%% Compute the Fourier Transform of the noisy image
F = fft2(noisy_img);
F_shifted = fftshift(F);

%% Display the magnitude spectrum of the noisy image (log scale)
subplot(2,3,3);
magnitude_spectrum = log(1 + abs(F_shifted));
imshow(mat2gray(magnitude_spectrum));
title('Spectrum of Noisy Image (Log Scale)');

%% Create Ideal Low Pass Filter
[rows, cols] = size(img);
cx = floor(cols/2) + 1;
cy = floor(rows/2) + 1;
radius = 50;

[X, Y] = meshgrid(1:cols, 1:rows);
dist = sqrt((X - cx).^2 + (Y - cy).^2);
H = double(dist <= radius);

%% Display the filter mask
subplot(2,3,4);
imshow(H);
title('Ideal Low-Pass Filter Mask');

%% Apply the filter to the frequency spectrum
F_filtered = F_shifted .* H;

%% Display the filtered frequency spectrum
subplot(2,3,5);
filtered_magnitude_spectrum = log(1 + abs(F_filtered));
imshow(mat2gray(filtered_magnitude_spectrum));
title('Filtered Spectrum (Log Scale)');

%% Reconstruct the filtered image using Inverse FFT
F_inv_shifted = ifftshift(F_filtered);
img_denoised = ifft2(F_inv_shifted);
img_denoised = real(img_denoised);

%% Display the denoised image
subplot(2,3,6);
imshow(uint8(img_denoised));
title('Denoised Image');

%% Display the difference image
figure;
imshow(mat2gray(abs(img - img_denoised)));
title('Difference Image');

%% Compute PSNR to evaluate denoising quality
mse_noisy = mean((img(:) - noisy_img(:)).^2);
psnr_noisy = 10 * log10(255^2 / mse_noisy);
disp(['PSNR of noisy image = ', num2str(psnr_noisy), ' dB']);

mse_denoised = mean((img(:) - img_denoised(:)).^2);
psnr_denoised = 10 * log10(255^2 / mse_denoised);
disp(['PSNR of denoised image = ', num2str(psnr_denoised), ' dB']);
