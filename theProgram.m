%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Phase Field Finite Difference %
%           Code For            %
%   Dendritic Crystallization   %
%   Optimized For Matlab        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%== get initial wall time: (format long:��ʾ15λ˫����)
time0=clock();
format long;

%-- Simulation cell parameters:
Nx=300;     %x�����
Ny=300;     %y�����
NxNy=Nx*Ny;

dx=0.03;    %grid spacing between two grid points in the x-direction
dy=0.03;    %grid spacing between two grid points in the x-direction  

%-- Time integration parameters:

nstep=4000;     % time integration seps
nprint=50;      % Output frequency to write the results to file
dtime=1.e-4;    % Time increment for numerical integration

%-- Material specific parameters:

tau=0.0003;      % ��
epsilonb=0.01;   % �Ű�
mu=1.0;          % ��
kappa=1.8;       % ��
delta=0.02;      % ��
aniso=6.0;       % j
alpha=0.9;       % ��
gamma=10.0;      % ��
teq=1.0;         % Teq
theta0=0.2;      % ��0
seed=5.0;        % The size of the initial seed (In grid numbers) 
                 % See function nucleus
pix=4.0*atan(1.0);  % The value of pi

%--- Initialize and introduce initial nuclei;

[phi,tempr]=nucleus(Nx,Ny,seed);
% Initialize the phi and temper arrays and introduce the seed in center
%--- Laplacian templet

[laplacian]=laplacian(Nx,Ny,dx,dy);
%Calculate the finite difference template for the laplacians

%-- Evolution, calculate Eqs4.51 and Eqs4.52
%--

for istep=1:nstep
    
    phiold=phi; %���ȶ�����phi_old��phi����ȵ�
    
    %--
    % calculate the laplacians and epsilon:
    %--
    
    phi2=reshape(phi',NxNy,1); %��phi(Nx,Ny)ת����һά����phi2(Nx*Ny)��phi'Ϊphi��ת�ã�ֻ
                               %ֻ��ת�ú������ȷ�ذ��յ�һ�С��ڶ��е�˳�����reshape
    lap_phi2=laplacian*phi2;   %����phi2��������˹ֵ��?2��
    
    [lap_phi]=vec2matx(lap_phi2,Nx);    %��lap_phi2(Nx*Ny��ת������ά����lap_phi(Nx,Ny)
    
    %--
    
    tempx=reshape(tempr',NxNy,1); %��tempr(Nx,Ny)ת��Ϊһά����tempx(NxNy)
    
    lap_tempx=laplacian*tempx; %����?2T
    
    [lap_tempr]=vec2matx(lap_tempx,Nx); %��lap_tempx(Nx*Ny)ת��Ϊ��ά����lap_tempr(Nx,Ny)
    
    %--gradients of phi:
    
    [phidy,phidx]=gradient_mat(phi,Nx,Ny,dx,dy); %����Cartesian derivatives of phi,?��
    %һά�����ϵ��ݶȣ��������˱߽������Լ�������dx��dy
    %calculate angle:
    
    theta=atan2(phidy,phidx); %calculate theta:��=tan-1(��y/��x)
    %�����atan2�Ƕ�����(-��,��)�ϵģ������theta��һ������
    %--epsilon and its derivative:
    
    epsilon=epsilonb*(1.0+delta*cos(aniso*(theta-theta0))); %calculate ��,����һ������
    
    epsilon_deriv=-epsilonb*aniso*delta*sin(aniso.*(theta-theta0));
    %calculate ?��/?��  .*ָ������������Ķ�ӦԪ����ˣ�aij*bij,�����Ǿ���˷�������һ������
    %--- first term of Eq.4.51 �����һ��
    
    dummyx=epsilon.*epsilon_deriv.*phidx;
    
    [term1,dummy]=gradient_mat(dummyx,Nx,Ny,dx,dy);
    
    %--- second term of Eq.4.51 ����ڶ���
    
    dummyy=-epsilon.*epsilon_deriv.*phidy;
    
    [dummy,term2]=gradient_mat(dummyy,Nx,Ny,dx,dy);
    
    %--- factor m:
    
    m=(alpha/pix)*atan(gamma*(teq-tempr));
    
    %-- Time integration:
    
    phi=phi+(dtime/tau)*(term1+term2+epsilon.^2.*lap_phi+...
        phiold.*(1.0-phiold).*(phiold-0.5+m));
    
    %-- evolve temperature:
    
    tempr=tempr+dtime*lap_tempr+kappa*(phi-phiold);
    
    
    %---- print results
    
    
    if(mod(istep,nprint)==0)
        
        fprintf('done step: %5d\n',istep);
        
        fname1=sprintf('time_%d_phi.txt',istep);
        out1=fopen(fname1,'w');
        
        for i=1:Nx
            for j=1:Ny
             
                fprintf(out1,'%14.6e\n',phi(i,j));
            end
        end
        
        fname2=sprintf('time_%d_tempr.txt',istep);
        out2=fopen(fname2,'w');
        
        for i=1:Nx
            for j=1:Ny
             
                fprintf(out2,'%14.6e\n',tempr(i,j));
            end
        end
      
        
        %write_vtk_grid_values(Nx,Ny,dx,dy,istep,phi,tempr);
        
    end
end

%calculate compute time:

compute_time=etime(clock(),time0);
fprintf('Compute Time: %10d\n',compute_time);

    
    
    
    
    
    
    
    
    


