CLASS zcl_del_tab_entries_0932 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEL_TAB_ENTRIES_0932 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DELETE FROM ztb_libros_0932.
    IF sy-subrc EQ 0.
        out->write( 'All data deleted' ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
