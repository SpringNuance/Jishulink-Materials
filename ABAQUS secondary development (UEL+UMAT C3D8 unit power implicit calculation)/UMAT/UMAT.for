      SUBROUTINE UMAT(STRESS,STATEV,DDSDDE,SSE,SPD,SCD,
     1 RPL,DDSDDT,DRPLDE,DRPLDT,
     2 STRAN,DSTRAN,TIME,DTIME,TEMP,DTEMP,PREDEF,DPRED,CMNAME,
     3 NDI,NSHR,NTENS,NSTATV,PROPS,NPROPS,COORDS,DROT,PNEWDT,
     4 CELENT,DFGRD0,DFGRD1,NOEL,NPT,LAYER,KSPT,JSTEP,KINC)
C
      INCLUDE 'ABA_PARAM.INC'
C
      CHARACTER*80 CMNAME
      DIMENSION STRESS(NTENS),STATEV(NSTATV),
     1 DDSDDE(NTENS,NTENS),DDSDDT(NTENS),DRPLDE(NTENS),
     2 STRAN(NTENS),DSTRAN(NTENS),TIME(2),PREDEF(1),DPRED(1),
     3 PROPS(NPROPS),COORDS(3),DROT(3,3),DFGRD0(3,3),DFGRD1(3,3),
     4 JSTEP(4)

      DIMENSION STRE(6),STRA(6),DSTRA(6)

C     abaqus, in accordance with the provisions of elasticity, takes
C     pull as positive; Soil mechanics usually uses push as a 
C     positive, so switch signs
      DO K1=1,6
          STRE(K1)=-STRESS(K1)
          STRA(K1)=-STRAN(K1)
          DSTRA(K1)=-DSTRAN(K1)
      END DO
C     properties set
      EMOD=PROPS(1)
      ENU=PROPS(2)

C     get Elastic stiffness matrix
      CALL ELSMTX(EMOD,ENU,DDSDDE)

C     Renewal stress
      CALL NEWSTR(DDSDDE,DSTRA,STRE)
      
C     Switch signs back
      DO K1=1,6
          STRESS(K1)=-STRE(K1)
          STRAN(K1)=-STRA(K1)
          DSTRAN(K1)=-DSTRA(K1)
      END DO
C     -------------------------------------------------------------
      STATEV(1:6)=STRAN+dstran
      write(6,*)stran
      STATEV(7:12)=STRESS
      
      RETURN
      END
      

CCC   **************************************************************
C     subroutine function 
CCC   **************************************************************

CCC   **************************************************************
C     1. get Elastic stiffness matrix 
CCC   **************************************************************
      SUBROUTINE ELSMTX(EMOD,ENU,DDSDDE)
C     -------------------------------------------------------------
C     EMOD-intent(in)-elastic model
C     ENU-intent(in)-Poisson's ratio
C     DDSDDE(6,6)-intent(inout)-Elastic stiffness matrix[De]

C     Local variable(Implicit)
C     BK！！bulk model K
C     G！！shear model G
C     -------------------------------------------------------------     
      INCLUDE 'ABA_PARAM.INC'
      DIMENSION DDSDDE(6,6)

      BK=EMOD/(3.0D0*(1.0D0-2.0D0*ENU))
      G=EMOD/(2.0D0*(1.0D0+ENU))
      DO K1=1,6
          DO K2=1,6
              DDSDDE(K2,K1)=0.0
          END DO
      END DO
      DO K1=1,3
          DO K2=1,3
              DDSDDE(K2,K1)=BK-2.0D0/3.0D0*G
          END DO
          DDSDDE(K1,K1)=BK+4.0D0/3.0D0*G
      END DO
      DO K1=4,6
          DDSDDE(K1,K1)=G
      END DO
      
      END

CCC   **************************************************************
C     2. Renewal stress 
CCC   **************************************************************
      SUBROUTINE NEWSTR(DDSDDE,DSTRA,STRE)
C     -------------------------------------------------------------
C     DDSDDE(6,6)-intent(in)-Elastic stiffness matrix[De]
C     DSTRA(6)-intent(in)-strain increment
C     STRE(6)-intent(inout)-Stress

C     Local variable
C     K1,K2！！counting variable
C     -------------------------------------------------------------     
      INCLUDE 'ABA_PARAM.INC'
      DIMENSION DDSDDE(6,6),DSTRA(6),STRE(6)

      DO K1=1,6
          DO K2=1,6
              STRE(K2)= STRE(K2)+DDSDDE(K2,K1)*DSTRA(K1)
          END DO
      END DO
      END