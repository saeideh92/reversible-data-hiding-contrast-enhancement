clc
close all
clear all
pic=imread('boat.512.tiff');
figure(11),imshow(pic)
c=pic;
[rows,columns]=size(c);
lmap=zeros(columns*rows,1);
c1=c';
c2=c(:);
nn=c2;
 go=zeros(1,256);
        for col =1:256 
            go(1,col)=sum(c2==(col-1));
        end
%%Plot the histogram.
grayLevels = 0:255;
figure(2),bar(grayLevels,go,'BarWidth',0.5,'FaceColor','b');
xlabel('Gray Level','FontSize',30);
ylabel('Pixel Count','FontSize',10);
title('original image','FontSize',20);
grid on;
f=rng;
load('data.mat');
mk=data;
k=length(mk);
M=50;
yy=zeros(1,M);


%%%pre-process
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

figure(10),imshow(reshape(lmap,size(c)))
gp=zeros(1,256);
for col = 1:(columns*rows)-16
    %%Get the gray level.
    grayLevel = c2(col,1);
    %%Add 1 because graylevel zero goes into index 1 and so on.
    gp(grayLevel+1) = gp(grayLevel+1)+ 1;
end
%%Plot the histogram.
grayLevels = 0:255;
figure(3),bar(grayLevels,gp,'BarWidth',0.5,'FaceColor','b');
xlabel('Gray Level','FontSize',30);
ylabel('Pixel Count','FontSize',10);
title('cover image','FontSize',20);
grid on;
peakval=zeros(1,2*(M-1));

for t=1:M-1
    gc=zeros(1,256);
    for col = 1:(columns*rows)-16
        grayLevel = c2(col,1);
        gc(grayLevel+1) = gc(grayLevel+1)+ 1;
    end
    [~,sortedInds] = sort(gc,'descend');
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
    N=gc(I1)+gc(I2);
    yy(1,t+1)=N;
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
    for x=1+sum(yy(1,1:t)):sum(yy(1,1:t+1))
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
end


%%%%final round of embedding%%%%
%%%getting 16 lsbs of pixels in last row%%%%%

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
peakbi=de2bi(peakval);
p1=peakbi';
p2=p1(:);
p=p2';
sideinf=[Mbi p lsb];
nf=length(sideinf);
gc=zeros(1,256);

for col = 1:(columns*rows)-16
    grayLevel = c2(col,1);
    gc(grayLevel+1) = gc(grayLevel+1)+ 1;
end

[sortedX,sortedInds] = sort(gc,'descend');
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

gs=zeros(1,256);
for col= 1:(columns*rows)-16
    %%Get the gray level.
    grayLevel1 =c2(col,1);
    %%Add 1 because graylevel zero goes into index 1 and so on.
    gs(grayLevel1+1)=gs(grayLevel1+1)+1;
end

%%Plot the histogram.
grayLevels = 0:255;
figure(4),bar(grayLevels,gs,'BarWidth',0.5,'FaceColor','b');
xlabel('Gray Level','FontSize',30);
ylabel('Pixel Count','FontSize',10);
title('stego','FontSize',20);
grid on;
stego=reshape(c2,size(c));
imwrite(stego,'st2.tiff')
figure(15), imshow(stego),title('stego')

