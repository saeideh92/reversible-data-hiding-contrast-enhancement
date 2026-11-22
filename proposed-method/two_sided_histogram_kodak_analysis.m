% Set the PATH_TO_* strings below to your local image or MAT-file paths before running.
clc
close all
clear all
NCapa=zeros(1,1);
NrealCapa=zeros(1,1);
NPSNR=zeros(1,1);
NNumofrep=zeros(1,1);
NMeanprop=zeros(1,1);
NMeanorgi=zeros(1,1);
Nsigmaprop=zeros(1,1);
Nsigmaorgi=zeros(1,1);
NNum=zeros(1,1);
Nssimval=zeros(1,1);
Nbpp=zeros(1,1);
Nbppr=zeros(1,1);
Nnewend=zeros(1,1);
CEN=zeros(1,1);
SEN=zeros(1,1);

for rt =1:24
    rt
    baseFileName = sprintf('kodim%d.png', rt);
    ImageSet{1,rt} = string(fullfile ('PATH_TO_KODAK_DIRECTORY', baseFileName));
    img= imread(ImageSet{1,rt});
    load('PATH_TO_DATA2_MAT_FILE');
    c=rgb2gray(img);

[rows,columns]=size(c);
c2=c(:);
nn=c2;
M=2;
binR(1,1)=0;
binR(1,2)=0;
binL(1,1)=0;
binL(1,2)=0;
CapL=zeros(1,1);
DL=zeros(1,1);
CapR=zeros(1,1);
DR=zeros(1,1);
  newstart=tic;
go=zeros(1,256);
for col =1:256
    go(1,col)=sum(c2==(col-1));
end

[sortedX,sortedInds]=sort(go,'descend');
v1=sortedInds(1,1)-1;
v2=sortedInds(1,2)-1;

if v1>v2
    PL=v2;
    PR=v1;
else
    PL=v1;
    PR=v2;
end

if PL>1
    gopc1=go(1,1:(PL-1));
    [sortedX1,sortedInds1]=sort(gopc1,'descend');
    k1=zeros(1,(PL-1));
    
    for w=1:(PL-1)
        if sortedX1(1,w)==min(sortedX1)
            k1(1,w)=abs(sortedInds(1,1)-(sortedInds1(1,w)));
            if k1(1,w)==min(k1(k1>0))
                Pl=sortedInds1(1,w)-1;
            end
        end
    end
else
    Pl=255;
end

if  PR<254
    z=256-(PR+3)+1;
    gopc2=go(1,(PR+3):256);
    [sortedX2,sortedInds2]=sort(gopc2,'descend');
    k2=zeros(1,z);
    for w=1:z
        if sortedX2(1,w)==min(sortedX2)
            k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+PR+2));
            if k2(1,w)==min(k2(k2>0))
                Pr=(sortedInds2(1,w)-1)+(PR+2);
            end
        end
    end
else
    Pr=0;
end

gsR=0;
gsL=0;
for col = 33:(columns*rows)
    if c2(col,1)==PR
        gsR=gsR+1;
    else if c2(col,1)==PL
            gsL=gsL+1;
        end
    end
end

if Pr~=0 && Pl~=255
    while (32+go(1,Pr+1)+go(1,Pr))<gsR &&  (32+go(1,Pl+1)+go(1,Pl+2))<gsL
        
        go=zeros(1,256);
        for col =1:256
            go(1,col)=sum(c2==(col-1));
        end
        
        [~,sortedInds]=sort(go,'descend');
        v1=sortedInds(1,1)-1;
        v2=sortedInds(1,2)-1;
        
        if v1>v2
            PL=v2;
            PR=v1;
        else
            PL=v1;
            PR=v2;
        end
        
        if PL>1
            gopc1=go(1,1:(PL-1));
            [sortedX1,sortedInds1]=sort(gopc1,'descend');
            k1=zeros(1,(PL-1));
            
            for w=1:(PL-1)
                if sortedX1(1,w)==min(sortedX1)
                    k1(1,w)=abs(sortedInds(1,1)-(sortedInds1(1,w)));
                    if k1(1,w)==min(k1(k1>0))
                        Pl=sortedInds1(1,w)-1;
                    end
                end
            end
        else
            Pl=255;
        end
        
        if  PR<254
            z=256-(PR+3)+1;
            gopc2=go(1,(PR+3):256);
            [sortedX2,sortedInds2]=sort(gopc2,'descend');
            k2=zeros(1,z);
            for w=1:z
                if sortedX2(1,w)==min(sortedX2)
                    k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+PR+2));
                    if k2(1,w)==min(k2(k2>0))
                        Pr=(sortedInds2(1,w)-1)+(PR+2);
                    end
                end
            end
        else
            Pr=0;
        end
        
        lmL=zeros(1,go(1,Pl+1)+go(1,Pl+2));
        t=1;
        for i=1:go(1,Pl+1)+go(1,Pl+2)
            for col=t:(columns*rows)
                if c2(col,1)==Pl
                    lmL(1,i)=0;
                    t=t+1;
                    break
                else if c2(col,1)==Pl+1
                        lmL(1,i)=1;
                        t=t+1;
                        break
                    else
                        t=t+1;
                    end
                end
            end
        end
        
        
        lmR=zeros(1,go(Pr+1)+go(Pr));
        t=1;
        for i=1:go(Pr+1)+go(Pr)
            for col=t:(columns*rows)
                if c2(col,1)==Pr
                    lmR(1,i)=0;
                    t=t+1;
                    break
                else if c2(col,1)==Pr-1
                        lmR(1,i)=1;
                        t=t+1;
                        break
                    else
                        t=t+1;
                    end
                end
            end
        end
        
        qL1=de2bi(binL(1,2*M-3),8);
        qL2=de2bi(binL(1,2*M-2),8);
        SL1=[qL1,qL2,lmL];
        lL1=length(SL1);
        CapL(1,M)=go(PL+1);
        DL(1,M)=go(PL+1)-lL1;
        mkL=[SL1 data(1,1+sum(DL(1,1:M-1))+sum(DR(1,1:M-1)):sum(DR(1,1:M-1))+sum(DL(1,1:M)))];
        
        qR1=de2bi(binR(1,2*M-3),8);
        qR2=de2bi(binR(1,2*M-2),8);
        SR1=[qR1,qR2,lmR];
        lR1=length(SR1);
        CapR(1,M)=go(PR+1);
        DR(1,M)=go(PR+1)-lR1;
        mkR=[SR1 data(1,1+sum(DL(1,1:M))+sum(DR(1,1:M-1)):sum(DR(1,1:M))+sum(DL(1,1:M)))];
        
        for col=1:columns*rows
            if c2(col,1)>Pl && c2(col,1)<PL
                c2(col,1)=c2(col,1)-1;
            else
                c2(col,1)=c2(col,1);
            end
        end
        
        for col=1:columns*rows
            if c2(col,1)>PR && c2(col,1)<Pr
                c2(col,1)=c2(col,1)+1;
            else
                c2(col,1)=c2(col,1);
            end
        end
        
        t=1;
        for col = 1:(columns*rows)
            for j=t:go(PL+1)
                if c2(col,1)==PL
                    c2(col,1)=c2(col,1)+(mkL(1,j)*(-1));
                    t=t+1;
                    break
                else
                    break
                end
            end
        end
        t=1;
        for col = 1:(columns*rows)
            for j=t:go(PR+1)
                if c2(col,1)==PR
                    c2(col,1)=c2(col,1)+(mkR(1,j)*(1));
                    t=t+1;
                    break
                else
                    break
                end
            end
        end
        
        binL(1,2*M-1)=PL;
        binL(1,2*M)=Pl;
        binR(1,2*M-1)=PR;
        binR(1,2*M)=Pr;
        M=M+1;
        
        go=zeros(1,256);
        for col =1:256
            go(1,col)=sum(c2==(col-1));
        end
        
        [sortedX,sortedInds]=sort(go,'descend');
        v1=sortedInds(1,1)-1;
        v2=sortedInds(1,2)-1;
        
        if v1>v2
            PL=v2;
            PR=v1;
        else
            PL=v1;
            PR=v2;
        end
        
        if PL>1
            gopc1=go(1,1:(PL-1));
            [sortedX1,sortedInds1]=sort(gopc1,'descend');
            k1=zeros(1,(PL-1));
            
            for w=1:(PL-1)
                if sortedX1(1,w)==min(sortedX1)
                    k1(1,w)=abs(sortedInds(1,1)-(sortedInds1(1,w)));
                    if k1(1,w)==min(k1(k1>0))
                        Pl=sortedInds1(1,w)-1;
                    end
                end
            end
        else
            Pl=255;
        end
        
        if  PR<254
            z=256-(PR+3)+1;
            gopc2=go(1,(PR+3):256);
            [sortedX2,sortedInds2]=sort(gopc2,'descend');
            k2=zeros(1,z);
            for w=1:z
                if sortedX2(1,w)==min(sortedX2)
                    k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+PR+2));
                    if k2(1,w)==min(k2(k2>0))
                        Pr=(sortedInds2(1,w)-1)+(PR+2);
                    end
                end
            end
        else
            Pr=0;
        end
        gsR=0;
        gsL=0;
        for col = 33:(columns*rows)
            if c2(col,1)==PR
                gsR=gsR+1;
            else if c2(col,1)==PL
                    gsL=gsL+1;
                end
            end
        end
        
        if Pl==255 || Pr==0
            break
        end
    end
    end
    M=M-1;
    if M>=2
        
        PL=binL(1,2*M-1);
        Pl=binL(1,2*M);
        PR=binR(1,2*M-1);
        Pr=binR(1,2*M);
        
        for col = 1:(columns*rows)
            if c2(col,1)>Pl && c2(col,1)<PL
                c2(col,1)=c2(col,1)+1;
            else
                c2(col,1)=c2(col,1);
            end
        end
        
        for col = 1:(columns*rows)
            if c2(col,1)>PR && c2(col,1)<Pr
                c2(col,1)=c2(col,1)-1;
            else
                c2(col,1)=c2(col,1);
            end
        end
        
        lsbL=zeros(1,16);
        for j=1:16
            lsbL(1,j)=mod(c2(j,1),2);
        end
        
        lsbR=zeros(1,16);
        t=17;
        for j=1:16
            for col=t:32
                lsbR(1,j)=mod(c2(t,1),2);
                t=t+1;
                break
            end
        end
        
        gsR=0;
        gsL=0;
        for col = 33:(columns*rows)
            if c2(col,1)==PR
                gsR=gsR+1;
            else if c2(col,1)==PL
                    gsL=gsL+1;
                end
            end
        end
        
        lsbL=double(lsbL);
        SL=[lsbL SL1];
        rL=length(SL);
        DL(1,M)=gsL-rL;
        CapL(1,M)=gsL;
        mkL=[SL data(1,1+sum(DL(1,1:M-1))+sum(DR(1,1:M-1)):sum(DR(1,1:M-1))+sum(DL(1,1:M)))];
        
        lsbR=double(lsbR);
        SR=[lsbR SR1];
        rR=length(SR);
        DR(1,M)=gsR-rR;
        CapR(1,M)=gsR;
        mkR=[SR data(1,1+sum(DL(1,1:M))+sum(DR(1,1:M-1)):sum(DR(1,1:M))+sum(DL(1,1:M)))];
        
        for col = 33:(columns*rows)
            if c2(col,1)>Pl && c2(col,1)<PL
                c2(col,1)=c2(col,1)-1;
            else
                c2(col,1)=c2(col,1);
            end
        end
        
        for col = 33:(columns*rows)
            if c2(col,1)>PR && c2(col,1)<Pr
                c2(col,1)=c2(col,1)+1;
            else
                c2(col,1)=c2(col,1);
            end
        end
        
        t=1;
        for col = 33:(columns*rows)
            for j=t:gsL
                if c2(col,1)==PL
                    c2(col,1)=c2(col,1)+(mkL(1,j)*(-1));
                    t=t+1;
                    break
                else
                    break
                end
            end
        end
        
        t=1;
        for col = 33:(columns*rows)
            for j=t:gsR
                if c2(col,1)==PR
                    c2(col,1)=c2(col,1)+(mkR(1,j)*(1));
                    t=t+1;
                    break
                else
                    break
                end
            end
        end
        
        bL1=de2bi(PL,8);
        bL2=de2bi(Pl,8);
        binsL=[bL1 bL2];
        
        for col=1:16
            c2(col,1)=bitset(c2(col,1),1,binsL(1,col));
        end
        
        bR1=de2bi(PR,8);
        bR2=de2bi(Pr,8);
        binsR=[bR1 bR2];
        
        t=17;
        for j=1:16
            for col=t:32
                c2(t,1)=bitset(c2(t,1),1,binsR(1,j));
                t=t+1;
                break
            end
        end
        
    

    Nnewend(1,rt)=toc(newstart);
stego=reshape(c2,size(c));
            OutDirs = 'KNStegoes';
            mkdir(OutDirs);
            baseFileName = sprintf('KNStego%d.png',rt);
            fullFileName = fullfile(OutDirs, baseFileName);
            imwrite(stego, fullFileName)
cover=reshape(nn,size(c));
CEN(1,rt)=entropy(cover);
SEN(1,rt)=entropy(stego);
NCapa(1,rt)= sum(CapL)+sum(CapR);
NrealCapa(1,rt)=sum(DL)+sum(DR);
NPSNR(1,rt)=psnr(stego,cover);
Nssimval(1,rt)=ssim(stego,cover);
NNumofrep(1,rt)=M-1;
NNum(1,rt)=rt;
NMeanprop(1,rt)=mean(c2);
NMeanorgi(1,rt)=mean(nn);
Nsigmaprop(1,rt)=std(double(c2),1);
Nsigmaorgi(1,rt)=std(double(nn),1);
nD1{rt}=[DL DR];
nC1{rt}=[CapL CapR];
Nbppr(1,rt)=(sum(DL)+sum(DR))/(columns*rows);
Nbpp(1,rt)=(sum(CapL)+sum(CapR))/(columns*rows);
    else 
CEN(1,rt)=0;
SEN(1,rt)=0;
NCapa(1,rt)= 0;
NrealCapa(1,rt)=0;
NPSNR(1,rt)=0;
Nssimval(1,rt)=0;
NNumofrep(1,rt)=0;
NNum(1,rt)=0;
NMeanprop(1,rt)=0;
NMeanorgi(1,rt)=0;
Nsigmaprop(1,rt)=0;
Nsigmaorgi(1,rt)=0;
nD1{rt}=0;
nC1{rt}=0;
Nbppr(1,rt)=0;
Nbpp(1,rt)=0;
   
end
end