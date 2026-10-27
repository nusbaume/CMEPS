module test_flux_large

  ! Tests of flux_atmOcn_large (Large and Pond / Large and Yeager bulk scheme)

  use funit
  use shr_kind_mod,          only : r8 => shr_kind_r8
  use shr_const_mod,         only : shr_const_latvap
  use flux_atmOcn_large_mod, only : flux_atmOcn_large
  use flux_test_fixtures

  implicit none

  integer, parameter :: logunit = 6

contains

  !@before
  subroutine setUp()
    call fixture_init()
  end subroutine setUp

  !@after
  subroutine tearDown()
    call fixture_reset()
  end subroutine tearDown

  !@test
  subroutine test_unstable_fluxes_are_upward()
    ! Warm ocean under cooler, drier air: heat and moisture leave the ocean, so
    ! sen, lat and evap are negative (fluxes are positive downward), and the wind
    ! stress points along the wind.
    integer, parameter :: nMax = 1
    type(flux_inputs_t) :: s
    real(r8), dimension(nMax) :: sen, lat, lwup, evap, taux, tauy, tref, qref
    real(r8), dimension(nMax) :: duu10n, ugust_out, u10res

    s = make_unstable_state(nMax)

    call flux_atmOcn_large(logunit=logunit, spval=test_spval, nMax=nMax, &
         zbot=s%zbot, ubot=s%ubot, vbot=s%vbot, thbot=s%thbot, &
         qbot=s%qbot, rainc=s%rainc, rbot=s%rbot, &
         tbot=s%tbot, us=s%us, vs=s%vs, pslv=s%pslv, &
         ts=s%ts, mask=s%mask, seq_flux_atmocn_minwind=test_minwind, &
         sen=sen, lat=lat, lwup=lwup, evap=evap, &
         taux=taux, tauy=tauy, tref=tref, qref=qref, &
         add_gusts=.false., aofluxes_use_shr_wv_sat=.true., &
         duu10n=duu10n, ugust_out=ugust_out, u10res=u10res)

#line 49 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"
  call assertLessThan(sen(1), 0.0_r8, &
 & location=SourceLocation( &
 & 'test_flux_large.pf', &
 & 49) )
  if (anyExceptions()) return
#line 50 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"
#line 50 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"
  call assertLessThan(lat(1), 0.0_r8, &
 & location=SourceLocation( &
 & 'test_flux_large.pf', &
 & 50) )
  if (anyExceptions()) return
#line 51 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"
#line 51 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"
  call assertLessThan(evap(1), 0.0_r8, &
 & location=SourceLocation( &
 & 'test_flux_large.pf', &
 & 51) )
  if (anyExceptions()) return
#line 52 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"
#line 52 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"
  call assertEqual(lat(1)/shr_const_latvap, evap(1), tolerance=tol_exact*abs(evap(1)), &
 & location=SourceLocation( &
 & 'test_flux_large.pf', &
 & 52) )
  if (anyExceptions()) return
#line 53 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"
#line 53 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"
  call assertGreaterThan(taux(1), 0.0_r8, &
 & location=SourceLocation( &
 & 'test_flux_large.pf', &
 & 53) )
  if (anyExceptions()) return
#line 54 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"
#line 54 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"
  call assertGreaterThan(tauy(1), 0.0_r8, &
 & location=SourceLocation( &
 & 'test_flux_large.pf', &
 & 54) )
  if (anyExceptions()) return
#line 55 "/glade/work/nusbaume/SE_projects/water_isotopes/CMEPS/cesm/flux_atmocn/test/bulk/test_flux_large.pf"

  end subroutine test_unstable_fluxes_are_upward

end module test_flux_large

module Wraptest_flux_large
   use FUnit
   use test_flux_large
   implicit none
   private

contains


end module Wraptest_flux_large

function test_flux_large_suite() result(suite)
   use FUnit
   use test_flux_large
   use Wraptest_flux_large
   implicit none
   type (TestSuite) :: suite

   class (Test), allocatable :: t

   suite = TestSuite('test_flux_large_suite')

   if(allocated(t)) deallocate(t)
   allocate(t, source=TestMethod('test_unstable_fluxes_are_upward', &
      test_unstable_fluxes_are_upward, setUp=setUp, tearDown=tearDown))
   call suite%addTest(t)


end function test_flux_large_suite

