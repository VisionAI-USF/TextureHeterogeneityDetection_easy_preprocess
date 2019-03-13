function [  ] = show_nodule( data )

nimg = (data-100)/1100;
idx = find(nimg<0);
nimg(idx) = 0;
idx = find(nimg>1);
nimg(idx) = 1;
nimg = nimg.*255;
nimg = round(nimg);
nimg = uint8(nimg);
imshow(nimg)

end

