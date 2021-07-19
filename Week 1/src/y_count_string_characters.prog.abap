*&---------------------------------------------------------------------*
*& Report y_count_string_characters
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_count_string_characters.

CLASS ycl_string DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_character_count,
             character TYPE char1,
             count     TYPE int1,
           END OF ts_character_count,
           tt_character_count TYPE STANDARD TABLE OF ts_character_count WITH DEFAULT KEY.

    METHODS:
      constructor      IMPORTING iv_text                   TYPE string,
      count_characters,
      get_counted_characters RETURNING VALUE(rt_character_count) TYPE tt_character_count.

  PRIVATE SECTION.
    DATA:
      mv_text             TYPE string,
      mv_current_position TYPE i,
      mt_character_count  TYPE tt_character_count.

    METHODS:
      string_has_next_position    RETURNING VALUE(rv_has_next_position) TYPE abap_bool,
      get_current_string_position RETURNING VALUE(rv_current_character) TYPE char1,
      is_character_counted        RETURNING VALUE(rv_counted)    TYPE abap_bool,
      add_count_for_current_char,
      add_new_character,
      set_next_string_position.

ENDCLASS.

CLASS ycl_string IMPLEMENTATION.

  METHOD constructor.
    mv_text = iv_text.
  ENDMETHOD.

  METHOD count_characters.

    WHILE string_has_next_position( ).
      IF is_character_counted( ).
        add_count_for_current_char(  ).
      ELSE.
        add_new_character(  ).
      ENDIF.
      set_next_string_position( ).
    ENDWHILE.

  ENDMETHOD.

  METHOD set_next_string_position.
    mv_current_position = mv_current_position + 1.
  ENDMETHOD.

  METHOD add_new_character.
    APPEND VALUE ycl_string=>ts_character_count( character = get_current_string_position( ) count = 1 ) TO mt_character_count.
  ENDMETHOD.

  METHOD add_count_for_current_char.
    READ TABLE mt_character_count ASSIGNING FIELD-SYMBOL(<character_count>) WITH KEY character = get_current_string_position( ).
    <character_count>-count = <character_count>-count + 1.
  ENDMETHOD.

  METHOD get_current_string_position.
    rv_current_character = mv_text+mv_current_position(1).
  ENDMETHOD.

  METHOD string_has_next_position.
    rv_has_next_position = xsdbool( mv_current_position < strlen( mv_text ) ).
  ENDMETHOD.

  METHOD is_character_counted.
    LOOP AT mt_character_count TRANSPORTING NO FIELDS WHERE character = get_current_string_position( ).
      rv_counted = abap_true.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_counted_characters.
    rt_character_count = mt_character_count.
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
    DATA(lo_cut) = NEW ycl_string( 'Das ist ein Test').
    lo_cut->count_characters( ).
    cl_abap_unit_assert=>assert_equals( exp = VALUE ycl_string=>tt_character_count( ( character = 'D' count = 1 )
                                                                                    ( character = 'a' count = 1 )
                                                                                    ( character = 's' count = 3 )
                                                                                    ( character = ' ' count = 3 ) ##TODO " Space mit _ austauschen
                                                                                    ( character = 'i' count = 2 )
                                                                                    ( character = 't' count = 2 )
                                                                                    ( character = 'e' count = 2 )
                                                                                    ( character = 'n' count = 1 )
                                                                                    ( character = 'T' count = 1 ) )
                                        act = lo_cut->get_counted_characters( ) ).
  ENDMETHOD.

ENDCLASS.
