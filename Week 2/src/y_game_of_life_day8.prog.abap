*&---------------------------------------------------------------------*
*& Report y_game_of_life_day8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_game_of_life_day8.

CLASS ycl_cell DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: ty_status     TYPE char1,
           tt_neighboors TYPE STANDARD TABLE OF REF TO ycl_cell WITH DEFAULT KEY.

    METHODS:
      set_neighboor IMPORTING io_neighboor TYPE REF TO ycl_cell,
      set_status    IMPORTING iv_status TYPE ty_status,
      get_neighboors RETURNING VALUE(rt_neighboors) TYPE tt_neighboors.

  PRIVATE SECTION.
    CONSTANTS:
      mc_alive TYPE string VALUE 'X' ##NO_TEXT.

    DATA:
      mt_neighboors TYPE STANDARD TABLE OF REF TO ycl_cell,
      mv_status     TYPE ycl_cell=>ty_status.

    METHODS:
      is_cell_arising   IMPORTING iv_status       TYPE ty_status
                        RETURNING VALUE(r_result) TYPE abap_bool,
      set_cell_status   IMPORTING iv_status TYPE ycl_cell=>ty_status,
      inform_neighboors IMPORTING iv_status TYPE ycl_cell=>ty_status,
      delete_neighboor  IMPORTING io_neighboor TYPE REF TO ycl_cell,
      add_me_as_neighboor.

ENDCLASS.

CLASS ycl_cell IMPLEMENTATION.

  METHOD set_neighboor.
    APPEND io_neighboor TO mt_neighboors.
  ENDMETHOD.

  METHOD set_status.
    set_cell_status( iv_status ).
    inform_neighboors( iv_status ).
  ENDMETHOD.

  METHOD inform_neighboors.
    CHECK mt_neighboors IS NOT INITIAL.
    IF is_cell_arising( iv_status ).
      add_me_as_neighboor( ).
    ELSE.
      LOOP AT mt_neighboors INTO DATA(lo_neighboor).
        lo_neighboor->delete_neighboor( me ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD add_me_as_neighboor.
    LOOP AT mt_neighboors INTO DATA(lo_neighboor).
      lo_neighboor->set_neighboor( me ).
    ENDLOOP.
  ENDMETHOD.

  METHOD set_cell_status.
    mv_status = iv_status.
  ENDMETHOD.

  METHOD is_cell_arising.
    r_result = boolc( iv_status = mc_alive ).
  ENDMETHOD.

  METHOD get_neighboors.
    rt_neighboors = mt_neighboors.
  ENDMETHOD.

  METHOD delete_neighboor.
    DELETE TABLE mt_neighboors FROM io_neighboor.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_game_of_life DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      a2_arise_b1_gets_new_neighboor FOR TESTING,
      a2_dying_b1_loose_neighboor FOR TESTING.
ENDCLASS.

CLASS ltcl_game_of_life IMPLEMENTATION.

  METHOD a2_arise_b1_gets_new_neighboor.
    DATA(lo_cell_a2) = NEW ycl_cell( ).
    DATA(lo_cell_b1) = NEW ycl_cell( ).
    DATA(lo_cell_c2) = NEW ycl_cell( ).
    lo_cell_a2->set_neighboor( lo_cell_b1 ).
    lo_cell_b1->set_neighboor( lo_cell_c2 ).
    lo_cell_a2->set_status( 'X' ).

    DATA(lt_neighboors) = lo_cell_b1->get_neighboors( ).

    cl_abap_unit_assert=>assert_equals( exp = lo_cell_a2
                                        act = lt_neighboors[ 2 ] ).
  ENDMETHOD.

  METHOD a2_dying_b1_loose_neighboor.
    DATA(lo_cell_a2) = NEW ycl_cell( ).
    DATA(lo_cell_b1) = NEW ycl_cell( ).
    " Starting Setup
    lo_cell_b1->set_neighboor( lo_cell_a2 ).
    lo_cell_a2->set_status( 'X' ).
    " Action
    lo_cell_a2->set_neighboor( lo_cell_b1 ).
    lo_cell_a2->set_status( '' ).

    cl_abap_unit_assert=>assert_initial( act = lo_cell_b1->get_neighboors( ) ).
  ENDMETHOD.

ENDCLASS.
