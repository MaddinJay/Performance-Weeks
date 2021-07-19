*&---------------------------------------------------------------------*
*& Report ymj_count_characters
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ymj_count_characters.

INTERFACE yif_count_characters.
  TYPES: BEGIN OF ts_characters,
           character TYPE char1,
           count     TYPE int4,
         END OF ts_characters,
         tt_characters TYPE STANDARD TABLE OF ts_characters WITH DEFAULT KEY.
  METHODS count
    IMPORTING
      iv_input                  TYPE string
    RETURNING
      VALUE(rt_character_count) TYPE tt_characters
    RAISING
      ycx_mj_static_check.
ENDINTERFACE.

CLASS ycl_count_characters DEFINITION FINAL.

  PUBLIC SECTION.
    INTERFACES: yif_count_characters.
  PRIVATE SECTION.
    METHODS check_input
      IMPORTING
        iv_input TYPE string
      RAISING
        ycx_mj_static_check.
    METHODS count_characters
      IMPORTING
        iv_input                  TYPE string
      RETURNING
        VALUE(rt_character_count) TYPE yif_count_characters=>tt_characters.
    METHODS add_new_counted_character
      IMPORTING iv_count                  TYPE int4
                iv_input                  TYPE string
      RETURNING VALUE(rt_character_count) TYPE yif_count_characters=>tt_characters.
ENDCLASS.

CLASS ycl_count_characters IMPLEMENTATION.

  METHOD yif_count_characters~count.
    check_input( iv_input ).
    rt_character_count = count_characters( iv_input ).
  ENDMETHOD.

  METHOD count_characters.
    DATA: lv_count TYPE int4.

    DATA(lv_length) = strlen( iv_input ).

    WHILE lv_count < lv_length.
      LOOP AT rt_character_count ASSIGNING FIELD-SYMBOL(<character_count>) WHERE character = iv_input+lv_count(1).
        EXIT.
      ENDLOOP.

      IF sy-subrc = 0.
        <character_count>-count = <character_count>-count + 1.
      ELSE.
        rt_character_count = add_new_counted_character( iv_count = lv_count
                                                        iv_input = iv_input ).
      ENDIF.

      lv_count = lv_count + 1.
    ENDWHILE.

  ENDMETHOD.

  METHOD add_new_counted_character.
    APPEND VALUE yif_count_characters=>ts_characters( character = iv_input+iv_count(1) count = 1 ) TO rt_character_count.
  ENDMETHOD.

  METHOD check_input.
    IF iv_input IS INITIAL.
      RAISE EXCEPTION TYPE ycx_mj_static_check
        EXPORTING
          iv_message = 'Initial Input'.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_count_characters DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
      mo_cut TYPE REF TO yif_count_characters.
    METHODS:
      setup,

      count_one_character FOR TESTING RAISING ycx_mj_static_check,
      count_two_characters FOR TESTING RAISING ycx_mj_static_check,
      count_three_characters FOR TESTING RAISING ycx_mj_static_check,
      double_count_character FOR TESTING RAISING ycx_mj_static_check,
      acceptance_test_okay   FOR TESTING RAISING ycx_mj_static_check,
      empty_string_error FOR TESTING.
ENDCLASS.

CLASS ltcl_count_characters IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW ycl_count_characters( ).
  ENDMETHOD.

  METHOD count_one_character.
    cl_abap_unit_assert=>assert_equals( exp = VALUE yif_count_characters=>tt_characters( ( character = 'D' count = 1 ) )
                                        act = mo_cut->count( 'D ' ) ).
  ENDMETHOD.

  METHOD count_two_characters.
    cl_abap_unit_assert=>assert_equals( exp = VALUE yif_count_characters=>tt_characters( ( character = 'D' count = 1 )
                                                                                         ( character = 'a' count = 1 ) )
                                        act = mo_cut->count( 'Da' ) ).
  ENDMETHOD.

  METHOD count_three_characters.
    cl_abap_unit_assert=>assert_equals( exp = VALUE yif_count_characters=>tt_characters( ( character = 'D' count = 1 )
                                                                                         ( character = 'a' count = 1 )
                                                                                         ( character = 's' count = 1 ) )
                                        act = mo_cut->count( 'Das' ) ).
  ENDMETHOD.

  METHOD double_count_character.
    cl_abap_unit_assert=>assert_equals( exp = VALUE yif_count_characters=>tt_characters( ( character = 'D' count = 1 )
                                                                                         ( character = 'a' count = 2 ) )
                                        act = mo_cut->count( 'Daa' ) ).
  ENDMETHOD.

  METHOD empty_string_error.
    TRY.
        mo_cut->count( '' ).
      CATCH ycx_mj_static_check INTO DATA(lx_error).
        cl_abap_unit_assert=>assert_equals( exp = 'Initial Input' act = lx_error->get_message( ) ).
        RETURN.
    ENDTRY.
    cl_abap_unit_assert=>fail( ).
  ENDMETHOD.


  METHOD acceptance_test_okay.
    cl_abap_unit_assert=>assert_equals( exp = VALUE yif_count_characters=>tt_characters( ( character = 'D' count = 1 )
                                                                                         ( character = 'a' count = 1 )
                                                                                         ( character = 's' count = 2 )
                                                                                         ( character = 'i' count = 3 )
                                                                                         ( character = 't' count = 2 )
                                                                                         ( character = 'e' count = 1 )
                                                                                         ( character = 'n' count = 2 )
                                                                                         ( character = 's' count = 1 )
                                                                                         ( character = 'r' count = 1 )
                                                                                         ( character = 'g' count = 1 ) )
                                        act = mo_cut->count( 'Das ist ein String' ) ).
  ENDMETHOD.

ENDCLASS.
