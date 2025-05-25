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

* 100: Open, 150: Partially, 200: Completed, 250: Cancelled
      lt_so_status = VALUE #(
        ( status = 1 text = 'New' )           " 100
        ( status = 2 text = 'Preparing' )     " 110
        ( status = 3 text = 'Sent' )          " 150
        ( status = 4 text = 'Delivered' )     " 200
        ( status = 5 text = 'Cancelled' )     " 250
      ).
      DELETE FROM zso_stat_0932.
      INSERT zso_stat_0932 FROM TABLE @lt_so_status.
      out->write( 'Datos cargados' ).
  ENDMETHOD.
ENDCLASS.
