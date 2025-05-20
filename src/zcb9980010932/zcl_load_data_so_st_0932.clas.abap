CLASS zcl_load_data_so_st_0932 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LOAD_DATA_SO_ST_0932 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA:
      lt_so_status TYPE STANDARD TABLE OF zso_stat_0932.

      lt_so_status = VALUE #(
        ( status = 100 text = 'Open' )
        ( status = 150 text = 'Partially' )
        ( status = 200 text = 'Completed' )
        ( status = 250 text = 'Cancelled' )
      ).
      DELETE FROM zso_stat_0932.
      INSERT zso_stat_0932 FROM TABLE @lt_so_status.
  ENDMETHOD.
ENDCLASS.
