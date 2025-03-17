CLASS zcl_load_data_travel_0932 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LOAD_DATA_TRAVEL_0932 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA:
      lt_travel  TYPE TABLE OF ztb_travel_0932,
      lt_booking TYPE TABLE OF ztb_booking_0932,
      lt_booksup TYPE TABLE OF ztb_booksup_0932,
      lt_log     TYPE TABLE OF ztb_log_0932.

    CLEAR lt_travel.
    SELECT FROM /dmo/travel
      FIELDS travel_id, agency_id, customer_id, begin_date, end_date, booking_fee, total_price, currency_code,
             description, status AS overall_status, createdby AS created_by, createdat AS created_at, lastchangedby AS last_changed_by, lastchangedat AS last_changed_at
      INTO CORRESPONDING FIELDS OF TABLE @lt_travel
      UP TO 50 ROWS.
    IF sy-subrc EQ 0.
      CLEAR lt_booking.
*    SELECT FROM /dmo/booking
*      FIELDS travel_id, booking_id, booking_date, customer_id, carrier_id, connection_id,
*             flight_date, flight_price, currency_code, booking_status, last_changed_at
*      INTO
      SELECT * FROM /dmo/booking
        FOR ALL ENTRIES IN @lt_travel
        WHERE travel_id EQ @lt_travel-travel_id
        INTO CORRESPONDING FIELDS OF TABLE @lt_booking.
      IF sy-subrc EQ 0.
        CLEAR lt_booksup.
        SELECT * FROM /dmo/book_suppl
          FOR ALL ENTRIES IN @lt_booking
          WHERE travel_id EQ @lt_booking-travel_id
            AND booking_id EQ @lt_booking-booking_id
          INTO CORRESPONDING FIELDS OF TABLE @lt_booksup.
      ENDIF.

      DELETE FROM:
        ztb_travel_0932,
        ztb_booking_0932,
        ztb_booksup_0932.

      INSERT:
        ztb_travel_0932 FROM TABLE @lt_travel,
        ztb_booking_0932 FROM TABLE @lt_booking,
        ztb_booksup_0932 FROM TABLE @lt_booksup.

      CLEAR:
        lt_travel, lt_booking, lt_booksup.

      out->write( 'Done!' ).
    ELSE.
      out->write( 'The tables coudlnt be loeaded!' ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
