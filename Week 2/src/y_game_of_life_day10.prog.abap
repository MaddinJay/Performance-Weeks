*&---------------------------------------------------------------------*
*& Report y_game_of_life_day10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_game_of_life_day10.

CLASS ycl_cell DEFINITION.
  PUBLIC SECTION.
    METHODS:
      set_status IMPORTING iv_status TYPE char1,
      get_status RETURNING VALUE(rv_status) TYPE char1,
      get_neighboors RETURNING VALUE(rv_neighboors) TYPE i,
      add_neighboor.
  PRIVATE SECTION.
    DATA:
      mv_status     TYPE char1,
      mv_neighboors TYPE i.

ENDCLASS.

CLASS ycl_cell IMPLEMENTATION.

  METHOD set_status.
    mv_status = iv_status.
  ENDMETHOD.

  METHOD get_status.
    rv_status = mv_status.
  ENDMETHOD.

  METHOD get_neighboors.
    rv_neighboors = mv_neighboors.
  ENDMETHOD.

  METHOD add_neighboor.
    mv_neighboors = mv_neighboors + 1.
  ENDMETHOD.

ENDCLASS.

CLASS ycl_game_of_life DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: tt_cells TYPE STANDARD TABLE OF REF TO ycl_cell WITH DEFAULT KEY.
    METHODS:
      constructor       IMPORTING it_board TYPE ytt_board,
      play_round,
      get_current_board RETURNING VALUE(rt_board) TYPE ytt_board,
      get_cell_list     RETURNING VALUE(rt_cells) TYPE tt_cells.

  PRIVATE SECTION.
    DATA:
      mt_cells TYPE tt_cells.
    METHODS create_cell_a
      IMPORTING
        is_board TYPE yts_board.
    METHODS create_cell_b
      IMPORTING
        is_board TYPE yts_board.
    METHODS create_cell_c
      IMPORTING
        is_board TYPE yts_board.
    METHODS create_cell_d
      IMPORTING
        is_board TYPE yts_board.

ENDCLASS.

CLASS ycl_game_of_life IMPLEMENTATION.

  METHOD constructor.
    LOOP AT it_board INTO DATA(ls_board).
      create_cell_a( ls_board ).
      create_cell_b( ls_board ).
      create_cell_c( ls_board ).
      create_cell_d( ls_board ).
    ENDLOOP.
  ENDMETHOD.

  METHOD create_cell_d.
    ##TODO " Methoden dynamisch vereinheitlichen
    DATA(lo_cell_d) = NEW ycl_cell( ).
    lo_cell_d->set_status( is_board-d ).
    APPEND lo_cell_d TO mt_cells.
  ENDMETHOD.

  METHOD create_cell_c.
    DATA(lo_cell_c) = NEW ycl_cell( ).
    lo_cell_c->set_status( is_board-c ).
    APPEND lo_cell_c TO mt_cells.
  ENDMETHOD.

  METHOD create_cell_b.
    DATA(lo_cell_b) = NEW ycl_cell( ).
    lo_cell_b->set_status( is_board-b ).
    APPEND lo_cell_b TO mt_cells.
  ENDMETHOD.

  METHOD create_cell_a.
    DATA(lo_cell_a) = NEW ycl_cell( ).
    lo_cell_a->set_status( is_board-a ).
    IF is_board-b = 'X'.
      lo_cell_a->add_neighboor( ).
    ENDIF.
    APPEND lo_cell_a TO mt_cells.
  ENDMETHOD.

  METHOD play_round.
*    mt_board = VALUE #( ( a = ''  b = ''  c = ''  d = '' )
*                        ( a = 'X' b = ''  c = 'X' d = '' )
*                        ( a = ''  b = 'X' c = 'X' d = '' )
*                        ( a = ''  b = 'X' c = ''  d = '' ) ).
  ENDMETHOD.

  METHOD get_current_board.
*    rt_board = mt_board.
  ENDMETHOD.

  METHOD get_cell_list.
    rt_cells = mt_cells.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_game_of_life DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      cell_input_transfer_ok FOR TESTING.
ENDCLASS.


CLASS ltcl_game_of_life IMPLEMENTATION.

  METHOD cell_input_transfer_ok.
    DATA(lo_game_of_life) = NEW ycl_game_of_life( VALUE #( ( a = 'X'  b = 'X'  c = 'X'  d = 'X' ) ) ).
    DATA(lt_cells)        = lo_game_of_life->get_cell_list( ).

    cl_abap_unit_assert=>assert_equals( exp = 4
                                        act = lines( lo_game_of_life->get_cell_list( ) ) ).

    cl_abap_unit_assert=>assert_equals( exp = 'X'
                                        act = lt_cells[ 1 ]->get_status( ) ).
    cl_abap_unit_assert=>assert_equals( exp = 1
                                        act = lt_cells[ 1 ]->get_neighboors( ) ).
    cl_abap_unit_assert=>assert_equals( exp = 'X'
                                        act = lt_cells[ 2 ]->get_status( ) ).
    cl_abap_unit_assert=>assert_equals( exp = 'X'
                                        act = lt_cells[ 3 ]->get_status( ) ).
    cl_abap_unit_assert=>assert_equals( exp = 'X'
                                        act = lt_cells[ 4 ]->get_status( ) ).
  ENDMETHOD.

ENDCLASS.

DATA:
  go_alv          TYPE REF TO cl_gui_alv_grid,
  gt_board        TYPE ytt_board,
  go_game_of_life TYPE REF TO ycl_game_of_life.

INCLUDE y_game_of_life_day10_pbo_0100.
INCLUDE y_game_of_life_day10_pai_0100.

START-OF-SELECTION.
  go_alv = NEW #( cl_gui_container=>screen0 ).

  gt_board = VALUE #( ( a = ''  b = 'X' c = ''  d = '' )
                      ( a = ''  b = ''  c = 'X' d = '' )
                      ( a = 'X' b = 'X' c = 'X' d = '' )
                      ( a = ''  b = ''  c = ''  d = '' ) ).
  go_game_of_life = NEW ycl_game_of_life( it_board = gt_board ).


  go_alv->set_table_for_first_display( EXPORTING i_structure_name = 'YTS_BOARD'
                                       CHANGING  it_outtab        = gt_board ).

  CALL SCREEN 0100.
