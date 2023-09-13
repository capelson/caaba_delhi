!*****************************************************************************

! Authors:
! Andreas Baumgaertner, MPICH, 2010-...

!*****************************************************************************

! This program is free software; you can redistribute it and/or
! modify it under the terms of the GNU General Public License
! as published by the Free Software Foundation; either version 2
! of the License, or (at your option) any later version.

! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.

! You should have received a copy of the GNU General Public License
! along with this program; if not, get it from:
! http://www.gnu.org/copyleft/gpl.html

!*****************************************************************************

MODULE messy_radjimt_box

  USE messy_main_constants_mem, ONLY: DP
  USE caaba_io,  ONLY: open_output_file, write_output_file, &
                       close_file
  USE messy_cmn_photol_mem      ! IP_MAX, ip_*, jname
  USE messy_radjimt

  IMPLICIT NONE
  PRIVATE

  INTEGER :: ncid_radjimt

  INTEGER :: nlev ! number of levels
  INTEGER, PARAMETER :: jrow =  1 ! must be jrow=1 for box model

  REAL(DP), POINTER, DIMENSION(:,:,:,:) :: heatrates
  REAL(dp), ALLOCATABLE, DIMENSION(:) :: jpress & ! given pressure levels
       , nd_gas1_1d, nd_gas2_1d, nd_gas3_1d &
       , gas_O3_1d, gas_H2O_1d, gas_H2O2_1d &
       , nden1d, r0_eff, scht1d, temp1d, ht1d, cp1d, den1d
  REAL(dp) :: eccentric, f107
  REAL(dp) :: mmw_gas1 = 16.
  REAL(dp) :: mmw_gas2 = 32.
  REAL(dp) :: GRAV0 = 9.5

  LOGICAL :: l_heating, l_reduceO3heating

  PUBLIC :: radjimt_init   ! initialize J-values
  PUBLIC :: radjimt_physc  ! calculate J values
  PUBLIC :: radjimt_result
  PUBLIC :: radjimt_finish

CONTAINS

  ! --------------------------------------------------------------------------

  SUBROUTINE radjimt_init

    USE messy_main_tools,          ONLY: find_next_free_unit
    USE caaba_mem,                 ONLY: photo_scenario

    IMPLICIT NONE

    INTEGER :: status ! status flag
    INTEGER :: ip, iou1, iou2

    ! read radjimt ctrl namelist:
    CALL radjimt_read_nml_ctrl(status, 999)
    IF (status /= 0) STOP 1

    ! intialize flux data
    iou1 = find_next_free_unit(100,150)
    iou2 = find_next_free_unit(151,200)
    CALL radjimt_readfluxes(iou1,iou2)

    CALL open_output_file(ncid_radjimt, 'caaba_radjimt', &
      (/ ('J_'//jname(ip), ip=1,IP_MAX) /), &
      (/ ('1/s',           ip=1,IP_MAX) /), &
      (/ ('J_'//jname(ip), ip=1,IP_MAX) /)) ! longname same as name

    SELECT CASE (TRIM(photo_scenario))
    CASE ('MTCHEM')
      CALL photo_mtchem
    CASE DEFAULT
      PRINT *, 'ERROR, photo_scenario '//TRIM(photo_scenario)// &
        ' is not defined in '//TRIM(modstr)//'.'
      STOP 1
    END SELECT

    CALL BranchingRatios(nlev,jpress,ht1d)

    !-------------------------------------------------------------------------

  CONTAINS

    !-------------------------------------------------------------------------

    SUBROUTINE allocate_arrays

      ALLOCATE(jx(nlev,1,IP_MAX,1))

      ALLOCATE(jpress(nlev))
      ALLOCATE(nd_gas1_1d(nlev), nd_gas2_1d(nlev), nd_gas3_1d(nlev) &
       , gas_O3_1d(nlev), gas_H2O_1d(nlev), gas_H2O2_1d(nlev) &
       , nden1d(nlev), r0_eff(nlev), scht1d(nlev), temp1d(nlev), ht1d(nlev), cp1d(nlev), den1d(nlev))
      ALLOCATE(heatrates(nlev,1,heatcool_rates,1))
      ALLOCATE(O2eff_bulk(nlev), O3eff_bulk(nlev) &
           , htlyeff(nlev), euveff(nlev), src1eff(nlev) &
           , PEOP(nlev),PEN2(nlev),PEO2(nlev))
      O2eff_bulk(:)=1.
      O3eff_bulk(:)=1.
      htlyeff(:)=1.

      ALLOCATE(CSH2O2(NLEV,92))
      ALLOCATE(branch(ht_branches,nlev))

    END SUBROUTINE allocate_arrays

    !-------------------------------------------------------------------------


    !-------------------------------------------------------------------------

   SUBROUTINE photo_mtchem


!!$     nlev = 39
!!$
!!$     CALL allocate_arrays
!!$
!!$! cmat/util/extract.tcsh
!!$     jpress = 100.*(/&
!!$0.10376E-01 , &
!!$0.74347E-02 , &
!!$0.53272E-02 , &
!!$0.38171E-02 , &
!!$0.27351E-02 , &
!!$0.19598E-02 , &
!!$0.14042E-02 , &
!!$0.10062E-02 , &
!!$0.72096E-03 , &
!!$0.51659E-03 , &
!!$0.37015E-03 , &
!!$0.26523E-03 , &
!!$0.19004E-03 , &
!!$0.13617E-03 , &
!!$0.97571E-04 , &
!!$0.69913E-04 , &
!!$0.50095E-04 , &
!!$0.35894E-04 , &
!!$0.25720E-04 , &
!!$0.18429E-04 , &
!!$0.13205E-04 , &
!!$0.94617E-05 , &
!!$0.67796E-05 , &
!!$0.48578E-05 , &
!!$0.34808E-05 , &
!!$0.24941E-05 , &
!!$0.17871E-05 , &
!!$0.12805E-05 , &
!!$0.91752E-06 , &
!!$0.65743E-06 , &
!!$0.47107E-06 , &
!!$0.33754E-06 , &
!!$0.24186E-06 , &
!!$0.17330E-06 , &
!!$0.12417E-06 , &
!!$0.88974E-07 , &
!!$0.63752E-07 , &
!!$0.45681E-07 , &
!!$0.32732E-07 /)
!!$
!!$ den1d = (/ &
!!$  1.87477e-05,&
!!$  1.354029e-05,&
!!$  9.94586e-06,&
!!$  7.288474e-06,&
!!$  5.323769e-06,&
!!$  3.872492e-06,&
!!$  2.801957e-06,&
!!$  2.01335e-06,&
!!$  1.434484e-06,&
!!$  1.011729e-06,&
!!$  7.048896e-07,&
!!$  4.841471e-07,&
!!$  3.278537e-07,&
!!$  2.202185e-07,&
!!$  1.474709e-07,&
!!$  9.837859e-08,&
!!$  6.481214e-08,&
!!$  4.169847e-08,&
!!$  2.608586e-08,&
!!$  1.590773e-08,&
!!$  9.752077e-09,&
!!$  6.112167e-09,&
!!$  3.894726e-09,&
!!$  2.520615e-09,&
!!$  1.654455e-09,&
!!$  1.099133e-09,&
!!$  7.378024e-10,&
!!$  4.994878e-10,&
!!$  3.404454e-10,&
!!$  2.33279e-10,&
!!$  1.605094e-10,&
!!$  1.107977e-10,&
!!$  7.668384e-11,&
!!$  5.319643e-11,&
!!$  3.698623e-11,&
!!$  2.577495e-11,&
!!$  1.800499e-11,&
!!$  1.260828e-11,&
!!$  8.850481e-12 /)
!!$
!!$ ht1d = (/&
!!$  80000.,&
!!$  81941.95,&
!!$  83847.59,&
!!$  85704.52,&
!!$  87523.97,&
!!$  89312.34,&
!!$  91078.42,&
!!$  92833.18,&
!!$  94590.19,&
!!$  96365.86,&
!!$  98180.56,&
!!$  100060.2,&
!!$  102035.9,&
!!$  104136.3,&
!!$  106380.6,&
!!$  108784.8,&
!!$  111380.6,&
!!$  114235.8,&
!!$  117461.7,&
!!$  121213.8,&
!!$  125622.2,&
!!$  130716.4,&
!!$  136487.3,&
!!$  142925.3,&
!!$  150001.,&
!!$  157676.5,&
!!$  165910.4,&
!!$  174660.4,&
!!$  183888.6,&
!!$  193562.9,&
!!$  203657.5,&
!!$  214152.,&
!!$  225030.9,&
!!$  236280.4,&
!!$  247887.,&
!!$  259834.7,&
!!$  272104.6,&
!!$  284674.7,&
!!$  297521.2 /)
!!$
!!$ nd_gas1_1d = (/&
!!$  4.861659e+15,&
!!$  1.152597e+16,&
!!$  2.493227e+16,&
!!$  4.828812e+16,&
!!$  8.359943e+16,&
!!$  1.296523e+17,&
!!$  1.812032e+17,&
!!$  2.304428e+17,&
!!$  2.693408e+17,&
!!$  2.923169e+17,&
!!$  2.972838e+17,&
!!$  2.854326e+17,&
!!$  2.608753e+17,&
!!$  2.295358e+17,&
!!$  1.963896e+17,&
!!$  1.64007e+17,&
!!$  1.331471e+17,&
!!$  1.042893e+17,&
!!$  7.858824e+16,&
!!$  5.713501e+16,&
!!$  4.132112e+16,&
!!$  3.018037e+16,&
!!$  2.214845e+16,&
!!$  1.63638e+16,&
!!$  1.218708e+16,&
!!$  9.148275e+15,&
!!$  6.918339e+15,&
!!$  5.259803e+15,&
!!$  4.014361e+15,&
!!$  3.070145e+15,&
!!$  2.348877e+15,&
!!$  1.795085e+15,&
!!$  1.368696e+15,&
!!$  1.040237e+15,&
!!$  7.875621e+14,&
!!$  5.937195e+14,&
!!$  4.455658e+14,&
!!$  3.328368e+14,&
!!$  2.475352e+14 /)
!!$
!!$ nd_gas2_1d = (/&
!!$  8.22049e+19,&
!!$  5.92433e+19,&
!!$  4.33966e+19,&
!!$  3.16896e+19,&
!!$  2.304265e+19,&
!!$  1.666387e+19,&
!!$  1.196751e+19,&
!!$  8.517559e+18,&
!!$  5.995522e+18,&
!!$  4.164419e+18,&
!!$  2.846347e+18,&
!!$  1.908886e+18,&
!!$  1.254937e+18,&
!!$  8.126684e+17,&
!!$  5.20379e+17,&
!!$  3.288631e+17,&
!!$  2.03126e+17,&
!!$  1.211702e+17,&
!!$  6.949942e+16,&
!!$  3.849362e+16,&
!!$  2.136653e+16,&
!!$  1.217734e+16,&
!!$  7.104841e+15,&
!!$  4.233406e+15,&
!!$  2.56274e+15,&
!!$  1.567331e+15,&
!!$  9.646983e+14,&
!!$  5.948128e+14,&
!!$  3.665655e+14,&
!!$  2.252353e+14,&
!!$  1.377259e+14,&
!!$  8.362674e+13,&
!!$  5.03534e+13,&
!!$  3.00325e+13,&
!!$  1.772935e+13,&
!!$  1.035356e+13,&
!!$  5.978726e+12,&
!!$  3.412867e+12,&
!!$  1.923541e+12 /)
!!$
!!$ nd_gas3_1d = (/&
!!$  3.092614e+20,&
!!$  2.23502e+20,&
!!$  1.642983e+20,&
!!$  1.205112e+20,&
!!$  8.811772e+19,&
!!$  6.416838e+19,&
!!$  4.648187e+19,&
!!$  3.34357e+19,&
!!$  2.384595e+19,&
!!$  1.683319e+19,&
!!$  1.173743e+19,&
!!$  8.068011e+18,&
!!$  5.467964e+18,&
!!$  3.676379e+18,&
!!$  2.464759e+18,&
!!$  1.646296e+18,&
!!$  1.085706e+18,&
!!$  6.987474e+17,&
!!$  4.36701e+17,&
!!$  2.654911e+17,&
!!$  1.6171e+17,&
!!$  1.002934e+17,&
!!$  6.298899e+16,&
!!$  4.002272e+16,&
!!$  2.568998e+16,&
!!$  1.662057e+16,&
!!$  1.081229e+16,&
!!$  7.05725e+15,&
!!$  4.609212e+15,&
!!$  3.005421e+15,&
!!$  1.952507e+15,&
!!$  1.261624e+15,&
!!$  8.096038e+14,&
!!$  5.15368e+14,&
!!$  3.251764e+14,&
!!$  2.032487e+14,&
!!$  1.257969e+14,&
!!$  7.707727e+13,&
!!$  4.670298e+13 /)
!!$
!!$ nden1d = (/&
!!$  3.914711e+20,&
!!$  2.827568e+20,&
!!$  2.077198e+20,&
!!$  1.52249e+20,&
!!$  1.112439e+20,&
!!$  8.096187e+19,&
!!$  5.863056e+19,&
!!$  4.21837e+19,&
!!$  3.011081e+19,&
!!$  2.128992e+19,&
!!$  1.488106e+19,&
!!$  1.026233e+19,&
!!$  6.983776e+18,&
!!$  4.718583e+18,&
!!$  3.181528e+18,&
!!$  2.139167e+18,&
!!$  1.421979e+18,&
!!$  9.24207e+17,&
!!$  5.847887e+17,&
!!$  3.611197e+17,&
!!$  2.243976e+17,&
!!$  1.426511e+17,&
!!$  9.224228e+16,&
!!$  6.061992e+16,&
!!$  4.04398e+16,&
!!$  2.733617e+16,&
!!$  1.869533e+16,&
!!$  1.291187e+16,&
!!$  8.990138e+15,&
!!$  6.300801e+15,&
!!$  4.43911e+15,&
!!$  3.140336e+15,&
!!$  2.228654e+15,&
!!$  1.585637e+15,&
!!$  1.130468e+15,&
!!$  8.073218e+14,&
!!$  5.773415e+14,&
!!$  4.133269e+14,&
!!$  2.961617e+14 /)
!!$
!!$ scht1d = (/&
!!$  5825.836,&
!!$  5779.81,&
!!$  5638.121,&
!!$  5512.838,&
!!$  5407.89,&
!!$  5327.11,&
!!$  5275.405,&
!!$  5260.576,&
!!$  5290.443,&
!!$  5374.755,&
!!$  5527.604,&
!!$  5766.548,&
!!$  6101.665,&
!!$  6508.933,&
!!$  6964.542,&
!!$  7480.546,&
!!$  8136.033,&
!!$  9061.168,&
!!$  10378.49,&
!!$  12194.57,&
!!$  14253.21,&
!!$  16294.83,&
!!$  18323.28,&
!!$  20286.57,&
!!$  22146.01,&
!!$  23885.55,&
!!$  25496.51,&
!!$  26985.53,&
!!$  28368.97,&
!!$  29665.44,&
!!$  30893.07,&
!!$  32067.55,&
!!$  33199.22,&
!!$  34291.34,&
!!$  35339.64,&
!!$  36336.2,&
!!$  37271.73,&
!!$  38137.45,&
!!$  38929.24 /)
!!$
!!$ temp1d = (/&
!!$  191.9732,&
!!$  190.441,&
!!$  185.7508,&
!!$  181.5893,&
!!$  178.0745,&
!!$  175.3195,&
!!$  173.468,&
!!$  172.7557,&
!!$  173.4157,&
!!$  175.7391,&
!!$  180.1527,&
!!$  187.1815,&
!!$  197.0767,&
!!$  208.9836,&
!!$  222.0775,&
!!$  236.6743,&
!!$  255.1482,&
!!$  281.3191,&
!!$  318.5923,&
!!$  369.6114,&
!!$  426.1123,&
!!$  480.2786,&
!!$  532.1367,&
!!$  580.124,&
!!$  623.0451,&
!!$  660.4068,&
!!$  691.8877,&
!!$  717.781,&
!!$  738.6246,&
!!$  755.0981,&
!!$  767.9188,&
!!$  777.7681,&
!!$  785.2261,&
!!$  790.7325,&
!!$  794.6116,&
!!$  797.1552,&
!!$  798.6318,&
!!$  799.2791,&
!!$  799.2791 /)
!!$
!!$ gas_H2O_1d = (/&
!!$  5.522515e-06,&
!!$  5.080714e-06,&
!!$  4.674257e-06,&
!!$  4.300316e-06,&
!!$  3.956291e-06,&
!!$  3.639788e-06,&
!!$  3.348605e-06,&
!!$  3.080717e-06,&
!!$  2.834259e-06,&
!!$  2.607519e-06,&
!!$  2.398917e-06,&
!!$  2.207004e-06,&
!!$  1.784968e-06,&
!!$  1.441835e-06,&
!!$  1.162958e-06,&
!!$  9.364312e-07,&
!!$  7.525588e-07,&
!!$  6.03442e-07,&
!!$  4.826502e-07,&
!!$  3.849503e-07,&
!!$  3.060823e-07,&
!!$  2.425772e-07,&
!!$  1.915881e-07,&
!!$  1.507664e-07,&
!!$  1.181786e-07,&
!!$  9.224063e-08,&
!!$  7.166025e-08,&
!!$  5.538897e-08,&
!!$  4.257543e-08,&
!!$  3.253019e-08,&
!!$  2.46954e-08,&
!!$  1.861979e-08,&
!!$  1.393857e-08,&
!!$  1.035717e-08,&
!!$  7.638127e-09,&
!!$  5.59056e-09,&
!!$  4.061681e-09,&
!!$  2.92992e-09,&
!!$  2.099234e-09 /)
!!$
!!$ gas_H2O2_1d = (/ &
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0,&
!!$  0 /)
!!$
!!$ gas_O3_1d = (/ &
!!$  1.087059e-07,&
!!$  1.872413e-07,&
!!$  3.091965e-07,&
!!$  3.895738e-07,&
!!$  3.920347e-07,&
!!$  3.231847e-07,&
!!$  2.381083e-07,&
!!$  1.698136e-07,&
!!$  1.214717e-07,&
!!$  8.874146e-08,&
!!$  6.68589e-08,&
!!$  6.68589e-09,&
!!$  6.68589e-10,&
!!$  6.68589e-11,&
!!$  6.685891e-12,&
!!$  6.68589e-13,&
!!$  6.685891e-14,&
!!$  6.685891e-15,&
!!$  6.685891e-16,&
!!$  6.685891e-17,&
!!$  6.685891e-18,&
!!$  6.685891e-19,&
!!$  6.685892e-20,&
!!$  6.685891e-21,&
!!$  6.685891e-22,&
!!$  6.685892e-23,&
!!$  6.685891e-24,&
!!$  6.685892e-25,&
!!$  6.685892e-26,&
!!$  6.685892e-27,&
!!$  6.685892e-28,&
!!$  6.685892e-29,&
!!$  6.685892e-30,&
!!$  6.685892e-31,&
!!$  6.685892e-32,&
!!$  6.685892e-33,&
!!$  6.685893e-34,&
!!$  6.685893e-35,&
!!$  6.685892e-36 /)


     nlev = 72

     CALL allocate_arrays

! cmat/util/extract.tcsh
     jpress = 100.*(/&
  0.10000E+03 ,&
  0.71653E+02 ,&
  0.51342E+02 ,&
  0.36788E+02 ,&
  0.26360E+02 ,&
  0.18888E+02 ,&
  0.13534E+02 ,&
  0.96972E+01 ,&
  0.69483E+01 ,&
  0.49787E+01 ,&
  0.35674E+01 ,&
  0.25562E+01 ,&
  0.18316E+01 ,&
  0.13124E+01 ,&
  0.94036E+00 ,&
  0.67379E+00 ,&
  0.48279E+00 ,&
  0.34594E+00 ,&
  0.24788E+00 ,&
  0.17761E+00 ,&
  0.12726E+00 ,&
  0.91188E-01 ,&
  0.65339E-01 ,&
  0.46818E-01 ,&
  0.33546E-01 ,&
  0.24037E-01 ,&
  0.17223E-01 ,&
  0.12341E-01 ,&
  0.88427E-02 ,&
  0.63361E-02 ,&
  0.45400E-02 ,&
  0.32530E-02 ,&
  0.23309E-02 ,&
  0.16702E-02 ,&
  0.11967E-02 ,&
  0.85749E-03 ,&
  0.61442E-03 ,&
  0.44025E-03 ,&
  0.31545E-03 ,&
  0.22603E-03 ,&
  0.16196E-03 ,&
  0.11605E-03 ,&
  0.83153E-04 ,&
  0.59582E-04 ,&
  0.42692E-04 ,&
  0.30590E-04 ,&
  0.21919E-04 ,&
  0.15706E-04 ,&
  0.11254E-04 ,&
  0.80635E-05 ,&
  0.57777E-05 ,&
  0.41399E-05 ,&
  0.29664E-05 ,&
  0.21255E-05 ,&
  0.15230E-05 ,&
  0.10913E-05 ,&
  0.78193E-06 ,&
  0.56028E-06 ,&
  0.40146E-06 ,&
  0.28766E-06 ,&
  0.20612E-06 ,&
  0.14769E-06 ,&
  0.10582E-06 ,&
  0.75826E-07 ,&
  0.54331E-07 ,&
  0.38930E-07 ,&
  0.27895E-07 ,&
  0.19987E-07 ,&
  0.14322E-07 ,&
  0.10262E-07 ,&
  0.73530E-08 ,&
  0.52686E-08 /)

 den1d = (/ &
  0.1651493,&
  0.1176437,&
  0.08364272,&
  0.05936073,&
  0.04204764,&
  0.0297189,&
  0.02094506,&
  0.01470308,&
  0.01027541,&
  0.007157734,&
  0.004979551,&
  0.003471442,&
  0.00243319,&
  0.001719688,&
  0.001226909,&
  0.0008831597,&
  0.0006406013,&
  0.0004676829,&
  0.0003431273,&
  0.0002526111,&
  0.0001863202,&
  0.000137432,&
  0.0001012222,&
  7.440742e-05,&
  5.467866e-05,&
  4.010852e-05,&
  2.940547e-05,&
  2.160562e-05,&
  1.589164e-05,&
  1.168259e-05,&
  8.572836e-06,&
  6.273203e-06,&
  4.573483e-06,&
  3.318713e-06,&
  2.393713e-06,&
  1.713258e-06,&
  1.214994e-06,&
  8.521618e-07,&
  5.898242e-07,&
  4.023164e-07,&
  2.712232e-07,&
  1.819132e-07,&
  1.216694e-07,&
  8.078545e-08,&
  5.26512e-08,&
  3.342509e-08,&
  2.062642e-08,&
  1.25294e-08,&
  7.782582e-09,&
  4.917916e-09,&
  3.157702e-09,&
  2.057845e-09,&
  1.358822e-09,&
  9.075182e-10,&
  6.118366e-10,&
  4.15656e-10,&
  2.840835e-10,&
  1.950733e-10,&
  1.344436e-10,&
  9.292701e-11,&
  6.438643e-11,&
  4.470889e-11,&
  3.110963e-11,&
  2.169128e-11,&
  1.515612e-11,&
  1.061218e-11,&
  7.448247e-12,&
  5.239938e-12,&
  3.694871e-12,&
  2.611113e-12,&
  1.849448e-12,&
  1.312219e-12 /)

 ht1d = (/ &
  15525.0,&
  17649.61,&
  19794.68,&
  21958.46,&
  24145.13,&
  26359.41,&
  28607.2,&
  30896.89,&
  33239.43,&
  35645.59,&
  38122.93,&
  40672.65,&
  43286.88,&
  45948.59,&
  48634.27,&
  51319.2,&
  53981.33,&
  56602.28,&
  59167.97,&
  61669.1,&
  64100.79,&
  66462.71,&
  68758.68,&
  70994.73,&
  73174.72,&
  75302.13,&
  77381.32,&
  79411.29,&
  81389.42,&
  83316.72,&
  85196.77,&
  87034.99,&
  88838.17,&
  90614.35,&
  92373.28,&
  94127.13,&
  95890.8,&
  97682.34,&
  99524.5,&
  101445.9,&
  103477.6,&
  105643.6,&
  107960.3,&
  110448.6,&
  113156.2,&
  116171.6,&
  119627.2,&
  123686.4,&
  128427.3,&
  133842.8,&
  139934.2,&
  146680.2,&
  154047.2,&
  161994.3,&
  170478.9,&
  179460.8,&
  188904.9,&
  198782.2,&
  209069.8,&
  219749.8,&
  230807.9,&
  242231.3,&
  254007.0,&
  266120.9,&
  278556.8,&
  291296.6,&
  304318.5,&
  317596.9,&
  331105.3,&
  344817.0,&
  358703.9,&
  372739.4 /)

 nd_gas1_1d = (/ &
  5.151444e+18,&
  5.297277e+18,&
  5.106808e+18,&
  4.728584e+18,&
  4.053001e+18,&
  3.265724e+18,&
  2.563677e+18,&
  1.983028e+18,&
  1.42674e+18,&
  9.319405e+17,&
  5.680255e+17,&
  3.168433e+17,&
  1.69786e+17,&
  9.227437e+16,&
  5.209686e+16,&
  3.036534e+16,&
  1.830383e+16,&
  1.218093e+16,&
  5.984528e+15,&
  3.231259e+15,&
  1.726845e+15,&
  8.853023e+14,&
  4.532885e+14,&
  2.572958e+14,&
  2.099141e+14,&
  3.750166e+14,&
  1.043233e+15,&
  2.914392e+15,&
  7.410615e+15,&
  1.695227e+16,&
  3.479507e+16,&
  6.389732e+16,&
  1.049053e+17,&
  1.546506e+17,&
  2.062713e+17,&
  2.515186e+17,&
  2.832897e+17,&
  2.976376e+17,&
  2.941233e+17,&
  2.754596e+17,&
  2.468614e+17,&
  2.14124e+17,&
  1.810678e+17,&
  1.492801e+17,&
  1.191811e+17,&
  9.164203e+16,&
  6.77896e+16,&
  4.884945e+16,&
  3.559804e+16,&
  2.605853e+16,&
  1.918203e+16,&
  1.422553e+16,&
  1.063538e+16,&
  8.01346e+15,&
  6.078012e+15,&
  4.630939e+15,&
  3.538878e+15,&
  2.70762e+15,&
  2.070791e+15,&
  1.580991e+15,&
  1.203656e+15,&
  9.130318e+14,&
  6.89615e+14,&
  5.184126e+14,&
  3.877921e+14,&
  2.886966e+14,&
  2.138558e+14,&
  1.576969e+14,&
  1.158055e+14,&
  8.471849e+13,&
  6.177927e+13,&
  4.490967e+13 /)

 nd_gas2_1d = (/ &
  7.292796e+23,&
  5.195004e+23,&
  3.693563e+23,&
  2.621299e+23,&
  1.856774e+23,&
  1.312351e+23,&
  9.249086e+22,&
  6.492703e+22,&
  4.537496e+22,&
  3.16077e+22,&
  2.19891e+22,&
  1.532947e+22,&
  1.074468e+22,&
  7.593935e+21,&
  5.417885e+21,&
  3.899928e+21,&
  2.828819e+21,&
  2.065232e+21,&
  1.515209e+21,&
  1.115365e+21,&
  8.223791e+20,&
  6.063176e+20,&
  4.463447e+20,&
  3.279277e+20,&
  2.408247e+20,&
  1.764978e+20,&
  1.292506e+20,&
  9.482595e+19,&
  6.961529e+19,&
  5.10531e+19,&
  3.734754e+19,&
  2.722084e+19,&
  1.974431e+19,&
  1.423352e+19,&
  1.018033e+19,&
  7.208657e+18,&
  5.043195e+18,&
  3.477224e+18,&
  2.355922e+18,&
  1.564881e+18,&
  1.020864e+18,&
  6.575798e+17,&
  4.186958e+17,&
  2.620601e+17,&
  1.5926e+17,&
  9.321898e+16,&
  5.247242e+16,&
  2.886474e+16,&
  1.625606e+16,&
  9.369329e+15,&
  5.52415e+15,&
  3.318471e+15,&
  2.019693e+15,&
  1.239332e+15,&
  7.638331e+14,&
  4.709564e+14,&
  2.898645e+14,&
  1.777061e+14,&
  1.082976e+14,&
  6.548543e+13,&
  3.924271e+13,&
  2.32823e+13,&
  1.366487e+13,&
  7.929451e+12,&
  4.547638e+12,&
  2.5751e+12,&
  1.441977e+12,&
  7.982667e+11,&
  4.367228e+11,&
  2.361881e+11,&
  1.263238e+11,&
  6.679397e+10 /)

 nd_gas3_1d = (/ &
  2.718454e+24,&
  1.936483e+24,&
  1.376808e+24,&
  9.771122e+23,&
  6.921287e+23,&
  4.891904e+23,&
  3.447678e+23,&
  2.420212e+23,&
  1.691392e+23,&
  1.178205e+23,&
  8.196631e+22,&
  5.714196e+22,&
  4.005173e+22,&
  2.830706e+22,&
  2.019564e+22,&
  1.453732e+22,&
  1.054467e+22,&
  7.698333e+21,&
  5.648076e+21,&
  4.158281e+21,&
  3.067384e+21,&
  2.262858e+21,&
  1.666909e+21,&
  1.225529e+21,&
  9.007624e+20,&
  6.609142e+20,&
  4.847168e+20,&
  3.563045e+20,&
  2.622217e+20,&
  1.92905e+20,&
  1.416759e+20,&
  1.037737e+20,&
  7.573846e+19,&
  5.502135e+19,&
  3.972978e+19,&
  2.846538e+19,&
  2.020572e+19,&
  1.418365e+19,&
  9.824975e+18,&
  6.706901e+18,&
  4.525515e+18,&
  3.038586e+18,&
  2.034803e+18,&
  1.352677e+18,&
  8.822706e+17,&
  5.599808e+17,&
  3.449133e+17,&
  2.085714e+17,&
  1.284623e+17,&
  8.017272e+16,&
  5.063917e+16,&
  3.233727e+16,&
  2.083903e+16,&
  1.352277e+16,&
  8.812854e+15,&
  5.755153e+15,&
  3.756379e+15,&
  2.445197e+15,&
  1.584441e+15,&
  1.020345e+15,&
  6.521266e+14,&
  4.132269e+14,&
  2.594015e+14,&
  1.61223e+14,&
  9.917442e+13,&
  6.032705e+13,&
  3.634041e+13,&
  2.167211e+13,&
  1.279304e+13,&
  7.477503e+12,&
  4.329837e+12,&
  2.483292e+12 /)

 nden1d = (/ &
  3.447734e+24,&
  2.455984e+24,&
  1.746164e+24,&
  1.239242e+24,&
  8.77806e+23,&
  6.204255e+23,&
  4.372587e+23,&
  3.069483e+23,&
  2.145141e+23,&
  1.494282e+23,&
  1.039554e+23,&
  7.247143e+22,&
  5.079641e+22,&
  3.5901e+22,&
  2.561353e+22,&
  1.843725e+22,&
  1.337349e+22,&
  9.763565e+21,&
  7.163285e+21,&
  5.273646e+21,&
  3.889763e+21,&
  2.869176e+21,&
  2.113253e+21,&
  1.553456e+21,&
  1.141587e+21,&
  8.374123e+20,&
  6.139684e+20,&
  4.511333e+20,&
  3.318443e+20,&
  2.439749e+20,&
  1.790581e+20,&
  1.310583e+20,&
  9.55876e+19,&
  6.940948e+19,&
  5.011636e+19,&
  3.592555e+19,&
  2.55322e+19,&
  1.795852e+19,&
  1.247502e+19,&
  8.547242e+18,&
  5.79324e+18,&
  3.910289e+18,&
  2.634567e+18,&
  1.764017e+18,&
  1.160712e+18,&
  7.448418e+17,&
  4.651753e+17,&
  2.862856e+17,&
  1.803164e+17,&
  1.156006e+17,&
  7.534536e+16,&
  4.988128e+16,&
  3.34941e+16,&
  2.277556e+16,&
  1.56547e+16,&
  1.085705e+16,&
  7.585122e+15,&
  5.330523e+15,&
  3.76353e+15,&
  2.666822e+15,&
  1.895025e+15,&
  1.349541e+15,&
  9.626814e+14,&
  6.875651e+14,&
  4.915141e+14,&
  3.515987e+14,&
  2.516382e+14,&
  1.801673e+14,&
  1.290352e+14,&
  9.243218e+13,&
  6.623543e+13,&
  4.745976e+13 /)

 scht1d = (/ &
  6373.817,&
  6411.254,&
  6461.282,&
  6523.552,&
  6598.983,&
  6689.928,&
  6801.553,&
  6942.517,&
  7118.066,&
  7321.861,&
  7541.246,&
  7751.037,&
  7923.737,&
  8033.278,&
  8067.996,&
  8031.082,&
  7933.415,&
  7786.297,&
  7604.335,&
  7401.134,&
  7189.936,&
  6984.439,&
  6794.828,&
  6623.279,&
  6458.125,&
  6308.449,&
  6165.466,&
  6012.593,&
  5857.261,&
  5708.983,&
  5574.527,&
  5458.573,&
  5364.865,&
  5297.533,&
  5262.697,&
  5268.583,&
  5323.297,&
  5438.414,&
  5629.991,&
  5914.35,&
  6286.647,&
  6716.615,&
  7195.557,&
  7764.274,&
  8535.143,&
  9632.668,&
  11184.63,&
  13197.88,&
  15224.79,&
  17265.05,&
  19268.72,&
  21187.43,&
  22992.25,&
  24668.57,&
  26219.36,&
  27655.73,&
  28995.81,&
  30258.19,&
  31459.77,&
  32613.97,&
  33728.6,&
  34805.19,&
  35841.56,&
  36833.16,&
  37772.68,&
  38654.61,&
  39463.11,&
  40193.66,&
  40843.39,&
  41412.54,&
  41893.91,&
  42307.94 /)

 temp1d = (/ &
  210.077,&
  211.3111,&
  212.9599,&
  215.0116,&
  217.4977,&
  220.4951,&
  224.174,&
  228.8198,&
  234.6054,&
  241.3219,&
  248.5519,&
  255.4657,&
  261.157,&
  264.7667,&
  265.9106,&
  264.6939,&
  261.4753,&
  256.6268,&
  250.6302,&
  243.9326,&
  236.9697,&
  230.194,&
  223.9416,&
  218.2843,&
  212.8372,&
  207.8991,&
  203.18,&
  198.1332,&
  193.0025,&
  188.0994,&
  183.6427,&
  179.7787,&
  176.6186,&
  174.2827,&
  172.9533,&
  172.8781,&
  174.2972,&
  177.5593,&
  183.1503,&
  191.5394,&
  202.4873,&
  214.954,&
  228.6022,&
  244.6369,&
  266.4009,&
  297.4618,&
  341.2823,&
  397.3434,&
  452.0283,&
  505.2146,&
  555.4111,&
  601.1303,&
  641.4651,&
  675.9389,&
  704.6395,&
  728.0062,&
  746.6542,&
  761.2853,&
  772.6042,&
  781.2563,&
  787.7852,&
  792.6324,&
  796.1786,&
  798.7565,&
  800.6218,&
  801.9574,&
  802.892,&
  803.513,&
  803.8884,&
  804.1111,&
  804.0519,&
  804.0519 /)

 gas_H2O_1d = (/ &
  3.727722e-06,&
  4.187942e-06,&
  4.562569e-06,&
  4.869964e-06,&
  5.125758e-06,&
  5.342853e-06,&
  5.531424e-06,&
  5.698916e-06,&
  5.850046e-06,&
  5.986803e-06,&
  6.108447e-06,&
  6.211508e-06,&
  6.289791e-06,&
  6.334369e-06,&
  6.333589e-06,&
  6.273067e-06,&
  6.135693e-06,&
  5.901626e-06,&
  5.429496e-06,&
  4.995137e-06,&
  4.595526e-06,&
  4.227884e-06,&
  3.889653e-06,&
  3.578481e-06,&
  3.292203e-06,&
  3.028827e-06,&
  2.78652e-06,&
  2.563599e-06,&
  2.358511e-06,&
  2.16983e-06,&
  1.996244e-06,&
  1.836544e-06,&
  1.689621e-06,&
  1.554451e-06,&
  1.430095e-06,&
  1.315687e-06,&
  1.210433e-06,&
  1.113598e-06,&
  1.02451e-06,&
  8.290635e-07,&
  6.701368e-07,&
  5.409437e-07,&
  4.359698e-07,&
  3.507291e-07,&
  2.815663e-07,&
  2.255055e-07,&
  1.801241e-07,&
  1.434507e-07,&
  1.138803e-07,&
  9.01025e-08,&
  7.103788e-08,&
  5.579615e-08,&
  4.364609e-08,&
  3.399002e-08,&
  2.634134e-08,&
  2.030552e-08,&
  1.556255e-08,&
  1.185334e-08,&
  8.968343e-09,&
  6.738055e-09,&
  5.025516e-09,&
  3.720219e-09,&
  2.733184e-09,&
  1.993018e-09,&
  1.442729e-09,&
  1.037105e-09,&
  7.406856e-10,&
  5.258416e-10,&
  3.713149e-10,&
  2.609558e-10,&
  1.826416e-10,&
  1.2738e-10 /)

 gas_H2O2_1d = (/ &
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0,&
  0 /)

 gas_O3_1d = (/ &
  1.494154e-06,&
  2.156886e-06,&
  2.924586e-06,&
  3.815706e-06,&
  4.617194e-06,&
  5.263685e-06,&
  5.863066e-06,&
  6.460462e-06,&
  6.651031e-06,&
  6.236712e-06,&
  5.464125e-06,&
  4.371975e-06,&
  3.34248e-06,&
  2.570245e-06,&
  2.033959e-06,&
  1.646956e-06,&
  1.368665e-06,&
  1.24759e-06,&
  8.354446e-07,&
  6.127183e-07,&
  4.43946e-07,&
  3.085563e-07,&
  2.144979e-07,&
  1.584249e-07,&
  1.251802e-07,&
  1.137199e-07,&
  1.351876e-07,&
  2.033035e-07,&
  3.329134e-07,&
  5.156107e-07,&
  7.021643e-07,&
  8.186177e-07,&
  7.263021e-07,&
  4.991279e-07,&
  2.842074e-07,&
  1.242234e-07,&
  1.416275e-08,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0,&
  0.0 /)

     ! ----------

      cp1d(:) = 1100.
     eccentric = 1.015
     f107 = 180. ! -> nml
     mmw_gas1 = 16.
     mmw_gas2 = 32.
     GRAV0 = 9.5
     l_reduceO3heating = .FALSE.
    r0_eff(:) = 6.370E06+ht1d(:)

   END SUBROUTINE photo_mtchem

    !-------------------------------------------------------------------------

  END SUBROUTINE radjimt_init

  ! --------------------------------------------------------------------------

  SUBROUTINE radjimt_physc

    USE caaba_mem,        ONLY: cossza, press, x_j_no2, photol_clev
    !mz_hr_20160420+ does not seem to be needed
                                !lyear, lmonth, lday, lhour, photol_clev, &
                                !photo_scenario
    !mz_hr_20160420-
    USE messy_main_tools, ONLY: nn_index, find_next_free_unit

    IMPLICIT NONE

    INTEGER :: status
    INTEGER :: iou1, iou2

    ! calculate pressure level in jpress according to current pressure
    CALL nn_index(jpress(:), press, photol_clev)

    IF (press > 1.1 * jpress(1)) THEN
      WRITE (*,*) 'Warning jval_physc: pressure more than 10% above '// &
        'highest standard atmosphere pressure'
    ENDIF
    IF (press < 0.9 * jpress(nlev)) THEN
      WRITE (*,*) 'Warning jval_physc: pressure more than 10% below '// &
        'lowest standard atmosphere pressure'
    ENDIF


    CALL MesoSol(1,1,nlev, heatrates,                             &
       nd_gas1_1d, nd_gas2_1d, nd_gas3_1d, gas_O3_1d, gas_H2O_1d, gas_H2O2_1d, &
       nden1d, cossza,                               &
       r0_eff, scht1d, temp1d, ht1d, cp1d, den1d, eccentric,                  &
       f107, jpress, mmw_gas1, mmw_gas2, GRAV0,l_reduceO3heating)

    iou1 = find_next_free_unit(100,150)
    iou2 = find_next_free_unit(151,200)

    CALL ThermoSol(1,1,nlev, nd_gas1_1d,nd_gas2_1d, nd_gas3_1d, gas_O3_1d,    &
       F107,cossza, ht1d, heatrates,temp1d,                                &
       eccentric, cp1d, scht1d, jpress, den1d, R0_eff,                       &
       nden1d, GRAV0, iou1, iou2)
    !-------------------------------------------------------------------------

  END SUBROUTINE radjimt_physc

  ! --------------------------------------------------------------------------

  SUBROUTINE radjimt_finish

    IMPLICIT NONE

    INTEGER :: ip


    DEALLOCATE(jpress)

    DEALLOCATE(heatrates)

    DEALLOCATE(O2eff_bulk, O3eff_bulk &
         , htlyeff, CSH2O2, euveff, src1eff, PEOP, PEN2, PEO2)
    DEALLOCATE(branch)

    CALL close_file(ncid_radjimt)

  END SUBROUTINE radjimt_finish

  ! --------------------------------------------------------------------------

  SUBROUTINE radjimt_result

    USE caaba_mem, ONLY: model_time, percent_done, photol_clev
    USE messy_main_constants_mem, ONLY: FLAGGED_BAD

    IMPLICIT NONE

    REAL(DP), DIMENSION(IP_MAX) :: radjimt_array
    INTEGER :: ip

    IF (percent_done > 0.) THEN
      ! The following loop is necessary because the component (after the
      ! "%") to the right of a part reference with nonzero rank cannot
      ! have the POINTER attribute. In other words, we cannot use
      ! "radjimt_gp(:)%ptr(1,photol_clev,1)"
      DO ip = 1, IP_MAX
        radjimt_array(ip) = jx(photol_clev,1,ip,1)
      ENDDO
      CALL write_output_file(ncid_radjimt, model_time, radjimt_array)
    ELSE
      ! photol_clev not defined in first call of radjimt_result (before radjimt_physc)
      CALL write_output_file(ncid_radjimt, model_time, &
        (/ (FLAGGED_BAD, ip=1,IP_MAX) /))
    ENDIF

  END SUBROUTINE radjimt_result

  ! --------------------------------------------------------------------------

END MODULE messy_radjimt_box

!*****************************************************************************
