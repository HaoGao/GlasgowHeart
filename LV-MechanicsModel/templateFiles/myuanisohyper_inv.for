C-------------------------------------------------------------
      subroutine uanisohyper_inv(ainv, ua, zeta, nfibers, ninv,
     $     ui1, ui2, ui3, temp, noel, cmname, incmpflag, ihybflag,
     $     numstatev, statev, numfieldv, fieldv, fieldvinc,
     $     numprops, props)
C
      include 'aba_param.inc'
C
      character*80 cmname
      dimension ua(2), ainv(ninv), ui1(ninv),
     $     ui2(ninv*(ninv+1)/2), ui3(ninv*(ninv+1)/2),
     $     statev(numstatev), fieldv(numfieldv),
     $     fieldvinc(numfieldv), props(numprops)
C
C
C
      if (cmname(1:20) .eq. 'UANISO_HO_MYOCARDIUM') then
         call UANISOHYPER_INVHOMODEL(ainv, ua, zeta, nfibers, ninv,
     $     ui1, ui2, ui3, temp, noel, cmname, incmpflag, ihybflag,
     $     numstatev, statev, numfieldv, fieldv, fieldvinc,
     $     numprops, props)
      else
         write(6,*)'ERROR: User subroutine UANISOHYPER_INV missing!'
         call xit
      end if
C
C
C
      return
      end
c------------------------------------------------------------------
c
c     Holzapfel and Ogden passive myocardium constitutive model
c
      subroutine uanisohyper_invhomodel(ainv, ua, zeta, nfibers, ninv,
     $     ui1, ui2, ui3, temp, noel, cmname, incmpflag, ihybflag,
     $     numstatev, statev, numfieldv, fieldv, fieldvinc,
     $     numprops, props)
C
      include 'aba_param.inc'
C
      character*80 cmname
      dimension ua(2), ainv(ninv), ui1(ninv),
     $     ui2(ninv*(ninv+1)/2), ui3(ninv*(ninv+1)/2),
     $     statev(numstatev), fieldv(numfieldv),
     $     fieldvinc(numfieldv), props(numprops)

C
c     ainv: invariants
c     ua  : energies ua(1): utot, ua(2); udev
c     ui1 : dUdI
c     ui2 : d2U/dIdJ
c     ui3 : d3U/dIdJdJ, not used for regular elements
C
      parameter ( half = 0.5d0,
     *            zero = 0.d0, 
     *            one  = 1.d0, 
     *            two  = 2.d0, 
     *            three = 3.d0,
     *            index_J = 3,
     *            asmall  = 2.d-16)
C
C Read material properties
C
      a  = props(1)
      b  = props(2)
      af = props(3)
      bf = props(4)
      as = props(5)
      bs = props(6)
      afs= props(7)
      bfs= props(8)
C - Compressible case
      D  = props(9)
C	  write(6,*)'the value of D is:', D
C
C Compute Udev and 1st and 2nd derivatives w.r.t invariants
C
      ua(2) = zero
C - I1
      bi1 = aInv(1)
      term1 = bi1-three
      term2 = half*a*exp(b*term1)
      ua(2) = (one/b)*term2
      ui1(1) = term2
      ui2(indx(1,1)) = b*term2
C - I4(11) refer to I4f
      nI411 = indxInv4(1,1)
      bi411 = aInv(nI411)
      aux1f = bi411-one
      aux2f = half+sign(half,aux1f+asmall)
      term1 = max(aux1f,zero)
      term2 = half*af*exp(bf*term1**2)
      ua(2) = ua(2)+(one/bf)*(term2 - half*af)
      ui1(nI411) = two*term1*term2
      ui2(indx(nI411,nI411))= two*term2*(one + two*bf*term1**2)*aux2f
C - I4(22) refer to I4s
      nI422 = indxInv4(2,2)
      bi422 = aInv(nI422)
      aux1s = bi422-one
      aux2s = half+sign(half,aux1s+asmall)
      term1 = max(aux1s,zero)
      term2 = half*as*exp(bs*term1**2)
      ua(2) = ua(2)+(one/bs)*(term2 - half*as)
      ui1(nI422) = two*term1*term2
      ui2(indx(nI422,nI422))= two*term2*(one + two*bs*term1**2)*aux2s
C - I4(12) refer to I8fs
      nI412 = indxInv4(1,2)
      bi412 = aInv(nI412)
      term1 = bi412
      term2 = half*afs*exp(bfs*term1**2)
      ua(2) = ua(2)+(one/bfs)*(term2 - half*afs)
      ui1(nI412) = two*term1*term2
      ui2(indx(nI412,nI412)) = two*term2*(one + two*bfs*term1**2)
      
C     
C - Compressible case
C
C      if(D .gt. zero) then
C         Dinv = one / D
C         det = ainv(index_J)
C        ua(1) = ua(2) + Dinv *((det*det - one)/two - log(det))
C         ui1(index_J) = Dinv * (det - one/det)
C         ui2(indx(index_J,index_J))= Dinv * (one + one / det / det)
C         if (hybflag.eq.1) then
C           ui3(indx(index_J,index_J))= - Dinv * two / (det*det*det)
C         end if
C      end if

      if(D.gt.zero) then
         Dinv = one / D
         det = ainv(index_J)
         ua(1) = ua(2) + Dinv *((det*det - one)/two - log(det))
         ui1(index_J) = Dinv * (det - one/det)
         ui2(indx(index_J,index_J))= Dinv * (one + one / det / det)
         if (hybflag.eq.1) then
           ui3(indx(index_J,index_J))= - Dinv * two / (det*det*det)
         end if
      end if

C
C     write(6,*) ninv,nfibers,incmpflag,ihybflag
C     write(6,*) ua(1),ua(2)
C     write(6,*) ainv(1),ainv(2),ainv(3),ainv(4),ainv(5),ainv(6),ainv(7)
C    $ ,ainv(8),ainv(9)
C     write(6,*) ui1(1),ui1(2),ui1(3),ui1(4),ui1(5),ui1(6),ui1(7),ui1(8)
C    $ ,ui1(9)
C
      return
      end
C-------------------------------------------------------------
C     Function to map index from Square to Triangular storage 
C 		 of symmetric matrix
C
      integer function indx( i, j )
      include 'aba_param.inc'
      ii = min(i,j)
      jj = max(i,j)
      indx = ii + jj*(jj-1)/2
      return
      end
C-------------------------------------------------------------
C
C     Function to generate enumeration of scalar
C     Pseudo-Invariants of type 4

      integer function indxInv4( i, j )
      include 'aba_param.inc'
      ii = min(i,j)
      jj = max(i,j)
      indxInv4 = 4 + jj*(jj-1) + 2*(ii-1)
      return
      end
C-------------------------------------------------------------
C
C     Function to generate enumeration of scalar
C     Pseudo-Invariants of type 5
C
      integer function indxInv5( i, j )
      include 'aba_param.inc'
      ii = min(i,j)
      jj = max(i,j)
      indxInv5 = 5 + jj*(jj-1) + 2*(ii-1)
      return
      end
C-------------------------------------------------------------
