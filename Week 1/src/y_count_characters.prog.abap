*&---------------------------------------------------------------------*
*& Report y_count_characters
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_count_characters.

CLASS ycl_counted_chars DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: tv_character TYPE char1,
           tv_count     TYPE int1.

    METHODS:
      get_character RETURNING VALUE(rv_character) TYPE tv_character,
      get_count     RETURNING VALUE(rv_count) TYPE tv_count,
      set_character IMPORTING iv_character TYPE tv_character,
      set_count     IMPORTING iv_count TYPE tv_count.

  PRIVATE SECTION.
    DATA:
      mv_character TYPE tv_character,
      mv_count     TYPE tv_count.

ENDCLASS.

CLASS ycl_counted_chars IMPLEMENTATION.

  METHOD get_character.
    rv_character = mv_character.
  ENDMETHOD.

  METHOD get_count.
    rv_count = mv_count.
  ENDMETHOD.

  METHOD set_character.
    mv_character = iv_character.
  ENDMETHOD.

  METHOD set_count.
    mv_count = iv_count.
  ENDMETHOD.

ENDCLASS.

CLASS ycl_input DEFINITION FINAL.

  PUBLIC SECTION.
    ##TODO " Type wechseln auf String
    TYPES: tv_text TYPE text255.

    METHODS:
      constructor IMPORTING iv_text TYPE tv_text,
      get_text    RETURNING VALUE(rv_text) TYPE tv_text.

  PRIVATE SECTION.
    DATA:
      mv_text TYPE string.

ENDCLASS.

CLASS ycl_input IMPLEMENTATION.

  METHOD constructor.
    mv_text = iv_text.
  ENDMETHOD.

  METHOD get_text.
    rv_text = mv_text.
  ENDMETHOD.

ENDCLASS.

CLASS ycl_count_characters DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING io_input TYPE REF TO ycl_input,
      count,
      get_char    RETURNING VALUE(ro_counted_chars) TYPE REF TO ycl_counted_chars.

  PRIVATE SECTION.
    DATA:
      mo_counted_chars   TYPE REF TO ycl_counted_chars,
      mo_input           TYPE REF TO ycl_input,
      mv_string_position TYPE i.

    METHODS:
      string_not_finished RETURNING VALUE(rv_not_finished) TYPE abap_bool,
      increase_string_position.

ENDCLASS.

CLASS ycl_count_characters IMPLEMENTATION.

  METHOD constructor.
    mo_input = io_input.
  ENDMETHOD.

  METHOD count.
    DATA lv_string_position TYPE i.

    mo_counted_chars = NEW ycl_counted_chars( ).
    DATA(lv_text) = mo_input->get_text( ).

    WHILE string_not_finished( ).
      mo_counted_chars->set_character( lv_text+lv_string_position(1) ).
      mo_counted_chars->set_count( 1 ).

      increase_string_position( ).
    ENDWHILE.
  ENDMETHOD.

  METHOD increase_string_position.
    mv_string_position = mv_string_position + 1.
  ENDMETHOD.

  METHOD get_char.
    ro_counted_chars = mo_counted_chars.
  ENDMETHOD.

  METHOD string_not_finished.
    DATA(lv_string_length) = strlen( mo_input->get_text( ) ).
    rv_not_finished = xsdbool( mv_string_position < lv_string_length ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_count_characters DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      sentence_counted_correctly FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_count_characters IMPLEMENTATION.

  METHOD sentence_counted_correctly.
    DATA(lo_count_characters) = NEW ycl_count_characters( NEW ycl_input( 'D' ) ).
    lo_count_characters->count( ).

    DATA(lo_counted_character) = lo_count_characters->get_char( ).
    cl_abap_unit_assert=>assert_equals( exp = 'D'
                                        act = lo_counted_character->get_character( ) ).
    cl_abap_unit_assert=>assert_equals( exp = '1'
                                        act = lo_counted_character->get_count( ) ).

  ENDMETHOD.

ENDCLASS.
