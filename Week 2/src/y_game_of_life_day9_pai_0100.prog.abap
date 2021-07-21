*&---------------------------------------------------------------------*
*&  Include  y_game_of_life_day9_pai_0100
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'PLAY'.
      CLEAR gt_board.
      go_game_of_life->play_round( ).
      gt_board = go_game_of_life->get_board( ).
      go_alv->refresh_table_display( ).

    WHEN OTHERS.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
