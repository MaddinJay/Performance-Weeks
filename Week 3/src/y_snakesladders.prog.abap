*&---------------------------------------------------------------------*
*& Report y_snakesladders
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_snakesladders.

CLASS ycl_player DEFINITION.

  PUBLIC SECTION.
    METHODS:
      constructor  IMPORTING iv_player TYPE int1,
      set_position IMPORTING iv_die_one TYPE int1
                             iv_die_two TYPE int1,
      get_position RETURNING VALUE(rv_position) TYPE int1.

  PRIVATE SECTION.
    DATA:
      mv_player   TYPE int1,
      mv_position TYPE int1.

ENDCLASS.

CLASS ycl_player IMPLEMENTATION.

  METHOD constructor.
    mv_player = iv_player.
  ENDMETHOD.

  METHOD set_position.
    mv_position = mv_position + iv_die_one + iv_die_two.
  ENDMETHOD.

  METHOD get_position.
    rv_position = mv_position.
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
    DATA: mv_current_player TYPE int1,
          mt_players        TYPE STANDARD TABLE OF REF TO ycl_player.

    METHODS:
      change_player,
      get_new_position      IMPORTING iv_die_one         TYPE int1
                                      iv_die_two         TYPE int1
                            RETURNING VALUE(rv_position) TYPE int1,
      get_players_position  RETURNING VALUE(rv_position) TYPE int1,
      set_players_position  IMPORTING iv_die_one TYPE int1
                                      iv_die_two TYPE int1,
      get_result_text       RETURNING VALUE(r_result) TYPE string,
      create_player         IMPORTING iv_player TYPE int1,
      set_starting_player_one.

ENDCLASS.

CLASS ycl_snakes_ladders IMPLEMENTATION.

  METHOD constructor.
    create_player( 1 ).
    create_player( 2 ).
    set_starting_player_one( ).
  ENDMETHOD.

  METHOD play.
    set_players_position( iv_die_one = iv_die_one
                          iv_die_two = iv_die_two ).
    rv_result = get_result_text( ).
    change_player( ).
  ENDMETHOD.

  METHOD set_starting_player_one.
    mv_current_player = 1.
  ENDMETHOD.

  METHOD create_player.
    APPEND NEW ycl_player( iv_player = iv_player ) TO mt_players.
  ENDMETHOD.

  METHOD get_result_text.
    r_result = SWITCH #( get_players_position( )
                         WHEN 100 THEN |Player { mv_current_player } wins!|
                         ELSE |Player { mv_current_player } is on square { get_players_position( ) }| ).
  ENDMETHOD.

  METHOD change_player.
    mv_current_player = COND #( WHEN mv_current_player = 1 THEN 2
                                WHEN mv_current_player = 2 THEN 1 ).
  ENDMETHOD.

  METHOD get_new_position.
    rv_position = iv_die_one + iv_die_two.
  ENDMETHOD.

  METHOD get_players_position.
    rv_position = mt_players[ mv_current_player ]->get_position( ).
  ENDMETHOD.

  METHOD set_players_position.
    mt_players[ mv_current_player ]->set_position( iv_die_one = iv_die_one
                                                   iv_die_two = iv_die_two ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_snakes_ladders DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      player_1_throws_again FOR TESTING,
      player_2_throws_again FOR TESTING,
      player_1_wins FOR TESTING.
ENDCLASS.


CLASS ltcl_snakes_ladders IMPLEMENTATION.

  METHOD player_1_throws_again.
    DATA(lo_cut) = NEW ycl_snakes_ladders( ).
    lo_cut->play( iv_die_one = 3
                  iv_die_two = 2 ).
    lo_cut->play( iv_die_one = 3
                  iv_die_two = 3 ).
    cl_abap_unit_assert=>assert_equals( exp = 'Player 1 is on square 10'
                                        act = lo_cut->play( iv_die_one = 3
                                                            iv_die_two = 2 ) ).
  ENDMETHOD.

  METHOD player_2_throws_again.
    DATA(lo_cut) = NEW ycl_snakes_ladders( ).
    lo_cut->play( iv_die_one = 3
                  iv_die_two = 2 ).
    lo_cut->play( iv_die_one = 3
                  iv_die_two = 3 ).
    lo_cut->play( iv_die_one = 3
                  iv_die_two = 3 ).
    cl_abap_unit_assert=>assert_equals( exp = 'Player 2 is on square 11'
                                        act = lo_cut->play( iv_die_one = 3
                                                            iv_die_two = 2 ) ).
  ENDMETHOD.

  METHOD player_1_wins.
    DATA(lo_cut) = NEW ycl_snakes_ladders( ).
    DO 9 TIMES.
      lo_cut->play( iv_die_one = 5
                    iv_die_two = 5 ).
      lo_cut->play( iv_die_one = 5
                    iv_die_two = 5 ).
    ENDDO.
    cl_abap_unit_assert=>assert_equals( exp = 'Player 1 wins!'
                                        act = lo_cut->play( iv_die_one = 5
                                                            iv_die_two = 5 ) ).
  ENDMETHOD.

ENDCLASS.
