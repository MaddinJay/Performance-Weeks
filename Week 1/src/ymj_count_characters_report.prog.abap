*&---------------------------------------------------------------------*
*& Report ymj_count_characters_report
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ymj_count_characters_report NO STANDARD PAGE HEADING.

INTERFACE yif_count_characters.

  TYPES: BEGIN OF ts_counted_chars,
           character TYPE char1,
           count     TYPE int1,
         END OF ts_counted_chars,
         tt_counted_chars TYPE STANDARD TABLE OF ts_counted_chars WITH DEFAULT KEY.

  METHODS: count.

ENDINTERFACE.

CLASS ycl_characters DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      set_counted_chars IMPORTING it_counted_chars TYPE yif_count_characters=>tt_counted_chars,
      get_counted_chars RETURNING VALUE(rt_counted_chars) TYPE yif_count_characters=>tt_counted_chars,
      print.

  PRIVATE SECTION.
    DATA:
      mt_counted_chars TYPE yif_count_characters=>tt_counted_chars.

ENDCLASS.

CLASS ycl_characters IMPLEMENTATION.

  METHOD set_counted_chars.
    mt_counted_chars = it_counted_chars.
  ENDMETHOD.

  METHOD print.
    LOOP AT mt_counted_chars INTO DATA(ls_counted_chars).
      WRITE: / ls_counted_chars-character, ':', ls_counted_chars-count.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_counted_chars.
    rt_counted_chars = mt_counted_chars.
  ENDMETHOD.

ENDCLASS.

CLASS ycl_character_counter DEFINITION FINAL.

  PUBLIC SECTION.
    INTERFACES: yif_count_characters.

    METHODS:
      constructor IMPORTING iv_text TYPE string,
      get_counted_chars RETURNING VALUE(ro_characters) TYPE REF TO ycl_characters.

  PRIVATE SECTION.
    DATA:
      mv_text  TYPE string,
      mo_characters TYPE REF TO ycl_characters.

ENDCLASS.

CLASS ycl_character_counter IMPLEMENTATION.

  METHOD constructor.
    mv_text = iv_text.
  ENDMETHOD.

  METHOD yif_count_characters~count.
    mo_characters = NEW ycl_characters( ).
    mo_characters->set_counted_chars( VALUE yif_count_characters=>tt_counted_chars(
                                            ( character = 'T' count = '1' )
                                            ( character = 'e' count = '1' )
                                            ( character = 's' count = '1' )
                                            ( character = 't' count = '1' ) ) ).
  ENDMETHOD.

  METHOD get_counted_chars.
    ro_characters = mo_characters.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_count_characters DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      return_chars_okay FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_count_characters IMPLEMENTATION.

  METHOD return_chars_okay.
    DATA(lo_count_chars) = NEW ycl_character_counter( 'Test' ).
    lo_count_chars->yif_count_characters~count( ).
    cl_abap_unit_assert=>assert_equals( exp = VALUE yif_count_characters=>tt_counted_chars( ( character = 'T' count = '1' )
                                                                                            ( character = 'e' count = '1' )
                                                                                            ( character = 's' count = '1' )
                                                                                            ( character = 't' count = '1' ) )
                                        act = lo_count_chars->get_counted_chars( )->get_counted_chars( ) ).
  ENDMETHOD.

ENDCLASS.

SELECTION-SCREEN BEGIN OF BLOCK one.
PARAMETERS: p_text TYPE string LOWER CASE.
SELECTION-SCREEN END OF BLOCK one.

START-OF-SELECTION.


END-OF-SELECTION.
  DATA(lo_chars_counter) = NEW ycl_character_counter( p_text ).
  lo_chars_counter->yif_count_characters~count( ).
  lo_chars_counter->get_counted_chars( )->print( ).
