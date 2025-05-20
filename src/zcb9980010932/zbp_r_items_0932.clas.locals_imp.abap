CLASS lhc_Items DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS:
      get_instance_authorizations FOR INSTANCE AUTHORIZATION
        IMPORTING keys REQUEST requested_authorizations FOR Items RESULT result,

      get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Items RESULT result,

      calculateTotalPrice FOR DETERMINE ON MODIFY
        IMPORTING keys FOR Items~calculateTotalPrice,

      setItemPosition FOR DETERMINE ON SAVE
        IMPORTING keys FOR Items~setItemPosition,

      validateCurrencyCode FOR VALIDATE ON SAVE
        IMPORTING keys FOR Items~validateCurrencyCode,

      validateMeasuresValues FOR VALIDATE ON SAVE
        IMPORTING keys FOR Items~validateMeasuresValues,

      validateUnitOfMeasure FOR VALIDATE ON SAVE
        IMPORTING keys FOR Items~validateUnitOfMeasure,

      validationReleaseDiscontinued FOR VALIDATE ON SAVE
        IMPORTING keys FOR Items~validationReleaseDiscontinued.

ENDCLASS.

CLASS lhc_Items IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD calculateTotalPrice.
  ENDMETHOD.

  METHOD setItemPosition.
    DATA:
      max_itempos TYPE zr_items_0932-ItemPos,
      items_upd   TYPE TABLE FOR UPDATE zr_header_0932\\Items,
      item_upd    LIKE LINE OF items_upd.

    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Items BY \_Header
        FIELDS ( OrderUUID )
        WITH CORRESPONDING #( keys )
        RESULT DATA(headers).

    LOOP AT headers INTO DATA(header).
      READ ENTITIES OF zr_header_0932 IN LOCAL MODE
          ENTITY Header BY \_Items
          FIELDS ( ItemPos )
          WITH VALUE #( ( %tky = header-%tky ) )
          RESULT DATA(items).

      CLEAR max_itempos.

      LOOP AT items INTO DATA(item).
        IF item-ItemPos GT max_itempos.
          max_itempos = item-ItemPos.
        ENDIF.
      ENDLOOP.

      LOOP AT items INTO item WHERE ItemPos IS INITIAL.
        max_itempos += 1.
        APPEND VALUE #( %tky    = item-%tky
                        ItemPos = max_itempos ) TO items_upd.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Items
        UPDATE FIELDS ( ItemPos )
        WITH items_upd.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateMeasuresValues.
  ENDMETHOD.

  METHOD validateUnitOfMeasure.
  ENDMETHOD.

  METHOD validationReleaseDiscontinued.
  ENDMETHOD.

ENDCLASS.
