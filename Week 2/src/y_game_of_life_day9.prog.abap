*&---------------------------------------------------------------------*
*& Report y_game_of_life_day9
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_game_of_life_day9.

CLASS ycl_game_of_life DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      constructor,
      get_board RETURNING VALUE(rt_board) TYPE ytt_board,
      play_round.

  PRIVATE SECTION.
    DATA:
      mt_board TYPE ytt_board.

ENDCLASS.

CLASS ycl_game_of_life IMPLEMENTATION.

  METHOD constructor.
    APPEND VALUE yts_board( a = ''  b = 'X' c = ''  d = '' ) TO mt_board.
    APPEND VALUE yts_board( a = ''  b = ''  c = 'X' d = '' ) TO mt_board.
    APPEND VALUE yts_board( a = 'X' b = 'X' c = 'X' d = '' ) TO mt_board.
    APPEND VALUE yts_board( a = ''  b = ''  c = ''  d = '' ) TO mt_board.
  ENDMETHOD.

  METHOD get_board.
    rt_board = mt_board.
  ENDMETHOD.

  METHOD play_round.
    CLEAR mt_board.
    APPEND VALUE yts_board( a = ''  b = ''  c = ''  d = '' ) TO mt_board.
    APPEND VALUE yts_board( a = 'X' b = ''  c = 'X' d = '' ) TO mt_board.
    APPEND VALUE yts_board( a = ''  b = 'X' c = 'X' d = '' ) TO mt_board.
    APPEND VALUE yts_board( a = ''  b = 'X' c = ''  d = '' ) TO mt_board.
  ENDMETHOD.

ENDCLASS.

DATA: gt_board        TYPE STANDARD TABLE OF yts_board WITH DEFAULT KEY,
      go_alv          TYPE REF TO cl_gui_alv_grid,
      go_game_of_life TYPE REF TO ycl_game_of_life.

INCLUDE y_game_of_life_day9_pai_0100.
INCLUDE y_game_of_life_day9_pbo_0100.

START-OF-SELECTION.
  go_game_of_life = NEW #( ).
  gt_board        = go_game_of_life->get_board( ).

  go_alv         = NEW #( i_parent = cl_gui_container=>screen0 ).
  go_alv->set_table_for_first_display( EXPORTING i_structure_name = 'YTS_BOARD'
                                        CHANGING  it_outtab        = gt_board ).

  CALL SCREEN 0100.
