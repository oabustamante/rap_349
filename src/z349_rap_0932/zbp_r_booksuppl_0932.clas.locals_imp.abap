CLASS lhc_BookingSupplement DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalSupplimPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR BookingSupplement~calculateTotalSupplimPrice.

ENDCLASS.

CLASS lhc_BookingSupplement IMPLEMENTATION.

  METHOD calculateTotalSupplimPrice.
    IF NOT keys IS INITIAL.
      zcl_aux_travel_det_0932=>calculate_price( it_travel_id = VALUE #( FOR GROUPS <booking_suppl> OF booking_key IN keys
                                                                            GROUP BY booking_key-TravelId WITHOUT MEMBERS ( <booking_suppl> )
                                                                      ) ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
