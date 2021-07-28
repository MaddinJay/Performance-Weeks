*&---------------------------------------------------------------------*
*& Report y_snakesladders
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_snakesladders.

CLASS ycl_snakes_ladders DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      play IMPORTING iv_die_one TYPE int1
                     iv_die_two TYPE int1,
      get_player_one_result RETURNING VALUE(rv_result) TYPE string,
      get_player_two_result RETURNING VALUE(rv_result) TYPE string,
      constructor.
  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mv_player_one_result TYPE int1.
    DATA mv_player_two_result TYPE int1.

ENDCLASS.

CLASS ycl_snakes_ladders IMPLEMENTATION.

  METHOD constructor.
    mv_player_one_result = 0.
    mv_player_two_result = 0.
  ENDMETHOD.

  METHOD play.
    mv_player_one_result = iv_die_one + iv_die_two.
  ENDMETHOD.

  METHOD get_player_one_result.
    rv_result = mv_player_one_result.
  ENDMETHOD.

  METHOD get_player_two_result.
    rv_result = mv_player_two_result.
  ENDMETHOD.

ENDCLASS.

DATA: gv_player_one_result TYPE text60,
      gv_player_two_result TYPE text60,
      go_snakes_ladders    TYPE REF TO ycl_snakes_ladders.

INCLUDE y_snakesladders_pbo_0100.
INCLUDE y_snakesladders_pai_0100.

START-OF-SELECTION.
  go_snakes_ladders = NEW #( ).
  gv_player_one_result = |Player 1 is on square { go_snakes_ladders->get_player_one_result( ) }|.
  gv_player_two_result = |Player 2 is on square { go_snakes_ladders->get_player_two_result( ) }|.
  CALL SCREEN 0100.
