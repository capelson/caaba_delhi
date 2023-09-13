  SUBROUTINE jval_cal_MVK

    ! MVK -> products JPL 2006, cross sections and total quantum yield, channels: 60\% to C3H6 + CO, 20\% to CH2CHCO + CH3, 20\% to C2H3 + CH3CO (IUPAC)

    INTEGER :: j, k
    REAL    :: dj
    REAL, DIMENSION(0:MAXWAV) :: sig_MVK

    REAL :: f6

    ! T-const parameters:
    REAL, PARAMETER :: a3_MVK(dim55) = (/ &
      -7.8560E-25,-5.2719E-25,-3.3545E-25,-2.2933E-25,-1.6775E-25,-1.3178E-25, &
      -1.0782E-25,-8.9010E-26,-7.3594E-26,-6.5036E-26,-5.6485E-26,-4.9635E-26, &
      -4.4496E-26,-3.9370E-26,-3.4231E-26,-3.2522E-26,-2.9095E-26,-2.7374E-26, &
      -2.3971E-26,-2.2263E-26,-2.0512E-26,-1.8836E-26,-1.8836E-26,-1.7121E-26, &
      -1.5386E-26,-1.3697E-26,-1.3701E-26,-1.3697E-26,-1.1965E-26,-1.0274E-26, &
      -1.0277E-26,-1.0274E-26,-1.0256E-26,-8.5621E-27,-6.8469E-27,-8.5474E-27, &
      -6.8503E-27,-6.8504E-27,-6.8469E-27,-6.8386E-27,-5.1355E-27,-3.7652E-27, &
      -3.0804E-27,-2.0541E-27,-1.7118E-27,-1.3691E-27,-1.0267E-27,-6.8514E-28, &
      -3.4211E-28,-6.8445E-28,-3.4223E-28,-0.0000E+00,-3.4223E-28,-0.0000E+00, &
      -3.4280E-28 /)
    REAL, PARAMETER :: b3_MVK(dim55) = (/ &
      1.8978E-21, 1.8826E-21, 1.8601E-21, 1.8414E-21, 1.8270E-21, 1.8165E-21, &
      1.8081E-21, 1.8003E-21, 1.7931E-21, 1.7886E-21, 1.7836E-21, 1.7792E-21, &
      1.7756E-21, 1.7717E-21, 1.7675E-21, 1.7660E-21, 1.7628E-21, 1.7611E-21, &
      1.7575E-21, 1.7556E-21, 1.7536E-21, 1.7515E-21, 1.7515E-21, 1.7492E-21, &
      1.7468E-21, 1.7443E-21, 1.7443E-21, 1.7443E-21, 1.7415E-21, 1.7386E-21, &
      1.7386E-21, 1.7386E-21, 1.7386E-21, 1.7353E-21, 1.7319E-21, 1.7354E-21, &
      1.7318E-21, 1.7318E-21, 1.7318E-21, 1.7318E-21, 1.7278E-21, 1.7242E-21, &
      1.7222E-21, 1.7189E-21, 1.7177E-21, 1.7164E-21, 1.7150E-21, 1.7135E-21, &
      1.7119E-21, 1.7136E-21, 1.7118E-21, 1.7099E-21, 1.7119E-21, 1.7098E-21, &
      1.7120E-21/)
    REAL, PARAMETER :: a4_MVK(2)= (/1.4748E-21, -1.4195E-26/)
    REAL, PARAMETER :: a5_MVK(3)= (/8.0692E-22, -5.8770E-26,  4.5077E-30/)
    REAL, PARAMETER :: a6_MVK(2)= (/4.1874E-23, -3.9217E-28/)
    jval_2d(ip_MVK)%ptr(:,:) = 0.0_dp
    DO k = 1,klev
      DO j = 1,kproma_day
        sig_MVK(3) = &
          p1(b3_MVK(i3(j,k)), a3_MVK(i3(j,k)), &
          v3_du2(j,k))
        sig_MVK(4) = &
          p1(a4_MVK(1),a4_MVK(2),v3_du2(j,k))
        sig_MVK(5) = &
          p2(a5_MVK(1),a5_MVK(2),a5_MVK(3),v3_du2(j,k))
        sig_MVK(6) = &
          p1(a6_MVK(1),a6_MVK(2),v3_du2(j,k))
        ! drel = dens(j,k)/dens_ref (32.16=denom with dens=2.90e19 used for fit in f6)
        f6=32.16/(5.5+9.2E-19*dens(j,k))
        dj = 0. &
          + sig_MVK(3) *F6 * fint(j,k,3)  &
          + sig_MVK(4) *F6 * fint(j,k,4)  &
          + sig_MVK(5) *F6 * fint(j,k,5)  &
          + sig_MVK(6) *F6 * fint(j,k,6)

        jval_2d(ip_MVK)%ptr(iu0(j),k) = REAL(MAX(0.0, dj*fj_corr(j,6)),dp)
      ENDDO
    ENDDO

  END SUBROUTINE jval_cal_MVK