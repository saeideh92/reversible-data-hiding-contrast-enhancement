%%%%%%%%%recover the image and extract the message%%%%%%
% % message extraction 
ste=imread('st1.tiff');
st=ste;
[rows,columns]=size(st);
lmap=zeros(columns*rows,1);
s1=st';
s2=st(:);
nn=s2;
% rng(f)
% m=randi([0,1],1,N-16);

t=(columns*rows)-15;
for j=1:16
for col=t:(columns*rows)
    lsb1(1,j)=mod(s2(t,1),2);
    t=t+1;
    break
end
end

d1e=lsb1(1:8);
ir=bi2de(d1e);
d2e=lsb1(9:16);
is=bi2de(d2e);
peakse=[d1e d2e];
mkex=zeros(1,k);

a=1;
for n=1:k
for col=a:(columns*rows)-16
    if s2(col,1) == is-1
     mkex(1,n)=1;
     a=a+1;
     break
    else if s2(col,1) == is
     mkex(1,n)=0;
     a=a+1;
     break
     else if s2(col,1)==ir
     mkex(1,n)=0;
     a=a+1;
     break
    else if s2(col,1) == ir+1
     mkex(1,n)=1;
     a=a+1;
     break
        else
        a=a+1;
        end
        end
        end
        end
    end
end

if mkex-double(mk)==zeros(1,k)
    display('the extracted data completly matches with the message')
else
    C1=sum((mkex-double(mk)==0));
    P1=(C1/k)*100
    H='the similarity between the message and the extracted data is f%';
     o=[H,num2str(P1)];
    display(o)
end            


% recovering the orginal image

for col=1:(columns*rows)-16
    if  s2(col,1)<is-1
        s2(col,1)=s2(col,1)+1;
     
    else if s2(col,1)==is-1
         s2(col,1)=is;
        
    else if s2(col,1)==is
         s2(col,1)=is;
        
    else if s2(col,1)==ir
        s2(col,1)=ir;
        
    else if s2(col,1)==ir+1
         s2(col,1)=ir;
         
    else  if s2(col,1)>ir+1
        s2(col,1)= s2(col,1)-1;
     
        end
        end
        end
        end
        end
        end
end


grc=zeros(1,256);
for col= 1:(columns*rows)-16
		% Get the gray level.
		grayLevel1 = s2(col,1);
		% Add 1 because graylevel zero goes into index 1 and so on.
		grc(grayLevel1+1)=grc(grayLevel1+1)+1;
end


for col=1:(columns*rows)-16
    if lmap(col,1)==1 &&  s2(col,1)==1
      s2(col,1)=0;
    else if lmap(col,1)==1 &&  s2(col,1)==254
            s2(col,1)=255;
        end
    end
end

t=(columns*rows)-15;
for j=k-15:k
for col=t:(columns*rows)
    s2(t,1)=bitset(s2(t,1),1,mkex(1,j));
    t=t+1;
    break
end
end

gr=zeros(1,256);
for col= 1:(columns*rows)
		% Get the gray level.
		grayLevel1 = s2(col,1);
		% Add 1 because graylevel zero goes into index 1 and so on.
		gr(grayLevel1+1)=gr(grayLevel1+1)+1;
end

% Plot the histogram.
grayLevels = 0:255;
figure(6),bar(grayLevels,gr,'BarWidth',0.5,'FaceColor','b');
xlabel('Gray Level','FontSize',30);
ylabel('Pixel Count','FontSize',10);
title('recover','FontSize',20);
grid on;

figure(7), imshow(reshape(s2,size(st))),title('recover')

if gr-go==zeros(1,256)
    display('the pic is compeletly recovered')
else
    display('the restoring process is wrong')
end
