% Set the PATH_TO_* strings below to your local image or MAT-file paths before running.
clc
close all
% clear all
% ste=imread('stBP.tiff');
ste=stego;
load('PATH_TO_DATA2_MAT_FILE');
figure(1),imshow(ste),title('stego im')
st=ste;
[rows,columns]=size(st);
s2=st(:);
ns=s2;
N=1;
Y(1,1)=0;
pspc=zeros(1,16);
for j=1:16
    pspc(1,j)=mod(s2(j,1),2);
end

peak(1,1)=bi2de(pspc(9:16));
peak(1,2)=bi2de(pspc(1:8));
pse=peak(1,2*N);
pce=peak(1,2*N-1);


if pse<pce
    d=1;
else
    d=-1;
end

g1=0;
g2=0;
for col = 17:(columns*rows)
    if s2(col,1)==pse
        g1=g1+1;
    else if s2(col,1)==pse+d
            g2=g2+1;
        end
    end
end
mkex=zeros(1,g1+g2);
a=17;
for n=1:g1+g2
    for col=a:(columns*rows)
        if s2(col,1)==pse
            mkex(1,n)=0;
            a=a+1;
            break
        else if s2(col,1)==pse+d
                mkex(1,n)=1;
                a=a+1;
                break
            else
                a=a+1;
            end
        end
    end
end
gc=0;
for col = 17:(columns*rows)
    if s2(col,1)==pce
        gc=gc+1;
    end
end
lme=mkex(1,33:gc+32);

for col=17:(columns*rows)
    if  s2(col,1)>min(pse,pce) && s2(col,1)<max(pse,pce)
        s2(col,1)=s2(col,1)-d;
    else
        s2(col,1)= s2(col,1);
    end
end

a=1;
for col=17:(columns*rows)
    for t=a:gc
        if s2(col,1)==pce && lme(1,t)==0
            s2(col,1)=pce;
            a=a+1;
            break
        else if s2(col,1)==pce && lme(1,t)==1
                s2(col,1)=pce-d;
                a=a+1;
                break
            end
        end
    end
end

lsbex=mkex(1,1:16);
for col=1:16
    s2(col,1)=bitset(s2(col,1),1,lsbex(1,col));
end

Y(1,N+1)=(g1+g2)-(gc+32);
if (g1+g2)-(32+gc)~=0
    data1(1,1+sum(Y(1,1:N)):sum(Y(1:N+1)))=mkex(1,1+gc+32:g1+g2);
end

N=N+1;
peak(1,2*N-1)=bi2de(mkex(1,25:32));
peak(1,2*N)=bi2de(mkex(1,17:24));
pse=peak(1,2*N);
pce=peak(1,2*N-1);

if pse<pce
    d=1;
else
    d=-1;
end

while pce~=0 || pse~=0
    
    if pse<pce
        d=1;
    else
        d=-1;
    end
    
    g1=0;
    g2=0;
    for col = 1:(columns*rows)
        if s2(col,1)==pse
            g1=g1+1;
        else if s2(col,1)==pse+d
                g2=g2+1;
            end
        end
    end
    mkex=zeros(1,g1+g2);
    a=1;
    for n=1:g1+g2
        for col=a:(columns*rows)
            if s2(col,1)==pse
                mkex(1,n)=0;
                a=a+1;
                break
            else if s2(col,1)==pse+d
                    mkex(1,n)=1;
                    a=a+1;
                    break
                else
                    a=a+1;
                end
            end
        end
    end
    
    gc=0;
    for col = 1:(columns*rows)
        if s2(col,1)==pce
            gc=gc+1;
        end
    end
    lme=mkex(1,17:gc+16);
    
    for col=1:(columns*rows)
        if  s2(col,1)>min(pse,pce) && s2(col,1)<max(pse,pce)
            s2(col,1)=s2(col,1)-d;
        else
            s2(col,1)= s2(col,1);
        end
    end
    
    a=1;
    for col=1:(columns*rows)
        for t=a:gc
            if s2(col,1)==pce && lme(1,t)==0
                s2(col,1)=pce;
                a=a+1;
                break
            else if s2(col,1)==pce && lme(1,t)==1
                    s2(col,1)=pce-d;
                    a=a+1;
                    break
                else
                    break
                end
            end
        end
    end
    
    Y(1,N+1)=(g1+g2)-(gc+16);
    if (g1+g2)-(16+gc)~=0
        data1(1,1+sum(Y(1,1:N)):sum(Y(1:N+1)))=mkex(1,1+gc+16:g1+g2);
    end
    
    N=N+1;
    peak(1,2*N-1)=bi2de(mkex(1,9:16));
    peak(1,2*N)=bi2de(mkex(1,1:8));
    pse=peak(1,2*N);
    pce=peak(1,2*N-1);
    
end


h=fliplr(Y);
r=zeros(1,N);
r(2:N)=h(1:N-1);

for f=1:N
    dataext(1,1+sum(r(1:f-1)):sum(r(1:f)))=data1(1,1+sum(r)-sum(r(1,1:f)):sum(r)-sum(r(1,1:f-1)));
end

if dataext-data(1,1:sum(r))==zeros(1,sum(r))
    display('the extracted data completly matches with the message')
else
    C1=sum((dataext-data(1,1:sum(r))==0));
    P1=(C1/sum(r))*100;
    H='the similarity between the message and the extracted data is f%';
    o=[H,num2str(P1)];
    display(o)
end

img=imread('PATH_TO_KODAK_DIRECTORY/kodim5.png');
cx=rgb2gray(img);
% cx=img;
[rows,columns]=size(cx);
c2=cx(:);
nn=c2;

if s2-nn==zeros(columns*rows,1)
    display('the cover is compeletly recovered')
else
    display('the cover restoring process is wrong')
end


