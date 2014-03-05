%% Z-Stack Image Analysis
%% Description : Manual filter
%% Author : Pham Thai Hoa - thaihoabo@gmail.com
%% Created date: 23/02/2014

function [MCTimage, MCTrtv, MCTgtv, MCTbtv, MCTrcc, MCTgcc, MCTbcc, fbe] = MNL(inputimage, iSize)

if length(size(inputimage)) == 2; 
    i = inputimage; 
    bd = 0:iSize; 
    i = reshape(i,1, prod(size(i))); 
    hi = histc(i, bd); 

    m = sum(hi.*bd)/sum(hi); 

    nm = sum(hi); 

    nbd = bd - m; 
    selfcc =  ((nbd.*nbd)*hi'); 

    
    fbe = zeros(1,(iSize + 1)); 
    for jj = 2:(iSize + 1); 
        beuh = zeros(1,(iSize + 1)); beuh(1,jj:end) = hi(1,jj:end); 
        benh = 0:iSize; benh = benh - m; 
        
        tvu = zeros(1,(iSize + 1)); tvu(1,jj:end) = hi(1,jj:end); 
        tvl = zeros(1,(iSize + 1)); tvl(1,1:jj-1) = hi(1,1:jj-1);
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
            bd = 0:iSize; 
            i = reshape(i,1, prod(size(i))); 
            hi = histc(i, bd); 

            m = sum(hi.*bd)/sum(hi); 

            nm = sum(hi); 

            nbd = bd - m; 
            selfcc =  ((nbd.*nbd)*hi'); 

            
            fbe = zeros(1,(iSize + 1)); 
            for jj = 2:(iSize + 1); 
                beuh = zeros(1,(iSize + 1)); beuh(1,jj:end) = hi(1,jj:end); 
                benh = 0:iSize; benh = benh - m; 
                be1(1,jj) = beuh*benh';
                tvu = zeros(1,(iSize + 1)); tvu(1,jj:end) = hi(1,jj:end); 
                tvl = zeros(1,(iSize + 1)); tvl(1,1:jj-1) = hi(1,1:jj-1);
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