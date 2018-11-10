%This function generates the Laplae operator by using five-point
%stencil with periodic boundaries. It is used in optimized Matlab
%�õ�����һ��nxƽ��*nyƽ���ľ������磬������10X10�ľ��󣬱����100X100
%�����grad�������һ��(100X1)�ľ��󣬼�������ÿ������У���õ���ÿһ������ݶ�ֵ
%���ݶ�ֵ����-4*x+(��+��+��+�ң�������ѭ���߽磬���ϵ���=���£��������=�ң��Դ�����

function[grad]=laplacian(nx,ny,dx,dy)

format long;

nxny=nx*ny; %total number of grid points in the simulation cell

r=zeros(1,nx);
r(1:2)=[2,-1];
T=toeplitz(r);

E=speye(nx); %����һ��nx*nx�ĶԽ���Ϊ1��ϡ������

grad=-(kron(T,E)+kron(E,T));
%Kron��ΪKronecker����X,Y��Kron��Ϊ��
%X11*Y X12*Y .....X1N*Y
%X21*Y X22*Y .....X2N*Y
%......
%XN1*Y XN2*Y .....XNN*Y

%-- for periodic boundaries

for i=1:nx
    ii=(i-1)*nx+1;
    jj=ii+nx-1;
    grad(ii,jj)=1.0;
    grad(jj,ii)=1.0;
    
    kk=nxny-nx+i;
    grad(i,kk)=1.0;
    grad(kk,i)=1.0;
end

grad=grad/(dx*dy);

end
