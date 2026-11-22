% Set the PATH_TO_* strings below to your local image or MAT-file paths before running.
clc
close all
clear all

img=imread('PATH_TO_BOSSBASE_DIRECTORY/5785.pgm');
% c=rgb2gray(img);
c=img;
figure(1),imshow(c)
[rows,columns]=size(c);
c2=c(:);
nn=c2;
M=2;
bin(1,1)=0;
bin(1,2)=0;
load('PATH_TO_DATA2_MAT_FILE');

B1=sum(c2)/(columns*rows);

G(1,1)=0;
D(1,1)=0;
Cap(1,1)=0;

go=zeros(1,256);
for col =1:256
    go(1,col)=sum(c2==(col-1));
end

if G(1,M-1)==0
    [sortedX,sortedInds]=sort(go,'descend');
    ps=sortedInds(1,1)-1;
    if ps>1 && ps<254
        z=256-(ps+3)+1;
        gopc2=go(1,(ps+3):256);
        [sortedX2,sortedInds2]=sort(gopc2,'descend');
        k2=zeros(1,z);
        for w=1:z
            if sortedX2(1,w)==min(sortedX2)
                k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+(ps+2)));
                if k2(1,w)==min(k2(k2>0))
                    pc2=(sortedInds2(1,w)-1)+(ps+2);
                else
                    pc2=255;
                end
            end
        end
        
        gopc1=go(1,1:(ps-1));
        [sortedX1,sortedInds1]=sort(gopc1,'descend');
        k1=zeros(1,(ps-1));
        for w=1:(ps-1)
            if sortedX1(1,w)==min(sortedX1)
                k1(1,w)=abs(sortedInds(1,1)-(sortedInds1(1,w)));
                if k1(1,w)==min(k1(k1>0))
                    pc1=sortedInds1(1,w)-1;
                else
                    pc1=0;
                end
            end
        end
        if min(sortedX2) < min(sortedX1)
            pc=pc2;
        else if min(sortedX2) > min(sortedX1)
                pc=pc1;
            else if min(sortedX2)==min(sortedX1) && min(k1(k1>0))==min(k2(k2>0))
                    pc=pc1;
                else if min(sortedX2)==min(sortedX1) && min(k1(k1>0)) < min(k2(k2>0))
                        pc=pc1;
                    else if min(sortedX2)==min(sortedX1) && min(k1(k1>0)) > min(k2(k2>0))
                            pc=pc2;
                        end
                    end
                end
            end
        end
    else if ps<2
            z=256-(ps+3)+1;
            gopc=go(1,(ps+3):256);
            [sortedX2,sortedInds2]=sort(gopc,'descend');
            k2=zeros(1,z);
            for w=1:z
                if sortedX2(1,w)==min(sortedX2)
                    k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+(ps+2)));
                    if k2(1,w)==min(k2(k2>0))
                        pc=(sortedInds2(1,w)-1)+(ps+2);
                    else
                        pc=255;
                    end
                end
            end
        else if ps>253
                gopc=go(1,1:(ps-1));
                [sortedX1,sortedInds1]=sort(gopc,'descend');
                k1=zeros(1,(ps-1));
                for w=1:(ps-1)
                    if sortedX1(1,w)==min(sortedX1)
                        k1(1,w)=abs(sortedInds1(1)-(sortedInds1(1,w)));
                        if k1(1,w)==min(k1(k1>0))
                            pc=sortedInds1(1,w)-1;
                        else
                            pc=0;
                        end
                    end
                end
            end
        end
    end
    
    
else if G(1,M-1)>0
        
        gops=go(1,1:254);
        [sortedX,sortedInds]=sort(gops,'descend');
        ps=sortedInds(1,1)-1;
        z=256-(ps+3)+1;
        gopc=go(1,(ps+3):256);
        [sortedX2,sortedInds2]=sort(gopc,'descend');
        k2=zeros(1,z);
        for w=1:z
            if sortedX2(1,w)==min(sortedX2)
                k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+(ps+2)));
                if k2(1,w)==min(k2(k2>0))
                    pc=(sortedInds2(1,w)-1)+(ps+2);
                else
                    pc=255;
                end
            end
        end
        
    else if G(1,M-1)<0
            gops=go(1,3:256);
            [sortedX,sortedInds]=sort(gops,'descend');
            ps=sortedInds(1,1)-1+2;
            gopc=go(1,1:(ps-1));
            [sortedX1,sortedInds1]=sort(gopc,'descend');
            k1=zeros(1,(ps-1));
            for w=1:(ps-1)
                if sortedX1(1,w)==min(sortedX1)
                    k1(1,w)=abs(sortedInds1(1)-(sortedInds1(1,w)));
                    if k1(1,w)==min(k1(k1>0))
                        pc=sortedInds1(1,w)-1;
                    else
                        pc=0;
                    end
                end
            end
        end
    end
end

if ps<pc
    d=1;
else
    d=-1;
end

gs=0;
for col = 17:(columns*rows)
    if c2(col,1)==ps
        gs=gs+1;
    end
end

while (32+go(1,pc+1)+go(1,pc-d+1))<gs
    
    go=zeros(1,256);
    for col =1:256
        go(1,col)=sum(c2==(col-1));
    end
    
    if G(1,M-1)==0
        [sortedX,sortedInds]=sort(go,'descend');
        ps=sortedInds(1,1)-1;
        if ps>1 && ps<254
            z=256-(ps+3)+1;
            gopc2=go(1,(ps+3):256);
            [sortedX2,sortedInds2]=sort(gopc2,'descend');
            k2=zeros(1,z);
            for w=1:z
                if sortedX2(1,w)==min(sortedX2)
                    k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+(ps+2)));
                    if k2(1,w)==min(k2(k2>0))
                        pc2=(sortedInds2(1,w)-1)+(ps+2);
                    else
                        pc2=255;
                    end
                end
            end
            
            gopc1=go(1,1:(ps-1));
            [sortedX1,sortedInds1]=sort(gopc1,'descend');
            k1=zeros(1,(ps-1));
            for w=1:(ps-1)
                if sortedX1(1,w)==min(sortedX1)
                    k1(1,w)=abs(sortedInds(1,1)-(sortedInds1(1,w)));
                    if k1(1,w)==min(k1(k1>0))
                        pc1=sortedInds1(1,w)-1;
                    else
                        pc1=0;
                    end
                end
            end
            if min(sortedX2) < min(sortedX1)
                pc=pc2;
            else if min(sortedX2) > min(sortedX1)
                    pc=pc1;
                else if min(sortedX2)==min(sortedX1) && min(k1(k1>0))==min(k2(k2>0))
                        pc=pc1;
                    else if min(sortedX2)==min(sortedX1) && min(k1(k1>0)) < min(k2(k2>0))
                            pc=pc1;
                        else if min(sortedX2)==min(sortedX1) && min(k1(k1>0)) > min(k2(k2>0))
                                pc=pc2;
                            end
                        end
                    end
                end
            end
        else if ps<2
                z=256-(ps+3)+1;
                gopc=go(1,(ps+3):256);
                [sortedX2,sortedInds2]=sort(gopc,'descend');
                k2=zeros(1,z);
                for w=1:z
                    if sortedX2(1,w)==min(sortedX2)
                        k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+(ps+2)));
                        if k2(1,w)==min(k2(k2>0))
                            pc=(sortedInds2(1,w)-1)+(ps+2);
                        else
                            pc=255;
                        end
                    end
                end
            else if ps>253
                    gopc=go(1,1:(ps-1));
                    [sortedX1,sortedInds1]=sort(gopc,'descend');
                    k1=zeros(1,(ps-1));
                    for w=1:(ps-1)
                        if sortedX1(1,w)==min(sortedX1)
                            k1(1,w)=abs(sortedInds1(1)-(sortedInds1(1,w)));
                            if k1(1,w)==min(k1(k1>0))
                                pc=sortedInds1(1,w)-1;
                            else
                                pc=0;
                            end
                        end
                    end
                end
            end
        end
        
        
    else if G(1,M-1)>0
            
            gops=go(1,1:254);
            [sortedX,sortedInds]=sort(gops,'descend');
            ps=sortedInds(1,1)-1;
            z=256-(ps+3)+1;
            gopc=go(1,(ps+3):256);
            [sortedX2,sortedInds2]=sort(gopc,'descend');
            k2=zeros(1,z);
            for w=1:z
                if sortedX2(1,w)==min(sortedX2)
                    k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+(ps+2)));
                    if k2(1,w)==min(k2(k2>0))
                        pc=(sortedInds2(1,w)-1)+(ps+2);
                    else
                        pc=255;
                    end
                end
            end
            
        else if G(1,M-1)<0
                gops=go(1,3:256);
                [sortedX,sortedInds]=sort(gops,'descend');
                ps=sortedInds(1,1)-1+2;
                gopc=go(1,1:(ps-1));
                [sortedX1,sortedInds1]=sort(gopc,'descend');
                k1=zeros(1,(ps-1));
                for w=1:(ps-1)
                    if sortedX1(1,w)==min(sortedX1)
                        k1(1,w)=abs(sortedInds1(1)-(sortedInds1(1,w)));
                        if k1(1,w)==min(k1(k1>0))
                            pc=sortedInds1(1,w)-1;
                        else
                            pc=0;
                        end
                    end
                end
            end
        end
    end
    
    if ps<pc
        d=1;
    else
        d=-1;
    end
    
    lm=zeros(1,go(pc+1)+go(pc-d+1));
    t=1;
    for i=1:go(pc+1)+go(pc-d+1)
        for col=t:(columns*rows)
            if c2(col,1)==pc
                lm(1,i)=0;
                t=t+1;
                break
            else if c2(col,1)==pc-d
                    lm(1,i)=1;
                    t=t+1;
                    break
                else
                    t=t+1;
                end
            end
        end
    end
    q1=de2bi(bin(1,2*M-3),8);
    q2=de2bi(bin(1,2*M-2),8);
    
    S1=[q1,q2,lm];
    l1=length(S1);
    
    Cap(1,M)=go(ps+1);
    
    D(1,M)=go(ps+1)-l1;
    mk=[S1 data(1,(1+sum(D(1,1:M-1))):(sum(D(1,1:M))))];
    
    for col=1:columns*rows
        if c2(col,1)>min(pc,ps) && c2(col,1)<max(pc,ps)
            c2(col,1)=c2(col,1)+d;
        else
            c2(col,1)=c2(col,1);
        end
    end
    t=1;
    for col = 1:(columns*rows)
        for j=t:go(ps+1)
            if c2(col,1)==ps
                c2(col,1)=c2(col,1)+(mk(1,j)*d);
                t=t+1;
                break
            else
                break
            end
        end
    end
    
    B(1,M)=sum(c2)/(columns*rows);
    G(1,M)=B1-B(1,M);
    bin(1,2*M-1)=ps;
    bin(1,2*M)=pc;
    M=M+1;
    
    go=zeros(1,256);
    for col =1:256
        go(1,col)=sum(c2==(col-1));
    end
    
    if G(1,M-1)==0
        [sortedX,sortedInds]=sort(go,'descend');
        ps=sortedInds(1,1)-1;
        if ps>1 && ps<254
            z=256-(ps+3)+1;
            gopc2=go(1,(ps+3):256);
            [sortedX2,sortedInds2]=sort(gopc2,'descend');
            k2=zeros(1,z);
            for w=1:z
                if sortedX2(1,w)==min(sortedX2)
                    k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+(ps+2)));
                    if k2(1,w)==min(k2(k2>0))
                        pc2=(sortedInds2(1,w)-1)+(ps+2);
                    else
                        pc2=255;
                    end
                end
            end
            
            gopc1=go(1,1:(ps-1));
            [sortedX1,sortedInds1]=sort(gopc1,'descend');
            k1=zeros(1,(ps-1));
            for w=1:(ps-1)
                if sortedX1(1,w)==min(sortedX1)
                    k1(1,w)=abs(sortedInds(1,1)-(sortedInds1(1,w)));
                    if k1(1,w)==min(k1(k1>0))
                        pc1=sortedInds1(1,w)-1;
                    else
                        pc1=0;
                    end
                end
            end
            if min(sortedX2) < min(sortedX1)
                pc=pc2;
            else if min(sortedX2) > min(sortedX1)
                    pc=pc1;
                else if min(sortedX2)==min(sortedX1) && min(k1(k1>0))==min(k2(k2>0))
                        pc=pc1;
                    else if min(sortedX2)==min(sortedX1) && min(k1(k1>0)) < min(k2(k2>0))
                            pc=pc1;
                        else if min(sortedX2)==min(sortedX1) && min(k1(k1>0)) > min(k2(k2>0))
                                pc=pc2;
                            end
                        end
                    end
                end
            end
        else if ps<2
                z=256-(ps+3)+1;
                gopc=go(1,(ps+3):256);
                [sortedX2,sortedInds2]=sort(gopc,'descend');
                k2=zeros(1,z);
                for w=1:z
                    if sortedX2(1,w)==min(sortedX2)
                        k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+(ps+2)));
                        if k2(1,w)==min(k2(k2>0))
                            pc=(sortedInds2(1,w)-1)+(ps+2);
                        else
                            pc=255;
                        end
                    end
                end
            else if ps>253
                    gopc=go(1,1:(ps-1));
                    [sortedX1,sortedInds1]=sort(gopc,'descend');
                    k1=zeros(1,(ps-1));
                    for w=1:(ps-1)
                        if sortedX1(1,w)==min(sortedX1)
                            k1(1,w)=abs(sortedInds1(1)-(sortedInds1(1,w)));
                            if k1(1,w)==min(k1(k1>0))
                                pc=sortedInds1(1,w)-1;
                            else
                                pc=0;
                            end
                        end
                    end
                end
            end
        end
        
        
    else if G(1,M-1)>0
            
            gops=go(1,1:254);
            [sortedX,sortedInds]=sort(gops,'descend');
            ps=sortedInds(1,1)-1;
            z=256-(ps+3)+1;
            gopc=go(1,(ps+3):256);
            [sortedX2,sortedInds2]=sort(gopc,'descend');
            k2=zeros(1,z);
            for w=1:z
                if sortedX2(1,w)==min(sortedX2)
                    k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+(ps+2)));
                    if k2(1,w)==min(k2(k2>0))
                        pc=(sortedInds2(1,w)-1)+(ps+2);
                    else
                        pc=255;
                    end
                end
            end
            
        else if G(1,M-1)<0
                gops=go(1,3:256);
                [sortedX,sortedInds]=sort(gops,'descend');
                ps=sortedInds(1,1)-1+2;
                gopc=go(1,1:(ps-1));
                [sortedX1,sortedInds1]=sort(gopc,'descend');
                k1=zeros(1,(ps-1));
                for w=1:(ps-1)
                    if sortedX1(1,w)==min(sortedX1)
                        k1(1,w)=abs(sortedInds1(1)-(sortedInds1(1,w)));
                        if k1(1,w)==min(k1(k1>0))
                            pc=sortedInds1(1,w)-1;
                        else
                            pc=0;
                        end
                    end
                end
            end
        end
    end
    
    if ps<pc
        d=1;
    else
        d=-1;
    end
    
    gs=0;
    for col = 17:(columns*rows)
        if c2(col,1)==ps
            gs=gs+1;
        end
    end
    
end

M=M-1;
if M>=2
    
    ps=bin(1,2*M-1);
    pc=bin(1,2*M);
    
    if ps<pc
        d=1;
    else
        d=-1;
    end
    
    for col = 1:(columns*rows)
        if c2(col,1)>min(pc,ps) && c2(col,1)<max(pc,ps)
            c2(col,1)=c2(col,1)-d;
        else
            c2(col,1)=c2(col,1);
        end
    end
    lsb=zeros(1,16);
    for j=1:16
        lsb(1,j)=mod(c2(j,1),2);
    end
    
    gs=0;
    for col = 17:(columns*rows)
        if c2(col,1)==ps
            gs=gs+1;
        end
    end
    
    lsb=double(lsb);
    S=[lsb S1];
    r=length(S);
    D(1,M)=gs-r;
    Cap(1,M)=gs;
    mk=[S data(1,(1+sum(D(1,1:M-1))):(sum(D(1,1:M))))];
    
    for col = 17:(columns*rows)
        if c2(col,1)>min(pc,ps) && c2(col,1)<max(pc,ps)
            c2(col,1)=c2(col,1)+d;
        else
            c2(col,1)=c2(col,1);
        end
    end
    
    t=1;
    for col = 17:(columns*rows)
        for j=t:gs
            if c2(col,1)==ps
                c2(col,1)=c2(col,1)+(mk(1,j)*d);
                t=t+1;
                break
            else
                break
            end
        end
    end
    
    b1=de2bi(ps,8);
    b2=de2bi(pc,8);
    bins=[b1 b2];
    
    for col=1:16
        c2(col,1)=bitset(c2(col,1),1,bins(1,col));
    end
    B(1,M)=sum(c2)/(columns*rows);
    G(1,M)=B1-B(1,M);
    stego=reshape(c2,size(c));
    cover=reshape(nn,size(c));
    BCapa=sum(Cap);
    BrealCapa=sum(D);
    BPSNR=psnr(stego,cover);
    Bssimval=ssim(stego,cover);
    Bnumofrep=M-1;
    BMeanprop=mean(c2);
    BMeanorgi=mean(nn);
    Bsigmaprop=std(double(c2),1);
    Bsigmaorgi=std(double(nn),1);
    BD{1}=D;
    BC{1}=Cap;
    Bppr=BrealCapa/(columns*rows);
    Bpp=BCapa/(columns*rows);
    CE=entropy(cover);
    SE=entropy(stego);
end












