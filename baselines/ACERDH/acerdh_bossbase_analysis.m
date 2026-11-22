% Set the PATH_TO_* strings below to your local image or MAT-file paths before running.
clc
clear all
close all

ACapa=zeros(1,1);
ArealCapa=zeros(1,1);
APSNR=zeros(1,1);
Anumofrep=zeros(1,1);
AMeanprop=zeros(1,1);
AMeanorgi=zeros(1,1);
Asigmaprop=zeros(1,1);
Asigmaorgi=zeros(1,1);
ANum=zeros(1,1);
gsf=zeros(1,1);
Assimval=zeros(1,1);
Anewend=zeros(1,1);
Abpp=zeros(1,1);
Abppr=zeros(1,1);
CE=zeros(1,1);
SE=zeros(1,1);

qv=1;
% load('NrealCapa1.mat')
load('BNum.mat')
H=BNum;

for rt=1:length(H)
    rt
    baseFileName = sprintf('%d.pgm',H(1,rt));
    ImageSet{1,rt} = string(fullfile ('PATH_TO_BOSSBASE_DIRECTORY', baseFileName));
    img= imread(ImageSet{1,rt});
    load('PATH_TO_DATA2_MAT_FILE');
    c=img;
    [rows,columns]=size(c);
    c2=c(:);
    nn=c2;
    M=2;
    
    Cap=zeros(1,1);
    D=zeros(1,1);
    bin=zeros(1,2); 
    PL=floor(0.12*rows*columns);
%     PL=NrealCapa1;
    newstart=tic;
    
%     while sum(D)<=PL(1,rt)
  while sum(Cap)<=PL 
      
        go=zeros(1,256);
        for col =1:256
            go(1,col)=sum(c2==(col-1));
        end
        
        [sortedX,sortedInds]=sort(go,'descend');
        ps=sortedInds(1,1)-1;
        
        if ps>1 && ps<254
            z=256-(ps+3)+1;
            gopc2=go(1,(ps+3):256);
            [sortedX2,sortedInds2]=sort(gopc2,'descend');
            k2=zeros(1,z);
            for w=1:z
                if sortedX2(1,w)==min(sortedX2)
                    k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+ps+2));
                    if k2(1,w)==min(k2(k2>0))
                        pc2=(sortedInds2(1,w)-1)+(ps+2);
                    end
                else
                    pc2=255;
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
                        k2(1,w)=abs(sortedInds(1,1)-(sortedInds2(1,w)+ps+2));
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
        
        gps=0;
        for col = 17:(columns*rows)
            if c2(col,1)==ps
                gps=gps+1;
            end
        end
        
        if (32+go(1,pc+1)+go(1,pc-d+1))<=gps
            
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
            
            bin(1,2*M-1)=ps;
            bin(1,2*M)=pc;
            M=M+1;
        else
            break
        end
    end
    
    extra=sum(Cap)-PL;
%     extra=sum(D)-PL(1,rt);
    if extra>=0
        
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
            
            gps=0;
            for col = 17:(columns*rows)
                if c2(col,1)==ps
                    gps=gps+1;
                end
            end
            
            lsb=double(lsb);
            S=[lsb S1];
            r=length(S);
            
            gsf(1,rt)=PL-sum(Cap(1,1:M-1));
            if gsf(1,rt)>=r
                Cap(1,M)=gsf(1,rt);
                D(1,M)=gsf(1,rt)-r;
            else
                Cap(1,M)=r;
                D(1,M)=Cap(1,M)-r;
            end
            
%             D(1,M)=D(1,M)-extra;
            
            mk=[S data(1,(1+sum(D(1,1:M-1))):(sum(D(1,1:M))))];
%             Cap(1,M)=length(mk);
%             gsf(1,rt)=Cap(1,M);
            
            for col = 17:(columns*rows)
                if c2(col,1)>min(pc,ps) && c2(col,1)<max(pc,ps)
                    c2(col,1)=c2(col,1)+d;
                else
                    c2(col,1)=c2(col,1);
                end
            end
            
            t=1;
            for col = 17:(columns*rows)
                for j=t:gsf(1,rt)
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
            
            Anewend(1,rt)=toc(newstart);
            
            stego=reshape(c2,size(c));
            OutDirs = 'AStegoes1';
            mkdir(OutDirs);
            baseFileName = sprintf('Stego%d.pgm',H(1,rt));
            fullFileName = fullfile(OutDirs, baseFileName);
            imwrite(stego, fullFileName)
            
            cover=reshape(nn,size(c));
            %             OutDirc = 'ACover0.5'; 
            %             mkdir(OutDirc);
            %             baseFileName1 = sprintf('Cover%d.pgm', rt);
            %             fullFileName1 = fullfile(OutDirc, baseFileName1);
            %             imwrite(cover, fullFileName1)
            %
            ACapa(1,rt)=sum(Cap);
            ArealCapa(1,rt)=sum(D);
            APSNR(1,rt)=psnr(stego,cover);
            Assimval(1,rt)=ssim(stego,cover);
            Anumofrep(1,rt)=M-1;
            AMeanprop(1,rt)=mean(c2);
            AMeanorgi(1,rt)=mean(nn);
            Asigmaprop(1,rt)=std(double(c2),1);
            Asigmaorgi(1,rt)=std(double(nn),1);
            AD{rt}=D;
            AC{rt}=Cap;
            ANum(1,rt)=H(1,rt);
            Abppr(1,rt)=ArealCapa(1,rt)/(columns*rows);
            Abpp(1,rt)=ACapa(1,rt)/(columns*rows);
            CE(1,rt)=entropy(cover);
            SE(1,rt)=entropy(stego);
            qv=qv+1
        end
    end
    
end


