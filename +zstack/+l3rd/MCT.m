function [MCTimage, MCTrtv, MCTgtv, MCTbtv, MCTrcc, MCTgcc, MCTbcc, fbe] = MCT(inputimage)
% 
% MCT is an algorithm written by Krishnan Padmanabhan in the lab of Justin Crowley at 
% Carnegie Mellon University and was developed in 2007.  
%For help, please contact kpadmana@andrew.cmu.edu.  
%   
% 
% The algorithm takes an 8 bith input image (0 to 255) and thresholds the image into a 
% binary of 0 and 1.  If the image is grayscale, then the output is a N X M image, if the
% image is N X M X 3 with the three channels corresponding to the red, green and blue (RGB)
% channels.  
% 
% The output image MCTimage is the thresholded image.  fbe is the correlation spectrum. In 
% the greyscale image, fbe is a vector of length 256 (correspnding to the correlation at each 
% threshold value).  In the case of a RGB image, fbe is a 3 X 256 matrix with each 1 X 256 vector
% corresponding to the correlation spectrum of the R, G, and B channels.  

if length(size(inputimage)) == 2; 
    i = inputimage; 
    bd = 0:255; 
    i = reshape(i,1, prod(size(i))); 
    hi = histc(i, bd); 

    m = sum(hi.*bd)/sum(hi); 

    nm = sum(hi); 

    nbd = bd - m; 
    selfcc =  ((nbd.*nbd)*hi'); 

    
    fbe = zeros(1,256); 
    for jj = 2:256; 
        beuh = zeros(1,256); beuh(1,jj:end) = hi(1,jj:end); 
        benh = 0:255; benh = benh - m; 
        
        tvu = zeros(1,256); tvu(1,jj:end) = hi(1,jj:end); 
        tvl = zeros(1,256); tvl(1,1:jj-1) = hi(1,1:jj-1);
        njl = sum(tvl); 
        nju = sum(tvu);
        lv = (0-(nju/nm));
        uv = (1-(nju/nm));
        
        fbe(1,jj-1) = (beuh*benh')/sqrt(selfcc*(((nm-nju)*(nju))/nm));
        fbe(isinf(fbe))=0;

    end; 
    [bev bep] = max(fbe);
    tv = bep-1; 
    MCTimage = inputimage > tv; MCTimage = double(MCTimage); 
    MCTrtv = tv; MCTgtv = tv; MCTbtv = tv;
    MCTrcc = bev; MCTgcc = bev; MCTbcc = bev;


elseif length(size(inputimage)) == 3; 
    MCTimage = zeros(size(inputimage)); 
    clear tvh; clear cch; 
    tvh = zeros(1,3); cch = zeros(1,3); 
    for cc = 1:3; 
        i = inputimage(:,:,cc); 
        if max(max(i)) == 0; 
            tvh(1,cc) = 0; 
            cch(1,cc) = 0;
            MCTimage(:,:,cc) = inputimage(:,:,cc); 
        else
            bd = 0:255; 
            i = reshape(i,1, prod(size(i))); 
            hi = histc(i, bd); 

            m = sum(hi.*bd)/sum(hi); 

            nm = sum(hi); 

            nbd = bd - m; 
            selfcc =  ((nbd.*nbd)*hi'); 

            
            fbe = zeros(1,256); 
            for jj = 2:256; 
                beuh = zeros(1,256); beuh(1,jj:end) = hi(1,jj:end); 
                benh = 0:255; benh = benh - m; 
                be1(1,jj) = beuh*benh';
                tvu = zeros(1,256); tvu(1,jj:end) = hi(1,jj:end); 
                tvl = zeros(1,256); tvl(1,1:jj-1) = hi(1,1:jj-1);
                njl = sum(tvl); 
                nju = sum(tvu);
                lv = (0-(nju/nm));
                uv = (1-(nju/nm));
               
                fbe(1,jj-1) = (beuh*benh')/sqrt(selfcc*(((nm-nju)*(nju))/nm));
                fbe(isinf(fbe))=0;

            end; 
            
            [bev bep] = max(fbe);
            tv = bep-1; 
            MCTimage(:,:,cc) = inputimage(:,:,cc) > tv; MCTimage(:,:,cc) = double(MCTimage(:,:,cc)); 
            tvh(1,cc) = tv;
            cch(1,cc) = bev; 
        end
        fbec(cc,:) = fbe; 
    end
        MCTrtv = tvh(1,1);  
        MCTgtv = tvh(1,2); 
        MCTbtv = tvh(1,3); 
        MCTrcc = cch(1,1);
        MCTgcc = cch(1,2);
        MCTbcc = cch(1,3);
        
        fbe = fbec; 
end

end
            
        
            
            
            
            
            
            
        
        
        
    
    


    
    
    
    
    
    
    
    
    



