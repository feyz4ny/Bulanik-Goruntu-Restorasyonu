clc; clear all;

resim = im2double(imread('yaprak.jpg'));
figure('Name', '1. Adim: Orijinal');
imshow(resim); 
title('Orijinal Goruntu');

h_motion = fspecial('motion', 25, 45);
resimBulanik = imfilter(resim, h_motion, 'replicate');
figure('Name', '2. Adim: Bulaniklik');
imshow(resimBulanik); 
title('Bulaniklastirilmis Goruntu');

figure('Name', '3. Adim: Kiyaslama');
subplot(1,2,1); imshow(resim); title('Orijinal');
subplot(1,2,2); imshow(resimBulanik); title('Bulaniklastirilmis');

resimBozuk = imnoise(resimBulanik, 'salt & pepper', 0.02);
figure('Name', '4. Adim: Gurultu');
imshow(resimBozuk); 
title('Bulanik + Gurultulu Goruntu');

figure('Name', '5. Adim: Kiyaslama');
subplot(1,2,1); imshow(resimBulanik); title('Sadece Bulanik');
subplot(1,2,2); imshow(resimBozuk); title('Bulanik + Gurultulu');

resimDenoised = resimBozuk;
resimDenoised(:,:,1) = medfilt2(resimBozuk(:,:,1), [3 3]);
resimDenoised(:,:,2) = medfilt2(resimBozuk(:,:,2), [3 3]);
resimDenoised(:,:,3) = medfilt2(resimBozuk(:,:,3), [3 3]);

figure('Name', '6. Adim: Gurultu Temizleme');
imshow(resimDenoised); 
title('Median Filtre Uygulanmis Goruntu');

figure('Name', '7. Adim: Kiyaslama');
subplot(1,2,1); imshow(resimBozuk); title('Gurultulu');
subplot(1,2,2); imshow(resimDenoised); title('Temizlenmis');

resimTapered = edgetaper(resimDenoised, h_motion);
resimOnarilmis = deconvwnr(resimTapered, h_motion, 0.01); 

[boy, en, ~] = size(resimOnarilmis);
k = 25; 
resimOnarilmis_Temiz = resimOnarilmis(k:boy-k, k:en-k, :);
resimDenoised_Temiz = resimDenoised(k:boy-k, k:en-k, :);

figure('Name', '8. Adim: Bulaniklik Giderme');
imshow(resimOnarilmis_Temiz); 
title('Wiener Filtre (Kenarlar Temizlenmis)');

figure('Name', '9. Adim: Final Kiyaslama');
subplot(1,2,1); imshow(resimDenoised_Temiz); title('Onarim Oncesi');
subplot(1,2,2); imshow(resimOnarilmis_Temiz); title('Onarim Sonrasi');