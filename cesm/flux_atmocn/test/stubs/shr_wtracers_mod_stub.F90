module shr_wtracers_mod

  !-----------------------------------------------------------------------------
  ! Unit-test stub for CESM_share's shr_wtracers_mod.
  !
  ! The real module depends on ESMF and NUOPC. This stub only provides
  ! shr_wtracers_get_species_type, which is all the flux schemes need, plus two
  ! test-only routines to set and clear the species type of each tracer.
  !
  ! The WATER_SPECIES_TYPE_* constants are not duplicated here; they come from
  ! the real (dependency-free) shr_water_species_mod.
  !-----------------------------------------------------------------------------

  use shr_sys_mod, only : shr_sys_abort

  implicit none
  private

  public :: shr_wtracers_get_species_type ! same interface as the real one
  public :: stub_wtracers_set_species     ! test-only: set the species type of each tracer
  public :: stub_wtracers_reset           ! test-only: clear the stub's state

  integer, allocatable :: species_types(:)

contains

  !-----------------------------------------------------------------------------
  subroutine stub_wtracers_set_species(types)
    ! Set the species type (a WATER_SPECIES_TYPE_* value) of each tracer.
    ! Tracer n gets types(n).
    integer, intent(in) :: types(:)

    species_types = types

  end subroutine stub_wtracers_set_species

  !-----------------------------------------------------------------------------
  subroutine stub_wtracers_reset()
    ! Clear the species types, so tests cannot leak state into each other.

    if (allocated(species_types)) deallocate(species_types)

  end subroutine stub_wtracers_reset

  !-----------------------------------------------------------------------------
  function shr_wtracers_get_species_type(tracer_num)
    ! Same interface as the real shr_wtracers_get_species_type. Aborts (raising
    ! a pFUnit exception, via the shr_sys_mod stub) if the stub is not set up or
    ! the index is out of range, like the real module.
    integer, intent(in) :: tracer_num
    integer :: shr_wtracers_get_species_type

    character(len=*), parameter :: subname = 'shr_wtracers_get_species_type'
    character(len=128) :: msg

    shr_wtracers_get_species_type = -1

    if (.not. allocated(species_types)) then
       call shr_sys_abort(subname//' ERROR: water tracers not yet initialized'// &
            ' (call stub_wtracers_set_species first)')
       return
    end if
    if (tracer_num < 1 .or. tracer_num > size(species_types)) then
       write(msg, '(a,i0)') subname//' ERROR: tracer number out of range: ', tracer_num
       call shr_sys_abort(trim(msg))
       return
    end if

    shr_wtracers_get_species_type = species_types(tracer_num)

  end function shr_wtracers_get_species_type

end module shr_wtracers_mod
