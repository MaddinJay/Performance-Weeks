*----------------------------------------------------------------------*
***INCLUDE Y_SNAKESLADDERS_PAI_0100.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'PLAY'.
      go_snakes_ladders->play( iv_die_one = 3 iv_die_two = 2 ).
      gv_player_one_result = |Player 1 is on square { go_snakes_ladders->get_player_one_result( ) }|.
      gv_player_two_result = |Player 2 is on square { go_snakes_ladders->get_player_two_result( ) }|.
    WHEN 'EXIT'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
