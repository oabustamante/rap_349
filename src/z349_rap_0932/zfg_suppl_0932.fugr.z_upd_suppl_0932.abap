FUNCTION z_upd_suppl_0932.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_SUPPLEMENTS) TYPE  ZTT_SUPPL_0932
*"     REFERENCE(IV_MODE) TYPE  ZDE_UPD_MODE_0932
*"  EXPORTING
*"     REFERENCE(EV_UPDATED) TYPE  ZDE_UPD_MODE_0932
*"----------------------------------------------------------------------
  IF it_supplements IS NOT INITIAL.
    CASE iv_mode.
      WHEN 'C'.
        INSERT ztb_booksup_0932 FROM TABLE @it_supplements.
      WHEN 'D'.
        DELETE ztb_booksup_0932 FROM TABLE @it_supplements.
      WHEN 'U'.
        UPDATE ztb_booksup_0932 FROM TABLE @it_supplements.
    ENDCASE.
    IF sy-subrc EQ 0.
      ev_updated = abap_true.
    ENDIF.
  ENDIF.

ENDFUNCTION.
