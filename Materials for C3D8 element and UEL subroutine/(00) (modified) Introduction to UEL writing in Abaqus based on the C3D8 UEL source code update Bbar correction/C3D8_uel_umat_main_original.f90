include "C3D8_uel_pack.f90" 

subroutine uel(rhs,amatrx,svars,energy,ndofel,nrhs,nsvars,                  &
                props,nprops,coords,mcrd,nnode,u,du,v,a,jtype,time,dtime,   &
                kstep,kinc,jelem,params,ndload,jdltyp,adlmag,predef,npredf, &
                lflags,mlvarx,ddlmag,mdload,pnewdt,jprops,njprop,period)

    use C3D8_uel_pack

    include 'aba_param.inc'

    dimension   rhs(mlvarx,*),amatrx(ndofel,ndofel),props(*),               &
                svars(*),energy(8),coords(mcrd,nnode),u(ndofel),            &
                du(mlvarx,*),v(ndofel),a(ndofel),time(2),params(*),         &
                jdltyp(mdload,*),adlmag(mdload,*),ddlmag(mdload,*),         &
                predef(2,npredf,nnode),lflags(*),jprops(*)
    


    ! **************************************************************
    ! 使用umat进行结果可视化
    REAL*8 UVAR(NELEMENT,NSVINT, NGAUSS)
    INTEGER JELEM,K1,K2,KINTK
    COMMON/KUSER/UVAR
    ! **************************************************************
    
    real(8) :: E
    real(8) :: nu
    real(8) :: Ke(24,24)
    real(8) :: fint(24)
    integer :: i

    E  = props(1)
    nu = props(2)

    ! call uel
    call C3D8_uel(E,nu, coords, u, du, Ke, fint, svars)
    
    rhs(:,1) = -fint
    amatrx = Ke

    ! ! 输出单元刚度矩阵
    ! do i = 1,24
    !     write(*,*) Ke(i,1:i)
    ! enddo

    ! **************************************************************
    ! for visualization
    DO KINTK = 1,NGAUSS !对高斯积分点进行循环
        DO K1=1,NSVINT  !对每个高斯积分点上的状态变量进行循环
            UVAR(JELEM,K1,KINTK) = SVARS(NSVINT*(KINTK-1)+K1)
        END DO
    ENDDO
    ! **************************************************************

    return
end subroutine uel

! ******************************************************************
! umat进行可视化
subroutine umat(stress,statev,ddsdde,sse,spd,scd,                       &
                rpl,ddsddt,drplde,drpldt,                               &
                stran,dstran,time,dtime,temp,dtemp,predef,dpred,cmname, &
                ndi,nshr,ntens,nstatv,props,nprops,coords,drot,pnewdt,  &
                celent,dfgrd0,dfgrd1,noel,npt,layer,kspt,kstep,kinc)

    use C3D8_uel_pack

    include 'aba_param.inc'

    character*80 cmname
    dimension    stress(ntens),statev(nstatv),ddsdde(ntens,ntens),   &
                ddsddt(ntens),drplde(ntens),                        &
                stran(ntens),dstran(ntens),time(2),                 &
                predef(1),dpred(1),props(nprops),coords(3),         &
                drot(3,3),dfgrd0(3,3),dfgrd1(3,3)

    ! **************************************************************
    ! 可视化
    INTEGER NELEMAN, K1
    real(8) :: E,nu
    COMMON/KUSER/UVAR(NELEMENT,NSVINT, NGAUSS)
    NELEMAN=NOEL-NELEMENT

    DO K1=1,NSVINT
        STATEV(K1)=UVAR(NELEMAN,K1,NPT)
    END DO
    ! **************************************************************
    E = props(1)
    nu = props(2)

    ddsdde = C3D8_uel_compute_De(E,nu)
    stress = matmul(ddsdde,stran + dstran)
    
    return
end subroutine umat