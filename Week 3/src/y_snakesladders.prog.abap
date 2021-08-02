*&---------------------------------------------------------------------*
*& Report y_snakesladders
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_snakesladders.

INTERFACE yitf_snakes_ladders.
  DATA:
    mv_square TYPE int1,
    mv_player TYPE int1.

  METHODS:
    play                    IMPORTING iv_die_one       TYPE int1
                                      iv_die_two       TYPE int1
                            RETURNING VALUE(rv_result) TYPE string.
ENDINTERFACE.

CLASS ycl_snakes_ladders DEFINITION.

  PUBLIC SECTION.
    INTERFACES: yitf_snakes_ladders.
    ALIASES: play      FOR yitf_snakes_ladders~play,
             mv_player FOR yitf_snakes_ladders~mv_player,
             mv_square FOR yitf_snakes_ladders~mv_square.

  PRIVATE SECTION.
    DATA:
      mv_game_over TYPE abap_bool.

    METHODS:
      is_game_finished      RETURNING VALUE(rv_is_finished) TYPE abap_bool,
      set_new_square        IMPORTING iv_die_two TYPE int1
                                      iv_die_one TYPE int1,
      get_throw_result      RETURNING VALUE(rv_throw_result) TYPE string,
      is_game_over          RETURNING VALUE(r_result) TYPE abap_bool,
      play_round            IMPORTING iv_die_two       TYPE int1
                                      iv_die_one       TYPE int1
                            RETURNING VALUE(rv_result) TYPE string.

ENDCLASS.

CLASS ycl_snakes_ladders IMPLEMENTATION.

  METHOD yitf_snakes_ladders~play.
    rv_result = SWITCH #( is_game_over( )
                          WHEN abap_true THEN |Game over!|
                          ELSE play_round( iv_die_two = iv_die_two
                                           iv_die_one = iv_die_one ) ).
  ENDMETHOD.

  METHOD is_game_over.
    r_result = xsdbool( mv_square = 99 ).
  ENDMETHOD.

  METHOD set_new_square.
    mv_square = mv_square + iv_die_one + iv_die_two.
  ENDMETHOD.

  METHOD is_game_finished.
    rv_is_finished = xsdbool( mv_square = 99 ).
  ENDMETHOD.

  METHOD get_throw_result.
    rv_throw_result = SWITCH #( is_game_finished(  )
                                WHEN abap_true THEN |Player { mv_player } wins!|
                                ELSE                |Player { mv_player } is on square {  mv_square }| ).
  ENDMETHOD.

  METHOD play_round.
    set_new_square( iv_die_two = iv_die_two
                    iv_die_one = iv_die_one ).
    rv_result = get_throw_result( ).
  ENDMETHOD.

ENDCLASS.

CLASS ltd_snakes_ladders DEFINITION INHERITING FROM ycl_snakes_ladders.
  PUBLIC SECTION.
    METHODS:
      set_active_player     IMPORTING iv_active_player TYPE int1,
      set_square            IMPORTING iv_square TYPE int1.

ENDCLASS.

CLASS ltd_snakes_ladders IMPLEMENTATION.

  METHOD set_active_player.
    mv_player = iv_active_player.
  ENDMETHOD.

  METHOD set_square.
    mv_square = iv_square.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_snakes_ladders DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
      mo_game TYPE REF TO ltd_snakes_ladders.

    METHODS:
      player_1_is_on_square_4 FOR TESTING,
      player_2_is_on_square_6 FOR TESTING,
      player_2_wins           FOR TESTING,
      game_over               FOR TESTING.

    METHODS:
      setup.

ENDCLASS.

CLASS ltcl_snakes_ladders IMPLEMENTATION.

  METHOD setup.
    mo_game = NEW #( ).
  ENDMETHOD.

  METHOD player_1_is_on_square_4.
    mo_game->set_active_player( 1 ).
    cl_abap_unit_assert=>assert_equals( exp = |Player 1 is on square 4|
                                        act = mo_game->play( iv_die_one = 2
                                                             iv_die_two = 2 ) ).
  ENDMETHOD.

  METHOD player_2_is_on_square_6.
    mo_game->set_active_player( 2 ).
    cl_abap_unit_assert=>assert_equals( exp = |Player 2 is on square 4|
                                        act = mo_game->play( iv_die_one = 2
                                                             iv_die_two = 2 ) ).
  ENDMETHOD.

  METHOD player_2_wins.
    mo_game->set_active_player( 2 ).
    mo_game->set_square( iv_square = 95 ).
    cl_abap_unit_assert=>assert_equals( exp = |Player 2 wins!|
                                        act = mo_game->play( iv_die_one = 2
                                                             iv_die_two = 2 ) ).
  ENDMETHOD.

  METHOD game_over.
    mo_game->set_square( iv_square = 99 ).
    cl_abap_unit_assert=>assert_equals( exp = |Game over!|
                                        act = mo_game->play( iv_die_one = 2
                                                             iv_die_two = 2 ) ).
  ENDMETHOD.

ENDCLASS.
