% Set the PATH_TO_* strings below to your local image or MAT-file paths before running.
clc
close all
clear all
ste=imread('stegim.pgm');
load('PATH_TO_DATA2_MAT_FILE');
figure(1),imshow(ste),title('stego im')
st=ste;
[rows,columns]=size(st);
s2=st(:);
ns=s2;
N=1;
YL=zeros(1,1);
YR=zeros(1,1);
peakL=zeros(1,2);
peakR=zeros(1,2);

PLPl=zeros(1,16);
for j=1:16
    PLPl(1,j)=mod(s2(j,1),2);
end

peakL(1,1)=bi2de(PLPl(9:16));
peakL(1,2)=bi2de(PLPl(1:8));
PLe=peakL(1,2*N);
Ple=peakL(1,2*N-1);

PRPr=zeros(1,16);
t=17;
for j=1:16
    for col=t:32
        PRPr(1,j)=mod(s2(t,1),2);
        t=t+1;
        break
    end
end

peakR(1,1)=bi2de(PRPr(9:16));
peakR(1,2)=bi2de(PRPr(1:8));
PRe=peakR(1,2*N);
Pre=peakR(1,2*N-1);

gR1=0;
gR2=0;
gL1=0;
gL2=0;
for col = 33:(columns*rows)
    if s2(col,1)==PRe
        gR1=gR1+1;
    else if s2(col,1)==PRe+1
            gR2=gR2+1;
        else if s2(col,1)==PLe
                gL1=gL1+1;
            else if s2(col,1)==PLe-1
                    gL2=gL2+1;
                end
            end
        end
    end
end

mkLex=zeros(1,gL1+gL2);
a=33;
for n=1:gL1+gL2
    for col=a:(columns*rows)
        if s2(col,1)==PLe
            mkLex(1,n)=0;
            a=a+1;
            break
        else if s2(col,1)==PLe-1
                mkLex(1,n)=1;
                a=a+1;
                break
            else
                a=a+1;
            end
        end
    end
end

mkRex=zeros(1,gR1+gR2);
a=33;
for n=1:gR1+gR2
    for col=a:(columns*rows)
        if s2(col,1)==PRe
            mkRex(1,n)=0;
            a=a+1;
            break
        else if s2(col,1)==PRe+1
                mkRex(1,n)=1;
                a=a+1;
                break
            else
                a=a+1;
            end
        end
    end
end

gcL=0;
gcR=0;
for col = 33:(columns*rows)
    if s2(col,1)==Ple
        gcL=gcL+1;
    else if s2(col,1)==Pre
            gcR=gcR+1;
        end
    end
end

lmLe=mkLex(1,33:gcL+32);
lmRe=mkRex(1,33:gcR+32);

for col=33:(columns*rows)
    if  s2(col,1)>Ple && s2(col,1)<PLe
        s2(col,1)=s2(col,1)+1;
    else if s2(col,1)>PRe && s2(col,1)<Pre
            s2(col,1)=s2(col,1)-1;
        else
            s2(col,1)= s2(col,1);
        end
    end
end

a=1;
for col=33:(columns*rows)
    for t=a:gcL
        if s2(col,1)==Ple && lmLe(1,t)==0
            s2(col,1)=Ple;
            a=a+1;
            break
        else if s2(col,1)==Ple && lmLe(1,t)==1
                s2(col,1)=Ple+1;
                a=a+1;
                break
            end
        end
    end
end

a=1;
for col=33:(columns*rows)
    for t=a:gcR
        if s2(col,1)==Pre && lmRe(1,t)==0
            s2(col,1)=Pre;
            a=a+1;
            break
        else if s2(col,1)==Pre && lmRe(1,t)==1
                s2(col,1)=Pre-1;
                a=a+1;
                break
            end
        end
    end
end

lsbLex=mkLex(1,1:16);
for col=1:16
    s2(col,1)=bitset(s2(col,1),1,lsbLex(1,col));
end

lsbRex=mkRex(1,1:16);
t=17;
for j=1:16
    for col=t:32
        s2(t,1)=bitset(s2(t,1),1,lsbRex(1,j));
        t=t+1;
        break
    end
end

YL(1,N+1)=(gL1+gL2)-(gcL+32);
YR(1,N+1)=(gR1+gR2)-(gcR+32);

    data1(1,1+sum(YL(1,1:N))+sum(YR(1,1:N)):sum(YR(1,1:N))+sum(YL(1,1:N+1)))=mkLex(1,1+gcL+32:gL1+gL2);
    data1(1,1+sum(YR(1,1:N))+sum(YL(1,1:N+1)):sum(YL(1,1:N+1))+sum(YR(1:N+1)))=mkRex(1,1+gcR+32:gR1+gR2);

%     if (gL1+gL2)-(32+gcL)~=0
%     end
% if (gR1+gR2)-(32+gcR)~=0
%     dataR1(1,1+sum(YR(1,1:N))+sum(YL(1,1:N+1)):sum(YL(1,1:N+1))+sum(YR(1:N+1)))=mkRex(1,1+gcR+32:gR1+gR2);
% end

N=N+1;
peakL(1,2*N-1)=bi2de(mkLex(1,25:32));
peakL(1,2*N)=bi2de(mkLex(1,17:24));
PLe=peakL(1,2*N);
Ple=peakL(1,2*N-1);

peakR(1,2*N-1)=bi2de(mkRex(1,25:32));
peakR(1,2*N)=bi2de(mkRex(1,17:24));
PRe=peakR(1,2*N);
Pre=peakR(1,2*N-1);

while PRe~=0 || PLe~=0
    
    gR1=0;
    gR2=0;
    gL1=0;
    gL2=0;
    
    for col = 1:(columns*rows)
        if s2(col,1)==PRe
            gR1=gR1+1;
        else if s2(col,1)==PRe+1
                gR2=gR2+1;
            else if s2(col,1)==PLe
                    gL1=gL1+1;
                else if s2(col,1)==PLe-1
                        gL2=gL2+1;
                    end
                end
            end
        end
    end
    
    mkLex=zeros(1,gL1+gL2);
    a=1;
    for n=1:gL1+gL2
        for col=a:(columns*rows)
            if s2(col,1)==PLe
                mkLex(1,n)=0;
                a=a+1;
                break
            else if s2(col,1)==PLe-1
                    mkLex(1,n)=1;
                    a=a+1;
                    break
                else
                    a=a+1;
                end
            end
        end
    end
    
    mkRex=zeros(1,gR1+gR2);
    a=1;
    for n=1:gR1+gR2
        for col=a:(columns*rows)
            if s2(col,1)==PRe
                mkRex(1,n)=0;
                a=a+1;
                break
            else if s2(col,1)==PRe+1
                    mkRex(1,n)=1;
                    a=a+1;
                    break
                else
                    a=a+1;
                end
            end
        end
    end
    
    gcL=0;
    gcR=0;
    for col = 1:(columns*rows)
        if s2(col,1)==Ple
            gcL=gcL+1;
        else if s2(col,1)==Pre
                gcR=gcR+1;
            end
        end
    end
    
    lmLe=mkLex(1,17:gcL+16);
    lmRe=mkRex(1,17:gcR+16);
    
    for col=1:(columns*rows)
        if  s2(col,1)>Ple && s2(col,1)<PLe
            s2(col,1)=s2(col,1)+1;
        else if s2(col,1)>PRe && s2(col,1)<Pre
                s2(col,1)=s2(col,1)-1;
            else
                s2(col,1)= s2(col,1);
            end
        end
    end
    
    a=1;
    for col=1:(columns*rows)
        for t=a:gcL
            if s2(col,1)==Ple && lmLe(1,t)==0
                s2(col,1)=Ple;
                a=a+1;
                break
            else if s2(col,1)==Ple && lmLe(1,t)==1
                    s2(col,1)=Ple+1;
                    a=a+1;
                    break
                end
            end
        end
    end
    
    a=1;
    for col=1:(columns*rows)
        for t=a:gcR
            if s2(col,1)==Pre && lmRe(1,t)==0
                s2(col,1)=Pre;
                a=a+1;
                break
            else if s2(col,1)==Pre && lmRe(1,t)==1
                    s2(col,1)=Pre-1;
                    a=a+1;
                    break
                end
            end
        end
    end
    
    YL(1,N+1)=(gL1+gL2)-(gcL+16);
    YR(1,N+1)=(gR1+gR2)-(gcR+16);
   
        data1(1,1+sum(YL(1,1:N))+sum(YR(1,1:N)):sum(YR(1,1:N))+sum(YL(1,1:N+1)))=mkLex(1,1+gcL+16:gL1+gL2);
        data1(1,1+sum(YR(1,1:N))+sum(YL(1,1:N+1)):sum(YL(1,1:N+1))+sum(YR(1:N+1)))=mkRex(1,1+gcR+16:gR1+gR2);
%    
%     if (gL1+gL2)-(16+gcL)~=0 
%      end
%     if (gR1+gR2)-(16+gcR)~=0
%        
%     end
    
    N=N+1;
    peakL(1,2*N-1)=bi2de(mkLex(1,9:16));
    peakL(1,2*N)=bi2de(mkLex(1,1:8));
    PLe=peakL(1,2*N);
    Ple=peakL(1,2*N-1);
    
    peakR(1,2*N-1)=bi2de(mkRex(1,9:16));
    peakR(1,2*N)=bi2de(mkRex(1,1:8));
    PRe=peakR(1,2*N);
    Pre=peakR(1,2*N-1);
end

e=fliplr(YL+YR);
eq=zeros(1,N);
eq(2:N)=e(1:N-1);

for f=1:N
    dataext(1,1+sum(eq(1:f-1)):sum(eq(1:f)))=data1(1,1+sum(eq)-sum(eq(1,1:f)):sum(eq)-sum(eq(1,1:f-1)));
end

if dataext-data(1,1:sum(eq))==zeros(1,sum(eq))
    display('the extracted data completly matches with the message')
else
    C1=sum((dataext-data(1,1:sum(eq))==0));
    P1=(C1/sum(eq))*100;
    H='the similarity between the message and the extracted data is f%';
    o=[H,num2str(P1)];
    display(o)
end

img=imread('PATH_TO_BOSSBASE_DIRECTORY/2.pgm');

% cx=rgb2gray(img);
cx=img;
[rows,columns]=size(cx);
s2=cx(:);
nn=s2;

if s2-nn==zeros(columns*rows,1)
    display('the cover is compeletly recovered')
else
    display('the cover restoring process is wrong')
end







