close all
clear al
clc

im = imresize(rgb2gray(imread('BraTS20_Validation_001_flair.png')), [120 120]);
size_im = size(im);
[out_a ,out_d]= dwt(im(:,1),'db1');
out = cat(1,out_a ,out_d);
for ii = 2:size_im(2)
    [out_a, out_d] = dwt(im(:,ii),'db1');
    w_col = cat(1, out_a, out_d);
    out = cat(2, out, w_col);
    
end
out(out< 0) = 0;
pout = out(:);
n = length(pout);
%m = nnz(pout);
m = floor(0.5*n);
Phi = randn(m,n);
y = Phi*pout;

%ll=1700;%iteration time
%alphar=omp_arch(Phi,n,m,ll,y);
%rout = alphar';
rout = l1eq_pd(pout,Phi,[],y);  
rec = reshape(rout, [size_im(1) size_im(2)]);
col = rec(:,1);
cout = idwt(col(1:size_im(1)/2,1), col(size_im(1)/2+1:size_im(1),1), 'db1');
for ii = 2:size_im[2];
    col = rec(:,ii);
    ccol= idwt(col(1:size_im(1)/2,1), col(size_im(1)/2+1:size_im(1),1), 'db1');
    cout = cat(2, cout,ccol);
end

figure 
imshow(im);
figure
imshow(out);
figure()
imshow(cout)
psnr(uint8(cout), im)