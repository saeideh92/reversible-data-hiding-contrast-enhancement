% Set the PATH_TO_* strings below to your local image or MAT-file paths before running.
clc
close all
clear all
RCapa=zeros(1,1);
RrealCapa=zeros(1,1);
RPSNR=zeros(1,1);
RNumofrep=zeros(1,1);
RMeanprop=zeros(1,1);
RMeanorgi=zeros(1,1);
Rsigmaprop=zeros(1,1);
Rsigmaorgi=zeros(1,1);
RNum=zeros(1,1);
Rssimval=zeros(1,1);
Rbpp=zeros(1,1);
Rbppr=zeros(1,1);
Rnewend=zeros(1,1);
CE=zeros(1,1);
SE=zeros(1,1);
load('BNum.mat');
number=BNum;
qv=1;
M=5;
for rt=1:length(number)
    rt
    baseFileName = sprintf('%d.pgm',number(1,rt));
    ImageSet{1,rt} = string(fullfile ('PATH_TO_BOSSBASE_DIRECTORY', baseFileName));
    img= imread(ImageSet{1,rt});
    load('PATH_TO_DATA2_MAT_FILE');
    c=img;
    [rows,columns]=size(c);
    c2=c(:);
    nn=c2;
    lmap=zeros(1,1);
    EL=ceil(0.1*columns*rows);
    mk=data;
    k=length(mk);

    D=zeros(1,1);
    peakval=zeros(1,2*(M-1));
    newstart=tic;
    
    for col=1:(columns*rows)-16
        if c2(col,1)<M
            c2(col,1)=c2(col,1)+M;
            lmap(col,1)=1;
        else if c2(col,1)>256-M-1
                c2(col,1)=c2(col,1)-M;
                lmap(col,1)=1;
            end
        end
    end
    
    for t=1:M-1
    if sum(D)<=EL
        
       
            go=zeros(1,256);
            for col =1:256
                go(1,col)=sum(c2==(col-1));
            end
            [~,sortedInds] = sort(go,'descend');
            I1=sortedInds(1);
            I2=sortedInds(2);
            if I1<I2
                Is=I1-1;
                Ir=I2-1;
            else
                Is=I2-1;
                Ir=I1-1;
            end
            peakval(1,2*t-1)=Is;
            peakval(1,2*t)=Ir;
            D(1,t+1)=go(I1)+go(I2);
            
            for col=1:(columns*rows)-16
                
                if c2(col,1) < Is
                    c2(col,1)=c2(col,1)-1;
                    
                else if c2(col,1)>Is && c2(col,1)<Ir
                        c2(col,1)=c2(col,1);
                        
                    else if c2(col,1) > Ir
                            c2(col,1)=c2(col,1)+1;
                            
                        end
                    end
                end
            end
            
            i=1;
            for x=1+sum(D(1,1:t)):sum(D(1,1:t+1))
                for col=i:(columns*rows)-16
                    
                    if c2(col,1) == Is
                        c2(col,1)=c2(col,1)-mk(1,x);
                        i=i+1;
                        break
                        
                    else if c2(col,1) == Ir
                            c2(col,1)=c2(col,1)+mk(1,x);
                            i=i+1;
                            break
                            
                        else
                            i=i+1;
                            
                        end
                    end
                end
            end
    else
        break
        end
    end 
    U(1,rt)=t;
    extra(1,rt)=sum(D)-EL;
    
    if extra(1,rt)>=0
        lsb=zeros(1,16);
        t=(columns*rows)-15;
        for j=1:16
            for col=t:(columns*rows)
                lsb(1,j)=mod(c2(t,1),2);
                t=t+1;
                break
            end
        end
        
        lsb=double(lsb);
        Mbi=de2bi(M,8);
        Ubi=de2bi(U(1,rt),8);
        peakbi=de2bi(peakval);
        p1=peakbi';
        p2=p1(:);
        p=p2';
        sideinf=[Mbi Ubi p lsb];
        nf=length(sideinf);
        
        go=zeros(1,256);
        for col =1:256
            go(1,col)=sum(c2==(col-1));
        end

        [sortedX,sortedInds] = sort(go,'descend');
        I1=sortedInds(1);
        I2=sortedInds(2);
        
        if I1<I2
            Isf=I1-1;
            Irf=I2-1;
        else
            Isf=I2-1;
            Irf=I1-1;
        end
        
        peakval(1,2*M-1)=Isf;
        peakval(1,2*M)=Irf;
        
        i=1;
        for col=1:(columns*rows)-16
            
            if c2(col,1) < Isf
                c2(col,1)=c2(col,1)-1;
                
            else if c2(col,1)>Isf && c2(col,1)<Irf
                    c2(col,1)=c2(col,1);
                    
                else if c2(col,1) > Irf
                        c2(col,1)=c2(col,1)+1;
                        
                    end
                end
            end
        end
        
        for x=1:nf
            for col=i:(columns*rows)-16
                
                if c2(col,1) == Isf
                    c2(col,1)=c2(col,1)-sideinf(1,x);
                    i=i+1;
                    break
                    
                else if c2(col,1) == Irf
                        c2(col,1)=c2(col,1)+sideinf(1,x);
                        i=i+1;
                        break
                        
                    else
                        i=i+1;
                    end
                end
            end
        end
        
        d1=de2bi(Irf,8);
        d2=de2bi(Isf,8);
        peaks=[d1 d2];
        
        t=(columns*rows)-15;
        for j=1:16
            for col=t:(columns*rows)
                c2(t,1)=bitset(c2(t,1),1,peaks(1,j));
                t=t+1;
                break
            end
        end
        
        Rnewend(1,rt)=toc(newstart);
        
        stego=reshape(c2,size(c));
        OutDirs = 'RStegoes1';
        mkdir(OutDirs);
        baseFileName = sprintf('RStego%d.pgm',number(1,rt));
        fullFileName = fullfile(OutDirs, baseFileName);
        imwrite(stego, fullFileName)
        
        cover=reshape(nn,size(c));
%         OutDirc = 'Cover';
%         mkdir(OutDirc);
%         baseFileName = sprintf('Cover%d.pgm',number(1,rt));
%         fullFileName = fullfile(OutDirc, baseFileName);
%         imwrite(cover, fullFileName)
        
        CE(1,rt)=entropy(cover);
        SE(1,rt)=entropy(stego);
        RCapa(1,rt)= sum(D)+nf;
        RrealCapa(1,rt)=sum(D);
        RPSNR(1,rt)=psnr(stego,cover);
        Rssimval(1,rt)=ssim(stego,cover);
        RNumofrep(1,rt)=U(1,rt);
        RMeanprop(1,rt)=mean(c2);
        RMeanorgi(1,rt)=mean(nn);
        Rsigmaprop(1,rt)=std(double(c2),1);
        Rsigmaorgi(1,rt)=std(double(nn),1);
        nD1{rt}=D;
        RNum(1,rt)=number(1,rt);
        Rbppr(1,rt)=RrealCapa(1,rt)/(columns*rows);
        Rbpp(1,rt)=RCapa(1,rt)/(columns*rows);
        qv=qv+1
    end
end