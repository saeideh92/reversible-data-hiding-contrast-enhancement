clc
close all
clear all
pic=imread('5.1.12.tiff');
c=pic;
[rows,columns]=size(c);
lmap=zeros(columns*rows,1);
c1=c';
c2=c(:);
nn=c2;
go=zeros(1,256);
for col = 1:(columns*rows)
		% Get the gray level.
		grayLevel = c2(col,1);
		% Add 1 because graylevel zero goes into index 1 and so on.
		go(grayLevel+1) = go(grayLevel+1)+ 1;
end
% Plot the histogram.
grayLevels = 0:255;
figure(1),bar(grayLevels,go,'BarWidth',0.5,'FaceColor','b');
xlabel('Gray Level','FontSize',30);
ylabel('Pixel Count','FontSize',10);
title('original image','FontSize',20);
grid on;


figure(2),imshow(pic),title('orginal')

%pre-process
for col=1:(columns*rows)-16
        if c2(col,1)==0
            c2(col,1)=1;
            lmap(col,1)=1;
        else if c2(col,1)==255
            c2(col,1)=254;
            lmap(col,1)=1;
            end
            end
end

gc=zeros(1,256);
for col = 1:(columns*rows)-16
		% Get the gray level.
		grayLevel = c2(col,1);
		% Add 1 because graylevel zero goes into index 1 and so on.
		gc(grayLevel+1) = gc(grayLevel+1)+ 1;
end
% Plot the histogram.
grayLevels = 0:255;
figure(3),bar(grayLevels,gc,'BarWidth',0.5,'FaceColor','b');
xlabel('Gray Level','FontSize',30);
ylabel('Pixel Count','FontSize',10);
title('cover image','FontSize',20);
grid on;

%embedding data
[sortedX,sortedInds] = sort(gc,'descend');
i1=sortedInds(1);
i2=sortedInds(2);
if i1<i2
    Is=i1-1;
    Ir=i2-1;
else
    Is=i2-1;
    Ir=i1-1;
end

N=gc(i1)+gc(i2)
f=rng;
d=randi([0,1],1,N-16);

%getting 16 lsbs of pixels in last row
t=(columns*rows)-15;
for j=1:16
for col=t:(columns*rows)
    lsb(1,j)=mod(c2(t,1),2);
    t=t+1;
    break
end
end

mk=[d lsb];

k=length(mk);

%embedding data
st=zeros(columns*rows,1);
i=1;

for col=1:(columns*rows)-16

    if c2(col,1) < Is
     st(col,1)=c2(col,1)-1;
   
     else if c2(col,1)>Is && c2(col,1)<Ir
    st(col,1)=c2(col,1);
    
    else if c2(col,1) > Ir
     st(col,1)=c2(col,1)+1;
    
        end
        end
        end
end

for n=1:k
for col=i:(columns*rows)-16
    
   if c2(col,1) == Is
     st(col,1)=c2(col,1)-mk(1,n);
     i=i+1;
     break
     
   else if c2(col,1) == Ir
     st(col,1)=c2(col,1)+mk(1,n);
     i=i+1;
     break
     
       else
       i=i+1;

        end
        end
        end
        end

d1=de2bi(Ir);
d2=de2bi(Is);
peaks=[d1 d2];

t=(columns*rows)-15;
for j=1:16
for col=t:(columns*rows)
    st(t,1)=c2(t,1);
    st(t,1)=bitset(st(t,1),1,peaks(1,j));
    t=t+1;
    break
end
end

gs=zeros(1,256);
for col= 1:(columns*rows)-16
		% Get the gray level.
		grayLevel1 = st(col,1);
		% Add 1 because graylevel zero goes into index 1 and so on.
		gs(grayLevel1+1)=gs(grayLevel1+1)+1;
end

% Plot the histogram.
grayLevels = 0:255;
figure(4),bar(grayLevels,gs,'BarWidth',0.5,'FaceColor','b');
xlabel('Gray Level','FontSize',30);
ylabel('Pixel Count','FontSize',10);
title('stego','FontSize',20);
grid on;
st=uint8(st);
stego=reshape(st,size(c));
imwrite(stego,'st1.tiff')
figure(5), imshow(stego),title('stego')

