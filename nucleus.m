%This function introduces initial solid nuclei in the 
%center of the simulation cell. The size of the nuclei
%is in terms of grid numbers
%��ʵ����һ����ʼ������������T��������ά���飬��ʼֵ��Ϊ0
%����������Ϊԭ�㣬�뾶С��seed�ĵĶ���Ϊ�����ӣ���ʱ��=1
%�������T������ά����

function[phi,tempr]=nucleus(Nx,Ny,seed)

format long;

phi=zeros(Nx,Ny);
tempr=zeros(Nx,Ny);

for i=1:Nx
    for j=1:Ny
        if((i-Nx/2)*(i-Nx/2)+(j-Ny/2)*(j-Ny/2)<seed)
            phi(i,j)=1.0;
        end
    end
end

end
