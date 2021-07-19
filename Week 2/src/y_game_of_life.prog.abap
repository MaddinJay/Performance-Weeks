*&---------------------------------------------------------------------*
*& Report y_game_of_life
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_game_of_life.

CLASS ycl_game_of_life DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_cell,
             status         TYPE char1,
             sum_neighboors TYPE int1,
           END OF ts_cell,
           tt_cell TYPE STANDARD TABLE OF ts_cell WITH DEFAULT KEY.

    METHODS: add_cell IMPORTING is_cell TYPE ycl_game_of_life=>ts_cell.
    METHODS get_cell
      RETURNING
        VALUE(rs_cell) TYPE ycl_game_of_life=>ts_cell.
    METHODS play.

  PRIVATE SECTION.
    DATA:
      ms_cell TYPE ycl_game_of_life=>ts_cell.
    METHODS let_cell_die.
    METHODS let_cell_arise.
    METHODS is_cell_alive RETURNING VALUE(rv_is_alive) TYPE abap_bool.
    METHODS has_not_enough_neighboors
      RETURNING
        VALUE(r_result) TYPE abap_bool.
    METHODS has_too_many_neighboors
      RETURNING
        VALUE(r_result) TYPE abap_bool.
    METHODS has_three_neighboors
      RETURNING
        VALUE(r_result) TYPE abap_bool.

ENDCLASS.

CLASS ycl_game_of_life IMPLEMENTATION.

  METHOD add_cell.
    ms_cell = is_cell.
  ENDMETHOD.

  METHOD get_cell.
    rs_cell = ms_cell.
  ENDMETHOD.

  METHOD play.
    IF is_cell_alive( ).
      IF has_not_enough_neighboors( ) OR
         has_too_many_neighboors( ).
        let_cell_die( ).
      ENDIF.
    ELSE.
      IF has_three_neighboors( ).
        let_cell_arise( ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD has_three_neighboors.
    r_result = boolc( ms_cell-sum_neighboors = 3 ).
  ENDMETHOD.

  METHOD has_too_many_neighboors.
    r_result = boolc( ms_cell-sum_neighboors = 4 ).
  ENDMETHOD.

  METHOD has_not_enough_neighboors.
    r_result = boolc( ms_cell-sum_neighboors = 1 ).
  ENDMETHOD.

  METHOD is_cell_alive.
    rv_is_alive = boolc( ms_cell-status = 'X' ).
  ENDMETHOD.

  METHOD let_cell_arise.
    ms_cell-status = 'X'.
  ENDMETHOD.

  METHOD let_cell_die.
    CLEAR ms_cell-status.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_game_of_life DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      cell_dies_less_two_neighboors FOR TESTING,
      cell_alive_three_neighboors FOR TESTING,
      cell_dies_four_neighboors FOR TESTING,
      dead_cell_three_neighboors FOR TESTING.
ENDCLASS.


CLASS ltcl_game_of_life IMPLEMENTATION.

  METHOD cell_dies_less_two_neighboors.
    DATA(mo_cut) = NEW ycl_game_of_life( ).
    mo_cut->add_cell(  VALUE ycl_game_of_life=>ts_cell( status = 'X' sum_neighboors = 1 ) ).
    mo_cut->play( ).
    cl_abap_unit_assert=>assert_equals( exp = VALUE ycl_game_of_life=>ts_cell( status = '' sum_neighboors = 1 )
                                        act = mo_cut->get_cell( ) ).
  ENDMETHOD.

  METHOD cell_alive_three_neighboors.
    DATA(mo_cut) = NEW ycl_game_of_life( ).
    mo_cut->add_cell(  VALUE ycl_game_of_life=>ts_cell( status = 'X' sum_neighboors = 3 ) ).
    mo_cut->play( ).
    cl_abap_unit_assert=>assert_equals( exp = VALUE ycl_game_of_life=>ts_cell( status = 'X' sum_neighboors = 3 )
                                        act = mo_cut->get_cell( ) ).
  ENDMETHOD.

  METHOD cell_dies_four_neighboors.
    DATA(mo_cut) = NEW ycl_game_of_life( ).
    mo_cut->add_cell(  VALUE ycl_game_of_life=>ts_cell( status = 'X' sum_neighboors = 4 ) ).
    mo_cut->play( ).
    cl_abap_unit_assert=>assert_equals( exp = VALUE ycl_game_of_life=>ts_cell( status = '' sum_neighboors = 4 )
                                        act = mo_cut->get_cell( ) ).
  ENDMETHOD.

  METHOD dead_cell_three_neighboors.
    DATA(mo_cut) = NEW ycl_game_of_life( ).
    mo_cut->add_cell(  VALUE ycl_game_of_life=>ts_cell( status = '' sum_neighboors = 3 ) ).
    mo_cut->play( ).
    cl_abap_unit_assert=>assert_equals( exp = VALUE ycl_game_of_life=>ts_cell( status = 'X' sum_neighboors = 3 )
                                        act = mo_cut->get_cell( ) ).
  ENDMETHOD.

ENDCLASS.
