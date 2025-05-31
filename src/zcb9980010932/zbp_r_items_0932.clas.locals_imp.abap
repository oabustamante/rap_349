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
    " Parent
    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Items BY \_Header
        FIELDS ( OrderUUID )
        WITH CORRESPONDING #( keys )
        RESULT DATA(headers).
    " Trigger reCalculateTotalPrice on Root Node
    MODIFY ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        EXECUTE reCalculateTotalPrice
        FROM CORRESPONDING #( headers ).
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
    DATA currencies TYPE SORTED TABLE OF I_Currency WITH UNIQUE KEY Currency.

    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Items
        FIELDS ( CurrencyCode )
        WITH CORRESPONDING #( keys )
        RESULT DATA(items).

    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Items BY \_Header
        FROM CORRESPONDING #( items )
        LINK DATA(order_items_links).

    currencies = CORRESPONDING #( items DISCARDING DUPLICATES MAPPING Currency = CurrencyCode EXCEPT * ).
    DELETE currencies WHERE Currency IS INITIAL.

    IF currencies IS NOT INITIAL.
* AVOID FOR ALL ENTRIES (it is possible with just 1 internal table)
      SELECT FROM I_Currency AS db
        INNER JOIN @currencies AS it ON db~Currency EQ it~Currency
        FIELDS db~Currency
        INTO TABLE @DATA(valid_currencies).
    ENDIF.

    LOOP AT items INTO DATA(item).
      APPEND VALUE #( %tky = item-%tky
                      %state_area = 'VALID_CURR_CODE' ) TO reported-items.

      IF item-CurrencyCode IS NOT INITIAL.

        IF NOT line_exists( valid_currencies[ Currency = item-CurrencyCode ] ).
          APPEND VALUE #( %tky = item-%tky ) TO failed-items.

          APPEND VALUE #( %tky                  = item-%tky
                          %state_area           = 'VALID_CURR_CODE'
                          %msg                  = new_message( id       = 'ZMC_ORDER_0932'
                                                               number   = '005'
                                                               severity = if_abap_behv_message=>severity-error )
                          %path                 = VALUE #( header-%tky = order_items_links[ KEY id  source-%tky = item-%tky ]-target-%tky )
                          %element-CurrencyCode = if_abap_behv=>mk-on ) TO reported-items.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateMeasuresValues.
    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Items
        FIELDS ( Price Height Width Depth Quantity )
        WITH CORRESPONDING #( keys )
        RESULT DATA(items).

    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Items BY \_Header
        FROM CORRESPONDING #( items )
        LINK DATA(order_items_links).

    LOOP AT items INTO DATA(item).
      APPEND VALUE #( %tky        = item-%tky
                      %state_area = 'WRONG_VALUES' ) TO reported-items.
      IF item-Price LT 1.
        APPEND VALUE #( %tky = item-%tky ) TO failed-items.

        APPEND VALUE #( %tky           = item-%tky
                        %state_area    = 'WRONG_VALUES'
                        %msg           = new_message( id       = 'ZMC_ORDER_0932'
                                                      number   = '007'
                                                      severity = if_abap_behv_message=>severity-error )
                        %path          = VALUE #( header-%tky = order_items_links[ KEY id  source-%tky = item-%tky ]-target-%tky )
                        %element-Price = if_abap_behv=>mk-on ) TO reported-items.
      ENDIF.              " << Price LT 0
      IF item-Height LT 0.
        APPEND VALUE #( %tky = item-%tky ) TO failed-items.

        APPEND VALUE #( %tky            = item-%tky
                        %state_area     = 'WRONG_VALUES'
                        %msg            = new_message( id       = 'ZMC_ORDER_0932'
                                                       number   = '008'
                                                       severity = if_abap_behv_message=>severity-error )
                        %path           = VALUE #( header-%tky = order_items_links[ KEY id  source-%tky = item-%tky ]-target-%tky )
                        %element-Height = if_abap_behv=>mk-on ) TO reported-items.
      ENDIF.              " << Height LT 0
      IF item-Width LT 0.
        APPEND VALUE #( %tky = item-%tky ) TO failed-items.

        APPEND VALUE #( %tky           = item-%tky
                        %state_area    = 'WRONG_VALUES'
                        %msg           = new_message( id       = 'ZMC_ORDER_0932'
                                                      number   = '009'
                                                      severity = if_abap_behv_message=>severity-error )
                        %path          = VALUE #( header-%tky = order_items_links[ KEY id  source-%tky = item-%tky ]-target-%tky )
                        %element-Width = if_abap_behv=>mk-on ) TO reported-items.
      ENDIF.              " << Width LT 0
      IF item-Depth LT 0.
        APPEND VALUE #( %tky = item-%tky ) TO failed-items.

        APPEND VALUE #( %tky           = item-%tky
                        %state_area    = 'WRONG_VALUES'
                        %msg           = new_message( id       = 'ZMC_ORDER_0932'
                                                      number   = '010'
                                                      severity = if_abap_behv_message=>severity-error )
                        %path          = VALUE #( header-%tky = order_items_links[ KEY id  source-%tky = item-%tky ]-target-%tky )
                        %element-Depth = if_abap_behv=>mk-on ) TO reported-items.
      ENDIF.              " << Depth LT 0
      IF item-Quantity LT 0.
        APPEND VALUE #( %tky = item-%tky ) TO failed-items.

        APPEND VALUE #( %tky              = item-%tky
                        %state_area       = 'WRONG_VALUES'
                        %msg              = new_message( id       = 'ZMC_ORDER_0932'
                                                         number   = '011'
                                                         severity = if_abap_behv_message=>severity-error )
                        %path             = VALUE #( header-%tky = order_items_links[ KEY id  source-%tky = item-%tky ]-target-%tky )
                        %element-Quantity = if_abap_behv=>mk-on ) TO reported-items.
      ENDIF.              " << Quantity LT 0
    ENDLOOP.
  ENDMETHOD.

  METHOD validateUnitOfMeasure.
    DATA unit_of_measures TYPE SORTED TABLE OF I_UnitOfMeasure WITH UNIQUE KEY UnitOfMeasure.

    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Items
        FIELDS ( UnitOfMeasure )
        WITH CORRESPONDING #( keys )
        RESULT DATA(items).

    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Items BY \_Header
        FROM CORRESPONDING #( items )
        LINK DATA(order_items_links).

    unit_of_measures = CORRESPONDING #( items DISCARDING DUPLICATES MAPPING UnitOfMeasure = UnitOfMeasure EXCEPT * ).
    DELETE unit_of_measures WHERE UnitOfMeasure IS INITIAL.
    IF unit_of_measures IS NOT INITIAL.
* AVOID FOR ALL ENTRIES (it is possible with just 1 internal table)
      SELECT FROM I_UnitOfMeasure AS db
        INNER JOIN @unit_of_measures AS it ON db~UnitOfMeasure EQ it~UnitOfMeasure
        FIELDS db~UnitOfMeasure
        INTO TABLE @DATA(valid_unit_of_measures).
    ENDIF.

    LOOP AT items INTO DATA(item).
      IF item-UnitOfMeasure IS NOT INITIAL.

        IF NOT line_exists( valid_unit_of_measures[ UnitOfMeasure = item-UnitOfMeasure ] ).
          APPEND VALUE #( %tky = item-%tky ) TO failed-items.

          APPEND VALUE #( %tky                   = item-%tky
                          %state_area            = 'VALID_CURR_CODE'
                          %msg                   = new_message( id       = 'ZMC_ORDER_0932'
                                                                number   = '006'
                                                                severity = if_abap_behv_message=>severity-error )
                          %path                  = VALUE #( header-%tky = order_items_links[ KEY id  source-%tky = item-%tky ]-target-%tky )
                          %element-UnitOfMeasure = if_abap_behv=>mk-on ) TO reported-items.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validationReleaseDiscontinued.
    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Items
        FIELDS ( ReleaseDate DiscontinuedDate )
        WITH CORRESPONDING #( keys )
        RESULT DATA(items).

    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Items BY \_Header
        FROM CORRESPONDING #( items )
        LINK DATA(order_items_links).

    LOOP AT items INTO DATA(item).
      APPEND VALUE #( %tky        = item-%tky
                      %state_area = 'DISCONTINUED_DATE' ) TO reported-items.
      IF item-ReleaseDate IS NOT INITIAL AND item-DiscontinuedDate IS NOT INITIAL.
        IF item-DiscontinuedDate LE item-ReleaseDate.
          APPEND VALUE #( %tky = item-%tky ) TO failed-items.

          APPEND VALUE #( %tky                      = item-%tky
                          %state_area               = 'DISCONTINUED_DATE'
                          %msg                      = new_message( id       = 'ZMC_ORDER_0932'
                                                                   number   = '012'
                                                                   severity = if_abap_behv_message=>severity-error )
                          %path                     = VALUE #( header-%tky = order_items_links[ KEY id  source-%tky = item-%tky ]-target-%tky )
                          %element-DiscontinuedDate = if_abap_behv=>mk-on ) TO reported-items.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
