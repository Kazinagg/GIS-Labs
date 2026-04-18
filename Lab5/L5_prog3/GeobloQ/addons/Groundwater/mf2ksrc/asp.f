      module altparam  ! emrl pest - moved from lower in file
        integer nostop,hdrybot,limop,iaspunit,iaspline,ialtinterp
        real minthick
        character*120 aspinfile
      end module altparam

      module array_interpolation


        implicit none
        private
        public :: read_interpolation_file, int_deallocate,
     +            GetSumType,SetCurrentIndex,UnSetCurrentIndex,
     +            interpolation_check,apply_bounds, init_interp_data,
     +            put_interp_info,put_current_period


        integer              :: numpartype,numarray,
     +                          current_index,intunit,ipper
        integer, allocatable :: int_layer(:,:),int_interptype(:),
     +                          int_miniarrnum(:),int_maxiarrnum(:)
        real, allocatable    :: int_minival(:),int_maxival(:)
        real, allocatable    :: int_array(:,:,:)
        character*4, allocatable  :: int_partyp(:)
        character*10, allocatable :: int_miniarrname(:),
     +                               int_maxiarrname(:),
     +                               int_arrname(:)
        character*120             :: interpfile


      contains


      subroutine init_interp_data

        numpartype=0
        numarray=0
        current_index=0
        intunit=0

        return

      end subroutine init_interp_data


      subroutine put_interp_info(interp)

        implicit none
        integer interp

        if(interp.gt.0)then
          intunit=1
        else
          intunit=0
        end if
        return
      end subroutine put_interp_info


      subroutine put_current_period(iper)

        implicit none
        integer iper
        ipper=iper
        return

      end subroutine put_current_period

      subroutine read_interpolation_file(iout,ncol,nrow,nlay,nper)

        use altparam
        implicit none

        integer, intent(in) :: ncol,nrow,nlay,iout,nper

        logical             :: lopened
        integer             :: iunit,ierr,iline,i,j,ifail,icol,irow,
     +                         idim,itemp
        integer, allocatable:: lw(:),rw(:)
        integer             :: ls(10),rs(10)
        character*4         :: aatemp
        character*15        :: aint,amaxmin,ainterp
        character*20        :: aminval,amaxval
        character*600       :: cline

        if(iaspunit.eq.0) return
        if(intunit.eq.0) then
          close(iaspunit)
          return
        end if

        iunit=iaspunit
        interpfile=aspinfile

        write(*,110)
        write(*,105) trim(interpfile)
105     format(' PARAMETER VALUE PROCESSING BY MODFLOW 2000 WILL ',
     +  'BE MODIFIED IN ACCORDANCE',/,' WITH THE SETTINGS IN ',
     +  'FILE ',a,'.')

        write(iout,110)
110     format(/,' SUPPLEMENTARY INTERPOLATION PROCESS ACTIVE.')
        write(iout,120)
120     format(' PARAMETER VALUE PROCESSING BY MODFLOW 2000 WILL ',
     +  'BE MODIFIED IN ACCORDANCE',/,' WITH THE FOLLOWING ',
     +  'USER-SUPPLIED VARIABLES.')

        iline=iaspline
130     iline=iline+1
        read(iunit,'(a)',err=9000,end=9050) cline
        if((cline.eq.' ').or.(cline(1:1).eq.'#')) go to 130
        call linesplit(ifail,2,ls,rs,cline)
        if(ifail.ne.0)go to 9100
        call intread(ifail,cline(ls(1):rs(1)),numpartype)
        if(ifail.ne.0) go to 9000
        call intread(ifail,cline(ls(2):rs(2)),numarray)
        if(ifail.ne.0) go to 9000
        if(numpartype.lt.0)numpartype=0
        if(numarray.lt.0)numarray=0
        if(numpartype.eq.0) return


        idim=max(nlay,nper)+10
        allocate(int_layer(idim,numpartype),int_interptype(numpartype),
     +  int_minival(numpartype),int_maxival(numpartype),
     +  int_partyp(numpartype),int_miniarrname(numpartype),
     +  int_maxiarrname(numpartype),int_miniarrnum(numpartype),
     +  int_maxiarrnum(numpartype),stat=ierr)
        if(ierr.ne.0) go to 9500
        allocate(lw(idim),rw(idim),stat=ierr)
        if(ierr.ne.0) go to 9500
        if(numarray.ne.0)then
          allocate(int_array(ncol,nrow,numarray),
     +             int_arrname(numarray),stat=ierr)
          if(ierr.ne.0) go to 9500
        end if

        do i=1,numpartype
          iline=iline+1
          read(iunit,'(a)',err=9000,end=9050) cline
          call linesplit(ifail,1,lw,rw,cline)
          if(ifail.ne.0) go to 9100
          int_partyp(i)=cline(lw(1):rw(1))
          call casetrans(int_partyp(i),'hi')
          aatemp=int_partyp(i)
          if((aatemp.ne.'RCH').and.(aatemp.ne.'HK').and.
     +       (aatemp.ne.'HANI').and.(aatemp.ne.'VK').and.
     +       (aatemp.ne.'VANI').and.(aatemp.ne.'SS').and.
     +       (aatemp.ne.'SY').and.(aatemp.ne.'VKCN')) go to 9600
          if(int_partyp(i).eq.'RCH')then
            itemp=nper
          else
            itemp=nlay
          end if
          call linesplit(ifail,itemp+4,lw,rw,cline)
          if(ifail.ne.0) go to 9100
          call intread(ifail,cline(lw(2):rw(2)),int_interptype(i))
          if(ifail.ne.0) go to 9000
          call realread(ifail,cline(lw(3):rw(3)),int_minival(i))
          if(ifail.ne.0) then
            int_minival(i)=-1.1e35
            int_miniarrname(i)=cline(lw(3):rw(3))
            call casetrans(int_miniarrname(i),'hi')
          else
            int_miniarrname(i)=' '
          end if
          call realread(ifail,cline(lw(4):rw(4)),int_maxival(i))
          if(ifail.ne.0) then
            int_maxival(i)=-1.1e35
            int_maxiarrname(i)=cline(lw(4):rw(4))
            call casetrans(int_maxiarrname(i),'hi')
          else
            int_maxiarrname(i)=' '
          end if
          do j=1,itemp
            call intread(ifail,cline(lw(j+4):rw(j+4)),int_layer(j,i))
            if(ifail.ne.0) go to 9000
          end do
        end do

        if(numarray.ne.0)then
          do i=1,numarray
            read(iunit,'(a)',err=9150,end=9050) int_arrname(i)
            int_arrname(i)=adjustl(int_arrname(i))
            call casetrans(int_arrname(i),'hi')
            do irow=1,nrow
              read(iunit,*,err=9200,end=9050)
     +        (int_array(icol,irow,i),icol=1,ncol)
            end do
          end do
        end if
        close(unit=iunit)

        write(iout,*)
        write(iout,150)
150     format(' Parameter   Interpolation     Min value     ',
     +  'Max value      Layers or stress periods')
        write(iout,160)
160     format(' type        type              or array      ',
     +  'or array       (1 if active; 0 otherwise)')


        do i=1,numpartype
          if(int_minival(i).lt.-1.0e35)then
            aminval=int_miniarrname(i)
          else
            write(aminval,162) int_minival(i)
162         format(1pg12.5)   ! emrl pest - removed extra )
            aminval=adjustl(aminval)
          end if
          if(int_maxival(i).lt.-1.0e35)then
            amaxval=int_maxiarrname(i)
          else
            write(amaxval,162) int_maxival(i)
            amaxval=adjustl(amaxval)
          end if
          if(int_interptype(i).eq.0)then
            ainterp='native'
          else if(int_interptype(i).eq.1)then
            ainterp='log'
          else
            write(*,165) trim(int_partyp(i)),trim(interpfile)
165         format(/,' *** Incorrect INTERPTYPE supplied for ',
     +      'parameter type ',a,' in file ',a,' ***',/)
            go to 9890
          end if
          if(int_partyp(i).eq.'RCH')then
            itemp=nper
          else
            itemp=nlay
          end if
          write(iout,180) trim(int_partyp(i)),trim(ainterp),
     +    trim(aminval),trim(amaxval),(int_layer(j,i),j=1,itemp)
180       format(1x,a,t14,a,t32,a,t46,a,t59,100(i3))
        end do


        do i=1,numpartype
          if(int_miniarrname(i).ne.' ')then
            if(numarray.eq.0) go to 9300
            do j=1,numarray
              if(int_miniarrname(i).eq.int_arrname(j)) then
                int_miniarrnum(i)=j
                go to 200
              end if
            end do
            go to 9300
          end if
200       continue
          if(int_maxiarrname(i).ne.' ')then
            if(numarray.eq.0) go to 9350
            do j=1,numarray
              if(int_maxiarrname(i).eq.int_arrname(j)) then
                int_maxiarrnum(i)=j
                go to 220
              end if
            end do
            go to 9350
          end if
220       continue
        end do

        if(allocated(lw))deallocate(lw,stat=ierr)
        if(allocated(rw))deallocate(rw,stat=ierr)

        return


9000    write(*,9010) iline,trim(interpfile)
9010    format(/,' *** Error reading line',i5,' of file ',a,
     +  ' ***',/)
        go to 9890

9050    write(*,9060) trim(interpfile)
9060    format(/,' *** Unexpected end encountered to file ',a,
     +  ' ***',/)
        go to 9890

9100    write(*,9110) iline,trim(interpfile)
9110    format(/,' *** Insufficient entries on line',i5,' of file ',
     +  a,' ***',/)
        go to 9890

9150    write(*,9160) trim(interpfile)
9160    format(/,' *** Error reading file ',a,' ***',/)
        go to 9890


9200    write(*,9210) trim(int_arrname(i)),trim(interpfile)
9210    format(/,' *** Error reading array "',a,
     +  '" in file ',a,' ***',/)
        go to 9890

9300    write(*,9310) trim(int_miniarrname(i)),trim(interpfile)
9310    format(/,' *** No array named "',a,'" found in file ',a,'.')
        go to 9890

9350    write(*,9360) trim(int_maxiarrname(i)),trim(interpfile)
9360    format(/,' *** No array named "',a,'" found in file ',a,'.')
        go to 9890


9500    write(*,9510)
9510    format(/,' *** Cannot allocate sufficient memory for ',
     +  'supplementary interpolation ***')
        write(*,9520) trim(interpfile)
9520    format(  ' *** variables contained in file ',a,' ***',/)
        go to 9890

9600    write(*,9620) trim(interpfile)
9620    format(/,' *** Parameter types supplied in file ',a,' ***')
        write(*,9621)
9621    format(' *** must belong to LPF or RCH packages ***')
        write(*,9630) trim(aatemp)
9630    format(' *** Parameter "',a,'" does not.')
        go to 9890


9890    if(allocated(lw))deallocate(lw,stat=ierr)
        if(allocated(rw))deallocate(rw,stat=ierr)
        call int_deallocate()
        call stopfile ! emrl
        stop

        end subroutine read_interpolation_file


      subroutine int_deallocate

        implicit none

        integer :: ierr

        if(numpartype.eq.0) return


        if(allocated(int_layer))deallocate(int_layer,stat=ierr)
        if(allocated(int_interptype))
     +  deallocate(int_interptype,stat=ierr)
        if(allocated(int_minival))deallocate(int_minival,stat=ierr)
        if(allocated(int_maxival))deallocate(int_maxival,stat=ierr)
        if(allocated(int_partyp)) deallocate(int_partyp,stat=ierr)
        if(allocated(int_miniarrname))
     +  deallocate(int_miniarrname,stat=ierr)
        if(allocated(int_maxiarrname))
     +  deallocate(int_maxiarrname,stat=ierr)
        if(allocated(int_miniarrnum))
     +  deallocate(int_miniarrnum,stat=ierr)
        if(allocated(int_maxiarrnum))
     +  deallocate(int_maxiarrnum,stat=ierr)
        if(numarray.ne.0)then
          if(allocated(int_array))deallocate(int_array,stat=ierr)
          if(allocated(int_arrname))deallocate(int_arrname,stat=ierr)
        end if

        return

      end subroutine int_deallocate



      subroutine interpolation_check(isen,isenall)

        implicit none

        integer, intent(in) ::  isen,isenall
        integer             ::  i

        if(numpartype.eq.0) return

        if(isen.gt.0) then
          if(isenall.ne.-1)then
            do i=1,numpartype
              if(int_interptype(i).ne.0)then
                write(*,10)
10              format(/,' *** There is at least 1 parameter ty',
     +          'pe in ASP input file for which      ***')
                write(*,20)
20              format(  ' *** INTERPTYPE is logarithmic. MF2K ',
     +          'cannot calculate sensitivites       ***')
                write(*,30)
30              format(  ' *** under these circumstances.      ',
     +          '                                    ***')
                write(*,40)
40              format(  ' *** So alter the MF2K dataset such t',
     +          'hat sensitivities are not           ***')
                write(*,50)
50              format(  ' *** calculated (eg. set ISENALL to -',
     +          '1) or alter the ASP input file      ***')
                write(*,60)
60              format(  ' *** Alternatively, if running PEST, ',
     +          'rerun MF2PEST with IMDERCALC        ***')
                write(*,70)
70              format(  ' *** set to zero (ie. PEST must calcu',
     +          'late parameter derivatives, not     ***')
                write(*,80)
80              format(  ' *** MODFLOW)                        ',
     +          '                                    ***')
                call int_deallocate()
        call stopfile ! emrl
                stop
                return
              end if
            end do
          end if
        end if

        return

      end subroutine interpolation_check


      subroutine apply_bounds(ncol,nrow,zz)

        implicit none

        integer, intent(in)     :: ncol,nrow
        real, intent(inout)     :: zz(ncol,nrow)

        integer                 :: i,j,irow,icol
        real                    :: rtemp

        if(numpartype.eq.0) return
        if(current_index.eq.0) return

        i=current_index
        if(int_minival(i).gt.-1.0e35)then
          rtemp=int_minival(i)
          do irow=1,nrow
            do icol=1,ncol
              if(zz(icol,irow).lt.rtemp)zz(icol,irow)=rtemp
            end do
          end do
        else
          j=int_miniarrnum(i)
          do irow=1,nrow
            do icol=1,ncol
              if(zz(icol,irow).lt.int_array(icol,irow,j))
     +        zz(icol,irow)=int_array(icol,irow,j)
            end do
          end do
        end if

        if(int_maxival(i).gt.-1.0e35)then
          rtemp=int_maxival(i)
          do irow=1,nrow
            do icol=1,ncol
              if(zz(icol,irow).gt.rtemp)zz(icol,irow)=rtemp
            end do
          end do
        else
          j=int_maxiarrnum(i)
          do irow=1,nrow
            do icol=1,ncol
              if(zz(icol,irow).gt.int_array(icol,irow,j))
     +        zz(icol,irow)=int_array(icol,irow,j)
            end do
          end do
        end if


        return

      end subroutine apply_bounds



      subroutine SetCurrentIndex(partyp,ilay)

        implicit none

        character*(*), intent(in)     :: partyp
        integer, intent(in)           :: ilay
        integer                       :: i

        if(numpartype.eq.0)then
          current_index=0
          return
        end if
        do i=1,numpartype
          if(partyp.eq.int_partyp(i))then
            if(partyp.eq.'RCH')then
              if(int_layer(ipper,i).ne.0) go to 100
            else
              if(int_layer(ilay,i).ne.0) go to 100
            end if
          end if
        end do
        Current_Index=0
        return

100     Current_Index=i
        return

      end subroutine setcurrentindex



      subroutine UnSetCurrentIndex

        implicit none
        Current_index=0
        return

      end subroutine UnSetCurrentIndex



      integer function GetSumType()

        implicit none
        if(current_index.eq.0)then
          GetSumType=0
        else
          GetSumType=int_interptype(current_index)
        end if

        return

      end function GetSumType


      end module array_interpolation


c emrl pest - moved to top of file
c emrl pest      module altparam
c emrl pest        integer nostop,hdrybot,limop,iaspunit,iaspline,ialtinterp
c emrl pest        real minthick
c emrl pest        character*120 aspinfile
c emrl pest      end module altparam


      module pestdata

       implicit none

       integer npar,nobs
       integer ipestunit
       integer, allocatable::imodpar(:),imodobs(:)
       real, allocatable:: work(:)
       character*120 pestinfile,modderfile

      end module pestdata




      subroutine initaltparam

        use altparam
        implicit none

        iaspunit=0
        aspinfile=' '
        hdrybot=0
        limop=0
        nostop=0
        minthick=0.0
        ialtinterp=0

      end subroutine initaltparam


      subroutine putaspinfo(ioutg,iasp,aline)

        use altparam
        implicit none

        logical lopened
        integer i,ifail,nblnk,nbcl,iasp,ioutg
        character*(*) aline
        character*200 cline,atemp*4

        iasp=0
        cline=aline
        call lshift(cline)
        atemp=cline(1:4)
        call casetrans(atemp,'lo')
        if(atemp.ne.'asp ') return
        iasp=1
        cline(1:3)=' '
        call lshift(cline)
        i=index(cline,' ')
        call intread(ifail,cline(1:i-1),iaspunit)
        if(ifail.ne.0)then
          write(*,10)
10        format(/,' *** Cannot read unit no. for ASP input ',
     +    'file from MODFLOW name file ***',/)
        call stopfile ! emrl
          stop
        end if
        iaspunit=-1
        cline(1:i)=' '
        call lshift(cline)
        nbcl=nblnk(cline)
        call getfile(ifail,cline,aspinfile,1,nbcl)
        if(ifail.ne.0)then
          write(*,20)
20        format(/,' *** Cannot read name of ASP input ',
     +    'file from MODFLOW name file ***',/)
        call stopfile ! emrl
          stop
        end if

        inquire(unit=ioutg,opened=lopened)
        if(lopened)then
          write(ioutg,25) aspinfile(1:nblnk(aspinfile))
25        format(/,' FILE TYPE:ASP: FILE = ',a)
        end if

        return
      end



      subroutine readaltparam

        use altparam
        use pestdata
        use array_interpolation
        implicit none

        integer ierr,iline,ifail,ipestint,interp,nblnk,nblc,ipnextunit
        integer lw(4),rw(4)
        character*200 cline


        if(iaspunit.eq.0) return
        if(aspinfile.eq.' ') return
        iaspunit=ipnextunit()
	  call removequote(aspinfile)  ! emrl
        open(unit=iaspunit,file=aspinfile,status='old',iostat=ierr)
        if(ierr.ne.0)then
          write(*,5) trim(aspinfile)
5         format(/,' *** Cannot open ASP input file ',a,' ***',/)
        call stopfile ! emrl
          stop
        end if

        iline=0
6       iline=iline+1
        read(iaspunit,'(a)',err=9100,end=9000) cline
        if(cline.eq.' ') go to 6
        if(cline(1:1).eq.'#') go to 6
        call linesplit(ifail,2,lw,rw,cline)
        if(ifail.ne.0) then
          write(*,120) iline,trim(aspinfile)
        call stopfile ! emrl
          stop
        end if
        call intread(ifail,cline(lw(1):rw(1)),ipestint)
        if(ifail.ne.0) go to 9100
        call intread(ifail,cline(lw(2):rw(2)),interp)
        if(ifail.ne.0) go to 9100
        if(ipestint.gt.0)then
          ipestunit=1
          limop=1
        end if
        call put_interp_info(interp)
        ialtinterp=interp

        iline=iline+1
        read(iaspunit,'(a)',err=9100,end=9000) cline
        call linesplit(ifail,4,lw,rw,cline)
        if(ifail.ne.0)then
          write(*,120) iline,trim(aspinfile)
120       format(/,' *** Insufficient entries on line',i2,
     +    ' of ASP input file ',a,' ***',/)
        call stopfile ! emrl
          stop
        end if
        call intread(ifail,cline(lw(1):rw(1)),nostop)
        if(ifail.ne.0) go to 9100
        call intread(ifail,cline(lw(2):rw(2)),hdrybot)
        if(ifail.ne.0) go to 9100
        call intread(ifail,cline(lw(3):rw(3)),limop)
        if(ifail.ne.0) go to 9100
        call realread(ifail,cline(lw(4):rw(4)),minthick)
        if(ifail.ne.0) go to 9100

        if(ipestunit.eq.1)then
          iline=iline+1
          read(iaspunit,'(a)',err=9100,end=9000) cline
          call lshift(cline)
          nblc=nblnk(cline)
          call getfile(ifail,cline,pestinfile,1,nblc)
          if(ifail.ne.0) go to 9100
          if(pestinfile.eq.' ') go to 9100
        end if
        iaspline=iline

        return

9000    write(*,9010) aspinfile(1:nblnk(aspinfile))
9010    format(/,' *** Unexepected end encountered to ASP input ',
     +  'file ',a,' ***',/)
        call stopfile ! emrl
        stop

9100    write(*,9110) iline,aspinfile(1:nblnk(aspinfile))
9110    format(/,' *** Error encountered reading line',i2,
     +  ' of ASP input file ',a,' ***',/)
        call stopfile ! emrl
        stop

      end


      logical function equals(rtemp1,rtemp2)

        real rtemp1,rtemp2

        equals=.false.
        if(rtemp1.eq.0.0)then
          if(rtemp2.eq.0.0)then
            equals=.true.
            return
          else
            equals=.false.
          end if
        else if(rtemp2.eq.0.0)then
          equals=.false.
          return
        end if
        if(abs(rtemp2-rtemp1).le.abs(rtemp1+rtemp2)*1.0e-5)then
          equals=.true.
        else
          equals=.false.
        end if
        return
      end



        SUBROUTINE REALREAD(IFAIL,CLINE,RTEMP)

C -- Subroutine REALREAD reads a real number from a string.

        INTEGER IFAIL
        real RTEMP
        CHARACTER*8 AFMT
        CHARACTER*(*) CLINE

        IFAIL=0
        AFMT='(F   .0)'
        WRITE(AFMT(3:5),'(I3)') nblnk(CLINE)  ! emrl pest removed a from nblnk
        READ(CLINE,AFMT,ERR=100) RTEMP
        RETURN

100     IFAIL=1
        RETURN
        END


        subroutine writealtparam(ioutg)

          use altparam
          implicit none

          integer ioutg

          if(iaspunit.eq.0) return
          write(ioutg,50)
50        format(/,' ',79('-'),/)
          write(ioutg,51)
51        format(' VARIABLES READ FROM ASP INPUT FILE:-',/)
          if(nostop.eq.1)then
            write(ioutg,52) NOSTOP
52          format(' NOSTOP = ',i1,'          : DO NOT CEASE ',
     +      'EXECUTION IF MODFLOW FAILS TO CONVERGE.')
          else
            write(ioutg,53) NOSTOP
53          format(' NOSTOP = ',I1,'          : CEASE EXECUTION IF ',
     +      'MODFLOW FAILS TO CONVERGE.')
          end if
          if(hdrybot.eq.1)then
            write(ioutg,54) hdrybot
54          format(' HYDRYBOT = ',I1,'        : ASSIGN CELL BOTTOM ',
     +      'ELEVATION TO HEAD IN DRY CELLS.')
          else
            write(ioutg,55) hdrybot
55          format(' HYDRYBOT = ',I1,'        : ASSIGN HDRY TO HEAD ',
     +      'IN DRY CELL.')
          end if
          if(minthick.le.0.0)then
            write(ioutg,56) minthick
56          format(' MINTHICK = ',f9.3,': DO NOT PREVENT ',  ! emrl pest - removed extra ,
     +      'BASAL CELLS DRYING OUT.')
          else
            write(ioutg,57) minthick
57          format(' MINTHICK = ',F9.3,': MINIMUM SATURATED ',
     +      'THICKNESS FOR BASAL CELLS.')
          end if
          if(limop.eq.1)then
            write(ioutg,64) limop
64          format(' LIMOP = ',I1,'           : OBSERVATION AND ',
     +      'SENSITIVITY OUTPUT LIMITED.')
          else
            write(ioutg,65) limop
65          format(' LIMOP = ',I1,'           : NO LIMITATIONS ON ',
     +      'OBSERVATION OR SENSITIVITY OUTPUT.')
          end if

          write(ioutg,50)

          return
        end


      subroutine initpestdata()

        use pestdata
        ipestunit=0

        return
      end

      subroutine pestprocchek(ipes,isen,isenall)
        use pestdata
        use altparam
        implicit none

        integer isen,isenall,ipes


        if((ipes.gt.0).and.(isen.gt.0).and.(isenall.ne.-1))then
          if(ipestunit.ne.0)then
            write(*,15)
            write(*,1)
1           format(/,' MODFLOW PES process and PEST interface ',
     +      'must not be active togther. ',/)
            write(*,15)
        call stopfile ! emrl
            stop
          end if
          if(hdrybot.ne.0)then
            write(*,15)
            write(*,2)
2           format(/,' If MODFLOW is undertaking parameter ',
     +      'estimation, ASP variable HDRYBOT must be 0',/)
            write(*,15)
        call stopfile ! emrl
            stop
          end if
          if(limop.ne.0)then
            write(*,15)
            write(*,3)
3           format(/,' If MODFLOW is undertaking parameter ',
     +      'estimation, ASP variable LIMOP must be 0',/)
            write(*,15)
        call stopfile ! emrl
            stop
          end if
          if(nostop.ne.0)then
            write(*,15)
            write(*,4)
4           format(/,' If MODFLOW is undertaking parameter ',
     +      'estimation, ASP variable NOSTOP must be 0',/)
            write(*,15)
        call stopfile ! emrl
            stop
          end if
          if(ialtinterp.ne.0)then
            write(*,15)
            write(*,40)
40           format(/,' If MODFLOW is undertaking parameter ',
     +      'estimation, ASP variable INTERP must be 0',/)
            write(*,15)
        call stopfile ! emrl
            stop
          end if
        end if


        if(minthick.gt.0.0)then
          if(isen.gt.0) then
            if(isenall.ne.-1)then
              write(*,15)
              write(*,5)
5             format(/,' *** If sensitivity process active ASP ',
     +        'variable MINTHICK must be zero ***',/)
              write(*,15)
        call stopfile ! emrl
              stop
            end if
          end if
        end if

        if(ipestunit.ne.0)then
          if(minthick.gt.0.0)then
          write(*,15)
          write(*,10)
10        format(/,' *** If PEST interface active ASP ',
     +    'variable MINTHICK must be zero ***',/)
          write(*,15)
        call stopfile ! emrl
          stop
          end if
          if(hdrybot.eq.0)then
            write(*,15)
            write(*,13)
13          format(/,' *** If PEST interface active, ASP ',
     +      'variable HDRYBOT must be 1 ***',/)
            write(*,15)
        call stopfile ! emrl
            stop
          end if
          if(isen.eq.0)then
            write(*,15)
15          format(1x,79('*'),/)
            write(*,20)
20          format(/,' *** If PEST interface active, ',
     +      'sensitivity process must be active ***',/)
            write(*,15)
        call stopfile ! emrl
            stop
          end if
        end if
      end


      subroutine readpestpar(ioutg,ipes,nplist,nd,parnam,obsnam)

        use pestdata
        implicit none

        integer nplist,nd,ierr,i,nblnk,jacfile,ifail,iunit,
     +  ipnextunit,nbcl,ioutg,ipes
        integer lw(7),rw(7)
        character*(*) parnam(nplist),obsnam(nd)
        character*300 cline
        character*12 aname

        if(ipestunit.eq.0) return
        if(ipes.ne.0)then
          write(*,2)
2         format(/,' ******** ERROR ********')
          write(*,3)
3         format(/,' MODFLOW parameter estimation process ',
     +    'and PEST interface process cannot ',/,' both be ',
     +    'active at the same time.')
          go to 9999
        end if
        iunit=ipnextunit()
        if(iunit.eq.0)then
          write(*,5)
5        format(/,' *** Unable to find unit number to read ',
     +    'PEST control file ***',/)
        call stopfile ! emrl
          stop
        end if
	  call removequote(pestinfile)  ! emrl
        open(unit=iunit,file=pestinfile,status='old',iostat=ierr)
        if(ierr.ne.0)then
          write(*,10) pestinfile(1:nblnk(pestinfile))
10        format(/,' *** Cannot open PEST control file ',a,' ***',/)
        call stopfile ! emrl
          stop
        end if
        read(iunit,'(a)',err=9000,end=9100)aname
        call casetrans(aname,'lo')
        call lshift(aname)
        if(aname(1:3).ne.'pcf')then
          write(*,15) pestinfile(1:nblnk(pestinfile))
15        format(/,' *** File ',a,' cited in MODFLOW name file is ',
     +    'not a PEST control file ***',/)
        call stopfile ! emrl
          stop
        end if
        read(iunit,*,err=9000,end=9100)
        read(iunit,*,err=9000,end=9100)
        read(iunit,*,err=9000,end=9100) npar,nobs
        read(iunit,'(a)',err=9000,end=9100) cline
        call linesplit(ifail,7,lw,rw,cline)
        if(ifail.ne.0) go to 9200
        call intread(ifail,cline(lw(6):rw(6)),jacfile)
        if(ifail.ne.0) go to 9200
        if(jacfile.ne.1)then
          write(*,25) pestinfile(1:nblnk(pestinfile))
25        format(/,' *** JACFILE in PEST control file ',
     +    a,' should be set to 1 ***',/)
        call stopfile ! emrl
          stop
        end if
        allocate(imodpar(npar),imodobs(nobs),work(npar),stat=ierr)
        if(ierr.ne.0)then
          write(*,30)
30        format(/,' *** Error allocating memory for PEST interface ',
     +    '***',/)
        call stopfile ! emrl
          stop
        end if

        do
          read(iunit,'(a)',err=9000,end=9300) cline
          call lshift(cline)
          if(cline(1:1).ne.'*')cycle
          cline(1:1)=' '
          call lshift(cline)
          call casetrans(cline,'lo')
          if(index(cline,'parameter da').ne.0) go to 20
        end do
20      continue
        do i=1,npar
          read(iunit,'(a)',err=9000,end=9100) cline
          call linesplit(ifail,1,lw,rw,cline)
          if(ifail.ne.0) go to 9000
          aname=cline(lw(1):rw(1))
          call casetrans(aname,'lo')
          call findname(i,imodpar(i),nplist,parnam,aname)
        end do

        do
          read(iunit,'(a)',err=9000,end=9400) cline
          call lshift(cline)
          if(cline(1:1).ne.'*')cycle
          cline(1:1)=' '
          call lshift(cline)
          call casetrans(cline,'lo')
          if(index(cline,'observation da').ne.0) go to 40
        end do
40      continue
        do i=1,nobs
          read(iunit,'(a)',err=9000,end=9100) cline
          call linesplit(ifail,1,lw,rw,cline)
          if(ifail.ne.0) go to 9000
          aname=cline(lw(1):rw(1))
          call casetrans(aname,'lo')
          call findname(i,imodobs(i),nd,obsnam,aname)
        end do
        read(iunit,'(a)',err=9000,end=9100) cline
        call lshift(cline)
        call casetrans(cline,'lo')
        if(cline(1:6).ne.'* deri')then
          write(*,27) pestinfile(1:nblnk(pestinfile))
27        format(/,' *** Cannot read "* derivatives command ',
     +    'line" section of file ',a,' ***',/)
        call stopfile ! emrl
          stop
        end if
        read(iunit,'(a)',err=9000,end=9100) cline
        read(iunit,'(a)',err=9000,end=9100) cline
        nbcl=nblnk(cline)  ! emrl pest removed a from nblnk
        call getfile(ifail,cline,modderfile,1,nbcl)
        if(ifail.ne.0)then
          write(*,32) pestinfile(1:nblnk(pestinfile))
32        format(/,' *** Cannot read name of derivatives file ',
     +    'from PEST ctl file ',a,' ***',/)
	  go to 9999
	end if
c        read(iunit,'(a)',err=9000,end=9100) modderfile
        call lshift(modderfile)
        close(unit=iunit)

        write(ioutg,50)
50      format(/,' ',79('-'),/)
        write(ioutg,51)
51      format(' PEST INTERFACE:-',/)
        write(ioutg,52) pestinfile(1:nblnk(pestinfile))
52      format(' PEST CONTROL FILE FOR CURRENT CASE = ',a)
        write(ioutg,53) modderfile(1:nblnk(modderfile))
53      format(' MODFLOW-GENERATED EXTERNAL DERIVATIVES FILE ',
     +  'FOR PEST = ',a) 
        write(ioutg,50)

        return


9000    write(*,9010) pestinfile(1:nblnk(pestinfile))
9010    format(/,' *** Error reading PEST control file ',a,' ***',/)
        go to 9999
9100    write(*,9110) pestinfile(1:nblnk(pestinfile))
9110    format(/,' *** Premature end encountered to PEST control ',
     +  'file ',a,' ***',/)
        go to 9999
9200    write(*,9210) pestinfile(1:nblnk(pestinfile))
9210    format(/,' *** Cannot read variable JACFILE from PEST ',
     +  'control file ',a,' ***',/)
        go to 9999
9300    write(*,9310) pestinfile(1:nblnk(pestinfile))
9310    format(/,' *** Cannot find "parameter data" section in ',
     +  'PEST control file ',a,' ***',/)
        go to 9999
9400    write(*,9410) pestinfile(1:nblnk(pestinfile))
9410    format(/,' *** Cannot find "observation data" section in ',
     +  'PEST control file ',a,' ***',/)
        go to 9999
        

9999    close(unit=iunit)
        call stopfile ! emrl
        stop
      end


      subroutine findname(ibeg,iout,ndim,carray,aname)

        implicit none

        integer istart,iout,ndim,i,ibeg
        character*(*) aname
        character*(*)carray(ndim)
        character*12 atemp

        istart=ibeg
        if(istart.gt.ndim)then
          istart=ndim+1
          go to 10
        end if
        do i=istart,ndim
          atemp=carray(i)
          call lshift(atemp)
          call casetrans(atemp,'lo')
          if(atemp.eq.aname) go to 100
        end do
        if(istart.eq.1) then
          iout=0
          return
        end if
10      do i=istart-1,1,-1
          atemp=carray(i)
          call lshift(atemp)
          call casetrans(atemp,'lo')
          if(atemp.eq.aname) go to 100
        end do
        iout=0
        return

100     iout=i
        return
      end



      subroutine writepestjac(npe,nd,x,ipptr,wt,icut)

        use pestdata
        implicit none

        integer npe,nd,ipnextunit,iunit,i,iobs,j,ipar,k,icut
        integer ipptr(npe)
        real x(npe,nd),wt(nd)

        icut=0
        if(ipestunit.eq.0)return

        icut=1
        iunit=ipnextunit()
        if(iunit.eq.0)then
          write(*,10)
10        format(/,' *** Unable to find unit number to write ',
     +    'Jacobian file for PEST ***',/)
        call stopfile ! emrl
          stop
        end if
	  call removequote(modderfile)  ! emrl
        open(unit=iunit,file=modderfile)
        write(iunit,*) npar,nobs
        do i=1,nobs
          iobs=imodobs(i)
          if(iobs.eq.0)then
            do j=1,npar
              work(j)=-1.11e33
            end do
          else if(wt(iobs).lt.0.0)then
            do j=1,npar
              work(j)=0.0
            end do
          else
            do j=1,npar
              ipar=imodpar(j)
              if(ipar.eq.0)then
                work(j)=-1.11e33
              else
                do k=1,npe
                  if(ipptr(k).eq.ipar)then
                    work(j)=x(k,iobs)
                    go to 20
                  end if
                end do
                work(j)=-1.11e33
20              continue
              end if
            end do
          end if
          write(iunit,30)(work(j),j=1,npar)
30        format(7(1x,1pg14.7))
        end do
        close(unit=iunit)

        return
      end


      integer function ipnextunit()

        implicit none

        logical lopened
        integer i

        do i=10,100
          inquire(unit=i,opened=lopened)
          if(.not.lopened) go to 100
        end do
        ipnextunit=0
        return

100     ipnextunit=i
        return
      end


      subroutine lshift(cline)

C -- Subroutine LSHIFT left-justifies a character string.

        character*(*) cline
        cline=adjustl(cline)
        return
      end




      subroutine casetrans(string,hi_or_lo)

C -- Subroutine casetrans converts a string to upper or lower case.

        character*(*) string,hi_or_lo
        character alo, ahi
        integer inc,i,nblnk

        character*500 errmsg
        common /message/errmsg

        if(hi_or_lo.eq.'lo') then
          alo='A'
          ahi='Z'
          inc=iachar('a')-iachar('A')
        else if(hi_or_lo.eq.'hi') then
          alo='a'
          ahi='z'
          inc=iachar('A')-iachar('a')
        endif

        do 20 i=1,nblnk(string)
          if((string(i:i).ge.alo).and.(string(i:i).le.ahi))
     +    string(i:i)=achar(iachar(string(i:i))+inc)
20      continue

        return

      end


      integer function nblnk(aline)

        character*(*) aline
        nblnk=len_trim(aline)
        return
      end


        SUBROUTINE INTREAD(IFAIL,CLINE,ITEMP)

C -- Subroutine intREAD reads an integer from a string.

        INTEGER IFAIL
        integer iTEMP
        CHARACTER*6 AFMT
        CHARACTER*(*) CLINE

        IFAIL=0
        AFMT='(i   )'
        WRITE(AFMT(3:5),'(I3)') LEN(CLINE)
        READ(CLINE,AFMT,ERR=100) iTEMP
        RETURN

100     IFAIL=1
        RETURN
        END


      subroutine getfile(ifail,cline,filename,ibeg,iend)

C -- Subroutine GETFILE extracts a filename from a string.
C    (Note that this is also used in MF2PEST, so if any changes
C     are made here then they must be made there as well.)

        integer ibeg,iend,ifail,i,j,k
        character*(*) cline,filename
        character*1 aa

        ifail=0
        do 30 i=ibeg,iend
          aa=cline(i:i)
          if((aa.ne.' ').and.(aa.ne.',').and.(aa.ne.char(9)))go to 50
30      continue
        ifail=1
        return

50      if((aa.eq.'"').or.(aa.eq.''''))then
          do j=i+1,iend
            if(cline(j:j).eq.aa) go to 60
          end do
          ifail=1
          return
60        iend=j
          if(i+1.gt.j-1)then
            ifail=1
            return
          else
            filename=cline(i+1:j-1)
          end if
        else
          do j=i+1,iend
            if((cline(j:j).eq.' ').or.
     +         (cline(j:j).eq.',').or.(cline(j:j).eq.char(9)))then
              k=j-1
              go to 100
            end if
          end do
          k=iend
100       filename=cline(i:k)
          iend=k
        end if
        call lshift(filename)
        return

      end


         SUBROUTINE LINESPLIT(IFAIL,NUM,LW,RW,CLINE)

C -- Subroutine LINESPLIT splits a string into blank-delimited fragments.

        INTEGER IFAIL,NW,NBLC,J,I
        INTEGER NUM,NBLNK
        INTEGER LW(NUM),RW(NUM)
        CHARACTER*(*) CLINE

        IFAIL=0
        NW=0
c        NBLC=NBLNK(CLINE)
        NBLC=NBLNK(CLINE)  ! emrl pest removed a from nblnk
        IF((NBLC.NE.0).AND.(INDEX(CLINE,CHAR(9)).NE.0)) THEN
          CALL TABREM(CLINE)
c          NBLC=NBLNK(CLINE)
          NBLC=NBLNK(CLINE)  ! emrl pest removed a from nblnk
        ENDIF
        IF(NBLC.EQ.0) THEN
          IFAIL=-1
          RETURN
        END IF
        J=0
5       IF(NW.EQ.NUM) RETURN
        DO 10 I=J+1,NBLC
          IF((CLINE(I:I).NE.' ').AND.(CLINE(I:I).NE.',').AND.
     +    (ICHAR(CLINE(I:I)).NE.9)) GO TO 20
10      CONTINUE
        IFAIL=1
        RETURN
20      NW=NW+1
        LW(NW)=I
        DO 30 I=LW(NW)+1,NBLC
          IF((CLINE(I:I).EQ.' ').OR.(CLINE(I:I).EQ.',').OR.
     +    (ICHAR(CLINE(I:I)).EQ.9)) GO TO 40
30      CONTINUE
        RW(NW)=NBLC
        IF(NW.LT.NUM) IFAIL=1
        RETURN
40      RW(NW)=I-1
        J=RW(NW)
        GO TO 5

        END


        SUBROUTINE TABREM(CLINE)

C -- Subroutine TABREM removes tabs from a string.

        INTEGER I
        CHARACTER*(*) CLINE

        DO 10 I=1,LEN(CLINE)
10      IF(ICHAR(CLINE(I:I)).EQ.9) CLINE(I:I)=' '

        RETURN
        END

