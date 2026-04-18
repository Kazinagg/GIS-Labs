C         Serial version date:  5/23/2001
C
C       2/02/01 - Various Transport fixes
C       1/26/01 - Incomplete Choleski CG solver modified to avoid square roots.
C       1/24/01 - Duplicate x values in XY data sets flagged.
C       8/25/00 - Reversed rows and columns in CMATRX to speed memory access.
C       8/17/00 - Diagonal pre-conditioner conjugate gradient solver replaced Opton 2.
C       8/15/00 - Incomplete Cholesky conjugate gradient solver replaced Opton 3.
C       8/02/00 - Additional dynamic relaxation parameters added.
C       6/21/00 - Back-tracking updated.
C       6/12/00 - Velocity for tetrahedra fixed.
C       5/10/00 - Bug in subroutine FQ468 involving the variable ccc fixed.
c                 Only affects density dependent flow.
C       4/01/00 - Updated to V3.0 with following implementations:
C                  - Dynamic Relaxation Parameter (OMEF)
C                  - Summation and printing of Flux values at BC Nodes
C                  These were implemented by Fred Tracy in the || version
C                  and put into serial version by Cary Talbot
C       5/07/99 - Various I/O edits to comply w/ GMSv3.0 super files
C                 and cleanup of printed messages to terminal
C       5/20/98 - Revise nodal moisture content
C       2/28/97 - Make the sign consistent with GMS ( +, flow into the region,
C                 and -, flow out from the region)
C      12/31/96 - Add compressibilities of water and medium (alp,betap,por),and
C                 biodegradation option(kw,ks)
C      10/31/96 - Moisture content at the Gaussian poins will not be saved
C       7/31/96 - Modify working array for boundary condition and material
C                 types (more flexible)
C       3/31/96 - Output format is matched with GMS's new file format
C        3/1/96 - Delete steady transport simulation option
C       6/21/95 - Modify subroutine pwiss to symmetric successive
C                 relaxation scheme and increase computationaL
C                 efficiency
C               - Compute nd(np) in subroutine pagen if the
C                 pointwise iteration solver is used
C        8/6/94 - To add constraint on relative hydraulic conductivity
C
C ********************************************************************
C
C *                        FEMWATER v3.0.5
C
C ********************************************************************
C23456789012345678901234567890123456789012345678901234567890123456789012
C  YEH, G. T., J. R. Cheng, H.P. Cheng, F. Tracy
C       1994.  "FEMWATERT: A 3-DIMENSIONAL FINITE ELEMENT MODEL OF
C       DENSITY DEPENDENT FLOW AND TRANSPORT THROUGH SATURATED-
C       UNSATURATED MEDIA."  DEPARTMENT OF CIVIL ENGINEERING, PENN
C       STATE UNIVERSITY, UNIVERSITY PARK, PA 16802 AND WATERWAYS
C       EXPERIMENT STATION, U. S. CORPS OF ENGINEERS, VICKSBURG,
C       MS 39180-0631.
C
C
*     Date of last update is 23 May 2001
**********************************************************************
*
*   DESCRIPTION OF PARAMETERS
*
*       The list and definition of the control parameters required
*       for the model are given below:
*
*   MAXNPK = maximum number of nodes in the 3-D mesh
*   MAXELK = maximum number of element in the 3-D mesh
*   MXBESK = maximum number of boundary-element surfaces
*   MXBNPK = maximum number of nodal points at the boundary
*   MXJBDK = maximum number of element for node connectivity
*   MXKBDK = maximum number of element for element connectivity
C
*   Material and Soil Properries
*
*   MXMATK = maximum number of soil types
*   MXSPMK = maximum number of data points to describe soil
*            characteristic curve in unsaturated zone
*   MXMPMK = maximum number of material properties per material
*           (hydraulic conductivity)
*   MXRMPK = maximum number for coefficients of the viscosity and
*      density functions
*
*    HEAD Boundary Conditions
*
*
*   For flow simulation:
*
*      MXDNPH = maximum number of head nodal points
*      MXDPRH = maximum number of head profiles
*      MXDDPH = maximum number of data points on each profile
*
*   For transport simulation:
*
*      MXDNPC = maximum number of concentration nodal points
*      MXDPRC = maximum number of concentration profiles
*      MXDDPC = maximum number of data points on each profile
*
*      NXG = maximum number of grids for element tracking in
*            x-direction
*      NYG = maximum number of grids for element tracking in
*            y-direction
*      NZG = maximum number of grids for element tracking in
*         z-direction
*
*     FLUX Boundary Conditions
*
*
*   1.   Cauchy flux boundary condition:
*
*      For flow simulations:
*
*         MXCNPH = maximum number of flux nodal points
*         MXCESH = maximum number of flux element surfaces
*         MXCPRH = maximum number of flux rate profiles
*         MXCDPH = maximum number of data points on each flux rate
*                  profile
*
*      For transport simulations:
*
*         MXCNPC = maximum number of nodal points for
*                  concentration
*         MXCESC = maximum number of element surfaces for
*                  concentration
*         MXCPRC = maximum number of concentration profiles
*         MXCDPC = maximum number of data points on each
*                  concentration profile
*
*   2   Neumann flux boundary condition:
*
*         For flow simulations:
*
*            MXNNPH = maximum number of flux nodal points
*            MXNESH = maximum number of flux element
*                    surfaces
*            MXNPRH = maximum number of fluxrate  profiles
*            MXNDPH = maximum number of data points on
*                     each flux rate profile
*
*         For transport simulations:
*
*            MXNNPC = maximum number of nodal points for
*                    concentration
*            MXNESC = maximum number of element surfaces
*                    for flux rate
*            MXNPRC = maximum number of concentration
*                     profiles
*            MXNDPC = maximum number of data points on
*                     each flux rate profile
*
*  Rainfall-Seepage Boundary Conditions
*
*
*   For flow simulations:
*
*      MXVNPH = maximum number of ground nodal points
*      MXVESH = maximum number of ground element surfaces
*      MXVPRH = maximum number of rainfall-seepage profile
*      MXVDPH = maximum number of data points on each rainfall-
*                seepage profile
*
*
*   For transport simulations:
*
*      MXVNPC = maximum number of ground nodal points
*      MXVESC = maximum number of ground element surfaces
*      MXVPRC = maximum number of rainfall-seepage profile
*      MXVDPC = maximum number of data points on each rainfall-
*               seepage profile
*
*    Source/Sink Boundary Conditions
*
*
*   For flow simulations:
*
*      MXWNPH = maximum number of well nodal points
*      MXWPRH = maximum number of well source/sink profiles
*      MXWDPH = maximum number of data points on each well
*             source/sink profile
*
*   For transport simulations:
*
*      MXWNPC = maximum number of well nodal points for
*              concentration
*      MXWPRC = maximum number of well source/sink profiles
*              for concentration
*      MXWDPC = maximum number of data points on each well
*             source/sink profile
*   The FEMWATER program is limited to allow NX*NY*NZ nodes.
*   There are NX nodes along the x-direction, NY nodes along
*   the y-direction, and NZ nodes along the z-direction.
*
********
C
C
C
C
C
C
C
      PROGRAM FEMWATER       
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      CHARACTER ARG1 * 80
      REAL*4 SS
C
      INCLUDE 'gwpara.inc'
C
C ------- COMMON BLOCK FOR BOTH FLOW AND TRANSPORT
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /TSTEP/ NTI,NTIF,NTIT
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /PCG/ GG,IEIGEN
      COMMON /IP1/ OMEFTT,NITFTT
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
C ------- COMMON BLOCK FOR FLOW ITERATION AND MATERIAL CONTROL
C
      COMMON /FINTE/ NCYLF,NITERF,NPITERF,KSP,KGRAV,IPNTSF
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
C
C ------- COMMON BLOCK FOR TRANSPORT ITERATION AND MATERIAL CONTROL
C
      COMMON /TINTE/ NCMT,NITERT,NPITERT,IPNTST
      COMMON /TREAL/ OMET,OMIT,TOLBT
C
C ------- COMMON BLOCK FOR FLOW AND TRANSPORT SOURCE/SINK
C
      COMMON /FPS/ NWNPF,NWPRF,NWDPF(MXWPRH)
      COMMON /BLKPSF/ WSSF(MXWPRH),WSSFF(MXWDPH,MXWPRH),
     1               TWSSFF(MXWDPH,MXWPRH),IWTYPF(MXWNPH),
     2               NPWF(MXWNPH),JWTYPF(MXWNPH)
      COMMON /TPS/ NWNPT,NWPRT,NWDPT(MXWPRC)
      COMMON /BLKPST/ WSST(MXWPRC),WSSFT(MXWDPC,MXWPRC),
     1               TWSSFT(MXWDPC,MXWPRC),IWTYPT(MXWNPC),
     2               NPWT(MXWNPC),JWTYPT(MXWNPC)
C
C ------- COMMON BLOCK FOR FLOW BOUNDARY CONDITIONS
C
      COMMON /FDBC/ NDNPF,NDPRF,NDDPF(MXDPRH)
      COMMON /FCBC/ NCESF,NCNPF,NCPRF,NCDPF(MXCPRH)
      COMMON /FVBC/ NVESF,NVNPF,NVPRF,NVDPF(MXVPRH)
      COMMON /FNBC/ NNESF,NNNPF,NNPRF,NNDPF(MXNPRH)
      COMMON /FRBC/ NRESF,NRNPF,NRPRF,NRDPF(MXRPRH),NRMAF
C
      COMMON /BLKDBF/ HDBF(MXDPRH),HDBFF(MXDDPH,MXDPRH),
     1        THDBFF(MXDDPH,MXDPRH),IDTYPF(MXDNPH),NPDBF(MXDNPH),
     2        JDTYPF(MXDNPH)
      COMMON /BLKCBF/ QCBF(MXCPRH),QCBFF(MXCDPH,MXCPRH),
     1        TQCBFF(MXCDPH,MXCPRH),ICTYPF(MXCESH),ISCF(5,MXCESH),
     2        NPCBF(MXCNPH),IDCF(MXCESH),JCTYPF(MXCESH)
      COMMON /BLKVBF/ QVBF(MXVPRH),QVBFF(MXVDPH,MXVPRH),
     1        TQVBFF(MXVDPH,MXVPRH),IVTYPF(MXVESH),ISVF(5,MXVESH),
     2        NPVBF(MXVNPH),IDVF(MXVESH),JVTYPF(MXVESH)
      COMMON /BLKNBF/ QNBF(MXNPRH),QNBFF(MXNDPH,MXNPRH),
     1        TQNBFF(MXNDPH,MXNPRH),INTYPF(MXNESH),ISNF(5,MXNESH),
     2        NPNBF(MXNNPH),IDNF(MXNESH),JNTYPF(MXNESH)
      COMMON /BLKRBF/ HRBF(MXRPRH),HRBFF(MXRDPH,MXRPRH),
     1        THRBFF(MXRDPH,MXRPRH),IRTYPF(MXRNPH),NPRBF(MXRNPH),
     2        ISRF(6,MXRESH),PRORF(2,MXRESH),IDRF(MXRESH),NRBEF(MXRESH),
     3        IRMTYP(MXRMAH),JRTYPF(MXRNPH)
C
C ------- COMMON BLOCK FOR TRANSPORT BOUNDARY CONDITIONS
C
      COMMON /TDBC/ NDNPT,NDPRT,NDDPT(MXDPRC)
      COMMON /TCBC/ NCEST,NCNPT,NCPRT,NCDPT(MXCPRC)
      COMMON /TVBC/ NVEST,NVNPT,NVPRT,NVDPT(MXVPRC)
      COMMON /TNBC/ NNEST,NNNPT,NNPRT,NNDPT(MXNPRC)
C
      COMMON /BLKDBT/ CDBT(MXDPRC),CDBFT(MXDDPC,MXDPRC),
     1        TCDBFT(MXDDPC,MXDPRC),IDTYPT(MXDNPC),
     2        NPDBT(MXDNPC),JDTYPT(MXDNPC)
      COMMON /BLKCBT/ QCBT(MXCPRC),QCBFT(MXCDPC,MXCPRC),
     1        TQCBFT(MXCDPC,MXCPRC),ICTYPT(MXCESC),ISCT(5,MXCESC),
     2        NPCBT(MXCNPC),IDCT(MXCESC),JCTYPT(MXCESC)
      COMMON /BLKVBT/ CVBT(MXVPRC),CVBFT(MXVDPC,MXVPRC),
     1        TCVBFT(MXVDPC,MXVPRC),IVTYPT(MXVESC),ISVT(5,MXVESC),
     2        NPVBT(MXVNPC),IDVT(MXVESC),JVTYPT(MXVESC)
      COMMON /BLKNBT/ QNBT(MXNPRC),QNBFT(MXNDPC,MXNPRC),
     1        TQNBFT(MXNDPC,MXNPRC),INTYPT(MXNESC),ISNT(5,MXNESC),
     2        NPNBT(MXNNPC),IDNT(MXNESC),JNTYPT(MXNESC)
C
      COMMON /SAZFM/ NXW,NYW,NZW,IDETQ
C
C ------- COMMON BLOCK FOR FLOW MATERIAL BALANCE
C
      COMMON /FFLOW/ FRATEF(11),FLOWF(11),TFLOWF(11)
      COMMON /TFLOW/ FRATET(14),FLOWT(14),TFLOWT(14)
      COMMON /FFLUX/ FFLXB(MAXNPK), SUMPRV
      COMMON /TFLUX/ TFLXB(MAXNPK)
C
C ------- ADVECTION WEIGHTING FACTORS
C
      COMMON /WETX/ APHA1,APHA2,APHA3,APHA4
      COMMON /WETY/ BETA1,BETA2,BETA3,BETA4
      COMMON /WETZ/ GAMA1,GAMA2,GAMA3,GAMA4
C
      COMMON /SPCARD/ NUNSAT,NSP(MXMATK),IHM(MXMATK),IHC(MXMATK),
     1       IHW(MXMATK),NPMC(MXMATK),NPCON(MXMATK),NPWC(MXMATK)
      COMMON /RSCBBL/ NVTMPF(MXRSCB),NVTMPT(MXRSCB),NCTMPF(MXRSCB),
     1   NCTMPT(MXRSCB),NBTMPF(MXRSCB),NBTMPT(MXRSCB),KTEMP(KTMP)
C
      COMMON /XYCARD/ NTXY,NXY(MXXYS),NPOINT(MXXYS)
      COMMON /RSCARD/ VBFCNT,VBCCNT,HCON,HMIN,JVFCNT,JVCCNT
      COMMON /TEST/ TS(MXXYP,MXXYS),TVALUE(MXXYP,MXXYS)
C
      COMMON /TCCARD/ IUNIT,JOPT,KOPT,IFILE,NPRINT,NPOST,
     1                ICFILE,IVFILE,PTIMES(MXPOST),POTIME(MXPOST)
      COMMON /ICCARD/ JICH,JICV,JICC,JICM,JIBF,JIBT,
     1               JPH,JCN,JVL,JMN,JMC,JBF,JBT
      COMMON /FTFILE/ KPH,KCN,KVL,KMC,KBF,KBT,JFILE,KFILE
      COMMON /TC2/ IDT,IDTXY,NDT
      COMMON /TC21/ TIMEL(MXDTCK),DELTAT(MXDTCK)
      COMMON /UNSAT/ PH(MXSPMK,MXMATK),PMC(MXSPMK,MXMATK),
     1               PCON(MXSPMK,MXMATK),CONDUC(MXSPMK,MXMATK),
     2               PWC(MXSPMK,MXMATK),WC(MXSPMK,MXMATK),
     &               PMKNOT(MXSPMK + 4, MXMATK), PCKNOT(MXSPMK + 4,
     &               MXMATK), PWKNOT(MXSPMK + 4, MXMATK),
     &               PMCOEF(MXSPMK, MXMATK), PCCOEF(MXSPMK, MXMATK),
     &               PWCOEF(MXSPMK, MXMATK), IBSPL
      COMMON /TCONV/ NTY1(MXXYS),NTY2(MXXYS),NTY3(MXXYS),NTY4(MXXYS),
     1               NTY5(MXXYS),NTY6(MXXYS),NTY7(MXXYS),NTY8(MXXYS),
     2               NTY9(MXXYS),NTY10(MXXYS),NTY11(MXXYS),NTY12(MXXYS)
      COMMON /BLK1/ KGB(4,6,3)
      COMMON /BLK4/ OMEF1,OMET1,OMEFT1
C
C ------- ARRAYS FOR BOTH FLOW AND TRANSPORT
C
      COMMON /BLKFT1/LRN(MXJBDK,MAXNPK),LRL(MXKBDK,MAXNPK),NLRL(MAXNPK),
     1               ND(MAXNPK),NLRN(MAXNPK)
      COMMON /BLKFT2/ CMATRX(MXJBDK,MAXNPK),RI(MAXNPK),RL(MAXNPK),
     1                RLD(MAXNPK),SK(MAXNPK),RK(MAXNPK),PK(MAXNPK)
      COMMON /BLKFT3/ DCOSB(3,MXBESK),ISB(6,MXBESK),NPBB(MXBNPK),
     1                IB(MAXNPK)
      DIMENSION X(MAXNPK,3),IE(MAXELK,9)
C
C ------- ARRAYS FOR FLOW ONLY
C
      COMMON /BLKFL1/ H(MAXNPK),HP(MAXNPK),HW(MAXNPK),HT(MAXNPK)
      COMMON /BLKFL2/ V(MAXNPK,3),TH(8,MAXELK),DTH(8,MAXELK),
     1                AKHC(7,8,MAXELK)
      COMMON /BLKFL3/ BFLXF(MXBNPK,2),RSVAB(MXVNPH,4),PROPF(9,MXMATK),
     1                RHOMU(MXRMPK)
      DIMENSION NPCNV(MAXNPK),INDRS(MXVNPH,3)
C
C ------- ARRAYS FOR TRANSPORT ONLY
C
      COMMON /BLKTR1/ C(MAXNPK),CP(MAXNPK),CW(MAXNPK),CSTAR(MAXNPK),
     1                F(MAXNPK,3),DTI(MAXNPK)
      COMMON /BLKTR2/ BFLXT(MXBNPK,2),WETAB(12,MAXELK),VP(MAXNPK,3),
     1                THP(8,MAXELK),THN(MAXNPK,2),AKDC(6,8,MAXELK),
     2                VBAR(MAXNPK,3),PROPT(13,MXMATK)
C
      DIMENSION IBDY(MXTUBK),IWRK(MXBESK)
C
      WRITE(*,'(//,A)')' Welcome to the USACE-WES 3D Groundwater Model'
      WRITE(*,'(A,/)')'              FEMWATER v3.0 '
      WRITE(*,'(A,//)')' (Date of the last update is 23 May 2001)'
C
      SS = SECNDS(0.0)
      LGRN=1
      KSP=1
      KGRAV=1
      CNSTKR=1.0D-5
C
C ----- read input files
C
      NUMARGS = IARGC();
	IF (NUMARGS.GT.0) then
	  CALL GETARG(1, ARG1)
	ENDIF
      CALL FILES (ARG1,IE,X,PROPF,PROPT,RHOMU,RSVAB,
     1                        KMOD,IBUG,ICHNG,KCP)
C
      CALL GAUSS(X,IE)
C
      OMEF1 =  1.0D0-OMEF
      OMET1 =  1.0D0-OMET
      OMEFT1 = 1.0D0-OMEFTT
C
C ******* DATA SET 1: PROBLEM IDENTIFICATION AND DESCRIPTION
C
      WRITE(16,2001) KMOD,IBUG,ICHNG
C
C ******* DATA SET 2: OPTION PARAMETERS
C
      WRITE(16,2005) NITFTT,OMEFTT
      WRITE(16,2010) KSSF,KSST,ILUMP,IMID,IPNTSF,IPNTST,IQUAR
      WRITE(16,2020) KGRAV,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,OMERED,
     &  CNSTKR
      WRITE(16,2030) KSORP,LGRN
      WRITE(16,2040) OMET,OMIT
C
C ******* DATA SET 3: ITERATION PARAMETERS
C
      WRITE(16,2050) NITERF,NCYLF,NPITERF,TOLAF,TOLBF
      WRITE(16,2060) NITERT,NPITERT,TOLBT
C
C ******* DATA SET 4: TIME CONTROL PARAMETERS
C
      WRITE(16,2070) NTI
      WRITE(16,2080) TMAX
C
      WRITE(16,2100) (KPR0(I),I=1,NSELT)
      IF (JOPT.EQ.0) THEN
         WRITE(16,2110) KPRT
      ELSE
         WRITE(16,2111) (PTIMES(I),I=1,NPRINT)
      ENDIF
      IF (KOPT.EQ.0) THEN
         WRITE(16,2120) KDSK
      ELSE
         WRITE(16,2121) (POTIME(I),I=1,NPOST)
      ENDIF
C
      IF (IDT.EQ.0) THEN
         WRITE(16,2150) DELT
 2150 FORMAT(/5X,' TIME INCREMENT, DELT = ',1PD15.6)
      ELSEIF (IDT.EQ.1) THEN
         WRITE(16,2130)
 2130 FORMAT(5X,'SIMULATION TIME',5X,' DELT ',/)
         DO I=1,NDT
            WRITE(16,2140) TIMEL(I),DELTAT(I)
         ENDDO
 2140 FORMAT(5X,F15.2,5X,F6.2)
      ENDIF
C
C ******* DATA SETS 5 THROUGH 10: GEOMETRIC AND MATERIAL DATA
C
      CALL RDATIO (PROPF,RHOMU,PROPT,IE,KCP)
C
C ******* COMPUTE POINTER ARRAYS LRN,LRL
C
      CALL PAGEN (LRN,NLRN,LRL,NLRL,IE,ND)
C
C ******* IDENTIFY BOUNDARY ELEMENTS AND COMPUTE DIRECTIONAL COSINES
C
        CALL SURF(X,IE,LRL,NLRL, DCOSB,ISB,NPBB,LRN,NLRN)
C
C ----- PREAPRE IB ARRAY, THE INDEX OF BOUNDARY AT ALL NODAL POINTS
C
      DO I=1,NNP
         IB(I)=0
      ENDDO
      DO I=1,NBNP
         NI=NPBB(I)
         IB(NI)=5
      ENDDO
C
C ******* DATA SETS FOR SOURCE/SINK; FLOW AND TRANSPORT
C
      CALL FTSDAT
C
C ******* DATA SETS FOR BOUNDARY CONDITIONS; FLOW
C
      CALL FBCDAT (ISB,NPBB,RSVAB,IDTYPT)
C
C ******* DATA SETS FOR BOUNDARY CONDITIONS; TRANSPORT
C
      IF (KMOD.EQ.1 .OR. KMOD.EQ.11) THEN
          CALL TBCDAT (ISB,NPBB,IB)
      ENDIF
C
C ***** DATA SET 24:  PARAMETERS CONTROLLING TRACKING SCHEME
C
      IF (KMOD.EQ.1 .OR. KMOD.EQ.11) THEN
          WRITE(16,2200) NXW,NYW,NZW,IDETQ
      ENDIF
C
C ------- Check index number for all boundary conditions
C
      CALL CHKBC
C
C ------- Compute Jacobian of Boundary Surface Element
C
      CALL BSJAC(X,IE,ISB,ISCF,ISVF,ISNF,ISRF,ISCT,ISVT,ISNT)
C
C ------- PASS TO GWM3D
C
      CALL GWM3D (X,IE,IBDY,NPCNV,INDRS,
     1              KMOD,IBUG,ICHNG)
C
      SS = SECNDS(SS)
C
      CLOSE(23,STATUS='DELETE')
      CLOSE(24,STATUS='DELETE')
      CLOSE(25,STATUS='DELETE')
      CLOSE(26,STATUS='DELETE')
C
      SM=SS/60.0D0
      SH=SS/3600.0D0
      PRINT *, ' IT TOOK ',SS,' Seconds TO RUN'
      PRINT *,'  OR ',SM,' Minutes'
      PRINT *,'  OR ',SH,' Hours'
 9999 CONTINUE
       call stopfile  ! emrl jig
       STOP
 2001 FORMAT(5X,
     > ' INTEGER INDICATING THE SIMULATION MODES, KMOD . . . . .',I5/5X,
     > ' INTEGER INDICATING THE DIAGNOSTIC OUTPUT, IBUG . . . . ',I5/5X,
     > ' INTEGER INDICATING THE RAINFALL NODES BE PRINTED,ICHNG ',I5/)
 2005 FORMAT(5X,
     > ' NO. OF ITER. ALLOWED FOR HYDRO-TRANS ITERA, NITFTT. .',I5/5X,
     > ' RELAXATION FACTOR FOR HYDRO-TRANS ITER, OMEFTT . . . .',F5.2/)
 2010 FORMAT(///' *** OPTIONAL PARAMETERS (FLOW/TRANSPORT) ***'/5X,
     > ' FLOW STEADY-STATE I.C. CONTROL, KSSF . . . . . . . .',I5/5X,
     > ' TRANSPORT STEADY-STATE I.C. CONTROL, KSST. . . . . .',I5/5X,
     > ' LUMPING INDICATOR, ILUMP . . . . . . . . . . . . . .',I5/5X,
     > ' MID-DIFFERENCE INDICATOR, IMID . . . . . . . . . . .',I5/5X,
     > ' POINTWISE ITERATION INDICATOR FOR FLOW, IPNTSF . . .',I5/5X,
     > ' POINTWISE ITERATION INDICATOR FOR TRANSPORT, IPNTST.',I5/5X,
     > ' INDEX OF USING QUADRATURE FOR INTEGRATION, IQUAR . .',I5/)
 2020 FORMAT(/' *** OPTIONAL PARAMETERS (FLOW ONLY) ***'/5X,
     > ' GRAVITY CONTROL, KGRAV . . . . . . . . . . . . . ',I5/5X,
     > ' TIME-INTEGRATION PARAMETER, WF. . . . . . . . . .',1PD15.6/5X,
     > ' ITERATION PARAMETER FOR NONLINEAR EQUATION, OMEF.',1PD15.6/5X,
     > ' RELAXATION PARAMETER FOR MATRIX EQ. SOV., OMIF. .',1PD15.6/5X,
     > ' MIN. ITERATION PARAMETER FOR NONLIN. EQ., OMEMIN.',1PD15.6/5X,
     > ' MAX. ITERATION PARAMETER FOR NONLIN. EQ., OMEMAX.',1PD15.6/5X,
     > ' ADD. ITERATION PARAMETER FOR NONLIN. EQ., OMEADD.',1PD15.6/5X,
     > ' RED. ITERATION PARAMETER FOR NONLIN. EQ., OMERED.',1PD15.6/5X,
     > ' CONSTRAINT ON HYDRAULIC CONDUTIVITY, CNSTKR . . .',1PD15.6)
 2030 FORMAT(/' *** OPTIONAL PARAMETERS (TRANSPORT ONLY) ***'/5X,
     > 'SORPTION MODEL CONTROL, KSROP  . . . . . . . . . .',I5/5X,
     > 'LGRANGIAN INDICATOR, LGRN  . . . . . . . . . . . .',I5/)
 2040 FORMAT(1H ,//5X,
     3 'ITERATION PARAMETER FOR NONLINEAR EQUATION, OMET .',1PD15.6/5X,
     4 'RELAXATION PARAMETER FOR MATRIX EQUATION, OMIT . .',1PD15.6/)
 2050 FORMAT(/' **** ITERATION PARAMETERS (FLOW ONLY) ****'/5X,
     > ' NO. OF ITERATIONS PER CYCLE, NITERF. . . . . . . . .',I5/5X,
     > ' NO. OF CYCLES PER TIME STEP, NCYLF . . . . . . . . .',I5/5X,
     > ' NO. OF ITERATIONS ALLOWED FOR SOLVING MATRIX EQ  . .',I5/5X,
     > ' STEADY-STATE TOLERANCE, TOLAF . . . . . . . . . .',1PD15.6/5X,
     > ' TRANSIENT-STATE TOLERANCE, TOLBF. . . . . . . . .',1PD15.6/)
 2060 FORMAT(/' *** ITERATION PARAMETERS (TRANSPORT ONLY) ***'/5X,
     1 'NO. OF ITERATIONS FOR NONLINEAR EQUATION, NITERT .',I5/5X,
     2 'NO. OF ITERATIONS FOR MATRIX EQUATION, NPITERT . .',I5/5X,
     3 'ERROR ALLOWANCE FOR TRANSIENT SOLUTION, TOLBT. . .',1PD15.6/)
 2070 FORMAT(1H /5X,'*** TIME CONTROL PARAMTER ***'/5X,
     > ' NUMBER OF TIME INCREMENTS,NTI. . . . . . . . . . . .',I5/)
 2080 FORMAT(1H ,/5X,
     > ' MAXIMUM VALUE OF TIME, TMAX . . . . . . . . . . .',1PD15.6/)
 2100 FORMAT(1H ,' LINE  PRINTER OUTPUT CONTROL'/(6X,8I4))
 2110 FORMAT(1H ,' PRINTER TIME-STEP CONTROL   '/(6X,8I4))
 2111 FORMAT(1H ,' PRINTER TIME-STEP CONTROL   '/(6X,10F8.2))
 2120 FORMAT(1H ,' DSK SAVED TIME-STEP CONTROL'/(6X,8I4))
 2121 FORMAT(1H ,' DSK SAVED TIME-STEP CONTROL'/(6X,10F8.2))
 2200 FORMAT(' '/5X,
     > 'THE NUMBER OF REF. WORKING GRIDS IN X-DIRECTION,NXW . .',I3/5X,
     > 'THE NUMBER OF REF. WORKING GRIDS IN Y-DIRECTION,NYW . .',I3/5X,
     > 'THE NUMBER OF REF. WORKING GRIDS IN Z-DIRECTION,NZW . .',I3/5X,
     > 'THE INDEX OF DETERMING TRACKING VELOCITY, IDETQ . . . .',I3//)
      END
C
      SUBROUTINE FILES (ARG1,IE,X,PROPF,PROPT,RHOMU,RSVAB,
     1                        KMOD,IBUG,ICHNG,KCP)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      CHARACTER CHAR*4, FNAME*80, TITLE*6, INSUP*80, ARG1*80, PATH*80
      CHARACTER*80 FNPH1,FNPH2,FNVL1,FNVL2,FNCN1,FNCN2,FNMC1,FNMC2,
     1           FNBF1,FNBF2,FNBT1,FNBT2
C
      COMMON /TCCARD/ IUNIT,JOPT,KOPT,IFILE,NPRINT,NPOST,
     1                ICFILE,IVFILE,PTIMES(MXPOST),POTIME(MXPOST)
      COMMON /ICCARD/ JICH,JICV,JICC,JICM,JIBF,JIBT,
     1               JPH,JCN,JVL,JMN,JMC,JBF,JBT
      COMMON /FTFILE/ KPH,KCN,KVL,KMC,KBF,KBT,JFILE,KFILE
C
      DIMENSION RSVAB(MXVNPH,4),PROPF(9,MXMATK),RHOMU(MXRMPK),
     1 PROPT(13,MXMATK),IE(MAXELK,9),X(MAXNPK,3)
C
      JICV=0
      JFILE=0
      KFILE=0
C
      INSUP = ARG1
      IF(INSUP(1:1) .EQ. ' ') THEN
        PRINT *, ' Enter the name of the super file'
        READ (*,'(A)') INSUP
      ENDIF
      CALL GETPATH(INSUP,PATH)
C
      OPEN (1,FILE=INSUP,STATUS='OLD')
C
      READ (1,'(A6)') TITLE
      IF (TITLE.NE.'FEMSUP') THEN
           WRITE(*,1001)
 1001 FORMAT(5X,'this is NOT a FEMWATER super file!')
        call stopfile  ! emrl jig
           STOP 'files'
      ENDIF
C
      OPEN (26,FILE='gw3d.tmp',STATUS='UNKNOWN')
      OPEN (25,FILE='node_ele.inf',STATUS='UNKNOWN')
      WRITE(*,'(A,//)') '   Reading files from super file...'
  100 READ (1,'(A4,A80)',END=101) CHAR,FNAME
      CALL STRIP(FNAME)
      CALL SETPATH(PATH,FNAME)
C
      IF (CHAR.EQ.'GEOM') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         OPEN (10,FILE=FNAME,STATUS='OLD')
         WRITE(*,*)'  Reading 3D geometry file...'
         CALL GEOM (IE,X)
         WRITE(*,'(/,A,/)')'   3D geometry file read successfully'
         CLOSE(10)
C
      ELSEIF (CHAR.EQ.'BCFT') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         OPEN (15,FILE=FNAME,STATUS='OLD')
         WRITE(*,'(A,/)')'   Reading the model parameter file...'
         CALL RINPUT (IE,PROPF,PROPT,RHOMU,RSVAB,
     1                     KMOD,IBUG,ICHNG,TITLE,KCP)
         WRITE(*,'(A,/)')'   Model parameter file read successfully'
         CLOSE(15)
C
      ELSEIF (CHAR.EQ.'PRTF') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         OPEN (16,FILE=FNAME,STATUS='UNKNOWN')
C ----- pressure head
      ELSEIF (CHAR.EQ.'ICHD') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNPH1=FNAME
         IF (ICFILE.EQ.0) THEN
            OPEN (31,FILE=FNAME,STATUS='OLD')
            JICH=1
         ELSEIF (ICFILE.EQ.1) THEN
            OPEN (41,FILE=FNAME,FORM='UNFORMATTED',STATUS='OLD')
            JICH=-1
         ENDIF
C ----- velocity
      ELSEIF (CHAR.EQ.'ICVL') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNVL1=FNAME
         IF (ICFILE.EQ.0) THEN
            OPEN (34,FILE=FNAME,STATUS='OLD')
            JICV=1
         ELSEIF (ICFILE.EQ.1) THEN
            OPEN (44,FILE=FNAME,FORM='UNFORMATTED',STATUS='OLD')
            JICV=-1
         ENDIF
C ----- nodal moisture contents
      ELSEIF (CHAR.EQ.'ICMC') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNMC1=FNAME
         IF (ICFILE.EQ.0) THEN
            OPEN (33,FILE=FNAME,STATUS='OLD')
            JICM=1
         ELSEIF (ICFILE.EQ.1) THEN
            OPEN (43,FILE=FNAME,FORM='UNFORMATTED',STATUS='OLD')
            JICM=-1
         ENDIF
C ----- concentration
      ELSEIF (CHAR.EQ.'ICCN') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNCN1=FNAME
         IF (ICFILE.EQ.0) THEN
            OPEN (51,FILE=FNAME,STATUS='OLD')
            JICC=1
         ELSEIF (ICFILE.EQ.1) THEN
            OPEN (61,FILE=FNAME,FORM='UNFORMATTED',STATUS='OLD')
            JICC=-1
         ENDIF
C ----- flux at the boundary nodes (flow)
      ELSEIF (CHAR.EQ.'ICBF') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNBF1=FNAME
         IF (ICFILE.EQ.0) THEN
            OPEN (32,FILE=FNAME,STATUS='OLD')
            JIBF=1
         ELSEIF (ICFILE.EQ.1) THEN
            OPEN (42,FILE=FNAME,FORM='UNFORMATTED',STATUS='OLD')
            JIBF=-1
         ENDIF
C ----- flux at the boundary nodes (transport)
      ELSEIF (CHAR.EQ.'ICBT') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNBT1=FNAME
         IF (ICFILE.EQ.0) THEN
            OPEN (52,FILE=FNAME,STATUS='OLD')
            JIBT=1
         ELSEIF (ICFILE.EQ.1) THEN
            OPEN (62,FILE=FNAME,FORM='UNFORMATTED',STATUS='OLD')
            JIBT=-1
         ENDIF
C ----- velocity for transport simulation
      ELSEIF (CHAR.EQ.'FLVL') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNVL1=FNAME
         IF (ICFILE.EQ.0) THEN
            OPEN (34,FILE=FNAME,STATUS='OLD')
            JICV=1
         ELSEIF (ICFILE.EQ.1) THEN
            OPEN (44,FILE=FNAME,FORM='UNFORMATTED',STATUS='OLD')
            JICV=-1
         ENDIF
C ----- pressure head for transport simulation
      ELSEIF (CHAR.EQ.'FLPH') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNPH1=FNAME
         IF (ICFILE.EQ.0) THEN
            OPEN (31,FILE=FNAME,STATUS='OLD')
            JICH=1
         ELSEIF (ICFILE.EQ.1) THEN
            OPEN (41,FILE=FNAME,FORM='UNFORMATTED',STATUS='OLD')
            JICH=-1
         ENDIF
C ----- pressure head
      ELSE IF (CHAR.EQ.'PSOL') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNPH2=FNAME
         IF (FNPH2.NE.FNPH1) THEN
            KPH=1
            IF (IFILE.EQ.0) THEN
               OPEN (35,FILE=FNAME,STATUS='UNKNOWN')
               JPH=1
            ELSEIF (IFILE.EQ.1) THEN
               OPEN (45,FILE=FNAME,FORM='UNFORMATTED',STATUS='UNKNOWN')
               JPH=-1
            ENDIF
         ENDIF
C ----- concentration
      ELSE IF (CHAR.EQ.'CSOL') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNCN2=FNAME
         IF (FNCN2.NE.FNCN1) THEN
            KCN=1
            IF (IFILE.EQ.0) THEN
               OPEN (53,FILE=FNAME,STATUS='UNKNOWN')
               JCN=1
            ELSEIF (IFILE.EQ.1) THEN
               OPEN (63,FILE=FNAME,FORM='UNFORMATTED',STATUS='UNKNOWN')
               JCN=-1
            ENDIF
         ENDIF
C ----- velocity
      ELSE IF (CHAR.EQ.'VSOL') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNVL2=FNAME
         IF (FNVL2.NE.FNVL1) THEN
            KVL=1
            IF (IFILE.EQ.0) THEN
               OPEN (38,FILE=FNAME,STATUS='UNKNOWN')
               JVL=1
            ELSEIF (IFILE.EQ.1) THEN
               OPEN (48,FILE=FNAME,FORM='UNFORMATTED',STATUS='UNKNOWN')
               JVL=-1
            ENDIF
         ENDIF
C ----- nodal moisture contents
      ELSE IF (CHAR.EQ.'MSOL') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNMC2=FNAME
         IF (FNMC2.NE.FNMC1) THEN
            KMC=1
            IF (IFILE.EQ.0) THEN
               OPEN (37,FILE=FNAME,STATUS='UNKNOWN')
               JMN=1
            ELSEIF (IFILE.EQ.1) THEN
               OPEN (47,FILE=FNAME,FORM='UNFORMATTED',STATUS='UNKNOWN')
               JMN=-1
            ENDIF
          ENDIF
C   ----- nodal flux at the boundaries (flow)
      ELSEIF (CHAR.EQ.'BFXF') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNBF2=FNAME
         IF (FNBF2.NE.FNBF1) THEN
            KBF=1
            IF (IFILE.EQ.0) THEN
               OPEN (36,FILE=FNAME,STATUS='UNKNOWN')
               JBF=1
            ELSE IF (IFILE.EQ.1) THEN
               OPEN (46,FILE=FNAME,FORM='UNFORMATTED',STATUS='UNKNOWN')
               JBF=-1
            ENDIF
         ENDIF
C   ----- nodal flux at the boundaries (transport)
      ELSEIF (CHAR.EQ.'BFXT') THEN
         WRITE(*,*)'  File name read from super file > '//FNAME
         FNBT2=FNAME
         IF (FNBT2.NE.FNBT1) THEN
            KBT=1
            IF (IFILE.EQ.0) THEN
               OPEN (54,FILE=FNAME,STATUS='UNKNOWN')
               JBT=1
            ELSE IF (IFILE.EQ.1) THEN
               OPEN (64,FILE=FNAME,FORM='UNFORMATTED',STATUS='UNKNOWN')
               JBT=-1
            ENDIF
         ENDIF
      ENDIF
      GO TO 100
  101 CLOSE(1)
      RETURN
      END
C
      SUBROUTINE STRIP(FNAME)
      CHARACTER FNAME*80
C
      ISLASH = 0
      ILAST = 0
      ISTART = 0
      DO I = 1,80
        IF(FNAME(I:I).EQ.'/') ISLASH = I
        IF(FNAME(I:I).NE.' ' .AND. ISTART.EQ.0
     &     .AND.  FNAME(I:I).NE.CHAR(9) ) ISTART =I
      END DO
      DO I = 80,1,-1
         IF(FNAME(I:I).NE.' ' .AND.ILAST.EQ.0) ILAST =I
      END DO
C
      IF (ISLASH.GT.0) THEN
          FNAME = FNAME(ISLASH+1:ILAST)
      ELSE
          FNAME = FNAME(ISTART:ILAST)
      END IF
      RETURN
      END
C
      SUBROUTINE CHKBC
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /FPS/ NWNPF,NWPRF,NWDPF(MXWPRH)
      COMMON /TPS/ NWNPT,NWPRT,NWDPT(MXWPRC)
      COMMON /BLKPSF/ WSSF(MXWPRH),WSSFF(MXWDPH,MXWPRH),
     1                TWSSFF(MXWDPH,MXWPRH),IWTYPF(MXWNPH),
     2                NPWF(MXWNPH),JWTYPF(MXWNPH)
      COMMON /BLKPST/ WSST(MXWPRC),WSSFT(MXWDPC,MXWPRC),
     1                TWSSFT(MXWDPC,MXWPRC),IWTYPT(MXWNPC),
     2                NPWT(MXWNPC),JWTYPT(MXWNPC)
      COMMON /FDBC/ NDNPF,NDPRF,NDDPF(MXDPRH)
      COMMON /FCBC/ NCESF,NCNPF,NCPRF,NCDPF(MXCPRH)
      COMMON /FVBC/ NVESF,NVNPF,NVPRF,NVDPF(MXVPRH)
      COMMON /FNBC/ NNESF,NNNPF,NNPRF,NNDPF(MXNPRH)
      COMMON /FRBC/ NRESF,NRNPF,NRPRF,NRDPF(MXRPRH),NRMAF
      COMMON /BLKDBF/ HDBF(MXDPRH),HDBFF(MXDDPH,MXDPRH),
     1        THDBFF(MXDDPH,MXDPRH),IDTYPF(MXDNPH),NPDBF(MXDNPH),
     2        JDTYPF(MXDNPH)
      COMMON /BLKCBF/ QCBF(MXCPRH),QCBFF(MXCDPH,MXCPRH),
     1        TQCBFF(MXCDPH,MXCPRH),ICTYPF(MXCESH),ISCF(5,MXCESH),
     2        NPCBF(MXCNPH),IDCF(MXCESH),JCTYPF(MXCESH)
      COMMON /BLKVBF/ QVBF(MXVPRH),QVBFF(MXVDPH,MXVPRH),
     1        TQVBFF(MXVDPH,MXVPRH),IVTYPF(MXVESH),ISVF(5,MXVESH),
     2        NPVBF(MXVNPH),IDVF(MXVESH),JVTYPF(MXVESH)
      COMMON /BLKNBF/ QNBF(MXNPRH),QNBFF(MXNDPH,MXNPRH),
     1        TQNBFF(MXNDPH,MXNPRH),INTYPF(MXNESH),ISNF(5,MXNESH),
     2        NPNBF(MXNNPH),IDNF(MXNESH),JNTYPF(MXNESH)
      COMMON /BLKRBF/ HRBF(MXRPRH),HRBFF(MXRDPH,MXRPRH),
     1        THRBFF(MXRDPH,MXRPRH),IRTYPF(MXRNPH),NPRBF(MXRNPH),
     2        ISRF(6,MXRESH),PRORF(2,MXRESH),IDRF(MXRESH),NRBEF(MXRESH),
     3        IRMTYP(MXRMAH),JRTYPF(MXRNPH)
C
      COMMON /TDBC/ NDNPT,NDPRT,NDDPT(MXDPRC)
      COMMON /TCBC/ NCEST,NCNPT,NCPRT,NCDPT(MXCPRC)
      COMMON /TVBC/ NVEST,NVNPT,NVPRT,NVDPT(MXVPRC)
      COMMON /TNBC/ NNEST,NNNPT,NNPRT,NNDPT(MXNPRC)
C
      COMMON /BLKDBT/ CDBT(MXDPRC),CDBFT(MXDDPC,MXDPRC),
     1        TCDBFT(MXDDPC,MXDPRC),IDTYPT(MXDNPC),
     2        NPDBT(MXDNPC),JDTYPT(MXDNPC)
      COMMON /BLKCBT/ QCBT(MXCPRC),QCBFT(MXCDPC,MXCPRC),
     1        TQCBFT(MXCDPC,MXCPRC),ICTYPT(MXCESC),ISCT(5,MXCESC),
     2        NPCBT(MXCNPC),IDCT(MXCESC),JCTYPT(MXCESC)
      COMMON /BLKVBT/ CVBT(MXVPRC),CVBFT(MXVDPC,MXVPRC),
     1        TCVBFT(MXVDPC,MXVPRC),IVTYPT(MXVESC),ISVT(5,MXVESC),
     2        NPVBT(MXVNPC),IDVT(MXVESC),JVTYPT(MXVESC)
      COMMON /BLKNBT/ QNBT(MXNPRC),QNBFT(MXNDPC,MXNPRC),
     1        TQNBFT(MXNDPC,MXNPRC),INTYPT(MXNESC),ISNT(5,MXNESC),
     2        NPNBT(MXNNPC),IDNT(MXNESC),JNTYPT(MXNESC)
C
      COMMON /TCONV/ NTY1(MXXYS),NTY2(MXXYS),NTY3(MXXYS),NTY4(MXXYS),
     1               NTY5(MXXYS),NTY6(MXXYS),NTY7(MXXYS),NTY8(MXXYS),
     2               NTY9(MXXYS),NTY10(MXXYS),NTY11(MXXYS),NTY12(MXXYS)
C
      IF (NDNPF.GT.0 ) THEN
          DO I=1,NDNPF
             JDTYPF(I) = 0
             DO K=1,NDPRF
                 IF (IDTYPF(I).EQ.NTY5(K)) THEN
                    JDTYPF(I)=K
                 ENDIF
             ENDDO
C             WRITE(16,9001) I,JDTYPF(I),IDTYPF(I)
C 9001         FORMAT(5X,'I=',I5,5X,2I8)
          ENDDO
      ENDIF
C
C ------- concentration
C
      IF (NDNPT.GT.0) THEN
          DO I=1,NDNPT
             JDTYPT(I) = 0
             DO K=1,NDPRT
                IF (IDTYPT(I).EQ.NTY6(K)) THEN
                    JDTYPT(I)=K
                ENDIF
             ENDDO
C            WRITE(16,9001) I,JDTYPT(I),IDTYPT(I)
          ENDDO
          DO I=1,NDNPT
             IF (JDTYPT(I).EQ.0) THEN
               WRITE(*,9002) I,NPDBT(I),IDTYPT(I)
 9002 FORMAT(5X,'I=',I5,5X,2I8,5X,'IDTYPT did not match with NTY6')
       call stopfile  ! emrl jig
               STOP 'chkbc'
             ENDIF
          ENDDO
      ENDIF
C
C -------  CAUCHY FLUX index number
C
      IF (NCESF.GT.0 ) THEN
         DO I=1,NCESF
            JCTYPF(I) = 0
            DO K=1,NCPRF
                IF (ICTYPF(I).EQ.NTY7(K)) THEN
                    JCTYPF(I)=K
                ENDIF
            ENDDO
C            WRITE(16,9001) I,JCTYPF(I),ICTYPF(I)
         ENDDO
         DO I=1,NCESF
            IF (JCTYPF(I).EQ.0) THEN
               WRITE(*,9003) I,NPCBF(I),ICTYPF(I)
 9003 FORMAT(5X,'I=',I5,5X,2I8,5X,'ICTYPF did not match with NTY7')
        call stopfile  ! emrl jig
               STOP 'chkbc'
            ENDIF
         ENDDO
      ENDIF
C
      IF (NCEST.GT.0) THEN
         DO I=1,NCEST
            JCTYPT(I) = 0
            DO K=1,NCPRT
                IF (ICTYPT(I).EQ.NTY8(K)) THEN
                    JCTYPT(I)=K
                ENDIF
            ENDDO
C            WRITE(16,9001) I,JCTYPT(I),ICTYPT(I)
         ENDDO
         DO I=1,NCEST
            IF (JCTYPT(I).EQ.0) THEN
               WRITE(*,9004) I,NPCBT(I),ICTYPT(I)
 9004 FORMAT(5X,'I=',I5,5X,2I8,5X,'ICTYPT did not match with NTY8')
        call stopfile  ! emrl jig
               STOP 'chkbc'
            ENDIF
         ENDDO
      ENDIF
C
C --------  NEUMANN FLUX   index number
C
      IF (NNESF.GT.0) THEN
         DO I=1,NNESF
            JNTYPF(I) = 0
            DO K=1,NNPRF
                IF (INTYPF(I).EQ.NTY9(K)) THEN
                    JNTYPF(I)=K
                ENDIF
            ENDDO
C            WRITE(16,9001) I,JNTYPF(I),INTYPF(I)
         ENDDO
         DO I=1,NNESF
            IF (JNTYPF(I).EQ.0) THEN
               WRITE(*,9005) I,NPNBF(I),INTYPF(I)
 9005 FORMAT(5X,'I=',I5,5X,2I8,5X,'INTYPF did not match with NTY9')
        call stopfile  ! emrl jig
               STOP 'chkbc'
            ENDIF
         ENDDO
      ENDIF
      IF (NNEST.GT.0) THEN
         DO I=1,NNEST
            JNTYPT(I) = 0
            DO K=1,NNPRT
                IF (INTYPT(I).EQ.NTY10(K)) THEN
                    JNTYPT(I)=K
                ENDIF
            ENDDO
C            WRITE(16,9001) I,JNTYPT(I),INTYPT(I)
         ENDDO
         DO I=1,NNEST
            IF (JNTYPT(I).EQ.0) THEN
               WRITE(*,9006) I,NPNBT(I),INTYPT(I)
 9006 FORMAT(5X,'I=',I5,5X,2I8,5X,'INTYPT did not match with NTY10')
        call stopfile  ! emrl jig
               STOP 'chkbc'
            ENDIF
         ENDDO
      ENDIF
C
C   ------- RAINFALL-SEEPAGE  index number
C
      IF (NVESF.GT.0 ) THEN
          DO I=1,NVESF
            JVTYPF(I) = 0
            DO K=1,NVPRF
                IF (IVTYPF(I).EQ.NTY3(K)) THEN
                    JVTYPF(I)=K
                ENDIF
            ENDDO
C            WRITE(16,9001) I,JVTYPF(I),IVTYPF(I)
         ENDDO
         DO I=1,NVESF
            IF (JVTYPF(I).EQ.0) THEN
               WRITE(*,9007) I,NPVBF(I),IVTYPF(I)
 9007 FORMAT(5X,'I=',I5,5X,2I8,5X,'ICTYPF did not match with NTY3')
        call stopfile  ! emrl jig
               STOP 'chkbc'
            ENDIF
         ENDDO
      ENDIF
C
      IF ( NVEST.GT.0) THEN
         DO I=1,NVEST
            JVTYPT(I) = 0
            DO K=1,NVPRT
                IF (IVTYPT(I).EQ.NTY4(K)) THEN
                    JVTYPT(I)=K
                ENDIF
            ENDDO
C            WRITE(16,9001) I,JVTYPT(I),IVTYPT(I)
         ENDDO
         DO I=1,NVEST
            IF (JVTYPT(I).EQ.0) THEN
               WRITE(*,9008) I,NPVBT(I),IVTYPT(I)
 9008 FORMAT(5X,'I=',I5,5X,2I8,5X,'IVTYPT did not match with NTY4')
        call stopfile  ! emrl jig
               STOP 'chkbc'
            ENDIF
         ENDDO
      ENDIF
C
C  -------- WELL SOURCES/SINK    index number
C
      IF (NWNPF.GT.0) THEN
          DO I=1,NWNPF
             JWTYPF(I) = 0
             DO K=1,NWPRF
                 IF (IWTYPF(I).EQ.NTY1(K)) THEN
                    JWTYPF(I)=K
                 ENDIF
             ENDDO
C            WRITE(16,9001) I,JWTYPF(I),IWTYPF(I)
         ENDDO
         DO I=1,NWNPF
            IF (JWTYPF(I).EQ.0) THEN
               WRITE(*,9009) I,NPWF(I),IWTYPF(I)
 9009 FORMAT(5X,'I=',I5,5X,2I8,5X,'IWTYPF did not match with NTY1')
        call stopfile  ! emrl jig
               STOP 'chkbc'
            ENDIF
         ENDDO
      ENDIF
      IF (NWNPT.GT.0) THEN
         DO I=1,NWNPT
            JWTYPT(I) = 0
            DO K=1,NWPRT
                IF (IWTYPT(I).EQ.NTY2(K)) THEN
                    JWTYPT(I)=K
                ENDIF
            ENDDO
C           WRITE(16,9001) I,JWTYPT(I),IWTYPT(I)
         ENDDO
         DO I=1,NWNPT
            IF (JWTYPT(I).EQ.0) THEN
               WRITE(*,9010) I,NPWT(I),IWTYPT(I)
 9010 FORMAT(5X,'I=',I5,5X,2I8,5X,'IWTYPT did not match with NTY2')
        call stopfile  ! emrl jig
               STOP 'chkbc'
            ENDIF
         ENDDO
      ENDIF
C
C ----- River boundary index number
C
      IF ( NRNPF.GT.0 ) THEN
          DO I=1,NRNPF
             JRTYPF(I) = 0
             DO K=1,NDPRF
                 IF (IRTYPF(I).EQ.NTY12(K)) THEN
                    JRTYPF(I)=K
                 ENDIF
             ENDDO
C             WRITE(16,9001) I,JDTYPF(I),IDTYPF(I)
C 9001         FORMAT(5X,'I=',I5,5X,2I8)
          ENDDO
          DO I=1,NRNPF
             IF (JRTYPF(I).EQ.0) THEN
               WRITE(*,9011) I,NPRBF(I),JRTYPF(I)
 9011 FORMAT(5X,'I=',I5,5X,2I8,5X,'JRTYPF did not match with NTY12')
        call stopfile  ! emrl jig
               STOP 'chkbc'
             ENDIF
          ENDDO
      ENDIF
      RETURN
      END
C
      SUBROUTINE GWM3D (X,IE,IBDY,NPCNV,INDRS,
     1            KMOD,IBUG,ICHNG)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      CHARACTER SUBHD*32,FNAME*80
C
      INCLUDE 'gwpara.inc'
C
C ------- COMMON BLOCK FOR BOTH FLOW AND TRANSPORT
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /TSTEP/ NTI,NTIF,NTIT
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /PCG/ GG,IEIGEN
      COMMON /IP1/ OMEFTT,NITFTT
      COMMON /RAIN/ IRAIN
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
C ------- COMMON BLOCK FOR FLOW ITERATION AND MATERIAL CONTROL
C
      COMMON /FINTE/ NCYLF,NITERF,NPITERF,KSP,KGRAV,IPNTSF
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
C
C ------- COMMON BLOCK FOR TRANSPORT ITERATION AND MATERIAL CONTROL
C
      COMMON /TINTE/ NCMT,NITERT,NPITERT,IPNTST
      COMMON /TREAL/ OMET,OMIT,TOLBT
      COMMON /TCCARD/ IUNIT,JOPT,KOPT,IFILE,NPRINT,NPOST,
     1                ICFILE,IVFILE,PTIMES(MXPOST),POTIME(MXPOST)
      COMMON /TC2/ IDT,IDTXY,NDT
      COMMON /TC21/ TIMEL(MXDTCK),DELTAT(MXDTCK)
      COMMON /ICCARD/ JICH,JICV,JICC,JICM,JIBF,JIBT,
     1               JPH,JCN,JVL,JMN,JMC,JBF,JBT
      COMMON /FTFILE/ KPH,KCN,KVL,KMC,KBF,KBT,JFILE,KFILE
C
C ------- COMMON BLOCK FOR FLOW AND TRANSPORT SOURCE/SINK
C
      COMMON /FTREAL/EPSS,EPST
      COMMON /FPS/ NWNPF,NWPRF,NWDPF(MXWPRH)
      COMMON /BLKPSF/ WSSF(MXWPRH),WSSFF(MXWDPH,MXWPRH),
     1               TWSSFF(MXWDPH,MXWPRH),IWTYPF(MXWNPH),
     2               NPWF(MXWNPH),JWTYPF(MXWNPH)
      COMMON /TPS/ NWNPT,NWPRT,NWDPT(MXWPRC)
      COMMON /BLKPST/ WSST(MXWPRC),WSSFT(MXWDPC,MXWPRC),
     1               TWSSFT(MXWDPC,MXWPRC),IWTYPT(MXWNPC),
     2               NPWT(MXWNPC),JWTYPT(MXWNPC)
C
C ------- COMMON BLOCK FOR FLOW BOUNDARY CONDITIONS
C
      COMMON /FDBC/ NDNPF,NDPRF,NDDPF(MXDPRH)
      COMMON /FCBC/ NCESF,NCNPF,NCPRF,NCDPF(MXCPRH)
      COMMON /FVBC/ NVESF,NVNPF,NVPRF,NVDPF(MXVPRH)
      COMMON /FNBC/ NNESF,NNNPF,NNPRF,NNDPF(MXNPRH)
      COMMON /FRBC/ NRESF,NRNPF,NRPRF,NRDPF(MXRPRH),NRMAF
C
      COMMON /BLKDBF/ HDBF(MXDPRH),HDBFF(MXDDPH,MXDPRH),
     1        THDBFF(MXDDPH,MXDPRH),IDTYPF(MXDNPH),NPDBF(MXDNPH),
     2        JDTYPF(MXDNPH)
      COMMON /BLKCBF/ QCBF(MXCPRH),QCBFF(MXCDPH,MXCPRH),
     1        TQCBFF(MXCDPH,MXCPRH),ICTYPF(MXCESH),ISCF(5,MXCESH),
     2        NPCBF(MXCNPH),IDCF(MXCESH),JCTYPF(MXCESH)
      COMMON /BLKVBF/ QVBF(MXVPRH),QVBFF(MXVDPH,MXVPRH),
     1        TQVBFF(MXVDPH,MXVPRH),IVTYPF(MXVESH),ISVF(5,MXVESH),
     2        NPVBF(MXVNPH),IDVF(MXVESH),JVTYPF(MXVESH)
      COMMON /BLKNBF/ QNBF(MXNPRH),QNBFF(MXNDPH,MXNPRH),
     1        TQNBFF(MXNDPH,MXNPRH),INTYPF(MXNESH),ISNF(5,MXNESH),
     2        NPNBF(MXNNPH),IDNF(MXNESH),JNTYPF(MXNESH)
      COMMON /BLKRBF/ HRBF(MXRPRH),HRBFF(MXRDPH,MXRPRH),
     1        THRBFF(MXRDPH,MXRPRH),IRTYPF(MXRNPH),NPRBF(MXRNPH),
     2        ISRF(6,MXRESH),PRORF(2,MXRESH),IDRF(MXRESH),NRBEF(MXRESH),
     3        IRMTYP(MXRMAH),JRTYPF(MXRNPH)
C
C ------- COMMON BLOCK FOR TRANSPORT BOUNDARY CONDITIONS
C
      COMMON /TDBC/ NDNPT,NDPRT,NDDPT(MXDPRC)
      COMMON /TCBC/ NCEST,NCNPT,NCPRT,NCDPT(MXCPRC)
      COMMON /TVBC/ NVEST,NVNPT,NVPRT,NVDPT(MXVPRC)
      COMMON /TNBC/ NNEST,NNNPT,NNPRT,NNDPT(MXNPRC)
C
      COMMON /BLKDBT/ CDBT(MXDPRC),CDBFT(MXDDPC,MXDPRC),
     1        TCDBFT(MXDDPC,MXDPRC),IDTYPT(MXDNPC),
     2        NPDBT(MXDNPC),JDTYPT(MXDNPC)
      COMMON /BLKCBT/ QCBT(MXCPRC),QCBFT(MXCDPC,MXCPRC),
     1        TQCBFT(MXCDPC,MXCPRC),ICTYPT(MXCESC),ISCT(5,MXCESC),
     2        NPCBT(MXCNPC),IDCT(MXCESC),JCTYPT(MXCESC)
      COMMON /BLKVBT/ CVBT(MXVPRC),CVBFT(MXVDPC,MXVPRC),
     1        TCVBFT(MXVDPC,MXVPRC),IVTYPT(MXVESC),ISVT(5,MXVESC),
     2        NPVBT(MXVNPC),IDVT(MXVESC),JVTYPT(MXVESC)
      COMMON /BLKNBT/ QNBT(MXNPRC),QNBFT(MXNDPC,MXNPRC),
     1        TQNBFT(MXNDPC,MXNPRC),INTYPT(MXNESC),ISNT(5,MXNESC),
     2        NPNBT(MXNNPC),IDNT(MXNESC),JNTYPT(MXNESC)
C
C ------- COMMON BLOCK FOR FLOW AND TRANSPORT
C
      COMMON /FFLOW/ FRATEF(11),FLOWF(11),TFLOWF(11)
      COMMON /TFLOW/ FRATET(14),FLOWT(14),TFLOWT(14)
      COMMON /FFLUX/ FFLXB(MAXNPK), SUMPRV
      COMMON /TFLUX/ TFLXB(MAXNPK)
C
C ------- ADVECTION WEIGHTING FACTORS
C
      COMMON /WETX/ APHA1,APHA2,APHA3,APHA4
      COMMON /WETY/ BETA1,BETA2,BETA3,BETA4
      COMMON /WETZ/ GAMA1,GAMA2,GAMA3,GAMA4
C
      COMMON /UNSAT/ PH(MXSPMK,MXMATK),PMC(MXSPMK,MXMATK),
     1               PCON(MXSPMK,MXMATK),CONDUC(MXSPMK,MXMATK),
     2               PWC(MXSPMK,MXMATK),WC(MXSPMK,MXMATK),
     &               PMKNOT(MXSPMK + 4, MXMATK), PCKNOT(MXSPMK + 4,
     &               MXMATK), PWKNOT(MXSPMK + 4, MXMATK),
     &               PMCOEF(MXSPMK, MXMATK), PCCOEF(MXSPMK, MXMATK),
     &               PWCOEF(MXSPMK, MXMATK), IBSPL
      COMMON /TCONV/ NTY1(MXXYS),NTY2(MXXYS),NTY3(MXXYS),NTY4(MXXYS),
     1               NTY5(MXXYS),NTY6(MXXYS),NTY7(MXXYS),NTY8(MXXYS),
     2               NTY9(MXXYS),NTY10(MXXYS),NTY11(MXXYS),NTY12(MXXYS)
C
      COMMON /SAZFM/ NXW,NYW,NZW,IDETQ
      COMMON /BLK4/ OMEF1,OMET1,OMEFT1
C
C ------- ARRAYS FOR BOTH FLOW AND TRANSPORT
C
      COMMON /BLKFT1/LRN(MXJBDK,MAXNPK),LRL(MXKBDK,MAXNPK),NLRL(MAXNPK),
     1               ND(MAXNPK),NT(MAXNPK)
      COMMON /BLKFT2/ CMATRX(MXJBDK,MAXNPK),RI(MAXNPK),RL(MAXNPK),
     1                RLD(MAXNPK),SK(MAXNPK),RK(MAXNPK),PK(MAXNPK)
      COMMON /BLKFT3/ DCOSB(3,MXBESK),ISB(6,MXBESK),NPBB(MXBNPK),
     1                IB(MAXNPK)
C
      COMMON /ICREAL/ HCONST,CONVAL,HSTIME
      COMMON /ICINT / IHEAD,ICON,ISTART
C
      DIMENSION X(MAXNPK,3),IE(MAXELK,9),IBDY(MXTUBK)
C
C ------- ARRAYS FOR FLOW ONLY
C
      COMMON /BLKFL1/ H(MAXNPK),HP(MAXNPK),HW(MAXNPK),HT(MAXNPK)
      COMMON /BLKFL2/ V(MAXNPK,3),TH(8,MAXELK),DTH(8,MAXELK),
     1                AKHC(7,8,MAXELK)
      COMMON /BLKFL3/ BFLXF(MXBNPK,2),RSVAB(MXVNPH,4),PROPF(9,MXMATK),
     1                RHOMU(MXRMPK)
      COMMON /BLKFL4/ IDRY
C
      DIMENSION NPCNV(MAXNPK),INDRS(MXVNPH,3)
C
C ------- ARRAYS FOR TRANSPORT ONLY
C
      COMMON /BLKTR1/ C(MAXNPK),CP(MAXNPK),CW(MAXNPK),CSTAR(MAXNPK),
     1                F(MAXNPK,3),DTI(MAXNPK)
      COMMON /BLKTR2/ BFLXT(MXBNPK,2),WETAB(12,MAXELK),VP(MAXNPK,3),
     1                THP(8,MAXELK),THN(MAXNPK,2),AKDC(6,8,MAXELK),
     2                VBAR(MAXNPK,3),PROPT(13,MXMATK)
C
      DIMENSION THNPV(MAXNPK),SUBHD(3),NCONFT(MAXNPK)
C
      COMMON /TRFLOW/ IFFU
C
      DATA SUBHD/'INPUT INITIAL CONDITIONS        ',
     1 'STEADY-STATE INITIAL CONDITIONS ',
     2 '                                '/
      DATA EPSX/1.0D-8/
      DATA IEND/210/
C
      NFILE=0
      NTFILE=0
      IDRY=0
      IRAIN=0
C
C ------- Compute machine epsilon and square root of machine epsilon
C
      SQEPS = 1.D-8
C
C ------- Prepare initial variables
C
      STIME=0.0D0
      JTM=0
C
C         Get initial conditions for cold and hot start.  For
C         transport only hot start, use KSSF = IFFU.
C
      IF (KMOD .EQ. 1) KSSF = IFFU
C
      CALL RINIFL (X, H, HT, TH, V, IE, THNPV, FFLXB)
C
      IF ((KMOD .EQ. 1) .OR. (KMOD .EQ. 11)) THEN
C
        CALL RINITR (CP, TFLXB)
C
C ------- Apply Dirichlet concentration boundary specifications to
c         initial conditions.
C
        IF (NDNPT .GT. 0) then
          CALL LINEAR (CDBT, TCDBFT, CDBFT, STIME, MXDPRC, MXDDPC,
     &      NDPRT, NDDPT)
          DO NPP = 1, NDNPT
            NP = NPDBT(NPP)
            ITYP = JDTYPT(NPP)
            CP(NP) = CDBT(ITYP)
          END DO
        END IF
C
      END IF
C
C ---- Initiate rhomu array
C
      IF (KMOD.NE.11) THEN
          RHOMU(1)=1.0D0
          RHOMU(5)=1.0D0
          DO I=2,4
             RHOMU(I)=0.0D0
             RHOMU(I+4)=0.0D0
          ENDDO
      ENDIF
C
C ------- Flow simulation required
C
      IF (KMOD.EQ.10 .OR. KMOD.EQ.11) THEN
C
C ------- Prepare the initial/pre-initial data for flow
C
         IF (NWNPF.NE.0) CALL LINEAR (WSSF,TWSSFF,WSSFF,STIME,
     1                    MXWPRH,MXWDPH,NWPRF,NWDPF)
         IF (NCESF.NE.0) CALL LINEAR (QCBF,TQCBFF,QCBFF,STIME,
     1                      MXCPRH,MXCDPH,NCPRF,NCDPF)
         IF (NNESF.NE.0) CALL LINEAR (QNBF,TQNBFF,QNBFF,STIME,
     1                      MXNPRH,MXNDPH,NNPRF,NNDPF)
         IF (NVESF.NE.0) THEN
             CALL LINEAR (QVBF,TQVBFF,QVBFF,STIME,
     1                      MXVPRH,MXVDPH,NVPRF,NVDPF)
             IRAIN=0
             DO I=1,NVPRF
                IF (DABS(QVBF(I)).GT. 1.0E-10) THEN
                  IRAIN=1
                  JR=I
                  GO TO 101
                ENDIF
             ENDDO
  101        CONTINUE
         ENDIF
C
         IF (NDNPF.NE.0) THEN
              CALL LINEAR (HDBF,THDBFF,HDBFF,STIME,
     1                     MXDPRH,MXDDPH,NDPRF,NDDPF)
         ENDIF
C
         IF (NRNPF.NE.0) THEN
              CALL LINEAR (HRBF,THRBFF,HRBFF,STIME,
     1                     MXRPRH,MXRDPH,NRPRF,NRDPF)
         ENDIF
C
C ------- Apply Dirichlet head boundary specifications to
C         initial conditions.
C
         IF (KMOD.EQ.11) THEN
            DO I=1,NDNPF
               NP=NPDBF(I)
               ITYP=JDTYPF(I)
               CC=CP(NP)
               RO=RHOMU(1)+CC*(RHOMU(2)+CC*RHOMU(3)+CC*CC*RHOMU(4))
               H(NP)=(HDBF(ITYP)-X(NP,3)*DBLE(KGRAV))*RO
            ENDDO
         ELSEIF (KMOD.EQ.10) THEN
            DO I=1,NDNPF
               NP=NPDBF(I)
               ITYP=JDTYPF(I)
               H(NP)=HDBF(ITYP)-X(NP,3)*DBLE(KGRAV)
            ENDDO
         ENDIF
C
C     ---   Compute moisture contents at Gaussian points
C
         CALL CALMC (TH,H,IE)
C
         IF (ISTART.EQ.1 .AND. KSSF.EQ.1) GO TO 500
C
         DO I=1,NNP
            HP(I)=H(I)
         ENDDO
C
         CALL SPROP(AKHC,DTH,H,CP,IE,PROPF,RHOMU)
C
         CALL VELT(V,IE,H,AKHC)
C
         DO I=1,NBNP
            BFLXF(I,2)=0.0D0
         ENDDO
         KFLOW=-1
C
         SUMPRV = 0.D0
C
C        CALL FSFLOW (IE,H,HP,V,TH,DTH,AKHC,RHOMU,CP,
C    1              BFLXF,DCOSB,ISB,NPBB,PROPF,DELT,KFLOW,KMOD)
C
         DO I=1,9
            IF (I.NE.9) THEN
               FLOWF(I)=0.0D0
               TFLOWF(I)=0.0D0
            ENDIF
         ENDDO
         FLOWF(9)=0.0D0
C
C ------- Print initial variables for flow
C
         IF (KMC.EQ.1. OR. JMC.EQ.1) THEN
C   $$$$$ start revision 5/20/98
C            CALL THNPON (THNPV,TH,IE)
             CALL THNPON (THNPV,H,IE,LRL,NLRL)
C   $$$$$ end revision   5/20/98
         ENDIF
C
         CALL FPRINT(V,H,HT,THNPV,BFLXF,NPVBF,RSVAB,INDRS,SUBHD(1),
     1       -1)
C
         IF (KSSF.EQ.1) THEN
C   $$$$$ start revision  5/20/98
C            CALL THNPON (THNPV,TH,IE)
             CALL THNPON (THNPV,H,IE,LRL,NLRL)
C   $$$$$ end   revision   5/20/98
             CALL FSTORE (H,V,THNPV,FFLXB,NFILE)
         ENDIF
         IF (KSSF.EQ.1 .AND. KMOD.EQ.10) GO TO 500
      ENDIF
C
C ------- Transport Simulation required
C
  200 CONTINUE
C
      IF (KMOD.EQ.1 .OR. KMOD.EQ.11) THEN
C
C ------- Prepare initial or pre-initial variables for transport
C
         IF (NWNPT.NE.0) CALL LINEAR (WSST,TWSSFT,WSSFT,STIME,
     1                      MXWPRC,MXWDPC,NWPRT,NWDPT)
         IF (NCNPT.NE.0) CALL LINEAR (QCBT,TQCBFT,QCBFT,STIME,
     1                      MXCPRC,MXCDPC,NCPRT,NCDPT)
         IF (NNEST.NE.0) CALL LINEAR (QNBT,TQNBFT,QNBFT,STIME,
     1                      MXNPRC,MXNDPC,NNPRT,NNDPT)
         IF (NVEST.NE.0) CALL LINEAR (CVBT,TCVBFT,CVBFT,STIME,
     1                      MXVPRC,MXVDPC,NVPRT,NVDPT)
C
         IF (KMOD.EQ.1)THEN
            DO M=1,NEL
               NODE=IJNOD(M)
               DO I=1,NODE
                  AKHC(7,I,M)=1.0D0
               ENDDO
            ENDDO
         ENDIF
         IF (ISTART.EQ.1) GO TO 500
C
C ------ INITIATE C
C
         DO NP=1,NNP
            C(NP) = CP(NP)
            VP(NP,1)=V(NP,1)
            VP(NP,2)=V(NP,2)
            VP(NP,3)=V(NP,3)
         ENDDO
C
         DO M=1,NEL
            NODE=IJNOD(M)
            DO IQ=1,NODE
               THP(IQ,M)=TH(IQ,M)
            ENDDO
         ENDDO
C
         CALL CALMC(TH,H,IE)
         CALL THNODE(THN,TH,THP,PROPF,PROPT,IE,KSORP)
         CALL DISPC(AKDC,IE,V,VP,TH,THP,PROPT)
         CALL AFABTA(WETAB,X,IE,V,VP,THN(1,2),PROPT)
C
         WRITE(16,3400)
         DO MP=1,NEL
            WRITE(16,3450) MP,(WETAB(IQ,MP),IQ=1,12)
         ENDDO
C
         CALL FLUX (F,CP,IE,V,AKDC)
C
         DO NP=1,NBNP
            BFLXT(NP,2)=0.0D0
         ENDDO
         KFLOW=-1
C
         CALL TSFLOW (BFLXT,IE,CP,F,H,HP,TH,DCOSB,ISB,NPBB,
     1      WSSF,JWTYPF,PROPF,PROPT,DELT,KFLOW)
C
         DO I=1,14
            IF(I.NE.8 .AND. I.NE.9) THEN
               FLOWT(I)=0.0D0
               TFLOWT(I)=0.0D0
            ENDIF
         ENDDO
         FLOWT(8)=0.0D0
         FLOWT(9)=0.0D0
C
C ------- Print initial or pre-initial variables  for transport
C
         CALL TPRINT (CP,F,STIME,DELT, -1)
         CALL TSTORE (CP,TFLXB,NTFILE)
      ENDIF
C
C -------- Steady_state flow simulation
C
      IPRT=0
      IDSK=0
C
      IF (KMOD.EQ.10 .AND. KSSF.EQ.0) THEN
          DO NP=1,NNP
               HP(NP)=H(NP)
          ENDDO
C
          CALL HYDRO (X,IE,C,NPCNV,INDRS,
     1                IPRT,JTM,IBUG,ICHNG,KMOD,SQEPS)
C
C ------- Print steady-state variables for flow
C
         KFLOW=0
C
         CALL FSFLOW (IE,H,HP,V,TH,DTH,AKHC,RHOMU,C,
     1              BFLXF,DCOSB,ISB,NPBB,PROPF,DELT,KFLOW,KMOD)
         DO I=1,9
            IF (I.NE.9) THEN
               FLOWF(I)=0.0D0
               TFLOWF(I)=0.0D0
            ENDIF
         ENDDO
         FLOWF(9)=0.0D0
C
C ----- compute moisture contents
C
C   $$$$$ start revision 5/20/98
C        CALL THNPON (THNPV,TH,IE)
         CALL THNPON (THNPV,H,IE,LRL,NLRL)
C   $$$$$ end revision 5/20/98
C
         CALL FPRINT(V,H,HT,THNPV,BFLXF,NPVBF,RSVAB,INDRS,SUBHD(2),
     1     0)
C
         CALL FSTORE (H,V,THNPV,FFLXB,NFILE)
      ENDIF
C
      IF (NTIF.EQ.0 ) GO TO 991
C
C ******* Transient state simulation
C
  500 CONTINUE
      IF (KMOD.EQ.1) GO TO 550
      IF (NVESF.EQ.0 .OR. IRAIN.EQ.0) GO TO 550
      DO NPP=1,NVNPF
         NI=NPVBF(NPP)
         INDRS(NPP,1)=NPBB(NI)
         INDRS(NPP,2)=0
         INDRS(NPP,3)=0
      ENDDO
      NCHG=-1
  550 CONTINUE
C  
      DO NP=1,NNP
         C(NP)=CP(NP)
      ENDDO
C
C %%%%% Start time loop
C
      TFLOWF(9)=0.0D0
      TFLOWT(8)=0.0D0
      TFLOWT(9)=0.0D0
C
      KFLOW=0
      IF (IDT.EQ.1) THEN
         IDELT=1
         DELT=DELTAT(IDELT)
      ENDIF
C
C  ------- begin the time-marching loop
C
      DO 890 ITM=1,NTI
         STIME=STIME+DELT
         IF (IDT.EQ.0) GO TO 891
C
         IF (IDT.EQ.1) THEN
            IF (STIME.LE.TIMEL(IDELT)+0.000001D0) THEN
                GO TO 891
            ELSEIF (IDELT+1.GT.NDT) THEN
                IF (STIME.LE.TMAX) THEN
                   DELT=DELTAT(NDT)
                ENDIF
            ELSEIF (STIME.LE.TIMEL(IDELT+1)+0.0000010D0) THEN
                IDELT=IDELT+1
                IF (IDELT.LE.NDT) THEN
                   DELT=DELTAT(IDELT)
                   STIME=TIMEL(IDELT-1)+DELT
                ELSE
                   GO TO 991
                ENDIF
            ELSE
                IDELT=IDELT+1
                IF (IDELT.GT.NDT) GO TO 991
                DELT=DELTAT(IDELT)
                STIME=TIMEL(IDELT-1)+DELT
            ENDIF
         ENDIF
  891    JTM=ITM
         IF (STIME.GT.TMAX) GO TO 991
C
C    ----- hot start
C
         IF (ISTART.EQ.1) THEN
C
C      ------- flow
C
            IF (STIME.LT.HSTIME) GO TO 890
            IF (STIME.GT.HSTIME) GO TO 892
            IF (DABS(STIME-HSTIME).LE.0.000010) THEN
                WRITE(*,*) ' Starting time:', HSTIME
                GO TO 890
            ELSE
                WRITE(*,5413)
 5413 FORMAT(' Error: end of file reached before TS found')
        call stopfile  ! emrl jig
                STOP
            ENDIF
         ENDIF
  892    CONTINUE
C
         IF (JOPT.EQ.0) THEN
             IPRT=MOD(JTM,KPRT)
         ELSE
             IPRT = 1
             DO K=1,NPRINT
                IF (DABS(STIME-PTIMES(K)).LE.0.00001D0)THEN
                    IPRT=0
                ENDIF
             ENDDO
         ENDIF
C
         IF (KOPT.EQ.0) THEN
             IDSK=MOD(JTM,KDSK)
         ELSE
             IDSK = 1
             DO K=1,NPOST
                IF (DABS(STIME-POTIME(K)).LE.0.00001D0)THEN
                   IDSK=0
                ENDIF
             ENDDO
         ENDIF
C
         DO NP=1,NNP
            DO J=1,3
               VP(NP,J)=V(NP,J)
            ENDDO
            HP(NP)=H(NP)
            CP(NP)=C(NP)
         ENDDO
C
         DO M=1,NEL
            NODE=IJNOD(M)
            DO IQ=1,NODE
               THP(IQ,M)=TH(IQ,M)
            ENDDO
         ENDDO
C
         IF ((KMOD.EQ.10 .OR. KMOD.EQ.11) .AND. KSSF.EQ.1) THEN
C
            IF (NWNPF.NE.0) THEN
                 CALL LINEAR (WSSF,TWSSFF,WSSFF,STIME,
     1                       MXWPRH,MXWDPH,NWPRF,NWDPF)
            ENDIF
C
            IF (NDNPF.NE.0) THEN
                 CALL LINEAR (HDBF,THDBFF,HDBFF,STIME,
     1                     MXDPRH,MXDDPH,NDPRF,NDDPF)
            ENDIF
            IF (NDNPT.NE.0) THEN
                 CALL LINEAR (CDBT,TCDBFT,CDBFT,STIME,
     1                      MXDPRC,MXDDPC,NDPRT,NDDPT)
            ENDIF
            IF (NVESF.NE.0) THEN
               CALL LINEAR (QVBF,TQVBFF,QVBFF,STIME,
     1                          MXVPRH,MXVDPH,NVPRF,NVDPF)
               IRAIN=0
               DO I=1,NVPRF
                  IF (DABS(QVBF(I)).GT. 1.0E-10) THEN
                     IRAIN=1
                     JR=I
                     GO TO 102
                   ENDIF
               ENDDO
  102          CONTINUE
            ENDIF
            IF (NCESF.NE.0) CALL LINEAR (QCBF,TQCBFF,QCBFF,STIME,
     1                          MXCPRH,MXCDPH,NCPRF,NCDPF)
            IF (NNESF.NE.0) CALL LINEAR (QNBF,TQNBFF,QNBFF,STIME,
     1                          MXNPRH,MXNDPH,NNPRF,NNDPF)
            IF (NRNPF.NE.0) THEN
                 CALL LINEAR (HRBF,THRBFF,HRBFF,STIME,
     1                     MXRPRH,MXRDPH,NRPRF,NRDPF)
            ENDIF
         ENDIF
C
         IF ( KMOD.EQ.1 .OR. KMOD.EQ.11) THEN
C
            IF (NWNPF.NE.0) CALL LINEAR (WSSF,TWSSFF,WSSFF,STIME,
     1                       MXWPRH,MXWDPH,NWPRF,NWDPF)
C
            IF (NWNPT.NE.0) CALL LINEAR (WSST,TWSSFT,WSSFT,STIME,
     1                           MXWPRC,MXWDPC,NWPRT,NWDPT)
            IF (NDNPT.NE.0) CALL LINEAR (CDBT,TCDBFT,CDBFT,STIME,
     1                           MXDPRC,MXDDPC,NDPRT,NDDPT)
            IF (NVEST.NE.0) CALL LINEAR (CVBT,TCVBFT,CVBFT,STIME,
     1                           MXVPRC,MXVDPC,NVPRT,NVDPT)
            IF (NCNPT.NE.0) CALL LINEAR (QCBT,TQCBFT,QCBFT,STIME,
     1                           MXCPRC,MXCDPC,NCPRT,NCDPT)
            IF (NNEST.NE.0) CALL LINEAR (QNBT,TQNBFT,QNBFT,STIME,
     1                          MXNPRC,MXNDPC,NNPRT,NNDPT)
         ENDIF
C
C   ---- Print simulation time and time step
C
         IF (IDT.EQ.0) THEN
            IF (KMOD.NE.1) THEN
               IF (NVESF.LE.0) THEN
                   WRITE(*,5004) JTM,STIME,DELT
               ELSE
                   WRITE(*,5001) JTM,STIME,DELT,IRAIN,QVBF(1)
               ENDIF
            ELSE
               WRITE(*,5004) JTM,STIME,DELT
            ENDIF
         ELSEIF (IDT.EQ.1) THEN
            IF (KMOD.NE.1) THEN
               IF (NVESF.LE.0) THEN
                   WRITE(*,5002) JTM,STIME,DELT,IDELT,TIMEL(IDELT)
               ELSE
                   WRITE(*,5001) JTM,STIME,DELT,IDELT,TIMEL(IDELT),
     1                           IRAIN,QVBF(1)
               ENDIF
            ELSE
               WRITE(*,5002) JTM,STIME,DELT,IDELT,TIMEL(IDELT)
            ENDIF
         ENDIF
C
C   ------ flow simulation only - with transient
C
         IF (KMOD.EQ.10) THEN
             DO NP=1,NNP
                CSTAR(NP)=H(NP)
             ENDDO
C
             CALL HYDRO(X,IE,C,NPCNV,INDRS,
     1                  IPRT,JTM,IBUG,ICHNG,KMOD,SQEPS)
C
             IF (IDRY.EQ.1) GO TO 991
             GO TO 860
C
         ENDIF
C
C  ------- transport simulation only - transient
C
         IF (KMOD.EQ.1) THEN
C
             DO NP=1,NNP
                HT(NP)=C(NP)
             ENDDO
C
             CALL THNODE(THN,TH,THP,PROPF,PROPT,IE,KSORP)
             CALL DISPC(AKDC,IE,V,VP,TH,THP,PROPT)
             CALL AFABTA(WETAB,X,IE,V,VP,THN(1,2),PROPT)
             DO M=1,NEL
                NODE=IJNOD(M)
                DO IQ=1,NODE
                     DTH(IQ,M)=(TH(IQ,M)-THP(IQ,M))/DELT
                ENDDO
             ENDDO
C
             CALL CHEMI (X,IE,IBDY,IPRT,JTM,IBUG,
     1                   KMOD,SQEPS)
             GO TO 860
         ENDIF
C
C %%%%% Start Nonlinear loop between flow and transport
C
         DO 840 ITER=1,NITFTT
C
C -------Transient flow simulation is desired
C
            DO NP=1,NNP
                CSTAR(NP)=H(NP)
            ENDDO
C
C ------ pass to subroutine hydro for transient state hydrological
C -------- calculations
C
            CALL HYDRO (X,IE,C,NPCNV,INDRS,
     1                    IPRT,JTM,IBUG,ICHNG,KMOD,SQEPS)
C
            IF (IDRY.EQ.1) GO TO 991
C
C ----- Check convergence of flow part
C
            NPP=0
            RD=-1.0D0
            RES=-1.0D0
            DO NP=1,NNP
                RESNP=DABS(H(NP)-CSTAR(NP))
                RES=DMAX1(RES,RESNP)
                IF (RESNP.GT.EPSS) THEN
                   NPP=NPP+1
                   NCONFT(NPP)= NP
                ENDIF
            ENDDO
C
            DO NP=1,NNP
                H(NP)=OMEFTT*H(NP) + OMEFT1*CSTAR(NP)
            ENDDO
C
C         Update the other flow data.
C
            CALL CALMC (TH, H, IE)
            CALL SPROP (AKHC, DTH, H, C, IE, PROPF, RHOMU)
            CALL VELT (V, IE, H, AKHC)
C
C ====== Transient transport simulation is desired
C
            DO NP=1,NNP
               HW(NP)=C(NP)
            ENDDO
C
            CALL THNODE(THN,TH,THP,PROPF,PROPT,IE,KSORP)
            CALL DISPC(AKDC,IE,V,VP,TH,THP,PROPT)
            CALL AFABTA(WETAB,X,IE,V,VP,THN(1,2),PROPT)
            DO M=1,NEL
               NODE=IJNOD(M)
               DO IQ=1,NODE
                   DTH(IQ,M)=(TH(IQ,M)-THP(IQ,M))/DELT
               ENDDO
            ENDDO
C
C ------- Pass to chemi for transient state chemical transport
C ------- calculations
C
            CALL CHEMI (X,IE,IBDY,IPRT,JTM,IBUG,KMOD,SQEPS)
C
C --- check if the coupled flow and transport simulation with no density term
C
            IF (NITFTT.EQ.1) GO TO 860
C
C ----- Check convergence of transport part
C
            DIFMAX= -1.0D38
            NPMAX=0
            DO NP=1,NNP
               ERR=DABS(HW(NP)-C(NP))
               IF (ERR.GE.DIFMAX) THEN
                  DIFMAX=ERR
                  NPMAX=NP
               ENDIF
            ENDDO
            DO NP=1,NNP
                C(NP)=OMEFTT*C(NP) + OMEFT1*HW(NP)
            ENDDO
C
            IF (IBUG.NE.0) THEN
               IF (DIFMAX.LE.EPST) THEN
                 NPMAX=0
               ENDIF
               WRITE(16,7400) JTM,STIME,ITER-1,RES,EPSS,NPP,
     &                  DIFMAX,EPST,NPMAX
               WRITE(*,7400) JTM,STIME,ITER-1,RES,EPSS,NPP,
     #                  DIFMAX,EPST,NPMAX
            ENDIF
C
            IF (RES.LE.EPSS .AND. DIFMAX.LE.EPST) GO TO 860
  840    CONTINUE
C
C %%%%% End of Nonlinear loop between flow and transport
C
         IF (KMOD.EQ.11) THEN
             WRITE(16,7500) JTM,ITER-1,NITFTT,RES,EPSS,NPP,
     %                     DIFMAX,EPST,NPMAX
             WRITE (*,7500) JTM,ITER-1,NITFTT,RES,EPSS,NPP,
     #                     DIFMAX,EPST,NPMAX
         ELSEIF (KMOD.EQ.10) THEN
             WRITE(16,7501) JTM,ITER-1,NITFTT,RES,EPSS,NPP
             WRITE (*,7501) JTM,ITER-1,NITFTT,RES,EPSS,NPP
         ELSEIF (KMOD.EQ.1) THEN
             WRITE(16,7502) JTM,STIME,ITER-1,NITFTT,DIFMAX,EPST,NPMAX
             WRITE(*,7502)  JTM,STIME,ITER-1,NITFTT,DIFMAX,EPST,NPMAX
         ENDIF
  860    CONTINUE
C
C ----- compute fluxs through all types of boundary
C
         IF (KMOD.EQ.10 .OR. KMOD.EQ.11) THEN
C
            CALL FSFLOW (IE,H,HP,V,TH,DTH,AKHC,RHOMU,C,
     1              BFLXF,DCOSB,ISB,NPBB,PROPF,DELT,KFLOW,KMOD)
C
            KFLOW = 1
            IF (IPRT.EQ.0)  THEN
                CALL THNPON (THNPV,H,IE,LRL,NLRL)
                CALL FPRINT (V,H,HT,THNPV,BFLXF,NPVBF,RSVAB,
     1               INDRS,SUBHD(3),JTM)
            ENDIF
C
            IF (IDSK.EQ.0) THEN
               CALL THNPON (THNPV,H,IE,LRL,NLRL)
               CALL FSTORE (H,V,THNPV,FFLXB,NFILE)
            ENDIF
         ENDIF
C
         IF (KMOD.EQ.1 .OR. KMOD.EQ.11) THEN
C
C ------- Calculate material flux FX, FY, AND FZ
C
            CALL FLUX (F,C,IE,V,AKDC)
C
C ------- Determine flux through all boundaries
C
            CALL TSFLOW (BFLXT,IE,C,F,H,HP,TH,DCOSB,ISB,NPBB,
     1         WSSF,JWTYPF,PROPF,PROPT,DELT,KFLOW)
            IF (IPRT.EQ.0) CALL TPRINT(C,F,STIME,DELT,JTM)
C
            IF (IDSK.EQ.0) THEN
                CALL TSTORE (C,TFLXB,NTFILE)
            ENDIF
         ENDIF
         IF (NWNPF.NE.0) THEN
             WRITE(*,3001)
 3001 FORMAT(5X,' Pressure Head at Pumping Wells')
             DO I=1,NWNPF
                IW=NPWF(I)
                WPH=H(IW)
                WRITE(*,3002) I,IW,WPH
 3002 FORMAT(5X,'Well #',I4,2X,'NODE=',I8,5X,'PH=',E15.6)
             ENDDO
         ENDIF
  890 CONTINUE
  991 CONTINUE
C
C ***** write a mark ending a data set
C
C ----- pressure head
C
      IF (KPH.EQ.1) THEN
         IF (JPH.EQ.1) THEN
            INQUIRE (35,NAME=FNAME)
            WRITE(35,1001) 'ENDDS'
            WRITE(*,2001) FNAME
         ELSEIF (JPH.EQ.-1) THEN
            INQUIRE (45,NAME=FNAME)
            WRITE(45) IEND
            WRITE(*,2001) FNAME
         ENDIF
      ELSEIF (KPH.EQ.0) THEN
         IF (JICH.EQ.1) THEN
             INQUIRE (31,NAME=FNAME)
             WRITE(31,1001) 'ENDDS'
             WRITE(*,2001) FNAME
         ELSEIF (JICH.EQ.-1) THEN
             INQUIRE (41,NAME=FNAME)
             WRITE(41) IEND
             WRITE(*,2001) FNAME
         ENDIF
      ENDIF
C
C ----- moisture content - nodal points
C
      IF (KMC.EQ.1) THEN
         IF (JMN.EQ.1) THEN
            INQUIRE (37,NAME=FNAME)
            WRITE(37,1001) 'ENDDS'
            WRITE(*,2001) FNAME
         ELSEIF (JMN.EQ.-1) THEN
            INQUIRE (47,NAME=FNAME)
            WRITE(47) IEND
            WRITE(*,2001) FNAME
         ENDIF
      ELSEIF (KMC.EQ.0) THEN
         IF (JICM.EQ.1) THEN
            INQUIRE (33,NAME=FNAME)
            WRITE(33,1001) 'ENDDS'
            WRITE(*,2001) FNAME
         ELSEIF (JICM.EQ.-1) THEN
            INQUIRE (43,NAME=FNAME)
            WRITE(43) IEND
            WRITE(*,2001) FNAME
         ENDIF
      ENDIF
C
C ----- velocity
C
      IF (KVL.EQ.1) THEN
         IF (JVL.EQ.1) THEN
            INQUIRE (38,NAME=FNAME)
            WRITE(38,1001) 'ENDDS'
            WRITE(*,2001) FNAME
         ELSEIF (JVL.EQ.-1) THEN
            INQUIRE (48,NAME=FNAME)
            WRITE(48) IEND
            WRITE(*,2001) FNAME
         ENDIF
      ELSEIF (KVL.EQ.0) THEN
         IF (JICV.EQ.1) THEN
            INQUIRE (34,NAME=FNAME)
            WRITE(34,1001) 'ENDDS'
            WRITE(*,2001) FNAME
         ELSEIF (JICV.EQ.-1) THEN
            INQUIRE (44,NAME=FNAME)
            WRITE(44) IEND
            WRITE(*,2001) FNAME
         ENDIF
      ENDIF
C
C ----- concentration
C
      IF (KCN.EQ.1) THEN
         IF (JCN.EQ.1) THEN
            INQUIRE (53,NAME=FNAME)
            WRITE(53,1001) 'ENDDS'
            WRITE(*,2001) FNAME
         ELSEIF (JCN.EQ.-1) THEN
            INQUIRE (63,NAME=FNAME)
            WRITE(63) IEND
            WRITE(*,2001) FNAME
         ENDIF
      ELSEIF (KCN.EQ.0) THEN
         IF (JICC.EQ.1) THEN
            INQUIRE (51,NAME=FNAME)
            WRITE(51,1001) 'ENDDS'
            WRITE(*,2001) FNAME
         ELSEIF (JICC.EQ.-1) THEN
            INQUIRE (61,NAME=FNAME)
            WRITE(61) IEND
            WRITE(*,2001) FNAME
         ENDIF
      ENDIF
C
C ----- nodal flux at the boundaries (flow)
C
      IF (KBF.EQ.1) THEN
         IF (JBF.EQ.1) THEN
             INQUIRE (36,NAME=FNAME)
             WRITE(36,1001) 'ENDDS'
             WRITE(*,2001) FNAME
         ELSEIF (JBF.EQ.-1) THEN
             INQUIRE (46,NAME=FNAME)
             WRITE(46) IEND
             WRITE(*,2001) FNAME
         ENDIF
      ELSEIF (KBF.EQ.0) THEN
         IF (JIBF.EQ.1) THEN
             INQUIRE (32,NAME=FNAME)
             WRITE(32,1001) 'ENDDS'
             WRITE(*,2001) FNAME
         ELSEIF (JIBF.EQ.-1) THEN
             INQUIRE (42,NAME=FNAME)
             WRITE(42) IEND
             WRITE(*,2001) FNAME
         ENDIF
      ENDIF
C
C ----- nodal flux at the boundaries (transport)
C
      IF (KBT.EQ.1) THEN
         IF (JBT.EQ.1) THEN
             INQUIRE (54,NAME=FNAME)
             WRITE(54,1001) 'ENDDS'
             WRITE(*,2001) FNAME
         ELSEIF (JBT.EQ.-1) THEN
             INQUIRE (64,NAME=FNAME)
             WRITE(64) IEND
             WRITE(*,2001) FNAME
         ENDIF
      ELSEIF (KBT.EQ.0) THEN
         IF (JIBT.EQ.1) THEN
             INQUIRE (52,NAME=FNAME)
             WRITE(52,1001) 'ENDDS'
             WRITE(*,2001) FNAME
         ELSEIF (JIBT.EQ.-1) THEN
             INQUIRE (62,NAME=FNAME)
             WRITE(62) IEND
             WRITE(*,2001) FNAME
         ENDIF
      ENDIF
C
      RETURN
 1001 FORMAT(A5)
 1400 FORMAT(1H ,' *** ERROR reading velocity: STOP ')
 1500 FORMAT(1H ,/5X,' **** CARD INPUTTED VELOCITY ****'///1X,
     1 2('    N     VX         VY         VZ    ')/1X,
     2 2('  --- ---------- ---------- ----------')/)
 1550 FORMAT(1H ,2(I5,3D11.4))
 1800 FORMAT(1H ,' *** ERROR reading moisture content:  STOP')
 1900 FORMAT(1H ,/5X,' **** CARD INPUTTED MOISTURE CONTENT ***'///1X,
     1 '    M    1       2       3       4      5       6       7   ',
     3 '    8   '/1X,'  ---',8(' -------'))
 1950 FORMAT(1H ,I5,8F8.5)
 2001 FORMAT(3X,'Wrote end of file mark ',A72)
 3400 FORMAT(1H ,'TABLE OF WEIGHTING FACTORS OF EVERY ELEMENTS'//)
 3450 FORMAT(1H ,I5,12F6.3)
C
 5001 FORMAT(2X,'TS #',I6,2X,'TIME=',F10.2,2X,'delt_time=',F8.3,2X,
     1   'IDELT=',I2,2X,'TIMEL:',F8.2,2X,'Irain=',I4,2X,'rain=',F8.6)
 5002 FORMAT(2X,'TS #',I6,2X,'TIME=',F10.2,2X,'delt_time=',F8.3,2X,
     1   'IDELT=',I2,2X,'TIMEL:',F8.2)
 5003 FORMAT(2X,'TS #',I6,2X,'TIME=',F10.2,2X,'delt_time=',F8.3,2X,
     1   'Irain=',I4,2X,'rain=',F8.6)
 5004 FORMAT(2X,'TS #',I6,2X,'TIME=',F10.2,2X,'delt_time=',F8.3)
C
 7400 FORMAT(/2X,'TS # ',I6,' time=',F10.3,' ITER=',I3,' RES=',D12.4,
     >' EPSS=',D12.4/2X,' NNCVN=',I6,' DIFMAX=',D12.4,' EPST=',D12.4,
     >' NPMAX=',I5)
 7401 FORMAT(/2X,'TS # ',I6,' time=',F11.3,' ITER=',I3,' RES=',D12.4,
     >' EPSS =', D12.4,' NNCVN =',I6)
 7402 FORMAT(/2X,'TS #',I6,' time=',F11.3,' ITER=',I3,2X,' DIFMAX=',
     >D12.4, ' EPST=',D12.4,' NPNUM =',I5)
 7500 FORMAT(/5X,'** WARNING: No convergence at ',I6,'-th time step',
     > ' after ',I4,' iterations'/8X,'NITER=',I3,' RES=',D12.4,' EPSS=',
     > D12.4,' NNCVN=',I6/8X,
     > ' DIFMAX=',D12.4,' EPST=',D12.4,' NPNUM=',I5//)
 7501 FORMAT(/5X,'** WARNING: No convergence at ',I6,'-th time step',
     > ' after ',I4,' iterations'/8X,'NITER=',I4,' RES=',D12.4,' EPSS=',
     > D12.4,' NNCVN=',I6//)
 7502 FORMAT(/5X,'** WARNING: No convergence at ',I6,'-th time step',
     > ' after ',I4,' iterations'/8X,'NITER=',I4,
     > ' DIFMAX=',D12.4,' EPST=',D12.4,' NPNUM=',I5//)
 8010 FORMAT(1X,2I6,1PD12.4,1PD12.4)
      END
C
      SUBROUTINE RINIFL (X,H,HT,TH,V,IE,THNPV,FFLXB)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      CHARACTER STITLE*7,IC1*2,CHAR*4,TITLE1*6,TITLE2*40
      CHARACTER FNAME*80
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /ICREAL/ HCONST,CONVAL,HSTIME
      COMMON /ICINT / IHEAD,ICON,ISTART
      COMMON /TCCARD/ IUNIT,JOPT,KOPT,IFILE,NPRINT,NPOST,
     1                ICFILE,IVFILE,PTIMES(MXPOST),POTIME(MXPOST)
      COMMON /ICCARD/ JICH,JICV,JICC,JICM,JIBF,JIBT,
     1               JPH,JCN,JVL,JMN,JMC,JBF,JBT
      COMMON /FTFILE/ KPH,KCN,KVL,KMC,KBF,KBT,JFILE,KFILE
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /BLKTR1/ C(MAXNPK),CP(MAXNPK),CW(MAXNPK),CSTAR(MAXNPK),
     1                F(MAXNPK,3),DTI(MAXNPK)
      COMMON /BLKFL3/ BFLXF(MXBNPK,2),RSVAB(MXVNPH,4),PROPF(9,MXMATK),
     1                RHOMU(MXRMPK)
C
      DIMENSION IE(MAXELK,9),AKHC(7,8,MAXELK),FFLXB(MAXNPK)
      DIMENSION X(MAXNPK,3),H(MAXNPK),HT(MAXNPK),V(MAXNPK,3),
     1          TH(8,MAXELK),THNPV(MAXNPK)
C
      DATA ISTAT,ISCL,IVEC/0,130,140/
C
C *****   Flow data   *****
C
C   %%%%%  cold start  %%%%%
C
      IF (ISTART.EQ.0) THEN
C
C       --------- constant pressure head
C
         IF (IHEAD.EQ.0) THEN
             DO I=1,NNP
                H(I)=HCONST-X(I,3)
             ENDDO
             write(*,'(A,//)') '   Read constant intial total head '
C
         ELSEIF (IHEAD.EQ.1) THEN
C
C       #####   ASCII FILE  #####
C
            IF (JICH.EQ.1) THEN
C
C          ------ pressure head
C
               INQUIRE(31,NAME=FNAME)
               write(*,2001) FNAME
               READ(31,1001) STITLE
               READ(31,1007) STITLE,TITLE1
               READ(31,1002) TITLE1
               IF (TITLE1.NE.'BEGSCL') THEN
                     WRITE(*,4001) TITLE1
	       call stopfile  ! emrl jig
                     STOP 'R_ph'
               ENDIF
               READ(31,1003) IC1,NOD
               READ(31,1003) IC1,NELM
               IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                     WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                      STOP 'ph_nod'
               ENDIF
               READ(31,1004) CHAR,TITLE2
               READ(31,1005) IC1,ISTAT,RTIME
               WRITE(*,4006) RTIME,FNAME
               DO K=1,NNP
                  READ (31,*) H(K)
               ENDDO
C
C       #####  Binary file   #####
C
            ELSEIF (JICH.EQ.-1) THEN
C
C          ---------- pressure head
C
               INQUIRE(41,NAME=FNAME)
               write(*,2001) FNAME
               READ(41) IVERS,ID1,JD1,ID2,JD2,ID3,JD3
               READ(41) IDUMP
               IF (IDUMP.NE.ISCL) THEN
                      WRITE(*,4002) IDUMP
	       call stopfile  ! emrl jig
                      STOP 'R_ph'
               ENDIF
               READ(41) IDUMP,NOD
               READ(41) IDUMP,NELM
               READ(41) IDUMP,TITLE2
               IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                      WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                      STOP 'ph_nod'
               ENDIF
               READ(41) IDUMP,JDUMP,RTIME
               WRITE(*,4006) RTIME,FNAME
               READ(41) (H(I),I=1,NNP)
            ENDIF
         ENDIF
C
C          ---   Compute moisture contents at Gaussian points
C
         CALL CALMC (TH,H,IE)
C
         IF (JICV.EQ.0) THEN
C
C          ----- compute velocity based on pressure head
C
         CALL CALKR (AKHC,H,CP,IE,PROPF,RHOMU)
         CALL VELT (V,IE,H,AKHC)
C
C       #####   ASCII FILE  #####
C
         ELSEIF (JICV.EQ.1) THEN
C
C           ---  velocity
C
            INQUIRE(34,NAME=FNAME)
            write(*,2001) FNAME
            READ(34,1001) STITLE
            READ(34,1007) STITLE,TITLE1
            READ(34,1002) TITLE1
            IF (TITLE1.NE.'BEGVEC') THEN
                   WRITE(*,4003) TITLE1
	       call stopfile  ! emrl jig
                   STOP 'R_vel '
            ENDIF
            READ(34,1003) IC1,NOD
            READ(34,1003) IC1,NELM
            IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                   WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                   STOP 'v_nod'
            ENDIF
            READ(34,1004) CHAR,TILTE2
            READ(34,1005) IC1,ISTAT,RTIME
            write(*,4006) RTIME,FNAME
            DO I=1,NNP
               READ (34,*) (V(I,K),K=1,3)
            ENDDO
C
C       #####  Binary file   #####
C
         ELSEIF (JICV.EQ.-1) THEN
C
C         ----- velocity
C
            INQUIRE(44,NAME=FNAME)
            write(*,2001) FNAME
            READ(44) IVERS,ID1,JD1,ID2,JD2,ID3,JD3
            READ(44) IDUMP
            IF (IDUMP.NE.IVEC) THEN
                     WRITE(*,4004) IDUMP
	       call stopfile  ! emrl jig
                     STOP 'R_vel'
            ENDIF
            READ(44) IDUMP,NOD
            READ(44) IDUMP,NELM
            READ(44) IDUMP,TITLE2
            IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                    WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                    STOP 'v_nod'
            ENDIF
            READ(44) IDUMP,JDUMP,RTIME
            write(*,4006) RTIME,FNAME
            READ(44) ((V(I,J),J=1,3),I=1,NNP)
         ENDIF
C
C   %%%%%  hot start   %%%%%
C
      ELSEIF (ISTART.EQ.1) THEN
C
C      #####  ASCII FILE   #####
C
         IF (ICFILE.EQ.0) THEN
C
C           &&&&&  steady state  &&&&&
C
            IF (KSSF.EQ.0) THEN
C
C            --- pressure head
C
               INQUIRE(31,NAME=FNAME)
               write(*,2001) FNAME
               READ(31,1001) STITLE
               READ(31,1007) STITLE,TITLE1
               READ(31,1002) TITLE1
               IF (TITLE1.NE.'BEGSCL') THEN
                      WRITE(*,4001) TITLE1
	       call stopfile  ! emrl jig
                       STOP 'R_ph'
               ENDIF
               READ(31,1003) IC1,NOD
               READ(31,1003) IC1,NELM
               IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                        WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                        STOP 'ph_nod'
               ENDIF
               READ(31,1004) CHAR,TITLE2
               READ(31,1005) IC1,IDUMP,RTIME
               write(*,4006) RTIME,FNAME
               DO K=1,NNP
                  READ (31,*) H(K)
               ENDDO
C
C          ---   Compute moisture contents at Gaussian points
C
               CALL CALMC (TH,H,IE)
C
               IF (JICV.EQ.0) THEN
C
C          ----- compute velocity based on pressure head
C
                  CALL CALKR (AKHC,H,CP,IE,PROPF,RHOMU)
                  CALL VELT (V,IE,H,AKHC)
C
               ELSEIF (JICV.EQ.1) THEN
C
C           ---  velocity
C
                  INQUIRE(34,NAME=FNAME)
                  write(*,2001) FNAME
                  READ(34,1001) STITLE
                  READ(34,1007) STITLE,TITLE1
                  READ(34,1002) TITLE1
                  IF (TITLE1.NE.'BEGVEC') THEN
                         WRITE(*,4003) TITLE1
	       call stopfile  ! emrl jig
                         STOP 'R_vel '
                  ENDIF
                  READ(34,1003) IC1,NOD
                  READ(34,1003) IC1,NELM
                  IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                         WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                         STOP 'v_nod'
                  ENDIF
                  READ(34,1004) CHAR,TILTE2
                  READ(34,1005) IC1,ISTAT,RTIME
                  write(*,4006) RTIME,FNAME
                  DO I=1,NNP
                     READ (34,*) (V(I,K),K=1,3)
                  ENDDO
               ENDIF
               RETURN
C
C   -----  transient   -----
C
            ELSEIF (KSSF.EQ.1) THEN
C
C        --- pressure head
C
               INQUIRE(31,NAME=FNAME)
               write(*,2001) FNAME
               READ(31,1001) STITLE
               READ(31,1007) STITLE,TITLE1
               READ(31,1002) TITLE1
               IF (TITLE1.NE.'BEGSCL') THEN
                         WRITE(*,4001) TITLE1
	       call stopfile  ! emrl jig
                         STOP 'R_ph'
               ENDIF
               READ(31,1003) IC1,NOD
               READ(31,1003) IC1,NELM
               IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                         WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                      STOP 'ph_nod'
               ENDIF
               READ(31,1004) CHAR,TITLE2
  103          READ(31,1005) IC1,ISTAT,RTIME
               write(*,4006) RTIME,FNAME
               DO K=1,NNP
                  READ (31,*) H(K)
               ENDDO
               IF (RTIME.LT.HSTIME-0.0000001) GO TO 103
               IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                    DO I=1,NNP
                       HT(I)=H(I)+X(I,3)
                    ENDDO
                    GO TO 104
               ELSE
	       call stopfile  ! emrl jig
                    STOP 'endf31'
               ENDIF
C
C           --- moisture content at Gaussian points
C
  104          CALL CALMC (TH,H,IE)
C
               IF (JICV.EQ.0) THEN
C
C          ----- compute velocity based on pressure head
C
                   CALL CALKR (AKHC,H,CP,IE,PROPF,RHOMU)
                   CALL VELT (V,IE,H,AKHC)
C
               ELSEIF (JICV.EQ.1) THEN
C
C           --- velocity
C
                   INQUIRE(34,NAME=FNAME)
                   write(*,2001) FNAME
                   READ(34,1001) STITLE
                   READ(34,1007) STITLE,TITLE1
                   READ(34,1002) TITLE1
                   IF (TITLE1.NE.'BEGVEC') THEN
                            WRITE(*,4003) TITLE1
	       call stopfile  ! emrl jig
                            STOP 'R_vel'
                   ENDIF
                   READ(34,1003) IC1,NOD
                   READ(34,1003) IC1,NELM
                   IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                            WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                            STOP 'v_nod'
                   ENDIF
                   READ(34,1004) CHAR,TILTE2
  105              READ(34,1005) IC1,ISTAT,RTIME
                   write(*,4006) RTIME,FNAME
                   DO J=1,NNP
                      READ(34,*) (V(J,K),K=1,3)
                   ENDDO
                   IF (RTIME.LT.HSTIME) GO TO 105
                   IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                         GO TO 106
                   ELSE
	       call stopfile  ! emrl jig
                         STOP 'endf34'
                   ENDIF
               ENDIF
  106          CONTINUE
C
               IF (JICM.EQ.1) THEN
C
C        ----- Nodal moisture contents
C
                   INQUIRE(33,NAME=FNAME)
                   write(*,2001) FNAME
                   READ(33,1001) STITLE
                   READ(33,1007) STITLE,TITLE1
                   READ(33,1002) TITLE1
                   IF (TITLE1.NE.'BEGSCL') THEN
                           WRITE(*,4001) TITLE1
	       call stopfile  ! emrl jig
                           STOP 'R_mc'
                   ENDIF
                   READ(33,1003) IC1,NOD
                   READ(33,1003) IC1,NELM
                   IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                            WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                            STOP 'mc_nod'
                   ENDIF
                   READ(33,1004) CHAR,TITLE2
  107              READ(33,1005) IC1,ISTAT,RTIME
                   write(*,4006) RTIME,FNAME
                   DO K=1,NNP
                      READ (33,*) THNPV(K)
                   ENDDO
                   IF (RTIME.LT.HSTIME) GO TO 107
                   IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                         GO TO 108
                   ELSE
	       call stopfile  ! emrl jig
                         STOP 'endf33'
                   ENDIF
               ENDIF
  108          CONTINUE
C
               IF (JIBF.EQ.1) THEN
C
C -----        flux at the boundary nodes (flow)
C
                  INQUIRE(32,NAME=FNAME)
                  write(*,2001) FNAME
                  READ(32,1001) STITLE
                  READ(32,1007) STITLE,TITLE1
                  READ(32,1002) TITLE1
                  IF (TITLE1.NE.'BEGSCL') THEN
                          WRITE(*,4001) TITLE1
	       call stopfile  ! emrl jig
                          STOP 'R_bfx'
                  ENDIF
                  READ(32,1003) IC1,NOD
                  READ(32,1003) IC1,NELM
                  IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                          WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                          STOP 'bfx_nod'
                  ENDIF
                  READ(32,1004) CHAR,TITLE2
  109             READ(32,1005) IC1,ISTAT,RTIME
                  write(*,4006) RTIME,FNAME
                  DO K=1,NNP
                     READ (32,*) FFLXB(K)
                  ENDDO
                  IF (RTIME.LT.HSTIME) GO TO 109
                  IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                          RETURN
                  ELSE
	       call stopfile  ! emrl jig
                          STOP 'endf32'
                  ENDIF
               ENDIF
            ENDIF
C
C    #####  Binary file   #####
C
         ELSEIF (ICFILE.EQ.1) THEN
C
C       &&&&& steady state  &&&&&
C
            IF (KSSF.EQ.0) THEN
C
C          -----   pressure head
C
               INQUIRE(41,NAME=FNAME)
               write(*,2001) FNAME
               READ(41) IVERS,ID1,JD1,ID2,JD2,ID3,JD3
               READ(41) IDUMP
               IF (IDUMP.NE.ISCL) THEN
                       WRITE(*,4002) IDUMP
	       call stopfile  ! emrl jig
                       STOP 'R_ph'
               ENDIF
               READ(41) IDUMP,NOD
               READ(41) IDUMP,NELM
               READ(41) IDUMP,TITLE2
               IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                       WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                       STOP 'ph_nod'
               ENDIF
               READ(41) IDUMP,JDUMP,RTIME
               write(*,4006) RTIME,FNAME
               READ(41) (H(I),I=1,NNP)
               DO I=1,NNP
                  HT(I)=H(I)+X(I,3)
               ENDDO
C
C         ----- compute moisture content at Gaussian points
C
               CALL CALMC (TH,H,IE)
C
               IF (JICV.EQ.0) THEN
C
C         ----- compute velocity based on pressure head
C
                   CALL CALKR (AKHC,H,CP,IE,PROPF,RHOMU)
                   CALL VELT (V,IE,H,AKHC)
C
               ELSEIF (JICV.EQ.-1) THEN
C
C         ----- velocity
C
                   INQUIRE(44,NAME=FNAME)
                   write(*,2001) FNAME
                   READ(44) IVERS,ID1,JD1,ID2,JD2,ID3,JD3
                   READ(44) IDUMP
                   IF (IDUMP.NE.IVEC) THEN
                            WRITE(*,4004) IDUMP
	       call stopfile  ! emrl jig
                            STOP 'R_vel'
                   ENDIF
                   READ(44) IDUMP,NOD
                   READ(44) IDUMP,NELM
                   READ(44) IDUMP,TITLE2
                   IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                           WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                           STOP 'v_nod'
                   ENDIF
                   READ(44) IDUMP,JDUMP,RTIME
                   write(*,4006) RTIME,FNAME
                   READ(44) ((V(I,J),J=1,3),I=1,NNP)
               ENDIF
               RETURN
C
C   -----  transient   -----
C
            ELSEIF (KSSF.EQ.1) THEN
C
C        --- pressure head
C
               INQUIRE(41,NAME=FNAME)
               write(*,2001) FNAME
               READ(41) IVERS,ID1,JD1,ID2,JD2,ID3,JD3
               READ(41) IDUMP
               IF (IDUMP.NE.ISCL) THEN
                      WRITE(*,4002) IDUMP
	       call stopfile  ! emrl jig
                      STOP 'R_ph'
               ENDIF
               READ(41) IDUMP,NOD
               READ(41) IDUMP,NELM
               READ(41) IDUMP,TITLE2
               IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                      WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                      STOP 'ph_nod'
               ENDIF
  110          READ(41) IDUMP,JDUMP,RTIME
               write(*,4006) RTIME,FNAME
               READ(41) (H(I),I=1,NNP)
               IF (RTIME.LT.HSTIME) GO TO 110
               IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                   DO I=1,NNP
                      HT(I)=H(I)+X(I,3)
                   ENDDO
                   GO TO 111
               ELSE
	       call stopfile  ! emrl jig
                    STOP 'endf31'
               ENDIF
C
C          ---   Compute moisture contents at Gaussian points
C
  111          CALL CALMC (TH,H,IE)
C
               IF (JICV.EQ.0) THEN
C
C          ----- compute velocity based on pressure head
C
                  CALL CALKR (AKHC,H,CP,IE,PROPF,RHOMU)
                  CALL VELT (V,IE,H,AKHC)
C
               ELSEIF (JICV.EQ.-1) THEN
C
C           ---  velocity
C
                  INQUIRE(44,NAME=FNAME)
                  WRITE(*,2001) FNAME
                  READ(44) IVERS,ID1,JD1,ID2,JD2,ID3,JD3
                  READ(44) IDUMP
                  IF (IDUMP.NE.IVEC) THEN
                        WRITE(*,4004) IDUMP
	       call stopfile  ! emrl jig
                        STOP 'R_vel'
                  ENDIF
                  READ(44) IDUMP,NOD
                  READ(44) IDUMP,NELM
                  READ(44) IDUMP,TITLE2
                  IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                        WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                        STOP 'v_nod'
                  ENDIF
  112             READ(44) IDUMP,JDUMP,RTIME
                  write(*,4006) RTIME,FNAME
                  READ(44) ((V(I,J),J=1,3),I=1,NNP)
                  IF (RTIME.LT.HSTIME) GO TO 112
                  IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                        GO TO 113
                  ELSE
	       call stopfile  ! emrl jig
                        STOP 'endf35'
                  ENDIF
               ENDIF
  113          CONTINUE
C
               IF (JICM.EQ.-1) THEN
C
C        ----- Nodal moisture contents
C
                  INQUIRE(43,NAME=FNAME)
                  write(*,2001) FNAME
                  READ(43) IVERS,ID1,JD1,ID2,JD2,ID3,JD3
                  READ(43) IDUMP
                  IF (IDUMP.NE.ISCL) THEN
                          WRITE(*,4002) IDUMP
	       call stopfile  ! emrl jig
                          STOP 'R_mc'
                  ENDIF
                  READ(43) IDUMP,NOD
                  READ(43) IDUMP,NELM
                  READ(43) IDUMP,TITLE2
                  IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                          WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                          STOP 'mc_nod'
                  ENDIF
  114             READ(43) IDUMP,JDUMP,RTIME
                  write(*,4006) RTIME,FNAME
                  READ(43) (THNPV(I),I=1,NNP)
                  IF (RTIME.LT.HSTIME) GO TO 114
                  IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                         GO TO 115
                  ENDIF
               ENDIF
  115          CONTINUE
C
               IF (JIBF.EQ.-1) THEN
C
C -----        flux at the boundary nodes (flow)
C
                  INQUIRE(42,NAME=FNAME)
                  write(*,2001) FNAME
                  READ(42) IVERS,ID1,JD1,ID2,JD2,ID3,JD3
                  READ(42) IDUMP
                  IF (IDUMP.NE.ISCL) THEN
                          WRITE(*,4002) IDUMP
	       call stopfile  ! emrl jig
                          STOP 'R_bfx'
                  ENDIF
                  READ(42) IDUMP,NOD
                  READ(42) IDUMP,NELM
                  READ(42) IDUMP,TITLE2
                  IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                          WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                          STOP 'bfx_nod'
                  ENDIF
  116             READ(42) IDUMP,JDUMP,RTIME
                  write(*,4006) RTIME,FNAME
                  READ(42) (FFLXB(I),I=1,NNP)
                  IF (RTIME.LT.HSTIME) GO TO 116
                  IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                         RETURN
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      RETURN
 1001 FORMAT(A7)
 1002 FORMAT(A6)
 1003 FORMAT(A2,I8)
 1004 FORMAT(A4,1X,A40)
 1005 FORMAT(A2,I4,E16.8)
 1006 FORMAT(3(1X,E16.8))
 1007 FORMAT(A7,1X,A6)
 1008 FORMAT(8E16.8)
 1009 FORMAT(3X,'Time:',F12.5)
 1010 FORMAT(3X,'Written on file ',A72)
 2001 FORMAT('   Reading from file ',A72)
 4001 FORMAT('   Error: this is not a scalar file (ascii form)',A6)
 4002 FORMAT('   Error: this is not a scalar file (binary form)',I8)
 4003 FORMAT('   Error: this is not a vector file (ascii form)',A6)
 4004 FORMAT('   Error: this is not a vector file (binary form)',I8)
 4005 FORMAT('   Error: total nodes and elements did not match',2I8)
 4006 FORMAT(3X,'Time:',F10.2,2X,' read from file :',A72)
      END
C
      SUBROUTINE RINITR (CP,TFLXB)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      CHARACTER STITLE*7,IC1*2,CHAR*4,TITLE1*6,TITLE2*40
      CHARACTER FNAME*80
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /ICREAL/ HCONST,CONVAL,HSTIME
      COMMON /ICINT / IHEAD,ICON,ISTART
      COMMON /TCCARD/ IUNIT,JOPT,KOPT,IFILE,NPRINT,NPOST,
     1               ICFILE,IVFILE,PTIMES(MXPOST),POTIME(MXPOST)
      COMMON /ICCARD/ JICH,JICV,JICC,JICM,JIBF,JIBT,
     1               JPH,JCN,JVL,JMN,JMC,JBF,JBT
      COMMON /FTFILE/ KPH,KCN,KVL,KMC,KBF,KBT,JFILE,KFILE
C
      DIMENSION CP(MAXNPK),TFLXB(MAXNPK)
C
      DATA ISTAT,ISCL/0,130/
C
C *****    Transport only     *****
C
C ----- cold start
C
      IF (ISTART.EQ.0) THEN
C
C     ------ constant initial concentration
C
         IF (ICON.EQ.0) THEN
             DO I=1,NNP
                CP(I)=CONVAL
             ENDDO
             write(*,'(A,//)') '   Read constant intial concentration '
             RETURN
         ENDIF
C
C       ---------- ASCII file
C
         IF (JICC.EQ.1) THEN
C
C          ------ concentration
C
             INQUIRE(51,NAME=FNAME)
             write(*,2001) FNAME
             READ(51,1001) STITLE
             READ(51,1007) STITLE,TITLE1
             READ(51,1002) TITLE1
             IF (TITLE1.NE.'BEGSCL') THEN
                   WRITE(*,4001) TITLE1
	       call stopfile  ! emrl jig
                   STOP 'R_con'
             ENDIF
             READ(51,1003) IC1,NOD
             READ(51,1003) IC1,NELM
             IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                   WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                   STOP 'con_nod'
             ENDIF
             READ(51,1004) CHAR,TITLE2
             READ(51,1005) IC1,IDUMP,RTIME
             write(*,4006) RTIME,FNAME
             DO K=1,NNP
                READ (51,*) CP(K)
             ENDDO
C
C     -------------   Binary file
C
         ELSEIF (JICC.EQ.-1) THEN
C
C          ------ concentration
C
             INQUIRE(61,NAME=FNAME)
             write(*,2001) FNAME
             READ(61) IVERS,ID1,JD1,ID2,JD2,ID3,JD3
             READ(61) IDUMP
             IF (IDUMP.NE.ISCL) THEN
                   WRITE(*,4002) IDUMP
	       call stopfile  ! emrl jig
                   STOP 'R_con'
             ENDIF
             READ(61) IDUMP,NOD
             READ(61) IDUMP,NELM
             READ(61) IDUMP,TITLE2
             READ(61) IDUMP,JDUMP, RTIME
             write(*,4006) RTIME,FNAME
             READ(61) (CP(I),I=1,NNP)
         ENDIF
C
C ------  hot start
C
      ELSEIF (ISTART.EQ.1) THEN
C
C       ---------- ASCII file
C
         IF (JICC.EQ.1) THEN
C
C          ------ concentration
C
             INQUIRE(51,NAME=FNAME)
             write(*,2001) FNAME
             READ(51,1001) STITLE
             READ(51,1007) STITLE,TITLE1
             READ(51,1002) TITLE1
             IF (TITLE1.NE.'BEGSCL') THEN
                   WRITE(*,4001) TITLE1
	       call stopfile  ! emrl jig
                   STOP 'R_con'
             ENDIF
             READ(51,1003) IC1,NOD
             READ(51,1003) IC1,NELM
             IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                   WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                   STOP 'con_nod'
             ENDIF
             READ(51,1004) CHAR,TITLE2
  101        READ(51,1005) IC1,ISTAT,RTIME
             write(*,4006) RTIME,FNAME
             DO K=1,NNP
                READ(51,*) CP(K)
             ENDDO
             IF (RTIME.LT.HSTIME) GO TO 101
             IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                  GO TO 102
             ELSE
	       call stopfile  ! emrl jig
                  STOP 'endf51'
             ENDIF
C
  102        IF (JIBT.EQ.1) THEN
C
C          ------ flux at the boundary nodes (transport)
C
                INQUIRE(52,NAME=FNAME)
                write(*,2001) FNAME
                READ(52,1001) STITLE
                READ(52,1007) STITLE,TITLE1
                READ(52,1002) TITLE1
                IF (TITLE1.NE.'BEGSCL') THEN
                   WRITE(*,4001) TITLE1
	       call stopfile  ! emrl jig
                   STOP 'R_mfx'
                ENDIF
                READ(52,1003) IC1,NOD
                READ(52,1003) IC1,NELM
                IF (NOD.NE.NNP .OR. NELM.NE.NEL) THEN
                   WRITE(*,4005) NOD,NELM
	       call stopfile  ! emrl jig
                   STOP 'mfx_nod'
                ENDIF
                READ(52,1004) CHAR,TITLE2
  103           READ(52,1005) IC1,ISTAT,RTIME
                write(*,4006) RTIME,FNAME
                DO K=1,NNP
                   READ(52,*) TFLXB(K)
                ENDDO
                IF (RTIME.LT.HSTIME) GO TO 103
                IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                   RETURN
                ELSE
	       call stopfile  ! emrl jig
                  STOP 'endf52'
                ENDIF
             ENDIF
C
C     -------------   Binary file
C
          ELSEIF (JICC.EQ.-1) THEN
C
C          ------ concentration
C
             INQUIRE(61,NAME=FNAME)
             write(*,2001) FNAME
             READ(61) IVERS,ID1,JD1,ID2,JD2,ID3,JD3
             READ(61) IDUMP
             IF (IDUMP.NE.ISCL) THEN
                     WRITE(*,4002) IDUMP
	       call stopfile  ! emrl jig
                     STOP 'R_con'
             ENDIF
             READ(61) IDUMP,NOD
             READ(61) IDUMP,NELM
             READ(61) IDUMP,TITLE2
  104        READ(61) IDUMP,JDUMP,RTIME
             write(*,4006) RTIME,FNAME
             READ(61) (CP(I),I=1,NNP)
             IF (RTIME.LT.HSTIME) GO TO 104
             IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                   GO TO 105
             ELSE
	       call stopfile  ! emrl jig
                   STOP 'endf61'
             ENDIF
C
  105        IF (JIBT.EQ.-1) THEN
C
C          ------ flux at the boundary nodes (transport)
C
                INQUIRE(62,NAME=FNAME)
                write(*,2001) FNAME
                READ(62) IVERS,ID1,JD1,ID2,JD2,ID3,JD3
                READ(62) IDUMP
                IF (IDUMP.NE.ISCL) THEN
                     WRITE(*,4002) IDUMP
	       call stopfile  ! emrl jig
                     STOP 'mfx_con'
                ENDIF
                READ(62) IDUMP,NOD
                READ(62) IDUMP,NELM
                READ(62) IDUMP,TITLE2
  106           READ(62) IDUMP,JDUMP,RTIME
                write(*,4006) RTIME,FNAME
                READ(62) (TFLXB(I),I=1,NNP)
                IF (RTIME.LT.HSTIME) GO TO 106
                IF (DABS(RTIME-HSTIME).LE.0.0001) THEN
                   RETURN
                ELSE
	       call stopfile  ! emrl jig
                   STOP 'endf62'
                ENDIF
             ENDIF
          ENDIF
      ENDIF
      RETURN
 1001 FORMAT(A7)
 1002 FORMAT(A6)
 1003 FORMAT(A2,I8)
 1004 FORMAT(A4,1X,A40)
 1005 FORMAT(A2,I4,E16.8)
 1006 FORMAT(3(1X,E16.8))
 1007 FORMAT(A7,1X,A6)
 1008 FORMAT(8E16.8)
 1009 FORMAT(3X,'Time:',F12.5)
 1010 FORMAT(3X,'Written on file ',A72)
 2001 FORMAT('   Reading from file ',A72)
 4001 FORMAT('   Error: this is not a scalar file (ascii form)',A6)
 4002 FORMAT('   Error: this is not a scalar file (binary form)',I8)
 4003 FORMAT('   Error: this is not a vector file (ascii form)',A6)
 4004 FORMAT('   Error: this is not a vector file (binary form)',I8)
 4005 FORMAT('   Error: total nodes and elements did not match',2I8)
 4006 FORMAT(3X,'Time:',F10.2,2X,' read from file :',A72)
      END
C
      SUBROUTINE RDATIO (PROPF,RHOMU,PROPT,IE,KCP)
C
C***  READ MATERIAL PROPERTIES, SOIL PRPOPERTIY PARAMETERS, COORDINATE,
C***   SUBREGION DATA, ELEMENT CONNECTIVITY, AND MATERIAL TYPES.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /FINTE/ NCYLF,NITERF,NPITERF,KSP,KGRAV,IPNTSF
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /TINTE/ NCMT,NITERT,NPITERT,IPNTST
C
      COMMON /SPCARD/ NUNSAT,NSP(MXMATK),IHM(MXMATK),IHC(MXMATK),
     1       IHW(MXMATK),NPMC(MXMATK),NPCON(MXMATK),NPWC(MXMATK)
      COMMON /MPCARD/ NDVFUN,NPROPF(MXMATK),NPROPT(MXMATK)
      COMMON /UNSAT/ PH(MXSPMK,MXMATK),PMC(MXSPMK,MXMATK),
     1               PCON(MXSPMK,MXMATK),CONDUC(MXSPMK,MXMATK),
     2               PWC(MXSPMK,MXMATK),WC(MXSPMK,MXMATK),
     &               PMKNOT(MXSPMK + 4, MXMATK), PCKNOT(MXSPMK + 4,
     &               MXMATK), PWKNOT(MXSPMK + 4, MXMATK),
     &               PMCOEF(MXSPMK, MXMATK), PCCOEF(MXSPMK, MXMATK),
     &               PWCOEF(MXSPMK, MXMATK), IBSPL
C
      DIMENSION PROPF(9,MXMATK),RHOMU(MXRMPK),PROPT(13,MXMATK)
      DIMENSION IE(MAXELK,9)
C
C ******* DATA SET 5: MATERIAL PROPERTIES
C
      WRITE(16,2000) NMAT,NMPPM,NRMP
      WRITE(16,2100)
      DO K=1,NMAT
         I=NPROPF(K)
         WRITE(16,2110) I,(PROPF(J,K),J=1,NMPPM)
      ENDDO
      WRITE(16,2120)
      WRITE(16,2130) (RHOMU(I),I=1,NRMP)
C
C ******* DATA SET 6: SOIL PROPERTIES
C
      WRITE(16,2230) NUNSAT,KCP,RHO,GRAV,VISC,BETAP
      WRITE(16,2200)
      DO K=1,NDVFUN
         I=NPROPT(K)
         WRITE(16,2210) I,(PROPT(J,K),J=1,8),(PROPT(J,K),J=11,12)
      ENDDO
C
      IF (KCP.NE.0) THEN
C
C ####  Convert saturated permeability to saturated conductivity
C
          DO I=1,NMAT
             PKCF=RHO*GRAV/VISC
             DO J=1,6
                PROPF(J,I)=PROPF(J,I)*PKCF
             ENDDO
          ENDDO
      END IF
      WRITE(16,2500) NEL
 2500 FORMAT(//,' ***** ELEMENT DATA *****'/5X,
     1 ' NO. OF ELEMENTS, NEL . . . . . . . . . . . . . . . .',I5)
      WRITE(16,2300) NNP
 2300 FORMAT(' ***** NODAL COORDINATE DATA *****'/,5X,
     1 ' NO. OF NODAL POINTS, NNP . . . . . . . . . . . . . .',I5/)
C
C ##### Print element incidences and material types
C
          WRITE(25,2710)
          DO NI=1,NEL
             WRITE(25,2715) NI,(IE(NI,K),K=1,9)
          ENDDO
C
C ------- Check if material type for each element is correct
C
      DO 820 M=1,NEL
         MTYP=IE(M,9)
         DO I=1,NUNSAT
            IF (MTYP.EQ.NSP(I)) GO TO 820
         ENDDO
         WRITE(16,2810) M, MTYP
         WRITE(*,2810) M, MTYP
	       call stopfile  ! emrl jig
         STOP
  820 CONTINUE
      RETURN
 2000 FORMAT(' *** MATERIAL PROPERTIES *** '/5X,
     1 ' NUMBER OF DIFFERENT MATERIALS, NMAT. . . . . . . . .',I5/5X,
     2 ' NUMBER OF MATERIAL PROPERTIES PER MATERIAL, NMPPM  .',I5/5X,
     3 ' NUMBER OF DENSITY AND VISCOSITY FUNCTION COEFFS. . .',I5//)
 2100 FORMAT(5X,'MAT NO.  SAT KXX    SAT KYY    SAT KZZ    SAT KXY  ',
     1 '  SAT KXZ    SAT KXZ    Alpha   Porosity ',/5X,
     2 '-------  -------    -------    -------    -------  ',
     3 '  -------    -------    -------    -------  ')
 2110 FORMAT(5X,I7,8(1PD11.4))
 2120 FORMAT(/' *** DENSITY AND VISCOSITY FUNCTION COEFF.S ***'/
     1 '    RHO0   ','     B1    ','     B2    ','     B3    ',
     2 '    MU0  ','     A1    ','     A2    ','     A3    ')
 2130 FORMAT(8G11.4,/)
 2200 FORMAT('MAT. NO.    KD       RHOB       AL        AT        AM  ',
     1 '         TAU     LAMADA   N OR SMAX     Kw          Ks     '
     2 /1X,'-------- --------  --------  --------  --------  -------- ',
     3 ' --------  --------  ----------  ----------  ----------')
 2210 FORMAT(1X,I8, 10(1PD10.3)/)
 2230 FORMAT(1H ,'**** SOIL PROPERTY PARAMETERS ****'//5X,
     1 'NUMBER OF SOIL PROPERTY PARAMETERS, NSPPM  . . . . .',I5/5X,
     2 'PERMEABILITY INPUT CONTROL, KCP  . . . . . . . . . .',I5/5X,
     3 ' DENSITY OF WATER, RHO . . . . . . . . . . . . . .',1PD15.6/5X,
     4 ' ACCELERATION OF GRAVITY, GRAV . . . . . . . . . .',1PD15.6/5X,
     5 ' VISCOSITY OF WATER, VISC. . . . . . . . . . . . .',1PD15.6/5X,
     6 ' Compressibility of water. . . . . . . . . . . . .',1PD15.6/)
 2270 FORMAT('  *** SOIL CHARACTERISTIC VALUES'/)
 2271 FORMAT(1H  ,'MATERIAL NO.',I5)
 2278 FORMAT(/,5X,'XY SERIES NO.',I3,7X,'NO. OF POINTS=',I4,/)
 2272 FORMAT(10X,'PRESSURE',14X,'MOISTURE CONTENT')
 2273 FORMAT(10X,1PD13.6,10X,1PD13.6)
 2274 FORMAT(10X,'PRESSURE',14X,'REL. CONDUCTIVITY')
 2275 FORMAT(10X,1PD13.6,10X,1PD13.6)
 2276 FORMAT(10X,'PRESSURE',15X,'WATER CAPACITY')
 2277 FORMAT(10X,1PD13.6,10X,1PD13.6)
 2280 FORMAT(1H ,'*** ERROR IN READING SOIL PROPERTY DATA:',
     1 ' NSPPM =',I5,'  STOP ***')
 2715 FORMAT(5X,10I5)
 2710 FORMAT('   **** GLOBAL INDICES OF ELEMENT NODES ****'//5X,
     1 '  ELM NOD1 NOD2 NOD3 NOD4 NOD5 NOD6 NOD7 NOD8 MTYP'/5X,
     2 '  --- ---- ---- ---- ---- ---- ---- ---- ---- ----')
 2810 FORMAT(////40H ERROR IN MATERIAL TYPE CODE FOR ELEMENT,I8,I6/)
      END
C
      SUBROUTINE FTSDAT
C
C ------- TO READ AND PRINT SOURCE/SINK
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /FPS/ NWNPF,NWPRF,NWDPF(MXWPRH)
      COMMON /TPS/ NWNPT,NWPRT,NWDPT(MXWPRC)
      COMMON /BLKPSF/ WSSF(MXWPRH),WSSFF(MXWDPH,MXWPRH),
     1                TWSSFF(MXWDPH,MXWPRH),IWTYPF(MXWNPH),
     2                NPWF(MXWNPH),JWTYPF(MXWNPH)
      COMMON /BLKPST/ WSST(MXWPRC),WSSFT(MXWDPC,MXWPRC),
     1                TWSSFT(MXWDPC,MXWPRC),IWTYPT(MXWNPC),
     2                NPWT(MXWNPC),JWTYPT(MXWNPC)
      COMMON /TCONV/ NTY1(MXXYS),NTY2(MXXYS),NTY3(MXXYS),NTY4(MXXYS),
     1               NTY5(MXXYS),NTY6(MXXYS),NTY7(MXXYS),NTY8(MXXYS),
     2               NTY9(MXXYS),NTY10(MXXYS),NTY11(MXXYS),NTY12(MXXYS)
C
C ****   Point (well) source/sink for flow and transport
C
      IF (NWNPF.NE.0) THEN
          WRITE(16,2300) NWNPF,NWPRF
          DO I=1,NWPRF
             WRITE(16,2310) NTY1(I)
             DO J=1,NWDPF(I)
                WRITE(16,2320) TWSSFF(J,I),WSSFF(J,I)
             ENDDO
          ENDDO
C
C ------- Print global well node numbers and profile type of well node
C
          WRITE(16,2350)
          DO I=1,NWNPF,4
             J1=I
             J2=MIN0(I+3,NWNPF)
             DO J=J1,J2
                  WRITE(16,2360)  J,NPWF(J),IWTYPF(J)
             ENDDO
          ENDDO
      ENDIF
C
      IF (NWNPT.NE.0) THEN
          WRITE(16,2370) NWNPT,NWPRT
          DO I=1,NWPRT
             WRITE(16,2330) NTY2(I)
             DO J=1,NWDPT(I)
                WRITE(16,2340) TWSSFT(J,I),WSSFT(J,I)
             ENDDO
          ENDDO
C
C ------- Print global well node numbers and profile type of well node
C
          WRITE(16,2350)
          DO I=1,NWNPT,4
             J1=I
             J2=MIN0(I+3,NWNPT)
             DO J=J1,J2
                  WRITE(16,2360)  J,NPWT(J),IWTYPT(J)
             ENDDO
          ENDDO
      ENDIF
      RETURN
 2300 FORMAT(//5X,' *** WELL (POINT) SOURCE/SINK ***'//5X,
     1 'NO. OF WELL-SOURCE/SINK NODES, NWNPF . . . . . . . . .',I5/5X,
     2 'NO. OF  SOURCE/SINK XY series, NWPRF . . . . . . . . .',I5/)
 2310 FORMAT(1H ,/5X,'POINT SOURCE/SINK :',
     1 //,5X,'XY series number :',I4,
     2 //,5X,'TIME          FLOW    ' /1X,  4X,'----         -----  ' )
 2320 FORMAT(1H ,1PD11.3,3X,1PD11.3 )
 2330 FORMAT(1H ,/5X,' XY series number :',I4,//
     1 '     TIME          CONC  ',/'     ----           ----       ')
 2340 FORMAT(1H ,1PD11.3,3X,1PD11.3 )
 2350 FORMAT(1H ,//10X,'NODAL NUMBER OF WELL AND XY SERIES OF BOUNDARY',
     1 ' TYPE'//1X,  '    I  NPW   XY-series   ' /1X,
     2   '    -  ---   --------    ' )
 2360 FORMAT(1H ,2I5,2(5X,I5) )
 2370 FORMAT(//5X,' *** WELL (POINT) SOURCE/SINK ***'//5X,
     1 'NO. OF WELL-SOURCE/SINK NODES, NWNPT . . . . . . . . .',I5/5X,
     2 'NO. OF  SOURCE/SINK XY series, NWPRT . . . . . . . . .',I5/)
      END
C
      SUBROUTINE TBCDAT (ISB,NPBB,IB)
C
C ------- TO READ AND PRINT BOUNDARY CONDITIONS
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
C
      COMMON /TDBC/ NDNPT,NDPRT,NDDPT(MXDPRC)
      COMMON /TCBC/ NCEST,NCNPT,NCPRT,NCDPT(MXCPRC)
      COMMON /TVBC/ NVEST,NVNPT,NVPRT,NVDPT(MXVPRC)
      COMMON /TNBC/ NNEST,NNNPT,NNPRT,NNDPT(MXNPRC)
C
      COMMON /BLKDBT/ CDBT(MXDPRC),CDBFT(MXDDPC,MXDPRC),
     1        TCDBFT(MXDDPC,MXDPRC),IDTYPT(MXDNPC),
     2        NPDBT(MXDNPC),JDTYPT(MXDNPC)
      COMMON /BLKCBT/ QCBT(MXCPRC),QCBFT(MXCDPC,MXCPRC),
     1        TQCBFT(MXCDPC,MXCPRC),ICTYPT(MXCESC),ISCT(5,MXCESC),
     2        NPCBT(MXCNPC),IDCT(MXCESC),JCTYPT(MXCESC)
      COMMON /BLKVBT/ CVBT(MXVPRC),CVBFT(MXVDPC,MXVPRC),
     1        TCVBFT(MXVDPC,MXVPRC),IVTYPT(MXVESC),ISVT(5,MXVESC),
     2        NPVBT(MXVNPC),IDVT(MXVESC),JVTYPT(MXVESC)
      COMMON /BLKNBT/ QNBT(MXNPRC),QNBFT(MXNDPC,MXNPRC),
     1        TQNBFT(MXNDPC,MXNPRC),INTYPT(MXNESC),ISNT(5,MXNESC),
     2        NPNBT(MXNNPC),IDNT(MXNESC),JNTYPT(MXNESC)
      COMMON /TCONV/ NTY1(MXXYS),NTY2(MXXYS),NTY3(MXXYS),NTY4(MXXYS),
     1              NTY5(MXXYS),NTY6(MXXYS),NTY7(MXXYS),NTY8(MXXYS),
     2              NTY9(MXXYS),NTY10(MXXYS),NTY11(MXXYS),NTY12(MXXYS)
C
      DIMENSION ISB(6,MXBESK),NPBB(MXBNPK),IB(MAXNPK),NIMI(4),NJMJ(4)
C
C ******* DATA SET 13: VARIABLE BOUNDARY CONDITIONS
C
      IF (NVEST.GT.0) THEN
          WRITE(16,2100) NVEST,NVNPT,NVPRT
C
C ------- Read and write concentration profiles
C
          WRITE(16,2110)
          DO I=1,NVPRT
             WRITE(16,2120) NTY4(I)
             DO J=1,NVDPT(I)
                WRITE(16,2125)  TCVBFT(J,I),CVBFT(J,I)
             ENDDO
          ENDDO
C
C ------- Assign boundary node information to array IB
C
          DO I=1,NVNPT
             NP=NPVBT(I)
             IB(NP)=2
          ENDDO
C
C ------- Print inputted global nodal number and rainfall types of all
C ------- variable boundary element sides
C
          WRITE(16,2140)
          DO MP=1,NVEST,3
             J1=MP
             J2=MIN0(MP+2,NVEST)
             WRITE(16,2145) (J,(ISVT(I,J),I=1,4),IVTYPT(J),J=J1,J2)
          ENDDO
C
C ------ Print global node number for each of all vb nodes
C
          WRITE(16,2150)
          DO I=1,NVNPT,6
             J1=I
             J2=MIN0(I+5,NVNPT)
             WRITE(16,2155) (J,NPVBT(J),J=J1,J2)
          ENDDO
C
C ------- Compute boundary side number for all variable boundary sides
C
          DO 659 MI=1,NVEST
             NODEI=4
             IF (ISVT(4,MI).EQ.0) NODEI=3
             DO IQ=1,NODEI
                NIMI(IQ)=ISVT(IQ,MI)
             ENDDO
             DO 657 MJ=1,NBES
                NODEJ=4
                IF (ISB(4,MJ).EQ.0) NODEJ=3
                DO JQ=1,NODEJ
                   IJ=ISB(JQ,MJ)
                   NJMJ(JQ)=NPBB(IJ)
                ENDDO
                IEQ=0
                DO IQ=1,NODEI
                   NI=NIMI(IQ)
                   DO JQ=1,NODEJ
                      NJ=NJMJ(JQ)
                      IF(NJ.EQ.NI) GO TO 655
                   ENDDO
                   GO TO 657
  655              IEQ=IEQ+1
                ENDDO
                IF(IEQ.EQ.NODEI .AND. IEQ.EQ.NODEJ) GO TO 658
  657        CONTINUE
             WRITE(16,2160) MI
             WRITE(*,2160) MI
	       call stopfile  ! emrl jig
             STOP
  658        ISVT(5,MI)=MJ
  659     CONTINUE
C
C ------- Change npvb from containing global node number to
C ------- contain boundary node number
C
          DO 669 NP=1,NVNPT
             NI=NPVBT(NP)
             DO 665 I=1,NBNP
                NJ=NPBB(I)
                IF(NJ.NE.NI) GO TO 665
                NII=I
                GO TO 667
  665        CONTINUE
             WRITE(16,2170) NP
             WRITE(*,2170) NP
	       call stopfile  ! emrl jig
             STOP
  667        NPVBT(NP)=NII
  669     CONTINUE
C
C ------- Print computed boundary nodal number for all vb nodes
C
          WRITE(16,2180)
          DO I=1,NVNPT,6
             J1=I
             J2=MIN0(I+5,NVNPT)
             WRITE(16,2185) (J,NPVBT(J),J=J1,J2)
          ENDDO
      END IF
C
C ******* DATA SET 14: DIRICHLET BOUNDARY CONDITIONS
C
      IF (NDNPT.GT.0) THEN
C
C ------- Read and print dirichlet concentration profile
C
          WRITE(16,2200) NDNPT,NDPRT
          DO I=1,NDPRT
             WRITE(16,2220) NTY6(I)
             DO J=1,NDDPT(I)
                WRITE(16,2225)  TCDBFT(J,I),CDBFT(J,I)
             ENDDO
          ENDDO
C
C ------- Assign boundary node information to array IB
C
          DO I=1,NDNPT
             NP=NPDBT(I)
             IB(NP)=1
          ENDDO
C
C ------- Print global node number and profile types of dirichlet nodes
C
          WRITE(16,2230)
          DO I=1,NDNPT,5
             J1=I
             J2=MIN0(I+4,NDNPT)
             WRITE(16,2235) (J,NPDBT(J),IDTYPT(J),J=J1,J2)
          ENDDO
      END IF
C
C ******* DATA SET 15: CAUCHY BOUNDARY CONDITIONS
C
      IF (NCEST.GT.0) THEN
          WRITE(16,2300) NCEST,NCNPT,NCPRT
          DO I=1,NCPRT
             WRITE(16,2320) NTY8(I)
             DO J=1,NCDPT(I)
                WRITE(16,2325)  TQCBFT(J,I),QCBFT(J,I)
             ENDDO
          ENDDO
C
C ------- Assign boundary node information to array IB
C
          DO I=1,NCNPT
             NP=NPCBT(I)
             IB(NP)=3
          ENDDO
C
C ------- Print inputted global nodal number and flux types of all
C ------- cauchy boundary element sides
C
          WRITE(16,2340)
          DO MP=1,NCEST,3
            J1=MP
            J2=MIN0(MP+2,NCEST)
            WRITE(16,2345) (J,(ISCT(I,J),I=1,4),ICTYPT(J),J=J1,J2)
          ENDDO
C
C ------ Print global node number for each of all cauchy nodes
C
          WRITE(16,2350)
          DO I=1,NCNPT,10
             J1=I
             J2=MIN0(I+9,NCNPT)
             WRITE(16,2355) (J,NPCBT(J),J=J1,J2)
          ENDDO
C
C ------- Compute boundary side number for all cauchy sides
C
          DO 859 MI=1,NCEST
             NODEI=4
             IF (ISCT(4,MI).EQ.0) NODEI=3
             DO IQ=1,NODEI
                NIMI(IQ)=ISCT(IQ,MI)
             ENDDO
             DO 857 MJ=1,NBES
                NODEJ=4
                IF (ISB(4,MJ).EQ.0) NODEJ=3
                DO JQ=1,NODEJ
                   IJ=ISB(JQ,MJ)
                   NJMJ(JQ)=NPBB(IJ)
                ENDDO
                IEQ=0
                DO IQ=1,NODEI
                   NI=NIMI(IQ)
                   DO JQ=1,NODEJ
                      NJ=NJMJ(JQ)
                      IF(NJ.EQ.NI) GO TO 855
                   ENDDO
                   GO TO 857
  855              IEQ=IEQ+1
                ENDDO
                IF(IEQ.EQ.NODEI .AND. IEQ.EQ.NODEJ) GO TO 858
  857        CONTINUE
             WRITE(16,2360) MI
             WRITE(*,2360) MI
	       call stopfile  ! emrl jig
             STOP
  858        ISCT(5,MI)=MJ
  859     CONTINUE
C
C ------- Change npcb from containing global node number to
C ------- contain boundary node number
C
          DO 869 NP=1,NCNPT
             NI=NPCBT(NP)
             DO 865 I=1,NBNP
                NJ=NPBB(I)
                IF(NJ.NE.NI) GO TO 865
                NII=I
                GO TO 867
  865        CONTINUE
             WRITE(16,2370) NP
             WRITE(*,2370) NP
	       call stopfile  ! emrl jig
             STOP
  867        NPCBT(NP)=NII
  869     CONTINUE
C
C ------- Print computed boundary nodal number for all cauchy nodes
C
          WRITE(16,2380)
          DO I=1,NCNPT,10
             J1=I
             J2=MIN0(I+9,NCNPT)
             WRITE(16,2385) (J,NPCBT(J),J=J1,J2)
          ENDDO
      END IF
C
C ******* DATA SET 16:  NEUMANN BOUNDARY CONDITIONS
C
      IF (NNEST.GT.0) THEN
          WRITE(16,2400) NNEST,NNNPT,NNPRT
          DO I=1,NNPRT
             WRITE(16,2420) NTY10(I)
             DO J=1,NNDPT(I)
                WRITE(16,2425) TQNBFT(J,I),QNBFT(J,I)
             ENDDO
          ENDDO
C
C ------- Assign boundary node information to array IB
C
          DO I=1,NNNPT
             NP=NPNBT(I)
             IB(NP)=4
          ENDDO
C
C ------- Print inputted global nodal number and flux types of all
C ------- neumann boundary element sides
C
          WRITE(16,2440)
          DO MP=1,NNEST,3
             J1=MP
             J2=MIN0(MP+2,NNEST)
             WRITE(16,2445) (J,(ISNT(I,J),I=1,4),INTYPT(J),J=J1,J2)
          ENDDO
C
C ------ Print global node number for each of all neumann nodes
C
          WRITE(16,2450)
          DO I=1,NNNPT,10
             J1=I
             J2=MIN0(I+9,NNNPT)
             WRITE(16,2455) (J,NPNBT(J),J=J1,J2)
          ENDDO
C
C ------- Compute boundary side number for all neumann sides
C
          DO 959 MI=1,NNEST
             NODEI=4
             IF (ISNT(4,MI).EQ.0) NODEI=3
             DO IQ=1,NODEI
                NIMI(IQ)=ISNT(IQ,MI)
             ENDDO
             DO 957 MJ=1,NBES
                NODEJ=4
                IF (ISB(4,MJ).EQ.0) NODEJ=3
                DO JQ=1,NODEJ
                   IJ=ISB(JQ,MJ)
                   NJMJ(JQ)=NPBB(IJ)
                ENDDO
                IEQ=0
                DO IQ=1,NODEI
                   NI=NIMI(IQ)
                   DO JQ=1,NODEJ
                      NJ=NJMJ(JQ)
                      IF(NJ.EQ.NI) GO TO 955
                   ENDDO
                   GO TO 957
  955              IEQ=IEQ+1
                ENDDO
                IF(IEQ.EQ.NODEI .AND. IEQ.EQ.NODEJ) GO TO 958
  957           CONTINUE
                WRITE(16,2460) MI
                WRITE(*,2460) MI
	       call stopfile  ! emrl jig
                STOP
  958           ISNT(5,MI)=MJ
  959     CONTINUE
C
C ------- CHANGE NPNB FROM CONTAINING GLOBAL NODE NUMBER TO
C ------- CONTAINING BOUNDARY NODE NUMBER
C
          DO 969 NP=1,NNNPT
             NI=NPNBT(NP)
             DO 965 I=1,NBNP
                NJ=NPBB(I)
                IF(NJ.NE.NI) GO TO 965
                NII=I
                GO TO 967
  965        CONTINUE
             WRITE(16,2470) NP
             WRITE(*,2470) NP
	       call stopfile  ! emrl jig
             STOP
  967        NPNBT(NP)=NII
  969     CONTINUE
C
C ------- PRINT COMPUTED BOUNDARY NODAL NUMBER FOR ALL CAUCHY NODES
C
          WRITE(16,2480)
          DO I=1,NNNPT,10
             J1=I
             J2=MIN0(I+9,NNNPT)
             WRITE(16,2485) (J,NPNBT(J),J=J1,J2)
          ENDDO
      END IF
      RETURN
 2100 FORMAT('  *** VARIABLE BOUNDARY CONDITION DATA ***'/5X,
     1 'NO. OF VARIABLE BOUNDARY ELEMENT SIDES, NVEST . . . . .',I5/5X,
     2 'NO. OF VARIABLE BOUNDARY NODAL POINTS,  NVNPT . . . . .',I5/5X,
     3 'NO. OF VARIABLE FLUX PROFILES,          NVPRT . . . . .',I5/)
 2110 FORMAT(1H ,///10X,'--- VARIABLE-FLUID CONCENTRATION PROFILE ---')
 2120 FORMAT(1H ,/5X,' XY series NO.',I4/5X,'TIME       FLUX   ',/1X,
     1 4X,'----      ------  ')
 2125 FORMAT(1H , 2D11.3 )
 2130 FORMAT(1H ,/5X,' ERROR IN READING VB-ELEMENT-SIDES')
 2140 FORMAT(1H ,///10X,' --- INPUTTED VB SIDE INFORMATION ---'//5X,
     1 3('   MP  GN1  GN2  GN3  GN4 CTYP',5X)/5X,
     2 3('   --  ---  ---  ---  --- ----',5X))
 2145 FORMAT(1H ,4X,3(6I5,5X))
 2150 FORMAT(1H ,/10X,' --- INPUTTED VARIABLE NODE DATA ---'//5X,
     1 10('    I NPVB  ')/5X,10('    - ----  '))
 2155 FORMAT(1H ,4X,10(2I5,2X))
 2160 FORMAT(1H ,/5X,' CANNOT FIND A BOUNDARY SIDE COINCIDING WITH',
     1 I3,'-TH VARIABLE BOUNDARY SIDE: STOP ***')
 2170 FORMAT(1H ,/5X,' *** CANNOT FIND A BOUNDARY NODAL NUMBER FOR',
     1 I3,'-TH VARIABLE BOUNDARY NODE: STOP')
 2180 FORMAT(1H ,//10X,'--- COMPUTTED BOUNDARY NODE NUMBER OF VB NODE'//
     1 5X,10('    I NPVB',2X)/5X,10('    - ----',2X))
 2185 FORMAT(1H ,4X,10(2I5,2X))
 2200 FORMAT(//'  *** CONCENTRATION BOUNDARY CONDITIONS ***'//5X,
     1 'NO. OF DIRICHLET NODAL POINTS,  NDNPT  . . . . . . . .',I5/5X,
     2 'NO. OF CONCENTRATION XY SERIES, NDPRT  . . . . . . . .',I5)
 2220 FORMAT(1H ,/5X,' XY-series NUMBER : ',I2//
     1 1X, (4X,'TIME       HEAD   ')/1X, (4X,'----      ------  '))
 2225 FORMAT(1H , (1PD11.3,1PD11.3))
 2230 FORMAT(1H ,//10X,' CONCENTRATION BOUNDARY NODES AND ',
     1 'XY SERIES OF BOUNDARY TYPE'//1X,5('    I NPDB DTYP',4X)/1X,
     2 5('    - ---- ----',4X))
 2235 FORMAT(1H ,1X,5(3I5,4X))
 2300 FORMAT('  *** CAUCHY BOUNDARY CONDITIONS ***'//5X,
     1 'NO. OF CAUCHY BOUNDARY ELEMENT SIDES, NCEST . . . . . .',I5/5X,
     2 'NO. OF CAUCHY BOUNDARY NODAL POINTS,  NCNPT . . . . . .',I5/5X,
     3 'NO. OF CAUCHY FLUX PROFILES,          NCPRT . . . . . .',I5/)
 2320 FORMAT(1H ,/5X,' XY series NO.',I4/5X,'TIME       FLUX   ',/1X,
     1 4X,'----      ------  ')
 2325 FORMAT(1H ,3(1PD11.3,1PD11.3))
 2330 FORMAT(1H ,10X,' *** ERROR IN READING CAUCHY BOUNDARY ELEMENT',
     1 ' SIDE: STOP ***')
 2340 FORMAT(1H ,/10X,' --- INPUTTED CAUCHY SIDE DATA ---'//5X,
     1 3('   MP  GN1  GN2  GN3  GN4 CTYP',5X)/5X,
     2 3('   --  ---  ---  ---  --- ----',5X))
 2345 FORMAT(1H ,4X,3(6I5,5X))
 2350 FORMAT(1H ,/10X,' --- INPUTTED CAUCHY NODE DATA ---'//5X,
     1 10('    I NPCB',2X)/5X,10('    - ----',2X))
 2355 FORMAT(1H ,4X,10(2I5,2X))
 2360 FORMAT(1H ,/5X,' CANNOT FIND A BOUNDARY SIDE COINCIDING WITH',
     1 I3,'-TH CAUCHY SIDE: STOP ***')
 2370 FORMAT(1H ,/5X,' *** CANNOT FIND A BOUNDARY NODAL NUMBER FOR',
     1 I3,'-TH CAUCHY BOUNDARY NODE:  STOP')
 2380 FORMAT(1H ,/10X,' --- COMPUTED CAUCHY NODE DATA ---'//5X,
     1 10('    I NPCB',2X)/5X,10('    - ----',2X))
 2385 FORMAT(1H ,4X,10(2I5,2X))
 2400 FORMAT(//'  *** NEUMANN BOUNDARY CONDITIONS ***'/5X,
     1 'NO. OF NEUMANN BOUNDARY ELEMENT SIDES, NNEST  . . . . .',I5/5X,
     2 'NO. OF NEUMANN BOUNDARY NODAL POINTS,  NNNPT  . . . . .',I5/5X,
     3 'NO. OF NEUMANN FLUX PROFILES,          NNPRT  . . . . .',I5/)
 2410 FORMAT(1H ,//10X,'--- NEUMANN FLUX PROFILE ---')
 2420 FORMAT(1H ,/5X,' XY series number',I2//5X,4HTIME,6X,6H FLUX ,/
     1 5X,4H----,6X,6H ---- ,2X)
 2425 FORMAT(1H ,3(2D11.3))
 2430 FORMAT(1H ,10X,' *** ERROR IN READING NEUMANN BOUNDARY ELEMENT',
     1 ' SIDE: STOP ***')
 2440 FORMAT(1H ,/10X,' --- INPUTTED NEUMANN SIDE DATA ---'//5X,
     1 3('   MP  GN1  GN2  GN3  GN4 CTYP',5X)/5X,
     2 3('   --  ---  ---  ---  --- ----',5X))
 2445 FORMAT(1H ,4X,3(6I5,5X))
 2450 FORMAT(1H ,/10X,' --- INPUTTED NEUMANN NODE DATA ---'//5X,
     1 10('    I NPCB',2X)/5X,10('    - ----',2X))
 2455 FORMAT(1H ,4X,10(2I5,2X))
 2460 FORMAT(1H ,/5X,' CANNOT FIND A BOUNDARY SIDE COINCIDING WITH',
     1 I3,'-TH NEUMANN SIDE: STOP ***')
 2470 FORMAT(1H ,/5X,' *** CANNOT FIND A BOUNDARY NODAL NUMBER FOR',
     1 I3,'-TH NEUMANN BOUNDARY NODE: STOP')
 2480 FORMAT(1H ,/10X,' --- COMPUTED NEUMANN NODE DATA ---'//5X,
     1 10('    I NPCB',2X)/5X,10('    - ----',2X))
 2485 FORMAT(1H ,4X,10(2I5,2X))
      END
C
      SUBROUTINE FBCDAT (ISB,NPBB,RSVAB,IDTYPT)
C
C ------- TO READ BOUNDARY CONDITIONS
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /FDBC/ NDNPF,NDPRF,NDDPF(MXDPRH)
      COMMON /FCBC/ NCESF,NCNPF,NCPRF,NCDPF(MXCPRH)
      COMMON /FVBC/ NVESF,NVNPF,NVPRF,NVDPF(MXVPRH)
      COMMON /FNBC/ NNESF,NNNPF,NNPRF,NNDPF(MXNPRH)
      COMMON /FRBC/ NRESF,NRNPF,NRPRF,NRDPF(MXRPRH),NRMAF
C
      COMMON /BLKDBF/ HDBF(MXDPRH),HDBFF(MXDDPH,MXDPRH),
     1        THDBFF(MXDDPH,MXDPRH),IDTYPF(MXDNPH),NPDBF(MXDNPH),
     2        JDTYPF(MXDNPH)
      COMMON /BLKCBF/ QCBF(MXCPRH),QCBFF(MXCDPH,MXCPRH),
     1        TQCBFF(MXCDPH,MXCPRH),ICTYPF(MXCESH),ISCF(5,MXCESH),
     2        NPCBF(MXCNPH),IDCF(MXCESH),JCTYPF(MXCESH)
      COMMON /BLKVBF/ QVBF(MXVPRH),QVBFF(MXVDPH,MXVPRH),
     1        TQVBFF(MXVDPH,MXVPRH),IVTYPF(MXVESH),ISVF(5,MXVESH),
     2        NPVBF(MXVNPH),IDVF(MXVESH),JVTYPF(MXVESH)
      COMMON /BLKNBF/ QNBF(MXNPRH),QNBFF(MXNDPH,MXNPRH),
     1        TQNBFF(MXNDPH,MXNPRH),INTYPF(MXNESH),ISNF(5,MXNESH),
     2        NPNBF(MXNNPH),IDNF(MXNESH),JNTYPF(MXNESH)
      COMMON /BLKRBF/ HRBF(MXRPRH),HRBFF(MXRDPH,MXRPRH),
     1        THRBFF(MXRDPH,MXRPRH),IRTYPF(MXRNPH),NPRBF(MXRNPH),
     2        ISRF(6,MXRESH),PRORF(2,MXRESH),IDRF(MXRESH),NRBEF(MXRESH),
     3        IRMTYP(MXRMAH),JRTYPF(MXRNPH)
      COMMON /TCONV/ NTY1(MXXYS),NTY2(MXXYS),NTY3(MXXYS),NTY4(MXXYS),
     1               NTY5(MXXYS),NTY6(MXXYS),NTY7(MXXYS),NTY8(MXXYS),
     2               NTY9(MXXYS),NTY10(MXXYS),NTY11(MXXYS),NTY12(MXXYS)
C
      DIMENSION ISB(6,MXBESK),NPBB(MXBNPK),RSVAB(MXVNPH,4),
     1          IDTYPT(MXDNPC),NIMI(4),NJMJ(4)
C
C ******* DATA SET 14: RAINFALL/EVAPORATION-SEEPAGE BOUNDARY CONDITIONS
C
      IF (NVESF.GT.0) THEN
          WRITE(16,6000) NVESF,NVNPF,NVPRF
          WRITE(16,6100)
          DO I=1,NVPRF
             WRITE(16,6150) NTY3(I)
             DO J=1,NVDPF(I)
                WRITE(16,6155)  TQVBFF(J,I),QVBFF(J,I)
             ENDDO
          ENDDO
C
C ------- PRINT INPUTTED GLOBAL NODAL NUMBER AND RAINFALL TYPES OF ALL
C ------- VARIABLE BOUNDARY ELEMENT SIDES.
C
          WRITE(16,6400)
          DO MP=1,NVESF,3
             J1=MP
             J2=MIN0(MP+2,NVESF)
             WRITE(16,6450) (J,(ISVF(I,J),I=1,4),IVTYPF(J),J=J1,J2)
          ENDDO
C
C ------- PRINT GLOBAL NODAL NUMBER, PONDING DEPTH AND MINIMUM PRESURE
C ------- RESSURE HEAD FOR ALL VARIABLE BOUNDARY NODES
C
          WRITE(16,6500)
          DO I=1,NVNPF,3
             J1=I
             J2=MIN0(I+2,NVNPF)
             WRITE(16,6550) (J,NPVBF(J),(RSVAB(J,K),K=1,2),J=J1,J2)
          ENDDO
C
C ------- COMPUTE BOUNDARY SIDE NUMBER FOR EACH OF ALL VARIABLE
C ------- BOUNDARY SIDES.
C
          DO MI=1,NVESF
             NODEI=4
             IF(ISVF(4,MI).EQ.0) NODEI=3
             DO IQ=1,NODEI
                NIMI(IQ)=ISVF(IQ,MI)
             ENDDO
             DO 657 MJ=1,NBES
                NODEJ=4
                IF (ISB(4,MJ).EQ.0) NODEJ=3
                DO JQ=1,NODEJ
                   IJ=ISB(JQ,MJ)
                   NJMJ(JQ)=NPBB(IJ)
                ENDDO
                IEQ=0
                DO IQ=1,NODEI
                   NI=NIMI(IQ)
                   DO JQ=1,NODEJ
                      NJ=NJMJ(JQ)
                      IF(NJ.EQ.NI) GO TO 655
                   ENDDO
                   GO TO 657
  655              IEQ=IEQ+1
                ENDDO
                IF(IEQ.EQ.NODEI .AND. IEQ.EQ.NODEJ) GO TO 658
  657           CONTINUE
                WRITE(16,6570) MI
                WRITE(*,6570) MI
	       call stopfile  ! emrl jig
                STOP
  658           ISVF(5,MI)=MJ
          ENDDO
C
C ------- CHANGE NPVB FROM CONTAINING GLOBAL NODAL NUMBER TO
C ------- CONTAINING BOUNDARY NODAL NUMBER.
C
          DO NP=1,NVNPF
             NI=NPVBF(NP)
             DO 665 I=1,NBNP
                NJ=NPBB(I)
                IF (NJ.NE.NI) GO TO 665
                NII=I
                GO TO 667
  665        CONTINUE
             WRITE(16,6670) NP
             WRITE(*,6670) NP
	       call stopfile  ! emrl jig
             STOP
  667        NPVBF(NP)=NII
          ENDDO
C
C --------- PRINT COMPUTED BOUNDARY NODAL NUMBER FOR ALL VB NODES
C
          WRITE(16,6700)
          DO I=1,NVNPF,10
             J1=I
             J2=MIN0(I+9,NVNPF)
             WRITE(16,6750) (J,NPVBF(J),J=J1,J2)
          ENDDO
C
C ------- CHANGE ISVF(I,MP) I=1,4 FROM CONTAINING GLOBAL NODAL NUMBER
C ------- TO CONTAINING COMPRESSED VARIABLE BOUNDARY NODAL NUMBER.
C
          DO MP=1,NVESF
             MPB=ISVF(5,MP)
             NODE=4
             IF (ISB(4,MPB).EQ.0) NODE=3
             DO IQ=1,NODE
                NB=ISB(IQ,MPB)
                DO 675 I=1,NVNPF
                   NI=NPVBF(I)
                   IF (NI.NE.NB) GO TO 675
                   NII=I
                   GO TO 680
  675           CONTINUE
                WRITE(16,6751) IQ,MP
                WRITE(16,*) IQ,MP
	       call stopfile  ! emrl jig
                STOP
  680           ISVF(IQ,MP)=NII
              ENDDO
          ENDDO
C
C ------- PRINT COMPUTED BOUNDARY NODAL NUMBER & SIDE NUMBER AND
C ------- RAINFALL TYPES FOR ALL VB SIDES
C
          WRITE(16,6900)
          DO MP=1,NVESF,3
             J1=MP
             J2=MIN0(MP+2,NVESF)
             WRITE(16,6950) (J,(ISVF(I,J),I=1,5),IVTYPF(J),J=J1,J2)
          ENDDO
      ENDIF
C
C ******* DATA SET 15: DIRICHLET BOUNDARY CONDITIONS
C
      IF (NDNPF.GT.0) THEN
          NTALL=NDPRF
          WRITE(16,7000) NDNPF,NTALL
          DO I=1,NDPRF
             WRITE(16,7100) NTY5(I)
             DO J=1,NDDPF(I)
                WRITE(16,7155) THDBFF(J,I),HDBFF(J,I)
             ENDDO
          ENDDO
C
C --------- PRINT GLOBAL NODAL NUMBER AND PROFILE OF DIRICHLET NODES
C
          WRITE(16,7200)
          DO I=1,NDNPF,5
             J1=I
             J2=MIN0(I+4,NDNPF)
             WRITE(16,7250)(J,NPDBF(J),IDTYPF(J),IDTYPT(J),J=J1,J2)
          ENDDO
      END IF
C
C ******* DATA SET 16: CAUCHY BOUNDARY CONDITIONS
C
      IF (NCESF.GT.0) THEN
          WRITE(16,8000) NCESF,NCNPF,NCPRF
          DO I=1,NCPRF
             WRITE(16,8100) NTY7(I)
             DO J=1,NCDPF(I)
                WRITE(16,8155) TQCBFF(J,I),QCBFF(J,I)
             ENDDO
          ENDDO
C
C ------- PRINT INPUTTED GLOBAL NODAL NUMBER AND CAUCHY FLUX TYPES
C ------- FOR ALL CAUCHY BOUNDARY ELEMENT SIDES.
C
          WRITE(16,8400)
          DO MP=1,NCESF,3
             J1=MP
             J2=MIN0(MP+2,NCESF)
             WRITE(16,8450) (J,(ISCF(I,J),I=1,4),ICTYPF(J),J=J1,J2)
          ENDDO
C
C ------- PRINT GLOBAL NODAL NUMBER FOR ALL CAUCHY NODES
C
          WRITE(16,8500)
          DO I=1,NCNPF,10
             J1=I
             J2=MIN0(I+9,NCNPF)
             WRITE(16,8550) (J,NPCBF(J),J=J1,J2)
          ENDDO
C
C ------- COMPUTE BOUNDARY SIDE NUMBER FOR ALL CAUSHY SIDES
C
          DO MI=1,NCESF
             NODEI=4
             IF (ISCF(4,MI).EQ.0) NODEI=3
             DO IQ=1,NODEI
                NIMI(IQ)=ISCF(IQ,MI)
             ENDDO
             DO 857 MJ=1,NBES
                NODEJ=4
                IF (ISB(4,MJ).EQ.0) NODEJ=3
                DO JQ=1,NODEJ
                   IJ=ISB(JQ,MJ)
                   NJMJ(JQ)=NPBB(IJ)
                ENDDO
                IEQ=0
                DO IQ=1,NODEI
                   NI=NIMI(IQ)
                   DO JQ=1,NODEJ
                      NJ=NJMJ(JQ)
                      IF (NJ.EQ.NI) GO TO 855
                   ENDDO
                   GO TO 857
  855              IEQ=IEQ+1
                ENDDO
                IF(IEQ.EQ.NODEI .AND. IEQ.EQ.NODEJ) GO TO 858
  857        CONTINUE
             WRITE(16,8570) MI
             WRITE(*,8570) MI
	       call stopfile  ! emrl jig
             STOP
  858        ISCF(5,MI)=MJ
          ENDDO
C
C ------- CHANGE NPCB FROM CONTAINING GLOBAL NODAL NUMBER TO
C ------- CONTAINING BOUNDARY NODAL NUMBER.
C
          DO NP=1,NCNPF
             NI=NPCBF(NP)
             DO 865 I=1,NBNP
                NJ=NPBB(I)
                IF (NJ.NE.NI) GO TO 865
                NII=I
                GO TO 867
  865        CONTINUE
             WRITE(16,8670) NP
             WRITE(*,8670) NP
	       call stopfile  ! emrl jig
             STOP
  867        NPCBF(NP)=NII
          ENDDO
C
C --------- PRINT COMPUTED BOUNDARY NODAL NUMBER FOR ALL CAUCHY NODES
C
          WRITE(16,8700)
          DO I=1,NCNPF,10
             J1=I
             J2=MIN0(I+9,NCNPF)
             WRITE(16,8750) (J,NPCBF(J),J=J1,J2)
          ENDDO
      END IF
C
C ******* DATA SET 17:  NEUMANN BOUNDARY CONDITIONS
C
      IF (NNESF.GT.0) THEN
          WRITE(16,9000) NNESF,NNNPF,NNPRF
          DO I=1,NNPRF
             WRITE(16,9100) NTY9(I)
             DO J=1,NNDPF(I)
                WRITE(16,9155) TQNBFF(J,I),QNBFF(J,I)
             ENDDO
          ENDDO
C
C ------- PRINT INPUTTED GLOBAL NODAL NUMBER AND NEUMANN FLUX TYPES
C ------- FOR ALL NEUMANN BOUNDARY ELEMENT SIDES.
C
          WRITE(16,9400)
          DO MP=1,NNESF,3
             J1=MP
             J2=MIN0(MP+2,NNESF)
             WRITE(16,9450) (J,(ISNF(I,J),I=1,4),INTYPF(J),J=J1,J2)
          ENDDO
C
C ------- PRINT GLOBAL NODAL NUMBER FOR ALL NEUMANN NODES
C
          WRITE(16,9500)
          DO I=1,NNNPF,10
             J1=I
             J2=MIN0(I+9,NNNPF)
             WRITE(16,9550) (J,NPNBF(J),J=J1,J2)
          ENDDO
C
C ------- COMPUTE BOUNDARY SIDE NUMBER FOR EACH OF NEUMANN
C ------- BOUNDARY SIDES.
C
          DO MI=1,NNESF
             NODEI=4
             IF (ISNF(4,MI).EQ.0) NODEI=3
             DO IQ=1,NODEI
                NIMI(IQ)=ISNF(IQ,MI)
             ENDDO
             DO 957 MJ=1,NBES
                NODEJ=4
                IF (ISB(4,MJ).EQ.0) NODEJ=3
                DO JQ=1,NODEJ
                   IJ=ISB(JQ,MJ)
                   NJMJ(JQ)=NPBB(IJ)
                ENDDO
                IEQ=0
                DO IQ=1,NODEI
                   NI=NIMI(IQ)
                   DO JQ=1,NODEJ
                      NJ=NJMJ(JQ)
                      IF (NJ.EQ.NI) GO TO 955
                   ENDDO
                   GO TO 957
  955              IEQ=IEQ+1
                ENDDO
                IF (IEQ.EQ.NODEI .AND. IEQ.EQ.NODEJ) GO TO 958
  957        CONTINUE
             WRITE(16,9570) MI
             WRITE(*,9570) MI
	       call stopfile  ! emrl jig
             STOP
  958        ISNF(5,MI)=MJ
          ENDDO
C
C ------- CHANGE NPNB FROM CONTAINING GLOBAL NODAL NUMBER TO
C ------- CONTAINING BOUNDARY NODAL NUMBER.
C
          DO NP=1,NNNPF
             NI=NPNBF(NP)
             DO 965 I=1,NBNP
                NJ=NPBB(I)
                IF (NJ.NE.NI) GO TO 965
                NII=I
                GO TO 967
  965        CONTINUE
             WRITE(16,9670) NP
             WRITE(*,9670) NP
	       call stopfile  ! emrl jig
             STOP
  967        NPNBF(NP)=NII
          ENDDO
C
C --------- PRINT COMPUTED BOUNDARY NODAL NUMBER FOR ALL NEUMANN NODES
C
          WRITE(16,9700)
          DO I=1,NNNPF,10
             J1=I
             J2=MIN0(I+9,NNNPF)
             WRITE(16,9750) (J,NPNBF(J),J=J1,J2)
          ENDDO
      END IF
C
C ******* DATA SET 20: River Boundary Condition for Flow
C
      IF (NRNPF.GT.0) THEN
         WRITE(16,5000) NRNPF,NRPRF,NRESF,NRMAF
         DO I=1,NRPRF
            WRITE(16,7100) NTY12(I)
            DO J=1,NRDPF(I)
               WRITE(16,7155)  THRBFF(J,I),HRBFF(J,I)
            ENDDO
         ENDDO
C
C --------- PRINT GLOBAL NODAL NUMBER AND PROFILE OF River NODES
C
         WRITE(16,5200)
         DO I=1,NRNPF,4
            J1=I
            J2=MIN0(I+3,NRNPF)
            WRITE(16,5250) (J,NPRBF(J),IRTYPF(J),J=J1,J2)
         ENDDO
C
C ------- PRINT INPUTTED GLOBAL NODAL NUMBER and Material Types of
C ------- ALL RIVER BOUNDARY ELEMENT SIDES.
C
         WRITE(16,5400)
         DO MP=1,NRESF
            MTYP=ISRF(6,MP)
            RRK=PRORF(1,MP)
            RRB=PRORF(2,MP)
            WRITE(16,5450) MP,NRBEF(MP),(ISRF(I,MP),I=1,4),
     1                    MTYP,RRK,RRB
         ENDDO
C
C ------- COMPUTE BOUNDARY SIDE NUMBER FOR ALL RIVER SIDES
C
         DO MI=1,NRESF
            NODEI=4
            IF (ISRF(4,MI).EQ.0) NODEI=3
            DO IQ=1,NODEI
               NIMI(IQ)=ISRF(IQ,MI)
            ENDDO
            DO 557 MJ=1,NBES
                NODEJ=4
               IF(ISB(4,MJ).EQ.0) NODEJ=3
               DO JQ=1,NODEJ
                  IJ=ISB(JQ,MJ)
                  NJMJ(JQ)=NPBB(IJ)
               ENDDO
               IEQ=0
               DO IQ=1,NODEI
                  NI=NIMI(IQ)
                  DO JQ=1,NODEJ
                     NJ=NJMJ(JQ)
                     IF (NJ.EQ.NI) GO TO 555
                  ENDDO
                  GO TO 557
  555             IEQ=IEQ+1
               ENDDO
               IF (IEQ.EQ.NODEI .AND. IEQ.EQ.NODEJ) GO TO 558
  557       CONTINUE
            WRITE(16,5570) MI
            WRITE(*,5570) MI
	       call stopfile  ! emrl jig
            STOP
  558       ISRF(5,MI)=MJ
         ENDDO
C
C ------- CHANGE ISR(1..4,MP) FROM CONTAINING GLOBAL NODAL NUMBER TO
C ------- CONTAINING RIVER NODAL NUMBER
C
         DO MP=1,NRESF
            NODE=4
            IF (ISRF(4,MP).EQ.0) NODE=3
            DO IQ=1,NODE
               NIQ=ISRF(IQ,MP)
               DO 585 I=1,NRNPF
                  NI=NPRBF(I)
                  IF (NIQ.NE.NI) GO TO 585
                  NII=I
                  GO TO 587
  585          CONTINUE
               WRITE(16,5870) IQ,MP
               WRITE(*,5870) IQ,MP
	       call stopfile  ! emrl jig
               STOP
  587          ISRF(IQ,MP)=NII
            ENDDO
         ENDDO
C
C ------- PRINT COMPUTED RIVER NODE NUMBER and Material Types of
C ------- ALL RIVER BOUNDARY ELEMENT SIDES.
C
         WRITE(16,5900)
         DO MP=1,NRESF
            RRK=PRORF(1,MP)
            RRB=PRORF(2,MP)
            WRITE(16,5950) MP,(ISRF(I,MP),I=1,4),ISRF(6,MP),RRK,RRB
         ENDDO
C
C ------- CHANGE NRCB FROM CONTAINING GLOBAL NODAL NUMBER TO
C ------- CONTAINING BOUNDARY NODAL NUMBER.
C
         DO NP=1,NRNPF
            NI=NPRBF(NP)
            DO 565 I=1,NBNP
               NJ=NPBB(I)
               IF (NJ.NE.NI) GO TO 565
               NII=I
               GO TO 567
  565       CONTINUE
            WRITE(16,5670) NP
            WRITE(*,5670) NP
	       call stopfile  ! emrl jig
            STOP
  567       NPRBF(NP)=NII
         ENDDO
C
C --------- PRINT COMPUTED BOUNDARY NODAL NUMBER FOR ALL RIVER NODES
C
         WRITE(16,5700)
         DO I=1,NRNPF,6
            J1=I
            J2=MIN0(I+5,NRNPF)
            WRITE(16,5750) (J,NPRBF(J),J=J1,J2)
         ENDDO
      END IF
C
 5000 FORMAT(1H1/5X,' **** RIVER BOUNDARY CONDITIONS ****'/5X,
     > 'NO. OF RIVER NODES, NRNPF. . . . . . . . . . . . . ',I5/5X,
     > 'NO. OF RIVER PROFILES, NRPRF . . . . . . . . . . . ',I5/5X,
     > 'NO. OF RIVER BOUNDARY ELEMENT SIDES, NRESF . . . . ',I5/5X,
     > 'NO. OF RIVER MATERIAL TYPES NRMAF. . . . . . . . . ',I5)
 5200 FORMAT(1H0//10X,'GLOBAL NODAL NUMBER AND PROFILE TYPE OF ',
     1 'RIVER BOUNDARY NODES'/1X,4('    I NPRB TYPE',4X)/1X,
     2 4('    - ---- ----',4X))
 5250 FORMAT(1H ,4(3I5,4X))
 5300 FORMAT(1H0,10X,'*** ERROR READING RIVER BOUNDARY ELEMENT SIDE',
     1 ' SIDE: STOP ***')
 5400 FORMAT(1H0/10X,' --- INPUTTED RIVER SIDE DATA ---'//5X,
     1 '   MP     NRBEF  GN1  GN2  GN3  GN4 MTYP',5X,'   RIVERK
     2RIVERB'/5X,
     3 '   --     -----  ---  ---  ---  --- ----',5X,'   ------
     4------')
 5450 FORMAT(1H ,4X,I5,5X,I5,5I5,5X,1pd12.3,1pd12.3)
 5570 FORMAT(1H1,'*** CANNOT FIND A BOUNDARY SIDE COINCIDING '/1X,
     1 ' WITH',I3,'-TH RIVER BOUNDARY SIDE:  STOP ***')
 5670 FORMAT(1H1,'*** CANNOT FIND A BOUNDARY NODAL NUMBER FOR'/1X,
     1 I3,'-TH RIVER BOUNDARY NODE:  STOP')
 5700 FORMAT(1H0/10X,' --- COMPUTED RIVER NODE DATA ---'//5X,
     1 6('    I NPRB',2X)/5X,6('    - ----',2X))
 5750 FORMAT(1H ,4X,6(2I5,2X))
 5870 FORMAT(1H1,'*** CANNOT FIND A RIVER NODE FOR'/1X,
     1 I2,'-TH NODE OF THE',I4,'-TH RIVER BOUNDARY SIDE:  STOP')
 5900 FORMAT(1H0/10X,' --- COMPUTED CAUCHY SIDE DATA ---'//5X,
     1 '   MP  RN1  RN2  RN3  RN4 MTYP',5X,'   RIVERK      RIVERB'/5X,
     3 '   --  ---  ---  ---  --- ----',5X,'   ------      ------')
 5950 FORMAT(1H ,4X,6I5,5X,1pd12.3,1pd12.3)
      RETURN
 6000 FORMAT(1H ,5X,' **** RAINFALL-SEEPAGE BOUNDARY CONDITIONS ***'/5X,
     1 'NO. OF VARIABLE BOUNDARY ELEMENT SIDES, NVESF. . . ',I5/5X,
     2 'NO. OF VARIABLE BOUNDARY NODAL POINTS, NVNPF . . . ',I5/5X,
     3 'NO. OF RAINFALL PROFILES, NVPRF. . . . . . . . . . ',I5/)
 6100 FORMAT(1H /10X,' --- RAINFALL PROFILE ---')
 6150 FORMAT(1H /5X,' XY series NO.',I2/1X,(4X,'TIME       RAINS  ')/1X,
     1 (4X,'----      ------  '))
 6155 FORMAT(1H ,3(1PD11.3,1PD11.3))
 6300 FORMAT(1H ,'** ERROR READING RAINFALL-SEEPAGE ELEMENT SIDE: STOP')
 6400 FORMAT(1H ,/10X,' --- INPUTTED VARIABLE SIDE DATA ---'//5X,
     1 3('   MP  GN1  GN2  GN3  GN4 RTYP',5X)/5X,
     2 3('   --  ---  ---  ---  --- ----',5X))
 6450 FORMAT(1H ,4X,3(6I5,5X))
 6500 FORMAT(1H ,/10X,' --- INPUTTED VARIABLE NODE DATA ---'//1X,
     1 3(1X,'    I NPVB     HCON        HMIN   ',1X)/1X,
     2 3(1X,'    - ----     ----        ----   ',1X))
 6550 FORMAT(1H ,3(1X,2I5,2D12.4,1X))
 6570 FORMAT(1H ,'*** CANNOT FIND A BOUNDARY SIDE COINCIDING'/1X,
     1 'WITH',I3,'-TH VARIABLE BOUNDARY SIDE: STOP ***')
 6670 FORMAT(1H ,' *** CANNOT FIND A BOUNDARY NODAL NUMBER FOR'/1X,
     1 I3,'-TH VARIABLE BOUNDARY NODE: STOP ***')
 6700 FORMAT(1H //10X,'COMPUTED BOUNDARY NODAL NUMBER OF ALL VB NODES'
     1 //5X,10('    I NPVB',2X)/5X,10('    - ----',2X))
 6750 FORMAT(1H ,4X,10(2I5,2X))
 6751 FORMAT(1H ,' *** CAN NOT FIND A COMPRESSED RS NODE FOR'/1X,
     1 I2,'-TH POINT OF',I4,'-TH RS SIDE: STOP ***')
 6900 FORMAT(1H ,/10X,' --- COMPUTED VB SIDE DATA ---'//1X,
     1 3('   MP CNP1 CNP2 CNP3 CNP4  MPB RTYP',1X)/1X,
     2 3('   -- ---- ---- ---- ---- ---- ----',1X))
 6950 FORMAT(1H ,3(7I5,1X))
 7000 FORMAT(1H ,/5X,' **** HEAD BOUNDARY CONDITIONS ****'//5X,
     1 'NO. OF DIRICHLET NODES, NDNPF . . . . . . . . . . . ',I5/5X,
     2 'NO. OF HEAD XY SERIES, NDPRF  . . . . . . . . . . .',I5/)
 7100 FORMAT(1H ,/5X,' XY-series NUMBER : ',I2//
     1 1X, (4X,'TIME       HEAD   ')/1X, (4X,'----      ------  '))
 7155 FORMAT(1H , (1PD11.3,1PD11.3))
 7200 FORMAT(1H ,//10X,'HEAD BOUNDARY NODES AND ',
     1 ' XY-SERIES OF BOUNDARY TYPE'//1X,5('     I NPDB TYPE TYPE',
     2 4X)/1X,5('     - ---- ---- ----',4X))
 7250 FORMAT(1H ,1X,5(4I5,4X))
 8000 FORMAT(1H ,/5X,' **** CAUCHY  BOUNDARY CONDITIONS ****'/5X,
     1 'NO. OF CAUCHY BOUNDARY ELEMENT SIDES, NCESF. . . . ',I5/5X,
     2 'NO. OF CAUCHY BOUNDARY NODAL POINTS, NCNPF . . . . ',I5/5X,
     3 'NO. OF CAUCHY FLUX PROFILES, NCPR  . . . . . . . . ',I5/)
 8100 FORMAT(1H ,/5X,' XY series NO.',I4/5X,'TIME       FLUX   ',/1X,
     1 4X,'----      ------  ')
 8155 FORMAT(1H ,3(1PD11.3,1PD11.3))
 8300 FORMAT(1H ,10X,'*** ERROR READING CAUCHY BOUNDARY ELEMENT SIDE',
     1 ' SIDE: STOP ***')
 8400 FORMAT(1H ,/10X,' --- INPUTTED CAUCHY SIDE DATA ---'//5X,
     1 3('   MP  GN1  GN2  GN3  GN4 CTYP',5X)/5X,
     2 3('   --  ---  ---  ---  --- ----',5X))
 8450 FORMAT(1H ,4X,3(6I5,5X))
 8500 FORMAT(1H ,/10X,' --- INPUTTED CAUCHY NODE DATA ---'//5X,
     1 10('    I NPCB',2X)/5X,10('    - ----',2X))
 8550 FORMAT(1H ,4X,10(2I5,2X))
 8570 FORMAT(1H ,'*** CANNOT FIND A BOUNDARY SIDE COINCIDING '/1X,
     1 ' WITH',I3,'-TH CAUCY BOUNDARY SIDE:  STOP ***')
 8670 FORMAT(1H ,'*** CANNOT FIND A BOUNDARY NODAL NUMBER FOR'/1X,
     1 I3,'-TH CAUCHY BOUNDARY NODE:  STOP')
 8700 FORMAT(1H ,/10X,' --- COMPUTED CAUCHY NODE DATA ---'//5X,
     1 10('    I NPCB',2X)/5X,10('    - ----',2X))
 8750 FORMAT(1H ,4X,10(2I5,2X))
 9000 FORMAT(1H ,/5X,' **** NEUMANN BOUNDARY CONDITIONS ****'/5X,
     1 'NO. OF NEUMANN BOUNDARY ELEMENT SIDES, NNESF . . . ',I5/5X,
     2 'NO. OF NEUMANN BOUNDARY NODAL POINTS, NNNPF. . . . ',I5/5X,
     3 'NO. OF NEUMANN FLUX PROFILES, NNPRF. . . . . . . . ',I5/)
 9100 FORMAT(1H ,/5X,' XY series NO.',I4/5X,'TIME       FLUX   ',/1X,
     1 4X,'----      ------  ')
 9155 FORMAT(1H ,3(1PD11.3,1PD11.3))
 9300 FORMAT(1H ,' *** ERROR READING NEUMANN BOUNDARY ELEMENT',
     1 ' SIDE: STOP ***')
 9400 FORMAT(1H ,/10X,' --- INPUTTED NEUMANN SIDE DATA ---'//5X,
     1 3('   MP  GN1  GN2  GN3  GN4 NTYP',5X)/5X,
     2 3('   --  ---  ---  ---  ---  ---',5X))
 9450 FORMAT(1H ,4X,3(6I5,5X))
 9500 FORMAT(1H ,/10X,' --- INPUTTED NEUMANN NODE DATA ---'//5X,
     1 10('    I NPNB',2X)/5X,10('    - ----',2X))
 9550 FORMAT(1H ,4X,10(2I5,2X))
 9570 FORMAT(1H ,'*** CANNOT FIND A BOUNDARY SIDE COINCIDING'/1X,
     1 'WITH',I3,'-TH NEUMANN BOUNDARY SIDE:  STOP ***')
 9670 FORMAT(1H ,' *** CANNOT FIND A BOUNDARY NODAL NUMBER FOR'/1X,
     1 I3,'-TH NEUMANN BOUNDARY NODE: STOP ***')
 9700 FORMAT(1H /10X,' --- COMPUTED NEUMANN NODE DATA ---'//5X,
     1 10('    I NPNB',2X)/5X,10('    - ----',2X))
 9750 FORMAT(1H ,4X,10(2I5,2X))
      END
C
      SUBROUTINE GEOM (IE,X)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
      COMMON /PLIC/ LIPC
C
      COMMON /CARD/ JREC
      DIMENSION KNT(200),REA(200)
      CHARACTER JREC(180)*1,IC1*2,IC3*1
      DIMENSION IE(MAXELK,9),X(MAXNPK,3)
      CHARACTER TITLE*70,T8*8
C
      DATA IEND/0/
C
C ... READ FIRST "HEC" RECORD, LOOKING FOR A "T" CARD          (T_ CARD)
C
      NC1=0
      NC2=0
C
      READ(10,201) T8
  201 FORMAT(A8)
      IF (T8.NE.'3DFEMGEO') THEN
          WRITE(*,202)
  202 FORMAT('   ERROR, THIS IS NOT A 3DFEMGEO FILE')
         call stopfile  ! emrl jig
          STOP 'GEOM'
      ENDIF
C
      OPEN(23,FILE='3dfemgeo.ech',STATUS='UNKNOWN')
C
      READ(10,10) IC1,IC3,TITLE
   10 FORMAT(A2,A1,A70)
   30 CONTINUE
      WRITE(23,20) IC1,IC3,TITLE
   20 FORMAT(1X,A2,A1,A70)
      IF (IC1.NE.'T1'.AND.IC1.NE.'T2'.AND.IC1.NE.'T3') THEN
          WRITE(23,11)
   11     FORMAT(' *** ERROR, "T" CARD EXPECTED, RUN TERMINATED ***')
          STOP
      ENDIF
      IF (IC1.EQ.'T3') GO TO 40
      READ(10,10) IC1,IC3,TITLE
      GO TO 30
C-
C ... DATA INITIALIZATION FOR HEC READS
C-
   40 CONTINUE
C-
C ... MAIN DATA READ                                    (MAIN DATA READ)
C-
      READ(10,12,END=9) IC1,IC3,(JREC(I),I=1,180)
   12 FORMAT(A2,A1,180A1)
      I1=1
      IF(IC1.EQ.'GE') THEN
C
C ...     OPTION PARAMETERS CARD - OP CARD               (GE8 CARD)
C
           IF (IC3.EQ.'8') THEN
                  JJ=10
                  DO I=1,JJ
                     KNT(I)=0
                  ENDDO
                  CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                  WRITE(23,15) IC1,IC3,(KNT(I),I=1,JJ)
                  N  = KNT(1)
                  DO J=1,9
                     IE(N,J)= KNT(1+J)
                  ENDDO
                  IJNOD(N)=8
                  NIK(N)=1
                  NFACE(N)=6
                  NEDGE(N)=12
                  NC1=NC1+1
           ELSE IF (IC3.EQ.'6') THEN
C
C ...                      - GE6 CARD                    (GE6 TYPE)
C
                 JJ=8
                 DO I=1,8
                   KNT(I)=0
                 ENDDO
                 CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                 WRITE(23,15) IC1,IC3,(KNT(I),I=1,JJ)
                 N = KNT(1)
                 DO J=1,6
                    IE(N,J)=KNT(1+J)
                 ENDDO
                 IE(N,9)=KNT(8)
                 IJNOD(N)=6
                 NIK(N)=2
                 NFACE(N)=5
                 NEDGE(N)=9
                 NC1=NC1+1
           ELSE IF (IC3.EQ.'4') THEN
C
C ...                      - GE4 CARD                    (GE4 TYPE)
C
                 JJ=6
                 DO I=1,6
                   KNT(I)=0
                 ENDDO
                 CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
   15            FORMAT(1X,A2,A1,20I6)
                 WRITE(23,15) IC1,IC3,(KNT(I),I=1,JJ)
                 N   = KNT(1)
                 DO J=1,4
                    IE(N,J)=KNT(1+J)
                 ENDDO
                 IE(N,9)=KNT(6)
                 IJNOD(N)=4
                 NIK(N)=3
                 NFACE(N)=4
                 NEDGE(N)=6
                 NC1=NC1+1
            ENDIF
C
C ...     ITERATION PARAMETERS INFORMATION - CARD          (GN CARD)
C ...                    - GN CARD                        (GN TYPE)
       ELSE IF (IC1.EQ.'GN') THEN
C
                   JJ=3
                   DO I =1,JJ
                      KNT(I)= 0
                      REA(I)= 0.0D0
                   ENDDO
                   J1=1
                   CALL CRACKI (I1,J1,KNT,'INTEGER  ')
                   CALL CRACKD (I1,JJ,REA,'REAL     ')
                   WRITE(23,25) IC1,IC3,KNT(1),(REA(I),I=1,3)
   25              FORMAT(1X,A2,A1,I6,3F15.2)
                   ND = KNT(1)
                   DO J=1,3
                      X(ND,J)=REA(J)
                   ENDDO
                   NC2=NC2+1
C
C                                      (END CARD)
C
      ELSE IF(IC1.EQ.'EN') THEN
            NEL=NC1
            NNP=NC2
C
CRAE 10-25-94    check to insure that the number of elements (NEL) and
C                the number of nodes (NNP) is within array bounds
C
            IF (NNP.GT.MAXNPK) THEN
               WRITE(*,2001) NC2
 2001 FORMAT('  You must increase the parameter MAXNPK to ',I6)
            ELSE IF (NEL .GT. MAXELK) THEN
               WRITE(*,2002) NC1
 2002 FORMAT('  You must increase the parameter MAXELK to ',I6)
            ENDIF
            IF(NNP.GT.MAXNPK .OR. NEL.GT.MAXELK) then
	       call stopfile  ! emrl jig
		    STOP
	      endif
            IEND = 1
C
            IF (IE(1,5).EQ.0) THEN
               ISHAPE=4
            ELSEIF(IE(1,7).EQ.0) THEN
               ISHAPE=6
            ELSE
               ISHAPE=8
            ENDIF
            DO 560 M=2,NEL
               IF (ISHAPE.EQ.0) GO TO 560
               IF (ISHAPE.EQ.8) THEN
                  IF (IE(M,5).EQ.0.OR.IE(M,7).EQ.0)ISHAPE=0
               ELSEIF(ISHAPE.EQ.6) THEN
                   IF( IE(M,5).EQ.0.OR.IE(M,7).NE.0)ISHAPE=0
               ELSE
                   IF (IE(M,5).NE.0) ISHAPE=0
               ENDIF
  560       CONTINUE
            WRITE(23,9001) NEL,NNP
 9001 FORMAT(5X,'NEL=',I5,5X,'NNP=',I5)
            GO TO 1700
      ELSE
C
C ...     BAD CARD                                 (ILLEGAL CARD)
C
            WRITE(23,1665) IC1,IC3,(JREC(I),I=1,180)
            WRITE(*,1665) IC1,IC3,(JREC(I),I=1,180)
 1665     FORMAT(1X,A2,A1,180A1)
            WRITE(23,1670)
            WRITE(*,1670)
 1670     FORMAT(' *** ERROR, ILLEGAL CARD TYPE ***')
        call stopfile  ! emrl jig
            STOP
      ENDIF
C
C ... READ ANOTHER CARD
C
      GO TO 40
    9 CONTINUE
C
CRAE 10-24-94  if EOF is found but no 'END' card, run message but
C              assume this is an oversight & continue processing
      IF(IEND.EQ.0) THEN
        WRITE(*,*)'  no END card found in geometry file..will continue'
            NEL=NC1
            NNP=NC2
            IEND = 1
C
            IF (IE(1,5).EQ.0) THEN
               ISHAPE=4
            ELSEIF(IE(1,7).EQ.0) THEN
               ISHAPE=6
            ELSE
               ISHAPE=8
            ENDIF
            DO 561 M=2,NEL
               IF (ISHAPE.EQ.0) GO TO 561
               IF (ISHAPE.EQ.8) THEN
                  IF (IE(M,5).EQ.0.OR.IE(M,7).EQ.0)ISHAPE=0
               ELSEIF(ISHAPE.EQ.6) THEN
                   IF( IE(M,5).EQ.0.OR.IE(M,7).NE.0)ISHAPE=0
               ELSE
                   IF (IE(M,5).NE.0) ISHAPE=0
               ENDIF
  561       CONTINUE
            WRITE(23,9001) NEL,NNP
      END IF
 1700 CONTINUE
C
      IF (NEL.GT.20000) THEN
          LIPC=100
      ELSEIF (NEL.GT.10000) THEN
          LIPC=50
      ELSE
          LIPC=20
      ENDIF
      CLOSE(23,STATUS='DELETE')
 1001 FORMAT(A6,4X,A13)
 1002 FORMAT(A2,I8)
 1003 FORMAT(A4,I6)
 1004 FORMAT(A2,E16.8)
 1005 FORMAT(E16.8)
      RETURN
      END
C
      SUBROUTINE RINPUT (IE,PROPF,PROPT,RHOMU,RSVAB,
     1                     KMOD,IBUG,ICHNG,TITLE,KCP)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
C ------- Conver Index number of face in the element (BYU to George Yeh)
C ... HEC STYLE INPUT
C ------- COMMON BLOCK FOR BOTH FLOW AND TRANSPORT
C
      CHARACTER TITLE*6,Z8*8
C
      COMMON /CARD/ JREC
      DIMENSION KNT(200),REA(200)
      CHARACTER JREC(180)*1,IC1*2,IC3*1
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /TSTEP/ NTI,NTIF,NTIT
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /PCG/ GG,IEIGEN
      COMMON /IP1/ OMEFTT,NITFTT
      COMMON /SAZFM/ NXW,NYW,NZW,IDETQ
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
C ------- COMMON BLOCK FOR FLOW ITERATION AND MATERIAL CONTROL
C
      COMMON /FINTE/ NCYLF,NITERF,NPITERF,KSP,KGRAV,IPNTSF
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
C
C ------- COMMON BLOCK FOR TRANSPORT ITERATION AND MATERIAL CONTROL
C
      COMMON /TINTE/ NCMT,NITERT,NPITERT,IPNTST
      COMMON /TREAL/ OMET,OMIT,TOLBT
      COMMON /TRFLOW/ IFFU
C
C ------- COMMON BLOCK FOR FLOW AND TRANSPORT SOURCE/SINK
C
      COMMON /FTREAL/EPSS,EPST
      COMMON /FPS/ NWNPF,NWPRF,NWDPF(MXWPRH)
      COMMON /TPS/ NWNPT,NWPRT,NWDPT(MXWPRC)
      COMMON /BLKPSF/ WSSF(MXWPRH),WSSFF(MXWDPH,MXWPRH),
     1                TWSSFF(MXWDPH,MXWPRH),IWTYPF(MXWNPH),
     2                NPWF(MXWNPH),JWTYPF(MXWNPH)
      COMMON /BLKPST/ WSST(MXWPRC),WSSFT(MXWDPC,MXWPRC),
     1                TWSSFT(MXWDPC,MXWPRC),IWTYPT(MXWNPC),
     2                NPWT(MXWNPC),JWTYPT(MXWNPC)
C
C ------- COMMON BLOCK FOR FLOW BOUNDARY CONDITIONS
C
      COMMON /FDBC/ NDNPF,NDPRF,NDDPF(MXDPRH)
      COMMON /FCBC/ NCESF,NCNPF,NCPRF,NCDPF(MXCPRH)
      COMMON /FVBC/ NVESF,NVNPF,NVPRF,NVDPF(MXVPRH)
      COMMON /FNBC/ NNESF,NNNPF,NNPRF,NNDPF(MXNPRH)
      COMMON /FRBC/ NRESF,NRNPF,NRPRF,NRDPF(MXRPRH),NRMAF
C
      COMMON /BLKDBF/ HDBF(MXDPRH),HDBFF(MXDDPH,MXDPRH),
     1        THDBFF(MXDDPH,MXDPRH),IDTYPF(MXDNPH),NPDBF(MXDNPH),
     2        JDTYPF(MXDNPH)
      COMMON /BLKCBF/ QCBF(MXCPRH),QCBFF(MXCDPH,MXCPRH),
     1        TQCBFF(MXCDPH,MXCPRH),ICTYPF(MXCESH),ISCF(5,MXCESH),
     2        NPCBF(MXCNPH),IDCF(MXCESH),JCTYPF(MXCESH)
      COMMON /BLKVBF/ QVBF(MXVPRH),QVBFF(MXVDPH,MXVPRH),
     1        TQVBFF(MXVDPH,MXVPRH),IVTYPF(MXVESH),ISVF(5,MXVESH),
     2        NPVBF(MXVNPH),IDVF(MXVESH),JVTYPF(MXVESH)
      COMMON /BLKNBF/ QNBF(MXNPRH),QNBFF(MXNDPH,MXNPRH),
     1        TQNBFF(MXNDPH,MXNPRH),INTYPF(MXNESH),ISNF(5,MXNESH),
     2        NPNBF(MXNNPH),IDNF(MXNESH),JNTYPF(MXNESH)
      COMMON /BLKRBF/ HRBF(MXRPRH),HRBFF(MXRDPH,MXRPRH),
     1        THRBFF(MXRDPH,MXRPRH),IRTYPF(MXRNPH),NPRBF(MXRNPH),
     2        ISRF(6,MXRESH),PRORF(2,MXRESH),IDRF(MXRESH),NRBEF(MXRESH),
     3        IRMTYP(MXRMAH),JRTYPF(MXRNPH)
C
C ------- COMMON BLOCK FOR TRANSPORT BOUNDARY CONDITIONS
C
      COMMON /TDBC/ NDNPT,NDPRT,NDDPT(MXDPRC)
      COMMON /TCBC/ NCEST,NCNPT,NCPRT,NCDPT(MXCPRC)
      COMMON /TVBC/ NVEST,NVNPT,NVPRT,NVDPT(MXVPRC)
      COMMON /TNBC/ NNEST,NNNPT,NNPRT,NNDPT(MXNPRC)
C
      COMMON /BLKDBT/ CDBT(MXDPRC),CDBFT(MXDDPC,MXDPRC),
     1        TCDBFT(MXDDPC,MXDPRC),IDTYPT(MXDNPC),
     2        NPDBT(MXDNPC),JDTYPT(MXDNPC)
      COMMON /BLKCBT/ QCBT(MXCPRC),QCBFT(MXCDPC,MXCPRC),
     1        TQCBFT(MXCDPC,MXCPRC),ICTYPT(MXCESC),ISCT(5,MXCESC),
     2        NPCBT(MXCNPC),IDCT(MXCESC),JCTYPT(MXCESC)
      COMMON /BLKVBT/ CVBT(MXVPRC),CVBFT(MXVDPC,MXVPRC),
     1        TCVBFT(MXVDPC,MXVPRC),IVTYPT(MXVESC),ISVT(5,MXVESC),
     2        NPVBT(MXVNPC),IDVT(MXVESC),JVTYPT(MXVESC)
      COMMON /BLKNBT/ QNBT(MXNPRC),QNBFT(MXNDPC,MXNPRC),
     1        TQNBFT(MXNDPC,MXNPRC),INTYPT(MXNESC),ISNT(5,MXNESC),
     2        NPNBT(MXNNPC),IDNT(MXNESC),JNTYPT(MXNESC)
C
      COMMON /TCCARD/ IUNIT,JOPT,KOPT,IFILE,NPRINT,NPOST,
     1                ICFILE,IVFILE,PTIMES(MXPOST),POTIME(MXPOST)
      COMMON /TC2/ IDT,IDTXY,NDT
      COMMON /TC21/ TIMEL(MXDTCK),DELTAT(MXDTCK)
      COMMON /SPCARD/ NUNSAT,NSP(MXMATK),IHM(MXMATK),IHC(MXMATK),
     1       IHW(MXMATK),NPMC(MXMATK),NPCON(MXMATK),NPWC(MXMATK)
      COMMON /MPCARD/ NDVFUN,NPROPF(MXMATK),NPROPT(MXMATK)
C
      COMMON /RSCBBL/ NVTMPF(MXRSCB),NVTMPT(MXRSCB),NCTMPF(MXRSCB),
     1   NCTMPT(MXRSCB),NBTMPF(MXRSCB),NBTMPT(MXRSCB),KTEMP(KTMP)
C
      COMMON /XYCARD/ NTXY,NXY(MXXYS),NPOINT(MXXYS)
      COMMON /TEST/ TS(MXXYP,MXXYS),TVALUE(MXXYP,MXXYS)
      COMMON /UNSAT/ PH(MXSPMK,MXMATK),PMC(MXSPMK,MXMATK),
     1               PCON(MXSPMK,MXMATK),CONDUC(MXSPMK,MXMATK),
     2               PWC(MXSPMK,MXMATK),WC(MXSPMK,MXMATK),
     &               PMKNOT(MXSPMK + 4, MXMATK), PCKNOT(MXSPMK + 4,
     &               MXMATK), PWKNOT(MXSPMK + 4, MXMATK),
     &               PMCOEF(MXSPMK, MXMATK), PCCOEF(MXSPMK, MXMATK),
     &               PWCOEF(MXSPMK, MXMATK), IBSPL
      COMMON /TCONV/ NTY1(MXXYS),NTY2(MXXYS),NTY3(MXXYS),NTY4(MXXYS),
     1               NTY5(MXXYS),NTY6(MXXYS),NTY7(MXXYS),NTY8(MXXYS),
     2               NTY9(MXXYS),NTY10(MXXYS),NTY11(MXXYS),NTY12(MXXYS)
      COMMON /EFACE/ IFACE6(6),IFACE5(5),IFACE4(4)
      COMMON /BLK1/ KGB(4,6,3)
C
      COMMON /OCCARD/ KSELT,KSAVE(6)
      COMMON /PSCARD/ PQCNT,PCCNT,JPQCNT,JPCCNT
      COMMON /RSCARD/ VBFCNT,VBCCNT,HCON,HMIN,JVFCNT,JVCCNT
      COMMON /DBCARD/ DBHCNT,HDCNST,JDBCNT,JHDCNT
      COMMON /CBCARD/ ISURCB,JSURCB(MXCNPH)
      COMMON /NBCARD/ CNFCNT,CNCCNT,JNFCNT,JNCCNT
      COMMON /ICREAL/ HCONST,CONVAL,HSTIME
      COMMON /ICINT/ IHEAD,ICON,ISTART
C
      COMMON /PLIC/ LIPC
C
      DIMENSION RSVAB(MXVNPH,4),PROPF(9,MXMATK),RHOMU(MXRMPK),
     1 PROPT(13,MXMATK),RBHC(MXRMAH),RBT(MXRMAH),IE(MAXELK,9)
C
      DIMENSION NTY(MXXYS)
C
CRAE 10-24-94   set IEND = 0. this is the flag indicating whether
C               the 'END' card has been found (=1) or not (=0)
      DATA IEND/0/
C
C ... READ FIRST "HEC" RECORD, LOOKING FOR A "T" CARD          (T_ CARD)
C
      NC1=0
      NC2=0
      NC3=0
      NC4=0
      NC5=0
      NC6=0
      NC7=0
      NC8=0
      NC9=0
      NC10=0
      NC11=0
      NC12=0
      NC13=0
      NC14=0
      NC15=0
      NC16=0
      NC17=0
      IHEAD=1
      ICON=1
      NTI =0
      NTIF=0
      NTIT=0
C
      READ(15,201) Z8
  201 FORMAT(A8)
      IF (Z8.NE.'3DFEMWBC') THEN
          WRITE(*,202)
  202 FORMAT('   ERROR, THIS IS NOT A 3DFEMWBC FILE')
         call stopfile  ! emrl jig
          STOP 'RINPUT'
      ENDIF
C
      OPEN(24,FILE='3dfemwbc.ech',STATUS='UNKNOWN')
C
      READ(15,10) IC1,IC3,TITLE
   10 FORMAT(A2,A1,A6)
   30 CONTINUE
      WRITE(24,20) IC1,IC3,TITLE
   20 FORMAT(1X,A2,A1,A6)
      IF (IC1.NE.'T1'.AND.IC1.NE.'T2'.AND.IC1.NE.'T3') THEN
          WRITE(24,11)
   11     FORMAT(' *** ERROR, "T" CARD EXPECTED, RUN TERMINATED ***')
          call stopfile  ! emrl jig
          STOP 'T1CARD'
      ENDIF
      IF (IC1.EQ.'T3') GO TO 40
      READ(15,10) IC1,IC3,TITLE
      GO TO 30
C-
C ... DATA INITIALIZATION FOR HEC READS
C-
   40 CONTINUE
C-
C ... MAIN DATA READ                                    (MAIN DATA READ)
C-
      READ(15,12,END=9) IC1,IC3,(JREC(I),I=1,180)
   12 FORMAT(A2,A1,180A1)
      I1=1
   13 CONTINUE
C
C ...     OPTION PARAMETERS CARD - OP CARD               (OP CARD)
C
      IF (IC1.EQ.'OP') THEN
C ...                        - OP1 CARD                  (OP1 TYPE)
C
           IF (IC3.EQ.'1') THEN
                 JJ=1
                 KNT(1)=0
                 CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
   15 FORMAT(1X,A2,A1,12(I8,2X))
                 WRITE(24,15) IC1,IC3,KNT(1)
                 KMOD = KNT(1)
C
C ...                      - OP2 CARD                      (OP2 TYPE)
C
           ELSE IF (IC3.EQ.'2') THEN
                  JJ=6
                  DO I=1,JJ
                     KNT(I)=0
                  ENDDO
                  CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                  WRITE(24,15) IC1,IC3,(KNT(I),I=1,6)
                  KSSF   = KNT(1)
                  KSST   = KNT(2)
                  ILUMP  = KNT(3)
                  IMID   = KNT(4)
                  IPNTSF = KNT(5)
                  IQUAR  = KNT(6)
                  IPNTST=IPNTSF
C
C ...                    - OP3 CARD                      (OP3 TYPE)
C
            ELSE IF( IC3.EQ.'3') THEN
                   JJ=7
                   DO I =1,JJ
                      REA(I)= 0.0D0
                   ENDDO
                   CALL CRACKD (I1,JJ,REA,'REAL     ')
                   WRITE(24,95) IC1,IC3,(REA(I),I=1,7)
                   WF   = REA(1)
                   WT   = REA(1)
                   OMEF = REA(2)
                   OMET = REA(2)
                   OMIF = REA(3)
                   OMIT = REA(3)
                   OMEMIN = REA(4)
                   OMEMAX = REA(5)
                   OMEADD = REA(6)
                   OMERED = REA(7)
C
                   IF (OMEMIN .EQ. 0.0D0) OMEMIN = 0.1D0
                   IF (OMEMAX .EQ. 0.0D0) OMEMAX = 1.0D0
                   IF (OMEADD .EQ. 0.0D0) OMEADD = 5.0D-3
                   IF (OMERED .EQ. 0.0D0) OMERED = 2.0D0 / 3.0D0
C
C ...                     - OP4 CARD                      (OP4 TYPE)
C
            ELSE IF (IC3.EQ.'4') THEN
                   JJ=1
                   KNT(1)=0
                   CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                   WRITE(24,15) IC1,IC3,KNT(1)
                   KSORP  = KNT(1)
C
C ...                     - OP5 CARD                      (OP5 TYPE)
C
            ELSE IF (IC3.EQ.'5') THEN
                   JJ=1
                   REA(1)= 0.0D0
                   KNT(1)=0
                   CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                   CALL CRACKD (I1,JJ,REA,'REAL     ')
                   WRITE(24,75) IC1,IC3,KNT(1),REA(1)
                   IEIGEN = KNT(1)
                   GG = REA(1)
            ENDIF
C
C ...     ITERATION PARAMETERS INFORMATION - CARD          (IP CARD)
C
       ELSE IF (IC1.EQ.'IP') THEN
C ...                    - IP1CARD                        (IP1 TYPE)
C
             IF (IC3.EQ.'1') THEN
                 JJ=3
                 DO I=1,JJ
                    KNT(I)=0
                 ENDDO
                 CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                 NITERF  = KNT(1)
                 NCYLF   = KNT(2)
                 NPITERF = KNT(3)
                 JJ=2
                 REA(1) = 0.0D0
                 REA(2) = 0.0D0
                 CALL CRACKD (I1,JJ,REA,'REAL     ')
                 TOLAF=REA(1)
                 TOLBF=REA(2)
                 JJ=1
                 KNT(1)=0
                 CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                 IBSPL=KNT(1)
                 WRITE(24,45) IC1,IC3,NITERF,NCYLF,NPITERF,TOLAF,
     &             TOLBF,IBSPL
   45            FORMAT(1X,A2,A1,3I8,2F13.4,I8)
C
C ...                       - IP2 CARD                      (IP2 TYPE)
C
             ELSE IF (IC3.EQ.'2') THEN
                  JJ=2
                  DO I=1,JJ
                     KNT(I)=0
                     REA(I)=0.0D0
                  ENDDO
                  CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                  NITERT  = KNT(1)
                  NPITERT = KNT(2)
                  JR=1
                  CALL CRACKD (I1,JR,REA,'REAL     ')
                  WRITE(24,35) IC1,IC3,(KNT(I),I=1,2),REA(1)
                  TOLBT = REA(1)
   35 FORMAT(1X,A2,A1,2I8,2F13.4)
C
C ...                       - IP3 CARD                      (IP3 TYPE)
C
             ELSE IF (IC3.EQ.'3') THEN
                 JI=1
                 KNT(1)=0
                 REA(1)=0.0D0
                 REA(2)=0.0D0
                 REA(3)=0.0D0
                 CALL CRACKI (I1,JI,KNT,'INTEGER  ')
                 NITFTT = KNT(1)
                 JR=3
                 CALL CRACKD (I1,JR,REA,'REAL     ')
                 OMEFTT = REA(1)
                 EPSS = REA(2)
                 EPST = REA(3)
                 WRITE(24,55) IC1,IC3,KNT(1),(REA(I),I=1,3)
   55 FORMAT(1X,A2,A1,I8,8F10.3)
             ENDIF
C
C ...                     - PT CARD                      (PT1 TYPE)
C
       ELSE IF (IC1.EQ.'PT') THEN
                JJ=4
                DO I=1,JJ
                   KNT(I)=0
                ENDDO
                CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                WRITE(24,15) IC1,IC3,(KNT(I),I=1,4)
                NXW = KNT(1)
                NYW = KNT(2)
                NZW = KNT(3)
                IDETQ = KNT(4)
C
C ...     TIME CONTROL PARAMETERS               (TC CARD)
C
       ELSE IF (IC1.EQ.'TC') THEN
C ...           - TC1 CARD                      (TC1 TYPE)
C
                IF (IC3.EQ.'1') THEN
                     JJ=1
                     REA(1)=0.0D0
                     CALL CRACKD (I1,JJ,REA,'REAL     ')
                     WRITE(24,95) IC1,IC3,REA(1)
                     TMAX = REA(1)
C
C ...                - TC2 CARD                  (TC2 TYPE)
C
                ELSE IF (IC3.EQ.'2') THEN
                      JJ=1
                      REA(1)=0.0D0
                      KNT(1)=0
                      CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                      IDT = KNT(1)
                      IF (IDT.EQ.0) THEN
                          CALL CRACKD (I1,JJ,REA,'REAL     ')
                          DELT=REA(1)
                          WRITE(24,75) IC1,IC3,KNT(1),REA(1)
   75            FORMAT(1X,A2,A1,I8,2D12.4)
                          IF (TMAX.LE.0.001D0) THEN
                             NTI =0
                             NTIF=0
                             NTIT=0
                          ELSE
                             NTI=TMAX/DELT+1
                             NTIT=NTI
                             NTIF=NTI
                          ENDIF
                      ELSEIF (IDT.EQ.1) THEN
                         JJ=1
                         KNT(1)=0
                         CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                         WRITE(24,15) IC1,IC3,IDT,KNT(1)
                         IDTXY=KNT(1)
                      ELSE
                          WRITE(*,7001)
 7001 FORMAT(10X,'Error on TC2 CARD')
        call stopfile  ! emrl jig
                          STOP '7001'
                      ENDIF
               ENDIF
C
C ...     OUTPUT CONTROL PARAMETERS               (OC CARD)
C
       ELSE IF (IC1.EQ.'OC') THEN
C ...           - OC1 CARD                      (OC1 TYPE)
C
              IF (IC3.EQ.'1') THEN
                   JJ=4
                   DO I=1,JJ
                      KNT(I)=0
                   ENDDO
                   CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                   WRITE(24,15) IC1,IC3,(KNT(I),I=1,JJ)
                   IBUG =KNT(1)
                   ICHNG=KNT(2)
                   JOPT =KNT(3)
                   IF (JOPT.EQ.0) THEN
                        KPRT=KNT(4)
                   ELSE
                        NPRINT=KNT(4)
                        DO I=1,NPRINT
                           READ(15,*) PTIMES(I)
                           WRITE(24,*) PTIMES(I)
                        ENDDO
                   ENDIF
C
C ...             - OC2 CARD                      (OC2 TYPE)
C
               ELSE IF (IC3.EQ.'2') THEN
                      JJ=7
                      DO I=1,JJ
                         KNT(I)=0
                      ENDDO
                      CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                      WRITE(24,15) IC1,IC3,(KNT(I),I=1,JJ)
                      NSELT=KNT(1)
                      DO I=1,NSELT
                         KPR0(I)=KNT(I+1)
                      ENDDO
C
C ...             - OC3 CARD                      (OC3 TYPE)
C
               ELSE IF (IC3.EQ.'3') THEN
                      JJ=3
                      KNT(1)=0
                      KNT(2)=0
                      KNT(3)=0
                      CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                      WRITE(24,15) IC1,IC3,(KNT(I),I=1,JJ)
                      IFILE=KNT(1)
                      KOPT =KNT(2)
                      IF (KOPT.EQ. 0 ) THEN
	                   KDSK=KNT(3)
                      ELSE
                           NPOST=KNT(3)
                           DO I=1,NPOST
                               READ(15,*) POTIME(I)
                               WRITE(24,85) POTIME(I)
   85                          FORMAT(1X,F15.4)
                           ENDDO
                      ENDIF
                      IF (NPOST.GT.100) THEN
                          WRITE(*,7002) NPOST
 7002 FORMAT(10X,'TC5 CARD, NPOST=',I4,' > 100')
        call stopfile  ! emrl jig
                          STOP '7002'
                      ENDIF
C
C ...             - OC4 CARD                      (OC4 TYPE)
C
               ELSE IF( IC3.EQ.'4') THEN
                      JJ=6
                      DO I=1,JJ
                         KNT(I)=0
                      ENDDO
                      CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                      WRITE(24,15) IC1,IC3,(KNT(I),I=1,JJ)
                      KSELT=KNT(1)
                      DO I=1,KSELT
                         KSAVE(I)=KNT(I+1)
                      ENDDO
               ENDIF
C
C ...       MATERIAL PROPERTIES - CARD             (MP CARD)
C
       ELSE IF (IC1.EQ.'MP') THEN
C ...                 - MP1CARD                    (MP1 TYPE)
C
              IF (IC3.EQ.'1') THEN
                     JJ=1
                     KNT(1)=0
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,KNT(1)
                     KCP = KNT(1)
C
C ...                 - MP2 CARD                    (MP2 TYPE)
C
              ELSE IF (IC3.EQ.'2') THEN
                     KNT(1)=0
                     JJ=1
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
C
                     NMPPM=8
                     DO I=1,NMPPM
                        REA(I)=0.0D0
                     ENDDO
                     JJ=8
                     CALL CRACKD (I1,JJ,REA,'REAL     ')
                     WRITE(24,25) IC1,IC3,KNT(1),(REA(I),I=1,8)
   25 FORMAT(1X,A2,A1,I6,10F9.3)
                     NC8=NC8+1
                     IF (NC8.GT.MXMATK) THEN
                         WRITE(24,7003) NC8,MXMATK
 7003 FORMAT(10X,'MP2 CARD, MAX. NUMBER OF MATERIAL TYPE=',I4,
     1       ' > MXMATK=',I4)
	       call stopfile  ! emrl jig
                         STOP '7003'
                     ENDIF
C ECGL begin comment 1/12/98
C      From now on the compressibilities will not be in the
C      modified form.  Therefore, we must multiply by RHO and GRAV
C      to get the modified form.
C
                     REA(7)=REA(7)*RHO*GRAV
C ECGL end comment 1/12/98
C
                     NPROPF(NC8)=KNT(1)
                     DO J=1,8
                        PROPF(J,NC8) =REA(J)
                     ENDDO

C
C ...                 - MP3 CARD                    (MP3 TYPE)
C
              ELSE IF (IC3.EQ.'3') THEN
                     JJ=4
                     DO I=1,JJ
                        REA(I)=0.0D0
                     ENDDO
                     CALL CRACKD (I1,JJ,REA,'REAL     ')
                     WRITE(24,95) IC1,IC3,(REA(I),I=1,4)
   95 FORMAT(1X,A2,A1,8D12.5)
                     RHO  =REA(1)
                     VISC =REA(2)
                     GRAV =REA(3)
                     BETAP=REA(4)
C ECGL begin comment 1/12/98
C      From now on the compressibilities will not be in the
C      modified form.  Therefore, we must multiply by RHO and GRAV
C      to get the modified form.
C
                     BETAP=BETAP*RHO*GRAV
C ECGL end comment 1/12/98
C
C
C ...                   - MP4 CARD                   (MP4 TYPE)
C
              ELSE IF (IC3.EQ.'4') THEN
                     JJ=8
                     NRMP=8
                     DO I=1,JJ
                        REA(I)=0.0D0
                     ENDDO
                     CALL CRACKD (I1,JJ,REA,'REAL     ')
                     WRITE(24,95) IC1,IC3,(REA(I),I=1,8)
                     DO I=1,NRMP
                        RHOMU(I)=REA(I)
                     ENDDO
C
C ...                   - MP5 CARD                    (MP5 TYPE)
C
              ELSE IF (IC3.EQ.'5') THEN
                     JJ=1
                     KNT(1)=0
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
C
                     JJ=11
                     DO I=1,JJ
                          REA(I)=0.0D0
                     ENDDO
                     CALL CRACKD (I1,JJ,REA,'REAL     ')
                     WRITE(24,25) IC1,IC3,KNT(1),(REA(I),I=1,JJ)
                     IF (REA(11) .EQ. 0.0D0) REA(11) = 1.0D0
                     NC6=NC6+1
                     IF (NC6.GT.MXMATK) THEN
                          WRITE(*,7004) NC6,MXMATK
 7004 FORMAT(10X,'MP5 CARD, MAX. NUMBER OF MATERIAL TYPE=',I4,
     1       ' > MXMATK=',I4)
	       call stopfile  ! emrl jig
                          STOP 'MP5CARD'
                     ENDIF
                     NPROPT(NC6)=KNT(1)
                     DO J=1,8
                        PROPT(J,NC6)=REA(J)
                     ENDDO
                     DO J=11,13
                        PROPT(J,NC6)=REA(J-2)
                     ENDDO
              ENDIF
C
C .. SOIL PROPERTIES CARD                        (SP CARD)
C
       ELSE IF (IC1.EQ.'SP') THEN
C
C ...     Control parameters    - SP1 CARD           (SP1 TYPE)
C
               IF (IC3.EQ.'1') THEN
                   JJ=4
                   DO I=1,JJ
                       KNT(I)=0
                   ENDDO
	           CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
C
                   WRITE(24,15) IC1,IC3,(KNT(I),I=1,JJ)
	           NC9=NC9+1
	           IF (NC9.GT.MXMATK) THEN
	               WRITE(*,7005) NC9,MXMATK
 7005 FORMAT(10X,'SP1 CARD, MAX. NUMBER OF SOIL TYPES=',I4,
     1       ' > MXMATK=',I4)
	       call stopfile  ! emrl jig
	                STOP 'SP1CARD'
	           ENDIF
	           NSP(NC9)=KNT(1)
	           IHM(NC9)=KNT(2)
	           IHC(NC9)=KNT(3)
	           IHW(NC9)=KNT(4)
	        ENDIF
C
C .. XY SERIES CARD                        (XY CARD)
C
       ELSE IF (IC1.EQ.'XY') THEN
C
C ...     Control parameters    - XY1 CARD           (XY TYPE)
C
c EMRL              IF (IC3.EQ.'1') THEN
	         IF (IC3.EQ.'1'.or.ic3.eq.'S') THEN
	            if (ic3.eq.'1') then ! emrl XYS
	              jj=5               ! emrl XYS
	            else                 ! emrl XYS
	              jj=2               ! emrl XYS
	            endif                ! emrl XYS
                  ! emrl XYS JJ=5
                  DO I=1,JJ
                     KNT(I)=0
                  ENDDO
	          CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                  WRITE(24,15) IC1,IC3,(KNT(I),I=1,5)
                  NC7=NC7+1
                  IF (NC7.GT.MXXYS) THEN
                      WRITE(*,7006) KNT(1),MXXYS
 7006 FORMAT(10X,'XY1 CARD:',
     1 ' The XY series card =',I6,' > MXXYS=',I6,' stop')
	       call stopfile  ! emrl jig
                      STOP 'XYCARD'
                  ENDIF
                  NXY(NC7) = KNT(1)
                  NPOINT(NC7)= KNT(2)
                  IF (KNT(2).GT.MXXYP) THEN
                      WRITE(*,7007) KNT(2)
 7007 FORMAT(10X,'XY series card, number of points >MXXYP:',I5)
        call stopfile  ! emrl jig
                       STOP '7007'
                  ENDIF
                  DO J=1,KNT(2)
                     READ(15,*) XX,YY
                     WRITE(24,105) XX,YY
  105 FORMAT(1X,2(D15.5,5X))
                     TS(J,NC7) = XX
                     TVALUE(J,NC7) = YY
                  ENDDO
C
C         CHECK FOR DUPLICATE X VALUE.
C
                  TLAST = 1.0D10
                  DO J = 1, KNT(2)
                    IF (TS(J, NC7) .EQ. TLAST) THEN
                      WRITE(*,5422) TLAST, KNT(1)
 5422 FORMAT(' Duplicate X value, ',F15.6,' detected in XY series #',I4)
        call stopfile  ! emrl jig
                      STOP
                    END IF
                    TLAST = TS(J, NC7)
                  END DO
               ENDIF
C
C .. POINT SOURCE/SINK DATA- CARD             (PS CARD)
C
       ELSE IF (IC1.EQ.'PS') THEN
               JJ=2
               KNT(1)=0
               KNT(2)=0
               IF (IC3.EQ.'1') THEN
                    CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                    WRITE(24,15) IC1,IC3,(KNT(I),I=1,2)
                    NC1=NC1+1
                    IF (NC1.GT.MXWNPH) THEN
                        WRITE(*,7008) NC1,MXWNPH
 7008 FORMAT(10X,'PS1 card, MAX. NUMBER OF WELLS FOR FLOW=',I4,
     1       ' > MXWNPH=',I5)
	       call stopfile  ! emrl jig
                        STOP 'PS1CARD'
                    ENDIF
                    NPWF(NC1) =KNT(1)
                    IWTYPF(NC1) = KNT(2)
C
C ...     Control parameters    - PS2 CARD           (PS2 TYPE)
C
                ELSEIF (IC3.EQ.'2') THEN
                    CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                    WRITE(24,15) IC1,IC3,(KNT(I),I=1,2)
                    NC11=NC11+1
                    IF (NC11.GT.MXWNPC) THEN
                        WRITE(*,7009) NC11,MXWNPC
 7009 FORMAT(10X,'PS2 card, MAX. NUMBER OF WELLS FOR CONC=',I4,
     1       ' > MXWNPC=',I5)
	       call stopfile  ! emrl jig
                        STOP 'PS2CARD'
                    ENDIF
                    NPWT(NC11) = KNT(1)
                    IWTYPT(NC11) = KNT(2)
                ENDIF		
C
C .. RAINFALL/EVAPORATION-SEEPAGE B.C.          (RS CARD)
C
       ELSE IF (IC1.EQ.'RS') THEN
C
C ...     Control parameters    - RS1 CARD           (RS1 TYPE)
C
                IF (IC3.EQ.'1') THEN
                     JJ=3
                     DO I=1,JJ
                        KNT(I)=0
                     ENDDO
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,(KNT(I),I=1,3)
                     NC2=NC2+1
                     IF (NC2.GT.MXVESH) THEN
                         WRITE(*,7010) NC2,MXVESH
 7010 FORMAT(10X,'RS1 card, MAX. NUMBER OF ELEMENTS=',I4,
     1       ' > MXVESH=',I4)
                         STOP 'NC2'
                     ENDIF
                     NVTMPF(NC2) = KNT(1)
                     IVTYPF(NC2) = KNT(3)
                     NELM=KNT(1)
                     IDFACE=KNT(2)
                     CALL CFACE(NELM,IDFACE,IDVF,NC2,MXVESH)
C
C ...     Control parameters    - RS2 CARD
C
                ELSEIF (IC3.EQ.'2') THEN
                     JJ=3
                     DO I=1,JJ
                        KNT(I)=0
                     ENDDO
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,(KNT(I),I=1,3)
                     NC12=NC12+1
                     IF (NC12.GT.MXVESC) THEN
                         WRITE(*,7011) NC12,MXVESC
 7011 FORMAT(10X,'RS2 card, MAX. NUMBER OF ELEMENTS FOR CONC=',I4,
     1       ' > MXVESC=',I4)
	       call stopfile  ! emrl jig
                         STOP 'NC12'
                     ENDIF
                     NVTMPT(NC12) = KNT(1)
                     IVTYPT(NC12) = KNT(3)
                     NELM=KNT(1)
                     IDFACE=KNT(2)
                     CALL CFACE(NELM,IDFACE,IDVT,NC12,MXVESC)
C
C ...     Control parameters    - RS3 CARD
C
                ELSEIF (IC3.EQ.'3') THEN
                     JJ=2
                     DO I=1,JJ
                        REA(I)=0.0D0
                     ENDDO
                     CALL CRACKD (I1,JJ,REA,'REAL     ')
                     WRITE(24,95) IC1,IC3,(REA(I),I=1,2)
                     HCON = REA(1)
                     HMIN = REA(2)
                ENDIF		
C
C .. DIRICHLET BOUNDARY CONDITIONS:HEAD           (DB CARD)
C
       ELSE IF (IC1.EQ.'DB') THEN
C
C ...     Control parameters    - DB1 CARD           (DB1 TYPE)
C
                JJ=2
                KNT(1)=0
                KNT(2)=0
                IF (IC3.EQ.'1') THEN
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,(KNT(I),I=1,2)
                     NC3=NC3+1
                     IF (NC3.GT.MXDNPH) THEN
                         WRITE(*,7012) NC3,MXDNPH
 7012 FORMAT(10X,'DB1 card, MAX. NUMBER OF HEAD NODAL POINTS=',
     1      I4,' > MXDNPH=',I4)
	       call stopfile  ! emrl jig
                         STOP 'NC3'
                     ENDIF
                     NPDBF(NC3)  = KNT(1)
                     IDTYPF(NC3) = KNT(2)
C
C ...                             - DB2 CARD           (DB2 TYPE)
C
                ELSEIF (IC3.EQ.'2') THEN
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,(KNT(I),I=1,2)
                     NC13=NC13+1
                     IF (NC13.GT.MXDNPC) THEN
                         WRITE(*,7013) NC13,MXDNPC
 7013 FORMAT(10X,'DB2 card, MAX. NUMBER OF CONC NODAL POINTS=',
     1      I4,' > MXDNPC=',I4)
	       call stopfile  ! emrl jig
                         STOP 'NC13'
                     ENDIF
                     NPDBT(NC13)  = KNT(1)
                     IDTYPT(NC13) = KNT(2)
                ENDIF		
C
C .. CAUCHY BOUNDARY CONDITIONS:FLUX            (CB CARD)
C
       ELSE IF (IC1.EQ.'CB') THEN
C
C ...     Control parameters    - CB1 CARD           (CB1 TYPE)
C
                JJ=3
                DO I=1,JJ
                   KNT(I)=0
                ENDDO
                IF (IC3.EQ.'1') THEN
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,(KNT(I),I=1,3)
                     NC4=NC4+1
                     IF (NC4.GT.MXCESH) THEN
                         WRITE(*,7014) NC4,MXCESH
 7014 FORMAT(10X,'CB1 card, MAX. NUMBER OF FLUX ELEMENTS=',I4,
     1       ' > MXCESH=',I4)
	       call stopfile  ! emrl jig
                         STOP 'NC4'
                     ENDIF
                     NCTMPF(NC4) = KNT(1)
                     ICTYPF(NC4) = KNT(3)
                     NELM=KNT(1)
                     IDFACE=KNT(2)
                     CALL CFACE(NELM,IDFACE,IDCF,NC4,MXCESH)
C
C ...     Control parameters    - CB2 CARD           (CB2 TYPE)
C
                ELSEIF (IC3.EQ.'2') THEN
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,(KNT(I),I=1,3)
                     NC14=NC14+1
                     IF (NC14.GT.MXCESC) THEN
                         WRITE(*,7015) NC14,MXCESC
 7015 FORMAT(10X,'CB2 card, MAX. NUMBER OF CONC ELEMENTS=',I4,
     1       ' > MXCESC=',I4)
	       call stopfile  ! emrl jig
                         STOP 'NC14'
                     ENDIF
                     NCTMPT(NC14) = KNT(1)
                     ICTYPT(NC14) = KNT(3)
                     NELM=KNT(1)
                     IDFACE=KNT(2)
                     CALL CFACE(NELM,IDFACE,IDCT,NC14,MXCESC)
                ENDIF		
C
C .. NEUMANN BOUNDARY CONDITIONS:FLUX            (NB CARD)
C
       ELSE IF (IC1.EQ.'NB') THEN
C
C ...     Control parameters    - NB1 CARD           (NB1 TYPE)
C
                JJ=3
                DO I=1,JJ
                   KNT(I)=0
                ENDDO
                IF (IC3.EQ.'1') THEN
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,(KNT(I),I=1,3)
                     NC5=NC5+1
                     IF (NC5.GT.MXNESH) THEN
                         WRITE(*,7016) NC5,MXNESH
 7016 FORMAT(10X,'NB1 card, MAX. NUMBER OF FLUX POINTS=',I4,
     1       ' > MXNESH=',I4)
	       call stopfile  ! emrl jig
                         STOP 'NC5'
                     ENDIF
                     NBTMPF(NC5) = KNT(1)
                     INTYPF(NC5) = KNT(3)
                     NELM=KNT(1)
                     IDFACE=KNT(2)
                     CALL CFACE(NELM,IDFACE,IDNF,NC5,MXNESH)
C
C ...     Control parameters    - NB2 CARD           (NB2 TYPE)
C
                ELSEIF (IC3.EQ.'2') THEN
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,(KNT(I),I=1,3)
                     NC15=NC15+1
                     IF (NC15.GT.MXNESC) THEN
                         WRITE(*,7017) NC15,MXNESC
 7017 FORMAT(10X,'NB2 card, MAX. NUMBER OF CONC POINTS=',I4,
     1       ' > MXNESC=',I4)
	       call stopfile  ! emrl jig
                         STOP 'NC15'
                     ENDIF
                     NBTMPT(NC15) = KNT(1)
                     INTYPT(NC15) = KNT(3)
                     NELM=KNT(1)
                     IDFACE=KNT(2)
                     CALL CFACE(NELM,IDFACE,IDNT,NC15,MXNESC)
                ENDIF
C
C ...     Control parameters    - RB1 CARD           (RB1 TYPE)
C
       ELSE IF (IC1.EQ.'RB') THEN
                IF (IC3.EQ.'1') THEN
                     JJ=2
                     KNT(1)=0
                     KNT(2)=0
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,(KNT(I),I=1,2)
                     NC10=NC10+1
                     IF (NC10.GT.MXRNPH) THEN
                         WRITE(*,7018) NC10,MXRNPH
 7018 FORMAT(10X,'RB1 card, MAX. NUMBER OF NODAL POINTS=',I4,
     1       ' > MXRNPH=',I4)
	       call stopfile  ! emrl jig
                         STOP 'RB1'
                     ENDIF
                     NPRBF(NC10) = KNT(1)
                     IRTYPF(NC10) = KNT(2)
C
C ...     Control parameters    - RB2 CARD           (RB2 TYPE)
C
                ELSEIF (IC3.EQ.'2') THEN
                     JJ=3
                     DO I=1,JJ
                        KNT(I)=0
                     ENDDO
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,(KNT(I),I=1,3)
                     NC16=NC16+1
                     IF (NC16.GT.MXRESH) THEN
                         WRITE(*,7019) NC16,MXRESH
 7019 FORMAT(10X,'RB2 card, MAX. ELEMENT NUMBER =',I4,
     1       ' > MXRESH=',I4)
	       call stopfile  ! emrl jig
                         STOP 'RB2'
                     ENDIF
                     NRBEF(NC16) = KNT(1)
                     ISRF(6,NC16) = KNT(3)
                     NELM=KNT(1)
                     IDFACE=KNT(2)
                     CALL CFACE(NELM,IDFACE,IDRF,NC16,MXRESH)
C
C ...     Control parameters    - RB3 CARD           (RB3 TYPE)
C
                ELSEIF (IC3.EQ.'3') THEN
                     KNT(1)=0
                     JJ=1
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     JJ=2
                     REA(1)=0.0D0
                     REA(2)=0.0D0
                     CALL CRACKD (I1,JJ,REA,'REAL     ')
                     WRITE(24,75) IC1,IC3,KNT(1),REA(1),REA(2)
                     NC17=NC17+1
                     IF (NC17.GT.MXRMAH) THEN
                         WRITE(*,7020) NC17,MXRMAH
 7020 FORMAT(10X,'RB3 card, MAX. bed material type =',I4,
     1       ' > MXRMAH=',I4)
	       call stopfile  ! emrl jig
                         STOP 'RB3'
                     ENDIF
                     IRMTYP(NC17) = KNT(1)
                     RBHC(NC17) = REA(1)
                     RBT(NC17) = REA(2)
                ENDIF		
C
C .. INITIAL CONDITIONS:HEAD                        (IC CARD)
C
       ELSE IF (IC1.EQ.'IC') THEN
C ...                                               (ICH TYPE)
                IF (IC3.EQ.'H') THEN
                     JJ=1
                     KNT(1)=0
                     REA(1)=0.0D0
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     CALL CRACKD (I1,JJ,REA,'REAL     ')
                     WRITE(24,25) IC1,IC3,KNT(1),REA(1)
                     IHEAD = KNT(1)
                     HCONST= REA(1)
C ...                                               (ICC TYPE)
                ELSEIF (IC3.EQ.'C') THEN
                     JJ=1
                     KNT(1)=0
                     REA(1)=0.0D0
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     CALL CRACKD (I1,JJ,REA,'REAL     ')
                     WRITE(24,25) IC1,IC3,KNT(1),REA(1)
                     ICON = KNT(1)
                     CONVAL=REA(1)
C ...                                               (ICS TYPE)
                ELSEIF (IC3.EQ.'S') THEN
                     JJ=1
                     KNT(1)=0
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,KNT(1)
                     ISTART = KNT(1)
C ...                                               (ICT TYPE)
                ELSEIF (IC3.EQ.'T') THEN
                     JJ=1
                     REA(1)=0.0D0
                     CALL CRACKD (I1,JJ,REA,'REAL     ')
                     WRITE(24,95) IC1,IC3,REA(1)
                     HSTIME = REA(1)
C ...                                               (ICF TYPE)
                ELSEIF (IC3.EQ.'F') THEN
                     JJ=3
                     KNT(1)=0
                     KNT(2)=0
                     KNT(3)=0
                     CALL CRACKI (I1,JJ,KNT,'INTEGER  ')
                     WRITE(24,15) IC1,IC3,(KNT(I),I=1,3)
                     ICFILE=KNT(1)
                     IVFILE=KNT(2)
                     IFFU  =KNT(3)
                ENDIF
C
C                                      (END CARD)
C
      ELSE IF(IC1.EQ.'EN') THEN
C
            IEND = 1
	    NWNPF=NC1
	    NWNPT=NC11
	    NVESF=NC2
	    NVEST=NC12
	    NDNPF=NC3
	    NDNPT=NC13
	    NCESF=NC4
	    NCEST=NC14
	    NNESF=NC5
	    NNEST=NC15
            NMAT=NC8
            NDVFUN=NC6
            NTXY=NC7
            NUNSAT=NC9
            NRNPF=NC10
            NRESF=NC16
            NRMAF=NC17
C
C ----- Checking the material type in the element is in sequence
C
            MTYP=1
            DO I=1,NUNSAT
               MTYP=MAX0(MTYP,NSP(I))
            ENDDO
C
            CALL MSORT (IE)
C
C  ------- WELL SOURCES/SINK
C
            IF (NC1.NE.0) THEN
                CALL TSCONV(NWNPF,IWTYPF,MXWNPH,NTXY,NXY,MXXYS,NTY,N1)
                NWPRF=N1
                IF (NWPRF.GT.MXWPRH) THEN
                     WRITE(*,9001) NWPRF,MXWPRH
	       call stopfile  ! emrl jig
                     STOP 'NC1'
 9001 FORMAT(5X,'NWPRF=',I5,5X,'MXWPRH=',I5)
                ENDIF
C               WRITE(16,8001) NWPRF
 8001 FORMAT(5X,'NWPRF:',I8)
                DO K=1,NWPRF
                   I=NTY(K)
                   NTY1(K)=NXY(I)
                   NWDPF(K)=NPOINT(I)
C                  WRITE(16,8002) K,NWDPF(K),NTY1(K)
 8002 FORMAT(5X,'K=',I5,5X,'NWDPF:',I5,5X,'NTY1:',I5)
                   NPXY=NPOINT(I)
                   IF (NPXY.GT.MXWDPH) THEN
                      WRITE(*,9901) NPXY
 9901 FORMAT(5X,'points in xy1 seris:',I5,' > MXWDPH:',I5)
        call stopfile  ! emrl jig
                      STOP 'npxy'
                   ENDIF
C
                   DO J=1,NPXY
C                      WRITE(16,8011) J,TS(J,I),TVALUE(J,I)
 8011 FORMAT(10X,'J=',I5,5X,2(E12.6,2X))
                      TWSSFF(J,K)=TS(J,I)
                      WSSFF(J,K)=TVALUE(J,I)
                   ENDDO
                ENDDO
            ENDIF
C
            IF (NC11.NE.0) THEN
               CALL TSCONV(NWNPT,IWTYPT,MXWNPC,NTXY,NXY,MXXYS,NTY,N1)
               NWPRT=N1
               IF (NWPRT.GT.MXWPRC) THEN
                     WRITE(*,9002) NWPRT,MXWPRC
	       call stopfile  ! emrl jig
                     STOP 'NC11'
 9002 FORMAT(5X,'NWPRT=',I5,5X,'MXWPRC=',I5)
               ENDIF
C
C                 WRITE(16,8003) NWPRT
 8003 FORMAT(5X,'NWPRT:',I8)
                DO K=1,NWPRT
                   I=NTY(K)
                   NTY2(K)=NXY(I)
                   NWDPT(K)=NPOINT(I)
C
C                   WRITE(16,8004) K,NWDPT(K),NTY2(K)
 8004 FORMAT(5X,'K=',I5,5X,'NWDPT:',I5,5X,'NTY2:',I5)
                   NPXY=NPOINT(I)
                   IF (NPXY.GT.MXWDPC) THEN
                      WRITE(*,9902) NPXY
 9902 FORMAT(5X,'points in xy1 seris:',I5,' > MXWDPC:',I5)
        call stopfile  ! emrl jig
                      STOP 'npxy'
                   ENDIF
C
                   DO J=1,NPXY
C                      WRITE(16,8012) J,TS(J,I),TVALUE(J,I)
 8012 FORMAT(10X,'J=',I5,5X,2(E12.6,2X))
                      TWSSFT(J,K)=TS(J,I)
                      WSSFT(J,K) =TVALUE(J,I)
                   ENDDO
                ENDDO
            ENDIF
C
C  --------  RAINFALL-SEEPAGE
C
            IF (NC2.NE.0) THEN
                CALL TSCONV(NVESF,IVTYPF,MXVESH,NTXY,NXY,MXXYS,NTY,N1)
                NVPRF=N1
                IF (NVPRF.GT.MXVPRH) THEN
                     WRITE(*,9003) NVPRF,MXVPRH
	       call stopfile  ! emrl jig
                     STOP 'NC2'
 9003 FORMAT(5X,'NVPRF=',I5,5X,'MXVPRH=',I5)
                ENDIF
C                 WRITE(16,8021) NVPRF
 8021 FORMAT(5X,'NVPRF:',I8)
                DO K=1,NVPRF
                   I=NTY(K)
                   NTY3(K)=NXY(I)
                   NVDPF(K)=NPOINT(I)
C
C                    WRITE(16,8022) K,NVDPF(K),NTY3(K)
 8022 FORMAT(5X,'K=',I5,5X,'NVPRF:',I5,5X,'NTY3:',I5)
                   NPXY=NPOINT(I)
                   IF (NPXY.GT.MXVDPH) THEN
                      WRITE(*,9903) NPXY
 9903 FORMAT(5X,'points in xy1 seris:',I5,' > MXVDPH:',I5)
        call stopfile  ! emrl jig
                      STOP 'npxy'
                   ENDIF
C
                   DO J=1,NPXY
C                      WRITE(16,8023) J,TS(J,I),TVALUE(J,I)
 8023 FORMAT(10X,'J=',I5,5X,2(E12.6,2X))
                      TQVBFF(J,K)=TS(J,I)
                      QVBFF(J,K) =TVALUE(J,I)
                   ENDDO
                ENDDO
            ELSE
                NCYLF=1
            ENDIF
C
            IF (NC12.NE.0) THEN
                CALL TSCONV(NVEST,IVTYPT,MXVESC,NTXY,NXY,MXXYS,NTY,N1)
                NVPRT=N1
                IF (NVPRT.GT.MXVPRC) THEN
                     WRITE(*,9004) NVPRT,MXVPRC
	       call stopfile  ! emrl jig
                     STOP 'NC12'
 9004 FORMAT(5X,'NVPRT=',I5,5X,'MXVPRC=',I5)
                ENDIF
                DO K=1,NVPRT
                   I=NTY(K)
                   NTY4(K)=NXY(I)
                   NVDPT(K)=NPOINT(I)
                   NPXY=NPOINT(I)
                   IF (NPXY.GT.MXVDPC) THEN
                      WRITE(*,9904) NPXY
 9904 FORMAT(5X,'points in xy1 seris:',I5,' > MXVDPC:',I5)
        call stopfile  ! emrl jig
                      STOP 'npxy'
                   ENDIF
C
                   DO J=1,NPXY
                      TCVBFT(J,K)=TS(J,I)
                      CVBFT(J,K)=TVALUE(J,I)
                   ENDDO
                ENDDO
            ENDIF
C
C ---------- HEAD BOUNDARIES
C
            IF (NC3.NE.0) THEN
                CALL TSCONV(NDNPF,IDTYPF,MXDNPH,NTXY,NXY,MXXYS,NTY,N1)
                NDPRF=N1
                IF (NDPRF.GT.MXDPRH) THEN
                     WRITE(*,9005) NDPRF,MXDPRH
	       call stopfile  ! emrl jig
                     STOP 'NC3'
 9005 FORMAT(5X,'NDPRF=',I5,5X,'MXDPRH=',I5)
                ENDIF
C                WRITE(16,8005) NDPRF
 8005 FORMAT(5X,'NDPRF:',I8)
                DO K=1,NDPRF
                   I=NTY(K)
                   NTY5(K)=NXY(I)
                   NDDPF(K)=NPOINT(I)
C                   WRITE(16,8006) K,NDDPF(K),NTY5(K)
 8006 FORMAT(5X,'K=',I5,5X,'NDDPF:',I5,5X,'NTY5:',I5)
                   NPXY=NPOINT(I)
                   IF (NPXY.GT.MXDDPH) THEN
                      WRITE(*,9905) NPXY
 9905 FORMAT(5X,'points in xy1 seris:',I5,' > MXDDPH:',I5)
        call stopfile  ! emrl jig
                      STOP 'npxy'
                   ENDIF
C
                   DO J=1,NPXY
C                        WRITE(16,8013) J,TS(J,I),TVALUE(J,I)
 8013 FORMAT(10X,'J=',I5,5X,2(E12.6,2X))
                      THDBFF(J,K)=TS(J,I)
                      HDBFF(J,K)=TVALUE(J,I)
                   ENDDO
                ENDDO
            ENDIF
C
            IF (NC13.NE.0) THEN
                CALL TSCONV(NDNPT,IDTYPT,MXDNPC,NTXY,NXY,MXXYS,NTY,N1)
                NDPRT=N1
                IF (NDPRT.GT.MXDPRC) THEN
                     WRITE(*,9006) NDPRT,MXDPRC
	       call stopfile  ! emrl jig
                     STOP 'NC13'
 9006 FORMAT(5X,'NDPRT=',I5,5X,'MXDPRC=',I5)
                ENDIF
C                 WRITE(16,8007) NDPRT
 8007 FORMAT(5X,'NDPRT:',I8)
                DO K=1,NDPRT
                   I=NTY(K)
                   NTY6(K)=NXY(I)
                   NDDPT(K)=NPOINT(I)
C                   WRITE(16,8008) K,NDDPT(K),NTY6(K)
 8008 FORMAT(5X,'K=',I5,5X,'NDDPT:',I5,5X,'NTY6:',I5)
                   NPXY=NPOINT(I)
                   IF (NPXY.GT.MXDDPC) THEN
                      WRITE(*,9906) NPXY
 9906 FORMAT(5X,'points in xy1 seris:',I5,' > MXDDPC:',I5)
        call stopfile  ! emrl jig
                      STOP 'npxy'
                   ENDIF
C
                   DO J=1,NPXY
C                      WRITE(16,8014) J,TS(J,I),TVALUE(J,I)
 8014 FORMAT(10X,'J=',I5,5X,2(E12.6,2X))
                      TCDBFT(J,K)=TS(J,I)
                      CDBFT(J,K)=TVALUE(J,I)
                   ENDDO
                ENDDO
            ENDIF
C
C  ---------- CAUCHY FLUX BOUNDARIES
C
            IF (NC4.NE.0) THEN
               CALL TSCONV(NCESF,ICTYPF,MXCESH,NTXY,NXY,MXXYS,NTY,N1)
               NCPRF=N1
               IF (NCPRF.GT.MXCPRH) THEN
                     WRITE(*,9007) NCPRF,MXCPRH
	       call stopfile  ! emrl jig
                     STOP 'NC4'
 9007 FORMAT(5X,'NCPRF=',I5,5X,'MXCPRH=',I5)
               ENDIF
               DO K=1,NCPRF
                   I=NTY(K)
                   NTY7(K)=NXY(I)
                   NCDPF(K)=NPOINT(I)
                   NPXY=NPOINT(I)
                   IF (NPXY.GT.MXCDPH) THEN
                      WRITE(*,9907) NPXY
 9907 FORMAT(5X,'points in xy1 seris:',I5,' > MXCDPH:',I5)
        call stopfile  ! emrl jig
                      STOP 'npxy'
                   ENDIF
C
C ----- Switch sign of flux direction
C           flux sign in GMS is different from the FEMWATER
C
                   DO J=1,NPXY
                      TQCBFF(J,K)=TS(J,I)
                      QCBFF(J,K)=-TVALUE(J,I)
                   ENDDO
                ENDDO
            ENDIF
C
            IF (NC14.NE.0) THEN
                CALL TSCONV(NCEST,ICTYPT,MXCESC,NTXY,NXY,MXXYS,NTY,N1)
                NCPRT=N1
                IF (NCPRT.GT.MXCPRC) THEN
                     WRITE(*,9008) NCPRT,MXCPRC
	       call stopfile  ! emrl jig
                     STOP 'NC14'
 9008 FORMAT(5X,'NCPRT=',I5,5X,'MXCPRC=',I5)
                ENDIF
                DO K=1,NCPRT
                   I=NTY(K)
                   NTY8(K)=NXY(I)
                   NCDPT(K)=NPOINT(I)
                   NPXY=NPOINT(I)
                   IF (NPXY.GT.MXCDPC) THEN
                      WRITE(*,9908) NPXY
 9908 FORMAT(5X,'points in xy1 seris:',I5,' > MXCDPC:',I5)
        call stopfile  ! emrl jig
                      STOP 'npxy'
                   ENDIF
C
                   DO J=1,NPXY
                      TQCBFT(J,K)=TS(J,I)
                      QCBFT(J,K)=-TVALUE(J,I)
                   ENDDO
                ENDDO
            ENDIF
C
C  ---------- NEUMANN FLUX BOUNDARIES
C
            IF (NC5.NE.0) THEN
                CALL TSCONV(NNESF,INTYPF,MXNESH,NTXY,NXY,MXXYS,NTY,N1)
                NNPRF=N1
                IF (NNPRF.GT.MXNPRH) THEN
                     WRITE(*,9009) NNPRF,MXNPRH
	       call stopfile  ! emrl jig
                     STOP 'NC5'
 9009 FORMAT(5X,'NNPRF=',I5,5X,'MXNPRH=',I5)
                ENDIF
                DO K=1,NNPRF
                   I=NTY(K)
                   NTY9(K)=NXY(I)
                   NNDPF(K)=NPOINT(I)
                   NPXY=NPOINT(I)
                   IF (NPXY.GT.MXNDPH) THEN
                      WRITE(*,9909) NPXY
 9909 FORMAT(5X,'points in xy1 seris:',I5,' > MXNDPH:',I5)
        call stopfile  ! emrl jig
                      STOP 'npxy'
                   ENDIF
C
C ----- Switch sign of flux direction
C           flux sign in GMS is different from the FEMWATER
C
                   DO J=1,NPXY
                      TQNBFF(J,K)=TS(J,I)
                      QNBFF(J,K)=-TVALUE(J,I)
                   ENDDO
                ENDDO
            ENDIF
C
            IF (NC15.NE.0) THEN
               CALL TSCONV(NNEST,INTYPT,MXNESC,NTXY,NXY,MXXYS,NTY,N1)
                NNPRT=N1
                IF (NNPRT.GT.MXNPRC) THEN
                     WRITE(*,9010) NNPRT,MXNPRC
	       call stopfile  ! emrl jig
                     STOP 'NC15'
 9010 FORMAT(5X,'NNPRT=',I5,5X,'MXNPRC=',I5)
                ENDIF
                DO K=1,NNPRT
                   I=NTY(K)
                   NTY10(K)=NXY(I)
                   NNDPT(K)=NPOINT(I)
                   NPXY=NPOINT(I)
                   IF (NPXY.GT.MXNDPC) THEN
                      WRITE(*,9910) NPXY
 9910 FORMAT(5X,'points in xy1 seris:',I5,' > MXNDPC:',I5)
        call stopfile  ! emrl jig
                      STOP 'npxy'
                   ENDIF
C
                   DO J=1,NPXY
                      TQNBFT(J,K)=TS(J,I)
                      QNBFT(J,K)=-TVALUE(J,I)
                   ENDDO
                ENDDO
            ENDIF
C
C  ---------- RIVER FLUX BOUNDARIES
C
C             head-sreies
C
            IF (NC10.NE.0) THEN
               CALL TSCONV(NRNPF,IRTYPF,MXRNPH,NTXY,NXY,MXXYS,NTY,N1)
                NRPRF=N1
                IF (NRPRF.GT.MXRNPH) THEN
                     WRITE(*,9012) NRPRF,MXRNPH
	       call stopfile  ! emrl jig
                     STOP 'NC10'
 9012 FORMAT(5X,'NRPRF=',I5,5X,'MXRNPH=',I5)
                ENDIF
                DO K=1,NRPRF
                   I=NTY(K)
                   NTY12(K)=NXY(I)
                   NRDPF(K)=NPOINT(I)
                   NPXY=NPOINT(I)
                   IF (NPXY.GT.MXRDPH) THEN
                      WRITE(*,9911) NPXY
 9911 FORMAT(5X,'points in xy1 seris:',I5,' > MXRDPH:',I5)
        call stopfile  ! emrl jig
                      STOP 'npxy'
                   ENDIF
C
                   DO J=1,NPXY
                      THRBFF(J,K)=TS(J,I)
                      HRBFF(J,K)=TVALUE(J,I)
                   ENDDO
                ENDDO
            ENDIF
C
C ------- river bed material
C
            IF (NRESF.NE.0) THEN
                DO MP=1,NRESF
                   DO J=1,NRMAF
                      IF (ISRF(6,MP).EQ.IRMTYP(J)) GO TO 101
                   ENDDO
                   WRITE(*,9013) MP
 9013 FORMAT(5X,'Bed material =',I2,' did not match IRMTYP')
        call stopfile  ! emrl jig
                   STOP '9013'
  101              CONTINUE
                   PRORF(1,MP)=RBHC(J)
                   PRORF(2,MP)=RBT(J)
                ENDDO
            ENDIF
C
C ------- Compute variable time step from XY card
C
            IF (IDTXY.GT.0) THEN
                DO K=1,NTXY
                   IF (NXY(K).EQ.IDTXY) THEN
                      NDT=NPOINT(K)
                      DO J=1,NDT
                         TIMEL(J)=TS(J,K)
                         DELTAT(J)=TVALUE(J,K)
                      ENDDO
                      NTI=NINT(TIMEL(1)/DELTAT(1))
                      DO J=2,NDT
                         NTI=NTI+NINT((TIMEL(J)-TIMEL(J-1))/DELTAT(J))
                      ENDDO
                      IF (TMAX.GT.TIMEL(NDT)) THEN
                          NTI=NTI+NINT((TMAX-TIMEL(NDT))/DELTAT(NDT))
                      ENDIF
                      NTIT=NTI
                      NTIF=NTI
                      GO TO 102
                   ENDIF
                ENDDO
                WRITE(*,9014)
 9014 FORMAT(5X,' Can not locate var. time step curve from XY series')
        call stopfile  ! emrl jig
                STOP  ' 9014'
            ENDIF
  102       CONTINUE
            IF (KSSF.EQ.0.AND.KMOD.EQ.10) THEN
                NTI=0
                NTIT=NTI
                NTIF=NTI
                TMAX=0.0D0
            ENDIF
            GO TO 1700
      ELSE
C
C ...     BAD CARD                                 (ILLEGAL CARD)
C
            WRITE(24,1665) IC1,IC3,(JREC(I),I=1,180)
 1665     FORMAT(1X,A2,A1,180A1)
            WRITE(24,1670)
 1670     FORMAT(' *** ERROR, ILLEGAL CARD TYPE ***')
        call stopfile  ! emrl jig
            STOP '1670'
      ENDIF
C
C ... READ ANOTHER CARD
C
      GO TO 40
    9 CONTINUE
C
CRAE  10-24-94   check if the END card has been read. if not, then
C                assume it is an oversight and process as if it had been
C
      IF (IEND.EQ.0)THEN
         WRITE(*,*)'  no END card was read in the bc file...'
         WRITE(*,*)'  ...will continue processing'
         IC1 = 'EN'
         GO TO 13
      ENDIF
C
C     Find the duplicate node and eliminate the node
C     Rainfall/evaporation-seepage B.C.
C
 1700 IF (NVESF.NE.0) THEN
          IF (NVESF.GT.MXRSCB) THEN
              WRITE(*,6001) NVESF,MXRSCB
 6001 FORMAT(5X,'NVESF=',I5,' > MXRSCB=',I5)
        call stopfile  ! emrl jig
              STOP '6001'
          ENDIF
          N=0
          DO I=1,NVESF
             J=NVTMPF(I)
             IK=NIK(J)
             ID=IDVF(I)
             DO K=1,4
                L=KGB(K,ID,IK)
                IF (L.NE.0) THEN
                   N=N+1
                   NI=IE(J,L)
                   KTEMP(N)=NI
                   ISVF(K,I)=NI
                ENDIF
             ENDDO
          ENDDO
          NALL=N
          IF (NALL.GT.KTMP) THEN
              WRITE(*,6011) NALL,KTMP
 6011 FORMAT(5X,' array of KTEMP',I6,' > KTMP=', I5)
        call stopfile  ! emrl jig
              STOP 'rinput'
          ENDIF
          CALL NELIM (KTMP,KTEMP,NALL,NPVBF,MXVNPH,NVNPF)
C
C     ASSIGN THE PONDING DEPTH AND MINI HEAD
C
         DO I=1,NVNPF
            RSVAB(I,1)=HCON
            RSVAB(I,2)=HMIN
         ENDDO
      ENDIF
C
      IF (NVEST.NE.0) THEN
          IF (NVEST.GT.MXRSCB) THEN
              WRITE(*,6002) NVEST,MXRSCB
 6002 FORMAT(5X,'NVEST=',I5,' > MXRSCB=',I5)
        call stopfile  ! emrl jig
              STOP '6002'
          ENDIF
          N=0
          DO I=1,NVEST
             J=NVTMPT(I)
             IK=NIK(J)
             ID=IDVT(I)
             DO K=1,4
                L=KGB(K,ID,IK)
                IF (L.NE.0) THEN
                   N=N+1
                   NI=IE(J,L)
                   KTEMP(N)=NI
                   ISVT(K,I)=NI
                ENDIF
             ENDDO
         ENDDO
         NALL=N
         IF (NALL.GT.KTMP) THEN
              WRITE(*,6011) NALL,KTMP
	       call stopfile  ! emrl jig
              STOP 'rinput'
         ENDIF
         CALL NELIM (KTMP,KTEMP,NALL,NPVBT,MXVNPC,NVNPT)
      ENDIF
C
C   SPECIFIED FLUX B.C.
C      CAUCHY FLUX
C
      IF (NCESF.GT.0) THEN
          IF (NCESF.GT.MXRSCB) THEN
              WRITE(*,6003) NCESF,MXRSCB
 6003 FORMAT(5X,'NCESF=',I5,' > MXRSCB=', I5)
        call stopfile  ! emrl jig
              STOP '6003'
          ENDIF
          N=0
          DO I=1,NCESF
             J=NCTMPF(I)
             IK=NIK(J)
             ID=IDCF(I)
             DO K=1,4
                L=KGB(K,ID,IK)
                IF (L.NE.0) THEN
                   N=N+1
                   NI=IE(J,L)
                   KTEMP(N)=NI
                   ISCF(K,I)=NI
                ENDIF
             ENDDO
          ENDDO
          NALL=N
          IF (NALL.GT.KTMP) THEN
              WRITE(*,6011) NALL,KTMP
	       call stopfile  ! emrl jig
              STOP 'rinput'
          ENDIF
          CALL NELIM (KTMP,KTEMP,NALL,NPCBF,MXCNPH,NCNPF)
      ENDIF
C
      IF (NCEST.GT.0) THEN
          IF (NCEST.GT.MXRSCB) THEN
              WRITE(*,6004) NCEST,MXRSCB
 6004 FORMAT(5X,'NCEST=',I5,' > MXRSCB=', I5)
        call stopfile  ! emrl jig
              STOP '6004'
          ENDIF
C
          N=0
          DO I=1,NCEST
             J=NCTMPT(I)
             IK=NIK(J)
             ID=IDCT(I)
             DO K=1,4
                L=KGB(K,ID,IK)
                IF (L.NE.0) THEN
                   N=N+1
                   NI=IE(J,L)
                   KTEMP(N)=NI
                   ISCT(K,I)=NI
                ENDIF
             ENDDO
          ENDDO
          NALL=N
          IF (NALL.GT.KTMP) THEN
              WRITE(*,6011) NALL,KTMP
	       call stopfile  ! emrl jig
              STOP 'rinput'
          ENDIF
          CALL NELIM (KTMP,KTEMP,NALL,NPCBT,MXCNPC,NCNPT)
      ENDIF
C
C-------      NEUMANN FLUX
C
      IF (NNESF.GT.0 ) THEN
           IF (NNESF.GT.MXRSCB) THEN
              WRITE(*,6005) NNESF,MXRSCB
 6005 FORMAT(5X,'NNESF=',I5,' > MXRSCB=', I5)
        call stopfile  ! emrl jig
              STOP '6005'
          ENDIF
C
          N=0
          DO I=1,NNESF
             J=NBTMPF(I)
             IK=NIK(J)
             ID=IDNF(I)
             DO K=1,4
                L=KGB(K,ID,IK)
                IF (L.NE.0) THEN
                   N=N+1
                   NI=IE(J,L)
                   KTEMP(N)=NI
                   ISNF(K,I)=NI
                ENDIF
             ENDDO
          ENDDO
          NALL=N
          IF (NALL.GT.KTMP) THEN
              WRITE(*,6011) NALL,KTMP
	       call stopfile  ! emrl jig
              STOP 'rinput'
          ENDIF
          CALL NELIM (KTMP,KTEMP,NALL,NPNBF,MXNNPH,NNNPF)
      ENDIF
C
      IF (NNEST.GT.0) THEN
           IF (NNEST.GT.MXRSCB) THEN
              WRITE(*,6006) NNEST,MXRSCB
 6006 FORMAT(5X,'NNEST=',I5,' > MXRSCB=', I5)
        call stopfile  ! emrl jig
              STOP '6006'
          ENDIF
C
          N=0
          DO I=1,NNEST
             J=NBTMPT(I)
             IK=NIK(J)
             ID=IDNT(I)
             DO K=1,4
                L=KGB(K,ID,IK)
                IF (L.NE.0) THEN
                   N=N+1
                   NI=IE(J,L)
                   KTEMP(N)=NI
                   ISNT(K,I)=NI
                ENDIF
             ENDDO
          ENDDO
          NALL=N
          IF (NALL.GT.KTMP) THEN
              WRITE(*,6011) NALL,KTMP
	       call stopfile  ! emrl jig
              STOP 'rinput'
          ENDIF
          CALL NELIM(KTMP,KTEMP,NALL,NPNBT,MXNNPC,NNNPT)
      ENDIF
C
C-------   River boundary
C
      IF (NRESF.GT.0 ) THEN
           IF (NRESF.GT.MXRSCB) THEN
              WRITE(*,6007) NRESF,MXRSCB
 6007 FORMAT(5X,'NRESF=',I5,' > MXRSCB=', I5)
        call stopfile  ! emrl jig
              STOP '6007'
          ENDIF
C
          N=0
          DO I=1,NRESF
             J=NRBEF(I)
             IK=NIK(J)
             ID=IDRF(I)
             DO K=1,4
                L=KGB(K,ID,IK)
                IF (L.NE.0) THEN
                   N=N+1
                   NI=IE(J,L)
                   ISRF(K,I)=NI
                ENDIF
             ENDDO
          ENDDO
      ENDIF
C
C    PUT PRESSURE HEAD MOISTURE, CONDUCTIVITY AND WAPER CAPACITY IN THE RIGHT FORM
C
      DO 200 I=1,NUNSAT
         MTYP = NSP(I)
C
C     Pressure head vs. moisture content
C
         DO L=1,NTXY
            IF (IHM(I).EQ.NXY(L)) GO TO 211
         ENDDO
         WRITE(*,6008) I,IHM(I)
 6008 FORMAT('Cannot find soil index number for H vs MC;',I2,5X,I2)
        call stopfile  ! emrl jig
         STOP 'HvsMC'
  211 CONTINUE
         NPMC(I)=NPOINT(L)
         IF (NPMC(I).GT.MXSPMK) THEN
            WRITE(*,6012)
 6012 FORMAT(5X,'NPMC(I): > MXSPMK, STOP')
        call stopfile  ! emrl jig
             STOP 'RINPUT'
         ENDIF
c
c         Put the data in ascending order.
c
         NN = NPOINT(L)
         TEST = TS(NN, L) - TS(1, L)
         DO J=1,NN
            IF (TEST .GE. 0.0D0) THEN
              JJ = J
            ELSE
              JJ = NN - J + 1
            END IF
            PH(J,MTYP) = TS(JJ,L)
            PMC(J,MTYP) = TVALUE(JJ,L)
         ENDDO
c
c         Compute the B spline coefficients.
c
         IF (IBSPL .EQ. 1) THEN
           CALL BSKNOT (PH(1, MTYP), PMKNOT(1, MTYP), NN)
           CALL BSCOEF (PH(1, MTYP), PMC(1, MTYP), NN, PMKNOT(1, MTYP),
     &       PMCOEF(1, MTYP))
          END IF
C
C     Pressure head vs. conductivity
C
         DO L=1,NTXY
            IF (IHC(I).EQ.NXY(L)) GO TO 221
         ENDDO
           WRITE(*,6009) I,IHC(I)
 6009 FORMAT('Cannot find soil index no. for H vs Conduc;',I2,5X,I2)
        call stopfile  ! emrl jig
         STOP 'HvsKR'
  221    CONTINUE
         NPCON(I)=NPOINT(L)
         IF (NPCON(I).GT.MXSPMK) THEN
            WRITE(*,6013) NPCON(I)
 6013 FORMAT(5X,'NPCON(I): > MXSPMK, STOP')
        call stopfile  ! emrl jig
            STOP 'RINPUT'
         ENDIF
c
c         Put the data in ascending order.
c
         NN = NPOINT(L)
         TEST = TS(NN, L) - TS(1, L)
         DO J=1,NN
            IF (TEST .GE. 0.0D0) THEN
              JJ = J
            ELSE
              JJ = NN - J + 1
            END IF
            PCON(J,MTYP) = TS(JJ,L)
            CONDUC(J,MTYP) = TVALUE(JJ,L)
         ENDDO
c
c         Compute the B spline coefficients.
c
         IF (IBSPL .EQ. 1) THEN
           CALL BSKNOT (PCON(1, MTYP), PCKNOT(1, MTYP), NN)
           CALL BSCOEF (PCON(1, MTYP), CONDUC(1, MTYP), NN, PCKNOT(1,
     &       MTYP), PCCOEF(1, MTYP))
         END IF
C
C     Pressure head vs. water capacity
C
         DO L=1,NTXY
            IF (IHW(I).EQ.NXY(L)) GO TO 231
         ENDDO
         WRITE(*,6010) I,IHW(I)
 6010 FORMAT('Cannot find soil index number for H vs WC;',I2,5X,I2)
         STOP 'HvsWC'
  231    CONTINUE
         NPWC(I)=NPOINT(L)
         IF (NPWC(I).GT.MXSPMK) THEN
            WRITE(*,6014) NPWC(I)
 6014 FORMAT(5X,'NPWC(I): > MXSPMK, STOP')
        call stopfile  ! emrl jig
            STOP 'RINPUT'
         ENDIF
c
c         Put the data in ascending order.
c
         NN = NPOINT(L)
         TEST = TS(NN, L) - TS(1, L)
         DO J=1,NN
            IF (TEST .GE. 0.0D0) THEN
              JJ = J
            ELSE
              JJ = NN - J + 1
            END IF
            PWC(J,MTYP) = TS(JJ,L)
            WC(J,MTYP) = TVALUE(JJ,L)
         ENDDO
c
c         Compute the B spline coefficients.
c
         IF (IBSPL .EQ. 1) THEN
           CALL BSKNOT (PWC(1, MTYP), PWKNOT(1, MTYP), NN)
           CALL BSCOEF (PWC(1, MTYP), WC(1, MTYP), NN, PWKNOT(1,
     &       MTYP), PWCOEF(1, MTYP))
         END IF
C
  200 CONTINUE
C
C ----- set up print counter
C
      IF (NNP.GT.20000. OR. NPITERF.GT.5000 ) THEN
          LIPC=200
      ELSEIF (NNP.GT.10000.OR. NPITERF.GT.1000) THEN
          LIPC=100
      ELSE
          LIPC=50
      ENDIF
C
C    CHECK PS2 IF KMOD=11
C
      IF (KMOD.EQ.11) THEN
         IF (NC11.EQ.0.AND. NC1.NE.0) THEN
            WRITE(*,6016)
 6016 FORMAT('  Missing PS2 card,')
        call stopfile  ! emrl jig
            STOP 'rinput'
         ENDIF
      ENDIF
      CLOSE(24,STATUS='DELETE')
      RETURN
      END
C
      SUBROUTINE TSCONV (N4,ITYPE,N5,NTXY,NXY,MXXYS,NTY,NTYPE)
C
      DIMENSION ITYPE(N5),NXY(MXXYS),NTY(MXXYS)
C
      K=0
      DO 100 J=1,NTXY
         DO I=1,N4
            IF (NXY(J).EQ.ITYPE(I)) THEN
               K=K+1
               NTY(K)=J
               GO TO 100
            ENDIF
            IF (I.EQ.N4.AND.J.EQ.NTXY) GO TO 101
         ENDDO
  100 CONTINUE
  101 NTYPE=K
      IF (NTYPE.GT.MXXYS) THEN
         WRITE(*,1001) NTYPE
 1001 FORMAT(5X,'array of NTY > MXXYS, stop')
        call stopfile  ! emrl jig
         STOP 'TSCONV'
      ENDIF
      IF (K.EQ.0) THEN
          WRITE(*,1002)
 1002 FORMAT(5X,' Can not locate the bc curve in XY-series card')
        call stopfile  ! emrl jig
         STOP 'TSCONV'
      ENDIF
      RETURN
      END
C
      SUBROUTINE CRACKI (I1,NWD,KNT,TYPE)
C
      CHARACTER*1  IBLANK,ICOMMA
      COMMON /CARD/ JREC
      DIMENSION KNT(NWD)
      CHARACTER JREC(180)*1,TYPE*9,IBUF*77,IFOR(1)*10
C
      DATA IBLANK /' '/
      DATA ICOMMA /','/
C-
C ... LOOP FOR EACH WORD TO BE READ
C
      IF(I1.GT.180) RETURN
      NWD1=NWD
      DO 900 I=1,NWD1
C
C ... FIND START OF DATA (FIRST NON-BLANK CHARACTER)
C
   10 CONTINUE
      IF(JREC(I1).NE.IBLANK.AND.JREC(I1).NE.ICOMMA) GO TO 15
      I1=I1+1
      IF (JREC(I1).EQ.ICOMMA) THEN
          I1=I1+1
          GO TO 900
      ENDIF
      IF(I1.GE.180) THEN
          NWD=I-1
          RETURN
      ENDIF
      GO TO 10
   15 CONTINUE
C
C  FIND END OF DATA
C
      I2=I1+1
   20 CONTINUE
      IF (JREC(I1).EQ.'''') THEN
           IF( JREC(I2).EQ.'''') GO TO 25
      ELSE
           IF (JREC(I2).EQ.IBLANK.OR.JREC(I2).EQ.ICOMMA) GO TO 25
      ENDIF
      I2=I2+1
      IF (I2.LT.181) GO TO 20
      I2=180
   25 CONTINUE
      IF (JREC(I1).EQ.'''') I1=I1+1
      LENGTH=I2-I1
      IF (LENGTH.LT.1) LENGTH=1
      I2=I2-1
C
C ... PACK DATA INTO BUFFER
C
      WRITE (IBUF,30) (JREC(J),J=I1,I2)
   30 FORMAT(180A1)
C
C ... SET UP CORRECT FORMAT AND READ DATA
C
      IF (TYPE(1:7).EQ.'INTEGER') THEN
          WRITE(IFOR,40) LENGTH
   40     FORMAT('(I',I2,')')
          READ(IBUF,IFOR) KNT(I)
      ELSE
          WRITE(24,50) TYPE
   50     FORMAT(' *** ERROR, ',A10,' IS ILLEGAL IN CALL TO CRACK ***')
CRAE 10-25-94          IERR=IERR+1
          RETURN
      ENDIF
      IF (JREC(I2+1).EQ.'''') I2=I2+1
      I1=I2+1
  900 CONTINUE
      RETURN
      END
      SUBROUTINE CRACKD (I1,NWD,REA,TYPE)
C
      CHARACTER*1  IBLANK,ICOMMA
      COMMON /CARD/ JREC
      REAL*8 REA(NWD)
      CHARACTER JREC(180)*1,TYPE*9,IBUF*77,IFOR(1)*10
C
      DATA IBLANK /' '/
      DATA ICOMMA /','/
C-
C ... LOOP FOR EACH WORD TO BE READ
C
      IF (I1.GT.180) RETURN
      NWD1=NWD
      DO 900 I=1,NWD1
C
C ... FIND START OF DATA (FIRST NON-BLANK CHARACTER)
C
   10 CONTINUE
      IF (JREC(I1).NE.IBLANK.AND.JREC(I1).NE.ICOMMA) GO TO 15
      I1=I1+1
      IF (JREC(I1).EQ.ICOMMA) THEN
          I1=I1+1
          GO TO 900
      ENDIF
      IF (I1.GE.180) THEN
          NWD=I-1
          RETURN
      ENDIF
      GO TO 10
   15 CONTINUE
C
C  FIND END OF DATA
C
      I2=I1+1
   20 CONTINUE
      IF (JREC(I1).EQ.'''') THEN
          IF(JREC(I2).EQ.'''') GO TO 25
      ELSE
          IF(JREC(I2).EQ.IBLANK.OR.JREC(I2).EQ.ICOMMA) GO TO 25
      ENDIF
      I2=I2+1
      IF (I2.LT.181) GO TO 20
      I2=180
   25 CONTINUE
      IF (JREC(I1).EQ.'''') I1=I1+1
      LENGTH=I2-I1
      IF (LENGTH.LT.1) LENGTH=1
      I2=I2-1
C
C ... PACK DATA INTO BUFFER
C
      WRITE (IBUF,30) (JREC(J),J=I1,I2)
   30 FORMAT(180A1)
C
C ... SET UP CORRECT FORMAT AND READ DATA
C
      IF(TYPE(1:4).EQ.'REAL') THEN
          WRITE(IFOR,35) LENGTH
   35     FORMAT('(F',I2,'.0)')
          READ(IBUF,IFOR) REA(I)
      ELSE
          WRITE(24,50) TYPE
   50     FORMAT(' *** ERROR, ',A10,' IS ILLEGAL IN CALL TO CRACK ***')
CRAE 10-25-94          IERR=IERR+1
          RETURN
      ENDIF
      IF (JREC(I2+1).EQ.'''') I2=I2+1
      I1=I2+1
  900 CONTINUE
      RETURN
      END
C
      SUBROUTINE LINEAR(PR,TPRF,PRF,T,MXPR,MXDP,NPR,NDP)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      DIMENSION PR(MXPR),TPRF(MXDP,MXPR),PRF(MXDP,MXPR)
      DIMENSION NDP(MXPR)
C
C ------- THE PROFILE VALUE IS OBTAINED BY INTERPOLATION OF THE INPUT
C ------- TABULAR VALUES
C
      DO 160 I=1,NPR
         NK=NDP(I)
         IF (NDP(I).EQ.1) THEN
            PR(I)=PRF(1,I)
            GO TO 160
         ENDIF
C
         DO 140 J=2,NK
            IF(TPRF(J-1,I).LE.T .AND. T.LE.TPRF(J,I)) GO TO 120
            GO TO 140
  120       RFJM1=PRF(J-1,I)
            TRFJM1=TPRF(J-1,I)
            RFJ=PRF(J,I)
            TRFJ=TPRF(J,I)
            ABC=RFJ-RFJM1
            ABCD=TRFJ-TRFJM1
            PR(I)=RFJM1+(T-TRFJM1)*ABC/ABCD
            GO TO 160
  140    CONTINUE
         IF (T.LT.TPRF(1,I)) THEN
            PR(I)=PRF(1,I)
         ELSEIF (T.GT.TPRF(NK,I)) THEN
            PR(I)=PRF(NK,I)
         ENDIF
  160 CONTINUE
      RETURN
      END
C
      SUBROUTINE NELIM(NK,ND,NT,NW,NF,NTOTAL)
C
      DIMENSION ND(NK),NW(NF)
C
      N=NT-1
      DO I=1,N
          J1=I+1
          DO J=J1,NT
             IF (ND(I).EQ.ND(J)) ND(J)=0
          ENDDO
      ENDDO
C
      K=0
      DO 100 I=1,NT
         IF (ND(I).EQ.0) GO TO 100
         K=K+1
         NW(K)=ND(I)
  100 CONTINUE
      NTOTAL=K
      RETURN
      END
C
      SUBROUTINE CFACE(NELM,IDFACE,IDF,NC,NZZ)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
      COMMON /EFACE/ IFACE6(6),IFACE5(5),IFACE4(4)
C
      DIMENSION IDF(NZZ)
C
      IF (NFACE(NELM).EQ.6) THEN
          DO I=1,6
             IF (IDFACE.EQ.IFACE6(I)) THEN
                IDF(NC)=I
                GO TO 111
             ENDIF
          ENDDO
  111     CONTINUE
      ELSEIF (NFACE(NELM).EQ.5) THEN
          DO I=1,5
             IF (IDFACE.EQ.IFACE5(I)) THEN
                IDF(NC)=I
                GO TO 112
             ENDIF
          ENDDO
  112     CONTINUE
      ELSEIF (NFACE(NELM).EQ.4) THEN
          DO I=1,4
             IF (IDFACE.EQ.IFACE4(I)) THEN
                IDF(NC)=I
                GO TO 113
             ENDIF
          ENDDO
  113     CONTINUE
      ELSE
          WRITE(*,1001)
 1001 FORMAT(5X,' Element face number did not match, stop')
        call stopfile  ! emrl jig
          STOP 'CFACE'
      ENDIF
      RETURN
      END
C
      BLOCK DATA
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      COMMON /BLK1/ KGB(4,6,3)
      COMMON /BLK2/ S(8),T(8),U(8)
      COMMON /BLK3/ C00,C10,C20
      COMMON /Q34WG/ WG(3)
      COMMON /EFACE/ IFACE6(6),IFACE5(5),IFACE4(4)
      COMMON /ICCARD/ JICH,JICV,JICC,JICM,JIBF,JIBT,
     1               JPH,JCN,JVL,JMN,JMC,JBF,JBT
      COMMON /FTFILE/ KPH,KCN,KVL,KMC,KBF,KBT,JFILE,KFILE
C
      DATA IFACE6/6,3,4,5,1,2/
      DATA IFACE5/5,3,4,1,2/
      DATA IFACE4/1,2,3,4/
C
      DATA KGB/1,4,8,5, 1,2,6,5, 2,3,7,6, 4,3,7,8, 1,2,3,4, 5,6,7,8,
     >         1,3,6,4, 1,4,5,2, 2,5,6,3, 1,2,3,0, 4,5,6,0, 0,0,0,0,
     >         4,3,2,0, 4,1,3,0, 4,2,1,0, 1,2,3,0, 0,0,0,0, 0,0,0,0/
C
      DATA S/-1.0D0,1.0D0,1.0D0,-1.0D0,-1.0D0,1.0D0,1.0D0,-1.0D0/
      DATA T/-1.0D0,-1.0D0,1.0D0,1.0D0,-1.0D0,-1.0D0,1.0D0,1.0D0/
      DATA U/-1.0D0,-1.0D0,-1.0D0,-1.0D0,1.0D0,1.0D0,1.0D0,1.0D0/
      DATA C00,C10,C20/-0.468750D0,1.68750D0,-2.250D0/
      DATA WG/0.333333333333333D0, 0.333333333333333D0,
     1        0.333333333333333D0/
C
      DATA JPH,JCN,JVL,JMN,JMC,JBF,JBT /0,0,0,0,0,0,0/
      DATA KPH,KCN,KVL,KMC,KBF,KBT,JFILE,KFILE /0,0,0,0,0,0,0,0/
      END
C
      SUBROUTINE HYDRO (X,IE,C,NPCNV,INDRS,
     1                 IPRT,JTM,IBUG,ICHNG,KMOD,SQEPS)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /TSTEP/ NTI,NTIF,NTIT
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /FINTE/ NCYLF,NITERF,NPITERF,KSP,KGRAV,IPNTSF
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /PCG/ GG,IEIGEN
      COMMON /RAIN/ IRAIN
C
      COMMON /FPS/ NWNPF,NWPRF,NWDPF(MXWPRH)
      COMMON /BLKPSF/ WSSF(MXWPRH),WSSFF(MXWDPH,MXWPRH),
     1               TWSSFF(MXWDPH,MXWPRH),IWTYPF(MXWNPH),
     2               NPWF(MXWNPH),JWTYPF(MXWNPH)
      COMMON /TPS/ NWNPT,NWPRT,NWDPT(MXWPRC)
      COMMON /BLKPST/ WSST(MXWPRC),WSSFT(MXWDPC,MXWPRC),
     1               TWSSFT(MXWDPC,MXWPRC),IWTYPT(MXWNPC),
     2               NPWT(MXWNPC),JWTYPT(MXWNPC)
C
      COMMON /FDBC/ NDNPF,NDPRF,NDDPF(MXDPRH)
      COMMON /FCBC/ NCESF,NCNPF,NCPRF,NCDPF(MXCPRH)
      COMMON /FVBC/ NVESF,NVNPF,NVPRF,NVDPF(MXVPRH)
      COMMON /FNBC/ NNESF,NNNPF,NNPRF,NNDPF(MXNPRH)
      COMMON /FRBC/ NRESF,NRNPF,NRPRF,NRDPF(MXRPRH),NRMAF
C
      COMMON /BLKDBF/ HDBF(MXDPRH),HDBFF(MXDDPH,MXDPRH),
     1        THDBFF(MXDDPH,MXDPRH),IDTYPF(MXDNPH),NPDBF(MXDNPH),
     2        JDTYPF(MXDNPH)
      COMMON /BLKVBF/ QVBF(MXVPRH),QVBFF(MXVDPH,MXVPRH),
     1        TQVBFF(MXVDPH,MXVPRH),IVTYPF(MXVESH),ISVF(5,MXVESH),
     2        NPVBF(MXVNPH),IDVF(MXVESH),JVTYPF(MXVESH)
      COMMON /BLKCBF/ QCBF(MXCPRH),QCBFF(MXCDPH,MXCPRH),
     1        TQCBFF(MXCDPH,MXCPRH),ICTYPF(MXCESH),ISCF(5,MXCESH),
     2        NPCBF(MXCNPH),IDCF(MXCESH),JCTYPF(MXCESH)
      COMMON /BLKNBF/ QNBF(MXNPRH),QNBFF(MXNDPH,MXNPRH),
     1        TQNBFF(MXNDPH,MXNPRH),INTYPF(MXNESH),ISNF(5,MXNESH),
     2        NPNBF(MXNNPH),IDNF(MXNESH),JNTYPF(MXNESH)
      COMMON /BLKRBF/ HRBF(MXRPRH),HRBFF(MXRDPH,MXRPRH),
     1        THRBFF(MXRDPH,MXRPRH),IRTYPF(MXRNPH),NPRBF(MXRNPH),
     2        ISRF(6,MXRESH),PRORF(2,MXRESH),IDRF(MXRESH),NRBEF(MXRESH),
     3        IRMTYP(MXRMAH),JRTYPF(MXRNPH)
      COMMON /BLKDBT/ CDBT(MXDPRC),CDBFT(MXDDPC,MXDPRC),
     1        TCDBFT(MXDDPC,MXDPRC),IDTYPT(MXDNPC),
     2        NPDBT(MXDNPC),JDTYPT(MXDNPC)
C
      COMMON /FFLOW/ FRATEF(11),FLOWF(11),TFLOWF(11)
      COMMON /TCCARD/ IUNIT,JOPT,KOPT,IFILE,NPRINT,NPOST,
     1                ICFILE,IVFILE,PTIMES(MXPOST),POTIME(MXPOST)
      COMMON /UNSAT/ PH(MXSPMK,MXMATK),PMC(MXSPMK,MXMATK),
     1               PCON(MXSPMK,MXMATK),CONDUC(MXSPMK,MXMATK),
     2               PWC(MXSPMK,MXMATK),WC(MXSPMK,MXMATK),
     &               PMKNOT(MXSPMK + 4, MXMATK), PCKNOT(MXSPMK + 4,
     &               MXMATK), PWKNOT(MXSPMK + 4, MXMATK),
     &               PMCOEF(MXSPMK, MXMATK), PCCOEF(MXSPMK, MXMATK),
     &               PWCOEF(MXSPMK, MXMATK), IBSPL
      COMMON /BLK4/ OMEF1,OMET1,OMEFT1
C
      COMMON /BUCK/ BUCKET(10), HSAVE(MAXNPK), IBUCKET
C
C ------- ARRAYS FOR BOTH FLOW AND TRANSPORT
C
      COMMON /BLKFT1/LRN(MXJBDK,MAXNPK),LRL(MXKBDK,MAXNPK),NLRL(MAXNPK),
     1               ND(MAXNPK),NT(MAXNPK)
      COMMON /BLKFT2/ CMATRX(MXJBDK,MAXNPK),RI(MAXNPK),RL(MAXNPK),
     1                RLD(MAXNPK),SK(MAXNPK),RK(MAXNPK),PK(MAXNPK)
      COMMON /BLKFT3/ DCOSB(3,MXBESK),ISB(6,MXBESK),NPBB(MXBNPK),
     1                IB(MAXNPK)
C
      DIMENSION X(MAXNPK,3),IE(MAXELK,9)
C
C ------ ARRAYS FOR FLOW ONLY
C
      COMMON /BLKFL1/ H(MAXNPK),HP(MAXNPK),HW(MAXNPK),HT(MAXNPK)
      COMMON /BLKFL2/ V(MAXNPK,3),TH(8,MAXELK),DTH(8,MAXELK),
     1                AKHC(7,8,MAXELK)
      COMMON /BLKFL3/ BFLXF(MXBNPK,2),RSVAB(MXVNPH,4),PROPF(9,MXMATK),
     1                RHOMU(MXRMPK)
      COMMON /BLKFL4/ IDRY
C
      DIMENSION NPCNV(MAXNPK),INDRS(MXVNPH,3),C(MAXNPK)
C
      W1=WF
      W2=1.0D0-WF
      IF (KSSF.EQ.0) THEN
         W1=1.0D0
         W2=0.0D0
      END IF
      IF (KSSF.NE.0) GO TO 500
C
C $$$$$$$ Perform steady-state calculation
C
      IF (NVESF.EQ.0 .OR. IRAIN.EQ.0) GO TO 170
      DO NPP=1,NVNPF
         NI=NPVBF(NPP)
         INDRS(NPP,1)=NPBB(NI)
         INDRS(NPP,2)=0
         INDRS(NPP,3)=0
      ENDDO
      NCHG=-1
C
      CALL BCPREP
     > (IE, H,V,DCOSB,ISB,ISVF,RSVAB,INDRS,JVTYPF,QVBF,NCHG)
C
C ----- Iteration loop on seepage-rainfall boundary conditions begins
C
  170 CONTINUE
C
      EPS = 0.1D0 * TOLAF
      OMESAV = OMEF
      NNCVN=0
C
      DO NP=1,NNP
         HW(NP)=H(NP)
         RI(NP)=H(NP)
      ENDDO
C
      DO 390 ICY=1,NCYLF
C
C ------- Put dirichlet boundary values of the variable boundary
C ------- into H, RI, HW, AND RL
C
         OMEF = OMESAV
C
         IF (NVESF.EQ.0 .OR. IRAIN.EQ.0) GO TO 250
         DO 230 NPP=1,NVNPF
            NI=INDRS(NPP,2)
            IF (NI.EQ.0) GO TO 220
            H(NI) =RSVAB(NPP,2)
            RI(NI)=RSVAB(NPP,2)
            HW(NI)=RSVAB(NPP,2)
            GO TO 230
  220       NI=INDRS(NPP,1)
            IF (NI.EQ.0) GO TO 230
            H(NI)=RSVAB(NPP,1)
            RI(NI)=RSVAB(NPP,1)
            HW(NI)=RSVAB(NPP,1)
  230    CONTINUE
  250    CONTINUE
C
C ******* Iteration loop on the non-linear equation begins
C
C         Add dynamic change of OMEF.
C
         RESOLD = 0.D0
C
         DO 350 IT=1,NITERF
C
C ------- Evaluate soil properties for previous iterate
C
            CALL SPROP(AKHC,DTH,HW,C,IE,PROPF,RHOMU)
C
C ------- Assemble stead-state element matrices qa and qb into the
C ------- global matrix c and construct global load vector r from
C ------- element load vector RQ.
C
            CALL FASEMB (CMATRX,RLD,IE,LRN,C,KMOD)
C
C ------- Apply steady-state boundary conditions
C
            CALL FBC (CMATRX,RLD,LRN,IE,X,AKHC,DCOSB,ISB,
     1                RSVAB,INDRS,RHOMU,HP,KMOD)
C
C ------- Solve the matrix equation by point iteration
C
            IPRT=0
            ID=1
            IF (IPNTSF.EQ.1) THEN
                CALL PWISS (CMATRX,RLD,
     I          LRN,OMIF,EPS,NPITERF,ID,MAXNPK,MXJBDK,
     I          NT,ND,
     M          RI,
     O          RL)
            ELSE IF (IPNTSF.EQ.2) THEN
                CALL CG (1, NPITERF, OMIF, EPS, NNP, MAXNPK, MXJBDK,
     &          CMATRX, RLD, LRN, NT, ND, PK, SK, RK, RI, RL)
            ELSE IF (IPNTSF.EQ.3) THEN
                CALL CG (2, NPITERF, OMIF, EPS, NNP, MAXNPK, MXJBDK,
     &          CMATRX, RLD, LRN, NT, ND, PK, SK, RK, RI, RL)
            END IF
C
C ------- Obtain maximum relative deviation from previous iterate
C
            NPP=0
            RD=-1.0D0
            RES=-1.0D0
            DO 320 NP=1,NNP
               RESNP=DABS(RL(NP)-H(NP))
               RES=DMAX1(RES,RESNP)
               IF (RESNP .LE. TOLAF) GO TO 320
               NPP=NPP+1
               NPCNV(NPP)=NP
  320       CONTINUE
            NNCVN=NPP
C
C ------- Update pressure with current iterate
C
            DO NP=1,NNP
               H(NP)=OMEF*RL(NP)+ OMEF1*H(NP)
               RI(NP)=H(NP)
               HW(NP)=H(NP)
            ENDDO
C
C         Add dynamic change of OMEF.
C
            IF (RES .LT. RESOLD) THEN
              OMEF = OMEF + OMEADD
              IF (OMEF .GT. OMEMAX) OMEF = OMEMAX
            ELSE IF (IT .GT. 1) THEN
              OMEF = OMEF * OMERED
              IF (OMEF .LT. OMEMIN) OMEF = OMEMIN
            END IF
            OMEF1 = 1.D0 - OMEF
            RESOLD = RES
C
C ------- Escape from iteration loop if the maximum residual is
C ------- sufficiently small
C
            IF (KMOD.EQ.10) THEN
               WRITE(*,1201) IT, RES, NNCVN
               WRITE(*,5428) OMEF
 5428 FORMAT(3X,'Current Relaxation Parameter =',F10.6,/)
            ENDIF
C
            IF (RES.LT.TOLAF) GO TO 360
            IF (RES.GT.1.0D38) GO TO 355
  350    CONTINUE
C
C ------- END OF ITERATION LOOP ON THE NON-LINEAR EQUATION
C
  355    WRITE(16,2000) ICY,IT,NITERF,RES,RD,NNCVN
C
C ------- PRINT NONCONVERGENING NODES
C
         IF (IBUG.EQ.1) THEN
             WRITE(16,1450)
             WRITE(16,1460) (NPCNV(NPP),NPP=1,NNCVN)
         ENDIF
  360    IF (ICHNG.EQ.0.OR.NVESF.EQ.0.OR.IRAIN.EQ.0) GO TO 370
C
C ------- PRINT RAINFALL-SEEPAGE B. C. CHANGE INFORMATION
C
         WRITE(16,1420) ICY
         DO I=1,NVNPF
            NI=NPVBF(I)
            NP=NPBB(NI)
            WRITE(16,1430) I,NP,INDRS(I,1),RSVAB(I,1),INDRS(I,2),
     1              RSVAB(I,2),INDRS(I,3),RSVAB(I,3),RSVAB(I,4)
         ENDDO
C
C ----- Check if wells are dry
C
  370    IF (NWNPF.NE.0) THEN
             DO I=1,NWNPF
                IW=NPWF(I)
                WELLPH=H(IW)
                IF (WELLPH.LT.0.0D0) THEN
                    IDRY=1
                    WRITE(*,8001) IW, WELLPH
 8001 FORMAT(5X,'WARNING: Well at node=',I6,' is dry, ph=',E12.6)
                 ENDIF
             ENDDO
         ENDIF
  380    CONTINUE
C
C ----- Compute dth/dh and kr
C
         CALL SPROP(AKHC,DTH,H,C,IE,PROPF,RHOMU)
C
C ------- Calculate Darcy's velocity
C
         CALL VELT (V,IE,H, AKHC)
C
         IF (NVESF.EQ.0 .OR. IRAIN.EQ.0 ) THEN
            IF (NNCVN.EQ.0) RETURN
         ENDIF
C
C ------- Prepare boundary conditions on the variable-type boundary for
C ------- next cycle computations.
C
         CALL BCPREP(IE,H,V,DCOSB,ISB,ISVF,RSVAB,INDRS,JVTYPF,
     1             QVBF,NCHG)
         DO I=1,NVNPF
            NI=NPVBF(I)
            NP=NPBB(NI)
            WRITE(26,1430) I,NP,INDRS(I,1),RSVAB(I,1),INDRS(I,2),
     1              RSVAB(I,2),INDRS(I,3),RSVAB(I,3),RSVAB(I,4)
         ENDDO
         IF(NCHG.EQ.0) GO TO 440
  390 CONTINUE
C
C ------- End of iteration loop on seepage-rainfall boundary conditions
C
  440 IF (NNCVN.EQ.0) GO TO 445
      WRITE(16,3000) ICY,IT,NCYLF,NITERF,RES,RD,NNCVN
C
C ------- Compute fluxes through all types of boundaries.
C
  445 CONTINUE
      OMEF = OMESAV
      OMEF1 = 1.D0 - OMEF
      RETURN
C
C $$$$$$$ PERFORM TRANSIENT-STATE CALCULATION
C
  500 CONTINUE
      IF (NVESF.EQ.0 .OR. IRAIN.EQ.0) GO TO 560
      NCHG=-1
C
      CALL BCPREP
     >  (IE, H,V,DCOSB,ISB,ISVF,RSVAB,INDRS,JVTYPF,QVBF,NCHG)
C
  560 EPS = 0.1D0 * TOLBF
C
C ------- Begin iteration loop on seepage-rainfall boundary conditions
C
      NNCVN=0
      OMESAV = OMEF
C
      DO NP=1,NNP
         HW(NP)=W1*H(NP) + W2*HP(NP)
         RI(NP)=H(NP)
      ENDDO
C
      DO 690 ICY=1,NCYLF
C
C ------- PUT DIRICHLET BOUNDARY VALUES OF THE VARIABLE BOUNDARY
C ------- INTO H, RI, HW, AND RL
C
         OMEF = OMESAV
C
         IF (NVESF.EQ.0 .OR. IRAIN.EQ.0) GO TO 595
         DO 590 NPP=1,NVNPF
            NI=INDRS(NPP,2)
            IF (NI.EQ.0) GO TO 585
            H(NI)=RSVAB(NPP,2)
            RI(NI)=RSVAB(NPP,2)
            HW(NI)=RSVAB(NPP,2)
            GO TO 590
  585       NI=INDRS(NPP,1)
            IF (NI.EQ.0) GO TO 590
            H(NI)=RSVAB(NPP,1)
            RI(NI)=RSVAB(NPP,1)
            HW(NI)=RSVAB(NPP,1)
  590    CONTINUE
  595    CONTINUE
C
c         Modify H and HW for standard Dirichlet BC's, too.
C
         IF (NDNPF .NE. 0) THEN
           IF (KMOD .EQ. 11) THEN
             DO I = 1, NDNPF
               NP = NPDBF(I)
               ITYP = JDTYPF(I)
               CC = C(NP)
               RO = RHOMU(1) + CC * (RHOMU(2) + CC * RHOMU(3) +
     &           CC * CC * RHOMU(4))
               H(NP) =(HDBF(ITYP) - X(NP, 3) * DBLE (KGRAV)) * RO
               RI(NP) = H(NP)
               HW(NP) = H(NP)
             END DO
           ELSE IF (KMOD .EQ. 10) THEN
             DO I = 1, NDNPF
               NP = NPDBF(I)
               ITYP = JDTYPF(I)
               H(NP) = HDBF(ITYP) - X(NP, 3) * DBLE (KGRAV)
               RI(NP) = H(NP)
               HW(NP) = H(NP)
             ENDDO
           ENDIF
         ENDIF
C
C ******* Begin iteration loop on the non-linear equation
C
C      Add dynamic change of time step to aid convergence.
C
      IBUCK = 0
      DELTS = DELT
      DO N = 1, NNP
        HSAVE(N) = H(N)
      END DO
C
C         Add dynamic change of OMEF.
C
   10    RESOLD = 0.D0
C
         DO 650 IT=1,NITERF
C
C ------- Evaluate soil properties for previous iterate
C
            CALL SPROP(AKHC,DTH,HW,C,IE, PROPF,RHOMU)
C
C ------- ASSEMBLE ELEMENT MATRICES QA AND QB INTO THE GLOBAL MATRIX C
C ------- AND CONSTRUCT THE GLOBAL LOAD VECTOR R FROM ELEMENT LOAD
C ------- VECTOR RQ.
C
            CALL FASEMB (CMATRX,RLD,IE,LRN,C,KMOD)
C
C ------- APPLY BOUNDARY CONDITIONS TO MODIFY THE GLOBAL MATRIX C AND
C ------- THE LOAD VECTOR R.
C
            CALL FBC (CMATRX,RLD,LRN,IE,X,AKHC,DCOSB,ISB,
     1                RSVAB,INDRS,RHOMU,HP,KMOD)
C
C ------- Solve the matrix equaiton by point iteration
C
            ID=1
            IF (IPNTSF.EQ.1) THEN
                CALL PWISS (CMATRX, RLD,
     I          LRN,OMIF,EPS,NPITERF,ID,MAXNPK,MXJBDK,
     I          NT, ND,
     M          RI,
     O          RL)
            ELSE IF (IPNTSF.EQ.2) THEN
                CALL CG (1, NPITERF, OMIF, EPS, NNP, MAXNPK, MXJBDK,
     &          CMATRX, RLD, LRN, NT, ND, PK, SK, RK, RI, RL)
            ELSE IF (IPNTSF.EQ.3) THEN
                CALL CG (2, NPITERF, OMIF, EPS, NNP, MAXNPK, MXJBDK,
     &          CMATRX, RLD, LRN, NT, ND, PK, SK, RK, RI, RL)
            END IF
C
C ------- Obtain maximum relative deviation from previous iterate
C
            NPP=0
            RD=-1.0D0
            RES=-1.0D0
            DO 620 NP=1,NNP
               RESNP=DABS(RL(NP)-H(NP))
               RES=DMAX1(RES,RESNP)
               IF (RESNP .LE. TOLBF) GO TO 620
               NPP=NPP+1
               NPCNV(NPP)=NP
  620       CONTINUE
            NNCVN=NPP
C
C ------- Update pressure with current iterate
C
            DO NP=1,NNP
               H(NP)=OMEF*RL(NP)+ OMEF1*H(NP)
               RI(NP)=H(NP)
               HW(NP)=W1*H(NP)+W2*HP(NP)
            ENDDO
C
C         Add dynamic change of OMEF.
C
            IF (RES .LT. RESOLD) THEN
              OMEF = OMEF + OMEADD
              IF (OMEF .GT. OMEMAX) OMEF = OMEMAX
            ELSE IF (IT .GT. 1) THEN
              OMEF = OMEF * OMERED
              IF (OMEF .LT. OMEMIN) OMEF = OMEMIN
            END IF
            OMEF1 = 1.D0 - OMEF
            RESOLD = RES
C
C ------- Escape from iteration loop if the maximum residual is
C ------- sufficiently small.
C
C
C  writing out a message to user to show the residual
C
             IF (KMOD.EQ.10 .OR. KMOD.EQ.11) THEN
                 WRITE(*,1201) IT, RES, NNCVN
 1201 FORMAT('   Non-Linear Equations Iteration (flow) #',I5,/,
     &             '                 Residual Error = ',E12.5,/,
     &             '   Number of Non-Converging Nodes is ',I7)
                 WRITE(*,5428) OMEF
             ENDIF
C
            IF (RES.LE.TOLBF) GO TO 660
            IF (RES.GT.1.0D38) GO TO 655
  650    CONTINUE
C
C      Add dynamic change of time step to aid convergence.
C
         IF (IBUCK .EQ. 10) THEN
           WRITE(*,5419)
 5419 FORMAT(' The time step was reduced 10 times without',
     &  ' convergence - move on.')
           GO TO 655
         ELSE
           IBUCK = IBUCK + 1
           DELT = DELT * 0.5D0
           WRITE(*,5420) DELT
 5420 FORMAT(' Time step size cut in half.  New DELT = ',F15.6,/)
           BUCKET(IBUCK) = DELT
           DO N = 1, NNP
             H(N) = HSAVE(N)
             RI(N) = H(N)
             HW(N) = W1 * H(N) + W2 * HP(N)
           END DO
           OMEF = OMESAV
           GO TO 10
         END IF
C
C ------- End the iteration loop on the non-linear equation
C
  655    WRITE(16,4000) JTM,ICY,IT,NITERF,RES,RD,NNCVN
         IF (IBUG.EQ.0 .OR. IPRT.EQ.0) GO TO 660
C
C ------- Print nonconverging nodes
C
         WRITE(16,1450)
         WRITE(16,1460) (NPCNV(NPP),NPP=1,NNCVN)
C
  660    IF (IBUCK .NE. 0) THEN
           DELT = BUCKET(IBUCK)
           IBUCK = IBUCK - 1
           DO N = 1, NNP
             HSAVE(N) = H(N)
             HP(N) = H(N)
             RI(N) = H(N)
             HW(N) = W1 * H(N) + W2 * HP(N)
           END DO
           OMEF = OMESAV
           GO TO 10
         ELSE
           DELT = DELTS
         END IF
C
         IF (ICHNG.EQ.0 .OR. IPRT.EQ.0) GO TO 680
         IF (NVESF.EQ.0 .OR. IRAIN.EQ.0) GO TO 680
C
C ------- Print rainfall-seepage boundary condition change information
C
         WRITE(16,1420) ICY
         DO I=1,NVNPF
            NI=NPVBF(I)
            NP=NPBB(NI)
            WRITE(16,1430) I,NP,INDRS(I,1),RSVAB(I,1),INDRS(I,2),
     1             RSVAB(I,2),INDRS(I,3),RSVAB(I,3),RSVAB(I,4)
         ENDDO
  680    CONTINUE
C
C ----- Compute dth/dh and Kr
C
         CALL SPROP(AKHC,DTH,H,C,IE, PROPF,RHOMU)
C
C ------- Calculate Darcy's velocity
C
         CALL VELT (V,IE,H, AKHC)
C
C ----- Calculate the total head
C
         DO NP=1,NNP
            HT(NP)=H(NP)+X(NP,3)
         ENDDO
C
         IF (NVESF.EQ.0 .OR. IRAIN.EQ.0) GO TO 710
         CALL BCPREP(IE, H,V,DCOSB,ISB,ISVF,RSVAB,INDRS,JVTYPF,
     1              QVBF,NCHG)
         IF (NCHG.EQ.0) GO TO 710
  690 CONTINUE
C
C ------- End iteration loop on seepage-rainfall boundary conditions
C
  710 IF (NNCVN.EQ.0) GO TO 715
      WRITE(16,5000) JTM,ICY,IT,NCYLF,NITERF,RES,RD,NNCVN,NCHG
  715 IF (IMID.EQ.0) GO TO 740
      DO NP=1,NNP
         H(NP)=2.0D0*H(NP)-HP(NP)
      ENDDO
      DO I=1,NDNPF
         NP=NPDBF(I)
         ITYP=JDTYPF(I)
         H(NP)=HDBF(ITYP)-X(NP,3)*DBLE(KGRAV)
      ENDDO
  740 CONTINUE
C
C ----- Check if well is dry
C
      IF (NWNPF.NE.0) THEN
          DO I=1,NWNPF
             IW=NPWF(I)
             WELLPH=H(IW)
             IF (WELLPH.LT.0.0D0) THEN
                 IDRY=1
                 WRITE(*,8001) IW, WELLPH
             ENDIF
          ENDDO
      ENDIF
C
      OMEF = OMESAV
      OMEF1 = 1.D0 - OMEF
C
      RETURN
 1200 FORMAT(5X,I10,3X,E12.6,3X,E12.6,5X,I10,3X,E12.4)
 1410 FORMAT(' TABLE OF NON-LINEAR EQUATION  FOR',I3,'-TH CYCLE',/6X,
     1 'ITERATION',7X,'RESIDUAL',6X,'DEVIATION',6X,
     2 'NO. NON-CONV. NODES',5X,' TOLAF ')
 1411 FORMAT(' TABLE OF NON-LINEAR EQUATION  FOR',I3,'-TH CYCLE',/6X,
     1 'ITERATION',7X,'RESIDUAL',6X,'DEVIATION',6X,
     2 'NO. NON-CONV. NODES',5X,' TOLBF ')
 1420 FORMAT(//' TABLE OF RAINFALL/EVAPORATION-SEEPAGE B. C. USED FOR',
     1 I3,'-TH CYCLE'//5X,' I NPVB NPCON     HCON    NPMIN     HMIN',
     2 '    NPFLX       FLX       DCYFLX'/5X,
     3 ' - ---- -----     ----    -----     ----',
     4 '    -----       ---       ------')
 1430 FORMAT(1H ,I6,I5,I6,1PD12.4,I6,1PD12.4,I6,1PD12.4,1PD12.4)
 1450 FORMAT(//' TABLE OF NON-CONVERGING NODES')
 1460 FORMAT(/(5X,15I5))
 2000 FORMAT(1H ,'WARNING: Steady state simulation DID NOT converge at',
     1I3,'-th cycle'/1H ,'IT = ',I3,'  .GT.  MAXIT = ',I3,
     2 ',  RES =',D12.5,',  RD =',D12.4/'   NNCVN =',I6)
 3000 FORMAT(1H ,'WARNING: Steady state solution is NOT converged'/1H ,
     1 'ICY = ',I3,'  IT = ',I3,'  MAXCY = ',I3,'  MAXIT = ',I3/
     2 '   RES =',D12.4,',  RD =',D12.4,',  NNCVN =',I6)
 4000 FORMAT(1H ,'WARNING: Solution did NOT converge at',I5,'-th time
     1step',I3,'-th cycle'/1H ,'IT = ',I3,' .GT. MAXIT = ',I3,2D12.4,5X,
     2I5)
 5000 FORMAT(1H ,'WARNING: Transient solution did NOT converge at ',I5,
     1 '-th time step'/1H ,'ICY = ',I3,'  IT = ',I3,'  MAXCY = ',I3,
     2 '  MAXIT = ',I3,',  RES =',D12.4,',  RD =',D12.4/'   NNCVN =',I6,
     3 '  NCHG=',I5)
      END
C
      SUBROUTINE CHEMI (X,IE,IBDY,IPRT,JTM,IBUG,KMOD,SQEPS)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /TSTEP/ NTI,NTIF,NTIT
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /PCG/ GG,IEIGEN
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /TINTE/ NCMT,NITERT,NPITERT,IPNTST
      COMMON /TREAL/ OMET,OMIT,TOLBT
C
      COMMON /FPS/ NWNPF,NWPRF,NWDPF(MXWPRH)
      COMMON /BLKPSF/ WSSF(MXWPRH),WSSFF(MXWDPH,MXWPRH),
     1               TWSSFF(MXWDPH,MXWPRH),IWTYPF(MXWNPH),
     2               NPWF(MXWNPH),JWTYPF(MXWNPH)
      COMMON /TPS/ NWNPT,NWPRT,NWDPT(MXWPRC)
      COMMON /BLKPST/ WSST(MXWPRC),WSSFT(MXWDPC,MXWPRC),
     1               TWSSFT(MXWDPC,MXWPRC),IWTYPT(MXWNPC),
     2               NPWT(MXWNPC),JWTYPT(MXWNPC)
C
      COMMON /TDBC/ NDNPT,NDPRT,NDDPT(MXDPRC)
      COMMON /TCBC/ NCEST,NCNPT,NCPRT,NCDPT(MXCPRC)
      COMMON /TVBC/ NVEST,NVNPT,NVPRT,NVDPT(MXVPRC)
      COMMON /TNBC/ NNEST,NNNPT,NNPRT,NNDPT(MXNPRC)
C
      COMMON /BLKDBT/ CDBT(MXDPRC),CDBFT(MXDDPC,MXDPRC),
     1        TCDBFT(MXDDPC,MXDPRC),IDTYPT(MXDNPC),
     2        NPDBT(MXDNPC),JDTYPT(MXDNPC)
      COMMON /BLKCBT/ QCBT(MXCPRC),QCBFT(MXCDPC,MXCPRC),
     1        TQCBFT(MXCDPC,MXCPRC),ICTYPT(MXCESC),ISCT(5,MXCESC),
     2        NPCBT(MXCNPC),IDCT(MXCESC),JCTYPT(MXCESC)
      COMMON /BLKVBT/ CVBT(MXVPRC),CVBFT(MXVDPC,MXVPRC),
     1        TCVBFT(MXVDPC,MXVPRC),IVTYPT(MXVESC),ISVT(5,MXVESC),
     2        NPVBT(MXVNPC),IDVT(MXVESC),JVTYPT(MXVESC)
      COMMON /BLKNBT/ QNBT(MXNPRC),QNBFT(MXNDPC,MXNPRC),
     1        TQNBFT(MXNDPC,MXNPRC),INTYPT(MXNESC),ISNT(5,MXNESC),
     2        NPNBT(MXNNPC),IDNT(MXNESC),JNTYPT(MXNESC)
C
      COMMON /SAZFM/ NXW,NYW,NZW,IDETQ
      COMMON /WETX/ APHA1,APHA2,APHA3,APHA4
      COMMON /WETY/ BETA1,BETA2,BETA3,BETA4
      COMMON /WETZ/ GAMA1,GAMA2,GAMA3,GAMA4
C
      COMMON /TFLOW/ FRATET(14),FLOWT(14),TFLOWT(14)
      COMMON /TCCARD/ IUNIT,JOPT,KOPT,IFILE,NPRINT,NPOST,
     1                ICFILE,IVFILE,PTIMES(MXPOST),POTIME(MXPOST)
      COMMON /BLK4/ OMEF1,OMET1,OMEFT1
C
C ------- ARRAYS FOR FLOW AND TRANSPORT
C
      COMMON /BLKFT1/LRN(MXJBDK,MAXNPK),LRL(MXKBDK,MAXNPK),NLRL(MAXNPK),
     1               ND(MAXNPK),NT(MAXNPK)
      COMMON /BLKFT2/ CMATRX(MXJBDK,MAXNPK),RI(MAXNPK),RL(MAXNPK),
     1                RLD(MAXNPK),SK(MAXNPK),RK(MAXNPK),PK(MAXNPK)
      COMMON /BLKFT3/ DCOSB(3,MXBESK),ISB(6,MXBESK),NPBB(MXBNPK),
     1                IB(MAXNPK)
C
C -------- ARRAYS FOR FLOW ONLY
C
      COMMON /BLKFL1/ H(MAXNPK),HP(MAXNPK),HW(MAXNPK),HT(MAXNPK)
      COMMON /BLKFL2/ V(MAXNPK,3),TH(8,MAXELK),DTH(8,MAXELK),
     1                AKHC(7,8,MAXELK)
C
C ------- ARRAYS FOR TRANSPORT ONLY
C
      COMMON /BLKTR1/ C(MAXNPK),CP(MAXNPK),CW(MAXNPK),CSTAR(MAXNPK),
     1                F(MAXNPK,3),DTI(MAXNPK)
      COMMON /BLKTR2/ BFLXT(MXBNPK,2),WETAB(12,MAXELK),VP(MAXNPK,3),
     1                THP(8,MAXELK),THN(MAXNPK,2),AKDC(6,8,MAXELK),
     2                VBAR(MAXNPK,3),PROPT(13,MXMATK)
C
      DIMENSION X(MAXNPK,3),IE(MAXELK,9),IBDY(MXTUBK),
     1 NOCONT(MAXNPK)
C
C $$$$$$$ PERFORM TRANSIENT-STATE OR TRANSIENT COMPUTATION
C
C ------- UPDATE CP AND ESTIMATE NONLINEAR ITERATE CW FOR COMPUTING
C ------- COEFFICIENT MATRIX AND LOAD VECTOR.
C
      DO NPP=1,NDNPT
         NP=NPDBT(NPP)
         ITYP=JDTYPT(NPP)
         C(NP)=CDBT(ITYP)
      ENDDO
      DO NP=1,NNP
         CW(NP)=C(NP)
      ENDDO
C
C ******* Compute advection concentration
C
      DO NP=1,NNP
         DTI(NP)=1.0D0/DELT
      ENDDO
C
C +++++++ USING LAGRANGIAN APPROACH
C ------- Determine ntau and dtau for lagrangian step integration
C ------- compute Lagrangian concentraton CSTAR
C
      DO I=1,NNP
         DO J=1,3
            VBAR(I,J)=0.5D0*(V(I,J)+VP(I,J))/THN(I,1)
         ENDDO
         CSTAR(I)=-1.0D20
      ENDDO
C
C ------ Incorporate boundary condition for the Lagrangian step.
C
      CALL ADVBC(CSTAR,RI,RL,IE,V,VP,CP,DCOSB,ISB,NPBB)
C
C ------ Excute backward tracking.
C
      CALL GNTRAK (IE, X, CP, VBAR, CSTAR, SK, RK, PK)
C
      EPS = 0.5D0*TOLBT
C
C %%%%%%% Begin the nonlinear iteration loop
C ------- Make initial guess for block iteration
C
      DO NP=1,NNP
         RI(NP)=CSTAR(NP)
      ENDDO
      NPT=0
C
      DO 740 ITER=1,NITERT
C
C ------- Assemble coefficient matrix and construct load vectoR
C
         CALL TASEMB(CMATRX,RLD,IE,LRN)
C
C ------- Apply boundary conditions
C
         CALL TBC(CMATRX,RLD,CSTAR,IE,LRN,DCOSB,ISB,V,VP)
C
         ID=2
         IF (IPNTST.EQ.1) THEN
            CALL PWISS (CMATRX,RLD,LRN,
     I       OMIT,EPS,NPITERT,ID,MAXNPK,MXJBDK,
     I       NT, ND,
     M       RI,
     O       C)
         ELSE IF (IPNTST.EQ.2) THEN
            CALL CG (1, NPITERT, OMIT, EPS, NNP, MAXNPK, MXJBDK,
     &       CMATRX, RLD, LRN, NT, ND, PK, SK, RK, RI, C)
         ELSE IF (IPNTST.EQ.3) THEN
            CALL CG (2, NPITERT, OMIT, EPS, NNP, MAXNPK, MXJBDK,
     &       CMATRX, RLD, LRN, NT, ND, PK, SK, RK, RI, C)
         END IF
C
C ------- Check the convergency of nonlinear loop
C
         DIFMAX=0.0D0
         NOCR=0
         DO 720 NP=1,NNP
            DIF=DABS(C(NP)-CW(NP))
            IF (DIF.LE.DIFMAX) GO TO 720
            DIFMAX=DIF
            NOCR=NP
  720    CONTINUE
C
C ------- Update nonlinear iterate cw for computing coefficient
C ------- matrix and load vector.
C
         DO NP=1,NNP
            CW(NP)=OMET*C(NP)+ OMET1*CW(NP)
            RI(NP)=CW(NP)
         ENDDO
C
         IF (KMOD.EQ.1 .OR. KMOD.EQ.11) THEN
             NPT=NPT+1
             NOCONT(NPT)=NOCR
             IF (DIFMAX.GT.TOLBT) THEN
                WRITE(*,1201) ITER, DIFMAX,TOLBT,NOCR
             ELSE
                NOCR=0
                WRITE(*,1201) ITER, DIFMAX, TOLBT,NOCR
             ENDIF
 1201 FORMAT('  Non-Linear Equations Iteration(transport) #',I5,/,
     &'   Residual Error = ',E12.3,5X,'TOLBT=',E12.3,/,
     &'   Non-Converging Nodes is ',I7,/)
         ENDIF
C
         IF (NITERT.EQ.1) GO TO 750
         IF (IBUG.NE.0.AND.IPRT.EQ.0) WRITE(16,5400)
     1         ITER,DIFMAX,TOLBT,NOCR
         IF (DIFMAX.LT.TOLBT) GO TO 750
  740 CONTINUE
C
C %%%%%%% End of nonlinear loop
C
      WRITE(16,7500) JTM,ITER-1,NITERT,DIFMAX,TOLBT,NOCR
  750 CONTINUE
      IF (IMID.EQ.0) GO TO 830
      DO NP=1,NNP
         C(NP)=2.0D0*C(NP)-CP(NP)
      ENDDO
      DO NPP=1,NDNPT
         NP=NPDBT(NPP)
         ITYP=JDTYPT(NPP)
         C(NP)=CDBT(ITYP)
      ENDDO
  830 CONTINUE
      RETURN
 4850 FORMAT(///' TRANSPORT ITERATIVE PARAMETERS'// 6X,
     1 'ITERATION',7X,' MAX DIF',6X,'TOLERANCE',6X,
     > ' MAX OCCURANCE NODE')
 5400 FORMAT(5X,'ITER =',I4,' DIFMAX =',D12.4,' TOLAT=',D12.4,
     1 ' NOCCUR =',I6)
 5500 FORMAT(1H0/5X,'** WARNING: No convergence after ',I6,
     1 ' iterations',/8X,'NITER =',I4,' DIFMAX =',D12.4,' TOLA =',
     2 D12.4,' NOCCUR =',I4)
 7500 FORMAT(1H0/5X,'** WARNING: No convergence at ',I6,'-th time step',
     1 ' after ',I4,' iterations'/8X,'NITER =',I4,' DIFMAX =',D12.4,
     2 ' TOLB =',D12.4,' NOCCUR =',I4)
      END
C
      SUBROUTINE BCPREP(IE,H,V,DCOSB,ISB, ISVF,
     1                   RSVAB,INDRS,JVTYPF,QVBF, NCHG)
C
C ------- TO DETERMINE WHETHER THE DIRICHLET B. C. WITH PONDING DEPTH,
C ------- OR THE DIRICHELT B. C. WITH MINIMUM PRESSURE HEAD, OR THE FLUX
C ------- B. C. WITH PRESCRIBED FLUX TO BE APPLIED ON THE VARIABLE
C ------- BOUNDARIES, NORMALLY THE AIR-MEDIA INTERFACE.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /FVBC/ NVESF,NVNPF,NVPRF,NVDPF(MXVPRH)
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
      COMMON /BS2F/ DETCBF(4,MXCESH),DETNBF(4,MXNESH),DETVBF(4,MXVESH),
     1              DETRBF(4,MXRESH),DETAB(4,MXBESK)
      COMMON /BLK1/ KGB(4,6,3)
C
      DIMENSION IE(MAXELK,9),H(MAXNPK),V(MAXNPK,3)
      DIMENSION DCOSB(3,MXBESK),ISB(6,MXBESK),ISVF(5,MXVESH),
     1 RSVAB(MXVNPH,4),INDRS(MXVNPH,3),QVBF(MXVPRH),JVTYPF(MXVESH)
C
      DIMENSION R1Q(4),R2Q(4),F1Q(4),F2Q(4),RHOKG(4),DET(4)
C
C ------- DETERMINE NORMAL RAINFALLS FLX(I) AND DARCY FLUXES DCYFLX(I)
C ------- FOR EACH NODAL POINT ON THE VARIABLE ELEMENT-SIDE.
C
      DO NP=1,NVNPF
         RSVAB(NP,3)=0.0D0
         RSVAB(NP,4)=0.0D0
      ENDDO
      DO MP=1,NVESF
         ITYP=JVTYPF(MP)
         RFMP=QVBF(ITYP)
         MPB=ISVF(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         IK=NIK(M)
         PROJ=DCOSB(3,MPB)
         RFMPN=-RFMP*PROJ
         NODE=4
         DO 230 IQ=1,NODE
            I=KGB(IQ,LS,IK)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
               NODE=3
               GO TO 230
            ENDIF
            NI=IE(M,I)
            F1Q(IQ)=RFMPN
            F2Q(IQ)=V(NI,1)*DCOSB(1,MPB)+DCOSB(2,MPB)*V(NI,2) +
     1              DCOSB(3,MPB)*V(NI,3)
            RHOKG(IQ)=1.0D0
            DET(IQ)=DETVBF(IQ,MP)
  230    CONTINUE
C
C -------- COMPUTE SURFACE INTEGRAL OF N(IQ).F
C
         CALL Q34S (R1Q,R2Q,F1Q,F2Q,RHOKG,NODE,DET)
C
         DO IQ=1,NODE
            I=ISVF(IQ,MP)
            RSVAB(I,3)=RSVAB(I,3)+R1Q(IQ)
            RSVAB(I,4)=RSVAB(I,4)+R2Q(IQ)
         ENDDO
      ENDDO
C
C ------- CHANGE TO FLUX OR HEAD CONDITIONS, AS NECESSARY, AND SO
C ------- INDICATE IN THE ARRAYS NPFLX(NPP) AND NPCON(NPP).
C
      IF (NCHG.NE.(-1)) GO TO 300
      NCHG=0
      RETURN
C
  300 NCHG=0
      DO 390 NPP=1,NVNPF
         DCYNNP=RSVAB(NPP,4)
         FLXNNP=RSVAB(NPP,3)
         HCONNP=RSVAB(NPP,1)
         HMINNP=RSVAB(NPP,2)
         IF (FLXNNP.GT.0.0D0) GO TO 350
C
C **** RAINFALL(INFILTRATION)-SEEPAGE CONDITIONS PREVAIL DURING RAINFALL
C ------- CHECK IF THE CHANGE FROM RAINFALL-FLUX CONDITION TO
C ------- PONDING (DIRICHLET) CONDITION IS NECESSARY?
C
         NP=INDRS(NPP,3)
         IF (NP.EQ.0) GO TO 310
         IF (HCONNP.GE.H(NP)) GO TO 390
         INDRS(NPP,1)=INDRS(NPP,3)
         INDRS(NPP,3)=0
         NCHG=NCHG+1
         WRITE(*,9001) NP,NCHG
 9001 FORMAT(5X,'INDRS(NPP,3)=',I4,2X,'NCHG=',I5,' changing flux
     & to ponding condition')
         GO TO 390
C
C ------- CHECK IF THE CHANGE FROM PONDING (DIRICHLET) CONDITION TO
C ------- RAINFALL-FLUX CONDITION IS NECESSARY?
C
  310    CONTINUE
         NP=INDRS(NPP,1)
         IF (NP.EQ.0) GO TO 320
         IF (FLXNNP.LE.DCYNNP) GO TO 390
         INDRS(NPP,3)=INDRS(NPP,1)
         INDRS(NPP,1)=0
         NCHG=NCHG+1
         WRITE(*,9002) NP,NCHG
 9002 FORMAT(5X,'INDRS(NPP,1)=',I4,2X,'NCHG=',I5,' changing ponding
     & to flux condition')
         GO TO 390
C
C ------- CHANGE MINIMUM PRESSURE CONDITION TO RAINFALL-FLUX CONDITION
C ------- SINCE A MINIMUM PRESSURE CONDITION IS NOT LIKELY TO BE
C ------- DURING RAINFALL PERIOD
C
  320    CONTINUE
         NP=INDRS(NPP,2)
         IF (NP.EQ.0) GO TO 390
         INDRS(NPP,3)=INDRS(NPP,2)
         INDRS(NPP,2)=0
         NCHG=NCHG+1
         WRITE(*,9003) NP,NCHG
 9003 FORMAT(5X,'INDRS(NPP,2)=',I4,2X,'NCHG=',I5,' changing min. press.
     & head to flux condition')
         GO TO 390
C
C **** Evaporation-seepage conditions prevail during non-rainfall period
C ------- check if the change from evaporation-flux condition to
C ------- minimum pressure head condition is necessary?
C
  350    CONTINUE
         NP=INDRS(NPP,3)
         IF (NP.EQ.0) GO TO 360
         IF (HMINNP.LE.H(NP)) GO TO 390
         INDRS(NPP,2)=INDRS(NPP,3)
         INDRS(NPP,3)=0
         NCHG=NCHG+1
         WRITE(*,9004) NP,NCHG
 9004 FORMAT(5X,'INDRS(NPP,3)=',I4,2X,'NCHG=',I5,' changing flux to
     & min. press. head condition')
         GO TO 390
C
C ------- CHECK IF THE CHANGE FROM PONDING CONDITION TO EVAPORATION-FLUX
C ------- CONDITION IS NECESSARY?
C
  360    CONTINUE
         NP=INDRS(NPP,1)
         IF (NP.EQ.0) GO TO 370
         IF (DCYNNP.GE.0.0) GO TO 390
         INDRS(NPP,3)=INDRS(NPP,1)
         INDRS(NPP,1)=0
         NCHG=NCHG+1
         WRITE(*,9005) NP,NCHG
 9005 FORMAT(5X,'INDRS(NPP,1)=',I4,2X,'NCHG=',I5,' changing ponding',
     & ' to flux condition')
         GO TO 390
C
C ------- CHECK IF THE CHANGE FROM MINIMUM PRESSURE HEAD CONDITION TO
C ------- EVAPORATION-FLUX CONDITION IS NECESSARY?
C
  370    CONTINUE
         NP=INDRS(NPP,2)
         IF (NP.EQ.0) GO TO 390
         IF (DCYNNP.LT.FLXNNP) GO TO 390
         INDRS(NPP,3)=INDRS(NPP,2)
         INDRS(NPP,2)=0
         NCHG=NCHG+1
         WRITE(*,9006) NP,NCHG
 9006 FORMAT(5X,'INDRS(NPP,2)=',I4,2X,'NCHG=',I5,' changing minimum
     & press. head to flux condition')
  390 CONTINUE
      RETURN
      END
C
      SUBROUTINE FASEMB (CMATRX,RLD,IE,LRN,C,KMOD)
C
C ------- TO ASSEMBLE THE GLOBAL COEFFICIENT MATRIX AND GLOBAL LOAD
C ------- VECTOR IN COMPRESSED FORM.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /FINTE/ NCYLF,NITERF,NPITERF,KSP,KGRAV,IPNTSF
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
C
      COMMON /FPS/ NWNPF,NWPRF,NWDPF(MXWPRH)
      COMMON /BLKPSF/ WSSF(MXWPRH),WSSFF(MXWDPH,MXWPRH),
     1                TWSSFF(MXWDPH,MXWPRH),IWTYPF(MXWNPH),
     2                NPWF(MXWNPH),JWTYPF(MXWNPH)
      COMMON /TPS/ NWNPT,NWPRT,NWDPT(MXWPRC)
      COMMON /BLKPST/ WSST(MXWPRC),WSSFT(MXWDPC,MXWPRC),
     1                TWSSFT(MXWDPC,MXWPRC),IWTYPT(MXWNPC),
     2                NPWT(MXWNPC),JWTYPT(MXWNPC)
C
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
C ------- ARRAYS FOR FLOW ONLY
C
      COMMON /BLKFL1/ H(MAXNPK),HP(MAXNPK),HW(MAXNPK),HT(MAXNPK)
      COMMON /BLKFL2/ V(MAXNPK,3),TH(8,MAXELK),DTH(8,MAXELK),
     1                AKHC(7,8,MAXELK)
      COMMON /BLKFL3/ BFLXF(MXBNPK,2),RSVAB(MXVNPH,4),PROPF(9,MXMATK),
     1                RHOMU(MXRMPK)
      COMMON /BLKFL4/ IDRY
C
      DIMENSION IE(MAXELK,9),LRN(MXJBDK,MAXNPK),RLD(MAXNPK),C(MAXNPK),
     1 CMATRX(MXJBDK,MAXNPK)
C
      DIMENSION QA(8,8),QB(8,8),RQ(8),DTHG(8),IEM(8),RHOKG(8),THG(8)
      DIMENSION AKXQ(8),AKYQ(8),AKZQ(8),AKXYQ(8),AKXZQ(8),AKYZQ(8)
C
      AGRAV=DBLE(KGRAV)
C
      IF (KSSF.EQ.1 ) THEN
         DELTI=1.0D0/DELT
         W1=WF
         W2=1.0D0-WF
      ELSE
          DELTI=0.0D0
          W1=1.0D0
          W2=0.0D0
          IF (IMID.EQ.1) THEN
             W1=1.0D0
             W2=0.0D0
          ENDIF
      ENDIF
C
C ------- Initiate matrices C(IB,NP) AND R(NP)
C
      DO NP=1,NNP
         RLD(NP)=0.0D0
      ENDDO
      DO I=1,MXJBDK
         DO NP=1,NNP
            CMATRX(I,NP)=0.0D0
         ENDDO
      ENDDO
C
C ------- Start to assemble over all elements
C
      DO 490 M=1,NEL
            NODE=IJNOD(M)
C
            MTYP=IE(M,9)
            ALP=PROPF(7,MTYP)
            POR=PROPF(8,MTYP)
C
            DO IQ=1,NODE
               IEM(IQ)=IE(M,IQ)
            ENDDO
            DO KG=1,NODE
                AKXQ(KG)=AKHC(1,KG,M)
                AKYQ(KG)=AKHC(2,KG,M)
                AKZQ(KG)=AKHC(3,KG,M)
                AKXYQ(KG)=AKHC(4,KG,M)
                AKXZQ(KG)=AKHC(5,KG,M)
                AKYZQ(KG)=AKHC(6,KG,M)
                RHOKG(KG)=AKHC(7,KG,M)
                DTHG(KG)=DTH(KG,M)
                THG(KG)=TH(KG,M)
            ENDDO
C
            CALL FQ468(QA,QB,RQ,THG,DTHG,AKXQ,AKYQ,AKZQ,AKXYQ,AKXZQ,
     >            AKYZQ,RHOKG,ALP,BETAP,POR,AGRAV,NODE,M)
C
C ------- Assemble QA(IQ,JQ) AND QB(IQ,JQ) into the global matrix
C ------- C(NP,IB) = B + A/DELT and form the global load vectoR R(NP).
C
C       For the case of mid-difference
C
            IF (IMID.NE.0) THEN
               DO IQ=1,NODE
                  NI=IEM(IQ)
                  RLD(NI)=RLD(NI)+RQ(IQ)
                  DO JQ=1,NODE
                     NJ=IEM(JQ)
                     QA(IQ,JQ)=2.0D0*QA(IQ,JQ)*DELTI
C
C ------- Merge non mid-difference and mid-difference cases
C
                     RLD(NI)=RLD(NI)+(QA(IQ,JQ)-QB(IQ,JQ))*HP(NJ)
                     DO I=1,MXJBDK
                        LNODE=LRN(I,NI)
                        IF (NJ.EQ.LNODE) GO TO 491
                     ENDDO
                     WRITE(16,1000) NI,M,JQ
	       call stopfile  ! emrl jig
                     STOP
  491                CMATRX(I,NI)=CMATRX(I,NI)+QA(IQ,JQ)+QB(IQ,JQ)
                  ENDDO
               ENDDO
C
C       For the case of non mid-difference
C
            ELSE
               DO IQ=1,NODE
                  NI=IEM(IQ)
                  RLD(NI)=RLD(NI)+RQ(IQ)
                  DO JQ=1,NODE
                     NJ=IEM(JQ)
                     QA(IQ,JQ)=QA(IQ,JQ)*DELTI
C
C ------- Merge non mid-difference and mid-difference cases
C
                     RLD(NI)=RLD(NI)+(QA(IQ,JQ)-W2*QB(IQ,JQ))*HP(NJ)
                     DO I=1,MXJBDK
                        LNODE=LRN(I,NI)
                        IF (NJ.EQ.LNODE) GO TO 492
                     ENDDO
                     WRITE(16,1000) NI,M,JQ
	       call stopfile  ! emrl jig
                     STOP
  492                CMATRX(I,NI)=CMATRX(I,NI)+QA(IQ,JQ)+W1*QB(IQ,JQ)
                  ENDDO
               ENDDO
            ENDIF
  490 CONTINUE
C
C ------- Incorporate well source/sink
C
  700 IF (NWNPF.EQ.0) RETURN
      DO I=1,NWNPF
         NI=NPWF(I)
         ITYP=JWTYPF(I)
         WSSK=WSSF(ITYP)
         IF (KMOD.EQ.11) THEN
            IF (WSSK.LT.0.0D0) THEN
               CKG=C(NI)
            ELSE
               ITYP=JWTYPT(I)
               CKG=WSST(ITYP)
            ENDIF
            RHO=RHOMU(1)+CKG*(RHOMU(2)+CKG*(RHOMU(3)+CKG*RHOMU(4)))
            WSSK=WSSK*RHO
         ENDIF
         RLD(NI)=RLD(NI)+WSSK
      ENDDO
C
 1000 FORMAT(1H1/5X,'*** WARNING: none of the lower-left nodes in equati
     1on',I3,/5X,'***  corresponds to the ',I5,'-th element',I2,
     2'-th node; STOP  ****')
      RETURN
      END
C
      SUBROUTINE FQ468(QA,QB,RQ,THG,DTHG,AKXQ,AKYQ,AKZQ,AKXYQ,AKXZQ,
     > AKYZQ,RHOKG,ALP,BETAP,POR,AGRAV,NODE,M)
C
C ------- TO COMPUTE ELEMENT MATRICES AND ELEMENT LOAD VECTORS.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /PRISM1/ XSIS(6),DL1S(6),DL2S(6),DL3S(6)
      COMMON /TETRA/ RLL1(4),RLL2(4),RLL3(4),RLL4(4)
C
      COMMON /JACOB1/ RNH(8,8),RNP(6,6),RNT(4,4)
      COMMON /JACOB2/ DJACS(8,MAXELK)
      COMMON /JACOB4/ RNH2(8,8,8),RNP2(6,6,6),RNT2(4,4,4)
      COMMON /DXYZ1/ DNXS(8,8,MAXELK)
      COMMON /DXYZ2/ DNYS(8,8,MAXELK)
      COMMON /DXYZ3/ DNZS(8,8,MAXELK)
C
      DIMENSION QA(8,8),QB(8,8),RQ(8),DTHG(8),RHOKG(8),THG(8)
      DIMENSION AKXQ(8),AKYQ(8),AKZQ(8),AKXYQ(8),AKXZQ(8),AKYZQ(8)
      DIMENSION DNX(8),DNY(8),DNZ(8),RN(8)
C
C ------- Initiate matrices QA, QB, AND RQ
C
      DO IQ=1,NODE
         RQ(IQ)=0.0D0
         DO JQ=1,NODE
            QA(IQ,JQ)=0.0D0
            QB(IQ,JQ)=0.0D0
         ENDDO
      ENDDO
C
      DO 490 KG=1,NODE
         DJAC=DJACS(KG,M)
         DO I=1,NODE
             DNX(I)=DNXS(I,KG,M)
             DNY(I)=DNYS(I,KG,M)
             DNZ(I)=DNZS(I,KG,M)
         ENDDO
         IF (NODE.EQ.8) THEN
             DO I=1,8
                RN(I)=RNH(I,KG)
             ENDDO
         ELSEIF(NODE.EQ.6) THEN
            DO I=1,6
               RN(I)=RNP(I,KG)
            ENDDO
         ELSEIF(NODE.EQ.4) THEN
            DO I=1,4
               RN(I)=RNT(I,KG)
            ENDDO
         ENDIF
C
         AKXQP=AKXQ(KG)*DJAC
         AKYQP=AKYQ(KG)*DJAC
         AKZQP=AKZQ(KG)*DJAC
         AKXYQP=AKXYQ(KG)*DJAC
         AKXZQP=AKXZQ(KG)*DJAC
         AKYZQP=AKYZQ(KG)*DJAC
         RHOQP=RHOKG(KG)
C
         DTHQP=DTHG(KG)*RHOQP*DJAC
         THQP=THG(KG)*RHOQP*DJAC
         FHP=ALP*THQP/POR + BETAP*THQP + DTHQP
C
C ------- Accumulate the sums to obtain the matrix integrals QA(IQ,JQ),
C ------- QB(IQ,JQ), AND RQ(IQ).
C
         CCC=AGRAV*RHOQP
C
         DO IQ=1,NODE
            RQ(IQ)=RQ(IQ)-(DNX(IQ)*AKXZQP+AKYZQP*DNY(IQ)+
     >             AKZQP*DNZ(IQ))*CCC
            DO JQ=1,NODE
               QB(IQ,JQ)=QB(IQ,JQ)+DNX(IQ)*(AKXQP*DNX(JQ)+
     1                   AKXYQP*DNY(JQ)+AKXZQP*DNZ(JQ)) +
     2                   DNY(IQ)*(AKXYQP*DNX(JQ)+AKYQP*DNY(JQ)+
     3                   AKYZQP*DNZ(JQ)) + DNZ(IQ)*(AKXZQP*DNX(JQ)+
     4                   AKYZQP*DNY(JQ)+AKZQP*DNZ(JQ))
            ENDDO
         ENDDO
C
         IF (NODE.EQ.8) THEN
            DO IQ=1,8
               DO JQ=1,8
                  QA(IQ,JQ)=QA(IQ,JQ) + FHP*RNH2(IQ,JQ,KG)
               ENDDO
            ENDDO
         ELSEIF (NODE.EQ.6) THEN
            DO IQ=1,6
               DO JQ=1,6
                  QA(IQ,JQ)=QA(IQ,JQ) + FHP*RNP2(IQ,JQ,KG)
               ENDDO
            ENDDO
         ELSE
            DO IQ=1,4
               DO JQ=1,4
                  QA(IQ,JQ)=QA(IQ,JQ) + FHP*RNT2(IQ,JQ,KG)
               ENDDO
            ENDDO
         ENDIF
  490 CONTINUE
C
      IF (ILUMP.EQ.0) RETURN
C
      DO I=1,NODE
         SUM=0.0D0
         DO J=1,NODE
            SUM=SUM+QA(I,J)
            QA(I,J)=0.0D0
         ENDDO
         QA(I,I)=SUM
      ENDDO
      RETURN
      END
C
      SUBROUTINE FBC (CMATRX,RLD,LRN,IE,X,AKHC,DCOSB,ISB,
     1                RSVAB,INDRS,RHOMU,HP,KMOD)
C
C ------- TO APPLY CAUCHY, NEUMANN, VARIABLE, AND DIRICHLET BOUNDARY
C ------- CONDITIONS.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /FINTE/ NCYLF,NITERF,NPITERF,KSP,KGRAV,IPNTSF
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /RAIN/ IRAIN
C
      COMMON /FDBC/ NDNPF,NDPRF,NDDPF(MXDPRH)
      COMMON /FCBC/ NCESF,NCNPF,NCPRF,NCDPF(MXCPRH)
      COMMON /FVBC/ NVESF,NVNPF,NVPRF,NVDPF(MXVPRH)
      COMMON /FNBC/ NNESF,NNNPF,NNPRF,NNDPF(MXNPRH)
      COMMON /FRBC/ NRESF,NRNPF,NRPRF,NRDPF(MXRPRH),NRMAF
C
      COMMON /BLKDBF/ HDBF(MXDPRH),HDBFF(MXDDPH,MXDPRH),
     1        THDBFF(MXDDPH,MXDPRH),IDTYPF(MXDNPH),NPDBF(MXDNPH),
     2        JDTYPF(MXDNPH)
      COMMON /BLKDBT/ CDBT(MXDPRC),CDBFT(MXDDPC,MXDPRC),
     1        TCDBFT(MXDDPC,MXDPRC),IDTYPT(MXDNPC),
     2        NPDBT(MXDNPC),JDTYPT(MXDNPC)
C
      COMMON /BLKVBF/ QVBF(MXVPRH),QVBFF(MXVDPH,MXVPRH),
     1        TQVBFF(MXVDPH,MXVPRH),IVTYPF(MXVESH),ISVF(5,MXVESH),
     2        NPVBF(MXVNPH),IDVF(MXVESH),JVTYPF(MXVESH)
      COMMON /BLKCBF/ QCBF(MXCPRH),QCBFF(MXCDPH,MXCPRH),
     1        TQCBFF(MXCDPH,MXCPRH),ICTYPF(MXCESH),ISCF(5,MXCESH),
     2        NPCBF(MXCNPH),IDCF(MXCESH),JCTYPF(MXCESH)
      COMMON /BLKNBF/ QNBF(MXNPRH),QNBFF(MXNDPH,MXNPRH),
     1        TQNBFF(MXNDPH,MXNPRH),INTYPF(MXNESH),ISNF(5,MXNESH),
     2        NPNBF(MXNNPH),IDNF(MXNESH),JNTYPF(MXNESH)
      COMMON /BLKRBF/ HRBF(MXRPRH),HRBFF(MXRDPH,MXRPRH),
     1        THRBFF(MXRDPH,MXRPRH),IRTYPF(MXRNPH),NPRBF(MXRNPH),
     2        ISRF(6,MXRESH),PRORF(2,MXRESH),IDRF(MXRESH),NRBEF(MXRESH),
     3        IRMTYP(MXRMAH),JRTYPF(MXRNPH)
C
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
      COMMON /BS2F/ DETCBF(4,MXCESH),DETNBF(4,MXNESH),DETVBF(4,MXVESH),
     1              DETRBF(4,MXRESH),DETAB(4,MXBESK)
      COMMON /BLK1/ KGB(4,6,3)
C
      COMMON /BLKTR1/ C(MAXNPK),CP(MAXNPK),CW(MAXNPK),CSTAR(MAXNPK),
     1                F(MAXNPK,3),DTI(MAXNPK)
C
      DIMENSION X(MAXNPK,3),IE(MAXELK,9),LRN(MXJBDK,MAXNPK),
     1 CMATRX(MXJBDK,MAXNPK),RLD(MAXNPK),AKHC(7,8,MAXELK),HP(MAXNPK)
      DIMENSION DCOSB(3,MXBESK),ISB(6,MXBESK)
      DIMENSION RSVAB(MXVNPH,4),INDRS(MXVNPH,3),RHOMU(MXRMPK)
C
      DIMENSION R1Q(4),R2Q(4),ZQ(4),F1Q(4),F2Q(4),RHOKG(4)
      DIMENSION BQ(4,4),DET(4)
C
      AGRAV=DBLE(KGRAV)
C
      W1=WF
      W2=1.0D0-WF
      IF (KSSF.EQ.0 .OR. IMID.EQ.1) THEN
         W1=1.0D0
         W2=0.0D0
      ENDIF
C
C ******* Apply River Boundary Conditions
C
      IF (NRESF.LE.0) GO TO 200
      DO MP=1,NRESF
         MTYP=ISRF(6,MP)
         RIVERK=PRORF(1,MP)
         RIVERB=PRORF(2,MP)
C
         MPB=ISRF(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         IK=NIK(M)
         NODE=4
         DO 110 IQ=1,4
               I=KGB(IQ,LS,IK)
               IF (I.EQ.0 .AND. IQ.EQ.4) THEN
                  NODE=3
                  GO TO 110
               ENDIF
               NI=IE(M,I)
               ZQ(IQ)=X(NI,3)
               RHOKG(IQ)=AKHC(7,I,M)
               NR=ISRF(IQ,MP)
               ITYP=JRTYPF(NR)
               F1Q(IQ)=HRBF(ITYP) - ZQ(IQ)*AGRAV
               DET(IQ)=DETRBF(IQ,MP)
  110    CONTINUE
C
         CALL Q34R (R1Q,BQ,F1Q,RHOKG,RIVERK,RIVERB,NODE,DET)
C
         DO IQ=1,NODE
            I=KGB(IQ,LS,IK)
            NI=IE(M,I)
            RLD(NI)=RLD(NI)+R1Q(IQ)
            DO JQ=1,NODE
               J=KGB(JQ,LS,IK)
               NJ=IE(M,J)
               RLD(NI)=RLD(NI)-W2*BQ(IQ,JQ)*HP(NJ)
               DO JJ=1,MXJBDK
                  LNODE=LRN(JJ,NI)
                  IF( LNODE.EQ.NJ) GO TO 150
               ENDDO
               WRITE (6,1000) MP,IQ,NI,JQ,NJ
	       call stopfile  ! emrl jig
               STOP
  150          CMATRX(JJ,NI)=CMATRX(JJ,NI)+W1*BQ(IQ,JQ)
            ENDDO
         ENDDO
      ENDDO
C
C ******* Apply cauchy boundary conditions
C
  200 IF (NCESF.LE.0) GO TO 300
      DO MP=1,NCESF
         ITYP=JCTYPF(MP)
         QCBMP=QCBF(ITYP)
         MPB=ISCF(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         IK=NIK(M)
         NODE=4
         DO 210 IQ=1,NODE
            I=KGB(IQ,LS,IK)
            IF(I.EQ.0 .AND. IQ.EQ.4)THEN
               NODE=3
               GOTO 210
            ENDIF
            NI=IE(M,I)
            F1Q(IQ)=QCBMP
            F2Q(IQ)=0.0D0
            RHOKG(IQ)=AKHC(7,I,M)
            DET(IQ)=DETCBF(IQ,MP)
  210    CONTINUE
C
         CALL Q34S (R1Q,R2Q,F1Q,F2Q,RHOKG,NODE,DET)
C
         DO IQ=1,NODE
            I=KGB(IQ,LS,IK)
            NI=IE(M,I)
            RLD(NI)=RLD(NI)-R1Q(IQ)
         ENDDO
      ENDDO
C
C ******* Apply neumann boundary conditions
C
  300 IF (NNESF.EQ.0) GO TO 500
      DO MP=1,NNESF
          ITYP=JNTYPF(MP)
          QNBMP=QNBF(ITYP)
          MPB=ISNF(5,MP)
          LS=ISB(5,MPB)
          M=ISB(6,MPB)
          IK=NIK(M)
          NODE=4
          DO 310 IQ=1,NODE
             I=KGB(IQ,LS,IK)
             IF (I.EQ.0 .AND. IQ.EQ.4) THEN
                NODE=3
                GOTO 310
             ENDIF
             NI=IE(M,I)
             F1Q(IQ)=QNBMP
             F2Q(IQ)=DCOSB(1,MPB)*AKHC(5,I,M)+DCOSB(2,MPB)*AKHC(6,I,M)+
     1              DCOSB(3,MPB)*AKHC(3,I,M)
             RHOKG(IQ)=AKHC(7,I,M)
             DET(IQ)=DETNBF(IQ,MP)
  310    CONTINUE
C
         CALL Q34S (R1Q,R2Q,F1Q,F2Q,RHOKG,NODE,DET)
C
C -------- Modify load vector due to neumann flux and gravity term.
C
          DO IQ=1,NODE
             I=KGB(IQ,LS,IK)
             NI=IE(M,I)
             RLD(NI)=RLD(NI)-R1Q(IQ)+R2Q(IQ)
          ENDDO
      ENDDO
C
C ******* Apply variable (rainfall-seepage) boundary conditions
C
  500 IF (NVESF.EQ.0 .OR. IRAIN.EQ.0) GO TO 600
C
C -------- CAUCHY PART OF VARIABLE BOUNDARY CONDITIONS
C
      DO MP=1,NVESF
         ITYP=JVTYPF(MP)
         QVBMP=QVBF(ITYP)
C
         MPB=ISVF(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         IK=NIK(M)
         PROJ=DCOSB(3,MPB)
         QVBMP=-QVBMP*PROJ
         NODE=4
         DO 410 IQ=1,NODE
            I=KGB(IQ,LS,IK)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
               NODE=3
               GO TO 410
            ENDIF
            F1Q(IQ)=QVBMP
            F2Q(IQ)=0.0D0
            RHOKG(IQ)=AKHC(7,I,M)
            DET(IQ)=DETVBF(IQ,MP)
  410    CONTINUE
C
C -------- Compute surface integral OF N(IQ).F
C
         CALL Q34S (R1Q,R2Q,F1Q,F2Q,RHOKG,NODE,DET)
C
         DO IQ=1,NODE
            I=KGB(IQ,LS,IK)
            NI=IE(M,I)
            RLD(NI)=RLD(NI)-R1Q(IQ)
         ENDDO
      ENDDO
C
C -------- Dirichlet part of variable boundary conditions
C
      DO 490 NPP=1,NVNPF
         NI=INDRS(NPP,1)
         IF (NI.NE.0) GO TO 450
         NI=INDRS(NPP,2)
         IF (NI.NE.0) GO TO 460
         GO TO 490
  450    BB=RSVAB(NPP,1)
         GO TO 470
  460    BB=RSVAB(NPP,2)
C
C ------- Put the constant head or minimum head at right-hand side
C
  470    RLD(NI)=BB
C
C ------ MOdify the row corresponding to the head node
C
         DO I=1,MXJBDK
            CMATRX(I,NI)=0.0D0
            IB=LRN(I,NI)
            IF (IB.EQ.NI) CMATRX(I,NI)=1.0D0
         ENDDO
C
C ----- Modify the column corresponding to the nead node
C ----- the reason for this is to make the coefficient matrix symmetric
C
         DO 487 INP=1,MXJBDK
            NP=LRN(INP,NI)
            IF (NP.EQ.NI .OR. NP.EQ.0) GO TO 487
            DO 485 IP=1,MXJBDK
               IB=LRN(IP,NP)
               IF (IB.EQ.0) GO TO 485
               IF (IB.EQ.NI) THEN
                  RLD(NP)=RLD(NP)-CMATRX(IP,NP)*RLD(NI)
                  CMATRX(IP,NP)=0.0D0
                  GO TO 487
               ENDIF
  485       CONTINUE
  487    CONTINUE
  490 CONTINUE
C
C ******* Apply Dirichlet boundary conditions
C
  600 IF (NDNPF.EQ.0) RETURN
      DO NPP=1,NDNPF
         NI=NPDBF(NPP)
         ITYP=JDTYPF(NPP)
         IF (KMOD.EQ.11)THEN
            CC=C(NI)
            RO=RHOMU(1)+CC*(RHOMU(2)+CC*RHOMU(3)+CC*CC*RHOMU(4))
            BB = (HDBF(ITYP)-X(NI,3)*AGRAV)*RO
         ELSEIF (KMOD.EQ.10) THEN
            BB = HDBF(ITYP)-X(NI,3)*AGRAV
         ENDIF
C
C ------- Put the dirichlet on the right-hand side
C
         RLD(NI)=BB
C
C ------- Modify the row corresponding to the dirichlet node
C
         DO I=1,MXJBDK
            CMATRX(I,NI)=0.0D0
            IB=LRN(I,NI)
            IF (IB.EQ.NI) CMATRX(I,NI)=1.0D0
         ENDDO
C
C ------ MODIFY THE COLUMN CORRESPONDING TO THE DIRICHLET NODE.
C ------ THE REASON OF THIS IS TO MAKE THE COEFFICIENT MATRIX SYMMETRIC
C
         DO 720 INP=1,MXJBDK
            NP=LRN(INP,NI)
            IF (NP.EQ.NI .OR. NP.EQ.0) GO TO 720
            DO 715 IP=1,MXJBDK
               IB=LRN(IP,NP)
               IF (IB.EQ.0) GO TO 715
               IF (IB.EQ.NI) THEN
                  RLD(NP)=RLD(NP)-CMATRX(IP,NP)*RLD(NI)
                  CMATRX(IP,NP)=0.0D0
                  GO TO 720
               ENDIF
  715       CONTINUE
  720    CONTINUE
      ENDDO
      RETURN
 1000 FORMAT(1H0,'FOR',I4,'-TH RIVER SIDE',I2,'-TH NODE EQUATION NO.',
     1 I4/1X,'  WE CANNOT FIND THE COEFFICIENT FOR THE',I2,'-TH NODE',
     2 ' UNKNOWN NO.',I4,'   STOP')
      END
C
      SUBROUTINE Q34S (R1Q,R2Q,F1Q,F2Q,RHOKG,NODE,DET)
C
C ------- TO COMPUTE BOUNDARY SURFACE LOAD VECTOR OVER A BOUNDARY
C ------- SURFACE.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      COMMON /BS1/ RNS4(4,4),RNS3(3,3)
C
      DIMENSION R1Q(4),R2Q(4),F1Q(4),F2Q(4),RHOKG(4)
      DIMENSION RN(4),DET(4)
C
C ------- Initiate matrices RQ(IQ)
C
      DO IQ=1,4
          R1Q(IQ)=0.0D0
          R2Q(IQ)=0.0D0
      ENDDO
C
C ------- Summation of the integrand over the gaussian points
C
      DO 690 KG=1,NODE
         IF (NODE.EQ.4) THEN
            RN(1)=RNS4(1,KG)
            RN(2)=RNS4(2,KG)
            RN(3)=RNS4(3,KG)
            RN(4)=RNS4(4,KG)
         ELSE
            RN(1)=RNS3(1,KG)
            RN(2)=RNS3(2,KG)
            RN(3)=RNS3(3,KG)
         ENDIF
C
C ------- Accumulate the sums to obtain the matrix integrals RQ(IQ)
C
         F1K=0.0D0
         F2K=0.0D0
         DO IQ=1,NODE
            F1K=F1K+F1Q(IQ)*RN(IQ)
            F2K=F2K+F2Q(IQ)*RN(IQ)
         ENDDO
         RHOK=RHOKG(KG)
         AA1=F1K*RHOKG(KG)*DET(KG)
         AA2=F2K*RHOKG(KG)*DET(KG)
         DO IQ=1,NODE
            R1Q(IQ)=R1Q(IQ)+RN(IQ)*AA1
            R2Q(IQ)=R2Q(IQ)+RN(IQ)*AA2
         ENDDO
  690 CONTINUE
      RETURN
      END
C
      SUBROUTINE Q34R (R1Q,BQ,F1Q,RHOKG,RIVERK,RIVERB,NODE,DET)
C
C ------- TO COMPUTE BOUNDARY SURFACE LOAD VECTOR AND BOUNDARY
C ------- MATRIX OVER A BOUNDARY SURFACE.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'gwpara.inc'
C
      COMMON /BS1/ RNS4(4,4),RNS3(3,3)
      COMMON /BS2F/ DETCBF(4,MXCESH),DETNBF(4,MXNESH),DETVBF(4,MXVESH),
     1              DETRBF(4,MXRESH),DETAB(4,MXBESK)
C
      DIMENSION R1Q(4),BQ(4,4),F1Q(4),RHOKG(4)
      DIMENSION RN(4),DET(4)
C
C ------- Initiate matrices RQ(IQ) and BQ(IQ,JQ)
C
      DO IQ=1,4
         R1Q(IQ)=0.0D0
         DO JQ=1,4
            BQ(IQ,JQ)=0.0D0
         ENDDO
      ENDDO
C
C ------- Summation of the integrand over the gaussian points
C
      DO 690 KG=1,NODE
         IF (NODE.EQ.4)THEN
            RN(1)=RNS4(1,KG)
            RN(2)=RNS4(2,KG)
            RN(3)=RNS4(3,KG)
            RN(4)=RNS4(4,KG)
         ELSE
            RN(1)=RNS3(1,KG)
            RN(2)=RNS3(2,KG)
            RN(3)=RNS3(3,KG)
         ENDIF
C
C ------- Accumulate the sums to obtain the matrix integrals RQ(IQ)
C
        F1K=0.0D0
        DO IQ=1,NODE
           F1K=F1K+F1Q(IQ)*RN(IQ)
        ENDDO
        RHOK=RHOKG(KG)
        AAAA=DET(KG)*RHOKG(KG)*RIVERK/RIVERB
        DO IQ=1,NODE
           R1Q(IQ)=R1Q(IQ)+RN(IQ)*F1K*AAAA
           DO JQ=1,NODE
              BQ(IQ,JQ)=BQ(IQ,JQ)+RN(IQ)*RN(JQ)*AAAA
           ENDDO
        ENDDO
  690 CONTINUE
      RETURN
      END
C
      SUBROUTINE VELT (V,IE,H,AKHC)
C
C ------- TO COMPUTE DARCY'S VELOCITY.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /FINTE/ NCYLF,NITERF,NPITERF,KSP,KGRAV,IPNTSF
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
      COMMON /JACOB3/ QBS(8,8,MAXELK)
      COMMON /JACOB6/ CMX(MAXNPK)
C
      DIMENSION IE(MAXELK,9)
      DIMENSION V(MAXNPK,3),H(MAXNPK),AKHC(7,8,MAXELK)
C
      DIMENSION QRX(8),QRY(8),QRZ(8),HQ(8),RHOKG(8)
      DIMENSION AKXQ(8),AKYQ(8),AKZQ(8),AKXYQ(8),AKXZQ(8),AKYZQ(8)
C
C ------- INITIATE THE DARCY VELOCITY COMPONETNTS
C
      DO NP=1,NNP
         V(NP,1)=0.0D0
         V(NP,2)=0.0D0
         V(NP,3)=0.0D0
      ENDDO
C
C ------- COMPUTE DARCY VELOCITIES BY APPLYING FINITE ELEMENT METHOD TO
C ------- DARCY LAW.
C ------- COMPUTE ELEMENT MATRICES QB(IQ,JQ), QRX(IQ),QRY(IQ),& QRZ(IQ)
C
      DO 290 M=1,NEL
         NODE = IJNOD(M)
         DO IQ=1,NODE
            NP=IE(M,IQ)
            AKXQ(IQ) =AKHC(1,IQ,M)
            AKYQ(IQ) =AKHC(2,IQ,M)
            AKZQ(IQ) =AKHC(3,IQ,M)
            AKXYQ(IQ)=AKHC(4,IQ,M)
            AKXZQ(IQ)=AKHC(5,IQ,M)
            AKYZQ(IQ)=AKHC(6,IQ,M)
            RHOKG(IQ)=AKHC(7,IQ,M)
            HQ(IQ)=H(NP)
         ENDDO
C
         CALL FQ468DV (QRX,QRY,QRZ, AKXQ,AKYQ,AKZQ,
     1      AKXYQ,AKXZQ,AKYZQ,RHOKG,HQ,NODE, M)
C
C ------- Assemble QB(IQ,JQ) into the global matrix CMATRX(IB,NP) AND
C                  QB(IQ,JQ)=QBS1(M,IQ,JQ)
C ------- Form the load vector VX(NP), VY(NP), AND VZ(NP).
C
         DO IQ=1,NODE
            NI=IE(M,IQ)
            V(NI,1)=V(NI,1)+QRX(IQ)
            V(NI,2)=V(NI,2)+QRY(IQ)
            V(NI,3)=V(NI,3)+QRZ(IQ)
         ENDDO
  290 CONTINUE
C
C ------- Solve the matrix equation CX=B
C
      DO NP=1,NNP
         V(NP,1)=V(NP,1)/CMX(NP)
         V(NP,2)=V(NP,2)/CMX(NP)
         V(NP,3)=V(NP,3)/CMX(NP)
      ENDDO
      RETURN
      END
C
      SUBROUTINE FPRINT(V,H,HT,THNPV,BFLXF,NPVBF,RSVAB,INDRS,SUBHD,
     1 ITIM)
C
C ------- TO OUTPUT FLOWS, PRESSURE HEAD, TOTAL HEAD, WATER CONTENT,
C ------- AND DARCY'S VELOCITY AS SPECIFIED BY THE PARAMETER KPR.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      CHARACTER*32 SUBHD
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
      COMMON /FVBC/ NVESF,NVNPF,NVPRF,NVDPF(MXVPRH)
      COMMON /FFLOW/ FRATEF(11),FLOWF(11),TFLOWF(11)
C
      DIMENSION V(MAXNPK,3),H(MAXNPK),HT(MAXNPK),THNPV(MAXNPK),
     1 BFLXF(MXBNPK,2),RSVAB(MXVNPH,4),INDRS(MXVNPH,3),NPVBF(MXVNPH)
      DIMENSION  FRATE(11),FINC(11),FTOTAL(11)
C
      IF (KPR0(1).LE.0) RETURN
C
      DO 100 I=1,NSELT
         KPR=KPR0(I)
C
         DO J=1,10
            FRATE(J)=FRATEF(J)
            FINC(J)=FLOWF(J)
            FTOTAL(J)=TFLOWF(J)
         ENDDO
         GO TO (10,20,30,100,100,60,70), KPR
   10    CONTINUE
C
C ----- PRINT DIAGNOSTIC FLOW INFORMATION
C
         IF (ITIM .NE. -1) THEN
           WRITE(16,1000) STIME,DELT,ITIM,(FRATE(K),FINC(K),
     &       FTOTAL(K),K=1,10)
         END IF
C
CRAE 10-20-94   EXPLANATION OF FLOW TERMS:
C
C  RATE OF CHANGE FOR VARIOUS FLOWS:10
C
C     FRATEF(1) = the Dirichlet (Head) nodal boundaries
C     FRATEF(2) = the Cauchy (Flux) nodal boundaries
C     FRATEF(3) = the Neumann (derivative) nodal boundaries
C     FRATEF(4) = the Seepage nodal boundaries
C     FRATEF(5) = the Infiltration nodal boundaries
C     FRATEF(6) = through unspecified nodes
C     FRATEF(7) = the entire boundary
C     FRATEF(8) = the artificial source/sink flows
C     FRATEF(9) = the increase in water content
C
C  FOR THIS TIME STEP:
C
C     FLOWF(1) = flow through the Dirichlet (Head) nodal boundaries
C     FLOWF(2) = flow through the Cauchy (Flux) nodal boundaries
C     FLOWF(3) = flow through the Neumann (derivative) nodal boundaries
C     FLOWF(4) = flow through the Seepage nodal boundaries
C     FLOWF(5) = flow through the Infiltration nodal boundaries
C     FLOWF(6) = flow through unspecified nodes
C     FLOWF(7) = net flow throughout the entire boundary  (total of 1 through 6)
C     FLOWF(8) = artificial source/sink flows
C     FLOWF(9) = increase in water content
C
C
C  VALUES SINCE THE BEGINNING OF THE SIMULATION:
C
C     TFLOWF(1) = TOTAL flow through the Dirichlet (Head) nodal boundaries
C     TFLOWF(2) = TOTAL flow through the Cauchy (Flux) nodal boundaries
C     TFLOWF(3) = TOTAL flow through the Neumann (derivative) nodal boundaries
C     TFLOWF(4) = TOTAL flow through the Seepage nodal boundaries
C     TFLOWF(5) = TOTAL flow through the Infiltration nodal boundaries
C     TFLOWF(6) = TOTAL flow through unspecified nodes
C     TFLOWF(7) = TOTAL net flow throughout the entire boundary  (total of 1 through 6)
C     TFLOWF(8) = TOTAL artificial source/sink flows
C     TFLOWF(9) = TOTAL increase in water content
C
C        (+) = Flow into region , (-) = flow out from the region
C
         IF (NVNPF.GT.0) THEN
            DO NPP=1,NVNPF
               NKK=NPVBF(NPP)
               RSVAB(NPP,4)=BFLXF(NKK,2)
            ENDDO
            WRITE(16,1100)
            WRITE(16,1110) (RSVAB(NPP,4),NPP=1,NVNPF)
            WRITE(16,1120) (INDRS(NPP,1),NPP=1,NVNPF)
            WRITE(16,1125) (INDRS(NPP,2),NPP=1,NVNPF)
            WRITE(16,1130) (INDRS(NPP,3),NPP=1,NVNPF)
         ENDIF
         GO TO 100
   20    CONTINUE
C
C ----- Print total heads
C
         WRITE(16,3000) STIME,DELT,MXJBDK,ITIM,SUBHD
         DO NI=1,NNP,6
            J1=NI
            J2=MIN0(NI+5,NNP)
            WRITE(16,2100) (NJ,HT(NJ),NJ=J1,J2)
         ENDDO
         GO TO 100
   30    CONTINUE
C
C ----- Print pressure heads
C
         WRITE (16,1190)
 1190 FORMAT(//)
         WRITE(16,2000) STIME,DELT,MXJBDK,ITIM,SUBHD
         DO NI=1,NNP,6
            J1=NI
            J2=MIN0(NI+5,NNP)
            WRITE(16,2110) (NJ,H(NJ),NJ=J1,J2)
         ENDDO
         GO TO 100
   60    CONTINUE
C
C ----- Print water contents at nodal points
C
         WRITE(16,4000) STIME,DELT,MXJBDK,ITIM,SUBHD
         DO NI=1,NNP,6
            J1=NI
            J2=MIN0(NI+5,NNP)
            WRITE(16,2110) (NJ,THNPV(NJ),NJ=J1,J2)
         ENDDO
         GO TO 100
   70    CONTINUE
C
C ----- Print darcy velocities
C
         WRITE(16,5000) STIME,DELT,MXJBDK,ITIM,SUBHD
         DO NP=1,NNP,3
            J1=NP
            J2=MIN0(NP+2,NNP)
            WRITE(16,5100) (NJ,(V(NJ,K),K=1,3),NJ=J1,J2)
         ENDDO
  100 CONTINUE
      RETURN
 1000 FORMAT('1',' TABLE OF SYSTEM-FLOW PARAMETERS',2X,'TABLE: ',
     > '  AT TIME =',1PD12.4/' (DELT =',1PD12.4,')',' ITIM=',I4//1X,
     > ' FLOW SIMULATION',22X,'RATE',7X,'INC. FLOW',4X,'TOTAL FLOW'/
     1 '1. FLOW THROUGH DIRICHLET NODES .. ',3(1PD12.4,2X)/
     2 '2. FLOW THROUGH CAUCHY NODES . . . ',3(1PD12.4,2X)/
     3 '3. FLOW THROUGH NEUMANN NODES .  . ',3(1PD12.4,2X)/
     4 '4. FLOW THROUGH SEEPAGE NODES .. . ',3(1PD12.4,2X)/
     5 '5. FLOW THROUGH INFILTRATION NODES ',3(1PD12.4,2X)/
     6 '6. FLOW THROUGH UNSPECIFIED NODES  ',3(1PD12.4,2X)/
     7 '7. NET FLOW THROUGH ENTIRE BOUNDARY',3(1PD12.4,2X)/
     8 '8. ARTIFICIAL SOURCES/SINKS . . . .',3(1PD12.4,2X)/
     9 '9. INCREASE IN WATER CONTENT . . . ',3(1PD12.4,2X)/
     B 'A. FLOW THROUGH RIVER NODES  . . . ',3(1PD12.4,2X)/
     A ' *** NOTE: (-) = OUT FROM, (+) = INTO THE REGION. '//)
 1100 FORMAT(/' RAINFALL-SEEPAGE NODAL FLOWS (L**3/T)')
 1110 FORMAT(10D12.4)
 1120 FORMAT(1H ,' VALUES OF NPCON'/(15I8))
 1125 FORMAT(1H ,' VALUES OF NPMIN'/(15I8))
 1130 FORMAT(1H ,' VALUES OF NPFLX'/(15I8))
 2000 FORMAT('    PRESSURE HEADS(L) AT TIME =',
     1 1PD12.4/' (DELT =',1PD12.4,'),(BAND WIDTH =',I4,')','  IT =',
     2 I5//1X,A32/1X,6(' NODE   P. HEAD(L) ')/1X,
     3 6(' ----   -----------'))
 2100 FORMAT(1X,6(I5,1PD13.5,1X))
 2110 FORMAT(1X,6(I5,1X,1PD13.5,1X))
 3000 FORMAT('  TOTAL HEADS(L) AT TIME =',1PD12.4/
     1 ' (DELT =',1PD12.4,'),(BAND WIDTH =',I4,')','  IT =',I5//1X,A32,
     2 /1X,6(' NODE  TOT HEAD(L) ')/1X,6(' ----  ----------- '))
 4000 FORMAT('  WATER CONTENT(L**3/L**3) AT TIME =',
     1 1PD12.4/' (DELT =',1PD12.4,'),(BAND WIDTH =',I4,')','  IT =',
     3 I5//1X,A32//1X,6('  NODE       M_C    '),/ )
 4100 FORMAT(1X,I7,5(I6,1PD13.5,1X))
 5000 FORMAT('   DARCY VELOCITIES (L/T) AT TIME =',
     1 1PD12.4/' (DELT =',1PD12.4,'),(BAND WIDTH =',I4,')','  IT =',
     2 I5//1X,A32//1X,3(' NODE     VX         VY         VZ     ')/1X,
     3 3(' ------------------------------------- ')/)
 5100 FORMAT(1H ,3(I5,1PD11.3,1PD11.3,1PD11.3,1X))
      END
C
      SUBROUTINE FSTORE (H,V,THNPV,FFLXB,NFILE)
C
C ------- TO STORE PERTINENT QUANTITIES FOR POST-PROCESSING
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /TCCARD/ IUNIT,JOPT,KOPT,IFILE,NPRINT,NPOST,
     1                ICFILE,IVFILE,PTIMES(MXPOST),POTIME(MXPOST)
      COMMON /ICCARD/ JICH,JICV,JICC,JICM,JIBF,JIBT,
     1               JPH,JCN,JVL,JMN,JMC,JBF,JBT
      COMMON /FTFILE/ KPH,KCN,KVL,KMC,KBF,KBT,JFILE,KFILE
      COMMON /OCCARD/ KSELT,KSAVE(6)
      COMMON /ICINT / IHEAD,ICON,ISTART
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1              NEDGE(MAXELK)
C
      DIMENSION H(MAXNPK),V(MAXNPK,3),THNPV(MAXNPK),FFLXB(MAXNPK)
C
      DATA IVER /3000/
      DATA N6 /6/
      DATA JSFLT,JSFLG,ISTAT /8,4,0/
      DATA IOBTY,ISFLT,ISFLG,ISCL,IVEC,INODE,IELEM,INAME,ITS
     % /100,110,120,130,140,170,180,190,200/
C
      CHARACTER*80 FNAME
      CHARACTER*40 ph_name, mo_name, vel_name, flx_name
C
      DATA ph_name/ 'pressure_head'/
      DATA mo_name/  'moisture_cont'/
      DATA vel_name/ 'nodal_velocity'/
      DATA flx_name/ 'nodal_boundary_flx'/
C
C  ------  WRITE ON ASCII FILES
C
      IF (IFILE.EQ.0) THEN
C
C    ------ hot start
C
         IF (ISTART.EQ.1) THEN
C
C      ---- steady state
C
            IF (KSSF.EQ.0) THEN
C
               write(*,1009) STIME
C
               DO 800 K=1,KSELT
                  KSA=KSAVE(K)+1
                  GO TO (800,81,82,83,84,800,800),KSA
C
C ----- Pressure head
C
   81             CONTINUE
                  IF (KPH.EQ.0) THEN
                     INQUIRE(31,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(31,1001) 'DATASET'
                     WRITE(31,1007) 'OBJTYPE','mesh3d'
                     WRITE(31,1002) 'BEGSCL'
                     WRITE(31,1003) 'ND',NNP
                     WRITE(31,1003) 'NC',NEL
                     WRITE(31,1004) 'NAME',ph_name
                     WRITE(31,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(31,1006) H(I)
                     ENDDO
                  ELSEIF (KPH.EQ.1) THEN
                     INQUIRE(35,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(35,1001) 'DATASET'
                     WRITE(35,1007) 'OBJTYPE','mesh3d'
                     WRITE(35,1002) 'BEGSCL'
                     WRITE(35,1003) 'ND',NNP
                     WRITE(35,1003) 'NC',NEL
                     WRITE(35,1004) 'NAME',ph_name
                     WRITE(35,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(35,1006) H(I)
                     ENDDO
                  ENDIF
                  GO TO 800
C
C ----- Flux for flow
C
   82             CONTINUE
                  IF (KBF.EQ.0) THEN
                     INQUIRE(32,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(32,1001) 'DATASET'
                     WRITE(32,1007) 'OBJTYPE','mesh3d'
                     WRITE(32,1002) 'BEGSCL'
                     WRITE(32,1003) 'ND',NNP
                     WRITE(32,1003) 'NC',NEL
                     WRITE(32,1004) 'NAME',flx_name
                     WRITE(32,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(32,1006) FFLXB(I)
                     ENDDO
                  ELSEIF (KBF.EQ.1) THEN
                     INQUIRE(36,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(36,1001) 'DATASET'
                     WRITE(36,1007) 'OBJTYPE','mesh3d'
                     WRITE(36,1002) 'BEGSCL'
                     WRITE(36,1003) 'ND',NNP
                     WRITE(36,1003) 'NC',NEL
                     WRITE(36,1004) 'NAME',flx_name
                     WRITE(36,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(36,1006) FFLXB(I)
                     ENDDO
                  ENDIF
                  GO TO 800
C
C ----- Moisture content
C
   83             CONTINUE
                  IF (KMC.EQ.0) THEN
                     INQUIRE(33,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(33,1001) 'DATASET'
                     WRITE(33,1007) 'OBJTYPE','mesh3d'
                     WRITE(33,1002) 'BEGSCL'
                     WRITE(33,1003) 'ND',NNP
                     WRITE(33,1003) 'NC',NEL
                     WRITE(33,1004) 'NAME',mo_name
                     WRITE(33,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(33,1006) THNPV(I)
                     ENDDO
                  ELSEIF (KMC.EQ.1) THEN
                     INQUIRE(37,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(37,1001) 'DATASET'
                     WRITE(37,1007) 'OBJTYPE','mesh3d'
                     WRITE(37,1002) 'BEGSCL'
                     WRITE(37,1003) 'ND',NNP
                     WRITE(37,1003) 'NC',NEL
                     WRITE(37,1004) 'NAME',mo_name
                     WRITE(37,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(37,1006) THNPV(I)
                     ENDDO
                  ENDIF
                  GO TO 800
C
C ----- Velocity
C
   84             CONTINUE
                  IF (KVL.EQ.0) THEN
                     INQUIRE(34,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(34,1001) 'DATASET'
                     WRITE(34,1007) 'OBJTYPE','mesh3d'
                     WRITE(34,1002) 'BEGVEC'
                     WRITE(34,1003) 'ND',NNP
                     WRITE(34,1003) 'NC',NEL
                     WRITE(34,1004) 'NAME',vel_name
                     WRITE(34,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(34,1006) (V(I,J),J=1,3)
                     ENDDO
                  ELSEIF (KVL.EQ.1) THEN
                     INQUIRE(38,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(38,1001) 'DATASET'
                     WRITE(38,1007) 'OBJTYPE','mesh3d'
                     WRITE(38,1002) 'BEGVEC'
                     WRITE(38,1003) 'ND',NNP
                     WRITE(38,1003) 'NC',NEL
                     WRITE(38,1004) 'NAME',vel_name
                     WRITE(38,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(38,1006) (V(I,J),J=1,3)
                     ENDDO
                  ENDIF
  800             CONTINUE
                  RETURN
             ENDIF
C
C   ----- Transient
C
             IF (JFILE.EQ.0) THEN
C
C ----- Pressure head
C
                IF (KPH.EQ.0) THEN
                   INQUIRE(31,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(31,1001) 'DATASET'
                   WRITE(31,1007) 'OBJTYPE','mesh3d'
                   WRITE(31,1002) 'BEGSCL'
                   WRITE(31,1003) 'ND',NNP
                   WRITE(31,1003) 'NC',NEL
                   WRITE(31,1004) 'NAME',ph_name
                ELSEIF (KPH.EQ.1) THEN
                   INQUIRE(35,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(35,1001) 'DATASET'
                   WRITE(35,1007) 'OBJTYPE','mesh3d'
                   WRITE(35,1002) 'BEGSCL'
                   WRITE(35,1003) 'ND',NNP
                   WRITE(35,1003) 'NC',NEL
                   WRITE(35,1004) 'NAME',ph_name
                ENDIF
C
C ----- Velocity
C
                IF (KVL.EQ.0) THEN
                   INQUIRE(34,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(34,1001) 'DATASET'
                   WRITE(34,1007) 'OBJTYPE','mesh3d'
                   WRITE(34,1002) 'BEGVEC'
                   WRITE(34,1003) 'ND',NNP
                   WRITE(34,1003) 'NC',NEL
                   WRITE(34,1004) 'NAME',vel_name
                ELSEIF (KVL.EQ.1) THEN
                   INQUIRE(38,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(38,1001) 'DATASET'
                   WRITE(38,1007) 'OBJTYPE','mesh3d'
                   WRITE(38,1002) 'BEGVEC'
                   WRITE(38,1003) 'ND',NNP
                   WRITE(38,1003) 'NC',NEL
                   WRITE(38,1004) 'NAME',vel_name
                ENDIF
C
C ----- Moisture content
C
                IF (KMC.EQ.0) THEN
                   INQUIRE(33,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(33,1001) 'DATASET'
                   WRITE(33,1007) 'OBJTYPE','mesh3d'
                   WRITE(33,1002) 'BEGSCL'
                   WRITE(33,1003) 'ND',NNP
                   WRITE(33,1003) 'NC',NEL
                   WRITE(33,1004) 'NAME',mo_name
                ELSEIF (KMC.EQ.1) THEN
                   INQUIRE(37,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(37,1001) 'DATASET'
                   WRITE(37,1007) 'OBJTYPE','mesh3d'
                   WRITE(37,1002) 'BEGSCL'
                   WRITE(37,1003) 'ND',NNP
                   WRITE(37,1003) 'NC',NEL
                   WRITE(37,1004) 'NAME',mo_name
                ENDIF
C
C ----- Flux for flow
C
                IF (KBF.EQ.0) THEN
                   INQUIRE(32,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(32,1001) 'DATASET'
                   WRITE(32,1007) 'OBJTYPE','mesh3d'
                   WRITE(32,1002) 'BEGSCL'
                   WRITE(32,1003) 'ND',NNP
                   WRITE(32,1003) 'NC',NEL
                   WRITE(32,1004) 'NAME',flx_name
                ELSEIF (KBF.EQ.1) THEN
                   INQUIRE(36,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(36,1001) 'DATASET'
                   WRITE(36,1007) 'OBJTYPE','mesh3d'
                   WRITE(36,1002) 'BEGSCL'
                   WRITE(36,1003) 'ND',NNP
                   WRITE(36,1003) 'NC',NEL
                   WRITE(36,1004) 'NAME',flx_name
                ENDIF
                JFILE=1
             ENDIF
C
             write(*,1009) STIME
C
             DO 600 K=1,KSELT
                KSA=KSAVE(K)+1
                GO TO (600,61,62,63,64,600,600),KSA
C
C ----- Pressure head
C
   61           CONTINUE
                IF (KPH.EQ.0) THEN
                   INQUIRE(31,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(31,1005) 'TS',ISTAT,STIME
                   DO I=1,NNP
                      WRITE(31,1006) H(I)
                   ENDDO
                ELSEIF (KPH.EQ.1) THEN
                   INQUIRE(35,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(35,1005) 'TS',ISTAT,STIME
                   DO I=1,NNP
                      WRITE(35,1006) H(I)
                   ENDDO
                ENDIF
                GO TO 600
C
C ----- Flux for flow
C
   62           CONTINUE
                IF (KBF.EQ.0) THEN
                   INQUIRE(32,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(32,1005) 'TS',ISTAT,STIME
                   DO I=1,NNP
                      WRITE(32,1006) FFLXB(I)
                   ENDDO
                ELSEIF (KBF.EQ.1) THEN
                   INQUIRE(36,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(36,1005) 'TS',ISTAT,STIME
                   DO I=1,NNP
                      WRITE(36,1006) FFLXB(I)
                   ENDDO
                ENDIF
                GO TO 600
C
C ----- Moisture content
C
   63           CONTINUE
                IF (KMC.EQ.0) THEN
                   INQUIRE(33,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(33,1005) 'TS',ISTAT,STIME
                   DO I=1,NNP
                      WRITE(33,1006) THNPV(I)
                   ENDDO
                ELSEIF (KMC.EQ.1) THEN
                   INQUIRE(37,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(37,1005) 'TS',ISTAT,STIME
                   DO I=1,NNP
                      WRITE(37,1006) THNPV(I)
                   ENDDO
                ENDIF
                GO TO 600
C
C ----- Velocity
C
   64           CONTINUE
                IF (KVL.EQ.0) THEN
                   INQUIRE(34,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(34,1005) 'TS',ISTAT,STIME
                   DO I=1,NNP
                      WRITE(34,1006) (V(I,J),J=1,3)
                   ENDDO
                ELSEIF (KVL.EQ.1) THEN
                   INQUIRE(38,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(38,1005) 'TS',ISTAT,STIME
                   DO I=1,NNP
                      WRITE(38,1006) (V(I,J),J=1,3)
                   ENDDO
                ENDIF
  600       CONTINUE
C
C   ----- Cold start
C
         ELSEIF (ISTART.EQ.0) THEN
            IF (NFILE.EQ.0) THEN
C
               write(*,1009) STIME
C
               NFILE=1
               DO 100 K=1,KSELT
                  KSA = KSAVE(K)+1
                  GO TO (100,11,12,13,14,100,100),KSA
C
C ----- Pressure head
C
   11             CONTINUE
                  IF (KPH.EQ.0) THEN
                     INQUIRE(31,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(31,1001) 'DATASET'
                     WRITE(31,1007) 'OBJTYPE','mesh3d'
                     WRITE(31,1002) 'BEGSCL'
                     WRITE(31,1003) 'ND',NNP
                     WRITE(31,1003) 'NC',NEL
                     WRITE(31,1004) 'NAME',ph_name
                     WRITE(31,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(31,1006) H(I)
                     ENDDO
                  ELSEIF (KPH.EQ.1) THEN
                     INQUIRE(35,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(35,1001) 'DATASET'
                     WRITE(35,1007) 'OBJTYPE','mesh3d'
                     WRITE(35,1002) 'BEGSCL'
                     WRITE(35,1003) 'ND',NNP
                     WRITE(35,1003) 'NC',NEL
                     WRITE(35,1004) 'NAME',ph_name
                     WRITE(35,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(35,1006) H(I)
                     ENDDO
                  ENDIF
                  GO TO 100
C
C ----- Flux for flow
C
   12             CONTINUE
                  IF (KBF.EQ.0) THEN
                     INQUIRE(32,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(32,1001) 'DATASET'
                     WRITE(32,1007) 'OBJTYPE','mesh3d'
                     WRITE(32,1002) 'BEGSCL'
                     WRITE(32,1003) 'ND',NNP
                     WRITE(32,1003) 'NC',NEL
                     WRITE(32,1004) 'NAME',flx_name
                     WRITE(32,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(32,1006) FFLXB(I)
                     ENDDO
                  ELSEIF (KBF.EQ.1) THEN
                     INQUIRE(36,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(36,1001) 'DATASET'
                     WRITE(36,1007) 'OBJTYPE','mesh3d'
                     WRITE(36,1002) 'BEGSCL'
                     WRITE(36,1003) 'ND',NNP
                     WRITE(36,1003) 'NC',NEL
                     WRITE(36,1004) 'NAME',flx_name
                     WRITE(36,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(36,1006) FFLXB(I)
                     ENDDO
                  ENDIF
                  GO TO 100
C
C ----- Moisture content
C
   13             CONTINUE
                  IF (KMC.EQ.0) THEN
                     INQUIRE(33,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(33,1001) 'DATASET'
                     WRITE(33,1007) 'OBJTYPE','mesh3d'
                     WRITE(33,1002) 'BEGSCL'
                     WRITE(33,1003) 'ND',NNP
                     WRITE(33,1003) 'NC',NEL
                     WRITE(33,1004) 'NAME',mo_name
                     WRITE(33,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(33,1006) THNPV(I)
                     ENDDO
                  ELSEIF (KMC.EQ.1) THEN
                     INQUIRE(37,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(37,1001) 'DATASET'
                     WRITE(37,1007) 'OBJTYPE','mesh3d'
                     WRITE(37,1002) 'BEGSCL'
                     WRITE(37,1003) 'ND',NNP
                     WRITE(37,1003) 'NC',NEL
                     WRITE(37,1004) 'NAME',mo_name
                     WRITE(37,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(37,1006) THNPV(I)
                     ENDDO
                  ENDIF
                  GO TO 100
C
C ----- Velocity
C
   14             CONTINUE
                  IF (KVL.EQ.0) THEN
                     INQUIRE(34,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(34,1001) 'DATASET'
                     WRITE(34,1007) 'OBJTYPE','mesh3d'
                     WRITE(34,1002) 'BEGVEC'
                     WRITE(34,1003) 'ND',NNP
                     WRITE(34,1003) 'NC',NEL
                     WRITE(34,1004) 'NAME',vel_name
                     WRITE(34,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(34,1006) (V(I,J),J=1,3)
                     ENDDO
                  ELSEIF (KVL.EQ.1) THEN
                     INQUIRE(38,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(38,1001) 'DATASET'
                     WRITE(38,1007) 'OBJTYPE','mesh3d'
                     WRITE(38,1002) 'BEGVEC'
                     WRITE(38,1003) 'ND',NNP
                     WRITE(38,1003) 'NC',NEL
                     WRITE(38,1004) 'NAME',vel_name
                     WRITE(38,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(38,1006) (V(I,J),J=1,3)
                     ENDDO
                  ENDIF
  100          CONTINUE
               RETURN
C
            ELSEIF (NFILE.EQ.1) THEN
C
               write(*,1009) STIME
C
               DO 200 K=1,KSELT
C
                  KSA=KSAVE(K)+1
                  GO TO (200,21,22,23,24,200,200),KSA
C
C ----- Pressure head
C
   21             CONTINUE
                  IF (KPH.EQ.0) THEN
                     INQUIRE(31,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(31,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(31,1006) H(I)
                     ENDDO
                  ELSEIF (KPH.EQ.1)THEN
                     INQUIRE(35,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(35,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(35,1006) H(I)
                     ENDDO
                  ENDIF
                  GO TO 200
C
C ----- Flux for flow
C
   22             CONTINUE
                  IF (KBF.EQ.0) THEN
                     INQUIRE(32,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(32,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(32,1006) FFLXB(I)
                     ENDDO
                  ELSEIF (KBF.EQ.1) THEN
                     INQUIRE(36,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(36,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(36,1006) FFLXB(I)
                     ENDDO
                  ENDIF
                  GO TO 200
C
C ----- Moisture content
C
   23             CONTINUE
                  IF (KMC.EQ.0)THEN
                     INQUIRE(33,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(33,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(33,1006) THNPV(I)
                     ENDDO
                  ELSEIF (KMC.EQ.1) THEN
                     INQUIRE(37,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(37,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(37,1006) THNPV(I)
                     ENDDO
                  ENDIF
                  GO TO 200
C
C ----- Velocity
C
   24             CONTINUE
                  IF (KVL.EQ.0) THEN
                     INQUIRE(34,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(34,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(34,1006) (V(I,J),J=1,3)
                     ENDDO
                  ELSEIF (KVL.EQ.1) THEN
                     INQUIRE(38,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(38,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(38,1006) (V(I,J),J=1,3)
                     ENDDO
                  ENDIF
  200          CONTINUE
            ENDIF
         ENDIF
C
C  -- WRITE ON Binary File
C
      ELSEIF (IFILE.EQ.1) THEN
C
C    ------- hot start
C
         IF (ISTART.EQ.1) THEN
C
C         ------ steady state
C
            IF (KSSF.EQ.0) THEN
C
               write(*,1009) STIME
C
               DO 700 K=1,KSELT
                  KSA = KSAVE(K)+1
                  GO TO (700,71,72,73,74,700,700), KSA
C
C ----- Pressure head
C
   71             CONTINUE
                  IF (KPH.EQ.0) THEN
                     INQUIRE(41,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(41) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(41) ISCL
                     WRITE(41) INODE,NNP
                     WRITE(41) IELEM,NEL
                     WRITE(41) INAME,ph_name
                     WRITE(41) ITS,ISTAT,STIME
                     WRITE(41) (H(I),I=1,NNP)
                  ELSEIF (KPH.EQ.1) THEN
                     INQUIRE(45,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(45) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(45) ISCL
                     WRITE(45) INODE,NNP
                     WRITE(45) IELEM,NEL
                     WRITE(45) INAME,ph_name
                     WRITE(45) ITS,ISTAT,STIME
                     WRITE(45) (H(I),I=1,NNP)
                  ENDIF
                  GO TO 700
C
C ----- Flux for flow
C
   72             CONTINUE
                  IF (KBF.EQ.0) THEN
                     INQUIRE(42,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(42) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(42) ISCL
                     WRITE(42) INODE,NNP
                     WRITE(42) IELEM,NEL
                     WRITE(42) INAME,flx_name
                     WRITE(42) ITS,ISTAT,STIME
                     WRITE(42) (FFLXB(J),J=1,NNP)
                  ELSEIF (KBF.EQ.1) THEN
                     INQUIRE(46,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(46) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(46) ISCL
                     WRITE(46) INODE,NNP
                     WRITE(46) IELEM,NEL
                     WRITE(46) INAME,flx_name
                     WRITE(46) ITS,ISTAT,STIME
                     WRITE(46) (FFLXB(J),J=1,NNP)
                  ENDIF
                  GO TO 700
C
C ----- Moisture content
C
   73             CONTINUE
                  IF (KMC.EQ.0) THEN
                     INQUIRE(43,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(43) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(43) ISCL
                     WRITE(43) INODE,NNP
                     WRITE(43) IELEM,NEL
                     WRITE(43) INAME,mo_name
                     WRITE(43) ITS,ISTAT,STIME
                     WRITE(43) (THNPV(J),J=1,NNP)
                  ELSEIF (KMC.EQ.1)THEN
                     INQUIRE(47,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(47) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(47) ISCL
                     WRITE(47) INODE,NNP
                     WRITE(47) IELEM,NEL
                     WRITE(47) INAME,mo_name
                     WRITE(47) ITS,ISTAT,STIME
                     WRITE(47) (THNPV(J),J=1,NNP)
                  ENDIF
                  GO TO 700
C
C ----- Velocity
C
   74             CONTINUE
                  IF (KVL.EQ.0) THEN
                     INQUIRE(44,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(44) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(44) IVEC
                     WRITE(44) INODE,NNP
                     WRITE(44) IELEM,NEL
                     WRITE(44) INAME,vel_name
                     WRITE(44) ITS,ISTAT,STIME
                     WRITE(44) ((V(I,J),J=1,3),I=1,NNP)
                  ELSEIF (KVL.EQ.1) THEN
                     INQUIRE(48,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(48) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(48) IVEC
                     WRITE(48) INODE,NNP
                     WRITE(48) IELEM,NEL
                     WRITE(48) INAME,vel_name
                     WRITE(48) ITS,ISTAT,STIME
                     WRITE(48) ((V(I,J),J=1,3),I=1,NNP)
                  ENDIF
  700          CONTINUE
               RETURN
           ENDIF
C
C  ---- transient
C
           IF (JFILE.EQ.0) THEN
C
C ----- Pressure head
C
              IF (KPH.EQ.0) THEN
                 INQUIRE(41,NAME=FNAME)
                 write(*,1010) FNAME
                 WRITE(41) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                 WRITE(41) ISCL
                 WRITE(41) INODE,NNP
                 WRITE(41) IELEM,NEL
                 WRITE(41) INAME,ph_name
              ELSEIF (KPH.EQ.1) THEN
                 INQUIRE(45,NAME=FNAME)
                 write(*,1010) FNAME
                 WRITE(45) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                 WRITE(45) ISCL
                 WRITE(45) INODE,NNP
                 WRITE(45) IELEM,NEL
                 WRITE(45) INAME,ph_name
              ENDIF
C
C ----- Velocity
C
              IF (KVL.EQ.0) THEN
                 INQUIRE(44,NAME=FNAME)
                 write(*,1010) FNAME
                 WRITE(44) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                 WRITE(44) IVEC
                 WRITE(44) INODE,NNP
                 WRITE(44) IELEM,NEL
                 WRITE(44) INAME,vel_name
              ELSEIF (KVL.EQ.1) THEN
                 INQUIRE(48,NAME=FNAME)
                 write(*,1010) FNAME
                 WRITE(48) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                 WRITE(48) IVEC
                 WRITE(48) INODE,NNP
                 WRITE(48) IELEM,NEL
                 WRITE(48) INAME,vel_name
              ENDIF
C
C ----- Moisture content
C
              IF (KMC.EQ.1) THEN
                 INQUIRE(43,NAME=FNAME)
                 write(*,1010) FNAME
                 WRITE(43) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                 WRITE(43) ISCL
                 WRITE(43) INODE,NNP
                 WRITE(43) IELEM,NEL
                 WRITE(43) INAME,mo_name
              ELSEIF (KMC.EQ.1) THEN
                 INQUIRE(47,NAME=FNAME)
                 write(*,1010) FNAME
                 WRITE(47) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                 WRITE(47) ISCL
                 WRITE(47) INODE,NNP
                 WRITE(47) IELEM,NEL
                 WRITE(47) INAME,mo_name
              ENDIF
C
C ----- Flux for flow
C
              IF (KBF.EQ.0) THEN
                 INQUIRE(42,NAME=FNAME)
                 write(*,1010) FNAME
                 WRITE(42) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                 WRITE(42) ISCL
                 WRITE(42) INODE,NNP
                 WRITE(42) IELEM,NEL
                 WRITE(42) INAME,flx_name
              ELSEIF (KBF.EQ.1) THEN
                 INQUIRE(46,NAME=FNAME)
                 write(*,1010) FNAME
                 WRITE(46) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                 WRITE(46) ISCL
                 WRITE(46) INODE,NNP
                 WRITE(46) IELEM,NEL
                 WRITE(46) INAME,flx_name
              ENDIF
              JFILE=1
           ENDIF
C
           write(*,1009) STIME
C
           DO 500 K=1,KSELT
              KSA = KSAVE(K)+1
              GO TO (500,51,52,53,54,500,500), KSA
C
C ----- Pressure head
C
   51         CONTINUE
              IF (KPH.EQ.0) THEN
                   INQUIRE(41,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(41) ITS,ISTAT,STIME
                   WRITE(41) (H(I),I=1,NNP)
              ELSEIF (KPH.EQ.1) THEN
                   INQUIRE(45,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(45) ITS,ISTAT,STIME
                   WRITE(45) (H(I),I=1,NNP)
              ENDIF
              GO TO 500
C
C ----- Flux for flow
C
   52         CONTINUE
              IF (KBF.EQ.0) THEN
                   INQUIRE(42,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(42) ITS,ISTAT,STIME
                   WRITE(42) (FFLXB(J),J=1,NNP)
              ELSEIF (KBF.EQ.1) THEN
                   INQUIRE(46,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(46) ITS,ISTAT,STIME
                   WRITE(46) (FFLXB(J),J=1,NNP)
              ENDIF
              GO TO 500
C
C ----- Moisture content
C
   53         CONTINUE
              IF (KMC.EQ.0) THEN
                   INQUIRE(43,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(43) ITS,ISTAT,STIME
                   WRITE(43) (THNPV(J),J=1,NNP)
              ELSEIF (KMC.EQ.1) THEN
                   INQUIRE(47,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(47) ITS,ISTAT,STIME
                   WRITE(47) (THNPV(J),J=1,NNP)
              ENDIF
              GO TO 500
C
C ----- Velocity
C
   54         CONTINUE
              IF (KVL.EQ.0) THEN
                   INQUIRE(44,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(44) ITS,ISTAT,STIME
                   WRITE(44) ((V(I,J),J=1,3),I=1,NNP)
              ELSEIF (KVL.EQ.1) THEN
                   INQUIRE(48,NAME=FNAME)
                   write(*,1010) FNAME
                   WRITE(48) ITS,ISTAT,STIME
                   WRITE(48) ((V(I,J),J=1,3),I=1,NNP)
              ENDIF
  500      CONTINUE
C
       ELSEIF (ISTART.EQ.0) THEN
          IF (NFILE.EQ.0) THEN
C
             write(*,1009) STIME
C
             DO 300 K=1,KSELT
                KSA = KSAVE(K)+1
                GO TO (300,31,32,33,34,300,300), KSA
C
C ----- Pressure head
C
   31           CONTINUE
                IF (KPH.EQ.0) THEN
                     INQUIRE(41,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(41) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(41) ISCL
                     WRITE(41) INODE,NNP
                     WRITE(41) IELEM,NEL
                     WRITE(41) INAME,ph_name
                     WRITE(41) ITS,ISTAT,STIME
                     WRITE(41) (H(I),I=1,NNP)
                ELSEIF (KPH.EQ.1) THEN
                     INQUIRE(45,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(45) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(45) ISCL
                     WRITE(45) INODE,NNP
                     WRITE(45) IELEM,NEL
                     WRITE(45) INAME,ph_name
                     WRITE(45) ITS,ISTAT,STIME
                     WRITE(45) (H(I),I=1,NNP)
                ENDIF
                GO TO 300
C
C ----- Flux for flow
C
   32           CONTINUE
                IF (KBF.EQ.0) THEN
                     INQUIRE(42,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(42) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(42) ISCL
                     WRITE(42) INODE,NNP
                     WRITE(42) IELEM,NEL
                     WRITE(42) INAME,flx_name
                     WRITE(42) ITS,ISTAT,STIME
                     WRITE(42) (FFLXB(J),J=1,NNP)
                ELSEIF (KBF.EQ.1) THEN
                     INQUIRE(46,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(46) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(46) ISCL
                     WRITE(46) INODE,NNP
                     WRITE(46) IELEM,NEL
                     WRITE(46) INAME,flx_name
                     WRITE(46) ITS,ISTAT,STIME
                     WRITE(46) (FFLXB(J),J=1,NNP)
                ENDIF
                GO TO 300
C
C ----- Moisture content
C
   33           CONTINUE
                IF (KMC.EQ.0) THEN
                     INQUIRE(43,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(43) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(43) ISCL
                     WRITE(43) INODE,NNP
                     WRITE(43) IELEM,NEL
                     WRITE(43) INAME,mo_name
                     WRITE(43) ITS,ISTAT,STIME
                     WRITE(43) (THNPV(J),J=1,NNP)
                ELSEIF (KMC.EQ.1) THEN
                     INQUIRE(47,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(47) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(47) ISCL
                     WRITE(47) INODE,NNP
                     WRITE(47) IELEM,NEL
                     WRITE(47) INAME,mo_name
                     WRITE(47) ITS,ISTAT,STIME
                     WRITE(47) (THNPV(J),J=1,NNP)
                ENDIF
                GO TO 300
C
C ----- Velocity
C
   34           CONTINUE
                IF (KVL.EQ.0)THEN
                     INQUIRE(44,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(44) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(44) IVEC
                     WRITE(44) INODE,NNP
                     WRITE(44) IELEM,NEL
                     WRITE(44) INAME,vel_name
                     WRITE(44) ITS,ISTAT,STIME
                     WRITE(44) ((V(I,J),J=1,3),I=1,NNP)
                ELSEIF (KVL.EQ.1) THEN
                     INQUIRE(48,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(48) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                     WRITE(48) IVEC
                     WRITE(48) INODE,NNP
                     WRITE(48) IELEM,NEL
                     WRITE(48) INAME,vel_name
                     WRITE(48) ITS,ISTAT,STIME
                     WRITE(48) ((V(I,J),J=1,3),I=1,NNP)
                ENDIF
  300          CONTINUE
               NFILE=1
C
            ELSEIF (NFILE.EQ.1) THEN
C
               write(*,1009) STIME
C
               DO 400 K=1,KSELT
                  KSA = KSAVE(K)+1
                  GO TO (400,41,42,43,44,400,400), KSA
C
C ----- Pressure head
C
C
   41             CONTINUE
                  IF (KPH.EQ.0) THEN
                     INQUIRE(41,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(41) ITS,ISTAT,STIME
                     WRITE(41) (H(I),I=1,NNP)
                  ELSEIF (KPH.EQ.1) THEN
                     INQUIRE(45,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(45) ITS,ISTAT,STIME
                     WRITE(45) (H(I),I=1,NNP)
                  ENDIF
                  GO TO 400
C
C ----- Flux for flow
C
   42             CONTINUE
                  IF (KBF.EQ.0) THEN
                     INQUIRE(42,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(42) ITS,ISTAT,STIME
                     WRITE(42) (FFLXB(J),J=1,NNP)
                  ELSEIF (KBF.EQ.1) THEN
                     INQUIRE(46,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(46) ITS,ISTAT,STIME
                     WRITE(46) (FFLXB(J),J=1,NNP)
                  ENDIF
                  GO TO 400
C
C ----- Moisture content
C
   43             CONTINUE
                  IF (KMC.EQ.0) THEN
                     INQUIRE(43,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(43) ITS,ISTAT,STIME
                     WRITE(43) (THNPV(J),J=1,NNP)
                  ELSEIF (KMC.EQ.1) THEN
                     INQUIRE(47,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(47) ITS,ISTAT,STIME
                     WRITE(47) (THNPV(J),J=1,NNP)
                  ENDIF
                  GO TO 400
C
C ----- Velocity
C
   44             CONTINUE
                  IF (KVL.EQ.0) THEN
                     INQUIRE(44,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(44) ITS,ISTAT,STIME
                     WRITE(44) ((V(I,J),J=1,3),I=1,NNP)
                  ELSEIF (KVL.EQ.1) THEN
                     INQUIRE(48,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(48) ITS,ISTAT,STIME
                     WRITE(48) ((V(I,J),J=1,3),I=1,NNP)
                  ENDIF
  400          CONTINUE
             ENDIF
          ENDIF
      ENDIF
      RETURN
 1001 FORMAT(A7)
 1002 FORMAT(A6)
 1003 FORMAT(A2,I8)
 1004 FORMAT(A4,1X,A40)
 1005 FORMAT(A2,I4,E16.8)
 1006 FORMAT(3(1X,E16.8E3))
 1007 FORMAT(A7,1X,A6)
 1008 FORMAT(8E16.8)
 1009 FORMAT(3X,'Time:',F12.5)
 1010 FORMAT(3X,'Written on file ',A72)
      END
C
      SUBROUTINE FSFLOW (IE,H,HP,V,TH,DTH,AKHC,RHOMU,C,
     1              BFLXF,DCOSB,ISB,NPBB,PROPF,DELT,KFLOW,KMOD)
C
C ------- TO COMPUTE WATER FLUXES, INCREMENTAL FLOW, AND ACCUMULATED
C ------- FLOW THROUGH ALL TYPES OF BOUNDARIES AND CHANGE OF WATER
C ------- STORED IN THE REGION OF INTEREST.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /FPS/ NWNPF,NWPRF,NWDPF(MXWPRH)
      COMMON /BLKPSF/ WSSF(MXWPRH),WSSFF(MXWDPH,MXWPRH),
     1                TWSSFF(MXWDPH,MXWPRH),IWTYPF(MXWNPH),
     2                NPWF(MXWNPH),JWTYPF(MXWNPH)
C
      COMMON /FDBC/ NDNPF,NDPRF,NDDPF(MXDPRH)
      COMMON /FCBC/ NCESF,NCNPF,NCPRF,NCDPF(MXCPRH)
      COMMON /FVBC/ NVESF,NVNPF,NVPRF,NVDPF(MXVPRH)
      COMMON /FNBC/ NNESF,NNNPF,NNPRF,NNDPF(MXNPRH)
      COMMON /FRBC/ NRESF,NRNPF,NRPRF,NRDPF(MXRPRH),NRMAF
C
      COMMON /BLKDBF/ HDBF(MXDPRH),HDBFF(MXDDPH,MXDPRH),
     1        THDBFF(MXDDPH,MXDPRH),IDTYPF(MXDNPH),NPDBF(MXDNPH),
     2        JDTYPF(MXDNPH)
      COMMON /BLKCBF/ QCBF(MXCPRH),QCBFF(MXCDPH,MXCPRH),
     1        TQCBFF(MXCDPH,MXCPRH),ICTYPF(MXCESH),ISCF(5,MXCESH),
     2        NPCBF(MXCNPH),IDCF(MXCESH),JCTYPF(MXCESH)
      COMMON /BLKVBF/ QVBF(MXVPRH),QVBFF(MXVDPH,MXVPRH),
     1        TQVBFF(MXVDPH,MXVPRH),IVTYPF(MXVESH),ISVF(5,MXVESH),
     2        NPVBF(MXVNPH),IDVF(MXVESH),JVTYPF(MXVESH)
      COMMON /BLKNBF/ QNBF(MXNPRH),QNBFF(MXNDPH,MXNPRH),
     1        TQNBFF(MXNDPH,MXNPRH),INTYPF(MXNESH),ISNF(5,MXNESH),
     2        NPNBF(MXNNPH),IDNF(MXNESH),JNTYPF(MXNESH)
      COMMON /BLKRBF/ HRBF(MXRPRH),HRBFF(MXRDPH,MXRPRH),
     1        THRBFF(MXRDPH,MXRPRH),IRTYPF(MXRNPH),NPRBF(MXRNPH),
     2        ISRF(6,MXRESH),PRORF(2,MXRESH),IDRF(MXRESH),NRBEF(MXRESH),
     3        IRMTYP(MXRMAH),JRTYPF(MXRNPH)
C
      COMMON /FFLOW/ FRATEF(11),FLOWF(11),TFLOWF(11)
      COMMON /FFLUX/ FFLXB(MAXNPK), SUMPRV
      COMMON /BS2F/ DETCBF(4,MXCESH),DETNBF(4,MXNESH),DETVBF(4,MXVESH),
     1              DETRBF(4,MXRESH),DETAB(4,MXBESK)
      COMMON /BLK1/ KGB(4,6,3)
C
      DIMENSION IE(MAXELK,9),H(MAXNPK),HP(MAXNPK),
     1 V(MAXNPK,3),TH(8,MAXELK),DTH(8,MAXELK),AKHC(7,8,MAXELK),C(MAXNPK)
      DIMENSION BFLXF(MXBNPK,2),RHOMU(MXRMPK),PROPF(9,MXMATK)
      DIMENSION DCOSB(3,MXBESK),ISB(6,MXBESK),NPBB(MXBNPK)
C
      DIMENSION DHQ(8),THG(8),RHOQ(8)
      DIMENSION R1Q(4),R2Q(4),F1Q(4),F2Q(4),RHOO(4),DET(4)
C
      DATA QSOS/0.0D0/
C
      CALL QLUMP (IE, C, RQ, KMOD, QSTORE, QWELL)
C
      IF (KFLOW.GT.0) GO TO 200
      DO NP=1,NBNP
         BFLXF(NP,1)=BFLXF(NP,2)
      ENDDO
      DO I=1,10
          TFLOWF(I)=0.0D0
      ENDDO
C
C ******* DETERMINE TOTAL FLOWS AND TOTAL FLOW RATES THROUGH VARIOUS
C ******* TYPES OF BOUNDARIES, STARTING WITH THE NET FLOWS THROUGH THE
C ******* ENTIRE BOUNDARY.
C
  200 SUM=0.0D0
      SUMP=0.0D0
      DO NP=1,NBNP
         SUM=SUM+BFLXF(NP,2)
         SUMP=SUMP+BFLXF(NP,1)
      ENDDO
      FRATEF(7)=SUM
      FLOWF(7)=0.5D0*(SUM+SUMP)*DELT
C
C ******* THE DIRICHLET BOUNDARY
C
      FRATEF(1)=0.0D0
      FLOWF(1)=0.0D0
      IF (NDNPF.LE.0) GO TO 400
      SUM=0.0D0
      SUMP=0.0D0
      SUMT=0.0D0
      DO NPP=1,NDNPF
          NP=NPDBF(NPP)
          DO 310 I=1,NBNP
             IJ=NPBB(I)
             IF (IJ.NE.NP) GO TO 310
             NII=I
             GO TO 320
  310     CONTINUE
             NII=0
  320     CONTINUE
          IF (NII .NE. 0) THEN
            SUM=SUM+BFLXF(NII,2)
            SUMP=SUMP+BFLXF(NII,1)
          ENDIF
          SUMT = FFLXB(NP) + SUMT
      ENDDO
C
      IF (KFLOW .EQ. 0) THEN
        SUMPRV = SUMT
      ENDIF
      FRATEF(1) = SUMT
      FLOWF(1) = 0.5D0 * (SUMT + SUMPRV) * DELT
      FRINTP = SUMPRV - SUMP
      FRINT = SUMT - SUM
      FRATEF(7) = FRATEF(7) + FRINT
      FLOWF(7) = FLOWF(7) + 0.5D0 * (FRINT + FRINTP) * DELT
      SUMPRV = SUMT
C
C ******* THE CAUCHY BOUNDARY
C
  400 FRATEF(2)=0.0D0
      FLOWF(2)=0.0D0
      IF (NCNPF.LE.0) GO TO 500
      SUM=0.0D0
      SUMP=0.0D0
      DO NPP=1,NCNPF
         NII=NPCBF(NPP)
         SUM=SUM+BFLXF(NII,2)
         SUMP=SUMP+BFLXF(NII,1)
      ENDDO
      FRATEF(2)=SUM
      FLOWF(2)=0.5D0*(SUM+SUMP)*DELT
C
C ******* THE NEUMANN BOUNDARY
C
  500 FRATEF(3)=0.0D0
      FLOWF(3)=0.0D0
      IF (NNNPF.LE.0) GO TO 600
      SUM=0.0D0
      SUMP=0.0D0
      DO NPP=1,NNNPF
         NII=NPNBF(NPP)
         SUM=SUM+BFLXF(NII,2)
         SUMP=SUMP+BFLXF(NII,1)
      ENDDO
      FRATEF(3)=SUM
      FLOWF(3)=0.5D0*(SUM+SUMP)*DELT
C
C ******* THE RAINFALL-SEEPAGE BOUNDARY
C
  600 FRATEF(4)=0.0D0
      FLOWF(4)=0.0D0
      FRATEF(5)=0.0D0
      FLOWF(5)=0.0D0
      IF (NVNPF.LE.0) GO TO 650
      SUMS=0.0D0
      SUMSP=0.0D0
      SUMR=0.0D0
      SUMRP=0.0D0
      DO 640 NPP=1,NVNPF
         NII=NPVBF(NPP)
         BFLXA=BFLXF(NII,2)
         IF (BFLXA.LT.0.D0) GO TO 630
         SUMS=SUMS+BFLXF(NII,2)
         SUMSP=SUMSP+BFLXF(NII,1)
         GO TO 640
  630    SUMR=SUMR+BFLXF(NII,2)
         SUMRP=SUMRP+BFLXF(NII,1)
  640 CONTINUE
      FRATEF(4)=SUMS
      FLOWF(4)=0.5D0*(SUMS+SUMSP)*DELT
      FRATEF(5)=SUMR
      FLOWF(5)=0.5D0*(SUMR+SUMRP)*DELT
C
C ******* THE RIVER BOUNDARY
C
  650 FRATEF(10)=0.0D0
      FLOWF(10)=0.0D0
      IF (NRNPF.LE.0) GO TO 700
      SUM=0.0D0
      SUMP=0.0D0
      DO NPP=1,NRNPF
         NII=NPRBF(NPP)
         SUM=SUM+BFLXF(NII,2)
         SUMP=SUMP+BFLXF(NII,1)
      ENDDO
      FRATEF(10)=SUM
      FLOWF(10)=0.5D0*(SUM+SUMP)*DELT
C
C ******* THE UNSPECIFIED BOUNDARY, I. E. BOUNDARY WITH ZERO TOTAL FLUX
C
  700 SUM=0.0D0
      SUMP=0.0D0
      DO I=1,5
         SUM=SUM+FRATEF(I)
         SUMP=SUMP+FLOWF(I)
      ENDDO
      SUM = SUM + FRATEF(10)
      SUMP = SUMP + FLOWF(10)
      FRATEF(6)=FRATEF(7)-SUM
      FLOWF(6)=FLOWF(7)-SUMP
C
C ******* CALCULATE THE INCREASE IN THE WATER CONTENT AND THE SOURCE
C
      QSOSP=QSOS
      QSOS = QWELL
C
      IF (KFLOW.GT.0) GO TO 880
      QSOSP=QSOS
  880 FRATEF(8)=QSOS
      FLOWF(8)=0.5D0*(QSOS+QSOSP)*DELT
C
      FRATEF(9) = QSTORE
      FLOWF(9) = FRATEF(9)*DELT
C
      DO I=1,10
         TFLOWF(I)=TFLOWF(I)+FLOWF(I)
      ENDDO
      RETURN
      END
C
      SUBROUTINE QLUMP (IE, C, RQ, KMOD, QSTORE, QWELL)
C
C
C         This subroutine computes the fluxes limped at the nodes
C         using mass and stiffness matrices.
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON / CGEOM / NNP, NEL, NBNP, NTUBS, NBES, ISHAPE
      COMMON / NINTR / NSELT, KPR0(7), KPRT, KDSK, KSSF, KSST
      COMMON / TTIME / DELT, TMAX, STIME
      COMMON / FINTE / NCYLF, NITERF, NPITERF, KSP, KGRAV, IPNTSF
      COMMON / NOPTN / ILUMP, IMID, KSORP, IQUAR
      COMMON / FREAL / TOLAF, TOLBF, WF, OMEF, OMIF, OMEMIN, OMEMAX,
     &  OMEADD, OMERED, GRAV, RHO, VISC, CNSTKR, BETAP
      COMMON / CELEM / IJNOD(MAXELK), NIK(MAXELK), NFACE(MAXELK),
     &  NEDGE(MAXELK)
      COMMON / BLKFL1 / H(MAXNPK), HP(MAXNPK), HW(MAXNPK), HT(MAXNPK)
      COMMON / BLKFL2 / V(MAXNPK, 3), TH(8, MAXELK), DTH(8, MAXELK),
     &  AKHC(7, 8, MAXELK)
      COMMON / BLKFL3 / BFLXF(MXBNPK,2), RSVAB(MXVNPH,4),
     &  PROPF(9, MXMATK), RHOMU(MXRMPK)
      COMMON / FPS / NWNPF, NWPRF, NWDPF(MXWPRH)
      COMMON / BLKPSF / WSSF(MXWPRH), WSSFF(MXWDPH, MXWPRH),
     &  TWSSFF(MXWDPH, MXWPRH), IWTYPF(MXWNPH), NPWF(MXWNPH),
     &  JWTYPF(MXWNPH)
      COMMON / BLKFT3 / DCOSB(3, MXBESK), ISB(6, MXBESK),
     &  NPBB(MXBNPK), IB(MAXNPK)
      COMMON / BLKPST / WSST(MXWPRC), WSSFT(MXWDPC, MXWPRC),
     &  TWSSFT(MXWDPC, MXWPRC), IWTYPT(MXWNPC), NPWT(MXWNPC),
     &  JWTYPT(MXWNPC)
C
      COMMON / FFLUX / FFLXB(MAXNPK), SUMPRV
C
      DIMENSION IE(MAXELK, 9), C(MAXNPK)
      DIMENSION QA(8, 8), QB(8, 8), RQ(8), DTHG(8), IEM(8),
     &  RHOKG(8), THG(8)
      DIMENSION AKXQ(8), AKYQ(8), AKZQ(8), AKXYQ(8), AKXZQ(8),
     &  AKYZQ(8)
C
      DO N = 1, NNP
        FFLXB(N) = 0.0D0
      END DO
      QSTORE = 0.0D0
      QWELL = 0.0D0
C
      IF (KSSF .EQ. 1) THEN
        IF (IMID .NE. 1) THEN
          W1 = WF
          W2 = 1.0D0 - WF
        ELSE
          W1 = 0.5D0
          W2 = 0.5D0
        END IF
      ELSE
        W1 = 1.0D0
        W2 = 0.0D0
      END IF
C
      AGRAV = DBLE (KGRAV)
C
      DO M = 1, NEL
C
C         Compute element mass and stiffness matrices.
C
        NODE = IJNOD(M)
        MTYP = IE(M, 9)
        ALP = PROPF(7, MTYP)
        POR = PROPF(8, MTYP)
C
        DO IQ = 1, NODE
          IEM(IQ) = IE(M, IQ)
        ENDDO
C
        DO KG = 1, NODE
          AKXQ(KG) = AKHC(1, KG, M)
          AKYQ(KG) = AKHC(2, KG, M)
          AKZQ(KG) = AKHC(3, KG, M)
          AKXYQ(KG) = AKHC(4, KG, M)
          AKXZQ(KG) = AKHC(5, KG, M)
          AKYZQ(KG) = AKHC(6, KG, M)
          RHOKG(KG) = AKHC(7, KG, M)
          DTHG(KG) = DTH(KG, M)
          THG(KG) = TH(KG, M)
        END DO
C
        CALL FQ468 (QA, QB, RQ, THG, DTHG, AKXQ, AKYQ,
     &    AKZQ, AKXYQ, AKXZQ, AKYZQ, RHOKG, ALP, BETAP,
     &    POR, AGRAV, NODE, M)
C
C         Compute the contribution from the element mass matrices.
C
        IF (KSSF .EQ. 1) THEN
C
          DELTI = 1.0D0 / DELT
C
          DO IQ = 1, NODE
            NI = IEM(IQ)
            SUM = 0.0D0
            DO JQ = 1, NODE
              NJ = IEM(JQ)
              SUM = (H(NJ) - HP(NJ)) * DELTI * QA(IQ, JQ) + SUM
            END DO
            FFLXB(NI) = FFLXB(NI) + SUM
            QSTORE = QSTORE + SUM
          END DO
C
        END IF
C
C         Compute the contribution from the element stiffness matrices.
C
        DO IQ = 1, NODE
          NI = IEM(IQ)
          SUM = 0.0D0
          DO JQ = 1, NODE
            NJ = IEM(JQ)
            SUM = (H(NJ) * W1 + HP(NJ) * W2) * QB(IQ, JQ) + SUM
          END DO
          FFLXB(NI) = FFLXB(NI) + SUM
        END DO
C
C         Compute the contribution from the gravity term.
C
        DO IQ = 1, NODE
          NI = IEM(IQ)
          FFLXB(NI) = FFLXB(NI) - RQ(IQ)
        END DO
C
      END DO
C
C         Compute the contribution from wells.
C
      IF (NWNPF .NE. 0) THEN
C
        DO I = 1, NWNPF
          NI = NPWF(I)
          QWELL = QWELL + FFLXB(NI)
        END DO
C
      END IF
C
C         Store data in the boundary node array.
C
      DO I = 1, NBNP
        NI = NPBB(I)
        BFLXF(I, 1) = BFLXF(I, 2)
        BFLXF(I, 2) = FFLXB(NI)
      END DO
C
      RETURN
      END
C
      SUBROUTINE PAGEN (LRN,NLRN,LRL,NLRL,IE,ND)
C
C ------- TO GENERATE POINTER ARRAYS.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /FINTE/ NCYLF,NITERF,NPITERF,KSP,KGRAV,IPNTSF
      COMMON /TINTE/ NCMT,NITERT,NPITERT,IPNTST
C
      DIMENSION LRN(MXJBDK,MAXNPK),LRL(MXKBDK,MAXNPK),IE(MAXELK,9)
      DIMENSION NLRN(MAXNPK),NLRL(MAXNPK),ND(MAXNPK)
      DIMENSION KK(100),KJ(100)
C
C ******* GENERATE LRN(MXJBD,MAXNP) BASED ON IE(MAXEL,9)
C
      CALL LRL3D (IE,NEL,NNP,MAXELK,MAXNPK,MXKBDK,NLRL,LRL)
      CALL LRN3D (IE,NEL,NNP,MAXELK,MAXNPK,MXJBDK,NLRN,LRN)
C
CCCCCC  THE FOLLOWING IF BLOCK IS FOR THE NEW VERSION OF SUBROUTINE
CCCCCC  PWISS
C
      IF (IPNTSF.LE.2 .OR. IPNTST.LE.2)THEN
         DO NP=1,NNP
            DO I=1,NLRN(NP)
               IF(LRN(I,NP).EQ.NP) ND(NP)=I
            ENDDO
         ENDDO
      ENDIF
C
CCCCCC
      IF (IPNTSF.EQ.3 .OR. IPNTST.EQ.3) THEN
C
C ----- REARRANGE LRN IN ACENDING ORDER AND COMPUTE ND IF EITHER
C       IPNTSF=3 OR IPNTST=3
C
         DO 150 NP=1,NNP
            NCOUNT=0
            DO 140 I=1,NLRN(NP)
               NI=LRN(I,NP)
               IF (NCOUNT.EQ.0)THEN
                  KK(1)=I
                  KJ(1)=NI
                  NCOUNT=NCOUNT+1
               ELSE
                  DO J=NCOUNT,1,-1
                     NJ=KJ(J)
                     IF (J.EQ.1)THEN
                        IF (NI.LT.NJ)GOTO 100
                     ELSE
                        NK=KJ(J-1)
                        IF(NI.LT.NJ .AND. NI.GT.NK) GOTO 100
                     ENDIF
                  ENDDO
                  NCOUNT=NCOUNT+1
                  KK(NCOUNT)=I
                  KJ(NCOUNT)=NI
                  GOTO 140
  100             CONTINUE
                  NCOUNT=NCOUNT+1
                  DO JJ=NCOUNT,J+1,-1
                     KK(JJ)=KK(JJ-1)
                     KJ(JJ)=KJ(JJ-1)
                  ENDDO
                  KK(J)=I
                  KJ(J)=NI
               ENDIF
  140      CONTINUE
C
           DO I=1,NLRN(NP)
              LRN(I,NP)=KJ(I)
              IF(KJ(I).EQ.NP) ND(NP)=I
           ENDDO
  150   CONTINUE
      ENDIF
C
      NMAX=0
      NOCUR=0
      DO NP=1,NNP
         NN=NLRL(NP)
         IF (NN.GT.NMAX) THEN
            NMAX=NN
            NOCUR=NP
         ENDIF
      ENDDO
      IF (NMAX.GT.MXKBDK) THEN
         WRITE(16,1100) NOCUR,NMAX,MXKBDK
	       call stopfile  ! emrl jig
         STOP
      ENDIF
C
      NMAX=0
      NOCUR=0
      DO NP=1,NNP
         NN=NLRN(NP)
         IF (NN.GT.NMAX) THEN
            NMAX=NN
            NOCUR=NP
         ENDIF
      ENDDO
      IF (NMAX.GT.MXJBDK) THEN
         KONT=NMAX-1
         JBND=MXJBDK-1
         WRITE(16,1000) NP,KONT,JBND
	       call stopfile  ! emrl jig
         STOP
      ENDIF
C
C ----- PRINT GENERATED ARRAY LRN
C
         WRITE(25,5000)
         DO NP=1,NNP
            WRITE(25,5100) NP,(LRN(I,NP),I=1,NLRN(NP))
         ENDDO
C
C ----- PRINT GENERATED ARRAY LRL
C
         WRITE(25,5200)
         DO NP=1,NNP
            WRITE(25,5100) NP,(LRL(I,NP),I=1,NLRL(NP))
         ENDDO
C ---------------------------------------------------------------------
C
 1000 FORMAT(1H ,//5X,' ***',I4,'-TH NODE HAS',I4,' NODES SURROUNDING',
     1 ' IT, WHICH IS MORE THAN MXJBDK - 1 =',I5,'  STOP ***')
 1100 FORMAT(1H ,//5X,' ***',I4,'-TH NODE HAS',I4,' ELEMENTS '/
     1 'SURROUNDING IT, WHICH IS MORE THAN MXKBDK =',I5,'  STOP ***')
 5000 FORMAT(1H ,/5X,' ** GENERATED SURROUNDING NODES OF ALL NODES *',//
     1 1X,'   NP    1    2    3    4    5    6    7    8    9   10   11'
     2 ,'   12   13   14   15   16   17   18   19   20'/1X,21('   --')/,
     3 '        21   22   23   24   25   26   27'/1X, 8('   --')/)
 5100 FORMAT(1H ,28I5)
 5200 FORMAT(1H ,/1X,' ** GENERATED CONNECTING ELEMENTS OF ALL NODES *'
     1 //1X,'   NP    1    2    3    4    5    6    7    8'/1X,
     2 9('  ---'))
 5300 FORMAT(1H ,9I5)
      RETURN
      END
C
      SUBROUTINE LRL3D (IE,NEL,NNP,MAXELK,MAXNPK,MXKBDK,NLRL,LRL)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      DIMENSION IE(MAXELK,9),NLRL(MAXNPK),LRL(MXKBDK,MAXNPK)
C
      DO I=1,NNP
         NLRL(I)=0
         DO K=1,MXKBDK
            LRL(K,I)=0
         ENDDO
      ENDDO
      DO 400 M=1,NEL
C
         CALL ELENOD(IE(M,5),IE(M,7),NODE,I,I1)
C
         DO I=1,NODE
            IEM=IE(M,I)
            NLRL(IEM)=NLRL(IEM)+1
            NLRLN=NLRL(IEM)
            LRL(NLRLN,IEM)=M
         ENDDO
 400  CONTINUE
      RETURN
      END
C
      SUBROUTINE LRN3D (IE,NEL,NNP,MAXELK,MAXNPK,MXJBDK,NLRN,LRN)
C
C $$$$$ TO GENERATE NLRN, AND LRN
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      DIMENSION IE(MAXELK,9),NLRN(MAXNPK),LRN(MXJBDK,MAXNPK)
C
      DO I=1,NNP
         NLRN(I)=0
         DO J=1,MXJBDK
            LRN(J,I)=0
         ENDDO
      ENDDO
      DO 400 M=1,NEL
C
         CALL ELENOD(IE(M,5),IE(M,7),NODE,MJ,MJ1)
C
         DO I=1,NODE
            IEM=IE(M,I)
            DO 100 J=1,NODE
               IEMJ=IE(M,J)
               IF (NLRN(IEM).EQ.0) THEN
                  NLRN(IEM)=NLRN(IEM)+1
                  LRN(1,IEM)=IEMJ
               ELSE
                  DO K=1,NLRN(IEM)
                     N=LRN(K,IEM)
                     IF(N.EQ.IEMJ) GOTO 100
                  ENDDO
                  NLRN(IEM)=NLRN(IEM)+1
                  NLRNN=NLRN(IEM)
                  LRN(NLRNN,IEM)=IEMJ
              ENDIF
 100       CONTINUE
         ENDDO
 400  CONTINUE
      RETURN
      END
C
      SUBROUTINE PWISS
     I  (C,RL,LRN, OMI,EPS,NITER,IDCS,MAXNPK,MXJBDK,
     I   NLRN, ND,
     M   RI,
     O   R)
C
C ------- To solve a matrix equation with pointwise iteration solution
C ------- strategies.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /PLIC/ LIPC
C
      DIMENSION C(MXJBDK,MAXNPK),RL(MAXNPK),LRN(MXJBDK,MAXNPK)
      DIMENSION R(MAXNPK),RI(MAXNPK)
      DIMENSION NLRN(MAXNPK),ND(MAXNPK)
C
C ------- Print iteration information if desired.
C
      DO 290 IT=1,NITER
C
C ------- For each iteration, put the load vector into R(MAXNP).
C
         DO NP=1,NNP
            R(NP)=RI(NP)
         ENDDO
C
         DO NP=1,NNP
            S=0.0D0
            DO I=1,NLRN(NP)
               S=S+C(I,NP)*R(LRN(I,NP))
            ENDDO
            R(NP)=R(NP)+OMI*(RL(NP)-S)/C(ND(NP),NP)
         ENDDO
C
C ------- Start to compute new iterate with pointwise iterations.
C
         DO NP=NNP,1,-1
            S=0.0D0
            DO I=1,NLRN(NP)
               S=S+C(I,NP)*R(LRN(I,NP))
            ENDDO
            R(NP)=R(NP)+OMI*(RL(NP)-S)/C(ND(NP),NP)
         ENDDO
C
C ------- Check if a convergent solution is obtained?
C
         NNCVN=0
         RELERR=-1.0D0
         ABSERR=-1.0D0
         IF (IDCS.EQ.1) THEN
            DO 260 NP=1,NNP
               ABSDIF=DABS(R(NP)-RI(NP))
               ABSERR=DMAX1(ABSERR,ABSDIF)
               IF (ABSDIF.LE.EPS) GOTO 260
               NNCVN=NNCVN+1
  260       CONTINUE
         ELSEIF (IDCS.EQ.2) THEN
            DO 270 NP=1,NNP
               ABSDIF=DABS(R(NP)-RI(NP))
               IF (RI(NP).NE.0.0D0) THEN
                  RELDIF = DABS (ABSDIF / RI(NP))
                  RELERR=DMAX1(RELERR,RELDIF)
               ELSE
                  GO TO 270
               ENDIF
               IF (RELDIF.LE.EPS) GOTO 270
               NNCVN=NNCVN+1
  270       CONTINUE
         ENDIF
C
C ------- Update the iterate.
C
         DO NP=1,NNP
            RI(NP)=R(NP)
         ENDDO
C
C -------  Print iteration information if desired.
C
         IF (IDCS.EQ.1) THEN
            IF (LIPC*(IT/LIPC).EQ.IT) THEN
               WRITE(*,241) IT,ABSERR,NNCVN,EPS
  241 FORMAT(' PW: Linear itera.(flow) #',I6,1X,'ABSERR=',1PD13.6,
     % 1X,'NNCVN=',I6,1X,'EPS=',1PD8.1)
            ENDIF
            IF (ABSERR .LE. EPS ) GO TO 990
         ELSEIF (IDCS.EQ.2) THEN
            IF (LIPC*(IT/LIPC).EQ.IT) THEN
              WRITE(*,242) IT,RELERR,NNCVN,EPS
  242 FORMAT(' PW: Linear itera.(trans.) #',I6,1X,'RELERR=',1PD13.6,
     & 1X,'NNCVN=',I6,1X,'EPS=',1PD9.2)
            ENDIF
            IF (RELERR .LE. EPS) GO TO 990
         ENDIF
  290 CONTINUE
      IF (IDCS.EQ.1) THEN
         WRITE (16,2001) IT,NITER,ABSERR,NNCVN
         WRITE (*,2001)  IT,NITER,ABSERR,NNCVN
      ELSEIF (IDCS.EQ.2) THEN
         WRITE (16,2002) IT,NITER,RELERR,NNCVN
         WRITE (*,2002)  IT,NITER,RELERR,NNCVN
      ENDIF
  990 CONTINUE
 2001 FORMAT(18X,' ** Warning: No Convergence after ', I6,
     1 ' iterations'
     2 /18X,' NPITER =',I4,'  ABSERR =',1PD13.6,' NNCVN =',I6)
 2002 FORMAT(18X,' ** Warning: No Convergence after ', I6,
     1 ' iterations'
     2 /18X,' NPITER =',I4,' RELERR =',1PD13.6,' NNCVN =',I6)
      RETURN
      END
C
      SUBROUTINE SPROP(AKHC,DTH,H,C,IE,PROPF,RHOMU)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
C ------- TO COMPUTE HYDRAULIC CONDUCTIVITY AND WATER CAPACITY GIVEN
C ------- THE PRESSURE HEAD.
C ------- INPUT: H(NNP),X(NNP,3),IE(NEL,9),
C -------        LRL(MXKBD,NNP), H(NNP), SPP(NSPPM,NMAT,4), KSP.
C ------- OUTPUT: AKHC(8,NEL), DTH(8,NEL).
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /SPCARD/ NUNSAT,NSP(MXMATK),IHM(MXMATK),IHC(MXMATK),
     1       IHW(MXMATK),NPMC(MXMATK),NPCON(MXMATK),NPWC(MXMATK)
      COMMON /UNSAT/ PH(MXSPMK,MXMATK),PMC(MXSPMK,MXMATK),
     1               PCON(MXSPMK,MXMATK),CONDUC(MXSPMK,MXMATK),
     2               PWC(MXSPMK,MXMATK),WC(MXSPMK,MXMATK),
     &               PMKNOT(MXSPMK + 4, MXMATK), PCKNOT(MXSPMK + 4,
     &               MXMATK), PWKNOT(MXSPMK + 4, MXMATK),
     &               PMCOEF(MXSPMK, MXMATK), PCCOEF(MXSPMK, MXMATK),
     &               PWCOEF(MXSPMK, MXMATK), IBSPL
      COMMON /MPCARD/ NDVFUN,NPROPF(MXMATK),NPROPT(MXMATK)
C
      COMMON /JACOB1/ RNH(8,8),RNP(6,6),RNT(4,4)
C
      DIMENSION IE(MAXELK,9)
      DIMENSION DTH(8,MAXELK),AKHC(7,8,MAXELK),H(MAXNPK)
      DIMENSION C(MAXNPK),RHOMU(MXRMPK),PROPF(9,MXMATK)
C
      DIMENSION HQ(8),HKG(8),CQ(8),CKG(8),RN(8)
C
C ------- Initiate array akhc
C
      DO M=1,NEL
         NODE=IJNOD(M)
         DO KG=1,NODE
            DO I=1,7
               AKHC(I,KG,M)=0.0D0
            ENDDO
         ENDDO
      ENDDO
C
C *******  DTH/DH  and Kr are obtained by table
C
      DO 490 M=1,NEL
         NODE=IJNOD(M)
         DO IQ=1,NODE
            NP=IE(M,IQ)
            CQ(IQ)=C(NP)
            HQ(IQ)=H(NP)
         ENDDO
C
C ------- Evaluate pressure at four gaussian points for quadrilateral
C ------- element.
C
         DO KG=1,NODE
            IF (NODE.EQ.8) THEN
               DO I=1,8
                  RN(I)=RNH(I,KG)
               ENDDO
            ELSEIF (NODE.EQ.6) THEN
               DO I=1,6
                  RN(I)=RNP(I,KG)
               ENDDO
            ELSE
               DO I=1,4
                  RN(I)=RNT(I,KG)
               ENDDO
            ENDIF
            HKG(KG)=0.0D0
            CKG(KG)=0.0D0
            DO IQ=1,NODE
               HKG(KG)=HKG(KG)+HQ(IQ)*RN(IQ)
               CKG(KG)=CKG(KG)+CQ(IQ)*RN(IQ)
            ENDDO
         ENDDO
C
         MTYP=IE(M,9)
         SATKX =PROPF(1,MTYP)
         SATKY =PROPF(2,MTYP)
         SATKZ =PROPF(3,MTYP)
         SATKXY=PROPF(4,MTYP)
         SATKXZ=PROPF(5,MTYP)
         SATKYZ=PROPF(6,MTYP)
C
         NUMWC=NPWC(MTYP)
         NUMCON=NPCON(MTYP)
C
C %%%%%%%  DTH/DH and Kr are obtained by table
C
         DO 290 KG=1,NODE
C
            HNP=HKG(KG)
C
C  *****  water capacity
C
            IF (IBSPL .EQ. 1) THEN
              CALL BSINT (PWC(1, MTYP), WC(1, MTYP), NUMWC, PWKNOT(1,
     &          MTYP), PWCOEF(1, MTYP), HNP, USWFCT)
            ELSE
              CALL LININT (PWC(1, MTYP), WC(1, MTYP), NUMWC,
     &          HNP, USWFCT)
            END IF
C
            DTH(KG, M) = USWFCT
C
C  ***** relative conductivity
C
            IF (IBSPL .EQ. 1) THEN
              CALL BSINT (PCON(1, MTYP), CONDUC(1, MTYP), NUMCON,
     &          PCKNOT(1, MTYP), PCCOEF(1, MTYP), HNP, USKFCT)
              IF (USKFCT .LT. CONDUC(1, MTYP)) USKFCT = CONDUC(1, MTYP)
            ELSE
              CALL LININT (PCON(1, MTYP), CONDUC(1, MTYP), NUMCON,
     &          HNP, USKFCT)
            END IF
C
            IF (USKFCT .LT. CNSTKR) USKFCT = CNSTKR
C
C ----- RHO denotes RHO/RHO0
C ----- AMU denotes MU/MU0
C
            RHO=RHOMU(1)+CKG(KG)*(RHOMU(2)+CKG(KG)*(RHOMU(3)+CKG(KG)
     1         *RHOMU(4)))
            AMU=RHOMU(5)+CKG(KG)*(RHOMU(6)+CKG(KG)*(RHOMU(7)+CKG(KG)
     1         *RHOMU(8)))
C
            AAAA = USKFCT*RHO/AMU
            AKHC(1,KG,M)=SATKX*AAAA
            AKHC(2,KG,M)=SATKY*AAAA
            AKHC(3,KG,M)=SATKZ*AAAA
            AKHC(4,KG,M)=SATKXY*AAAA
            AKHC(5,KG,M)=SATKXZ*AAAA
            AKHC(6,KG,M)=SATKYZ*AAAA
            AKHC(7,KG,M)=RHO
  290    CONTINUE
  490 CONTINUE
      RETURN
      END
C
      SUBROUTINE SURF(X,IE,LRL,NLRL, DCOSB,ISB,NPBB,LRN,NLRN)
C
C ------- TO GENERATE BOUNDARY GEOMETRY.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
      COMMON /BLK1/ KGB(4,6,3)
C
      DIMENSION X(MAXNPK,3),IE(MAXELK,9),LRL(MXKBDK,MAXNPK),NLRL(MAXNPK)
      DIMENSION DCOSB(3,MXBESK),ISB(6,MXBESK),NPBB(MXBNPK)
      DIMENSION LRN(MXJBDK,MAXNPK),NLRN(MAXNPK)
      DIMENSION IEMI(4),KS(6)
C
      NBES=0
      NBNP=0
C
C ------- INITIATEL NLRN(1.. NNP) for being as a working array
C
      DO I=1,NNP
         NLRN(I)=0
      ENDDO
C
      DO 390 MI=1,NEL
         NODE = IJNOD(MI)
         NSIDE = NFACE(MI)
         IK = NIK(MI)
         DO II=1,6
            KS(II)=0
         ENDDO
         DO 380 LS=1,NSIDE
C
C ------- STORE FOUR GLOBAL NODAL NUMBERS OF LS-TH SIDE OF MI-TH
C ------- ELEMENT IN ARRAY IEMI(4) FOR LATER USE.
C
            DO IQ=1,4
               K=KGB(IQ,LS,IK)
               IF (K.NE.0) THEN
                  IEMI(IQ)=IE(MI,K)
               ELSE
                  IEMI(IQ)=0
               ENDIF
            ENDDO
C
C ------- CHECK IF THE LS-TH SIDE OF ELEMENT MI IS A BOUNDARY
C ------- SIDE BY LOOPING OVER ALL ELEMENTS CONNECTING TO THE
C ------- FOUR NODES OF THE SIDE TO SEE IF ANY OF THOSE ELEMENTS
C ------- CONTAINS THE SAME FOUR NODES.  IF YES, THEN LS IS NOT
C ------- A BOUNDARY SIDE.  IF NO, THEN LS IS A BOUNDARY SIDE.
C
            NOD1=IEMI(1)
            NOD2=IEMI(2)
            NOD3=IEMI(3)
            DO 220 MJ1=1,NLRL(NOD1)
               MM1=LRL(MJ1,NOD1)
               IF (MM1.EQ.MI) GOTO 220
               DO 210 MJ2=1,NLRL(NOD2)
                  MM2=LRL(MJ2,NOD2)
                  IF (MM1.NE.MM2) GOTO 210
                  DO 200 MJ3=1,NLRL(NOD3)
                     MM3=LRL(MJ3,NOD3)
                     IF (MM2.EQ.MM3) GOTO 380
  200             CONTINUE
  210          CONTINUE
  220       CONTINUE
C
C ------- AFTER LOOPING OVER ALL ELEMENTS CONNECTED TO THE FOUR NODES
C ------- OF THE LS-TH SIDE OF ELEMENT MI, WE CANNOT FIND ANY OF THOSE
C ------- ELEMENTS CONTAINING THE SAME FOUR NODES OF THE LS-SIDE OF
C ------- ELEMENT MI, HENCE THIS SIDE IS A BOUNDARY SIDE.
C
            NBES=NBES+1
            IF (NBES.GT.MXBESK) THEN
                WRITE(*,4001) NBES,MXBESK
 4001 FORMAT(5X,'NBES=',I5,' IS GREATER THAN MXBESK=',I5)
        call stopfile  ! emrl jig
                STOP
            ENDIF
            ISB(5,NBES)=LS
            ISB(6,NBES)=MI
            KS(LS)=1
C
C ------- COMPUTE DIRECTIONAL COSINES FOR THE NBES-TH SIDE.
C
            NI=IEMI(1)
            NJ=IEMI(2)
            A1=X(NJ,1)-X(NI,1)
            A2=X(NJ,2)-X(NI,2)
            A3=X(NJ,3)-X(NI,3)
            NJ=IEMI(3)
            B1=X(NJ,1)-X(NI,1)
            B2=X(NJ,2)-X(NI,2)
            B3=X(NJ,3)-X(NI,3)
            AB23=A2*B3-A3*B2
            AB31=A3*B1-A1*B3
            AB12=A1*B2-A2*B1
            AREA=DSQRT(AB23*AB23+AB31*AB31+AB12*AB12)
            DCOSB(1,NBES)=AB23/AREA
            DCOSB(2,NBES)=AB31/AREA
            DCOSB(3,NBES)=AB12/AREA
            IF (NODE.EQ.8 .AND. (LS.EQ.2 .OR. LS.EQ.3 .OR. LS.EQ.6))
     >         GOTO 305
            IF (NODE.EQ.6 .AND. LS.EQ.5) GOTO 305
            DCOSB(1,NBES)=-DCOSB(1,NBES)
            DCOSB(2,NBES)=-DCOSB(2,NBES)
            DCOSB(3,NBES)=-DCOSB(3,NBES)
  305       CONTINUE
            DO 310 IQ=1,4
               NI=IEMI(IQ)
               IF (NI.EQ.0) GOTO 310
               IF (NLRN(NI).NE.0) GOTO 310
               NBNP=NBNP+1
               IF (NBNP.GT.MXBNPK) THEN
                  WRITE(*,4002) NBNP,MXBNPK
 4002 FORMAT(5X,'NBNP=',I6,' IS GREATER THAN MXBNPK=',I6)
        call stopfile  ! emrl jig
                  STOP 'surf'
               ENDIF
               NPBB(NBNP)=NI
C
C ----- NOTE: NLRN IS TO BE USED AS A WORKING ARRAY. IT WILL BE
C             RECOMPUTED AT THE END OF THIS SUBROUTINE
C
               NLRN(NI)=NBNP
  310       CONTINUE
  380   CONTINUE
  390 CONTINUE
C
C ------ PRINT BOUNDARY NODE INFORMATION
C
      WRITE(25,3900)
      DO I=1,NBNP,6
         J1=I
         J2=MIN0(I+5,NBNP)
         WRITE(25,3950) (J,NPBB(J),J=J1,J2)
      ENDDO
  396 CONTINUE
C
C ----- check NBES > MXBESK ?
C
      IF (NBES.GT.MXBESK) THEN
            WRITE(*,4003) NBES,MXBESK
 4003 FORMAT(5X,'NBES=',I5,' IS GREATER THAN MXBESK=',I5)
        call stopfile  ! emrl jig
            STOP 'surf'
      ENDIF
C
C ------- COMPUTE THE COMPRESSED BOUNDARY NODE NUMBER FOR EACH OF THE
C ------- FOUR NODES OF A BOUNDARY SIDE
C
      DO 490 MP=1,NBES
         LS=ISB(5,MP)
         M=ISB(6,MP)
         NODE = IJNOD(M)
         IK= NIK(M)
C
         DO 460 IQ=1,4
            I=KGB(IQ,LS,IK)
            IF (I.NE.0)THEN
               NI=IE(M,I)
            ELSE
               NI=0
            ENDIF
            IF (NI.EQ.0)THEN
               ISB(IQ,MP)=0
               GOTO 460
            ENDIF
            NII=NLRN(NI)
            IF (NII.GT.NBNP) THEN
               WRITE(16,4000) IQ,MP
 4000 FORMAT(10X,' CAN NOT FIND A COMPRESSED BOUNDARY NODE',
     1             ' FOR',I2,'-TH POINT OF',I4,'-TH BOUNDARY SIDE',
     2             ' --- STOP')
	       call stopfile  ! emrl jig
               STOP
            ENDIF
            ISB(IQ,MP)=NII
  460   CONTINUE
  490 CONTINUE
C
C ------ RECOMPUTE NLRN
C
      DO 500 NP=1,NNP
         DO K=1,MXJBDK
            IF (LRN(K,NP).EQ.0)THEN
               NLRN(NP)=K-1
               GOTO 500
            ENDIF
         ENDDO
         NLRN(NP)=MXJBDK
  500 CONTINUE
C
C ------- PRINT BOUNDARY SIDE INFORMATION
C
      WRITE(25,6900)
      DO MP=1,NBES
         WRITE(25,6950) MP,(DCOSB(I,MP),I=1,3),(ISB(I,MP),I=1,6)
      ENDDO
 3900 FORMAT(1H1//10X,' **** COMPUTED BOUNDARY NODE DATA ****'//5X,
     1 6('    I NPBB',2X)/5X,6('    - ----',2X))
 3950 FORMAT(1H ,4X,6(2I5,2X))
 6900 FORMAT(1H1//10X,' *** COMPUTED BOUNDARY ELEMENT SIDE INFORMATION',
     1 '***'//5X,'   MP     DCOSXB         DCOSYB         DCOSZB',
     2 '     BP1 BP2 BP3 BP4  LS    M'/5X,
     3 '   --     ------         ------         ------    ',
     4 ' --- --- --- ---  --    -')
 6950 FORMAT(1H ,4X,I5,3D15.6,5I4,I5)
      RETURN
      END
C
      SUBROUTINE FQ468DV (QRX,QRY,QRZ, AKXQ,AKYQ,AKZQ,
     1 AKXYQ,AKXZQ,AKYZQ,RHOKG,HQ,NODE, M)
C
C ---- To compute the integration of N(I)*N(J) AND -N(I)*K.GRAD(HT)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      REAL*8 N(8)
C
      COMMON /JACOB1/ RNH(8,8),RNP(6,6),RNT(4,4)
      COMMON /JACOB2/ DJACS(8,MAXELK)
      COMMON /JACOB5/ DJACN(8,8,MAXELK)
      COMMON /DXYZ1/ DNXS(8,8,MAXELK)
      COMMON /DXYZ2/ DNYS(8,8,MAXELK)
      COMMON /DXYZ3/ DNZS(8,8,MAXELK)
C
      DIMENSION QRX(8),QRY(8),QRZ(8),RHOKG(8),HQ(8)
      DIMENSION AKXQ(8),AKYQ(8),AKZQ(8),AKXYQ(8),AKXZQ(8),AKYZQ(8)
      DIMENSION DNX(8),DNY(8),DNZ(8)
C
C ------- INITIATE MATRICES QB(IQ,JQ), QRX(IQ),QRY(IQ) & QRZ(IQ)
C
      DO IQ=1,8
         QRX(IQ)=0.0D0
         QRY(IQ)=0.0D0
         QRZ(IQ)=0.0D0
      ENDDO
C
C ------- SUMMATION OF THE INTEGRAND OVER THE GAUSSIAN POINTS
C
      DO 490 KG=1,NODE
C
         DJAC=DJACS(KG,M)
         DO I=1,NODE
            DNX(I)=DNXS(I,KG,M)
            DNY(I)=DNYS(I,KG,M)
            DNZ(I)=DNZS(I,KG,M)
         ENDDO
         IF (NODE.EQ.8) THEN
            DO I=1,8
               N(I)=RNH(I,KG)
            ENDDO
         ELSEIF(NODE.EQ.6) THEN
            DO I=1,6
               N(I)=RNP(I,KG)
            ENDDO
         ELSEIF(NODE.EQ.4) THEN
            DO I=1,4
               N(I)=RNT(I,KG)
            ENDDO
         ENDIF
C
         AKXK=AKXQ(KG)
         AKYK=AKYQ(KG)
         AKZK=AKZQ(KG)
         AKXYK=AKXYQ(KG)
         AKXZK=AKXZQ(KG)
         AKYZK=AKYZQ(KG)
         RHOK=RHOKG(KG)
         A1 = DJAC/RHOK
C
C ------- ACCUMULATE THE SUMS TO OBTAIN THE MATRIX INTEGRALS QB(IQ,JQ)
C ------- AND QRX(IQ), QRY(IQ), AND QRZ(IQ)
C
         DO IQ=1,NODE
            B1 = DJACN(IQ,KG,M)
            QRX(IQ)=QRX(IQ)- B1*AKXZK
            QRY(IQ)=QRY(IQ)- B1*AKYZK
            QRZ(IQ)=QRZ(IQ)- B1*AKZK
C
            DO JQ=1,NODE
               A2 = N(IQ)*HQ(JQ)*A1
C
               QRX(IQ)=QRX(IQ)- A2*(AKXK*DNX(JQ)+AKXYK*DNY(JQ)
     1                +AKXZK*DNZ(JQ))
               QRY(IQ)=QRY(IQ)- A2*(AKXYK*DNX(JQ)+AKYK*DNY(JQ)
     1                +AKYZK*DNZ(JQ))
               QRZ(IQ)=QRZ(IQ)- A2*(AKXZK*DNX(JQ)+AKYZK*DNY(JQ)
     1                +AKZK*DNZ(JQ))
            ENDDO
         ENDDO
  490 CONTINUE
      RETURN
      END
C
      SUBROUTINE DISPC(AKDC,IE,V,VP,TH,THP, PROPT)
C
C ------- TO COMPUTE HARMONIC MEAN DISPERSION COEFFICIENTS AT NODES
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      REAL*8 N(8)
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /TREAL/ OMET,OMIT,TOLBT
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
      COMMON /JACOB1/ RNH(8,8),RNP(6,6),RNT(4,4)
C
      DIMENSION IE(MAXELK,9),AKDC(6,8,MAXELK),
     1          V(MAXNPK,3),VP(MAXNPK,3),TH(8,MAXELK)
      DIMENSION THP(8,MAXELK),PROPT(13,MXMATK)
C
      DIMENSION VXQ(8),VYQ(8),VZQ(8),VXG(8),VYG(8),VZG(8),THG(8)
C
      W1=WF
      W2=1.0D0 - WF
C
C ******* COMPUTE DISPERSION COEFFICIENT
C
      DO 690 M=1,NEL
         NODE=IJNOD(M)
         DO IQ=1,NODE
            NP=IE(M,IQ)
            VXQ(IQ)=V(NP,1)*W1+VP(NP,1)*W2
            VYQ(IQ)=V(NP,2)*W1+VP(NP,2)*W2
            VZQ(IQ)=V(NP,3)*W1+VP(NP,3)*W2
         ENDDO
C
         MTYP=IE(M,9)
         AL=PROPT(3,MTYP)
         AT=PROPT(4,MTYP)
         AM=PROPT(5,MTYP)
         TAU=PROPT(6,MTYP)
         DD=AM*TAU
         ALAT=AL-AT
C
C ------- Evaluate velocity component at gaussian points
C
         DO 650 KG=1,NODE
            IF (NODE.EQ.8)THEN
                DO I=1,8
                   N(I)=RNH(I,KG)
                ENDDO
            ELSEIF(NODE.EQ.6)THEN
                DO I=1,6
                   N(I)=RNP(I,KG)
                ENDDO
            ELSE
                DO I=1,4
                   N(I)=RNT(I,KG)
                ENDDO
            ENDIF
C
            THG(KG)=W1*TH(KG,M) + W2*THP(KG,M)
            VXG(KG)=0.0D0
            VYG(KG)=0.0D0
            VZG(KG)=0.0D0
            DO IQ=1,NODE
               VXG(KG)=VXG(KG)+VXQ(IQ)*N(IQ)
               VYG(KG)=VYG(KG)+VYQ(IQ)*N(IQ)
               VZG(KG)=VZG(KG)+VZQ(IQ)*N(IQ)
            ENDDO
C
            VXX=VXG(KG)*VXG(KG)
            VYY=VYG(KG)*VYG(KG)
            VZZ=VZG(KG)*VZG(KG)
            VG=DSQRT(VXX+VYY+VZZ)
            IF (VG .EQ. 0.0D0) GO TO 640
            VGI=1.0D0/VG
            DDTHG = DD*THG(KG)
            AKDC(1,KG,M)=(AL*VXX+AT*(VYY+VZZ))*VGI + DDTHG
            AKDC(2,KG,M)=(AL*VYY+AT*(VZZ+VXX))*VGI + DDTHG
            AKDC(3,KG,M)=(AL*VZZ+AT*(VXX+VYY))*VGI + DDTHG
            AKDC(4,KG,M)= ALAT*VXG(KG)*VYG(KG)*VGI
            AKDC(5,KG,M)= ALAT*VXG(KG)*VZG(KG)*VGI
            AKDC(6,KG,M)= ALAT*VYG(KG)*VZG(KG)*VGI
            GO TO 650
  640       AKDC(1,KG,M)=DDTHG
            AKDC(2,KG,M)=DDTHG
            AKDC(3,KG,M)=DDTHG
            AKDC(4,KG,M)=0.0D0
            AKDC(5,KG,M)=0.0D0
            AKDC(6,KG,M)=0.0D0
  650       CONTINUE
  690 CONTINUE
      RETURN
      END
C
      SUBROUTINE AFABTA(WETAB,X,IE,V,VP,THN,PROPT)
C
C ------- TO CALCULATE THE WEIGHTING FACTORS ON ALL THE SIDES OF EACH
C ------- ELEMENT.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /TREAL/ OMET,OMIT,TOLBT
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      DIMENSION X(MAXNPK,3),IE(MAXELK,9),WETAB(12,MAXELK)
      DIMENSION V(MAXNPK,3),VP(MAXNPK,3),THN(MAXNPK)
      DIMENSION PROPT(13,MXMATK),NODE(8)
C
      W1=WF
      W2=1.0D0-WF
C
      DO 490 M=1,NEL
         MTYP=IE(M,9)
         AL=PROPT(3,MTYP)
         AT=PROPT(4,MTYP)
         DD=PROPT(5,MTYP)*PROPT(6,MTYP)
         ALAT=AL-AT
         NNQ=IJNOD(M)
         NQ =NEDGE(M)
C
         DO IQ=1,NNQ
            NODE(IQ)=IE(M,IQ)
         ENDDO
         DO 390 I=1,NQ
            IF (NQ.EQ.12) THEN
              GOTO (321,322,323,324,325,326,327,328,329,330,331,332),I
            ELSEIF (NQ.EQ.9) THEN
              GOTO (311,312,313,314,315,316,317,318,319),I
            ELSE
              GOTO (301,302,303,304,305,306),I
            ENDIF
  301       N1=NODE(1)
            N2=NODE(2)
            KG1=1
            KG2=2
            GOTO 350
  302      N1=NODE(1)
           N2=NODE(3)
           KG1=1
           KG2=3
           GOTO 350
  303      N1=NODE(1)
           N2=NODE(4)
           KG1=1
           KG2=4
           GOTO 350
  304      N1=NODE(2)
           N2=NODE(3)
           KG1=2
           KG2=3
           GOTO 350
  305      N1=NODE(2)
           N2=NODE(4)
           KG1=2
           KG2=4
           GOTO 350
  306      N1=NODE(3)
           N2=NODE(4)
           KG1=3
           KG2=4
           GOTO 350
  311      N1=NODE(1)
           N2=NODE(2)
           KG1=1
           KG2=2
           GOTO 350
  312      N1=NODE(2)
           N2=NODE(3)
           KG1=2
           KG2=3
           GOTO 350
  313      N1=NODE(1)
           N2=NODE(3)
           KG1=1
           KG2=3
           GOTO 350
  314      N1=NODE(4)
           N2=NODE(5)
           KG1=4
           KG2=5
           GOTO 350
  315      N1=NODE(5)
           N2=NODE(6)
           KG1=5
           KG2=6
           GOTO 350
  316      N1=NODE(4)
           N2=NODE(6)
           KG1=4
           KG2=6
           GOTO 350
  317      N1=NODE(1)
           N2=NODE(4)
           KG1=1
           KG2=4
           GOTO 350
  318      N1=NODE(2)
           N2=NODE(5)
           KG1=2
           KG2=5
           GOTO 350
  319      N1=NODE(3)
           N2=NODE(6)
           KG1=3
           KG2=6
           GOTO 350
  321      N1=NODE(1)
           N2=NODE(2)
           KG1=1
           KG2=2
           GO TO 350
  322      N1=NODE(4)
           N2=NODE(3)
           KG1=4
           KG2=3
           GO TO 350
  323      N1=NODE(5)
           N2=NODE(6)
           KG1=5
           KG2=6
           GO TO 350
  324      N1=NODE(8)
           N2=NODE(7)
           KG1=8
           KG2=7
           GO TO 350
  325      N1=NODE(1)
           N2=NODE(4)
           KG1=1
           KG2=4
           GO TO 350
  326      N1=NODE(2)
           N2=NODE(3)
           KG1=2
           KG2=3
           GO TO 350
  327      N1=NODE(5)
           N2=NODE(8)
           KG1=5
           KG2=8
           GO TO 350
  328      N1=NODE(6)
           N2=NODE(7)
           KG1=6
           KG2=7
           GO TO 350
  329      N1=NODE(1)
           N2=NODE(5)
           KG1=1
           KG2=5
           GO TO 350
  330      N1=NODE(2)
           N2=NODE(6)
           KG1=2
           KG2=6
           GO TO 350
  331      N1=NODE(3)
           N2=NODE(7)
           KG1=3
           KG2=7
           GO TO 350
  332      N1=NODE(4)
           N2=NODE(8)
           KG1=4
           KG2=8
  350      DISTX=X(N2,1)-X(N1,1)
           DISTY=X(N2,2)-X(N1,2)
           DISTZ=X(N2,3)-X(N1,3)
           DIST=DSQRT(DISTX*DISTX+DISTY*DISTY+DISTZ*DISTZ)
           DCSX=DISTX/DIST
           DCSY=DISTY/DIST
           DCSZ=DISTZ/DIST
           VXX=0.5D0*((V(N1,1)+V(N2,1))*W1+(VP(N1,1)+VP(N2,1))*W2)
           VYY=0.5D0*((V(N1,2)+V(N2,2))*W1+(VP(N1,2)+VP(N2,2))*W2)
           VZZ=0.5D0*((V(N1,3)+V(N2,3))*W1+(VP(N1,3)+VP(N2,3))*W2)
           THE=0.5D0*(THN(N1)+THN(N2))
           DDTHE=DD*THE
           VX2=VXX*VXX
           VY2=VYY*VYY
           VZ2=VZZ*VZZ
           VV=DSQRT(VX2+VY2+VZ2)
           IF (VV.EQ.0.0D0) GOTO 370
           VAL=VXX*DCSX+VYY*DCSY+VZZ*DCSZ
           VEL=DIST*VAL
           VVI=1.0D0/VV
C
           IF (VVI.NE.0.0D0) THEN
              DXX=(AL*VX2+AT*(VY2+VZ2))*VVI + DDTHE
              DYY=(AL*VY2+AT*(VZ2+VX2))*VVI + DDTHE
              DZZ=(AL*VZ2+AT*(VX2+VY2))*VVI + DDTHE
              DXY= ALAT*VXX*VYY*VVI
              DXZ= ALAT*VXX*VZZ*VVI
              DYZ= ALAT*VYY*VZZ*VVI
           ELSE
              DXX=DDTHE
              DYY=DDTHE
              DZZ=DDTHE
              DXY=0.0D0
              DXZ=0.0D0
              DYZ=0.0D0
          ENDIF
C
          DAL=DABS(DCSX*(DCSX*DXX+DCSY*DXY+DCSZ*DXZ)+DCSY*(DCSX*DXY+
     1        DCSY*DYY+DCSZ*DYZ)+DCSZ*(DCSX*DXZ+DCSY*DYZ+DCSZ*DZZ))
          DISP=2.0D0*DAL
C
          WETAB(I,M)=1.0D0
          IF (VEL.LT.0.0D0) WETAB(I,M)=-1.0D0
          IF (VEL.EQ.0.0D0) WETAB(I,M)=0.0D0
          IF (DISP.EQ.0.0D0) GO TO 390
          IF (DABS(VEL/DISP).LT.1.0D-10) WETAB(I,M)=0.0D0
  390     CONTINUE
          GO TO 490
  370     WETAB(I,M)=0.0D0
  490 CONTINUE
      RETURN
      END
C
      SUBROUTINE THNPON (THNPV,H,IE,LRL,NLRL)
C
C ------- COMPUTE MOISTURE CONTENT AT NODAL POINTS.
C         entire subroutine revised 5/20/98
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
      COMMON /THN1/ VOLELM(MAXELK),VOLNP(MAXNPK)
C
      COMMON /SPCARD/ NUNSAT,NSP(MXMATK),IHM(MXMATK),IHC(MXMATK),
     1       IHW(MXMATK),NPMC(MXMATK),NPCON(MXMATK),NPWC(MXMATK)
      COMMON /UNSAT/ PH(MXSPMK,MXMATK),PMC(MXSPMK,MXMATK),
     1               PCON(MXSPMK,MXMATK),CONDUC(MXSPMK,MXMATK),
     2               PWC(MXSPMK,MXMATK),WC(MXSPMK,MXMATK),
     &               PMKNOT(MXSPMK + 4, MXMATK), PCKNOT(MXSPMK + 4,
     &               MXMATK), PWKNOT(MXSPMK + 4, MXMATK),
     &               PMCOEF(MXSPMK, MXMATK), PCCOEF(MXSPMK, MXMATK),
     &               PWCOEF(MXSPMK, MXMATK), IBSPL
C
      DIMENSION THNPV(MAXNPK),IE(MAXELK,9)
      DIMENSION LRL(MXKBDK,MAXNPK),NLRL(MAXNPK)
      DIMENSION H(MAXNPK)
C
      DO NP=1,NNP
         HNP=H(NP)
         SUM=0.0D0
         SUMPV=0.0D0
         DO J=1,NLRL(NP)
            M=LRL(J,NP)
            MTYP=IE(M,9)
            NUMMC=NPMC(MTYP)
C
            IF (IBSPL .EQ. 1) THEN
              CALL BSINT (PH(1, MTYP), PMC(1, MTYP), NUMMC, PMKNOT(1,
     &          MTYP), PMCOEF(1, MTYP), HNP, TH)
            ELSE
              CALL LININT (PH(1, MTYP), PMC(1, MTYP), NUMMC,
     &          HNP, TH)
            END IF
C
            SUMPV = SUMPV + TH * VOLELM(M)
            SUM = SUM + VOLELM(M)
         ENDDO
         THNPV(NP)=SUMPV/SUM
      ENDDO
C
      RETURN
      END
C
      SUBROUTINE THNODE(THN,TH,THP,PROPF,PROPT,IE,KSORP)
C
C ------- TO MOISTURE CONTENT AT NODAL POINTS.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /TREAL/ OMET,OMIT,TOLBT
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
      COMMON /THN1/ VOLELM(MAXELK),VOLNP(MAXNPK)
C
      DIMENSION IE(MAXELK,9),TH(8,MAXELK),THP(8,MAXELK),THN(MAXNPK,2),
     1  PROPF(9,MXMATK), PROPT(13,MXMATK)
C
      W1=WF
      W2=1.0D0-WF
C
      DO NP=1,NNP
         THN(NP,1)=0.0D0
         THN(NP,2)=0.0D0
      ENDDO
C
      DO 290 M=1,NEL
         MTYP=IE(M,9)
         RHOB=0.0D0
         RKD=0.0D0
         IF (KSORP.EQ.1) THEN
            RHOB=PROPT(2,MTYP)
            RKD=PROPT(1,MTYP)
         ENDIF
C
C         Modify for fraction of mobile water.
C
         FM=PROPT(13,MTYP)
         POR=PROPF(8,MTYP)
         THI=(1.0D0-FM)*POR
         RR=RHOB*RKD*FM
         NQ=IJNOD(M)
         DO IQ=1,NQ
           NP=IE(M,IQ)
           T1=W1*TH(IQ,M)+W2*THP(IQ,M)-THI
           THN(NP,1)=THN(NP,1)+(T1+RR)*VOLELM(M)
           THN(NP,2)=THN(NP,2)+T1*VOLELM(M)
        ENDDO
  290 CONTINUE
C
      DO NP=1,NNP
         THN(NP,1)=THN(NP,1)/VOLNP(NP)
         THN(NP,2)=THN(NP,2)/VOLNP(NP)
      ENDDO
      RETURN
      END
C
      SUBROUTINE FLUX (F,C,IE,V, AKDC)
C
C ------- TO COMPUTE THE MATERIAL FLUXES.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /WETX/ APHA1,APHA2,APHA3,APHA4
      COMMON /WETY/ BETA1,BETA2,BETA3,BETA4
      COMMON /WETZ/ GAMA1,GAMA2,GAMA3,GAMA4
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /JACOB3/ QBS(8,8,MAXELK)
      COMMON /JACOB6/ CMX(MAXNPK)
C
      DIMENSION IE(MAXELK,9),C(MAXNPK),V(MAXNPK,3),F(MAXNPK,3),
     1          AKDC(6,8,MAXELK)
      DIMENSION QRX(8),QRY(8),QRZ(8),CQ(8),AKXYZQ(6,8)
C
C ------- INITIALIZE THE FLUX FX(NP), FY(NP), AND FZ(NP).
C
      DO NP=1,NNP
         F(NP,1)=0.0D0
         F(NP,2)=0.0D0
         F(NP,3)=0.0D0
      ENDDO
C
C ------- COMPUTE THE FLUX COMPONENTS BY APPLYING THE FINITE ELEMENT
C ------- METHOD TO THE DISPERSION TERMS
C ------- COMPUTE THE ELEMENT MATRIX QB AND QRX, QRY, & QRZ
C
      DO 290 M=1,NEL
C
         NODE = IJNOD(M)
         APHA1=0.0D0
         APHA2=0.0D0
         APHA3=0.0D0
         APHA4=0.0D0
         BETA1=0.0D0
         BETA2=0.0D0
         BETA3=0.0D0
         BETA4=0.0D0
         GAMA1=0.0D0
         GAMA2=0.0D0
         GAMA3=0.0D0
         GAMA4=0.0D0
         DO IQ=1,NODE
            NP=IE(M,IQ)
            CQ(IQ)=C(NP)
            DO I=1,6
               AKXYZQ(I,IQ)=AKDC(I,IQ,M)
            ENDDO
         ENDDO
C
         CALL TQ468DV (QRX,QRY,QRZ,CQ,AKXYZQ,NODE, M)
C
C ------- ASSEMBLE QB(IQ,JQ) INTO THE GLOBAL MATRIX C(NP,1) AND
C ------- FORM THE LOAD VECTOR FX(NP), FY(NY), AND FZ(NP)
C
         DO IQ=1,NODE
            NI=IE(M,IQ)
            F(NI,1)=F(NI,1)+QRX(IQ)
            F(NI,2)=F(NI,2)+QRY(IQ)
            F(NI,3)=F(NI,3)+QRZ(IQ)
         ENDDO
  290 CONTINUE
C
C ------- SOLVE THE MATRIX EQUATION CX=B
C
      DO NP=1,NNP
         F(NP,1)=F(NP,1)/CMX(NP)
         F(NP,2)=F(NP,2)/CMX(NP)
         F(NP,3)=F(NP,3)/CMX(NP)
      ENDDO
C
C ------ ADD THE ADVECTION FLUX TO DISPERSION FLUX
C
       DO NP=1,NNP
          F(NP,1)=F(NP,1)+V(NP,1)*C(NP)
          F(NP,2)=F(NP,2)+V(NP,2)*C(NP)
          F(NP,3)=F(NP,3)+V(NP,3)*C(NP)
      ENDDO
      RETURN
      END
C
      SUBROUTINE TQ468DV (QRX,QRY,QRZ, CQ,AKXYZQ,NODE, M)
C
C ------- TO COMPUTE THE INTEGRATION OF N(I)*N(J) AND -N(I)*D>GRAD(C)
C ------- OVER AN ELEMENT.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      REAL*8 N(8)
C
      COMMON /JACOB1/ RNH(8,8),RNP(6,6),RNT(4,4)
      COMMON /JACOB2/ DJACS(8,MAXELK)
      COMMON /DXYZ1/ DNXS(8,8,MAXELK)
      COMMON /DXYZ2/ DNYS(8,8,MAXELK)
      COMMON /DXYZ3/ DNZS(8,8,MAXELK)
C
      DIMENSION QRX(8),QRY(8),QRZ(8),CQ(8)
      DIMENSION AKXYZQ(6,8),AKXYZK(6),DNX(8),DNY(8),DNZ(8)
C
C ------- INITIATE MATRICES  QRX(IQ), QRY(IQ) & QRZ(IQ)
C
      DO IQ=1,NODE
         QRX(IQ)=0.0D0
         QRY(IQ)=0.0D0
         QRZ(IQ)=0.0D0
      ENDDO
C
C ------- SUMMATION OF THE INTEGRAND OVER THE GAUSSIAN POINTS
C
      DO 490 KG=1,NODE
C
C ------- DETERMINE LOACAL COORDINATE OF GAUSSIAN POINT KG
C
         DJAC=DJACS(KG,M)
         DO I=1,NODE
            DNX(I)=DNXS(I,KG,M)
            DNY(I)=DNYS(I,KG,M)
            DNZ(I)=DNZS(I,KG,M)
         ENDDO
C
         IF (NODE.EQ.8) THEN
            DO I=1,8
               N(I)=RNH(I,KG)
            ENDDO
         ELSEIF(NODE.EQ.6) THEN
            DO I=1,6
               N(I)=RNP(I,KG)
            ENDDO
         ELSEIF(NODE.EQ.4) THEN
             DO I=1,4
                N(I)=RNT(I,KG)
             ENDDO
         ENDIF
C
C ------- CALCULATE VALUES OF BASIS FUNCTIONS N(IQ) AND THEIR
C ------- DERIVATIVES DNX(IQ), DNY(IQ), AND DNZ(IQ), W.R.T. TO
C ------- X, Y, AND Z, RESPECTIVELY, AT THE GAUSSIAN POINT KG.
C
         DO I=1,6
            AKXYZK(I)=AKXYZQ(I,KG)
         ENDDO
C
         AKXK=AKXYZK(1)*DJAC
         AKYK=AKXYZK(2)*DJAC
         AKZK=AKXYZK(3)*DJAC
         AKXYK=AKXYZK(4)*DJAC
         AKXZK=AKXYZK(5)*DJAC
         AKYZK=AKXYZK(6)*DJAC
C
C ------- ACCUMULATE THE SUMS TO OBTAIN THE MATRIX INTEGRALS QB(IQ,JQ)
C ------- AND QRX(IQ), QRY(IQ), AND QRZ(IQ)
C
         DO 390 IQ=1,NODE
            DO JQ=1,NODE
               A1 = N(IQ)*CQ(JQ)
              QRX(IQ)=QRX(IQ)- A1*(AKXK*DNX(JQ)+AKXYK*DNY(JQ)
     1              +AKXZK*DNZ(JQ))
              QRY(IQ)=QRY(IQ)- A1*(AKXYK*DNX(JQ)+AKYK*DNY(JQ)
     1              +AKYZK*DNZ(JQ))
              QRZ(IQ)=QRZ(IQ)- A1*(AKXZK*DNX(JQ)+AKYZK*DNY(JQ)
     1              +AKZK*DNZ(JQ))
            ENDDO
  390 CONTINUE
  490 CONTINUE
      RETURN
      END
C
      SUBROUTINE GNTRAK (IE, X, CP, V, CS, FKEEP, CBACK, FLAG)
C
C
C         THIS SUBROUTINE DOES THE BACK-TRACKING IN EACH ELEMENT
C         IN A SIMPLIFIED WAY.  RATHER THAN DO A COMPLICATED
C         TRACKING THROUGH SUB-ELEMENTS, THE TIME STEP IS DIVIDED
C         BY NXW TO HOPEFULLY ALLOW TRACKING ONLY IN THE NEIGHBORING
C         ELEMENTS.  IF IT GOES OUTSIDE THE NEIGHBORING ELEMENTS,
C         THE TIME STEP IS FURTHER DIVIDED.  THIS WAY, BOTH THE CODE
C         AND PARALLELIZATION IS GREATLY SIMPLIFIED.
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP, NEL, NBNP, NTUBS, NBES, ISHAPE
      COMMON /SAZFM/ NXW, NYW, NZW, IDETQ
      COMMON /BLKFT3/ DCOSB(3, MXBESK), ISB(6,MXBESK), NPBB(MXBNPK),
     &  IB(MAXNPK)
      COMMON /TTIME/ DELT, TMAX, STIME
      COMMON  /BLKFT1/ LRN(MXJBDK, MAXNPK), LRL(MXKBDK, MAXNPK),
     &  NLRL(MAXNPK), ND(MAXNPK), NLRN(MAXNPK)
C
      DIMENSION X(MAXNPK, 3), IE(MAXELK, 9), V(MAXNPK, 3)
      DIMENSION CP(MAXNPK), CS(MAXNPK), CBACK(MAXNPK), FLAG(MAXNPK),
     &  FKEEP(MAXNPK), OUTEL(MAXNPK)
C
C         FLAG THE BOUNDARY NODES ALREADY SET.
C
      DO N = 1, NNP
        FKEEP(N) = 0.0D0
        IF (CS(N) .GT. -1.0D10) THEN
          FKEEP(N) = 1.0D0
        END IF
      END DO
C
      JSUB = NXW
      ISTOP = 0
      I = 0
C
      DO WHILE ((ISTOP .EQ. 0) .AND. (I .LT. 20))
C
        I = I + 1
        DTSUB = DELT / DBLE (JSUB)
C
        DO N = 1, NNP
          CBACK(N) = CP(N)
        END DO
C
C         DO ALL THE SUB-TIME STEPS.
C
        JSTOP = 0
        J = 0
C
        DO WHILE ((JSTOP .EQ. 0) .AND. (J .LT. JSUB))
C
          J = J + 1
C
C         FLAG NODES WHEN FINISHED.
C
          DO N = 1, NNP
            FLAG(N) = 0.0D0
            OUTEL(N) = 1.0D20
          END DO
C
C         TRACK EACH NODE.
C
          DO N = 1, NNP
C
C         IF CSTAR HAS ALREADY BEEN COMPUTED, SET FLAG.
C
            IF (FKEEP(N) .EQ. 1.0D0) THEN
C
              FLAG(N) = 1.0D0
C
C         IF THE VELOCITY IS ZERO, KEEP THE SAME CONCENTRATION.
C
            ELSE IF ((V(N, 1) .EQ. 0.0D0) .AND. (V(N, 2) .EQ. 0.0D0)
     &        .AND. (V(N, 3) .EQ. 0.0D0)) THEN
C
              CS(N) = CP(N)
              FLAG(N) = 1.0D0
C
            ELSE
C
C         CONSIDER NEIGHBORING ELEMENTS.
C
              NLRLN = NLRL(N)
              KSTOP = 0
              K = 0
C
              DO WHILE ((KSTOP .EQ. 0) .AND. (K .LT. NLRLN))
C
                K = K + 1
                M = LRL(K, N)
C
C         CHECK THE ELMENT.
C
                CALL ELTRK (N, M, IE, X, CP, V, DTSUB, CS,
     &            CBACK, FLAG, OUTEL)
                IF (FLAG(N) .EQ. 1.0D0) THEN
                  KSTOP = 1
                END IF
C
              END DO
C
            END IF
C
          END DO
C
          DO N = 1, NNP
C
C         FIX ANY BOUNDARY NODES THAT WERE BACK-TRACKED OUTSIDE
C         THE REGION.
C
            IF (FLAG(N) .EQ. 2.0D0) THEN
C
              CS(N) = CBACK(N)
              FLAG(N) = 1.0D0
C
C         FIX THE NODES THAT SETTLED FOR SLIGHTLY OUTSIDE ALL THE
c         ELEMENTS.
C
            ELSE IF (FLAG(N) .EQ. 4.0D0) THEN
C
              FLAG(N) = 1.0D0
C
            END IF
C
          END DO
C
C         CHECK IF ALL THE NODES WERE ASSIGNED A CONCENTRATION VALUE.
C
          IOK = 1
          DO N = 1, NNP
            IF ((FLAG(N) .EQ. 0.0D0) .OR. (FLAG(N) .EQ. 3.0D0)) THEN
              IOK = 0
            END IF
          END DO
C
C         START OVER IF ALL WERE NOT SET.  OTHERWISE, GET READY
C         FOR THE NEXT SUB TIME STEP.
C
          IF (IOK .EQ. 0) THEN
C
            JSUB = JSUB * 2
            JSTOP = 1
C
          ELSE
C
            DO N = 1, NNP
              CBACK(N) = CS(N)
            END DO
C
          END IF
C
        END DO
C
C         IF THE WHOLE BUNCH OF SUB-DATA SETS WERE COMPLETED, STOP
C         THE PROCESS.
C
        IF (JSTOP .EQ. 0) THEN
          ISTOP = 1
        END IF
C
      END DO
C
C         RECTIFY ANY PROBLEM NODES.
C
      IF (ISTOP .EQ. 0) THEN
        WRITE(*,5423)
 5423 FORMAT(' First Ten Problem Nodes')
        ITEN = 0
        DO N = 1, NNP
          IF (FLAG(N) .NE. 1.0D0) THEN
            ITEN = ITEN + 1
            if (ITEN .LE. 10) THEN
              WRITE(*,5424) N
 5424 FORMAT(' Node = ',I7)
            END IF
            CS(N) = CBACK(N)
          END IF
        END DO
      END IF
C
      RETURN
      END
C
      SUBROUTINE ELTRK (N, M, IE, X, CP, V, DTSUB, CS,
     &  CBACK, FLAG, OUTEL)
C
C
C         THIS SUBROUTINE CHECKS THE ELEMENT TO SEE IF THE NEW POINT
C         EITHER IS INSIDE THE ELEMENT OR THE RAY XP - XQ INTERSECTS
C         A BOUNDARY FACE OF THE ELEMENT.
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CELEM/ IJNOD(MAXELK), NIK(MAXELK), NFACE(MAXELK),
     &  NEDGE(MAXELK)
      COMMON /BLKFT3/ DCOSB(3, MXBESK), ISB(6,MXBESK), NPBB(MXBNPK),
     &  IB(MAXNPK)
C
      DIMENSION X(MAXNPK, 3), IE(MAXELK, 9), V(MAXNPK, 3)
      DIMENSION CP(MAXNPK), CS(MAXNPK), CBACK(MAXNPK), FLAG(MAXNPK)
      DIMENSION OUTEL(MAXNPK)
C
      DIMENSION XX(8, 3), XXP(3), XXQ(3), XXDEL(3), CC(8)
C
C         COLLECT COORDINATE DATA FOR THIS ELEMENT.
C
      DO I = 1, 3
        XXP(I) = X(N, I)
      END DO
C
      NODE = IJNOD(M)
      DO I = 1, NODE
        NN = IE(M, I)
        DO J = 1, 3
          XX(I, J) = X(NN, J)
        END DO
        CC(I) = CBACK(NN)
      END DO
C
C         MOVE THE GIVEN NODE POINT BACKWARD IN TIME ACCORDING
C         TO ITS VELOCITY.
C
      T1 = 0.1D0 / DSQRT (V(N, 1) * V(N, 1) + V(N, 2) * V(N, 2) +
     &  V(N, 3) * V(N, 3))
      DO I = 1, 3
        XXQ(I) = - V(N, I) * DTSUB + XXP(I)
        XXDEL(I) = - V(N, I) * T1 + XXP(I)
      END DO
C
      NODE = IJNOD(M)
C
C         CHECK IF THE NEW POINT (XQ, YQ, ZQ) IS INSIDE THE ELEMENT.
C         IF SO, COMPUTE THE NEW VALUE OF CONCENTRATION.
C
      IF (NODE .EQ. 8) THEN
C
C         BRICK ELEMENT.
C
        CALL BRKINS (N, XX, XXQ, CC, CS, FLAG, OUTEL)
C
      ELSE IF (NODE .EQ. 6) THEN
C
C         PRISM ELEMENT.
C
        CALL PRSINS (N, XX, XXQ, CC, CS, FLAG, OUTEL)
C
      ELSE IF (NODE .EQ. 4) THEN
C
C         TETRAHEDRAL ELEMENT.
C
        CALL TETINS (N, XX, XXQ, CC, CS, FLAG, OUTEL)
C
      END IF
C
C         IF THE POINT IS NOT INSIDE, CHECK FOR A BOUNDARY NODE
C         BEING OUTSIDE THE ENTIRE REGION.  DO THIS BY MOVING
C         (XP, YP, ZP) A SMALL AMOUNT AND SEEING IF IT IS OUTSIDE
C         THE NEIGHBORING ELEMENTS.
C
      IF ((IB(N) .NE. 0) .AND. (FLAG(N) .NE. 1.0D0) .AND.
     &  (FLAG(N) .NE. 3.0D0) .AND. (FLAG(N) .NE. 4.0D0)) THEN
C
        IF (NODE .EQ. 8) THEN
C
C         BRICK ELEMENT.
C
          CALL BRKINS (N, XX, XXDEL, CC, CS, FLAG, OUTEL)
C
        ELSE IF (NODE .EQ. 6) THEN
C
C         PRISM ELEMENT.
C
          CALL PRSINS (N, XX, XXDEL, CC, CS, FLAG, OUTEL)
C
        ELSE IF (NODE .EQ. 4) THEN
C
C         TETRAHEDRAL ELEMENT.
C
          CALL TETINS (N, XX, XXDEL, CC, CS, FLAG, OUTEL)
C
        END IF
C
C         IF FLAG(N) REMAINED ZERO, IT IS POTENTIALLY OUTSIDE
C         THE REGION.  FLAG THIS SITUATION WITH A 2.0D0.  IF
C         FLAG(N) RETURNED A 1.0D0, THEN IT WILL EVENTUSLLY
C         BE INSIDE AN ELEMENT WHEN DTSUB IS SMALL ENOUGH.
C         FLAG THIS SITUATION WITH A 3.0D0.  IF FLAG(N) HAS
C         A VALUE OF 4.0D0, A SLIGHTLY OUTSIDE SOLUTION WAS
C         ACCEPTED.
C
        IF (FLAG(N) .EQ. 0.0D0) THEN
          FLAG(N) = 2.0D0
        ELSE IF (FLAG(N) .EQ. 1.0D0) THEN
          FLAG(N) = 3.0D0
        ELSE IF (FLAG(N) .EQ. 4.0D0) THEN
          FLAG(N) = 3.0D0
          OUTEL(N) = 1.0D20
        END IF
C
      END IF
C
      RETURN
      END
C
      SUBROUTINE BRKINS (N, XX, XXQ, CC, CS, FLAG, OUTEL)
C
C
C         THIS SUBROUTINE COMPUTES THE NEW ISOPARAMETRIC COORDINATES
C         INSIDE THE GIVEN HEXAHEDRON FOR THE GIVEN POINT (ZQ, YQ, ZQ).
C         IF THEY ARE BETWEEN -1 AND 1, THE POINT IS INSIDE, AND A NEW
C         CONCENTRATION IS COMPUTED.
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      INCLUDE 'gwpara.inc'
C
      DIMENSION CS(MAXNPK), FLAG(MAXNPK)
      DIMENSION OUTEL(MAXNPK)
C
      DIMENSION XX(8, 3), XXQ(3), CC(8)
      DIMENSION SI(8, 3), SOLD(3), SNEW(3), IORDER(2, 3)
      DATA SI /
     &  -1.0D0, 1.0D0, 1.0D0, -1.0D0, -1.0D0, 1.0D0, 1.0D0, -1.0D0,
     &  -1.0D0, -1.0D0, 1.0D0, 1.0D0, -1.0D0, -1.0D0, 1.0D0, 1.0D0,
     &  -1.0D0, -1.0D0, -1.0D0, -1.0D0, 1.0D0, 1.0D0, 1.0D0, 1.0D0 /
      DATA IORDER / 2, 3, 1, 3, 1, 2 /
C
      DO J = 1, 3
        SNEW(J) = 0.0D0
      END DO
      K = 0
      ISTOP = 0
C
      DO WHILE ((ISTOP .EQ. 0) .AND. (K .LT. 100))
C
        K = K + 1
        RESS = 0.0D0
C
C         COMPUTE NEW ISOPARAMETRIC COORDINATES.
C
        DO J = 1, 3
C
          SOLD(J) = SNEW(J)
          JJ1 = IORDER(1, J)
          JJ2 = IORDER(2, J)
C
          SUM1 = 0.0D0
          SUM2 = 0.0D0
          DO I = 1, 8
            T1 = (1.0D0 + SI(I, JJ1) * SNEW(JJ1)) * (1.0D0 +
     &        SI(I, JJ2) * SNEW(JJ2)) * XX(I, J)
            SUM1 = SUM1 + T1
            SUM2 = SI(I, J) * T1 + SUM2
          END DO
C
          SNEW(J) = (XXQ(J) * 8.0D0 - SUM1) / SUM2
          RESJ = DABS (SNEW(J) - SOLD(J))
          DABSJ = DABS (SNEW(J))
          IF (DABSJ .GT. 1.0D0) RESJ = RESJ / DABSJ
          RESS = RESS + RESJ
C
        END DO
C
C         CHECK FOR CONVERGENCE.
C
        IF (RESS .LT. 1.0D-4) THEN
          ISTOP = 1
        END IF
C
      END DO
C
C         IF THERE IS A VALID SOLUTION, COMPUTE THE NEW
C         CONCENTRATION.
C
      IF ((DABS (SNEW(1)) .LE. 1.001D0) .AND.
     &  (DABS (SNEW(2)) .LE. 1.001D0) .AND.
     &  (DABS (SNEW(3)) .LE. 1.001D0)) THEN
C
        FLAG(N) = 4.0D0
C
C         CHECK FOR STRICTLY INSIDE THE ELEMENT.
C
        IF ((DABS (SNEW(1)) .LE. 1.0D0) .AND.
     &    (DABS (SNEW(2)) .LE. 1.0D0) .AND.
     &    (DABS (SNEW(3)) .LE. 1.0D0)) THEN
C
          FLAG(N) = 1.0D0
C
        ELSE
C
C         CHECK TO SEE IF THIS IS THE BEST THUS FAR.
C
          TEST = 0.0D0
          DO I = 1, 3
            IF (SNEW(I) .LT. -1.0D0) THEN
              TEST = - SNEW(I) - 1.0D0 + TEST
            ELSE IF (SNEW(I) .GT. 1.0D0) THEN
              TEST = SNEW(I) - 1.0D0 + TEST
            END IF
          END DO
C
          IF (TEST .GT. OUTEL(N)) THEN
C
            RETURN
C
          ELSE
C
            OUTEL(N) = TEST
C
C         STAY WITHIN THE ELEMENT.
C
            DO I = 1, 3
              IF (SNEW(I) .LT. -1.0D0) THEN
                SNEW(I) = -1.0D0
              ELSE IF (SNEW(I) .GT. 1.0D0) THEN
                SNEW(I) = 1.0D0
              END IF
            END DO
C
          END IF
C
        END IF
C
C         COMPUTE THE CONCENTRATION.
C
        SUM1 = 0.0D0
        DO I = 1, 8
          T1 = 0.125D0 * CC(I)
          DO J = 1, 3
            T1 = (1.0D0 + SI(I, J) * SNEW(J)) * T1
          END DO
          SUM1 = SUM1 + T1
        END DO
C
C         AVOID NEGATIVE CONCENTRATIONS.
C
        IF (SUM1 .LT. 0.0D0) SUM1 = 0.0D0
C
        CS(N) = SUM1
C
      END IF
C
      RETURN
      END
C
      SUBROUTINE PRSINS (N, XX, XXQ, CC, CS, FLAG, OUTEL)
C
C
C         THIS SUBROUTINE COMPUTES THE NEW ISOPARAMETRIC COORDINATES
C         INSIDE THE GIVEN PRISM FOR THE GIVEN POINT (ZQ, YQ, ZQ).
C         IF THEY ARE BETWEEN 0 AND 1, THE POINT IS INDIDE, AND A NEW
C         CONCENTRATION IS COMPUTED.
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      INCLUDE 'gwpara.inc'
C
      DIMENSION CS(MAXNPK), FLAG(MAXNPK)
      DIMENSION OUTEL(MAXNPK)
C
      DIMENSION XX(8, 3), XXQ(3), CC(8)
      DIMENSION HEIGHT(3), FL(3)
C
C         COMPUTE THE DOMINANT HEIGHT.
C
      DO I = 1, 3
        HEIGHT(I) = 0.0D0
      END DO
C
      DO J = 1, 3
        SUM = 0.0D0
        DO I = 1, 3
          SUM = XX(I + 3, J) - XX(I, J) + SUM
        END DO
        HEIGHT(J) = SUM
      END DO
C
      BIG = - 1.0D0
      DO I = 1, 3
        VALUE = DABS (HEIGHT(I))
        IF (VALUE .GT. BIG) THEN
          IBIG = I
          BIG = VALUE
        END IF
      END DO
C
      IF (IBIG .EQ. 1) THEN
        J1 = 2
        J2 = 3
        J3 = 1
      ELSE IF (IBIG .EQ. 2) THEN
        J1 = 1
        J2 = 3
        J3 = 2
      ELSE
        J1 = 1
        J2 = 2
        J3 = 3
      END IF
C
C         SOLVE FOR ZETA.
C
      ZETA = 0.5D0
      K = 0
      ISTOP = 0
C
      DO WHILE ((ISTOP .EQ. 0) .AND. (K .LT. 100))
C
        K = K + 1
C
C         COMPUTE THE L'S.
C
        A1 = (XX(1, J1) - XX(3, J1)) * (1.0D0 - ZETA) + (XX(4, J1) -
     &    XX(6, J1)) * ZETA
        A2 = (XX(2, J1) - XX(3, J1)) * (1.0D0 - ZETA) + (XX(5, J1) -
     &    XX(6, J1)) * ZETA
        A3 = XXQ(J1) - XX(3, J1) * (1.0D0 - ZETA) - XX(6, J1) * ZETA
C
        B1 = (XX(1, J2) - XX(3, J2)) * (1.0D0 - ZETA) + (XX(4, J2) -
     &    XX(6, J2)) * ZETA
        B2 = (XX(2, J2) - XX(3, J2)) * (1.0D0 - ZETA) + (XX(5, J2) -
     &    XX(6, J2)) * ZETA
        B3 = XXQ(J2) - XX(3, J2) * (1.0D0 - ZETA) - XX(6, J2) * ZETA
C
        DET = A1 * B2 - A2 * B1
        IF (DET .EQ. 0.0D0) RETURN
C
        FL(1) = (A3 * B2 - B3 * A2) / DET
        FL(2) = (A1 * B3 - B1 * A3) / DET
        FL(3) = 1.0D0 - FL(1) - FL(2)
C
C         COMPUTE A NEW ZETA.
C
        ZETOLD = ZETA
C
        C1 = 0.0D0
        C2 = XXQ(J3)
        DO I = 1, 3
          C1 = (XX(I + 3, J3) - XX(I, J3)) * FL(I) + C1
          C2 = C2 - XX(I, J3) * FL(I)
        END DO
C
        IF (C1 .EQ. 0.0D0) RETURN
C
        ZETA = C2 / C1
C
C         CHECK FOR CONVERGENCE.
C
        RESS = DABS (ZETA - ZETOLD)
        DABZET = DABS (ZETA)
        IF (DABZET .GT. 1.0D0) RESS = RESS / DABZET
        IF (RESS .LT. 1.0D-4) THEN
          ISTOP = 1
        END IF
C
      END DO
C
C         IF THERE IS A VALID SOLUTION, COMPUTE THE NEW
C         CONCENTRATION.
C
      IF ((FL(1) .GE. -0.001D0) .AND. (FL(1) .LE. 1.001D0) .AND.
     &  (FL(2) .GE. -0.001D0) .AND. (FL(2) .LE. 1.001D0) .AND.
     &  (FL(3) .GE. -0.001D0) .AND. (FL(3) .LE. 1.001D0) .AND.
     &  (ZETA .GE. -0.001D0) .AND. (ZETA .LE. 1.001D0)) THEN
C
        FLAG(N) = 4.0D0
C
C         CHECK FOR STRICTLY INSIDE THE ELEMENT.
C
        IF ((FL(1) .GE. 0.0D0) .AND. (FL(1) .LE. 1.0D0) .AND.
     &    (FL(2) .GE. 0.0D0) .AND. (FL(2) .LE. 1.0D0) .AND.
     &    (FL(3) .GE. 0.0D0) .AND. (FL(3) .LE. 1.0D0) .AND.
     &    (ZETA .GE. 0.0D0) .AND. (ZETA .LE. 1.0D0)) THEN
C
          FLAG(N) = 1.0D0
C
        ELSE
C
C         CHECK TO SEE IF THIS IS THE BEST THUS FAR.
C
          TEST = 0.0D0
          DO I = 1, 3
            IF (FL(I) .LT. 0.0D0) THEN
              TEST = - FL(I) + TEST
            ELSE IF (FL(I) .GT. 1.0D0) THEN
              TEST = FL(I) - 1.0D0 + TEST
            END IF
          END DO
          IF (ZETA .LT. 0.0D0) THEN
            TEST = - ZETA + TEST
          ELSE IF (ZETA .GT. 1.0D0) THEN
            TEST = ZETA - 1.0D0 + TEST
          END IF
C
          IF (TEST .GT. OUTEL(N)) THEN
C
            RETURN
C
          ELSE
C
            OUTEL(N) = TEST
C
C         STAY WITHIN THE ELEMENT.
C
            DO I = 1, 3
              IF (FL(I) .LT. 0.0D0) THEN
                FL(I) = 0.0D0
              ELSE IF (FL(I) .GT. 1.0D0) THEN
                FL(I) = 1.0D0
              END IF
            END DO
C
            IF (FL(1) .EQ. 0.0D0) THEN
              FL(3) = 1.0D0 - FL(2)
            ELSE IF (FL(1) .EQ. 1.0D0) THEN
              FL(2) = 0.0D0
              FL(3) = 0.0D0
            ELSE IF (FL(2) .EQ. 0.0D0) THEN
              FL(3) = 1.0D0 - FL(1)
            ELSE IF (FL(2) .EQ. 1.0D0) THEN
              FL(1) = 0.0D0
              FL(3) = 0.0D0
            ELSE IF (FL(3) .EQ. 0.0D0) THEN
              FL(2) = 1.0D0 - FL(1)
            ELSE IF (FL(3) .EQ. 1.0D0) THEN
              FL(1) = 0.0D0
              FL(2) = 0.0D0
            END IF
C
            IF (ZETA .LT. 0.0D0) THEN
              ZETA = 0.0D0
            ELSE IF (ZETA .GT. 1.0D0) THEN
              ZETA = 1.0D0
            END IF
C
          END IF
C
        END IF
C
C         COMPUTE THE CONCENTRATION.
C
        SUM = 0.0D0
        DO I = 1, 3
          T1 = CC(I) * (1.0D0 - ZETA) + CC(I + 3) * ZETA
          SUM = SUM + FL(I) * T1
        END DO
C
C         AVOID NEGATIVE CONCENTRATIONS.
C
        IF (SUM .LT. 0.0D0) SUM = 0.0D0
C
        CS(N) = SUM
C
      END IF
C
      RETURN
      END
C
      SUBROUTINE TETINS (N, XX, XXQ, CC, CS, FLAG, OUTEL)
C
C
C         THIS SUBROUTINE COMPUTES THE NEW ISOPARAMETRIC COORDINATES
C         INSIDE THE GIVEN TETRAHEDRON FOR THE GIVEN POINT
C         (ZQ, YQ, ZQ).  IF THEY ARE BETWEEN 0 AND 1, THE POINT IS
C         INDIDE, AND A NEW CONCENTRATION IS COMPUTED.
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      INCLUDE 'gwpara.inc'
C
      DIMENSION CS(MAXNPK), FLAG(MAXNPK)
      DIMENSION OUTEL(MAXNPK)
C
      DIMENSION XX(8, 3), XXQ(3), CC(8)
      DIMENSION A(3, 3), AI(3, 3), B(3), FL(4)
C
C         DETERMINE COEFFICIENTS FOR THE 3 X 3 EQUATION.
C
      DO I = 1, 3
        DO J = 1, 3
          A(I, J) = XX(J, I) - XX(4, I)
        END DO
        B(I) = XXQ(I) - XX(4, I)
      END DO
C
C         COMPUTE THE NEW ISOPARAMETRIC COORDINATES.
C
      CALL AINV3 (A, AI)
C
      FL(4) = 1.0D0
      DO I = 1, 3
        SUM = 0.0D0
        DO J = 1, 3
          SUM = AI(I, J) * B(J) + SUM
        END DO
        FL(I) = SUM
        FL(4) = FL(4) - SUM
      END DO
C
C         IF THERE IS A VALID SOLUTION, COMPUTE THE NEW
C         CONCENTRATION.
C
      IF ((FL(1) .GE. -0.001D0) .AND. (FL(1) .LE. 1.001D0) .AND.
     &  (FL(2) .GE. -0.001D0) .AND. (FL(2) .LE. 1.001D0) .AND.
     &  (FL(3) .GE. -0.001D0) .AND. (FL(3) .LE. 1.001D0) .AND.
     &  (FL(4) .GE. -0.001D0) .AND. (FL(4) .LE. 1.001D0)) THEN
C
        FLAG(N) = 4.0D0
C
C         CHECK FOR STRICTLY INSIDE THE ELEMENT.
C
        IF ((FL(1) .GE. 0.0D0) .AND. (FL(1) .LE. 1.0D0) .AND.
     &    (FL(2) .GE. 0.0D0) .AND. (FL(2) .LE. 1.0D0) .AND.
     &    (FL(3) .GE. 0.0D0) .AND. (FL(3) .LE. 1.0D0) .AND.
     &    (FL(4) .GE. 0.0D0) .AND. (FL(4) .LE. 1.0D0)) THEN
C
          FLAG(N) = 1.0D0
C
        ELSE
C
C         CHECK TO SEE IF THIS IS THE BEST THUS FAR.
C
          TEST = 0.0D0
          DO I = 1, 4
            IF (FL(I) .LT. 0.0D0) THEN
              TEST = - FL(I) + TEST
            ELSE IF (FL(I) .GT. 1.0D0) THEN
              TEST = FL(I) - 1.0D0 + TEST
            END IF
          END DO
C
          IF (TEST .GT. OUTEL(N)) THEN
C
            RETURN
C
          ELSE
C
            OUTEL(N) = TEST
C
C         STAY WITHIN THE ELEMENT.
C
            DO I = 1, 4
              IF (FL(I) .LT. 0.0D0) THEN
                FL(I) = 0.0D0
              ELSE IF (FL(I) .GT. 1.0D0) THEN
                  FL(I) = 1.0D0
              END IF
            END DO
C
            IF (FL(1) .EQ. 0.0D0) THEN
              IF (FL(2) .EQ. 0.0D0) THEN
                FL(4) = 1.0D0 - FL(3)
              ELSE IF (FL(2) .EQ. 1.0D0) THEN
                FL(3) = 0.0D0
                FL(4) = 0.0D0
              ELSE IF (FL(3) .EQ. 0.0D0) THEN
                FL(4) = 1.0D0 - FL(2)
              ELSE IF (FL(3) .EQ. 1.0D0) THEN
                FL(2) = 0.0D0
                FL(4) = 0.0D0
              ELSE IF (FL(4) .EQ. 0.0D0) THEN
                FL(3) = 1.0D0 - FL(2)
              ELSE IF (FL(4) .EQ. 1.0D0) THEN
                FL(2) = 0.0D0
                FL(3) = 0.0D0
              END IF
            ELSE IF (FL(1) .EQ. 1.0D0) THEN
              FL(2) = 0.0D0
              FL(3) = 0.0D0
              FL(4) = 0.0D0
            ELSE IF (FL(2) .EQ. 0.0D0) THEN
              IF (FL(1) .EQ. 0.0D0) THEN
                FL(4) = 1.0D0 - FL(3)
              ELSE IF (FL(1) .EQ. 1.0D0) THEN
                FL(3) = 0.0D0
                FL(4) = 0.0D0
              ELSE IF (FL(3) .EQ. 0.0D0) THEN
                FL(4) = 1.0D0 - FL(1)
              ELSE IF (FL(3) .EQ. 1.0D0) THEN
                FL(1) = 0.0D0
                FL(4) = 0.0D0
              ELSE IF (FL(4) .EQ. 0.0D0) THEN
                FL(3) = 1.0D0 - FL(1)
              ELSE IF (FL(4) .EQ. 1.0D0) THEN
                FL(1) = 0.0D0
                FL(3) = 0.0D0
              END IF
            ELSE IF (FL(2) .EQ. 1.0D0) THEN
              FL(1) = 0.0D0
              FL(3) = 0.0D0
              FL(4) = 0.0D0
            ELSE IF (FL(3) .EQ. 0.0D0) THEN
              IF (FL(1) .EQ. 0.0D0) THEN
                FL(4) = 1.0D0 - FL(2)
              ELSE IF (FL(1) .EQ. 1.0D0) THEN
                FL(2) = 0.0D0
                FL(4) = 0.0D0
              ELSE IF (FL(2) .EQ. 0.0D0) THEN
                FL(4) = 1.0D0 - FL(1)
              ELSE IF (FL(2) .EQ. 1.0D0) THEN
                FL(1) = 0.0D0
                FL(4) = 0.0D0
              ELSE IF (FL(4) .EQ. 0.0D0) THEN
                FL(2) = 1.0D0 - FL(1)
              ELSE IF (FL(4) .EQ. 1.0D0) THEN
                FL(1) = 0.0D0
                FL(2) = 0.0D0
              END IF
            ELSE IF (FL(3) .EQ. 1.0D0) THEN
              FL(1) = 0.0D0
              FL(2) = 0.0D0
              FL(4) = 0.0D0
            ELSE IF (FL(4) .EQ. 0.0D0) THEN
              IF (FL(1) .EQ. 0.0D0) THEN
                FL(3) = 1.0D0 - FL(2)
              ELSE IF (FL(1) .EQ. 1.0D0) THEN
                FL(2) = 0.0D0
                FL(3) = 0.0D0
              ELSE IF (FL(2) .EQ. 0.0D0) THEN
                FL(3) = 1.0D0 - FL(1)
              ELSE IF (FL(2) .EQ. 1.0D0) THEN
                FL(1) = 0.0D0
                FL(3) = 0.0D0
              ELSE IF (FL(3) .EQ. 0.0D0) THEN
                FL(2) = 1.0D0 - FL(1)
              ELSE IF (FL(3) .EQ. 1.0D0) THEN
                FL(1) = 0.0D0
                FL(2) = 0.0D0
              END IF
            ELSE IF (FL(4) .EQ. 1.0D0) THEN
              FL(1) = 0.0D0
              FL(2) = 0.0D0
              FL(3) = 0.0D0
            END IF
C
          END IF
C
        END IF
C
C         COMPUTE THE CONCENTRATION.
C
        SUM = 0.0D0
        DO I = 1, 4
          SUM = CC(I) * FL(I) + SUM
        END DO
C
C         AVOID NEGATIVE CONCENTRATIONS.
C
        IF (SUM .LT. 0.0D0) SUM = 0.0D0
C
        CS(N) = SUM
C
      END IF
C
      RETURN
      END
C
      SUBROUTINE AINV3 (A, AI)
C
C
C         THIS SUBROUTINE COMPUTES THE INVERSE OF A(3, 3).
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      DIMENSION A(3, 3), AI(3, 3)
C
C         GET THE INVERSE TERMS.
C
      AI(1, 1) = A(2, 2) * A(3, 3) - A(2, 3) * A(3, 2)
      AI(1, 2) = A(1, 3) * A(3, 2) - A(1, 2) * A(3, 3)
      AI(1, 3) = A(1, 2) * A(2, 3) - A(1, 3) * A(2, 2)
      AI(2, 1) = A(2, 3) * A(3, 1) - A(2, 1) * A(3, 3)
      AI(2, 2) = A(1, 1) * A(3, 3) - A(1, 3) * A(3, 1)
      AI(2, 3) = A(1, 3) * A(2, 1) - A(1, 1) * A(2, 3)
      AI(3, 1) = A(2, 1) * A(3, 2) - A(2, 2) * A(3, 1)
      AI(3, 2) = A(1, 2) * A(3, 1) - A(1, 1) * A(3, 2)
      AI(3, 3) = A(1, 1) * A(2, 2) - A(1, 2) * A(2, 1)
C
C         GET THE SETERMINANT.
C
      DET =- 0.0D0
      DO J = 1, 3
        DET = A(1, J) * AI(J, 1) + DET
      END DO
C
      IF (DABS (DET) .LE. 1.0D-6) THEN
C
C         ERROR CONDITION.
C
        WRITE(*, 5410)
 5410 FORMAT(' WARNING: Matrix A does not have an inverse',/)
        DETI = 0.0D0
C
      ELSE
C
        DETI = 1.0D0 / DET
C
      END IF
C
      DO I = 1, 3
        DO J = 1, 3
          AI(I, J) = AI(I, J) * DETI
        END DO
      END DO
C
      RETURN
      END
C
      SUBROUTINE ADVBC (CSTAR,RI,RL,IE, V,VP,CP,
     1 DCOSB,ISB,NPBB)
C
C ------- TO APPLY CAUCHY, VARIABLE, AND DIRICHLET BOUNDARY CONDITIONS
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /TDBC/ NDNPT,NDPRT,NDDPT(MXDPRC)
      COMMON /TCBC/ NCEST,NCNPT,NCPRT,NCDPT(MXCPRC)
      COMMON /TVBC/ NVEST,NVNPT,NVPRT,NVDPT(MXVPRC)
      COMMON /TNBC/ NNEST,NNNPT,NNPRT,NNDPT(MXNPRC)
C
      COMMON /BLKDBT/ CDBT(MXDPRC),CDBFT(MXDDPC,MXDPRC),
     1        TCDBFT(MXDDPC,MXDPRC),IDTYPT(MXDNPC),
     2        NPDBT(MXDNPC),JDTYPT(MXDNPC)
      COMMON /BLKCBT/ QCBT(MXCPRC),QCBFT(MXCDPC,MXCPRC),
     1        TQCBFT(MXCDPC,MXCPRC),ICTYPT(MXCESC),ISCT(5,MXCESC),
     2        NPCBT(MXCNPC),IDCT(MXCESC),JCTYPT(MXCESC)
      COMMON /BLKVBT/ CVBT(MXVPRC),CVBFT(MXVDPC,MXVPRC),
     1        TCVBFT(MXVDPC,MXVPRC),IVTYPT(MXVESC),ISVT(5,MXVESC),
     2        NPVBT(MXVNPC),IDVT(MXVESC),JVTYPT(MXVESC)
C
      COMMON /BS2T/ DETCBT(4,MXCESC),DETNBT(4,MXNESC),DETVBT(4,MXVESC)
      COMMON /BLK1/ KGB(4,6,3)
C
      DIMENSION IE(MAXELK,9),RI(MAXNPK),RL(MAXNPK),
     1 V(MAXNPK,3),VP(MAXNPK,3),CSTAR(MAXNPK),CP(MAXNPK),
     2 DCOSB(3,MXBESK),ISB(6,MXBESK),NPBB(MXBNPK)
C
      DIMENSION RQI(4),RQL(4),DET(4)
      DIMENSION VXQ(4),VYQ(4),VZQ(4),COFTH(3)
C
C ******* APPLY CAUCHY CONDITION: QC=V.N.C - N.(THETA)D.GRAD(C)
C
  100 IF (NCEST.EQ.0) GO TO 500
      DO NI=1,NNP
         RI(NI)=0.0D0
         RL(NI)=0.0D0
      ENDDO
      DO 150 MP=1,NCEST
         ITYP=JCTYPT(MP)
         QCBMP=QCBT(ITYP)
         MPB=ISCT(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         ID = NIK(M)
C
         NODE=4
         DO 130 IQ=1,NODE
            I=KGB(IQ,LS,ID)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
               NODE=3
               GOTO 130
            ENDIF
            NI=IE(M,I)
            VXQ(IQ)=((V(NI,1)+VP(NI,1))*0.5D0)
            VYQ(IQ)=((V(NI,2)+VP(NI,2))*0.5D0)
            VZQ(IQ)=((V(NI,3)+VP(NI,3))*0.5D0)
            DET(IQ)=DETCBT(IQ,MP)
  130    CONTINUE
C
         CALL Q34ADB(RQI,RQL,VXQ,VYQ,VZQ,DCOSB(1,MPB),QCBMP,
     >        1,NODE,DET)
C
         DO IQ=1,NODE
            I=KGB(IQ,LS,ID)
            NI=IE(M,I)
            RL(NI)=RL(NI) - RQL(IQ)
            RI(NI)=RI(NI) - RQI(IQ)
         ENDDO
  150 CONTINUE
      DO NPP=1,NCNPT
         NI=NPCBT(NPP)
         NP=NPBB(NI)
         IF (RL(NP).NE.0.0D0) THEN
            CSTAR(NP)=RI(NP)/RL(NP)
         ENDIF
      ENDDO
C
C ******* APPLY VARIABLE BOUNDARY CONDITIONS
C
  500 IF (NVEST.EQ.0) GO TO 700
      DO NP=1,NNP
         RI(NP)=0.0D0
         RL(NP)=0.0D0
      ENDDO
      DO 550 MP=1,NVEST
         ITYP=JVTYPT(MP)
         CINMP=CVBT(ITYP)
         MPB=ISVT(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         ID = NIK(M)
C
         NODE=4
         DO 530 IQ=1,NODE
            I=KGB(IQ,LS,ID)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
               NODE=3
               GOTO 530
            ENDIF
            NI=IE(M,I)
            VXQ(IQ)=((V(NI,1)+VP(NI,1))*0.5D0)
            VYQ(IQ)=((V(NI,2)+VP(NI,2))*0.5D0)
            VZQ(IQ)=((V(NI,3)+VP(NI,3))*0.5D0)
            DET(IQ)=DETVBT(IQ,MP)
  530    CONTINUE
C
         CALL Q34ADB(RQI,RQL,VXQ,VYQ,VZQ,DCOSB(1,MPB),CINMP,
     >        3,NODE,DET)
C
         DO IQ=1,NODE
            I=KGB(IQ,LS,ID)
            NI=IE(M,I)
            RL(NI)=RL(NI) - RQL(IQ)
            RI(NI)=RI(NI) - RQI(IQ)
         ENDDO
  550 CONTINUE
      DO NPP=1,NVNPT
         NI=NPVBT(NPP)
         NP=NPBB(NI)
         IF (RL(NP).NE.0.0D0) THEN
             CSTAR(NP)=RI(NP)/RL(NP)
         ENDIF
      ENDDO
C
C ******* APPLY DIRICHLET BOUNDARY CONDITION
C
  700 IF (NDNPT.EQ.0) GO TO 900
C
      DO NPP=1,NDNPT
         NP=NPDBT(NPP)
         ITYP=JDTYPT(NPP)
         BB=CDBT(ITYP)
         CSTAR(NP)=BB
      ENDDO
  900 CONTINUE
      RETURN
      END
C
      SUBROUTINE Q34ADB(RQI,RQL,VXQ,VYQ,VZQ,DCOSB,QBMP,IBC,
     >                  NODE,DET)
C ----- 1/27/93
C
C $$$$$ TO COMPUTE BOUNDARY-SURFACE VOLUME FLUXES AND MATERIAL FLUXES
C       OVER A BOUNDARY SURFACE IN LAGRANGIAN STEP.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      COMMON /BS1/ RNS4(4,4),RNS3(3,3)
C
      DIMENSION RQL(4),RQI(4),THN(4)
      DIMENSION VXQ(4),VYQ(4),VZQ(4),DCOSB(3)
      DIMENSION RN(4),DET(4)
C
C ------- INITIATE VECTOR RQL(IQ) AND RQI(IQ)
C
      DO IQ=1,4
         RQL(IQ)=0.0D0
         RQI(IQ)=0.0D0
      ENDDO
C
C ------- SUMMATION OF THE INTEGRAND OVER THE GAUSSIAN POINTS
C
      DO 690 KG=1,NODE
         IF (NODE.EQ.4) THEN
            RN(1)=RNS4(1,KG)
            RN(2)=RNS4(2,KG)
            RN(3)=RNS4(3,KG)
            RN(4)=RNS4(4,KG)
         ELSE
            RN(1)=RNS3(1,KG)
            RN(2)=RNS3(2,KG)
            RN(3)=RNS3(3,KG)
         ENDIF
C
C ------- ACCUMULATE THE SUMS TO OBTAIN THE FLUX INTEGRALS RQL AND RQI
C
        GO TO (310,410,510) IBC
C
C ******* CAUCHY CONDITIONS
C
  310   VXK=0.0D0
        VYK=0.0D0
        VZK=0.0D0
        DO IQ=1,NODE
           VXK=VXK+VXQ(IQ)*RN(IQ)
           VYK=VYK+VYQ(IQ)*RN(IQ)
           VZK=VZK+VZQ(IQ)*RN(IQ)
        ENDDO
        VNK=VXK*DCOSB(1)+VYK*DCOSB(2)+VZK*DCOSB(3)
        DO IQ=1,NODE
           RQI(IQ)=RQI(IQ)+RN(IQ)*QBMP*DET(KG)
           RQL(IQ)=RQL(IQ)+RN(IQ)*VNK*DET(KG)
        ENDDO
        GOTO 690
C
C ****** NEUMANN CONDITIONS
C
  410   CONTINUE
        GOTO 690
C
C ******* VARIABLE CONDITIONS
C
  510   VXK=0.0D0
        VYK=0.0D0
        VZK=0.0D0
        DO IQ=1,NODE
           VXK=VXK+VXQ(IQ)*RN(IQ)
           VYK=VYK+VYQ(IQ)*RN(IQ)
           VZK=VZK+VZQ(IQ)*RN(IQ)
        ENDDO
        VNK=VXK*DCOSB(1)+VYK*DCOSB(2)+VZK*DCOSB(3)
        IF (VNK.GE.0.0D0) GO TO 690
        DO IQ=1,NODE
           RQI(IQ)=RQI(IQ)+RN(IQ)*VNK*QBMP*DET(KG)
           RQL(IQ)=RQL(IQ)+RN(IQ)*VNK*DET(KG)
        ENDDO
  690 CONTINUE
      RETURN
      END
C
      SUBROUTINE TASEMB (CMATRX,RLD,IE,LRN)
C
C ------- TO ASSEMBLE THE GLOBAL COEFFICIENT MATRIX AND GLOBAL LOAD
C ------- VECTOR.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      REAL*8 KD,LAMBDA
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /TREAL/ OMET,OMIT,TOLBT
C
      COMMON /FPS/ NWNPF,NWPRF,NWDPF(MXWPRH)
      COMMON /BLKPSF/ WSSF(MXWPRH),WSSFF(MXWDPH,MXWPRH),
     1               TWSSFF(MXWDPH,MXWPRH),IWTYPF(MXWNPH),
     2               NPWF(MXWNPH),JWTYPF(MXWNPH)
C
      COMMON /TPS/ NWNPT,NWPRT,NWDPT(MXWPRC)
      COMMON /BLKPST/ WSST(MXWPRC),WSSFT(MXWDPC,MXWPRC),
     1               TWSSFT(MXWDPC,MXWPRC),IWTYPT(MXWNPC),
     2               NPWT(MXWNPC),JWTYPT(MXWNPC)
C
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /WETX/ APHA1,APHA2,APHA3,APHA4
      COMMON /WETY/ BETA1,BETA2,BETA3,BETA4
      COMMON /WETZ/ GAMA1,GAMA2,GAMA3,GAMA4
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /BLKFL1/ H(MAXNPK),HP(MAXNPK),HW(MAXNPK),HT(MAXNPK)
      COMMON /BLKFL2/ V(MAXNPK,3),TH(8,MAXELK),DTH(8,MAXELK),
     1                AKHC(7,8,MAXELK)
      COMMON /BLKFL3/ BFLXF(MXBNPK,2),RSVAB(MXVNPH,4),PROPF(9,MXMATK),
     1                RHOMU(MXRMPK)
C
C ------- ARRAYS FOR TRANSPORT ONLY
C
      COMMON /BLKTR1/ C(MAXNPK),CP(MAXNPK),CW(MAXNPK),CSTAR(MAXNPK),
     1                F(MAXNPK,3),DTI(MAXNPK)
      COMMON /BLKTR2/ BFLXT(MXBNPK,2),WETAB(12,MAXELK),VP(MAXNPK,3),
     1                THP(8,MAXELK),THN(MAXNPK,2),AKDC(6,8,MAXELK),
     2                VBAR(MAXNPK,3),PROPT(13,MXMATK)
C
      DIMENSION IE(MAXELK,9),LRN(MXJBDK,MAXNPK),
     1 CMATRX(MXJBDK,MAXNPK),RLD(MAXNPK)
C
      DIMENSION QA(8,8),QAA(8,8),QB(8,8),QC(8,8),QD(8,8),QV(8,8),QR(8)
      DIMENSION VXQ(8),VYQ(8),VZQ(8),THG(8),RHOQ(8),CCQ(8),DHQ(8)
      DIMENSION AKXYZQ(6,8),DSDCQ(8),SWQ(8),CWQ(8)
C
      IF (KSST.EQ.1) THEN
          DELTI=1.D0/DELT
          W1=WF
          W2=1.0D0-WF
      ENDIF
      W1V=1.0D0
      W2V=0.0D0
      IF (IMID.EQ.0) GO TO 110
      W1=1.0D0
      W2=0.0D0
      W1V=1.0D0
      W2V=0.0D0
  110 VTERM=0.0D0
      IF (KSST.EQ.0) VTERM=1.0D0
C
C ------- INITIALIZE MATRICES CMATRX(IB,NP) AND RLD(NP)
C
      DO NP=1,NNP
         RLD(NP)=0.0D0
      ENDDO
      DO I=1,MXJBDK
         DO NP=1,NNP
            CMATRX(I,NP)=0.0D0
         ENDDO
      ENDDO
C
C ******* LOOP OVER ALL ELEMENTS TO FORM THE GLOBAL MATRIX EQUATION
C
      DO M=1,NEL
         NQ = IJNOD(M)
         IF (NQ.EQ.8) THEN
            APHA1=WETAB(1,M)
            APHA2=WETAB(2,M)
            APHA3=WETAB(3,M)
            APHA4=WETAB(4,M)
            BETA1=WETAB(5,M)
            BETA2=WETAB(6,M)
            BETA3=WETAB(7,M)
            BETA4=WETAB(8,M)
            GAMA1=WETAB(9,M)
            GAMA2=WETAB(10,M)
            GAMA3=WETAB(11,M)
            GAMA4=WETAB(12,M)
         ELSEIF(NQ.EQ.6) THEN
            APHA1=WETAB(1,M)
            APHA2=WETAB(2,M)
            APHA3=WETAB(3,M)
            BETA1=WETAB(4,M)
            BETA2=WETAB(5,M)
            BETA3=WETAB(6,M)
            GAMA1=WETAB(7,M)
            GAMA2=WETAB(8,M)
            GAMA3=WETAB(9,M)
         ELSE
            APHA1=WETAB(1,M)
            APHA2=WETAB(2,M)
            APHA3=WETAB(3,M)
            BETA1=WETAB(4,M)
            BETA2=WETAB(5,M)
            BETA3=WETAB(6,M)
         ENDIF
C
         MTYP=IE(M,9)
         RHOB=PROPT(2,MTYP)
         LAMBDA=PROPT(7,MTYP)
         FNLS=PROPT(8,MTYP)
         ALP=PROPF(7,MTYP)
         POR=PROPF(8,MTYP)
C
C         Modify for fraction of mobile water.
C
         FM=PROPT(13,MTYP)
         KD=PROPT(1,MTYP)*FM
         DECPKW=PROPT(11,MTYP)*FM
         DECPKS=PROPT(12,MTYP)*FM
C
         DO 250 IQ=1,NQ
            NP=IE(M,IQ)
            IF (IMID.EQ.0) THEN
               VXQ(IQ)=W1V*V(NP,1)+W2V*VP(NP,1)
               VYQ(IQ)=W1V*V(NP,2)+W2V*VP(NP,2)
               VZQ(IQ)=W1V*V(NP,3)+W2V*VP(NP,3)
               CWW=W1*CW(NP)+W2*CP(NP)
            ELSE
               VXQ(IQ)=0.5D0*(V(NP,1)+VP(NP,1))
               VYQ(IQ)=0.5D0*(V(NP,2)+VP(NP,2))
               VZQ(IQ)=0.5D0*(V(NP,3)+VP(NP,3))
               CWW=0.5D0*(CW(NP)+CP(NP))
            ENDIF
            CWQ(IQ)=CWW
            CCQ(IQ)=CP(NP)
            DHQ(IQ)=(H(NP)-HP(NP))/DELT
C
            DO I=1,6
               AKXYZQ(I,IQ)=AKDC(I,IQ,M)
            ENDDO
C
            GO TO (235,240,245), KSORP
  235       DSDCQ(IQ)=KD
            SWQ(IQ)=KD*CWW
            GO TO 250
  240       DSDCQ(IQ)=FNLS*KD*CWW**(FNLS-1.0D0)
            SWQ(IQ)=KD*CWW**FNLS
            GO TO 250
  245       DSDCQ(IQ)=KD*FNLS/((1.0D0+KD*CWW)*(1.0D0+KD*CWW))
            SWQ(IQ)=KD*FNLS*CWW/(1.0D0+KD*CWW)
  250    CONTINUE
         DO KG=1,NQ
            IF (IMID.EQ.0) THEN
               THG(KG)=W1*TH(KG,M)+W2*THP(KG,M)
            ELSE
               THG(KG)=0.5D0*(TH(KG,M)+THP(KG,M))
            ENDIF
            RHOQ(KG)=AKHC(7,KG,M)
         ENDDO
C
C ------- COMPUTE MATRICES QA(IQ,JQ), QAA(IQ,JQ), QB(IQ,JQ), QV(IQ,JQ),
C ------- AND QC(IQ,JQ) AND THE LOAD VECTOR QR(IQ) FOR EACH ELEMENT M.
C
         CALL TQ468 (QA,QAA,QB,QC,QD,QV,QR,VXQ,VYQ,VZQ,CCQ,DHQ,
     1 THG,AKXYZQ,RHOQ,RHOMU,RHOB,LAMBDA,ALP,POR,DECPKW,DECPKS,BETAP,
     2 DSDCQ,SWQ,CWQ,NQ,M)
C
C ------- ASSEMBLE QA(IQ,JQ), QAA(IQ,JQ), QB(IQ,JQ)/QV(IQ,JQ), AND
C ------- QC(IQ,JQ) INTO THE GLOBAL MATRIX CMATRX(I,NP).
C ------- CMATRX(I,NP) =QB+QC+(QA+QAA)/DELT.
C ------- FORM THE LOAD VECTOR, RLD(NP) = QR + QA/DELT*CSTAR +
C ------- QAA/DELT*CP.
C
         DO 390 IQ=1,NQ
            NI=IE(M,IQ)
            RLD(NI)=RLD(NI)+QR(IQ)
            DO 340 JQ=1,NQ
               NJ=IE(M,JQ)
               CPNJ=CP(NJ)
               IF (KSORP.EQ.1) CPNJ=CSTAR(NJ)
               IF (IMID.NE.0) GO TO 305
C
C ------- FOR THE CASE OF NON MID-DIFFERENCE
C
               QA(IQ,JQ)=QA(IQ,JQ)*DTI(NI)
               IF (KSORP.EQ.1) THEN
                   QAA(IQ,JQ)=QAA(IQ,JQ)*DTI(NI)
               ELSE
                   QAA(IQ,JQ)=QAA(IQ,JQ)*DELTI
               ENDIF
               RLD(NI)=RLD(NI)+QA(IQ,JQ)*CSTAR(NJ)+QAA(IQ,JQ)*CPNJ
               GO TO 310
C
C ------- FOR THE CASE OF MID-DIFFERENCE
C
  305          QA(IQ,JQ)=QA(IQ,JQ)*DTI(NI)*2.0D0
               IF (KSORP.EQ.1) THEN
                  QAA(IQ,JQ)=QAA(IQ,JQ)*DTI(NI)*2.0D0
               ELSE
                  QAA(IQ,JQ)=QAA(IQ,JQ)*DELTI*2.0D0
               ENDIF
               RLD(NI)=RLD(NI) + QA(IQ,JQ)*(CSTAR(NJ)+CP(NJ))*0.5D0 +
     1                 QAA(IQ,JQ)*(CPNJ+CP(NJ))*0.5D0
C
C ------- MERGE NON MID-DIFFERENCE AND MID-DIFFERENCE CASES
C
  310          CONTINUE
               RLD(NI)=RLD(NI)-W2*(QB(IQ,JQ)+QC(IQ,JQ)-QD(IQ,JQ))
     1                 *CSTAR(NJ)-VTERM*W2V*QV(IQ,JQ)*CP(NJ)
               DO I=1,MXJBDK
                  LNODE=LRN(I,NI)
                  IF (NJ.EQ.LNODE) GO TO 330
               ENDDO
               WRITE(16,1000) NI,M,JQ
	       call stopfile  ! emrl jig
               STOP
  330          CMATRX(I,NI)=CMATRX(I,NI)+QA(IQ,JQ)+QAA(IQ,JQ)+
     1                 W1*(QB(IQ,JQ)+QC(IQ,JQ)-QD(IQ,JQ)) +
     2                 VTERM*W1V*QV(IQ,JQ)
  340       CONTINUE
  390    CONTINUE
      ENDDO
C
C ------- INCORPORATE WELL SOURCE/SINK CONDITIONS
C
      IF (NWNPT.EQ.0) RETURN
C         write(2,*) STIME
      DO 790 I=1,NWNPT
         NI=NPWT(I)
         ITYP=JWTYPF(I)
         JTYP=JWTYPT(I)
         WSSQ=WSSF(ITYP)
         WSSC=WSST(JTYP)
C         write(2,*) I,WSSQ,WSSC
         IF (WSSQ.LE.0.0D0) GO TO 790
         CKG=WSSC
         RHOSTR = RHOMU(1) + CKG*(RHOMU(2)+CKG*(RHOMU(3)+CKG*RHOMU(4)))
         CKG=W1*CW(NI)+W2*CSTAR(NI)
         RHOTRU = RHOMU(1) + CKG*(RHOMU(2)+CKG*(RHOMU(3)+CKG*RHOMU(4)))
         WSSQC=WSSQ*RHOSTR/RHOTRU
         RLD(NI)=RLD(NI)+WSSQ*WSSC
         RLD(NI)=RLD(NI)-W2*WSSQC*CSTAR(NI)
  750    DO J=1,MXJBDK
            LNODE=LRN(J,NI)
            IF (LNODE.EQ.NI) CMATRX(J,NI)=CMATRX(J,NI)+W1*WSSQC
         ENDDO
  790 CONTINUE
 1000 FORMAT(1H1/5X,'*** WARNING: None of the lower-left nodes in equati
     1on',I3,/5X,'***  corresponds to ',I5,'-th element',I2,
     2'-th node; STOP  ****')
      RETURN
      END
C
      SUBROUTINE TQ468(QA,QAA,QB,QC,QD,QV,QR, VXQ,VYQ,VZQ,CCQ,
     > DHQ,THG,AKXYZQ,RHOQ,RHOMU,RHOB,LAMBDA,ALP,POR,DECPKW,DECPKS,
     > BETAP,DSDCQ,SWQ,CWQ, NODE,M)
C
C ------- TO COMPUTE ELEMENT MATRICES AND ELEMENT LOAD VECTORS.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      REAL*8 N(8),LAMBDA
C
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /WETX/ APHA1,APHA2,APHA3,APHA4
      COMMON /WETY/ BETA1,BETA2,BETA3,BETA4
      COMMON /WETZ/ GAMA1,GAMA2,GAMA3,GAMA4
C
      COMMON /JACOB1/ RNH(8,8),RNP(6,6),RNT(4,4)
      COMMON /JACOB2/ DJACS(8,MAXELK)
      COMMON /JACOB4/ RNH2(8,8,8),RNP2(6,6,6),RNT2(4,4,4)
      COMMON /DXYZ1/ DNXS(8,8,MAXELK)
      COMMON /DXYZ2/ DNYS(8,8,MAXELK)
      COMMON /DXYZ3/ DNZS(8,8,MAXELK)
C
      DIMENSION RHOMU(MXRMPK)
      DIMENSION QA(8,8),QAA(8,8),QB(8,8),QC(8,8),QD(8,8),QV(8,8),QR(8)
      DIMENSION VXQ(8),VYQ(8),VZQ(8),THG(8),RHOQ(8),CCQ(8),DHQ(8)
      DIMENSION AKXYZQ(6,8),AKXYZK(6),DSDCQ(8),SWQ(8),CWQ(8)
      DIMENSION DNX(8),DNY(8),DNZ(8),W(8)
C
C ------- INITIATE MATRICES QA, QAA, QB, QV, QC, AND QR
C
      DO IQ=1,NODE
         QR(IQ)=0.0D0
      ENDDO
      DO JQ=1,NODE
         DO IQ=1,NODE
            QA(IQ,JQ)=0.0D0
            QAA(IQ,JQ)=0.0D0
            QB(IQ,JQ)=0.0D0
            QC(IQ,JQ)=0.0D0
            QD(IQ,JQ)=0.0D0
            QV(IQ,JQ)=0.0D0
         ENDDO
      ENDDO
      DO 490 KG=1,NODE
C
C ------- DETERMINE LOACAL COORDINATE  OF GAUSSIAN POINT KG
C
         DJAC=DJACS(KG,M)
         DO I=1,NODE
            DNX(I)=DNXS(I,KG,M)
            DNY(I)=DNYS(I,KG,M)
            DNZ(I)=DNZS(I,KG,M)
         ENDDO
C
         IF (NODE.EQ.8)THEN
            ID=1
            DO I=1,8
               N(I)=RNH(I,KG)
               W(I)=N(I)
            ENDDO
         ELSEIF(NODE.EQ.6)THEN
            ID=2
            DO I=1,6
               N(I)=RNP(I,KG)
               W(I)=N(I)
            ENDDO
         ELSE
            ID=3
            DO I=1,4
               N(I)=RNT(I,KG)
               W(I)=N(I)
            ENDDO
         ENDIF
C
         DO I=1,6
            AKXYZK(I)=AKXYZQ(I,KG)
         ENDDO
         DHK=0.0D0
         VXK=0.0D0
         VYK=0.0D0
         VZK=0.0D0
         CKG=0.0D0
         DSDCK=0.0D0
         SORPSK=0.0D0
C
         DO IQ=1,NODE
            VXK=VXK+VXQ(IQ)*N(IQ)
            VYK=VYK+VYQ(IQ)*N(IQ)
            VZK=VZK+VZQ(IQ)*N(IQ)
            DHK=DHK+DHQ(IQ)*N(IQ)
            CKG=CKG+CCQ(IQ)*N(IQ)
            DSDCK=DSDCK+DSDCQ(IQ)*N(IQ)
            SORPSK=SORPSK+(SWQ(IQ)-DSDCQ(IQ)*CWQ(IQ))*N(IQ)
         ENDDO
C
         THK=THG(KG)
         RHOK=RHOQ(KG)
C
C ----- GRAD(RHO/RHOW) IS BASED ON GRAD(CP)
C
         COFRHO = RHOMU(2)+CKG*(2.0D0*RHOMU(3)+3.0D0*CKG*RHOMU(4))
         EEX=0.0D0
         EEY=0.0D0
         EEZ=0.0D0
         DO IQ=1,NODE
            EEX=EEX+DNX(IQ)*CCQ(IQ)
            EEY=EEY+DNY(IQ)*CCQ(IQ)
            EEZ=EEZ+DNZ(IQ)*CCQ(IQ)
         ENDDO
         D=(EEX*VXK+EEY*VYK+EEZ*VZK)/RHOK*COFRHO
C
         DXX=DJAC*AKXYZK(1)
         DYY=DJAC*AKXYZK(2)
         DZZ=DJAC*AKXYZK(3)
         DXY=DJAC*AKXYZK(4)
         DXZ=DJAC*AKXYZK(5)
         DYZ=DJAC*AKXYZK(6)
C
         VXK=VXK*DJAC
         VYK=VYK*DJAC
         VZK=VZK*DJAC
C
         SORPSK=SORPSK*DJAC
         A=DJAC*THK
         AA=DJAC*RHOB*DSDCK
         B= -RHOB*(ALP*DHK+LAMBDA+DECPKS)*SORPSK
         C=DJAC*((ALP*(THK+RHOB*DSDCK)-(ALP*THK/POR+BETAP*THK))*DHK
     1     +LAMBDA*(THK+RHOB*DSDCK)+(DECPKW*THK)+(DECPKS*RHOB*DSDCK))
         D=D*DJAC
C
         DO IQ=1,NODE
            QR(IQ)=QR(IQ)+B*N(IQ)
            DO JQ=1,NODE
               DWXDNX=DNX(IQ)*DNX(JQ)
               DWXDNY=DNX(IQ)*DNY(JQ)
               DWXDNZ=DNX(IQ)*DNZ(JQ)
               DWYDNX=DNY(IQ)*DNX(JQ)
               DWYDNY=DNY(IQ)*DNY(JQ)
               DWYDNZ=DNY(IQ)*DNZ(JQ)
               DWZDNX=DNZ(IQ)*DNX(JQ)
               DWZDNY=DNZ(IQ)*DNY(JQ)
               DWZDNZ=DNZ(IQ)*DNZ(JQ)
               WDNX=W(IQ)*DNX(JQ)
               WDNY=W(IQ)*DNY(JQ)
               WDNZ=W(IQ)*DNZ(JQ)
               QB(IQ,JQ)=QB(IQ,JQ)+DWXDNX*DXX+(DWXDNY+DWYDNX)*DXY
     1           +DWYDNY*DYY+(DWYDNZ+DWZDNY)*DYZ+DWZDNZ*DZZ+
     2           (DWXDNZ+DWZDNX)*DXZ
               QV(IQ,JQ)=QV(IQ,JQ) + (VXK*WDNX+VYK*WDNY+VZK*WDNZ)
            ENDDO
         ENDDO
C
         IF (NODE.EQ.8) THEN
            DO IQ=1,8
               DO JQ=1,8
                  WN=RNH2(IQ,JQ,KG)
                  QA(IQ,JQ)=QA(IQ,JQ) + A*WN
                  QAA(IQ,JQ)=QAA(IQ,JQ) + AA*WN
                  QC(IQ,JQ)=QC(IQ,JQ) + C*WN
                  QD(IQ,JQ)=QD(IQ,JQ) + D*WN
               ENDDO
            ENDDO
         ELSEIF (NODE.EQ.6) THEN
            DO IQ=1,6
               DO JQ=1,6
                  WN=RNP2(IQ,JQ,KG)
                  QA(IQ,JQ)=QA(IQ,JQ) + A*WN
                  QAA(IQ,JQ)=QAA(IQ,JQ) + AA*WN
                  QC(IQ,JQ)=QC(IQ,JQ) + C*WN
                  QD(IQ,JQ)=QD(IQ,JQ) + D*WN
               ENDDO
            ENDDO
         ELSE
            DO IQ=1,4
               DO JQ=1,4
                  WN=RNT2(IQ,JQ,KG)
                  QA(IQ,JQ)=QA(IQ,JQ) + A*WN
                  QAA(IQ,JQ)=QAA(IQ,JQ) + AA*WN
                  QC(IQ,JQ)=QC(IQ,JQ) + C*WN
                  QD(IQ,JQ)=QD(IQ,JQ) + D*WN
               ENDDO
            ENDDO
         ENDIF
  490 CONTINUE
C
      IF(ILUMP.EQ.0) RETURN
C
      DO I=1,NODE
         SUM=0.0D0
         SUMAA=0.0D0
         SUMC=0.0D0
         SUMD=0.0D0
         DO J=1,NODE
            SUM=SUM+QA(I,J)
            SUMAA=SUMAA+QAA(I,J)
            SUMC=SUMC+QC(I,J)
            SUMD=SUMD+QD(I,J)
            QA(I,J)=0.0D0
            QAA(I,J)=0.0D0
            QC(I,J)=0.0D0
            QD(I,J)=0.0D0
         ENDDO
         QA(I,I)=SUM
         QAA(I,I)=SUMAA
         QC(I,I)=SUMC
         QD(I,I)=SUMD
      ENDDO
      RETURN
      END
C
      SUBROUTINE TBC (CMATRX,RLD,CSTAR,IE,LRN,DCOSB,ISB,V,VP)
C
C ------- TO APPLY CAUCHY, NEUMANN, VARIABLE, AND DIRICHLET BOUNDARY
C ------- CONDITIONS.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /TREAL/ OMET,OMIT,TOLBT
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /TDBC/ NDNPT,NDPRT,NDDPT(MXDPRC)
      COMMON /TCBC/ NCEST,NCNPT,NCPRT,NCDPT(MXCPRC)
      COMMON /TVBC/ NVEST,NVNPT,NVPRT,NVDPT(MXVPRC)
      COMMON /TNBC/ NNEST,NNNPT,NNPRT,NNDPT(MXNPRC)
C
      COMMON /BLKDBT/ CDBT(MXDPRC),CDBFT(MXDDPC,MXDPRC),
     1        TCDBFT(MXDDPC,MXDPRC),IDTYPT(MXDNPC),
     2        NPDBT(MXDNPC),JDTYPT(MXDNPC)
      COMMON /BLKCBT/ QCBT(MXCPRC),QCBFT(MXCDPC,MXCPRC),
     1        TQCBFT(MXCDPC,MXCPRC),ICTYPT(MXCESC),ISCT(5,MXCESC),
     2        NPCBT(MXCNPC),IDCT(MXCESC),JCTYPT(MXCESC)
      COMMON /BLKVBT/ CVBT(MXVPRC),CVBFT(MXVDPC,MXVPRC),
     1        TCVBFT(MXVDPC,MXVPRC),IVTYPT(MXVESC),ISVT(5,MXVESC),
     2        NPVBT(MXVNPC),IDVT(MXVESC),JVTYPT(MXVESC)
      COMMON /BLKNBT/ QNBT(MXNPRC),QNBFT(MXNDPC,MXNPRC),
     1        TQNBFT(MXNDPC,MXNPRC),INTYPT(MXNESC),ISNT(5,MXNESC),
     2        NPNBT(MXNNPC),IDNT(MXNESC),JNTYPT(MXNESC)
C
      COMMON /BS2T/ DETCBT(4,MXCESC),DETNBT(4,MXNESC),DETVBT(4,MXVESC)
      COMMON /BLK1/ KGB(4,6,3)
C
      DIMENSION IE(MAXELK,9),LRN(MXJBDK,MAXNPK),
     1 CMATRX(MXJBDK,MAXNPK),RLD(MAXNPK),CSTAR(MAXNPK)
      DIMENSION DCOSB(3,MXBESK),ISB(6,MXBESK),V(MAXNPK,3),VP(MAXNPK,3)
C
      DIMENSION BQ(4,4),RQ(4),VXQ(4),VYQ(4),VZQ(4),DET(4)
C
      W1=WF
      W2=1.0D0-WF
      IF (KSST.NE.0 .OR. IMID.EQ.1) THEN
         W1=1.0D0
         W2=0.0D0
      ENDIF
C
C ******* APPLY CAUCHY CONDITION: QC=V.N.C - N.(THETA)D.GRAD(C)
C
      IF (NCEST.EQ.0) GO TO 300
      DO MP=1,NCEST
         ITYP=JCTYPT(MP)
         QCBMP=QCBT(ITYP)
         MPB=ISCT(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         ID = NIK(M)
         NODE=4
         DO 130 IQ=1,NODE
            I=KGB(IQ,LS,ID)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
               NODE=3
               GOTO 130
            ENDIF
            NI=IE(M,I)
            IF (IMID.EQ.0)THEN
               VXQ(IQ)=W1*V(NI,1)+W2*VP(NI,1)
               VYQ(IQ)=W1*V(NI,2)+W2*VP(NI,2)
               VZQ(IQ)=W1*V(NI,3)+W2*VP(NI,3)
            ELSE
               VXQ(IQ)=0.5D0*(V(NI,1)+W2*VP(NI,1))
               VYQ(IQ)=0.5D0*(V(NI,2)+W2*VP(NI,2))
               VZQ(IQ)=0.5D0*(V(NI,3)+W2*VP(NI,3))
            ENDIF
            DET(IQ)=DETCBT(IQ,MP)
  130    CONTINUE
C
         CALL Q34CNV(BQ,RQ,VXQ,VYQ,VZQ,DCOSB(1,MPB),QCBMP,1,NODE,DET)
      if (m .eq. 360) then
        print*, 'bq', bq
        print*, 'rq', rq
      end if
C
         DO IQ=1,NODE
            I=KGB(IQ,LS,ID)
            NI=IE(M,I)
            RLD(NI)=RLD(NI) + RQ(IQ)
            DO JQ=1,NODE
               J=KGB(JQ,LS,ID)
               NJ=IE(M,J)
               RLD(NI)=RLD(NI)-W2*BQ(IQ,JQ)*CSTAR(NJ)
               DO JJ=1,MXJBDK
                  LNODE=LRN(JJ,NI)
                  IF (LNODE.EQ.NJ) GO TO 150
               ENDDO
               WRITE (6,1000) MP,IQ,NI,JQ,NJ
	       call stopfile  ! emrl jig
               STOP
  150          CMATRX(JJ,NI)=CMATRX(JJ,NI) + W1*BQ(IQ,JQ)
            ENDDO
         ENDDO
      ENDDO
C
C ******* APPLY NEUMANN CONDITION: QN= - N.(THETA)D.GRAD(C)
C
  300 IF (NNEST.EQ.0) GO TO 500
      DO MP=1,NNEST
         ITYP=JNTYPT(MP)
         QNBMP=QNBT(ITYP)
         MPB=ISNT(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         ID = NIK(M)
         NODE=4
         DO 330 IQ=1,NODE
            I=KGB(IQ,LS,ID)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
               NODE=3
               GOTO 330
            ENDIF
            NI=IE(M,I)
            IF (IMID.EQ.0) THEN
               VXQ(IQ)=W1*V(NI,1)+W2*VP(NI,1)
               VYQ(IQ)=W1*V(NI,2)+W2*VP(NI,2)
               VZQ(IQ)=W1*V(NI,3)+W2*VP(NI,3)
            ELSE
               VXQ(IQ)=0.5D0*(V(NI,1)+W2*VP(NI,1))
               VYQ(IQ)=0.5D0*(V(NI,2)+W2*VP(NI,2))
               VZQ(IQ)=0.5D0*(V(NI,3)+W2*VP(NI,3))
            ENDIF
            DET(IQ)=DETNBT(IQ,MP)
  330    CONTINUE
C
         CALL Q34CNV(BQ,RQ,VXQ,VYQ,VZQ,DCOSB(1,MPB),QNBMP,2,NODE,DET)
C
         DO IQ=1,NODE
            I=KGB(IQ,LS,ID)
            NI=IE(M,I)
            RLD(NI)=RLD(NI)+RQ(IQ)
         ENDDO
      ENDDO
C
C ******* APPLY VARIABLE BOUNDARY CONDITIONS
C
  500 IF(NVEST.EQ.0) GO TO 700
      DO MP=1,NVEST
         ITYP=JVTYPT(MP)
         CINMP=CVBT(ITYP)
         MPB=ISVT(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         ID = NIK(M)
         NODE=4
         DO 530 IQ=1,NODE
            I=KGB(IQ,LS,ID)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
                 NODE=3
                 GOTO 530
            ENDIF
            NI=IE(M,I)
            IF (IMID.EQ.0) THEN
               VXQ(IQ)=W1*V(NI,1)+W2*VP(NI,1)
               VYQ(IQ)=W1*V(NI,2)+W2*VP(NI,2)
               VZQ(IQ)=W1*V(NI,3)+W2*VP(NI,3)
            ELSE
               VXQ(IQ)=0.5D0*(V(NI,1)+W2*VP(NI,1))
               VYQ(IQ)=0.5D0*(V(NI,2)+W2*VP(NI,2))
               VZQ(IQ)=0.5D0*(V(NI,3)+W2*VP(NI,3))
            ENDIF
            DET(IQ)=DETVBT(IQ,MP)
  530    CONTINUE
C
         CALL Q34CNV(BQ,RQ,VXQ,VYQ,VZQ,DCOSB(1,MPB),CINMP,3,NODE,DET)
C
         DO IQ=1,NODE
            I=KGB(IQ,LS,ID)
            NI=IE(M,I)
            RLD(NI)=RLD(NI) + RQ(IQ)
            DO JQ=1,NODE
               J=KGB(JQ,LS,ID)
               NJ=IE(M,J)
               RLD(NI)=RLD(NI)-W2*BQ(IQ,JQ)*CSTAR(NJ)
               DO JJ=1,MXJBDK
                  LNODE=LRN(JJ,NI)
                  IF (LNODE.EQ.NJ) GO TO 550
               ENDDO
               WRITE (6,5000) MP,IQ,NI,JQ,NJ
	       call stopfile  ! emrl jig
               STOP
  550          CMATRX(JJ,NI)=CMATRX(JJ,NI)+W1*BQ(IQ,JQ)
            ENDDO
         ENDDO
      ENDDO
C
C ******* APPLY DIRICHLET BOUNDARY CONDITION
C
  700 IF (NDNPT.EQ.0) RETURN
      DO NPP=1,NDNPT
         NI=NPDBT(NPP)
         ITYP=JDTYPT(NPP)
C
C ------- PUT THE DIRICHLET CONCENTRATION ON THE RIGHT-HAND SIDE
C
         BB=CDBT(ITYP)
         RLD(NI)=BB
C
C ------- MODIFY THE ROW CORRESPONDING TO DIRICHLET NODE.
C
         DO I=1,MXJBDK
            CMATRX(I,NI)=0.0D0
            IB=LRN(I,NI)
            IF (IB.EQ.NI) CMATRX(I,NI)=1.0D0
         ENDDO
C
C ------- MODIFY THE COLUMN CORRESPONDING TO THE DIRICHLET NODE.  THE
C ------- REASON OF THIS IS TO MAKE THE COEFFICIENT MATRIX SYMMETRIC.
C
         DO 720 INP=1,MXJBDK
            NP=LRN(INP,NI)
            IF (NP.EQ.NI .OR. NP.EQ.0) GO TO 720
            DO 715 IP=1,MXJBDK
               IB=LRN(IP,NP)
               IF (IB.EQ.0) GO TO 715
               IF (IB.EQ.NI) THEN
                   RLD(NP)=RLD(NP)-CMATRX(IP,NP)*RLD(NI)
                   CMATRX(IP,NP)=0.0D0
                   GO TO 720
               ENDIF
  715       CONTINUE
  720    CONTINUE
      ENDDO
      RETURN
 1000 FORMAT(1H0,'FOR',I4,'-TH CAUCHY SIDE',I2,'-TH NODE EQUATION NO.',
     1 I4/1X,'  WE CANNOT FIND THE COEFFICIENT FOR THE',I2,'-TH NODE',
     2 ' UNKNOWN NO.',I4,'   STOP')
 5000 FORMAT(1H0,'FOR',I4,'-TH VB SIDE',I2,'-TH NODE EQUATION NO.',
     1 I4/1X,'  WE CANNOT FIND THE COEFFICIENT FOR THE',I2,'-TH NODE',
     2 ' UNKNOWN NO.',I4,'   STOP')
      END
C
      SUBROUTINE Q34CNV(BQ,RQ,VXQ,VYQ,VZQ,DCOSB,QBMP,IBC,NODE,DET)
C
C ------- TO COMPUTE BOUNDARY-SURFACE MATRIX AND BOUNDARY-SURFACE LOAD
C ------- VECTOR OVER A BOUNDARY SURFACE.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      COMMON /BS1/ RNS4(4,4),RNS3(3,3)
C
      DIMENSION BQ(4,4),RQ(4),DET(4),RN(4)
      DIMENSION VXQ(4),VYQ(4),VZQ(4),DCOSB(3)
C
C ------- INITIATE MATRICES BQ(IQ,JQ) AND RQ(IQ)
C
      DO IQ=1,4
         RQ(IQ)=0.0D0
           DO JQ=1,4
              BQ(IQ,JQ)=0.0D0
           ENDDO
      ENDDO
C
C ------- SUMMATION OF THE INTEGRAND OVER THE GAUSSIAN POINTS
C
      DO 690 KG=1,NODE
         IF (NODE.EQ.4) THEN
            RN(1)=RNS4(1,KG)
            RN(2)=RNS4(2,KG)
            RN(3)=RNS4(3,KG)
            RN(4)=RNS4(4,KG)
         ELSE
            RN(1)=RNS3(1,KG)
            RN(2)=RNS3(2,KG)
            RN(3)=RNS3(3,KG)
         ENDIF
C
C ------- ACCUMULATE THE SUMS TO OBTAIN THE MATRIX INTEGRALS BQ AND RQ
C
         GO TO (310,410,510),IBC
C
C ******* CAUCHY CONDITIONS
C
  310    VXK=0.0D0
         VYK=0.0D0
         VZK=0.0D0
         DO IQ=1,NODE
            VXK=VXK+VXQ(IQ)*RN(IQ)
            VYK=VYK+VYQ(IQ)*RN(IQ)
            VZK=VZK+VZQ(IQ)*RN(IQ)
         ENDDO
         VNK=VXK*DCOSB(1)+VYK*DCOSB(2)+VZK*DCOSB(3)
         DO IQ=1,NODE
            RQ(IQ)=RQ(IQ)-RN(IQ)*QBMP*DET(KG)
            DO JQ=1,NODE
               BQ(IQ,JQ)=BQ(IQ,JQ)-RN(IQ)*VNK*RN(JQ)*DET(KG)
            ENDDO
         ENDDO
         GO TO 690
C
C ******* NEUMANN CONDITIONS
C
  410    DO IQ=1,NODE
             RQ(IQ)=RQ(IQ)-RN(IQ)*QBMP*DET(KG)
         ENDDO
         GO TO 690
C
C ******* VARIABLE CONDITIONS
C
  510    VXK=0.0D0
         VYK=0.0D0
         VZK=0.0D0
         DO IQ=1,NODE
            VXK=VXK+VXQ(IQ)*RN(IQ)
            VYK=VYK+VYQ(IQ)*RN(IQ)
            VZK=VZK+VZQ(IQ)*RN(IQ)
         ENDDO
         VNK=VXK*DCOSB(1)+VYK*DCOSB(2)+VZK*DCOSB(3)
         IF (VNK.GE.0.0D0) GO TO 690
         DO IQ=1,NODE
            RQ(IQ)=RQ(IQ)-RN(IQ)*VNK*QBMP*DET(KG)
            DO JQ=1,NODE
               BQ(IQ,JQ)=BQ(IQ,JQ)-RN(IQ)*VNK*RN(JQ)*DET(KG)
            ENDDO
         ENDDO
  690 CONTINUE
      RETURN
      END
C
      SUBROUTINE TSFLOW (BFLXT,IE,C,F,H,HP,TH,DCOSB,ISB,NPBB,
     1  WSSF,JWTYPF,PROPF,PROPT,DELT,KFLOW)
C
C ------- TO COMPUTE MATERIAL FLUXES, INCREMENTAL MASS FLOW, AND
C ------- ACCUMULATED MASS FLOW THROUGH ALL TYPES OF BOUNDARIES: AND
C ------- CHANGE OF MATERIALS IN THE REGION OF INTEREST.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      REAL*8 KD,LAMBDA
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /TPS/ NWNPT,NWPRT,NWDPT(MXWPRC)
      COMMON /BLKPST/ WSST(MXWPRC),WSSFT(MXWDPC,MXWPRC),
     1                TWSSFT(MXWDPC,MXWPRC),IWTYPT(MXWNPC),
     2                NPWT(MXWNPC),JWTYPT(MXWNPC)
      COMMON /TFLOW/ FRATET(14),FLOWT(14),TFLOWT(14)
C
C ------- COMMON BLOCK FOR TRANSPORT BOUNDARY CONDITIONS
C
      COMMON /TDBC/ NDNPT,NDPRT,NDDPT(MXDPRC)
      COMMON /TCBC/ NCEST,NCNPT,NCPRT,NCDPT(MXCPRC)
      COMMON /TVBC/ NVEST,NVNPT,NVPRT,NVDPT(MXVPRC)
      COMMON /TNBC/ NNEST,NNNPT,NNPRT,NNDPT(MXNPRC)
C
      COMMON /BLKDBT/ CDBT(MXDPRC),CDBFT(MXDDPC,MXDPRC),
     1        TCDBFT(MXDDPC,MXDPRC),IDTYPT(MXDNPC),
     2        NPDBT(MXDNPC),JDTYPT(MXDNPC)
      COMMON /BLKCBT/ QCBT(MXCPRC),QCBFT(MXCDPC,MXCPRC),
     1        TQCBFT(MXCDPC,MXCPRC),ICTYPT(MXCESC),ISCT(5,MXCESC),
     2        NPCBT(MXCNPC),IDCT(MXCESC),JCTYPT(MXCESC)
      COMMON /BLKVBT/ CVBT(MXVPRC),CVBFT(MXVDPC,MXVPRC),
     1        TCVBFT(MXVDPC,MXVPRC),IVTYPT(MXVESC),ISVT(5,MXVESC),
     2        NPVBT(MXVNPC),IDVT(MXVESC),JVTYPT(MXVESC)
      COMMON /BLKNBT/ QNBT(MXNPRC),QNBFT(MXNDPC,MXNPRC),
     1        TQNBFT(MXNDPC,MXNPRC),INTYPT(MXNESC),ISNT(5,MXNESC),
     2        NPNBT(MXNNPC),IDNT(MXNESC),JNTYPT(MXNESC)
      COMMON /BS2F/ DETCBF(4,MXCESH),DETNBF(4,MXNESH),DETVBF(4,MXVESH),
     1              DETRBF(4,MXRESH),DETAB(4,MXBESK)
      COMMON /BS2T/ DETCBT(4,MXCESC),DETNBT(4,MXNESC),DETVBT(4,MXVESC)
      COMMON /BLK1/ KGB(4,6,3)
C
      COMMON / PREV / QRP, QDP, QLP, QDHP, QLKWP, QLKSP, SOURSP
C
      DIMENSION IE(MAXELK,9),BFLXT(MXBNPK,2),H(MAXNPK),HP(MAXNPK)
      DIMENSION DCOSB(3,MXBESK),ISB(6,MXBESK),NPBB(MXBNPK)
      DIMENSION C(MAXNPK),F(MAXNPK,3),TH(8,MAXELK)
C
      DIMENSION WSSF(MXWPRH),JWTYPF(MXWNPH),PROPF(9,MXMATK),
     &  PROPT(13,MXMATK)
      DIMENSION CQ(8),CSQ(8),THG(8),DHQ(8),RRQ(4),FFQ(4),DET(4)
C
      DATA QR,QD,QL,SOURCE /0.0D0,0.0D0,0.0D0,0.0D0/
C
C ******* CALCULATE NODAL FLOW RATES THROUGH ALL BOUNDARY NODES
C
      DO NP=1,NBNP
         BFLXT(NP,1)=BFLXT(NP,2)
         BFLXT(NP,2)=0.0D0
      ENDDO
C
      DO MP=1,NBES
         LS=ISB(5,MP)
         M=ISB(6,MP)
         ID = NIK(M)
         NODE=4
         DO 120 IQ=1,NODE
            I=KGB(IQ,LS,ID)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
               NODE=3
               GOTO 120
            ENDIF
            NI=IE(M,I)
            FFQ(IQ)=DCOSB(1,MP)*F(NI,1)+DCOSB(2,MP)*F(NI,2)+
     1              DCOSB(3,MP)*F(NI,3)
            DET(IQ)=DETAB(IQ,MP)
  120    CONTINUE
C
         CALL Q34BB (RRQ,FFQ,NODE,DET)
C
         DO IQ=1,NODE
            NII=ISB(IQ,MP)
            BFLXT(NII,2)=BFLXT(NII,2)+RRQ(IQ)
         ENDDO
      ENDDO
      IF(KFLOW.GT.0) GO TO 200
      DO NP=1,NBNP
         BFLXT(NP,1)=BFLXT(NP,2)
      ENDDO
      DO I=1,14
         TFLOWT(I)=0.0D0
      ENDDO
C
C ******* DETERMINE FLOWS AND FLOW RATES THROUGH VARIOUS TYPES OF NODES,
C ******* STARTING WITH THE NET FLOWS THROUGH ALL BOUNDARY NODES
C
  200 S=0.0D0
      SP=0.0D0
      DO NP=1,NBNP
         S=S+BFLXT(NP,2)
         SP=SP+BFLXT(NP,1)
      ENDDO
      FRATET(7)=S
      FLOWT(7)=0.5D0*(S+SP)*DELT
C
C ******* THROUGH DIRICHLET BOUNDARY NODES
C
      FRATET(1)=0.0D0
      FLOWT(1)=0.0D0
      IF (NDNPT.LE.0) GO TO 340
      S=0.0D0
      SP=0.0D0
      DO NPP=1,NDNPT
         NP=NPDBT(NPP)
         DO 310 I=1,NBNP
            IJ=NPBB(I)
            IF (IJ.NE.NP) GO TO 310
            NII=I
            GO TO 320
  310    CONTINUE
  320    CONTINUE
         S=S+BFLXT(NII,2)
         SP=SP+BFLXT(NII,1)
      ENDDO
      FRATET(1)=S
      FLOWT(1)=0.5D0*(S+SP)*DELT
C
C ******* THROUGH CAUCHY NODES
C
  340 FRATET(2)=0.0D0
      FLOWT(2)=0.0D0
      IF (NCNPT.LE.0) GO TO 380
      S=0.0D0
      SP=0.0D0
      DO NPP=1,NCNPT
         NII=NPCBT(NPP)
         S=S+BFLXT(NII,2)
         SP=SP+BFLXT(NII,1)
      ENDDO
      FRATET(2)=S
      FLOWT(2)=0.5D0*(S+SP)*DELT
C
C ******* THROUGH NEUMANN NODES
C
  380 FRATET(3)=0.0D0
      FLOWT(3)=0.0D0
      IF (NNNPT.LE.0) GO TO 400
      S=0.0D0
      SP=0.0D0
      DO NPP=1,NNNPT
         NII=NPNBT(NPP)
         S=S+BFLXT(NII,2)
         SP=SP+BFLXT(NII,1)
      ENDDO
      FRATET(3)=S
      FLOWT(3)=0.5D0*(S+SP)*DELT
C
C ******* THROUGH RUN-IN SEEP-OUT NODES
C
  400 FRATET(4)=0.0D0
      FLOWT(4)=0.0D0
      FRATET(5)=0.0D0
      FLOWT(5)=0.0D0
      IF (NVNPT.LE.0) GO TO 500
      S=0.0D0
      SP=0.0D0
      SM=0.0D0
      SMP=0.0D0
      DO 490 NPP=1,NVNPT
         NII=NPVBT(NPP)
         IF (BFLXT(NII,2).LT.0.0D0) GO TO 460
         S=S+BFLXT(NII,2)
         GO TO 470
  460    SM=SM+BFLXT(NII,2)
  470    IF (BFLXT(NII,1).LT.0.0D0) GO TO 480
         SP=SP+BFLXT(NII,1)
         GO TO 490
  480    SMP=SMP+BFLXT(NII,1)
  490 CONTINUE
      FRATET(4)=S
      FLOWT(4)=0.5D0*(S+SP)*DELT
      FRATET(5)=SM
      FLOWT(5)=0.5D0*(SM+SMP)*DELT
C
C ******* NUMERICAL FLOW THROUGH UNSPECIFIED BOUNDARY NODES
C
  500 S=0.0D0
      SP=0.0D0
      DO I=1,5
         S=S+FRATET(I)
         SP=SP+FLOWT(I)
      ENDDO
      FRATET(6)=FRATET(7)-S
      FLOWT(6)=FLOWT(7)-SP
C
C ******* CALCULATE INCREASES OF INTEGRATED MATERIAL CONTENTS IN THE
C ******* FLUID QR AND IN SOLID QD; DETERMINE LOSSES DUE TO RADIOACTIVE
C ******* DECAY QL; AND COMPUTE INTEGRATE THE SOURCE/SINK SOURCES
C
      QR=0.0D0
      QD=0.0D0
      SUM=0.0D0
      QL=0.0D0
      QDH=0.0D0
      QLKW=0.0D0
      QLKS=0.0D0
      SOURCE=0.0D0
C
      DO M=1,NEL
         NODE = IJNOD(M)
         MTYP =IE(M,9)
         RHOB =PROPT(2,MTYP)
         LAMBDA=PROPT(7,MTYP)
         FNLS =PROPT(8,MTYP)
         ALP=PROPF(7,MTYP)
C
C         Modify for fraction of mobile water.
C
         FM=PROPT(13,MTYP)
         POR=PROPF(8,MTYP)
         THI=(1.0D0-FM)*POR
         KD   =PROPT(1,MTYP)*FM
         RKW =PROPT(11,MTYP)*FM
         RKS =PROPT(12,MTYP)*FM
C
         DO 650 IQ=1,NODE
            NP=IE(M,IQ)
            CQ(IQ)=C(NP)
            DHQ(IQ)=(H(NP)-HP(NP))
            IF (DELT.NE.0.0D0) DHQ(IQ)=DHQ(IQ)/DELT
         GO TO (610,620,630), KSORP
  610    CSQ(IQ)=KD*CQ(IQ)
         GO TO 650
  620    CSQ(IQ)=KD*CQ(IQ)**FNLS
         GO TO 650
  630    CSQ(IQ)=KD*FNLS*CQ(IQ)/(1.0D0+KD*CQ(IQ))
  650    CONTINUE
         DO KG=1,NODE
C
C         Modify for fraction of mobile water.
C
            THG(KG)=TH(KG,M)-THI
         ENDDO
C
         CALL Q468R (QRM,QDM,QDHM,CQ,CSQ,DHQ,THG,RHOB,NODE, M)
C
         QR =QR+QRM
         QD =QD+QDM*RHOB
         QLM=QRM+QDM*RHOB
         QL =QL+LAMBDA*QLM
         QLKW=QLKW+RKW*QRM
         QLKS=QLKS+RKS*RHOB*QDM
         QDHM=QDH+ALP*QDHM
      ENDDO
C
C ******** INCORPORATE WELL SOURCE/SINK
C
      IF (NWNPT.LE.0) GO TO 705
      DO I=1,NWNPT
         ITYP=JWTYPF(I)
         WSSQ=WSSF(ITYP)
         JTYP=JWTYPT(I)
         WSSC=WSST(JTYP)
         NI=NPWT(I)
         IF (WSSQ.LT.0.0D0) SOURCE=SOURCE-WSSQ*C(NI)
         IF (WSSQ.GE.0.0D0) SOURCE=SOURCE-WSSQ*WSSC
      ENDDO
  705 IF (KFLOW.GT.0) GO TO 710
      QRP=0.0D0
      QDP=0.0D0
      QLP=QL
      QDHP=0.0D0
      QLKWP=QLKW
      QLKSP=QLKS
      SOURSP=SOURCE
      SUM=QR+QD
      S=FRATET(7)+QL+SOURCE
  710 FLOWT(8)=QR-QRP
      IF (DELT.LE.0.000010D0) THEN
         FRATET(8)=FLOWT(8)
      ELSE
         FRATET(8)=FLOWT(8)/DELT
      ENDIF
      IF (KFLOW.LE.0 .AND. SUM.NE.0.0D0) FRATET(8)=-S*QR/SUM
      FLOWT(9)=QD-QDP
      IF (DELT.LE.0.0000010d0) THEN
         FRATET(9)=FLOWT(9)
      ELSE
         FRATET(9)=FLOWT(9)/DELT
      ENDIF
      IF (KFLOW.LE.0 .AND. SUM.NE.0.0D0) FRATET(9)=-S*QD/SUM
      FRATET(10)=QL
      FRATET(11)=QDHP
      FRATET(12)=QLKW
      FRATET(13)=QLKS
      FRATET(14)=SOURCE
      FLOWT(10)=0.5D0*(QL+QLP)*DELT
      FLOWT(11)=0.5D0*(QDH+QDHP)*DELT
      FLOWT(12)=0.5D0*(QLKW+QLKWP)*DELT
      FLOWT(13)=0.5D0*(QLKS+QLKSP)*DELT
      FLOWT(14)=0.5D0*(SOURCE+SOURSP)*DELT
      DO I=1,14
         TFLOWT(I)=TFLOWT(I)+FLOWT(I)
      ENDDO
      RETURN
      END
C
      SUBROUTINE Q34BB (RQ,FQ,NODE,DET)
C
C ------- TO COMPUTE THE NORMAL FLOW RATES (M/T) BY INTEGRATING THE
C ------- NORMAL FLUXES (M/L**2/T) OVER A BOUNDARY SURFACE.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      COMMON /BS1/ RNS4(4,4),RNS3(3,3)
C
      DIMENSION RQ(4),FQ(4),RN(4),DET(4)
C
C ------- INITIATE MATRICES RQ(IQ)
C
      DO IQ=1,4
         RQ(IQ)=0.0D0
      ENDDO
C
C ------- SUMMATION OF THE INTEGRAND OVER THE GAUSSIAN POINTS
C
      DO KG=1,NODE
         IF (NODE.EQ.4) THEN
            RN(1)=RNS4(1,KG)
            RN(2)=RNS4(2,KG)
            RN(3)=RNS4(3,KG)
            RN(4)=RNS4(4,KG)
         ELSE
            RN(1)=RNS3(1,KG)
            RN(2)=RNS3(2,KG)
            RN(3)=RNS3(3,KG)
         ENDIF
C
C ------- ACCUMULATE THE SUMS TO OBTAIN THE MATRIX INTEGRALS RQ(IQ)
C
         FK=0.0D0
         DO IQ=1,NODE
            FK=FK+FQ(IQ)*RN(IQ)
         ENDDO
         DO IQ=1,4
            RQ(IQ)=RQ(IQ)+RN(IQ)*FK*DET(KG)
         ENDDO
      ENDDO
      RETURN
      END
C
      SUBROUTINE Q468R (QRM,QDM,QDHM,CQ,CSQ,DHQ,THG,RHOB,NODE,M)
C
C ------- TO COMPUTE THE MATERIAL INTEGRATION AND ELEMENT SOURCE
C ------- INTEGRATION OVER AN ELEMENT.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /JACOB1/ RNH(8,8),RNP(6,6),RNT(4,4)
      COMMON /JACOB2/ DJACS(8,MAXELK)
C
      DIMENSION CQ(8),CSQ(8),THG(8),DHQ(8),RN(8)
C
      QRM=0.0D0
      QDM=0.0D0
      QDHM=0.0D0
C
      DO KG=1,NODE
C
C ------- DETERMINE LOACAL COORDINATE OF GAUSSIAN POINT KG.
C
         DJAC=DJACS(KG,M)
         IF (NODE.EQ.8) THEN
            DO I=1,8
               RN(I)=RNH(I,KG)
            ENDDO
         ELSEIF(NODE.EQ.6) THEN
C
            DO I=1,6
               RN(I)=RNP(I,KG)
            ENDDO
         ELSEIF(NODE.EQ.4) THEN
C
            DO I=1,4
               RN(I)=RNT(I,KG)
            ENDDO
         ENDIF
C
C ------- CALCULATE VALUES OF BASIS FUNCTIONS N(IQ).
C ------- INTERPOLATE TO OBTAIN WATER CONTENT AT THE GAUSSIAN POINT KG
C
         CQP=0.0D0
         CSQP=0.0D0
         DHQP=0.0D0
         DO IQ=1,NODE
            CQP =CQP+CQ(IQ)*RN(IQ)
            CSQP=CSQP+CSQ(IQ)*RN(IQ)
            DHQP=DHQP+DHQ(IQ)*RN(IQ)
         ENDDO
         THQP=THG(KG)
C
C ------- ACCUMULATE THE SUM TO EVALUATE THE INTEGRAL
C
         QRM=QRM+THQP*CQP*DJAC
         QDM=QDM+CSQP*DJAC
         QDHM=QDHM+(THQP*CQP+RHOB*CSQP)*DHQP*DJAC
      ENDDO
      RETURN
      END
C
      SUBROUTINE TPRINT(C,F,STIME,DELT,ITIM)
C
C ------- TO OUTPUT MATERIAL FLOWS, CONCENTRATION, AND MATERIAL FLUXES
C ------- AS SPECIFIED BY THE PARAMETER KPR.
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /NINTR/ NSELT,KPR0(7),KPRT,KDSK,KSSF,KSST
      COMMON /TFLOW/ FRATET(14),FLOWT(14),TFLOWT(14)
C
      DIMENSION C(MAXNPK),F(MAXNPK,3)
      DIMENSION  TRATE(14),TINC(14),TTOTAL(14)
C
      IF (KPR0(1).LE.0) RETURN
C
      DO 100 I=1,NSELT
         KPR=KPR0(I)
C
C    make the sign consistent with GMS
C
         DO J=1,14
            TRATE(J)=-FRATET(J)
            TINC(J)=-FLOWT(J)
            TTOTAL(J)=-TFLOWT(J)
         ENDDO
         GO TO (10,100,100,40,50,100,100), KPR
   10    CONTINUE
C
C ----- PRINT FLOW THROUGH ALL TYPES OF BOUNDARIES
C
         WRITE(16,1000) STIME,DELT,ITIM
         WRITE(16,1100) (TRATE(K),TINC(K),TTOTAL(K),K=1,14)
         GO TO 100
   40    CONTINUE
C
C ----- PRINT CONCENTRATIONS
C
         WRITE(16,2000) STIME,DELT,ITIM
         DO NI=1,NNP,5
            J1=NI
            J2=MIN0(NI+4,NNP)
            WRITE(16,2100) (NJ,C(NJ),NJ=J1,J2)
         ENDDO
         GO TO 100
   50    CONTINUE
C
C ----- PRINT MATERIAL FLUXES
C
         WRITE(16,3000) STIME,DELT,ITIM
         DO NI=1,NNP,3
            J1=NI
            J2=MIN0(NI+2,NNP)
            WRITE(16,3100) (NJ,(F(NJ,K),K=1,3),NJ=J1,J2)
         ENDDO
  100 CONTINUE
      RETURN
 1000 FORMAT(///' SYSTEM-FLOW TABLE','   AT TIME =',1PD11.3,
     1 ' ,(DELT =',1PD11.3,')',' ITIM=',I5)
 1100 FORMAT(//1X,'TRANSPORT SIMULATION',27X,'RATE',4X,'INC. FLOW',2X,
     1 'TOTAL FLOW'/1X,
     2 ' 1. THROUGH DIRICHLET BOUNDARY NODES . . . ',3(1PD11.3)/1X,
     3 ' 2. THROUGH CAUCHY BOUNDARY NODES . .  . . ',3(1PD11.3)/1X,
     4 ' 3. THROUGH NEUMANN BOUNDARY NODES . . . . ',3(1PD11.3)/1X,
     5 ' 4. THROUGH SEEPAGE NODES . . . . . .  . . ',3(1PD11.3)/1X,
     6 ' 5. THROUGH INFILTRATION NODES .. . .  . . ',3(1PD11.3)/1X,
     7 ' 6. THROUGH UNSPECIFIED NODES(NUMERICAL) . ',3(1PD11.3)/1X,
     8 ' 7. NET FLOW THROUGH ENTIRE BOUNDARY NODES ',3(1PD11.3)/1X,
     9 ' 8. INCREASE IN MATERIAL CONTENT (LIQUID) .',3(1PD11.3)/1X,
     A ' 9. INCREASE IN MATERIAL CONTENT (SOLID) . ',3(1PD11.3)/1X,
     B '10. RADIOACTIVE LOSSES (LIQUID AND SOLID) .',3(1PD11.3)/1X,
     C '11. LOSS TO COMP. OF SKELTON . . . . . . ..',3(1PD11.3)/1X,
     D '12. LOSS THROUGH DISSOLVED PHASE . . . . ..',3(1PD11.3)/1X,
     E '13. LOSS THROUGH ADSORBED PHASE . . . . . .',3(1PD11.3)/1X,
     F '14. ARTIFICIAL SOURCES/SINKS . . . . . . ..',3(1PD11.3)/1X,
     G ' *** NOTE: (-) = OUT FROM, (+) = INTO THE REGION. '/1X,
     H ' *** RATE ( M/T ), INC. FLOW ( M ), TOTAL FLOW ( M )'/)
 2000 FORMAT('   CONCENTRATIONS(M/L**3) AT TIME =',
     1 1PD12.4   /5X,' (DELT =',1PD12.4,')'    ,' *** ITIME =',I6/1X,
     2 5(' NODE   C(M/L**3)  ')/1X,5(' ---- ------------ ')/)
 2100 FORMAT(1H ,5(I5,E13.4E3,1X))
 3000 FORMAT('   MATERIAL FLUX (M/L**2/T) AT TIME =',
     1 1PD12.4/5X,' (DELT =',1PD12.4,')'    ,' *** ITIME =',I6//1X,
     2 3(' NODE     FX         FY         FZ     ')/1X,
     3 3(' ------------------------------------- ')/)
 3100 FORMAT(1H ,3(I5,1PD11.3,1PD11.3,1PD11.3,1X))
      END
C
      SUBROUTINE TSTORE (C,TFLXB,NTFILE)
C
C ------- TO STORE PERTINENT QUANTITIES FOR POST-PROCESSING
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /TTIME/ DELT,TMAX,STIME
      COMMON /TCCARD/ IUNIT,JOPT,KOPT,IFILE,NPRINT,NPOST,
     1               ICFILE,IVFILE,PTIMES(MXPOST),POTIME(MXPOST)
      COMMON /ICCARD/ JICH,JICV,JICC,JICM,JIBF,JIBT,
     1               JPH,JCN,JVL,JMN,JMC,JBF,JBT
      COMMON /FTFILE/ KPH,KCN,KVL,KMC,KBF,KBT,JFILE,KFILE
      COMMON /OCCARD/ KSELT,KSAVE(6)
      COMMON /ICINT / IHEAD,ICON,ISTART
C
      DIMENSION C(MAXNPK),TFLXB(MAXNPK)
C
      DATA IVER/3000/
      DATA N6 /6/
      DATA JSFLT,JSFLG,ISTAT /8,4,0/
      DATA IOBTY,ISFLT,ISFLG,ISCL,INODE,IELEM,INAME,ITS
     % /100,110,120,130,170,180,190,200/
C
      CHARACTER FNAME*80
      CHARACTER*40 conc_name,mafx_name
C
      DATA conc_name/ 'concentration'/
      DATA mafx_name/ 'material_flux'/
C
C   ------  ASCII FILE
C
      IF (IFILE.EQ.0) THEN
C
C      ------ hot start
C
         IF (ISTART.EQ.1) THEN
C
            IF (KFILE.EQ.0) THEN
C
C   ------  Concentration
C
               IF (KCN.EQ.0) THEN
                  INQUIRE(51,NAME=FNAME)
                  write(*,1010) FNAME
                  WRITE(51,1001) 'DATASET'
                  WRITE(51,1007) 'OBJTYPE','mesh3d'
                  WRITE(51,1002) 'BEGSCL'
                  WRITE(51,1003) 'ND',NNP
                  WRITE(51,1003) 'NC',NEL
                  WRITE(51,1004) 'NAME',conc_name
               ELSEIF (KCN.EQ.1) THEN
                  INQUIRE(53,NAME=FNAME)
                  write(*,1010) FNAME
                  WRITE(53,1001) 'DATASET'
                  WRITE(53,1007) 'OBJTYPE','mesh3d'
                  WRITE(53,1002) 'BEGSCL'
                  WRITE(53,1003) 'ND',NNP
                  WRITE(53,1003) 'NC',NEL
                  WRITE(53,1004) 'NAME',conc_name
               ENDIF
C
C   ------  Flux for concentration
C
               IF (KBT.EQ.0) THEN
                    INQUIRE(52,NAME=FNAME)
                    write(*,1010) FNAME
                    WRITE(52,1001) 'DATASET'
                    WRITE(52,1007) 'OBJTYPE','mesh3d'
                    WRITE(52,1002) 'BEGSCL'
                    WRITE(52,1003) 'ND',NNP
                    WRITE(52,1003) 'NC',NEL
                    WRITE(52,1004) 'NAME',mafx_name
               ELSEIF (KBT.EQ.1) THEN
                    INQUIRE(54,NAME=FNAME)
                    write(*,1010) FNAME
                    WRITE(54,1001) 'DATASET'
                    WRITE(54,1007) 'OBJTYPE','mesh3d'
                    WRITE(54,1002) 'BEGSCL'
                    WRITE(54,1003) 'ND',NNP
                    WRITE(54,1003) 'NC',NEL
                    WRITE(54,1004) 'NAME',mafx_name
               ENDIF
               KFILE=1
            ENDIF
C
            write(*,1009) STIME
C
            DO K=1,KSELT
C
C   ------  Concentration
C
               IF (KSAVE(K).EQ.5) THEN
                  IF (KCN.EQ.0) THEN
                     INQUIRE(51,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(51,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(51,1006) C(I)
                     ENDDO
                  ELSEIF (KCN.EQ.1) THEN
                     INQUIRE(53,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(53,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(53,1006) C(I)
                     ENDDO
                  ENDIF
C
C   ------  Flux for concentration
C
               ELSEIF (KSAVE(K).EQ.6) THEN
                  IF (KBT.EQ.0) THEN
                     INQUIRE(52,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(52,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(52,1006) TFLXB(I)
                     ENDDO
                  ELSEIF (KBT.EQ.1) THEN
                     INQUIRE(54,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(54,1005) 'TS',ISTAT,STIME
                     DO I=1,NNP
                        WRITE(54,1006) TFLXB(I)
                     ENDDO
                  ENDIF
               ENDIF
            ENDDO
C
C      ------ cold start
C
         ELSEIF (ISTART.EQ.0) THEN
C
            write(*,1009) STIME
C
            IF (NTFILE.EQ.0) THEN
C
               DO 100 K=1,KSELT
C
C   ------  Concentration
C
                  IF (KSAVE(K).EQ.5) THEN
                     IF (KCN.EQ.0) THEN
                        INQUIRE(51,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(51,1001) 'DATASET'
                        WRITE(51,1007) 'OBJTYPE','mesh3d'
                        WRITE(51,1002) 'BEGSCL'
                        WRITE(51,1003) 'ND',NNP
                        WRITE(51,1003) 'NC',NEL
                        WRITE(51,1004) 'NAME',conc_name
                        WRITE(51,1005) 'TS',ISTAT,STIME
                        DO I=1,NNP
                           WRITE(51,1006) C(I)
                        ENDDO
                     ELSEIF (KCN.EQ.1) THEN
                        INQUIRE(53,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(53,1001) 'DATASET'
                        WRITE(53,1007) 'OBJTYPE','mesh3d'
                        WRITE(53,1002) 'BEGSCL'
                        WRITE(53,1003) 'ND',NNP
                        WRITE(53,1003) 'NC',NEL
                        WRITE(53,1004) 'NAME',conc_name
                        WRITE(53,1005) 'TS',ISTAT,STIME
                        DO I=1,NNP
                           WRITE(53,1006) C(I)
                        ENDDO
                     ENDIF
C
C   ------  Flux for concentration
C
                  ELSEIF (KSAVE(K).EQ.6) THEN
                     IF (KBT.EQ.0) THEN
                        INQUIRE(52,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(52,1001) 'DATASET'
                        WRITE(52,1007) 'OBJTYPE','mesh3d'
                        WRITE(52,1002) 'BEGSCL'
                        WRITE(52,1003) 'ND',NNP
                        WRITE(52,1003) 'NC',NEL
                        WRITE(52,1004) 'NAME',mafx_name
                        WRITE(52,1005) 'TS',ISTAT,STIME
                        DO I=1,NNP
                           WRITE(52,1006) TFLXB(I)
                        ENDDO
                     ELSEIF (KBT.EQ.1) THEN
                        INQUIRE(54,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(54,1001) 'DATASET'
                        WRITE(54,1007) 'OBJTYPE','mesh3d'
                        WRITE(54,1002) 'BEGSCL'
                        WRITE(54,1003) 'ND',NNP
                        WRITE(54,1003) 'NC',NEL
                        WRITE(54,1004) 'NAME',mafx_name
                        WRITE(54,1005) 'TS',ISTAT,STIME
                        DO I=1,NNP
                           WRITE(54,1006) TFLXB(I)
                        ENDDO
                     ENDIF
                  ENDIF
  100          CONTINUE
               NTFILE=1
C
            ELSEIF (NTFILE.EQ.1) THEN
C
               DO K=1,KSELT
C
C   ------  Concentration
C
                  IF (KSAVE(K).EQ.5) THEN
                     IF (KCN.EQ.0) THEN
                        INQUIRE(51,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(51,1005) 'TS',ISTAT,STIME
                        DO I=1,NNP
                           WRITE(51,1006) C(I)
                        ENDDO
                     ELSEIF (KCN.EQ.1) THEN
                        INQUIRE(53,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(53,1005) 'TS',ISTAT,STIME
                        DO I=1,NNP
                           WRITE(53,1006) C(I)
                        ENDDO
                     ENDIF
C
C   ------  Flux for concentration
C
                  ELSEIF (KSAVE(K).EQ.6) THEN
                     IF (KBT.EQ.0) THEN
                        INQUIRE(52,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(52,1005) 'TS',ISTAT,STIME
                        DO I=1,NNP
                           WRITE(52,1006) TFLXB(I)
                        ENDDO
                     ELSEIF (KBT.EQ.1) THEN
                        INQUIRE(54,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(54,1005) 'TS',ISTAT,STIME
                        DO I=1,NNP
                           WRITE(54,1006) TFLXB(I)
                        ENDDO
                     ENDIF
                  ENDIF
               ENDDO
            ENDIF
         ENDIF
C
C   ------  BINARY FILE
C
      ELSEIF (IFILE.EQ.1) THEN
C
C      ------ hot start
C
         IF (ISTART.EQ.1) THEN
C
            IF (KFILE.EQ.0) THEN
C
C   ------  Concentration
C
               IF (KCN.EQ.0) THEN
                  INQUIRE(61,NAME=FNAME)
                  write(*,1010) FNAME
                  WRITE(61) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                  WRITE(61) ISCL
                  WRITE(61) INODE,NNP
                  WRITE(61) IELEM,NEL
                  WRITE(61) INAME,conc_name
               ELSEIF (KCN.EQ.1) THEN
                  INQUIRE(63,NAME=FNAME)
                  write(*,1010) FNAME
                  WRITE(63) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                  WRITE(63) ISCL
                  WRITE(63) INODE,NNP
                  WRITE(63) IELEM,NEL
                  WRITE(63) INAME,conc_name
               ENDIF
C
C   ------  Flux for concentration
C
               IF (KBT.EQ.0) THEN
                  INQUIRE(62,NAME=FNAME)
                  write(*,1010) FNAME
                  WRITE(62) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                  WRITE(62) ISCL
                  WRITE(62) INODE,NNP
                  WRITE(62) IELEM,NEL
                  WRITE(62) INAME,mafx_name
               ELSEIF (KBT.EQ.1) THEN
                  INQUIRE(64,NAME=FNAME)
                  write(*,1010) FNAME
                  WRITE(64) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                  WRITE(64) ISCL
                  WRITE(64) INODE,NNP
                  WRITE(64) IELEM,NEL
                  WRITE(64) INAME,mafx_name
               ENDIF
               KFILE=1
            ENDIF
C
            write(*,1009) STIME
C
            DO K=1,KSELT
C
C   ------  Concentration
C
               IF (KSAVE(K).EQ.5) THEN
                  IF (KCN.EQ.0) THEN
                     INQUIRE(61,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(61) ITS,ISTAT,STIME
                     WRITE(61) (C(I),I=1,NNP)
                  ELSEIF (KCN.EQ.1) THEN
                     INQUIRE(63,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(63) ITS,ISTAT,STIME
                     WRITE(63) (C(I),I=1,NNP)
                  ENDIF
C
C   ------  Flux for concentration
C
               ELSEIF (KSAVE(K).EQ.6) THEN
                  IF (KBT.EQ.0) THEN
                     INQUIRE(62,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(62) ITS,ISTAT,STIME
                     WRITE(62) (TFLXB(I),I=1,NNP)
                  ELSEIF (KBT.EQ.1) THEN
                     INQUIRE(64,NAME=FNAME)
                     write(*,1010) FNAME
                     WRITE(64) ITS,ISTAT,STIME
                     WRITE(64) (TFLXB(I),I=1,NNP)
                  ENDIF
               ENDIF
            ENDDO
C
C      ------ cold start
C
         ELSEIF (ISTART.EQ.0) THEN
C
            write(*,1009) STIME
C
            IF (NTFILE.EQ.0) THEN
C
               DO K=1,KSELT
C
C   ------  Concentration
C
                  IF (KSAVE(K).EQ.5) THEN
                     IF (KCN.EQ.0) THEN
                        INQUIRE(61,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(61) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                        WRITE(61) ISCL
                        WRITE(61) INODE,NNP
                        WRITE(61) IELEM,NEL
                        WRITE(61) INAME,conc_name
                        WRITE(61) ITS,ISTAT,STIME
                        WRITE(61) (C(I),I=1,NNP)
                     ELSEIF (KCN.EQ.1) THEN
                        INQUIRE(63,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(63) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                        WRITE(63) ISCL
                        WRITE(63) INODE,NNP
                        WRITE(63) IELEM,NEL
                        WRITE(63) INAME,conc_name
                        WRITE(63) ITS,ISTAT,STIME
                        WRITE(63) (C(I),I=1,NNP)
                     ENDIF
C
C   ------  Flux for concentration
C
                  ELSEIF (KSAVE(K).EQ.6) THEN
                     IF (KBT.EQ.0) THEN
                        INQUIRE(62,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(62) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                        WRITE(62) ISCL
                        WRITE(62) INODE,NNP
                        WRITE(62) IELEM,NEL
                        WRITE(62) INAME,mafx_name
                        WRITE(62) ITS,ISTAT,STIME
                        WRITE(62) (TFLXB(I),I=1,NNP)
                     ELSEIF (KBT.EQ.1) THEN
                        INQUIRE(64,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(64) IVER,IOBTY,N6,ISFLT,JSFLT,ISFLG,JSFLG
                        WRITE(64) ISCL
                        WRITE(64) INODE,NNP
                        WRITE(64) IELEM,NEL
                        WRITE(64) INAME,mafx_name
                        WRITE(64) ITS,ISTAT,STIME
                        WRITE(64) (TFLXB(I),I=1,NNP)
                     ENDIF
                  ENDIF
               ENDDO
               NTFILE=1
C
            ELSEIF (NTFILE.EQ.1) THEN
C
               DO K=1,KSELT
C
                  IF (KSAVE(K).EQ.5) THEN
C
C   ------  Concentration
C
                     IF (KCN.EQ.0) THEN
                        INQUIRE(61,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(61) ITS,ISTAT,STIME
                        WRITE(61) (C(I),I=1,NNP)
                     ELSEIF (KCN.EQ.1) THEN
                        INQUIRE(63,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(63) ITS,ISTAT,STIME
                        WRITE(63) (C(I),I=1,NNP)
                     ENDIF
C
C   ------  Flux for concentration
C
                  ELSEIF (KSAVE(K).EQ.6) THEN
                     IF (KBT.EQ.0) THEN
                        INQUIRE(62,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(62) ITS,ISTAT,STIME
                        WRITE(62) (TFLXB(I),I=1,NNP)
                     ELSEIF (KBT.EQ.1) THEN
                        INQUIRE(64,NAME=FNAME)
                        write(*,1010) FNAME
                        WRITE(64) ITS,ISTAT,STIME
                        WRITE(64) (TFLXB(I),I=1,NNP)
                     ENDIF
                  ENDIF
               ENDDO
            ENDIF
         ENDIF
      ENDIF
      RETURN
 1001 FORMAT(A7)
 1002 FORMAT(A6)
 1003 FORMAT(A2,I8)
 1004 FORMAT(A4,1X,A40)
 1005 FORMAT(A2,I4,E16.8E3)
 1006 FORMAT(3(1X,E16.8E3))
 1007 FORMAT(A7,1X,A6)
 1008 FORMAT(8E16.8E3)
 1009 FORMAT(3X,'Time:',F12.5)
 1010 FORMAT(3X,'Written on file ',A72)
      END
C
      SUBROUTINE CG (ICH, NITER, OM, EPS, NNP, MAXNPK, MXJBDK, A,
     &  B, LRN, NLRN, ND, P, Q, R, XI, XL)
C
C
C         SET OF EQUATIONS:
C
C         A X = B
C
C         ICH = 1 - CONJUGATE GRADIENT WITH MAIN DIAGONAL AS
C                   PRECONDITIONER.
C
C                   K = D
C
C         ICH = 2 - CONJUGATE GRADIENT WITH INCOMPLETE LU FACTORIZATION
C                   AS PRECONDITIONER.
C
C                   K = (D + OM * L) D ** (-1) (D + OM * U)
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      DIMENSION LRN(MXJBDK, MAXNPK), ND(MAXNPK), NLRN(MAXNPK)
      DIMENSION A(MXJBDK, MAXNPK), B(MAXNPK)
      DIMENSION XI(MAXNPK), XL(MAXNPK), P(MAXNPK), Q(MAXNPK),
     &  R(MAXNPK), Z(MAXNPK), TMP(MAXNPK), DIAGR(MAXNPK)
C
C         SAVE THE RECIPROCAL OF THE MAIN DIAGONAL TERM.
C
      DO I = 1, NNP
        JDIAG = ND(I)
        DIAGR(I) = 1.0D0 / A(JDIAG, I)
      END DO
C
C         COMPUTE THE INITIAL RESIDUAL AND SOLUTION XL.
C
      RMAX = -1.0D0
      DO I = 1, NNP
        SUM = B(I)
        JCOL = NLRN(I)
        DO J = 1, JCOL
          JJ = LRN(J, I)
          SUM = SUM - A(J, I) * XI(JJ)
        END DO
        R(I) = SUM
        RMAX = DMAX1 (DABS (R(I)), RMAX)
        XL(I) = XI(I)
      END DO
C
      IF (RMAX .LE. EPS) RETURN
C
      N = 0
      RMAX = 1.0D10
      NIT10 = NITER / 10
C
C         BEGIN THE ITERATION.
C
      DO WHILE ((N .LT. NITER) .AND. (RMAX .GT. EPS))
C
        N = N + 1
C
C         SOLVE K Z = R.
C
        IF (ICH .EQ. 1) THEN
C
          DO I = 1, NNP
            Z(I) = R(I) * DIAGR(I)
          END DO
C
        ELSE
C
C         SOLVE the LU SYSTEM.
C
          TMP(NNP) = R(NNP) * DIAGR(NNP)
          DO I = 2, NNP
            II = NNP - I + 1
            SUM = 0.0D0
            JCOL = NLRN(II)
            DO J = 1, JCOL
              JJ = LRN(J, II)
              IF (JJ .GT. II) THEN
                SUM = SUM + A(J, II) * TMP(JJ)
              END IF
            END DO
            TMP(II) = (R(II) - SUM * OM) * DIAGR(II)
          END DO
C
          DO I = 1, NNP
            JDIAG = ND(I)
            TMP(I) = TMP(I) * A(JDIAG, I)
          END DO
C
          Z(1) = TMP(1) * DIAGR(1)
          DO I = 2, NNP
            SUM = 0.0D0
            JCOL = NLRN(I)
            DO J = 1, JCOL
              JJ = LRN(J, I)
              IF (JJ .LT. I) THEN
                SUM = SUM + A(J, I) * Z(JJ)
              END IF
            END DO
            Z(I) = (TMP(I) - SUM * OM) * DIAGR(I)
          END DO
C
        END IF
C
C         COMPUTE RHO.
C
        RHO = 0.0D0
        DO I = 1, NNP
          RHO = RHO + R(I) * Z(I)
        END DO
C
C         COMPUTE P.
C
        IF (N .EQ. 1) THEN
          DO I = 1, NNP
            P(I) = Z(I)
          END DO
        ELSE
          BETA = RHO / RHOSAV
          DO I = 1, NNP
            P(I) = Z(I) + BETA * P(I)
          END DO
        END IF
C
C         COMPUTE Q = MODIFIED CMATRX TIMES P.
C
        DO I = 1, NNP
          SUM = 0.0D0
          JCOL = NLRN(I)
          DO J = 1, JCOL
            JJ = LRN(J, I)
            SUM = SUM + A(J, I) * P(JJ)
          END DO
          Q(I) = SUM
        END DO
C
C         COMPUTE ALPHA.
C
        SUM = 0.0D0
        DO I = 1, NNP
          SUM = SUM + P(I) * Q(I)
        END DO
C
        IF (SUM .EQ. 0.0D0) THEN
C
          RMAX = 0.0D0
C
        ELSE
C
          ALP = RHO / SUM
C
C         COMPUTE THE NEW XL, R, AND RMAX.
C
          DO I = 1, NNP
            XL(I) = XL(I) + ALP * P(I)
            R(I) = R(I) - ALP * Q(I)
          END DO
C
          IF (N .GE. 5) THEN
            RMAX = -1.0D0
            DO I = 1, NNP
              RMAX = DMAX1 (DABS (R(I)), RMAX)
            END DO
          END IF
C
          IF (MOD (N, NIT10) .EQ. 0) THEN
            WRITE(*,5425) N, RMAX, EPS
 5425 FORMAT(1X,'PCG: Linear iteration #', I6,' ABSERR= ',E15.8,
     &       ' EPS= ', F8.6)
          END IF
C
          RHOSAV = RHO
C
        END IF
C
      END DO
C
      IF (RMAX .LE. EPS) THEN
        WRITE(*, 5426) N
 5426 FORMAT(1X, 'PCG: Linear solution converged in ', I6,
     &       ' iterations',/)
      ELSE
        WRITE(*, 5427) RMAX, N
 5427 FORMAT(1X, 'PCG WARNING: Linear solution did NOT converge to ',
     &       F8.6, ' in ', I6, ' iterations',/)
      END IF
C
      RETURN
      END
C
      SUBROUTINE ELENOD
     I    (IEM1,IEM2,
     O     NODE,NSIDE,IK)
C
      IF (IEM1.EQ.0) THEN
         NODE=4
         NSIDE=4
         IK=3
      ELSEIF(IEM2.EQ.0) THEN
         NODE=6
         NSIDE=5
         IK=2
      ELSE
         NODE=8
         NSIDE=6
         IK=1
      ENDIF
      RETURN
      END
C
      SUBROUTINE WRKARY(IE,X,Y,Z,VX,VY,VZ,MAXELK,MAXNPK,M,NODE,MXNODE,
     O            XX,YY,ZZ,VXX,VYY,VZZ)
C
      IMPLICIT REAL*8(A-H,O-Z)
C
      DIMENSION IE(MAXELK,9),X(MAXNPK),Y(MAXNPK),Z(MAXNPK),VX(MAXNPK)
      DIMENSION VY(MAXNPK),VZ(MAXNPK),XX(MXNODE),YY(MXNODE),ZZ(MXNODE)
      DIMENSION VXX(MXNODE),VYY(MXNODE),VZZ(MXNODE)
C
      DO I1=1,NODE
         II=IE(M,I1)
         XX(I1)=X(II)
         YY(I1)=Y(II)
         ZZ(I1)=Z(II)
         VXX(I1)=VX(II)
         VYY(I1)=VY(II)
         VZZ(I1)=VZ(II)
      ENDDO
      RETURN
      END
C
      SUBROUTINE GAUSS(X,IE)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /NOPTN/ ILUMP,IMID,KSORP,IQUAR
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /BLK1/ KGB(4,6,3)
      COMMON /BLK2/ S(8),T(8),U(8)
      COMMON /BRICK1/ SSP(8),TTP(8),UUP(8)
      COMMON /BRICK2/ DNSSB(8,8),DNTTB(8,8),DNUUB(8,8)
      COMMON /PRISM1/ XSIS(6),DL1S(6),DL2S(6),DL3S(6)
      COMMON /PRISM2/ DNSSP(6,6),DNTTP(6,6),DNUUP(6,6)
      COMMON /TETRA/ RLL1(4),RLL2(4),RLL3(4),RLL4(4)
C
      COMMON /JACOB1/ RNH(8,8),RNP(6,6),RNT(4,4)
      COMMON /JACOB2/ DJACS(8,MAXELK)
      COMMON /JACOB3/ QBS(8,8,MAXELK)
      COMMON /JACOB4/ RNH2(8,8,8),RNP2(6,6,6),RNT2(4,4,4)
      COMMON /JACOB5/ DJACN(8,8,MAXELK)
      COMMON /JACOB6/ CMX(MAXNPK)
      COMMON /DXYZ1/ DNXS(8,8,MAXELK)
      COMMON /DXYZ2/ DNYS(8,8,MAXELK)
      COMMON /DXYZ3/ DNZS(8,8,MAXELK)
      COMMON /THN1/ VOLELM(MAXELK),VOLNP(MAXNPK)
C
      COMMON /Q34/ PS,DL1(3),DL2(3),DL3(3)
      COMMON /Q34WG/ WG(3)
C
      DIMENSION X(MAXNPK,3),IE(MAXELK,9)
      DIMENSION XQ(8),YQ(8),ZQ(8),A(4),B(4),C(4),D(4)
      DIMENSION JV(4),XX(4),YY(4),ZZ(4)
      DIMENSION SL1(3),SL2(3),SL3(3)
C
      IF (IQUAR.EQ.12.OR. IQUAR.EQ.22) THEN
         P=0.577350269189626D0
         SL1(1)=0.666666666666667D0
         SL1(2)=0.166666666666667D0
         SL1(3)=0.166666666666667D0
         SL2(1)=0.166666666666667D0
         SL2(2)=0.666666666666667D0
         SL2(3)=0.166666666666667D0
         SL3(1)=0.166666666666667D0
         SL3(2)=0.166666666666667D0
         SL3(3)=0.666666666666667D0
         RLL1(1)=0.58541020D0
         RLL1(2)=0.13819660D0
         RLL1(3)=0.13819660D0
         RLL1(4)=0.13819660D0
         RLL2(1)=0.13819660D0
         RLL2(2)=0.58541020D0
         RLL2(3)=0.13819660D0
         RLL2(4)=0.13819660D0
         RLL3(1)=0.13819660D0
         RLL3(2)=0.13819660D0
         RLL3(3)=0.58541020D0
         RLL3(4)=0.13819660D0
         RLL4(1)=0.13819660D0
         RLL4(2)=0.13819660D0
         RLL4(3)=0.13819660D0
         RLL4(4)=0.58541020D0
      ELSE
         P=1.0D0
         SL1(1)=1.0D0
         SL1(2)=0.0D0
         SL1(3)=0.0D0
         SL2(1)=0.0D0
         SL2(2)=1.0D0
         SL2(3)=0.0D0
         SL3(1)=0.0D0
         SL3(2)=0.0D0
         SL3(3)=1.0D0
         RLL1(1)=1.0D0
         RLL1(2)=0.0D0
         RLL1(3)=0.0D0
         RLL1(4)=0.0D0
         RLL2(1)=0.0D0
         RLL2(2)=1.0D0
         RLL2(3)=0.0D0
         RLL2(4)=0.0D0
         RLL3(1)=0.0D0
         RLL3(2)=0.0D0
         RLL3(3)=1.0D0
         RLL3(4)=0.0D0
         RLL4(1)=0.0D0
         RLL4(2)=0.0D0
         RLL4(3)=0.0D0
         RLL4(4)=1.0D0
      ENDIF
C
C ------For surface integration
C
      IF (IQUAR.EQ.21.OR. IQUAR.EQ.22) THEN
         PS=0.577350269189626D0
         DL1(1)=0.666666666666667D0
         DL1(2)=0.166666666666667D0
         DL1(3)=0.166666666666667D0
         DL2(1)=0.166666666666667D0
         DL2(2)=0.666666666666667D0
         DL2(3)=0.166666666666667D0
         DL3(1)=0.166666666666667D0
         DL3(2)=0.166666666666667D0
         DL3(3)=0.666666666666667D0
      ELSE
         PS=1.0D0
         DL1(1)=1.0D0
         DL1(2)=0.0D0
         DL1(3)=0.0D0
         DL2(1)=0.0D0
         DL2(2)=1.0D0
         DL2(3)=0.0D0
         DL3(1)=0.0D0
         DL3(2)=0.0D0
         DL3(3)=1.0D0
      ENDIF
C
C ----- FOR HEXAHEDRAL ELEMENTS
C
      DO KG=1,8
         SS=P*S(KG)
         TT=P*T(KG)
         UU=P*U(KG)
         SSP(KG)=SS
         TTP(KG)=TT
         UUP(KG)=UU
C
         SM=1.0D0-SS
         SP=1.0D0+SS
         TM=1.0D0-TT
         TP=1.0D0+TT
         UM=1.0D0-UU
         UP=1.0D0+UU
C
         RNH(1,KG)=0.125D0*SM*TM*UM
         RNH(2,KG)=0.125D0*SP*TM*UM
         RNH(3,KG)=0.125D0*SP*TP*UM
         RNH(4,KG)=0.125D0*SM*TP*UM
         RNH(5,KG)=0.125D0*SM*TM*UP
         RNH(6,KG)=0.125D0*SP*TM*UP
         RNH(7,KG)=0.125D0*SP*TP*UP
         RNH(8,KG)=0.125D0*SM*TP*UP
C
         DNSSB(1,KG)=-.125D0*TM*UM
         DNSSB(2,KG)= .125D0*TM*UM
         DNSSB(3,KG)= .125D0*TP*UM
         DNSSB(4,KG)=-.125D0*TP*UM
         DNSSB(5,KG)=-.125D0*TM*UP
         DNSSB(6,KG)= .125D0*TM*UP
         DNSSB(7,KG)= .125D0*TP*UP
         DNSSB(8,KG)=-.125D0*TP*UP
C
         DNTTB(1,KG)=-.125D0*SM*UM
         DNTTB(2,KG)=-.125D0*SP*UM
         DNTTB(3,KG)= .125D0*SP*UM
         DNTTB(4,KG)= .125D0*SM*UM
         DNTTB(5,KG)=-.125D0*SM*UP
         DNTTB(6,KG)=-.125D0*SP*UP
         DNTTB(7,KG)= .125D0*SP*UP
         DNTTB(8,KG)= .125D0*SM*UP
C
         DNUUB(1,KG)=-.125D0*SM*TM
         DNUUB(2,KG)=-.125D0*SP*TM
         DNUUB(3,KG)=-.125D0*SP*TP
         DNUUB(4,KG)=-.125D0*SM*TP
         DNUUB(5,KG)= .125D0*SM*TM
         DNUUB(6,KG)= .125D0*SP*TM
         DNUUB(7,KG)= .125D0*SP*TP
         DNUUB(8,KG)= .125D0*SM*TP
C
         DO IQ=1,8
            DO JQ=1,8
               RNH2(IQ,JQ,KG)=RNH(IQ,KG)*RNH(JQ,KG)
            ENDDO
         ENDDO
      ENDDO
C
C ----- FOR PRISM ELEMENTS
C
      DO KG=1,6
         IF (KG.LE.3) THEN
             XSI=-P
             KKG=KG
         ELSE
             XSI=P
             KKG=KG-3
         ENDIF
         XSIS(KG)=XSI
         DDL1=SL1(KKG)
         DDL2=SL2(KKG)
         DDL3=SL3(KKG)
         DL1S(KG)=DDL1
         DL2S(KG)=DDL2
         DL3S(KG)=DDL3
C
         SM=1.0D0-XSI
         SP=1.0D0+XSI
         RNP(1,KG)=0.5D0*SM*DDL1
         RNP(2,KG)=0.5D0*SM*DDL2
         RNP(3,KG)=0.5D0*SM*DDL3
         RNP(4,KG)=0.5D0*SP*DDL1
         RNP(5,KG)=0.5D0*SP*DDL2
         RNP(6,KG)=0.5D0*SP*DDL3
C
         DNSSP(1,KG)=-.5D0*DDL1
         DNSSP(2,KG)=-.5D0*DDL2
         DNSSP(3,KG)=-.5D0*DDL3
         DNSSP(4,KG)=0.5D0*DDL1
         DNSSP(5,KG)=0.5D0*DDL2
         DNSSP(6,KG)=0.5D0*DDL3
C
         DNTTP(1,KG)=.5D0*SM
         DNTTP(2,KG)=0.0D0
         DNTTP(3,KG)=-.5D0*SM
         DNTTP(4,KG)=0.5D0*SP
         DNTTP(5,KG)=0.0D0
         DNTTP(6,KG)=-.5D0*SP
C
         DNUUP(1,KG)=0.0D0
         DNUUP(2,KG)=0.5D0*SM
         DNUUP(3,KG)=-.5D0*SM
         DNUUP(4,KG)=0.0D0
         DNUUP(5,KG)=0.5D0*SP
         DNUUP(6,KG)=-.5D0*SP
C
         DO IQ=1,6
            DO JQ=1,6
               RNP2(IQ,JQ,KG)=RNP(IQ,KG)*RNP(JQ,KG)
            ENDDO
         ENDDO
      ENDDO
C
C ----- FOR TETRAHEDRAL ELEMENTS
C
      DO KG=1,4
         RNT(1,KG)=RLL1(KG)
         RNT(2,KG)=RLL2(KG)
         RNT(3,KG)=RLL3(KG)
         RNT(4,KG)=RLL4(KG)
         DO IQ=1,4
            DO JQ=1,4
               RNT2(IQ,JQ,KG)=RNT(IQ,KG)*RNT(JQ,KG)
            ENDDO
         ENDDO
      ENDDO
C
      DO 100 M=1,NEL
          NODE=IJNOD(M)
          DO IQ=1,NODE
             NP=IE(M,IQ)
             XQ(IQ)=X(NP,1)
             YQ(IQ)=X(NP,2)
             ZQ(IQ)=X(NP,3)
             DO JQ=1,NODE
                QBS(IQ,JQ,M)=0.0D0
             ENDDO
          ENDDO
C
          IF (NODE.EQ.8) THEN
             DO KG=1,8
                SUM1=0.0D0
                SUM2=0.0D0
                SUM3=0.0D0
                SUM4=0.0D0
                SUM5=0.0D0
                SUM6=0.0D0
                SUM7=0.0D0
                SUM8=0.0D0
                SUM9=0.0D0
                DO I=1,8
                   SUM1=SUM1+XQ(I)*DNSSB(I,KG)
                   SUM2=SUM2+YQ(I)*DNSSB(I,KG)
                   SUM3=SUM3+ZQ(I)*DNSSB(I,KG)
                   SUM4=SUM4+XQ(I)*DNTTB(I,KG)
                   SUM5=SUM5+YQ(I)*DNTTB(I,KG)
                   SUM6=SUM6+ZQ(I)*DNTTB(I,KG)
                   SUM7=SUM7+XQ(I)*DNUUB(I,KG)
                   SUM8=SUM8+YQ(I)*DNUUB(I,KG)
                   SUM9=SUM9+ZQ(I)*DNUUB(I,KG)
                ENDDO
C
                DJAC = SUM1*(SUM5*SUM9-SUM6*SUM8)
     1            + SUM2*(SUM6*SUM7-SUM4*SUM9)
     2            + SUM3*(SUM4*SUM8-SUM5*SUM7)
C
               IF (DJAC.LE.1.0D-15) THEN
                   WRITE(*,2001) M
 2001 FORMAT(' DJAC <= 0.0 AT THE ELEMENT, ',I6)
        call stopfile  ! emrl jig
                   STOP 'GAUSS'
                ENDIF
C
                DJACI=1.0D0/DJAC
                DJACS(KG,M)=DJAC
                DO IQ=1,8
                   DJACN(IQ,KG,M)=RNH(IQ,KG)*DJAC
                   DO JQ=1,8
                      QBS(IQ,JQ,M) = QBS(IQ,JQ,M)
     1                          +RNH(IQ,KG)*RNH(JQ,KG)*DJAC
                   ENDDO
                ENDDO
                SUMI1=DJACI*(SUM5*SUM9-SUM6*SUM8)
                SUMI2=DJACI*(SUM3*SUM8-SUM2*SUM9)
                SUMI3=DJACI*(SUM2*SUM6-SUM3*SUM5)
                SUMI4=DJACI*(SUM6*SUM7-SUM4*SUM9)
                SUMI5=DJACI*(SUM1*SUM9-SUM3*SUM7)
                SUMI6=DJACI*(SUM3*SUM4-SUM1*SUM6)
                SUMI7=DJACI*(SUM4*SUM8-SUM5*SUM7)
                SUMI8=DJACI*(SUM2*SUM7-SUM1*SUM8)
                SUMI9=DJACI*(SUM1*SUM5-SUM2*SUM4)
C
                DO I=1,8
                   DNXS(I,KG,M)=SUMI1*DNSSB(I,KG)
     1                 +SUMI2*DNTTB(I,KG)+SUMI3*DNUUB(I,KG)
                   DNYS(I,KG,M)=SUMI4*DNSSB(I,KG)
     1                 +SUMI5*DNTTB(I,KG)+SUMI6*DNUUB(I,KG)
                   DNZS(I,KG,M)=SUMI7*DNSSB(I,KG)
     1                 +SUMI8*DNTTB(I,KG)+SUMI9*DNUUB(I,KG)
                ENDDO
              ENDDO
C
C ----- FOR PRISM ELEMENTS
C
           ELSEIF (NODE.EQ.6) THEN
              DO KG=1,6
                 XSI=XSIS(KG)
                 DDL1=DL1S(KG)
                 DDL2=DL2S(KG)
                 DDL3=DL3S(KG)
C
                 X3416=XQ(3)+XQ(4)-XQ(1)-XQ(6)
                 X3526=XQ(3)+XQ(5)-XQ(2)-XQ(6)
                 X1436=XQ(1)+XQ(4)-XQ(3)-XQ(6)
                 X2536=XQ(2)+XQ(5)-XQ(3)-XQ(6)
                 Y3416=YQ(3)+YQ(4)-YQ(1)-YQ(6)
                 Y3526=YQ(3)+YQ(5)-YQ(2)-YQ(6)
                 Y1436=YQ(1)+YQ(4)-YQ(3)-YQ(6)
                 Y2536=YQ(2)+YQ(5)-YQ(3)-YQ(6)
                 Z3416=ZQ(3)+ZQ(4)-ZQ(1)-ZQ(6)
                 Z3526=ZQ(3)+ZQ(5)-ZQ(2)-ZQ(6)
                 Z1436=ZQ(1)+ZQ(4)-ZQ(3)-ZQ(6)
                 Z2536=ZQ(2)+ZQ(5)-ZQ(3)-ZQ(6)
C
                 S11=0.5D0*(XQ(6)-XQ(3)+DDL1*X3416+DDL2*X3526)
                 S12=0.5D0*(YQ(6)-YQ(3)+DDL1*Y3416+DDL2*Y3526)
                 S13=0.5D0*(ZQ(6)-ZQ(3)+DDL1*Z3416+DDL2*Z3526)
                 S21=0.5D0*(X1436+XSI*X3416)
                 S22=0.5D0*(Y1436+XSI*Y3416)
                 S23=0.5D0*(Z1436+XSI*Z3416)
                 S31=0.5D0*(X2536+XSI*X3526)
                 S32=0.5D0*(Y2536+XSI*Y3526)
                 S33=0.5D0*(Z2536+XSI*Z3526)
C
                 DJAC=S11*S22*S33+S12*S23*S31+S13*S21*S32-
     >                S11*S32*S23-S12*S21*S33-S13*S31*S22
C
                 IF (DJAC.LE.1.0D-15) THEN
                   WRITE(*,2001) M
	       call stopfile  ! emrl jig
                   STOP 'GAUSS'
                 ENDIF
C
                 DJACI=1.0D0/DJAC
                 DJAC=DJAC*0.5D0
                 DJAC=DJAC/3.0D0
                 DJACS(KG,M)=DJAC
                 DO IQ=1,6
                    DJACN(IQ,KG,M)=RNP(IQ,KG)*DJAC
                    DO JQ=1,6
                      QBS(IQ,JQ,M) = QBS(IQ,JQ,M)
     1                    +RNP(IQ,KG)*RNP(JQ,KG)*DJAC
                    ENDDO
                 ENDDO
C
                 S1= DJACI*(S22*S33-S23*S32)
                 S2=-DJACI*(S12*S33-S13*S32)
                 S3= DJACI*(S12*S23-S13*S22)
                 S4=-DJACI*(S21*S33-S23*S31)
                 S5= DJACI*(S11*S33-S13*S31)
                 S6=-DJACI*(S11*S23-S13*S21)
                 S7= DJACI*(S21*S32-S22*S31)
                 S8=-DJACI*(S11*S32-S12*S31)
                 S9= DJACI*(S11*S22-S12*S21)
C
                 DO I=1,6
                    DNXS(I,KG,M)=S1*DNSSP(I,KG)+S2*DNTTP(I,KG)
     1                          +S3*DNUUP(I,KG)
                    DNYS(I,KG,M)=S4*DNSSP(I,KG)+S5*DNTTP(I,KG)
     1                          +S6*DNUUP(I,KG)
                    DNZS(I,KG,M)=S7*DNSSP(I,KG)+S8*DNTTP(I,KG)
     1                          +S9*DNUUP(I,KG)
                 ENDDO
              ENDDO
C
C ----- FOR TETRAHEDRAL ELEMENTS
C
           ELSE
              DO KG=1,4
                 DJAC=0.0D0
                 DO KK=1,4
                    GO TO (10,20,30,40), KK
   10               K1=2
                    K2=3
                    K3=4
                    GO TO 50
   20               K1=1
                    K2=3
                    K3=4
                    GO TO 50
   30               K1=1
                    K2=2
                    K3=4
                    GO TO 50
   40               K1=1
                    K2=2
                    K3=3
   50               CONTINUE
                    A(KK)=(-1.0D0)**(KK+1)*(XQ(K1)*YQ(K2)*ZQ(K3)+
     1               YQ(K1)*ZQ(K2)*XQ(K3)+ZQ(K1)*XQ(K2)*YQ(K3)-
     2               XQ(K3)*YQ(K2)*ZQ(K1)-YQ(K3)*ZQ(K2)*XQ(K1)-
     3               ZQ(K3)*XQ(K2)*YQ(K1))
                    B(KK)=(-1.0D0)**KK*(YQ(K1)*ZQ(K2)+
     1               YQ(K2)*ZQ(K3)+YQ(K3)*ZQ(K1)-
     2               YQ(K3)*ZQ(K2)-YQ(K2)*ZQ(K1)-
     3               YQ(K1)*ZQ(K3))
                    C(KK)=(-1.0D0)**(KK+1)*(XQ(K1)*ZQ(K2)+
     1               XQ(K2)*ZQ(K3)+XQ(K3)*ZQ(K1)-
     2               XQ(K3)*ZQ(K2)-XQ(K2)*ZQ(K1)-
     3               XQ(K1)*ZQ(K3))
                    D(KK)=(-1.0D0)**KK*(XQ(K1)*YQ(K2)+
     1               XQ(K2)*YQ(K3)+XQ(K3)*YQ(K1)-
     2               XQ(K3)*YQ(K2)-XQ(K2)*YQ(K1)-
     3               XQ(K1)*YQ(K3))
                    DJAC=DJAC+A(KK)
                 ENDDO
                 IF (DJAC.LE.1.0D-15) THEN
                    WRITE(*,2001) M
	       call stopfile  ! emrl jig
                    STOP 'GAUSS'
                 ENDIF
C
                DO KK=1,4
                   DNXS(KK,KG,M)=B(KK)/DJAC
                   DNYS(KK,KG,M)=C(KK)/DJAC
                   DNZS(KK,KG,M)=D(KK)/DJAC
                ENDDO
                DJAC=DJAC/24.0D0
                DJACS(KG,M)=DJAC
                DO IQ=1,4
                   DJACN(IQ,KG,M)=RNT(IQ,KG)*DJAC
                   DO JQ=1,4
                      QBS(IQ,JQ,M) = QBS(IQ,JQ,M)
     1                  +RNT(IQ,KG)*RNT(JQ,KG)*DJAC
                   ENDDO
                ENDDO
             ENDDO
          ENDIF
  100 CONTINUE
C
      DO I=1,NNP
         CMX(I)=0.0D0
      ENDDO
      DO M=1,NEL
         NODE=IJNOD(M)
         DO IQ=1,NODE
            NI=IE(M,IQ)
            DO JQ=1,NODE
               CMX(NI)=CMX(NI)+QBS(IQ,JQ,M)
            ENDDO
         ENDDO
      ENDDO
C
C----- Compute volume for each element
C
      DO NP=1,NNP
         VOLNP(NP)=0.0D0
      ENDDO
C
      DO 200 M=1,NEL
         NQ = IJNOD(M)
         NP1=IE(M,1)
         NP2=IE(M,2)
         NP3=IE(M,3)
         NP4=IE(M,4)
         IF (NQ.NE.4) THEN
            NP5=IE(M,5)
            NP6=IE(M,6)
            IF (NQ.EQ.8) THEN
               NP7=IE(M,7)
               NP8=IE(M,8)
            ENDIF
         ENDIF
C
         IF (NQ.EQ.8) THEN
             NV=6
         ELSEIF (NQ.EQ.6) THEN
             NV=3
         ELSE
             NV=1
         ENDIF
         VOL=0.0D0
         DO 210 IV=1,NV
            IF (NQ.EQ.4) THEN
               JV(1)=NP1
               JV(2)=NP2
               JV(3)=NP3
               JV(4)=NP4
            ELSEIF(NQ.EQ.6) THEN
               IF (IV.EQ.1) THEN
                  JV(1)=NP4
                  JV(2)=NP1
                  JV(3)=NP2
                  JV(4)=NP3
               ELSEIF(IV.EQ.2) THEN
                  JV(1)=NP5
                  JV(2)=NP4
                  JV(3)=NP2
                  JV(4)=NP3
               ELSE
                  JV(1)=NP6
                  JV(2)=NP4
                  JV(3)=NP5
                  JV(4)=NP3
               ENDIF
            ELSE
               IF (IV.EQ.1) THEN
                  JV(1)=NP5
                  JV(2)=NP1
                  JV(3)=NP2
                  JV(4)=NP4
               ELSEIF(IV.EQ.2) THEN
                  JV(1)=NP6
                  JV(2)=NP5
                  JV(3)=NP2
                  JV(4)=NP4
               ELSEIF(IV.EQ.3) THEN
                  JV(1)=NP8
                  JV(2)=NP5
                  JV(3)=NP6
                  JV(4)=NP4
               ELSEIF(IV.EQ.4) THEN
                  JV(1)=NP7
                  JV(2)=NP2
                  JV(3)=NP3
                  JV(4)=NP4
               ELSEIF(IV.EQ.5) THEN
                  JV(1)=NP8
                  JV(2)=NP6
                  JV(3)=NP7
                  JV(4)=NP4
               ELSE
                  JV(1)=NP6
                  JV(2)=NP7
                  JV(3)=NP4
                  JV(4)=NP2
               ENDIF
           ENDIF
           DO KK=1,4
              JVKK=JV(KK)
              XX(KK)=X(JVKK,1)
              YY(KK)=X(JVKK,2)
              ZZ(KK)=X(JVKK,3)
           ENDDO
C
           DO KK=1,4
              GO TO (201,202,203,204),KK
  201         K1=2
              K2=3
              K3=4
              GO TO 205
  202         K1=1
              K2=3
              K3=4
              GO TO 205
  203         K1=1
              K2=2
              K3=4
              GO TO 205
  204         K1=1
              K2=2
              K3=3
  205         CONTINUE
              A(KK)=(-1.0D0)**(KK+1)*(XX(K1)*YY(K2)*ZZ(K3)+
     1            YY(K1)*ZZ(K2)*XX(K3)+ZZ(K1)*XX(K2)*YY(K3)-
     2            XX(K3)*YY(K2)*ZZ(K1)-YY(K3)*ZZ(K2)*XX(K1)-
     3            ZZ(K3)*XX(K2)*YY(K1))
           ENDDO
           VOL6=0.0D0
           DO KK=1,4
              VOL6=VOL6+A(KK)
           ENDDO
           VOL=VOL+DABS(VOL6)/6.0D0
  210   CONTINUE
        VOLELM(M)=VOL
C
        DO IQ=1,NQ
           NP=IE(M,IQ)
           VOLNP(NP)=VOLNP(NP)+VOL
        ENDDO
  200 CONTINUE
      RETURN
      END
C
      SUBROUTINE BSJAC(X,IE,ISB,ISCF,ISVF,ISNF,ISRF,ISCT,ISVT,ISNT)
C
C ------- TO COMPUTE BOUNDARY SURFACE JACOBIAN
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
      COMMON /FCBC/ NCESF,NCNPF,NCPRF,NCDPF(MXCPRH)
      COMMON /FVBC/ NVESF,NVNPF,NVPRF,NVDPF(MXVPRH)
      COMMON /FNBC/ NNESF,NNNPF,NNPRF,NNDPF(MXNPRH)
      COMMON /FRBC/ NRESF,NRNPF,NRPRF,NRDPF(MXRPRH),NRMAF
C
      COMMON /TCBC/ NCEST,NCNPT,NCPRT,NCDPT(MXCPRC)
      COMMON /TVBC/ NVEST,NVNPT,NVPRT,NVDPT(MXVPRC)
      COMMON /TNBC/ NNEST,NNNPT,NNPRT,NNDPT(MXNPRC)
C
      COMMON /BLK1/ KGB(4,6,3)
      COMMON /Q34/ PS,DL1(3),DL2(3),DL3(3)
      COMMON /Q34WG/ WG(3)
      COMMON /BS1/ RNS4(4,4),RNS3(3,3)
      COMMON /BS2F/ DETCBF(4,MXCESH),DETNBF(4,MXNESH),DETVBF(4,MXVESH),
     1              DETRBF(4,MXRESH),DETAB(4,MXBESK)
      COMMON /BS2T/ DETCBT(4,MXCESC),DETNBT(4,MXNESC),DETVBT(4,MXVESC)
      COMMON /BS3/ DNSS(4,4),DNTT(4,4)
C
      DIMENSION X(MAXNPK,3),IE(MAXELK,9)
      DIMENSION ISVF(5,MXVESH),ISCF(5,MXCESH),ISNF(5,MXNESH),
     1 ISRF(6,MXRESH),ISB(6,MXBESK)
      DIMENSION ISVT(5,MXVESC),ISCT(5,MXCESC),ISNT(5,MXNESC)
C
      DIMENSION XQ(4),YQ(4),ZQ(4),S(4),T(4),DET(4)
C
      DATA S/-1.0D+00, 1.0D+00, 1.0D+00,-1.0D+00/
      DATA T/-1.0D+00,-1.0D+00, 1.0D+00, 1.0D+00/
C
      DO KG=1,3
         RNS3(1,KG)=DL1(KG)
         RNS3(2,KG)=DL2(KG)
         RNS3(3,KG)=DL3(KG)
      ENDDO
C
      DO KG=1,4
         SS=PS*S(KG)
         TT=PS*T(KG)
         SM=1.0D0-SS
         SP=1.0D0+SS
         TM=1.0D0-TT
         TP=1.0D0+TT
         RNS4(1,KG)=0.25D0*SM*TM
         RNS4(2,KG)=0.25D0*SP*TM
         RNS4(3,KG)=0.25D0*SP*TP
         RNS4(4,KG)=0.25D0*SM*TP
         DNSS(1,KG)=-0.25D0*TM
         DNSS(2,KG)= 0.25D0*TM
         DNSS(3,KG)= 0.25D0*TP
         DNSS(4,KG)=-0.25D0*TP
         DNTT(1,KG)=-0.25D0*SM
         DNTT(2,KG)=-0.25D0*SP
         DNTT(3,KG)= 0.25D0*SP
         DNTT(4,KG)= 0.25D0*SM
      ENDDO
C
C ------ ALL BOUNDARY NODES
C
      DO MP=1,NBES
         LS=ISB(5,MP)
         M=ISB(6,MP)
         ID = NIK(M)
         NODE=4
         DO 10 IQ=1,NODE
            I=KGB(IQ,LS,ID)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
               NODE=3
               GO TO 10
            ENDIF
            NI=IE(M,I)
            XQ(IQ)=X(NI,1)
            YQ(IQ)=X(NI,2)
            ZQ(IQ)=X(NI,3)
   10    CONTINUE
         CALL JACOB (XQ,YQ,ZQ,DET,NODE)
         DO IQ=1,NODE
            DETAB(IQ,MP)=DET(IQ)
         ENDDO
      ENDDO
C
C ******* APPLY CAUCHY BOUNDARY CONDITIONS
C
      IF (NCESF.EQ.0) GO TO 100
      DO MP=1,NCESF
         MPB=ISCF(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         IK=NIK(M)
         NODE=4
         DO 20 IQ=1,NODE
            I=KGB(IQ,LS,IK)
            IF (I.EQ.0 .AND. IQ.EQ.4)THEN
                NODE=3
                GO TO 20
            ENDIF
            NI=IE(M,I)
            XQ(IQ)=X(NI,1)
            YQ(IQ)=X(NI,2)
            ZQ(IQ)=X(NI,3)
   20    CONTINUE
         CALL JACOB (XQ,YQ,ZQ,DET,NODE)
         DO IQ=1,NODE
            DETCBF(IQ,MP)=DET(IQ)
         ENDDO
      ENDDO
  100 IF (NCEST.EQ.0) GO TO 200
      DO MP=1,NCEST
         MPB=ISCT(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         IK=NIK(M)
         NODE=4
         DO 30 IQ=1,NODE
            I=KGB(IQ,LS,IK)
            IF (I.EQ.0 .AND. IQ.EQ.4)THEN
                NODE=3
                GO TO 30
            ENDIF
            NI=IE(M,I)
            XQ(IQ)=X(NI,1)
            YQ(IQ)=X(NI,2)
            ZQ(IQ)=X(NI,3)
   30    CONTINUE
         CALL JACOB (XQ,YQ,ZQ,DET,NODE)
         DO IQ=1,NODE
            DETCBT(IQ,MP)=DET(IQ)
         ENDDO
      ENDDO
C
C ******* APPLY NEUMANN BOUNDARY CONDITIONS
C
  200 IF (NNESF.EQ.0) GO TO 300
      DO MP=1,NNESF
          MPB=ISNF(5,MP)
          LS=ISB(5,MPB)
          M=ISB(6,MPB)
          IK=NIK(M)
          NODE=4
          DO 40 IQ=1,NODE
             I=KGB(IQ,LS,IK)
             IF (I.EQ.0 .AND. IQ.EQ.4) THEN
                NODE=3
                GO TO 40
             ENDIF
             NI=IE(M,I)
             XQ(IQ)=X(NI,1)
             YQ(IQ)=X(NI,2)
             ZQ(IQ)=X(NI,3)
   40    CONTINUE
         CALL JACOB (XQ,YQ,ZQ,DET,NODE)
         DO IQ=1,NODE
            DETNBF(IQ,MP)=DET(IQ)
         ENDDO
      ENDDO
  300 IF (NNEST.EQ.0) GO TO 400
      DO MP=1,NNEST
          MPB=ISNT(5,MP)
          LS=ISB(5,MPB)
          M=ISB(6,MPB)
          IK=NIK(M)
C
          NODE=4
          DO 50 IQ=1,NODE
             I=KGB(IQ,LS,IK)
             IF (I.EQ.0 .AND. IQ.EQ.4) THEN
                NODE=3
                GO TO 50
             ENDIF
             NI=IE(M,I)
             XQ(IQ)=X(NI,1)
             YQ(IQ)=X(NI,2)
             ZQ(IQ)=X(NI,3)
   50    CONTINUE
         CALL JACOB (XQ,YQ,ZQ,DET,NODE)
         DO IQ=1,NODE
            DETNBT(IQ,MP)=DET(IQ)
         ENDDO
      ENDDO
C
C ******* APPLY VARIABLE (RAINFALL-SEEPAGE) BOUNDARY CONDITIONS
C
  400 IF (NVESF.EQ.0) GO TO 500
C
C -------- CAUCHY PART OF VARIABLE BOUNDARY CONDITIONS
C
      DO MP=1,NVESF
         MPB=ISVF(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         IK=NIK(M)
C
         NODE=4
         DO 60 IQ=1,NODE
            I=KGB(IQ,LS,IK)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
               NODE=3
               GO TO 60
            ENDIF
            NI=IE(M,I)
            XQ(IQ)=X(NI,1)
            YQ(IQ)=X(NI,2)
            ZQ(IQ)=X(NI,3)
   60    CONTINUE
         CALL JACOB (XQ,YQ,ZQ,DET,NODE)
         DO IQ=1,NODE
            DETVBF(IQ,MP)=DET(IQ)
         ENDDO
      ENDDO
  500 IF (NVEST.EQ.0) GO TO 600
      DO MP=1,NVEST
         MPB=ISVT(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         IK=NIK(M)
         NODE=4
         DO 70 IQ=1,NODE
            I=KGB(IQ,LS,IK)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
               NODE=3
               GO TO 70
            ENDIF
            NI=IE(M,I)
            XQ(IQ)=X(NI,1)
            YQ(IQ)=X(NI,2)
            ZQ(IQ)=X(NI,3)
   70    CONTINUE
         CALL JACOB (XQ,YQ,ZQ,DET,NODE)
         DO IQ=1,NODE
            DETVBT(IQ,MP)=DET(IQ)
         ENDDO
      ENDDO
C
C ******* Apply River Boundary Conditions
C
  600 IF (NRESF.EQ.0) GO TO 700
      DO MP=1,NRESF
         MPB=ISRF(5,MP)
         LS=ISB(5,MPB)
         M=ISB(6,MPB)
         IK=NIK(M)
         NODE=4
         DO 80 IQ=1,4
            I=KGB(IQ,LS,IK)
            IF (I.EQ.0 .AND. IQ.EQ.4) THEN
                NODE=3
                GO TO 80
            ENDIF
            NI=IE(M,I)
            XQ(IQ)=X(NI,1)
            YQ(IQ)=X(NI,2)
            ZQ(IQ)=X(NI,3)
   80    CONTINUE
         CALL JACOB (XQ,YQ,ZQ,DET,NODE)
         DO IQ=1,NODE
            DETRBF(IQ,MP)=DET(IQ)
         ENDDO
      ENDDO
  700 RETURN
      END
C
      SUBROUTINE JACOB (XQ,YQ,ZQ,DET,NODE)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      COMMON /Q34WG/ WG(3)
      COMMON /BS3/ DNSS(4,4),DNTT(4,4)
C
      DIMENSION XQ(4),YQ(4),ZQ(4),DET(4)
C
C ----- COMPUTE JACOBIAN AT GAUSSIAN POINTS IF NODE.EQ.3
C
      IF (NODE.EQ.3) THEN
            DXDDL2=XQ(2)-XQ(1)
            DYDDL2=YQ(2)-YQ(1)
            DZDDL2=ZQ(2)-ZQ(1)
            DXDDL3=XQ(3)-XQ(1)
            DYDDL3=YQ(3)-YQ(1)
            DZDDL3=ZQ(3)-ZQ(1)
            DETX=DYDDL2*DZDDL3-DYDDL3*DZDDL2
            DETY=DXDDL2*DZDDL3-DXDDL3*DZDDL2
            DETZ=DXDDL2*DYDDL3-DXDDL3*DYDDL2
            DET1=DSQRT(DETX*DETX+DETY*DETY+DETZ*DETZ)*0.5D0
            DO KG=1,3
               DET(KG)=DET1*WG(KG)
            ENDDO
      ENDIF
C
      IF (NODE.EQ.4) THEN
          DO KG=1,NODE
              DXDSS=0.0D0
              DYDSS=0.0D0
              DZDSS=0.0D0
              DXDTT=0.0D0
              DYDTT=0.0D0
              DZDTT=0.0D0
              DO IQ=1,4
                 DXDSS=DXDSS+XQ(IQ)*DNSS(IQ,KG)
                 DYDSS=DYDSS+YQ(IQ)*DNSS(IQ,KG)
                 DZDSS=DZDSS+ZQ(IQ)*DNSS(IQ,KG)
                 DXDTT=DXDTT+XQ(IQ)*DNTT(IQ,KG)
                 DYDTT=DYDTT+YQ(IQ)*DNTT(IQ,KG)
                 DZDTT=DZDTT+ZQ(IQ)*DNTT(IQ,KG)
              ENDDO
              DETZ=DXDSS*DYDTT-DYDSS*DXDTT
              DETY=-DXDSS*DZDTT+DZDSS*DXDTT
              DETX=DYDSS*DZDTT-DZDSS*DYDTT
              DET(KG)=DSQRT(DETX*DETX+DETY*DETY+DETZ*DETZ)
          ENDDO
      ENDIF
      RETURN
      END
C
      SUBROUTINE CALMC(TH,H,IE)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
C ------- TO COMPUTE MOISTURE CONTENT, GIVEN THE PRESSURE HEAD.
C ------- INPUT: H(NNP),IE(NEL,9)
C ------- OUTPUT: TH(8,NEL)
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /SPCARD/ NUNSAT,NSP(MXMATK),IHM(MXMATK),IHC(MXMATK),
     1       IHW(MXMATK),NPMC(MXMATK),NPCON(MXMATK),NPWC(MXMATK)
      COMMON /UNSAT/ PH(MXSPMK,MXMATK),PMC(MXSPMK,MXMATK),
     1               PCON(MXSPMK,MXMATK),CONDUC(MXSPMK,MXMATK),
     2               PWC(MXSPMK,MXMATK),WC(MXSPMK,MXMATK),
     &               PMKNOT(MXSPMK + 4, MXMATK), PCKNOT(MXSPMK + 4,
     &               MXMATK), PWKNOT(MXSPMK + 4, MXMATK),
     &               PMCOEF(MXSPMK, MXMATK), PCCOEF(MXSPMK, MXMATK),
     &               PWCOEF(MXSPMK, MXMATK), IBSPL
      COMMON /MPCARD/ NDVFUN,NPROPF(MXMATK),NPROPT(MXMATK)
C
      COMMON /JACOB1/ RNH(8,8),RNP(6,6),RNT(4,4)
C
      DIMENSION IE(MAXELK,9)
      DIMENSION TH(8,MAXELK),H(MAXNPK)
C
      DIMENSION HQ(8),HKG(8),RN(8)
C
C ---------  moisture content
C
      DO 490 M=1,NEL
C
         NODE=IJNOD(M)
         DO IQ=1,NODE
            NP=IE(M,IQ)
            HQ(IQ)=H(NP)
         ENDDO
C
C ------- Evaluate pressure at four gaussian points for quadrilateral
C ------- element.
C
         DO KG=1,NODE
            IF (NODE.EQ.8) THEN
               DO I=1,8
                  RN(I)=RNH(I,KG)
               ENDDO
            ELSEIF (NODE.EQ.6) THEN
               DO I=1,6
                  RN(I)=RNP(I,KG)
               ENDDO
            ELSE
               DO I=1,4
                  RN(I)=RNT(I,KG)
               ENDDO
            ENDIF
            HKG(KG)=0.0D0
            DO IQ=1,NODE
               HKG(KG)=HKG(KG)+HQ(IQ)*RN(IQ)
            ENDDO
         ENDDO
C
         MTYP=IE(M,9)
         NUMMC=NPMC(MTYP)
C
         DO KG = 1, NODE
            HNP=HKG(KG)
C
            IF (IBSPL .EQ. 1) THEN
              CALL BSINT (PH(1, MTYP), PMC(1, MTYP), NUMMC, PMKNOT(1,
     &          MTYP), PMCOEF(1, MTYP), HNP, THETA)
            ELSE
              CALL LININT (PH(1, MTYP), PMC(1, MTYP), NUMMC,
     &          HNP, THETA)
            END IF
C
            TH(KG, M) = THETA
         END DO
C
  490 CONTINUE
C
      RETURN
      END
C
      SUBROUTINE MSORT(IE)
C
C ----- Sorting the material type in the element in sequence
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SPCARD/ NUNSAT,NSP(MXMATK),IHM(MXMATK),IHC(MXMATK),
     1       IHW(MXMATK),NPMC(MXMATK),NPCON(MXMATK),NPWC(MXMATK)
      COMMON /MPCARD/ NDVFUN,NPROPF(MXMATK),NPROPT(MXMATK)
C
      DIMENSION IE(MAXELK,9)
      DIMENSION NSPOLD(MXMATK)
C
      DO I=1,NUNSAT
         NSPOLD(I)=NSP(I)
      ENDDO
C
      DO I=1,NUNSAT
         NSP(I)=I
      ENDDO
C
C ----- Changing the material type in a element
C
      DO 100 M=1,NEL
         MTYP=IE(M,9)
         DO I=1,NUNSAT
            IF (MTYP.EQ.NSPOLD(I)) THEN
               IE(M,9)=I
               GO TO 100
            ENDIF
         ENDDO
         WRITE(*,1001) MTYP,M
 1001 FORMAT(2X,' material type no=',I2,' in element no=',I8,
     % ' was not found in SP1 card')
	       call stopfile  ! emrl jig
         STOP 'msort'
  100 CONTINUE
      RETURN
      END
C
      SUBROUTINE CALKR (AKHC,H,C,IE,PROPF,RHOMU)
C
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INCLUDE 'gwpara.inc'
C
C ------- TO COMPUTE HYDRAULIC CONDUCTIVITY GIVEN THE PRESSURE HEAD.
C ------- INPUT: H(NNP),IE(NEL,9),PROPF,RHOMU
C ------- OUTPUT: AKHC(7,8,NEL)
C
      COMMON /CGEOM/ NNP,NEL,NBNP,NTUBS,NBES,ISHAPE
      COMMON /SCMTL/ NMAT,NMPPM,NSPPM,NRMP
      COMMON /FREAL/ TOLAF,TOLBF,WF,OMEF,OMIF,OMEMIN,OMEMAX,OMEADD,
     &  OMERED,GRAV,RHO,VISC,CNSTKR,BETAP
      COMMON /CELEM/ IJNOD(MAXELK),NIK(MAXELK),NFACE(MAXELK),
     1               NEDGE(MAXELK)
C
      COMMON /SPCARD/ NUNSAT,NSP(MXMATK),IHM(MXMATK),IHC(MXMATK),
     1       IHW(MXMATK),NPMC(MXMATK),NPCON(MXMATK),NPWC(MXMATK)
      COMMON /UNSAT/ PH(MXSPMK,MXMATK),PMC(MXSPMK,MXMATK),
     1               PCON(MXSPMK,MXMATK),CONDUC(MXSPMK,MXMATK),
     2               PWC(MXSPMK,MXMATK),WC(MXSPMK,MXMATK),
     &               PMKNOT(MXSPMK + 4, MXMATK), PCKNOT(MXSPMK + 4,
     &               MXMATK), PWKNOT(MXSPMK + 4, MXMATK),
     &               PMCOEF(MXSPMK, MXMATK), PCCOEF(MXSPMK, MXMATK),
     &               PWCOEF(MXSPMK, MXMATK), IBSPL
C
      COMMON /JACOB1/ RNH(8,8),RNP(6,6),RNT(4,4)
C
      DIMENSION IE(MAXELK,9)
      DIMENSION AKHC(7,8,MAXELK),H(MAXNPK)
      DIMENSION C(MAXNPK),RHOMU(MXRMPK),PROPF(9,MXMATK)
C
      DIMENSION HQ(8),HKG(8),CQ(8),CKG(8),RN(8)
C
C ------- Initiate array akhc
C
      DO M=1,NEL
         NODE=IJNOD(M)
         DO KG=1,NODE
            DO I=1,7
               AKHC(I,KG,M)=0.0D0
            ENDDO
         ENDDO
      ENDDO
C
      DO 490 M=1,NEL
         NODE=IJNOD(M)
         DO IQ=1,NODE
            NP=IE(M,IQ)
            CQ(IQ)=C(NP)
            HQ(IQ)=H(NP)
         ENDDO
C
C ------- Evaluate pressure at four gaussian points for quadrilateral
C ------- element.
C
         DO KG=1,NODE
            IF (NODE.EQ.8) THEN
               DO I=1,8
                  RN(I)=RNH(I,KG)
               ENDDO
            ELSEIF (NODE.EQ.6) THEN
               DO I=1,6
                  RN(I)=RNP(I,KG)
               ENDDO
            ELSE
               DO I=1,4
                  RN(I)=RNT(I,KG)
               ENDDO
            ENDIF
            HKG(KG)=0.0D0
            CKG(KG)=0.0D0
            DO IQ=1,NODE
               HKG(KG)=HKG(KG)+HQ(IQ)*RN(IQ)
               CKG(KG)=CKG(KG)+CQ(IQ)*RN(IQ)
            ENDDO
         ENDDO
C
         MTYP=IE(M,9)
         SATKX =PROPF(1,MTYP)
         SATKY =PROPF(2,MTYP)
         SATKZ =PROPF(3,MTYP)
         SATKXY=PROPF(4,MTYP)
         SATKXZ=PROPF(5,MTYP)
         SATKYZ=PROPF(6,MTYP)
C
C -------  relative conductivity
C
         NUMCON=NPCON(MTYP)
C
         DO 290 KG=1,NODE
C
            HNP=HKG(KG)
C
            IF (IBSPL .EQ. 1) THEN
              CALL BSINT (PCON(1, MTYP), CONDUC(1, MTYP), NUMCON,
     &          PCKNOT(1, MTYP), PCCOEF(1, MTYP), HNP, USKFCT)
              IF (USKFCT .LT. CONDUC(1, MTYP)) USKFCT = CONDUC(1, MTYP)
            ELSE
              CALL LININT (PCON(1, MTYP), CONDUC(1, MTYP), NUMCON,
     &          HNP, USKFCT)
            END IF
C
            IF (USKFCT .LT. CNSTKR) USKFCT = CNSTKR
C
C ----- RHO denotes RHO/RHO0
C ----- AMU denotes MU/MU0
C
            RHO=RHOMU(1)+CKG(KG)*(RHOMU(2)+CKG(KG)*(RHOMU(3)+CKG(KG)
     1         *RHOMU(4)))
            AMU=RHOMU(5)+CKG(KG)*(RHOMU(6)+CKG(KG)*(RHOMU(7)+CKG(KG)
     1         *RHOMU(8)))
C
            AAAA = USKFCT*RHO/AMU
            AKHC(1,KG,M)=SATKX*AAAA
            AKHC(2,KG,M)=SATKY*AAAA
            AKHC(3,KG,M)=SATKZ*AAAA
            AKHC(4,KG,M)=SATKXY*AAAA
            AKHC(5,KG,M)=SATKXZ*AAAA
            AKHC(6,KG,M)=SATKYZ*AAAA
            AKHC(7,KG,M)=RHO
  290    CONTINUE
  490 CONTINUE
      RETURN
      END
C
      SUBROUTINE GETPATH(NAME,PATH)
      CHARACTER*80 NAME,PATH
      INTEGER COUNT
C
      COUNT = 80
      PATH = NAME
200   IF((COUNT.GT.0).AND.((PATH(COUNT:COUNT).NE.'/').and.
     &                          (PATH(COUNT:COUNT) .NE. '\'))) THEN
        PATH(COUNT:COUNT) = ' '
        COUNT = COUNT - 1
        GO TO 200
      ENDIF
      END
C
      SUBROUTINE SETPATH(PATH,FNAME)
      CHARACTER*80 PATH,FNAME,NEWNAME
      INTEGER COUNT,I
C
      COUNT = 80
888   IF ((COUNT .GT. 0) .AND. (PATH(COUNT:COUNT) .EQ. ' ')) THEN
        COUNT = COUNT - 1
        GO TO 888
      ENDIF
      COUNT = COUNT + 1
      I=1
      NEWNAME = PATH
999   IF (COUNT .LT. 81 .AND. I .LT. 81) THEN
        IF (FNAME(I:I) .NE. '"') THEN
          NEWNAME(COUNT:COUNT) = FNAME(I:I)
          COUNT = COUNT + 1
        ENDIF
        I = I + 1
        GO TO 999
      ENDIF
      FNAME = NEWNAME
      END
C
      SUBROUTINE BSKNOT (X, T, N)
C
C
C         THIS SUBROUTINE DETERMINES THE KNOTS FOR A B SPLINE
C         INTERPOLATION.
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      DIMENSION X(N), T(N + 6)
C
C         ADD EXTRA POINTS AT THE BEGINNING.
C
      DO I = 1, 3
        T(I) = X(1)
      END DO
C
C         DO THE MIDDLE POINTS.
C
      DO I = 1, N
        T(I + 3) = X(I)
      END DO
C
C         ADD EXTRA POINTS AT THE END.
C
      DO I = 1, 3
        T(N + 3 + I) = X(N)
      END DO
C
      RETURN
      END
C
      FUNCTION BS (T, N, IST, XINT)
C
C
C         THIS SUBROUTINE COMPUTES THE B SPLINE
C         FROM THE GIVEN STARTING INDEX FOR THE
C         NEEDED FIVE KNOTS AND THE X VALUE.
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      DIMENSION T(N + 6), B(4)
C
      BS = 0.0D0
      ISTP3 = IST + 3
      ISTP4 = IST + 4
C
C         CHECK FOR OUTSIDE THE REGION.
C
      IF ((T(IST) .GE. XINT) .OR. (T(ISTP4) .LE. XINT)) RETURN
C
C         DO B0.
C
      DO I = IST, ISTP3
        IF ((T(I) .LE. XINT) .AND. (T(I + 1) .GT. XINT)) THEN
          B(I - IST + 1) = 1.0D0
        ELSE
          B(I - IST + 1) = 0.0D0
        END IF
      END DO
C
C         DO THE B'S.
C
      DO J = 1, 3
C
        IFN = IST + 3 - J
C
        DO I = IST, IFN
C
          DX = T(I + J) - T(I)
          IF (DX .NE. 0.0D0) THEN
            F1 = (XINT - T(I)) / DX
          ELSE
            F1 = 0.0D0
          END IF
C
          DX = T(I + J + 1) - T(I + 1)
          IF (DX .NE. 0.0D0) THEN
            F2 = (T(I + J + 1) - XINT) / DX
          ELSE
            F2 = 0.0D0
          END IF
C
          B(I - IST + 1) = F1 * B(I - IST + 1) + F2 * B(I - IST + 2)
C
        END DO
C
      END DO
C
      BS = B(1)
C
      RETURN
      END
C
      SUBROUTINE BSCOEF (X, Y, N, T, C)
C
C
C         THIS SUBROUTINE COMPUTES THE COEFFICIENTS FOR B SPLINE
C         INTERPOLATION.
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      DIMENSION X(N), Y(N), T(N + 6), C(N + 2)
      DIMENSION A(N + 2, 3)
C
      IF (N .LE. 4) RETURN
C
C         COMPUTE THE A MATRIX AND D VECTOR TO SOLVE AC = D.
C         USE THE C MATIRX TO STORE D.
C
      C(1) = Y(1)
      NP1 = N + 1
      DO I = 2, NP1
        C(I) = Y(I - 1)
      END DO
      C(N + 2) = Y(N)
C
      A(2, 2) = 1.0D0
      A(2, 3) = 0.0D0
      A(N + 1, 1) = 0.0D0
      A(N + 1, 2) = 1.0D0
C
      DO I = 3, N
        XX = X(I - 1)
        DO J = 1, 3
          A(I, J) = BS (T, N, I + J - 2, XX)
        END DO
      END DO
C
C         DO THE FORWARD GAUSS ELIMINATION STEP.
C
      DO I = 2, N
        TT1 = - A(I + 1, 1) / A(I, 2)
        A(I + 1, 2) = A(I + 1, 2) + TT1 * A(I, 3)
        C(I + 1) = C(I + 1) + TT1 * C(I)
      END DO
C
C         DO THE BACKWARD GAUSS ELIMINATION STEP.
C
      C(NP1) = C(NP1) / A(NP1, 2)
      DO I = 2, N
        II = N - I + 2
        C(II) = (C(II) - A(II, 3) * C(II + 1)) / A(II, 2)
      END DO
C
      RETURN
      END
C
      SUBROUTINE BSINT (X, Y, N, T, C, XINT, YINT)
C
C
C         THIS SUBROUTINE COMPUTES THE INTERPOLATED Y VALUE
C         ON THE B SPLINE CURVE FROM THE GIVEN X VALUE.
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      DIMENSION X(N), Y(N), T(N + 6), C(N + 2)
C
C         XINT IS OUT OF RANGE.
C
      IF (XINT .LE. X(1)) THEN
        YINT = Y(1)
        RETURN
      END IF
C
      IF (XINT .GE. X(N)) THEN
        YINT = Y(N)
        RETURN
      END IF
C
C         N IS SMALL.
C
      IF (N .EQ. 2) THEN
C
        DX = X(2) - X(1)
        T1 = (X(2) - XINT) / DX
        T2 = (XINT - X(1)) / DX
        YINT = T1 * Y(1) + T2 * Y(2)
C
      ELSE IF (N .EQ. 3) THEN
C
        DX1 = X(2) - X(1)
        DX2 = X(3) - X(1)
        DX3 = X(3) - X(2)
        T1 = (XINT - X(2)) * (XINT - X(3)) / (DX1 * DX2)
        T2 = - (XINT - X(1)) * (XINT - X(3)) / (DX1 * DX3)
        T3 = (XINT - X(1)) * (XINT - X(2)) / (DX2 * DX3)
        YINT = T1 * Y(1) + T2 * Y(2) + T3 * Y(3)
C
      ELSE IF (N .EQ. 4) THEN
C
        DX1 = X(2) - X(1)
        DX2 = X(3) - X(1)
        DX3 = X(4) - X(1)
        DX4 = X(3) - X(2)
        DX5 = X(4) - X(2)
        DX6 = X(4) - X(3)
        T1 = - (XINT - X(2)) * (XINT - X(3)) * (XINT - X(4)) /
     &    (DX1 * DX2 * DX3)
        T2 = (XINT - X(1)) * (XINT - X(3)) * (XINT - X(4)) /
     &    (DX1 * DX4 * DX5)
        T3 = - (XINT - X(1)) * (XINT - X(2)) * (XINT - X(4)) /
     &    (DX2 * DX4 * DX6)
        T4 = (XINT - X(1)) * (XINT - X(2)) * (XINT - X(3)) /
     &    (DX3 * DX5 * DX6)
        YINT = T1 * Y(1) + T2 * Y(2) + T3 * Y(3) + T4 * Y(4)
C
C         USE B SPLINES.
C
      ELSE
C
C         FIND THE STARTING INTERVAL.
C
        NM1 = N - 1
        IST = 0
        I = 0
C
        DO WHILE ((IST .EQ. 0) .AND. (I .LT. NM1))
          I = I + 1
          IF ((X(I) .LE. XINT) .AND. (XINT .LT. X(I + 1))) THEN
            IST = I
          END IF
        END DO
C
C         COMPUTE THE INTERPOLATED VALUE.
C
      ISTP3 = IST + 3
C
        SUM = 0.0D0
        DO I = IST, ISTP3
          SUM = SUM + BS (T, N, I, XINT) * C(I)
        END DO
C
        YINT = SUM
C
      END IF
C
      RETURN
      END
C
      SUBROUTINE LININT (X, Y, N, XINT, YINT)
C
C
C         THIS SUBROUTINE COMPUTES THE INTERPOLATED Y VALUE
C         USING LINEAR INTERPOLATION FROM THE GIVEN X VALUE.
C
C
      IMPLICIT REAL * 8 (A-H, O-Z)
C
      DIMENSION X(N), Y(N)
C
C         XINT IS OUT OF RANGE.
C
      IF (XINT .LE. X(1)) THEN
        YINT = Y(1)
        RETURN
      END IF
C
      IF (XINT .GE. X(N)) THEN
        YINT = Y(N)
        RETURN
      END IF
C
C         FIND THE STARTING INTERVAL AND COMPUTE THE INTERPOLATED
C         VALUE.
C
      NM1 = N - 1
C
      DO I = 1, NM1
C
        IF ((X(I) .LE. XINT) .AND. (XINT .LT. X(I + 1))) THEN
C
          YINT = ((X(I + 1) - XINT) * Y(I) + (XINT - X(I)) * Y(I + 1)) /
     &      (X(I + 1) - X(I))
C
          RETURN
C
        END IF
C
      END DO
C
C         DEFAULT VALUE.
C
      YINT = Y(1)
C
      RETURN
      END

	SUBROUTINE stopfile

      WRITE (*,*) ' '
      PAUSE
	STOP

	END
