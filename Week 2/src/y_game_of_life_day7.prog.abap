*&---------------------------------------------------------------------*
*& Report y_game_of_life_day7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_game_of_life_day7.

CLASS ycl_cell DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: ty_cell_status TYPE char1.

    METHODS:
      constructor IMPORTING iv_status         TYPE ty_cell_status
                            iv_sum_neighboors TYPE int1,
      get_status  RETURNING VALUE(rv_status) TYPE ty_cell_status,
      play,
      get_sum_neighboors RETURNING VALUE(rv_sum_neighboors) TYPE int1,
      add_neighboor_cell IMPORTING io_cell TYPE REF TO ycl_cell.

  PRIVATE SECTION.
    CONSTANTS: BEGIN OF ms_status,
                 alive TYPE ty_cell_status VALUE 'X',
                 dead  TYPE ty_cell_status VALUE '',
               END OF ms_status.
    DATA:
      mv_status         TYPE ycl_cell=>ty_cell_status,
      mv_sum_neighboors TYPE int1,
      mt_cells          TYPE STANDARD TABLE OF REF TO ycl_cell.

    METHODS:
      has_too_little_neighboors RETURNING VALUE(rv_has_too_little) TYPE abap_bool,
      let_cell_die,
      let_cell_arise,
      has_adequate_neighboors   RETURNING VALUE(rv_has_adequate) TYPE abap_bool,
      increase_sum_neighboors,
      register_cell_for_neighboors.

ENDCLASS.

CLASS ycl_cell IMPLEMENTATION.

  METHOD constructor.
    mv_status = iv_status.
    mv_sum_neighboors = iv_sum_neighboors.
  ENDMETHOD.

  METHOD get_status.
    rv_status = mv_status.
  ENDMETHOD.

  METHOD play.
    IF has_too_little_neighboors( ).
      let_cell_die( ).

    ENDIF.
    IF has_adequate_neighboors( ).
      let_cell_arise( ).
      register_cell_for_neighboors( ).
    ENDIF.
  ENDMETHOD.

  METHOD register_cell_for_neighboors.
    LOOP AT mt_cells INTO DATA(lo_cell).
      lo_cell->increase_sum_neighboors( ).
    ENDLOOP.
  ENDMETHOD.

  METHOD has_adequate_neighboors.
    rv_has_adequate = xsdbool( mv_sum_neighboors BETWEEN 2 AND 3 ).
  ENDMETHOD.

  METHOD let_cell_arise.
    mv_status = ms_status-alive.
  ENDMETHOD.

  METHOD let_cell_die.
    mv_status = ms_status-dead.
  ENDMETHOD.

  METHOD has_too_little_neighboors.
    rv_has_too_little = xsdbool( mv_sum_neighboors = 1 ).
  ENDMETHOD.

  METHOD get_sum_neighboors.
    rv_sum_neighboors = mv_sum_neighboors.
  ENDMETHOD.

  METHOD add_neighboor_cell.
    APPEND io_cell TO mt_cells.
  ENDMETHOD.

  METHOD increase_sum_neighboors.
    mv_sum_neighboors = mv_sum_neighboors + 1.
  ENDMETHOD.

ENDCLASS.

CLASS ycl_game_of_life DEFINITION FINAL.
  PUBLIC SECTION.
    TYPES: tt_cells TYPE STANDARD TABLE OF REF TO ycl_cell WITH DEFAULT KEY.

    METHODS play_round.
    METHODS add_cell
      IMPORTING
        io_cell TYPE REF TO ycl_cell.
    METHODS get_cells
      RETURNING
        VALUE(rt_cells) TYPE tt_cells.

  PRIVATE SECTION.
    DATA:
      mt_cells TYPE STANDARD TABLE OF REF TO ycl_cell.

ENDCLASS.

CLASS ycl_game_of_life IMPLEMENTATION.

  METHOD play_round.
    LOOP AT mt_cells INTO DATA(lo_cell).
      lo_cell->play( ).
    ENDLOOP.
  ENDMETHOD.

  METHOD add_cell.
    APPEND io_cell TO mt_cells.
  ENDMETHOD.

  METHOD get_cells.
    rt_cells = mt_cells.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_game_of_life DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      cell_b1_dies                  FOR TESTING,
      cell_a2_arises                FOR TESTING,
      cell_a2_gets_neighboor_of_b2  FOR TESTING.
ENDCLASS.

CLASS ltcl_game_of_life IMPLEMENTATION.

  METHOD cell_b1_dies.
    DATA(lo_cell_b1) = NEW ycl_cell( iv_status = 'X' iv_sum_neighboors = 1 ).
    DATA(lo_game_of_life) = NEW ycl_game_of_life( ).
    lo_game_of_life->add_cell( lo_cell_b1 ).
    lo_game_of_life->play_round( ).
    cl_abap_unit_assert=>assert_equals( exp = ''
                                        act = lo_cell_b1->get_status( ) ).
  ENDMETHOD.

  METHOD cell_a2_arises.
    DATA(lo_cell_a2) = NEW ycl_cell( iv_status = '' iv_sum_neighboors = 3 ).
    DATA(lo_game_of_life) = NEW ycl_game_of_life( ).
    lo_game_of_life->add_cell( lo_cell_a2 ).
    lo_game_of_life->play_round( ).
    cl_abap_unit_assert=>assert_equals( exp = 'X'
                                        act = lo_cell_a2->get_status( ) ).
  ENDMETHOD.

  METHOD cell_a2_gets_neighboor_of_b2.
    DATA(lo_cell_a2) = NEW ycl_cell( iv_status = ''  iv_sum_neighboors = 3 ).
    DATA(lo_cell_b1) = NEW ycl_cell( iv_status = 'X' iv_sum_neighboors = 1 ).
    lo_cell_a2->add_neighboor_cell( lo_cell_b1 ).
    DATA(lo_game_of_life) = NEW ycl_game_of_life( ).
    lo_game_of_life->add_cell( lo_cell_a2 ).
    lo_game_of_life->add_cell( lo_cell_b1 ).
    lo_game_of_life->play_round( ).
    cl_abap_unit_assert=>assert_equals( exp = 2
                                        act = lo_cell_b1->get_sum_neighboors( ) ).
  ENDMETHOD.

ENDCLASS.
