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

* Local saver class
CLASS lsc_supplement DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PUBLIC SECTION.
    CONSTANTS:
      co_create TYPE string VALUE 'C',
      co_delete TYPE string VALUE 'D',
      co_update TYPE string VALUE 'U'.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.


ENDCLASS.

CLASS lsc_supplement IMPLEMENTATION.

  METHOD save_modified.

    DATA:
      lt_supplements TYPE STANDARD TABLE OF ztb_booksup_0932,
      lv_mode        TYPE zde_upd_mode_0932,
      lv_updated     TYPE zde_upd_mode_0932.

    IF NOT create-bookingsupplement IS INITIAL. " Aparece cuando se especifica "with additional/unmanage save en el Behavior
*      lt_supplements = CORRESPONDING #( create-bookingsupplement ).
      lt_supplements = VALUE #( FOR suppl_ins IN create-bookingsupplement (
                                    travel_id             = suppl_ins-TravelId
                                    booking_id            = suppl_ins-BookingId
                                    booking_supplement_id = suppl_ins-BookingSupplementId
                                    supplement_id         = suppl_ins-SupplementId
                                    price                 = suppl_ins-Price
                                    currency_code         = suppl_ins-CurrencyCode
                                    last_changed_at       = suppl_ins-LastChangedAt
                              ) ).
      lv_mode        = lsc_supplement=>co_create.
    ENDIF.

    IF NOT delete-bookingsupplement IS INITIAL.
*      lt_supplements = CORRESPONDING #( delete-bookingsupplement ).
      lt_supplements = VALUE #( FOR suppl_del IN delete-bookingsupplement (
                                    travel_id             = suppl_del-TravelId
                                    booking_id            = suppl_del-BookingId
                                    booking_supplement_id = suppl_del-BookingSupplementId
*                                    supplement_id         = suppl_del-SupplementId
*                                    price                 = suppl_del-Price
*                                    currency_code         = suppl_del-CurrencyCode
*                                    last_changed_at       = suppl_del-LastChangedAt
                              ) ).
      lv_mode        = lsc_supplement=>co_delete.
    ENDIF.

    IF NOT update-bookingsupplement IS INITIAL.
*      lt_supplements = CORRESPONDING #( update-bookingsupplement ).
      lt_supplements = VALUE #( FOR suppl_upd IN update-bookingsupplement (
                                    travel_id             = suppl_upd-TravelId
                                    booking_id            = suppl_upd-BookingId
                                    booking_supplement_id = suppl_upd-BookingSupplementId
                                    supplement_id         = suppl_upd-SupplementId
                                    price                 = suppl_upd-Price
                                    currency_code         = suppl_upd-CurrencyCode
                                    last_changed_at       = suppl_upd-LastChangedAt
                              ) ).
      lv_mode        = lsc_supplement=>co_update.
    ENDIF.

    IF NOT lt_supplements IS INITIAL.
      CALL FUNCTION 'Z_UPD_SUPPL_0932'
        EXPORTING
          it_supplements = lt_supplements
          iv_mode        = lv_mode
        IMPORTING
          ev_updated     = lv_updated.

    ENDIF.
    IF lv_updated EQ abap_true.
*        reported-
    ENDIF.

  ENDMETHOD.

ENDCLASS.
