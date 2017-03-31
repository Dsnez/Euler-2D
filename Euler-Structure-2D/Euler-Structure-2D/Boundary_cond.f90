subroutine Boundary_cond    !����ȷ�����������е��غ�ֵ
    implicit none
    integer::i,j
    real(kind=8)::R1,R2,R3,R4                  !4��Rimma������
    real(kind=8)::u_w,v_w,p_w                  !�߽紦��ʱԭʼ��
    real(kind=8)::rou_w,rouU_w,rouV_w,rouE_w   !�߽紦��ʱ�غ���
    real(kind=8)::Ue,Ve,pe,roue,qne,qte,ae,Se  !Rimma�����������ڳ��õ�����
    real(kind=8)::qn_inf,qt_inf,a_inf,S_inf    !Rimma�����������ⳡ�õ�����
    real(kind=8)::qn,qt,a,S
    
    write(*,*)  "Boundary_cond"
    !**************************************************
    !����߽�(������)
    !������
    do i=(imax-airfoil_num)/2+1,(imax+airfoil_num)/2+1  
      !���治�ɴ�͸��������ʱ����ͨ��ֻ��ѹ����
      !ѹǿ��Ҫ����
      p_w=0.5*(3*p(i,2)-p(i,3))    !����ͨ��ʱ����ѹ����
      rou_w=0.5*(3*rou(i,2)-rou(i,3))    !����ͨ��ʱ����ѹ����
      p(i,1)=p_w 
      rou(i,1)=rou_w 
      u(i,1)=-u(i,2)     !��֤����߽��Ϸ����ٶ�Ϊ�㣡������������������Ҫ��ϸ���ǣ��˹�ճ�ԡ�����ʱ�䲽�����õ���
      v(i,1)=-v(i,2) 
      
      W(i,1,:)=2.0*W(i,2,:)-W(i,3,:)          
      W(i,0,:)=3.0*W(i,2,:)-2.0*W(i,3,:)  
    end do 
           
 
    !��������
    !��������Ϊ�ԳƱ߽����ʵ����
    do i=2,(imax-airfoil_num)/2
        
      u(i,1)=u(imax-i+2,2)
      v(i,1)=v(imax-i+2,2)
      p(i,1)=p(imax-i+2,2)
      rou(i,1)=rou(imax-i+2,2)
      W(i,1,:)=W(imax-i+2,2,:)
      W(i,0,:)=W(imax-i+2,3,:)
      
      u(imax-i+2,1)=u(i,2)
      v(imax-i+2,1)=v(i,2)
      p(imax-i+2,1)=p(i,2)
      rou(imax-i+2,1)=rou(i,2)
      W(imax-i+2,1,:)=W(i,2,:)
      W(imax-i+2,0,:)=W(i,3,:)
    end do
    !*********************************************
    !��ڱ߽�
    !����Rimman��������������������
    do i=2,imax
      !****************************** 
      !R3
      Ue=0.5*(3*u(i,jmax)-u(i,jmax-1))
      Ve=0.5*(3*v(i,jmax)-v(i,jmax-1))
      pe=0.5*(3*p(i,jmax)-p(i,jmax-1))
      roue=0.5*(3*rou(i,jmax)-rou(i,jmax-1))
      
      qne=( Ue*vector1(1,i,jmax+1)+Ve*vector1(2,i,jmax+1) )/ds1(i,jmax+1)
1     qne=-qne  
      ae=sqrt(pe*gamma/roue)
      R3=qne-2*ae/(gamma-1)
      !************************************
      !R4
      qn_inf=( u_inf*vector1(1,i,jmax+1)+v_inf*vector1(2,i,jmax+1) )/ds1(i,jmax+1)
2     qn_inf=-qn_inf 
      a_inf=sqrt(p_inf*gamma/rou_inf)
      R4=qn_inf+2*a_inf/(gamma-1)
      !************************************* 
      !R1
3      qt_inf=( u_inf*vector1(2,i,jmax+1)-v_inf*vector1(1,i,jmax+1) )/ds1(i,jmax+1)
      R1=qt_inf
      !***********************
      !R2
      S_inf=p_inf/rou_inf**gamma
      R2=S_inf
      !********************************
      !����������ϵ�ԭʼ���Լ�����������غ���
      qn=0.5*(R3+R4)
      qt=R1
      a=(gamma-1.0)/4.0*(R4-R3)
      S=R2
      
     ! u_w=u_inf  -  (qn_inf-qn)*vector1(1,i,jmax+1)/ds1(i,jmax+1)
     ! v_w=v_inf  -  (qn_inf-qn)*vector1(2,i,jmax+1)/ds1(i,jmax+1)
11      u_w=u_inf  +  (qn_inf-qn)*vector1(1,i,jmax+1)/ds1(i,jmax+1)
      v_w=v_inf  +  (qn_inf-qn)*vector1(2,i,jmax+1)/ds1(i,jmax+1)
   !   u_w=( qn*vector1(1,i,jmax+1)+qt*vector1(2,i,jmax+1) ) / (vector1(1,i,jmax+1)**2 +vector1(2,i,jmax+1)**2) * ds1(i,jmax+1)
   !   v_w=( qn*vector1(2,i,jmax+1)-qt*vector1(1,i,jmax+1) ) / (vector1(2,i,jmax+1)**2 -vector1(1,i,jmax+1)**2) * ds1(i,jmax+1)
    
      rou_w=( a**2/(gamma*S) )**( 1/(gamma-1) )
      p_w=S*rou_w**gamma
      
      u(i,jmax+1)=u_w
      v(i,jmax+1)=v_w
      p(i,jmax+1)=p_w
      rou(i,jmax+1)=rou_w
      
      W(i,jmax+1:jmax+2,1)=rou_w
      W(i,jmax+1:jmax+2,2)=rou_w*u_w
      W(i,jmax+1:jmax+2,3)=rou_w*v_w
      W(i,jmax+1:jmax+2,5)=p_w/(gamma-1)+rou_w*(u_w**2+v_w**2)/2
    end do
    !*************************************************
     !���ڱ߽�
    !����Rimman��������������������
    !i=2 �߽�
    do j=2,jmax
      !******************************  
      !R4
      qn_inf=( u_inf*vector2(1,2,j)+v_inf*vector2(2,2,j) )/ds2(2,j)
4      qn_inf=-qn_inf
      a_inf=sqrt(p_inf*gamma/rou_inf)
      R4=qn_inf+2*a_inf/(gamma-1)
      !************************************* 
      !R3
      Ue=0.5*(3*u(2,j)-u(3,j))
      Ve=0.5*(3*v(2,j)-v(3,j))
      pe=0.5*(3*p(2,j)-p(3,j))
      roue=0.5*(3*rou(2,j)-rou(3,j))
      qne=( Ue*vector2(1,2,j)+Ve*vector2(2,2,j) )/ds2(2,j)
5      qne=-qne
      ae=sqrt(pe*gamma/roue)
      R3=qne-2*ae/(gamma-1)
      !************************************
      !R1
6      qte=( Ue*vector2(2,2,j) - Ve*vector2(2,2,j) )/ds2(2,j)
      R1=qte
      !***********************
      !R2
      Se=pe/roue**gamma
      R2=Se
      !********************************
      !����������ϵ�ԭʼ���Լ�����������غ���
      qn=0.5*(R3+R4)
      qt=R1
      a=(gamma-1)/4*(R4-R3)
      S=R2
      !u_w=Ue  +  (qn -qne)*vector2(1,2,j)/ds2(2,j)
      !v_w=Ve  +  (qn -qne)*vector2(2,2,j)/ds2(2,j)
12    u_w=Ue  -  (qn -qne)*vector2(1,2,j)/ds2(2,j)
      v_w=Ve  -  (qn -qne)*vector2(2,2,j)/ds2(2,j)
      !u_w=( qn*vector2(1,2,j)+qt*vector2(2,2,j) ) / (vector2(1,2,j)**2 +vector2(2,2,j)**2) * ds2(2,j)
      !v_w=( qn*vector2(2,2,j)-qt*vector2(1,2,j) ) / (vector2(2,2,j)**2 -vector2(1,2,j)**2) * ds2(2,j)
      rou_w=( a**2/(gamma*S) )**( 1/(gamma-1) )
      p_w=S*rou_w**gamma
      
      u(1,j)=u_w
      v(1,j)=v_w
      p(1,j)=p_w
      rou(1,j)=rou_w
      
      W(0:1,j,1)=rou_w
      W(0:1,j,2)=rou_w*u_w
      W(0:1,j,3)=rou_w*v_w
      W(0:1,j,5)=p_w/(gamma-1)+rou_w*(u_w**2+v_w**2)/2
    end do
    !i=imax+1�߽�
    do j=2,jmax
      !******************************  
      !R4
7     qn_inf=( u_inf*vector2(1,imax+1,j)+v_inf*vector2(2,imax+1,j) )/ds2(imax+1,j)
      qn_inf=-qn_inf
      a_inf=sqrt(p_inf*gamma/rou_inf)
      R4=qn_inf+2*a_inf/(gamma-1)
      !************************************* 
      !R3
      Ue=0.5*(3*u(imax,j)-u(imax-1,j))
      Ve=0.5*(3*v(imax,j)-v(imax-1,j))
      pe=0.5*(3*p(imax,j)-p(imax-1,j))
      roue=0.5*(3*rou(imax,j)-rou(imax-1,j))
      qne=( Ue*vector2(1,imax+1,j)+Ve*vector2(2,imax+1,j))/ds2(imax+1,j)
8      qne=-qne
      ae=sqrt(pe*gamma/roue)
      R3=qne-2*ae/(gamma-1)
      !************************************
      !R1
      qte=( Ue*vector2(2,imax+1,j) - Ve*vector2(2,imax+1,j) )/ds2(imax+1,j)
      R1=qte
      !***********************
      !R2
      Se=pe/roue**gamma
      R2=Se
      !********************************
      !����������ϵ�ԭʼ���Լ�����������غ���
      qn=0.5*(R3+R4)
      qt=R1
      a=(gamma-1)/4*(R4-R3)
      S=R2
      
      !u_w=Ue  +  (qn -qne)*vector2(1,imax+1,j)/ds2(imax+1,j)
      !v_w=Ve  +  (qn -qne)*vector2(2,imax+1,j)/ds2(imax+1,j)
13      u_w=Ue  -  (qn -qne)*vector2(1,imax+1,j)/ds2(imax+1,j)
      v_w=Ve  -  (qn -qne)*vector2(2,imax+1,j)/ds2(imax+1,j)
      !u_w=( qn*vector2(1,imax+1,j)+qt*vector1(2,imax+1,j) ) / (vector2(1,imax+1,j)**2 +vector2(2,imax+1,j)**2) * ds2(imax+1,j)
      !v_w=( qn*vector2(2,imax+1,j)-qt*vector1(1,imax+1,j) ) / (vector2(2,imax+1,j)**2 -vector2(1,imax+1,j)**2) * ds2(imax+1,j)
      rou_w=( a**2/(gamma*S) )**( 1/(gamma-1) )
      p_w=S*rou_w**gamma
      
      u(imax+1,j)=u_w
      v(imax+1,j)=v_w
      p(imax+1,j)=p_w
      rou(imax+1,j)=rou_w
     
      W(imax+1:imax+2,j,1)=rou_w
      W(imax+1:imax+2,j,2)=rou_w*u_w
      W(imax+1:imax+2,j,3)=rou_w*v_w
      W(imax+1:imax+2,j,5)=p_w/(gamma-1)+rou_w*(u_w**2+v_w**2)/2
    end do
end subroutine