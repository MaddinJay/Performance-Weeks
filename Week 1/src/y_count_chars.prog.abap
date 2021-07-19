*&---------------------------------------------------------------------*
*& Report y_count_chars
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_count_chars NO STANDARD PAGE HEADING.

CLASS ycl_converted_text DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_counted_chars,
             character TYPE text1,
             count     TYPE int1,
           END OF ts_counted_chars,
           tt_counted_chars TYPE STANDARD TABLE OF ts_counted_chars WITH DEFAULT KEY.

    METHODS:
      get_counted_chars RETURNING VALUE(rt_counted_chars) TYPE tt_counted_chars,
      set_counted_chars IMPORTING it_counted_chars TYPE tt_counted_chars,
      print,
      add_character IMPORTING iv_character TYPE text1.

  PRIVATE SECTION.
    DATA:
      mt_counted_chars TYPE ycl_converted_text=>tt_counted_chars.

ENDCLASS.

CLASS ycl_converted_text IMPLEMENTATION.

  METHOD get_counted_chars.
    rt_counted_chars = mt_counted_chars.
  ENDMETHOD.

  METHOD set_counted_chars.
    mt_counted_chars = it_counted_chars.
  ENDMETHOD.

  METHOD print.
    LOOP AT mt_counted_chars INTO DATA(ls_counted_chars).
      WRITE: / ls_counted_chars-character, 3 ':', ls_counted_chars-count.
    ENDLOOP.
  ENDMETHOD.

  METHOD add_character.
    DATA(lv_character) = iv_character.
    TRANSLATE lv_character TO LOWER CASE.
    APPEND VALUE ts_counted_chars( character = lv_character count = 1 ) TO mt_counted_chars.
  ENDMETHOD.

ENDCLASS.

CLASS ycl_text_input DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: tv_text TYPE text255.
    METHODS:
      ##TODO " String handeln
      constructor IMPORTING iv_text TYPE tv_text,
      get_text
        RETURNING
          VALUE(rv_text) TYPE tv_text.

  PRIVATE SECTION.
    DATA:
      mv_text TYPE tv_text.

ENDCLASS.

CLASS ycl_text_input IMPLEMENTATION.

  METHOD constructor.
    mv_text = iv_text.
  ENDMETHOD.

  METHOD get_text.
    rv_text = mv_text.
  ENDMETHOD.

ENDCLASS.

CLASS ycl_text_converter DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      constructor       IMPORTING io_text_input TYPE REF TO ycl_text_input,
      count_characters,
      get_counted_chars RETURNING VALUE(ro_converted_text) TYPE REF TO ycl_converted_text.

  PRIVATE SECTION.
    DATA:
      mo_text_input     TYPE REF TO ycl_text_input,
      mo_converted_text TYPE REF TO ycl_converted_text.

ENDCLASS.

CLASS ycl_text_converter IMPLEMENTATION.

  METHOD constructor.
    mo_text_input = io_text_input.
  ENDMETHOD.

  METHOD count_characters.
    DATA:
      lv_text_position TYPE i,
      lv_character     TYPE text1.

    mo_converted_text = NEW ycl_converted_text( ).
    ##TODO " Count-Logik einbauen
    DATA(lv_text) = mo_text_input->get_text( ).
    WHILE lv_text_position < strlen( lv_text ).
      lv_character = lv_text+lv_text_position(1).
      mo_converted_text->add_character( lv_character ).
      lv_text_position = lv_text_position + 1.
    ENDWHILE.
  ENDMETHOD.

  METHOD get_counted_chars.
    ro_converted_text = mo_converted_text.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_count_characters DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      acceptance_test FOR TESTING.
ENDCLASS.

CLASS ltcl_count_characters IMPLEMENTATION.

  METHOD acceptance_test.
    DATA(lo_text_converter) = NEW ycl_text_converter( NEW ycl_text_input( 'Das' ) )."as darf nicht sein' ) ).
    lo_text_converter->count_characters( ).

    DATA(lo_converted_text) = lo_text_converter->get_counted_chars( ).
    cl_abap_unit_assert=>assert_equals( exp = VALUE ycl_converted_text=>tt_counted_chars( ( character = 'd' count = 1 )
                                                                                          ( character = 'a' count = 1 )
                                                                                          ( character = 's' count = 1 ) )
*                                                                                          ( character = '_' count = 3 )
*                                                                                          ( character = 'r' count = 1 )
*                                                                                          ( character = 'f' count = 1 )
*                                                                                          ( character = 'n' count = 2 )
*                                                                                          ( character = 'i' count = 2 )
*                                                                                          ( character = 'c' count = 1 )
*                                                                                          ( character = 'h' count = 1 )
*                                                                                          ( character = 'e' count = 1 )
*                                                                                          ( character = 't' count = 1 ) )
                                        act = lo_text_converter->get_counted_chars( )->get_counted_chars( ) ).
  ENDMETHOD.

ENDCLASS.

SELECTION-SCREEN BEGIN OF BLOCK one.
PARAMETERS: p_text TYPE ycl_text_input=>tv_text DEFAULT 'Das darf nicht sein'.
SELECTION-SCREEN END OF BLOCK one.

END-OF-SELECTION.
  DATA(lo_text_converter) = NEW ycl_text_converter( NEW ycl_text_input( p_text ) ).
  lo_text_converter->count_characters( ).

  DATA(lo_converted_text) = lo_text_converter->get_counted_chars( ).
  lo_converted_text->print( ).
