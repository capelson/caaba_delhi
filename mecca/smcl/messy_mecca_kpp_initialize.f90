! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! Initialization File
! 
! Generated by KPP-2.2.3_rs3 symbolic chemistry Kinetics PreProcessor
!       (http://www.cs.vt.edu/~asandu/Software/KPP)
! KPP is distributed under GPL, the general public licence
!       (http://www.gnu.org/copyleft/gpl.html)
! (C) 1995-1997, V. Damian & A. Sandu, CGRER, Univ. Iowa
! (C) 1997-2005, A. Sandu, Michigan Tech, Virginia Tech
!     With important contributions from:
!        M. Damian, Villanova University, USA
!        R. Sander, Max-Planck Institute for Chemistry, Mainz, Germany
! 
! File                 : messy_mecca_kpp_Initialize.f90
! Time                 : Fri Sep  8 17:11:17 2023
! Working directory    : /home/taras/Work/EMAC/caaba/mecca
! Equation file        : messy_mecca_kpp.kpp
! Output root filename : messy_mecca_kpp
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



MODULE messy_mecca_kpp_Initialize

  USE messy_mecca_kpp_Parameters, ONLY: dp, NVAR, NFIX
  IMPLICIT NONE

CONTAINS


! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! Initialize - function to initialize concentrations
!   Arguments :
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SUBROUTINE Initialize ( )


  USE messy_mecca_kpp_Global

  USE messy_mecca_kpp_Parameters

  INTEGER :: i
  REAL(kind=dp) :: x

  CFACTOR = 1.000000e+00_dp

  x = (0.)*CFACTOR
  DO i = 1, NVAR
    VAR(i) = x
  END DO

  x = (0.)*CFACTOR
  DO i = 1, NFIX
    FIX(i) = x
  END DO

! constant rate coefficients
  RCONST(10) = 1.8e-12
  RCONST(12) = 1
  RCONST(24) = 3.5e-12
  RCONST(37) = 1.2e-14
  RCONST(38) = 1300
  RCONST(42) = 1.66e-12
  RCONST(53) = 1.2e-12
  RCONST(63) = 3e-14
  RCONST(76) = 1.2e-12
  RCONST(82) = 1.4e-10
  RCONST(85) = 5.2e-12
  RCONST(86) = 6e-14
  RCONST(88) = 3.6e-14
  RCONST(89) = 1e-10
  RCONST(90) = 1.7e-12
  RCONST(91) = 5e-12
  RCONST(92) = 5e-12
  RCONST(93) = 5e-12
  RCONST(94) = 1e-12
  RCONST(95) = 6e-11
  RCONST(101) = 1.3e-10
  RCONST(102) = 2.53e-14
  RCONST(103) = 2.5e-11
  RCONST(104) = 4.3e-11
  RCONST(114) = 7e-15
  RCONST(121) = 2.3e-12
  RCONST(134) = 4e-12
  RCONST(138) = 3e-14
  RCONST(318) = 7.6e-11
  RCONST(327) = 6.3e-15
  RCONST(357) = 4.29e-11
  RCONST(367) = 2.1e-11
  RCONST(368) = 2.14e-11
  RCONST(376) = 1.39e-11
  RCONST(377) = 1.73e-11
  RCONST(379) = 4.51e-12
  RCONST(380) = 2.49e-11
  RCONST(381) = 1.44e-10
  RCONST(393) = 9.82e-11
  RCONST(394) = 6.97e-11
  RCONST(396) = 1.36e-10
  RCONST(397) = 7.33e-11
  RCONST(436) = 3.2e-11
  RCONST(520) = 3.4e-13
  RCONST(545) = 3.5e-13
  RCONST(577) = 8.8e-11
  RCONST(580) = 8.8e-11
  RCONST(595) = 7.46e-11
  RCONST(599) = 8.33e-11
  RCONST(600) = 3.39e-11
  RCONST(607) = 1.63e-11
  RCONST(609) = 1.27e-11
  RCONST(612) = 1.4e-11
  RCONST(621) = 1.72e-12
  RCONST(622) = 4.8e-12
  RCONST(624) = 4.75e-13
  RCONST(627) = 1.2e-15
  RCONST(628) = 1e-14
  RCONST(629) = 1e-15
  RCONST(630) = 1.4e-12
  RCONST(631) = 1.22e-10
  RCONST(634) = 2.19e-11
  RCONST(635) = 3.68e-11
  RCONST(636) = 3.67e-11
  RCONST(644) = 3e-13
  RCONST(645) = 2.2e-19
  RCONST(646) = 4.45e-11
  RCONST(647) = 6.18e-12
  RCONST(648) = 4e-11
  RCONST(649) = 2.31e-11
  RCONST(657) = 5.68e-12
  RCONST(659) = 2e-18
  RCONST(660) = 5.2e-11
  RCONST(661) = 4.66e-11
  RCONST(662) = 3.7e-11
  RCONST(669) = 2.62e-11
  RCONST(670) = 2.45e-11
  RCONST(676) = 3.7e-11
  RCONST(678) = 4.32e-11
  RCONST(685) = 3.44e-11
  RCONST(686) = 1.16e-12
  RCONST(692) = 1.78e-11
  RCONST(698) = 2.29e-11
  RCONST(700) = 3.59e-12
  RCONST(704) = 5.53e-13
  RCONST(705) = 3e-12
  RCONST(706) = 6.78e-13
  RCONST(707) = 3e-12
  RCONST(741) = 1e-17
  RCONST(754) = 1e-17
  RCONST(761) = 1.03e-10
  RCONST(763) = 2.4e-17
  RCONST(768) = 2.65e-11
  RCONST(772) = 2.4e-17
  RCONST(790) = 2.52e-11
  RCONST(791) = 2.88e-11
  RCONST(793) = 2.52e-11
  RCONST(794) = 3.81e-11
  RCONST(801) = 9.7e-12
  RCONST(809) = 2.4e-17
  RCONST(839) = 2.8e-17
  RCONST(846) = 10000
  RCONST(860) = 4.829e-16
  RCONST(876) = 1.9e-11
  RCONST(887) = 2.52e-11
  RCONST(892) = 7.49e-11
  RCONST(893) = 6.65e-11
  RCONST(901) = 3.12e-13
  RCONST(905) = 1.01e-10
  RCONST(910) = 1.33e-10
  RCONST(912) = 9.23e-11
  RCONST(917) = 2.64e-11
  RCONST(923) = 1.1e-10
  RCONST(924) = 4.33e-11
  RCONST(925) = 7.55e-11
  RCONST(927) = 7.19e-11
  RCONST(941) = 3.79e-12
  RCONST(942) = 1.38e-11
  RCONST(949) = 4.26e-12
  RCONST(956) = 4.5e-12
  RCONST(957) = 1.27e-12
  RCONST(959) = 1.23e-12
  RCONST(962) = 1.72e-11
  RCONST(968) = 7.48e-11
  RCONST(969) = 5.43e-11
  RCONST(971) = 7.52e-11
  RCONST(978) = 1.5e-12
  RCONST(984) = 2.74e-11
  RCONST(993) = 5.44e-11
  RCONST(995) = 2e-18
  RCONST(996) = 6.2e-11
  RCONST(997) = 4.38e-11
  RCONST(998) = 1e-12
  RCONST(999) = 8e-19
  RCONST(1000) = 6.9e-11
  RCONST(1007) = 3.06e-11
  RCONST(1009) = 7.09e-11
  RCONST(1010) = 1.69e-11
  RCONST(1011) = 1.21e-10
  RCONST(1013) = 8.76e-13
  RCONST(1014) = 4.44e-12
  RCONST(1015) = 1e-14
  RCONST(1022) = 3.59e-12
  RCONST(1023) = 2.53e-11
  RCONST(1024) = 3.59e-12
  RCONST(1039) = 1.01e-11
  RCONST(1045) = 7.11e-12
  RCONST(1046) = 8.69e-11
  RCONST(1047) = 3.22e-12
  RCONST(1048) = 1.33e-11
  RCONST(1050) = 1.16e-10
  RCONST(1051) = 7.7e-11
  RCONST(1052) = 3.6e-11
  RCONST(1059) = 4.05e-11
  RCONST(1061) = 7.3e-11
  RCONST(1062) = 9e-14
  RCONST(1063) = 9e-13
  RCONST(1069) = 6.07e-11
  RCONST(1070) = 9.9e-11
  RCONST(1071) = 9.2e-18
  RCONST(1072) = 1e-10
  RCONST(1073) = 8.01e-11
  RCONST(1074) = 2.6e-12
  RCONST(1075) = 3.47e-12
  RCONST(1083) = 2e-18
  RCONST(1084) = 6.08e-11
  RCONST(1090) = 9e-13
  RCONST(1097) = 7.66e-11
  RCONST(1101) = 9.2e-11
  RCONST(1107) = 4.06e-11
  RCONST(1111) = 2.25e-15
  RCONST(1112) = 3e-14
  RCONST(1113) = 3.8e-12
  RCONST(1115) = 3e-13
  RCONST(1116) = 4.6e-12
  RCONST(1122) = 9.42e-11
  RCONST(1134) = 1.07e-10
  RCONST(1138) = 1.23e-10
  RCONST(1144) = 8.16e-11
  RCONST(1150) = 9.77e-11
  RCONST(1157) = 3.28e-11
  RCONST(1159) = 6.68e-11
  RCONST(1161) = 6.45e-11
  RCONST(1173) = 4.37e-11
  RCONST(1174) = 3.6e-12
  RCONST(1175) = 1.31e-10
  RCONST(1188) = 4.38e-11
  RCONST(1196) = 6.7e-11
  RCONST(1202) = 4.75e-12
  RCONST(1203) = 8.83e-13
  RCONST(1209) = 1.2e-10
  RCONST(1213) = 1.27e-11
  RCONST(1217) = 3.31e-11
  RCONST(1230) = 1.4e-11
  RCONST(1231) = 4.65e-11
  RCONST(1239) = 5e-18
  RCONST(1240) = 7.99e-11
  RCONST(1241) = 2.05e-11
  RCONST(1242) = 6.03e-12
  RCONST(1243) = 2.4e-15
  RCONST(1258) = 2.8e-17
  RCONST(1260) = 9.64e-11
  RCONST(1261) = 7.16e-11
  RCONST(1262) = 7.99e-11
  RCONST(1283) = 1.15e-10
  RCONST(1284) = 1.07e-10
  RCONST(1286) = 2.8e-12
  RCONST(1294) = 5.98e-11
  RCONST(1295) = 6.29e-11
  RCONST(1296) = 5.96e-11
  RCONST(1298) = 7.04e-11
  RCONST(1299) = 3.06e-11
  RCONST(1300) = 4.06e-11
  RCONST(1301) = 4.66e-12
  RCONST(1302) = 1.1e-12
  RCONST(1303) = 1.06e-12
  RCONST(1305) = 1e-12
  RCONST(1306) = 2.3e-11
  RCONST(1309) = 4.65e-11
  RCONST(1310) = 5.03e-12
  RCONST(1311) = 6.83e-12
  RCONST(1327) = 7.83e-15
  RCONST(1328) = 5.1e-14
  RCONST(1344) = 2.05e-10
  RCONST(1345) = 8.56e-11
  RCONST(1346) = 1.42e-10
  RCONST(1347) = 7.95e-11
  RCONST(1358) = 1.53e-12
  RCONST(1361) = 9.58e-11
  RCONST(1370) = 9.29e-11
  RCONST(1371) = 8.96e-11
  RCONST(1376) = 1.29e-11
  RCONST(1380) = 3.45e-11
  RCONST(1387) = 1.09e-11
  RCONST(1391) = 1.86e-11
  RCONST(1393) = 2.63e-11
  RCONST(1402) = 9.65e-12
  RCONST(1403) = 6.57e-12
  RCONST(1404) = 2.96e-12
  RCONST(1406) = 3.04e-12
  RCONST(1411) = 1.62e-11
  RCONST(1412) = 1.84e-12
  RCONST(1413) = 3.94e-12
  RCONST(1419) = 3.61e-11
  RCONST(1420) = 2.56e-11
  RCONST(1426) = 8.35e-11
  RCONST(1427) = 4.96e-11
  RCONST(1428) = 4.01e-12
  RCONST(1429) = 1.01e-12
  RCONST(1430) = 2.61e-12
  RCONST(1431) = 9.32e-12
  RCONST(1432) = 3.9e-16
  RCONST(1433) = 7e-12
  RCONST(1434) = 1.2e-16
  RCONST(1435) = 1.5e-12
  RCONST(1436) = 1.7e-17
  RCONST(1437) = 5.8e-11
  RCONST(1442) = 6.16e-11
  RCONST(1448) = 6.16e-11
  RCONST(1453) = 2.88e-12
  RCONST(1455) = 1.3e-11
  RCONST(1460) = 1.05e-11
  RCONST(1465) = 2.05e-11
  RCONST(1466) = 2.64e-11
  RCONST(1474) = 6.6e-12
  RCONST(1475) = 1.02e-11
  RCONST(1483) = 2.69e-11
  RCONST(1484) = 3e-11
  RCONST(1486) = 2.52e-11
  RCONST(1494) = 7.29e-12
  RCONST(1495) = 1.55e-11
  RCONST(1500) = 2.63e-11
  RCONST(1501) = 3.07e-12
  RCONST(1503) = 1.2e-15
  RCONST(1504) = 1e-14
  RCONST(1505) = 1e-15
  RCONST(1509) = 1.04e-11
  RCONST(1511) = 6.77e-12
  RCONST(1512) = 8.27e-12
  RCONST(1513) = 1.89e-12
  RCONST(1514) = 1.41e-12
  RCONST(1515) = 2.917e-11
  RCONST(1516) = 1.52e-15
  RCONST(1523) = 2.77e-11
  RCONST(1524) = 4.29e-12
  RCONST(1525) = 6.46e-11
  RCONST(1529) = 1e-11
  RCONST(1531) = 2e-14
  RCONST(1541) = 3.66e-12
  RCONST(1542) = 6.65e-12
  RCONST(1543) = 9.73e-12
  RCONST(1548) = 2.75e-11
  RCONST(1549) = 2.25e-11
  RCONST(1554) = 8.01e-11
  RCONST(1555) = 7.03e-11
  RCONST(1558) = 1.2e-15
  RCONST(1559) = 1e-14
  RCONST(1560) = 1e-15
  RCONST(1563) = 1.2e-15
  RCONST(1564) = 1e-14
  RCONST(1565) = 1e-15
  RCONST(1570) = 5.47e-11
  RCONST(1571) = 5.47e-11
  RCONST(1585) = 1.33e-11
  RCONST(1586) = 4.7e-12
  RCONST(1603) = 2.51e-12
  RCONST(1609) = 9.58e-12
  RCONST(1610) = 9.16e-13
  RCONST(1611) = 9.16e-13
  RCONST(1623) = 9.1e-12
  RCONST(1630) = 2.51e-12
  RCONST(1637) = 2.51e-12
  RCONST(1638) = 5.67e-11
  RCONST(1639) = 2.6e-15
  RCONST(1646) = 1.2e-12
  RCONST(1657) = 1.6e-11
  RCONST(1658) = 3.6e-12
  RCONST(1659) = 2.4e-11
  RCONST(1667) = 2.05e-10
  RCONST(1669) = 5.9e-11
  RCONST(1673) = 8e-11
  RCONST(1677) = 2.1e-12
  RCONST(1678) = 1.6e-10
  RCONST(1680) = 1.3e-16
  RCONST(1681) = 6.2e-11
  RCONST(1682) = 1.5e-10
  RCONST(1690) = 3.8e-11
  RCONST(1691) = 4.8e-11
  RCONST(1692) = 1.3e-10
  RCONST(1695) = 1e-10
  RCONST(1697) = 2.7e-12
  RCONST(1703) = 4.9e-11
  RCONST(1716) = 3.32e-15
  RCONST(1717) = 1.1e-15
  RCONST(1722) = 1.45e-11
  RCONST(1730) = 1e-10
  RCONST(1732) = 3e-13
  RCONST(1733) = 5e-11
  RCONST(1735) = 7e-14
  RCONST(1736) = 7e-14
  RCONST(1737) = 7e-14
  RCONST(1738) = 7e-14
  RCONST(1739) = 3.3e-10
  RCONST(1741) = 4.4e-13
  RCONST(3326) = 0
! END constant rate coefficients

! INLINED initializations

  ! start of code from messy_mecca_kpp.kpp
  rtol(:) = 1E-2_dp ! relative tolerance
  atol(:) = 1E1_dp  ! absolute tolerance
  IF ((ind_OH  >0).AND.(ind_OH  <=NVAR)) atol(ind_OH)  = 1._dp
  IF ((ind_NO3 >0).AND.(ind_NO3 <=NVAR)) atol(ind_NO3) = 1._dp
  IF ((ind_Cl  >0).AND.(ind_Cl  <=NVAR)) atol(ind_Cl)  = 1._dp
  IF ((ind_Br  >0).AND.(ind_Br  <=NVAR)) atol(ind_Br)  = 1._dp
  IF ((ind_O1D >0).AND.(ind_O1D <=NVAR)) atol(ind_O1D) = 1._dp
  ! end of code from messy_mecca_kpp.kpp

! End INLINED initializations

      
END SUBROUTINE Initialize

! End of Initialize function
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



END MODULE messy_mecca_kpp_Initialize

