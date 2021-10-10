% %%%%select the diameter of the hole
dia = 40;
 N = 2;  %%% number of simulations

a11 = textfile('C:\Users\Athiest69\IIST\Summer 21\Internship\D=40\a11.txt');
a12 = textfile('C:\Users\Athiest69\IIST\Summer 21\Internship\D=40\a12.txt');
% a11 = 125*3;
% a12=50*3;

%%%%start and end of x and y co-ordinates
xms=a11/2-2*dia;%10.5*dia;
xmf=a11/2+2*dia;%14.5*dia;
yms=a12/2-2*dia;%dia*3;
ymf=a12/2+2*dia;%dia*7;


%%%% meshgrid  for interpolation
f=0.05;g=0.05;h=0.05;
xq1=xms:h:a11/2-1.5*dia/2;
xq2=a11/2-1.5*dia/2:f:a11/2+1.5*dia/2;
xq3=a11/2+1.5*dia/2:h:xmf;
xq=[xq1';xq2';xq3'];
yq1=yms:h:a12/2-1.5*dia/2;
yq2=a12/2-1.5*dia/2:g:a12/2+1.5*dia/2;
yq3=a12/2+1.5*dia/2:h:ymf;
yq=[yq1';yq2';yq3'];
[K1,K2] =meshgrid(xq, yq);
a= size(xq2,2);
b=size(yq2,2);

for k = 0:b
    for j=0:a
       e=((k*f)-1.5*dia/2-.1)^2+((j*g)-1.5*dia/2-.1)^2-(.5*dia)^2;
%          disp(e)
        if e<0
          
            K1(size(xq1,2)+j,size(yq1,2)+k)=  NaN;
            K2(size(xq1,2)+j,size(yq1,2)+k)=  NaN;
        end
    end
end
 zz1=0;
 zz2= 0;


% z1= xlsread('z1ffavgdisp50030.xlsx');
% z2 =  xlsread('z2ffavgdisp50030.xlsx');
% zz1= z1*500;
% zz2 = z2*500;
%%%%input xx,yy,elst value of all simulations
for i =1:N 
    fx =[ 'C:\Users\Athiest69\IIST\Summer 21\Internship\D=40\xx' num2str(i) '.txt'];  %%% add path of xx yy u1 u2 values
    fy =[ 'C:\Users\Athiest69\IIST\Summer 21\Internship\D=40\yy' num2str(i) '.txt'];
    fu =[ 'C:\Users\Athiest69\IIST\Summer 21\Internship\D=40\rf1' num2str(i) '.txt'];
    fv =[ 'C:\Users\Athiest69\IIST\Summer 21\Internship\D=40\rf2' num2str(i) '.txt'];
    

x = textfile(fx);
y = textfile(fy);
z1 = textfile(fu);
z2 = textfile(fv);


U1 = griddata(x,y,z1,K1,K2);   %%  interpolation over the grid 
U2 = griddata(x,y,z2,K1,K2);

zz1 = U1+zz1;
 zz2 = U2+zz2;
i;  

end
  %%%  avg of disp values
Z1=zz1/N;
Z2= zz2/N;

%% saving data 
 xlswrite('z1ffavgdisp100030.xlsx',Z1);
 xlswrite('z2ffavgdisp100030.xlsx',Z2);

% Z1= xlsread('z1avgdisp50080.xlsx');
% Z2 =  xlsread('z2avgdisp50080.xlsx');
E = zeros(size(K1,1),size(K1,1));
%%% calculation of strain  using strain mapping 
       for j = 1: size(K1,1)-1
    for i = 1:size(K1,1)-1
      
       
        
%          v = [u(i,1);u(i,2);u(i+1,1);u(i+1,2);u(i+size(K1,1)+1,1);u(i+size(K1,1)+1,2);u(i+size(K1,1),1);u(i+size(K1,1),2)];
         v = [Z1(j,i);Z2(j,i);Z1(j,i+1);Z2(j,i+1);Z1(j+1,i+1);Z2(j+1,i+1);Z1(j+1,i);Z2(j+1,i)];
        e1= strain1(v);
        e2= strain2(v);
        e3= strain3(v);
        e4= strain4(v);
        
         E(j,i) = e1(1);%+E(i,1);
        E(j,i+1) = e2(1);%+E(i+1,1);
        E(j+1,i) = e4(1);%+E(i+size(K1,1),1);
        E(j+1,1+i) = e3(1);
    end
       end  
       
       %% ne is normalised strain 
ne = 0.015*2/125;
ne1 = E/ne;
       figure(1)
          contourf(K1,K2,E*2/ne)
          hold on 
    
  title('e11 variation (NS= 1400,d=20)')
     colormap(jet(256))
        colorbar
     hold off
     
%% saving data 
 xlswrite('ne1.xlsx',ne1);
 
  %%% ploting 
   
%     figure(2)
% % % % 
% %   D = xlsread('d30_1abb.xlsx');
%  Z= E(1:451,602); %%% Vertical below  of the hole 
%  s1 = 0:0.1:45.1;
%  Z= E(1503:end,1203); %% Vertical above of the hole
% %   
%     xlswrite('d30_nsf1000.xlsx',Z)
%    s3 = (0:0.05:60)/60;
% %   plot(s1,Z/0.015,s2,z/0.015);
% % plot(s2/dia,Z/ne)
%   title('e11 variation (NS= 200,d=30)')
%      xlabel('x2/d')
%     ylabel('Normalized Strain ')
%   legend('Vertical below','Vertical above')
%  figure(57)
% %   p1 =xlsread('d10_ns400.xlsx');
% %  p2 =xlsread('d20_ns400.xlsx');
% %   p3 =xlsread('d30_ns400.xlsx');
% % %  p4 =xlsread('d30_ns200.xlsx');
% % 
%  K= (0:0.3:45)/30;
%  s2 = (0:0.15:45.15)/30;
%    s3 = (0:0.1:45.2)/30;
% %   
%  plot(K,p1,'r',s2,p2,'b',s3,Z)
%  grid on 
%  title('Variation of Normalized strain with size of hole(NS=400)')
%     xlabel('x2/d')
%    ylabel('Normalized strain')
%     legend('d=10','d=20','d=30')
%     
   
function E1 = strain1(v)


B1 = [1 0 0 0;0 0 0 1;0 1 1 0];
%% for node 1 
xi1=-1/sqrt(3);eta1=-1/sqrt(3);

B21 = B2();
B31 = B3(xi1,eta1);
B12 = B1*B21;
B = B12*B31;
E1 =B*v; 
end 
function E1 = strain2(v)


B1 = [1 0 0 0;0 0 0 1;0 1 1 0];
%% for node 1 
xi1=1/sqrt(3);eta1=-1/sqrt(3);

B21 = B2();
B31 = B3(xi1,eta1);
B12 = B1*B21;
B = B12*B31;
E1 =B*v; 
end 
function E1 = strain3(v)


B1 = [1 0 0 0;0 0 0 1;0 1 1 0];
%% for node 1 
xi1=1/sqrt(3);eta1=1/sqrt(3);

B21 = B2();
B31 = B3(xi1,eta1);
B12 = B1*B21;
B = B12*B31;
E1 =B*v; 
end 
function E1 = strain4(v)

B1 = [1 0 0 0;0 0 0 1;0 1 1 0];
%% for node 4
xi1=-1/sqrt(3);eta1=1/sqrt(3);

B21 = B2();
B31 = B3(xi1,eta1);
B12 = B1*B21;
B = B12*B31;
E1 =B*v; 
end 

% function J = jacob(xi,eta,p)
% J = [(1-eta)*0.25*(p(2,1)-p(1,1))+(1+eta)*0.25*(p(3,1)-p(4,1)) (1-eta)*0.25*(p(2,2)-p(1,2))+(1+eta)*0.25*(p(3,2)-p(4,2));...
%     (1-xi)*0.25*(p(4,1)-p(1,1))+(1+xi)*0.25*(p(3,1)-p(2,1)) (1-xi)*0.25*(p(4,2)-p(1,2))+(1+xi)*0.25*(p(3,2)-p(2,2))];
% end 

function B21 = B2()
B21 = [0.05/0.0025 0 0 0;0 0.05/0.0025 0 0;0 0 0.05/0.0025 0;0 0 0 0.05/0.0025];
end 
function B31 = B3(x,eta)
B31 = [-(1-eta)*0.25 0 (1-eta)*0.25 0 (1+eta)*0.25 0 -(1+eta)*0.25 0;...
       -(1-x)*0.25 0  -(1+x)*0.25 0 (1+x)*0.25 0 (1-x)*0.25 0;...
       0 -(1-eta)*0.25 0 (1-eta)*0.25 0 (1+eta)*0.25 0 -(1+eta)*0.25;...
       0  -(1-x)*0.25 0  -(1+x)*0.25 0 (1+x)*0.25 0 (1-x)*0.25];
end

function value = textfile(path)
    fileID = fopen(path,'r'); 
    value= fscanf(fileID,'%f');
    fclose(fileID);
end
      
