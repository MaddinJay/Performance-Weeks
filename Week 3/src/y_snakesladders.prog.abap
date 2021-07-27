*&---------------------------------------------------------------------*
*& Report y_snakesladders
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT y_snakesladders.

INTERFACE yif_snake_ladder.
  TYPES: ty_square TYPE int1.

  METHODS:
    get_square IMPORTING iv_square        TYPE ty_square
               RETURNING VALUE(rv_square) TYPE ty_square.
ENDINTERFACE.

CLASS ycl_snake DEFINITION FINAL.

  PUBLIC SECTION.
    INTERFACES: yif_snake_ladder.

    TYPES: BEGIN OF ts_snake,
             tale_square TYPE int1,
             head_square TYPE int1,
           END OF ts_snake,
           tt_snake TYPE STANDARD TABLE OF ts_snake WITH DEFAULT KEY.

    METHODS:
      constructor.

  PRIVATE SECTION.
    DATA:
      mt_snakes TYPE ycl_snake=>tt_snake.

ENDCLASS.

CLASS ycl_snake IMPLEMENTATION.

  METHOD constructor.
    mt_snakes = VALUE tt_snake( ( head_square = 16 tale_square = 6 )
                                ( head_square = 46 tale_square = 25 ) ).
  ENDMETHOD.

  METHOD yif_snake_ladder~get_square.
    TRY.
        ##TODO "ExceptionHandling für Workflow missbraucht -> zu ändern
        rv_square = mt_snakes[ head_square = iv_square ]-tale_square.
      CATCH cx_root.
        rv_square = iv_square.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

CLASS ycl_ladder DEFINITION FINAL.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_ladder,
             bottom_square TYPE int1,
             top_square    TYPE int1,
           END OF ts_ladder,
           tt_ladder TYPE STANDARD TABLE OF ts_ladder WITH DEFAULT KEY.

    INTERFACES: yif_snake_ladder.
    METHODS:
      constructor.

  PRIVATE SECTION.
    DATA:
      mt_ladders TYPE ycl_ladder=>tt_ladder.

ENDCLASS.

CLASS ycl_ladder IMPLEMENTATION.

  METHOD constructor.
    ##TODO " Weitere Felder ergänzen mit Testklasse ergänzen, um Befüllung zu prüfen
    mt_ladders = VALUE tt_ladder( ( bottom_square = 2 top_square = 38 )
                                  ( bottom_square = 7 top_square = 14 )
                                  ( bottom_square = 8 top_square = 31 ) ).
  ENDMETHOD.


  METHOD yif_snake_ladder~get_square.
    TRY.
        ##TODO "ExceptionHandling für Workflow missbraucht -> zu ändern
        rv_square = mt_ladders[ bottom_square = iv_square ]-top_square.
      CATCH cx_root.
        rv_square = iv_square.
    ENDTRY.

  ENDMETHOD.


ENDCLASS.

CLASS ycl_snakes_ladders DEFINITION FINAL.

  PUBLIC SECTION.
    METHODS:
      constructor,
      play IMPORTING iv_die_one       TYPE int1
                     iv_die_two       TYPE int1
           RETURNING VALUE(rv_result) TYPE int1.

  PRIVATE SECTION.
    DATA:
      mo_ladder TYPE REF TO yif_snake_ladder,
      mo_snake  TYPE REF TO yif_snake_ladder.

    METHODS:
      look_for_climb_up IMPORTING iv_square        TYPE int1
                        RETURNING VALUE(rv_square) TYPE int1,
      create_ladders,
      look_for_slide_down IMPORTING iv_square        TYPE int1
                          RETURNING VALUE(rv_result) TYPE int1,
      create_snakes.

ENDCLASS.

CLASS ycl_snakes_ladders IMPLEMENTATION.

  METHOD constructor.
    create_ladders( ).
    create_snakes( ).
  ENDMETHOD.

  METHOD create_ladders.
    mo_ladder = NEW ycl_ladder( ).
  ENDMETHOD.

  METHOD play.
    rv_result = iv_die_one + iv_die_two.
    rv_result = look_for_climb_up( rv_result ).
    rv_result = look_for_slide_down( rv_result ).
  ENDMETHOD.

  METHOD look_for_slide_down.
    rv_result = mo_snake->get_square( iv_square ).
  ENDMETHOD.

  METHOD look_for_climb_up.
    rv_square = mo_ladder->get_square( iv_square ).
  ENDMETHOD.

  METHOD create_snakes.
    mo_snake = NEW ycl_snake( ).
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_snakes_ladders DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
      mo_cut TYPE REF TO ycl_snakes_ladders.

    METHODS:
      setup,
      normal_try       FOR TESTING,
      climb_up_ladder  FOR TESTING,
      slide_down_snake FOR TESTING.

ENDCLASS.

CLASS ltcl_snakes_ladders IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW ycl_snakes_ladders( ).
  ENDMETHOD.

  METHOD normal_try.
    cl_abap_unit_assert=>assert_equals( exp = 3
                                        act = mo_cut->play( iv_die_one = 1
                                                            iv_die_two = 2 ) ).
  ENDMETHOD.

  METHOD climb_up_ladder.
    DATA(lo_cut) = NEW ycl_snakes_ladders( ).
    cl_abap_unit_assert=>assert_equals( exp = 38
                                        act = mo_cut->play( iv_die_one = 1
                                                            iv_die_two = 1 ) ).
  ENDMETHOD.

  METHOD slide_down_snake.
    DATA(lo_cut) = NEW ycl_snakes_ladders( ).
    ##TODO " Testfall sporadisch für Logikeinbau missbraucht
    cl_abap_unit_assert=>assert_equals( exp = 6
                                        act = mo_cut->play( iv_die_one = 8
                                                            iv_die_two = 8 ) ).
    cl_abap_unit_assert=>assert_equals( exp = 25
                                        act = mo_cut->play( iv_die_one = 28
                                                            iv_die_two = 18 ) ).
  ENDMETHOD.

ENDCLASS.
