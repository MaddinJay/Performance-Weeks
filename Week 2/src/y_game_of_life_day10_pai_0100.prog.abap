*----------------------------------------------------------------------*
***INCLUDE Y_GAME_OF_LIFE_DAY10_PAI_0100.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'PLAY'.
      go_game_of_life->play_round( ).
      gt_board = go_game_of_life->get_current_board( ).
      go_alv->refresh_table_display( ).
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
