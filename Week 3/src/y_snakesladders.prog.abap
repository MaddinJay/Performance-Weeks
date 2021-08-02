*&---------------------------------------------------------------------*
*& Report y_snakesladders
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_snakesladders.

CLASS ycl_player DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      play IMPORTING iv_die_one       TYPE int1
                     iv_die_two       TYPE int1
           RETURNING VALUE(rv_square) TYPE int1.

  PRIVATE SECTION.
    DATA:
      mv_square TYPE int1.

ENDCLASS.

CLASS ycl_player IMPLEMENTATION.

  METHOD play.
    rv_square = mv_square = mv_square + iv_die_one + iv_die_two.
  ENDMETHOD.

ENDCLASS.

CLASS ycl_snakes_ladders DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      constructor,
      play IMPORTING iv_die_one       TYPE int1
                     iv_die_two       TYPE int1
           RETURNING VALUE(rv_result) TYPE string.

  PRIVATE SECTION.
    DATA:
      mv_player            TYPE int1,
      mv_square_player_one TYPE int1,
      mv_square_player_two TYPE int1,
      mo_player_one        TYPE REF TO ycl_player,
      mo_player_two        TYPE REF TO ycl_player,
      mt_players           TYPE STANDARD TABLE OF REF TO ycl_player.

    METHODS:
      switch_player,
      get_square_of_player_one IMPORTING iv_die_one      TYPE int1
                                         iv_die_two      TYPE int1
                               RETURNING VALUE(r_result) TYPE string,
      get_square_of_player_two IMPORTING iv_die_one      TYPE int1
                                         iv_die_two      TYPE int1
                               RETURNING VALUE(r_result) TYPE string,
      set_starting_player,
      create_players.

ENDCLASS.

CLASS ycl_snakes_ladders IMPLEMENTATION.

  METHOD constructor.
    set_starting_player( ).
    create_players( ).
  ENDMETHOD.

  METHOD create_players.
    mo_player_one = NEW ycl_player( ).
    mo_player_two = NEW ycl_player( ).
  ENDMETHOD.

  METHOD set_starting_player.
    mv_player = 1.
  ENDMETHOD.

  METHOD play.
    rv_result = SWITCH #( mv_player
                          WHEN 1 THEN get_square_of_player_one( iv_die_one = iv_die_one iv_die_two = iv_die_two )
                          WHEN 2 THEN get_square_of_player_two( iv_die_one = iv_die_one iv_die_two = iv_die_two ) ).
    switch_player( ).
  ENDMETHOD.

  METHOD get_square_of_player_two.
    r_result = |Player 2 is on square { mo_player_two->play( iv_die_one = iv_die_one
                                                             iv_die_two = iv_die_two ) }|.
  ENDMETHOD.

  METHOD get_square_of_player_one.
    r_result = |Player 1 is on square { mo_player_one->play( iv_die_one = iv_die_one
                                                             iv_die_two = iv_die_two ) }|.
  ENDMETHOD.

  METHOD switch_player.
    mv_player = SWITCH #( mv_player
                          WHEN 1 THEN 2
                          WHEN 2 THEN 1 ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_snakes_ladders DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
      mo_game TYPE REF TO ycl_snakes_ladders.

    METHODS:
      first_round FOR TESTING,
      second_round FOR TESTING.

    METHODS play_first_round.

ENDCLASS.

CLASS ltcl_snakes_ladders IMPLEMENTATION.

  METHOD first_round.
    DATA(lo_game) = NEW ycl_snakes_ladders( ).
    cl_abap_unit_assert=>assert_equals( exp = 'Player 1 is on square 4'
                                        act = lo_game->play( iv_die_one = 2
                                                             iv_die_two = 2 ) ).
    cl_abap_unit_assert=>assert_equals( exp = 'Player 2 is on square 6'
                                        act = lo_game->play( iv_die_one = 2
                                                             iv_die_two = 4 ) ).
  ENDMETHOD.

  METHOD second_round.
    mo_game = NEW ycl_snakes_ladders( ).
    play_first_round( ).
    cl_abap_unit_assert=>assert_equals( exp = 'Player 1 is on square 8'
                                        act = mo_game->play( iv_die_one = 2
                                                             iv_die_two = 2 ) ).
    cl_abap_unit_assert=>assert_equals( exp = 'Player 2 is on square 10'
                                        act = mo_game->play( iv_die_one = 2
                                                             iv_die_two = 2 ) ).
  ENDMETHOD.

  METHOD play_first_round.
    mo_game->play( iv_die_one = 2
                   iv_die_two = 2 ).
    mo_game->play( iv_die_one = 2
                   iv_die_two = 4 ).
  ENDMETHOD.

ENDCLASS.
