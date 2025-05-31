CLASS lhc_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES:
      "t_entities_create TYPE TABLE FOR CREATE /dmo/r_travel_d\\travel,
      t_entities_upd TYPE TABLE FOR UPDATE zr_header_0932\\header.

    CONSTANTS:
      BEGIN OF so_status,
        cancelled TYPE int1 VALUE 5,  "'250',    " 5
        delivered TYPE int1 VALUE 4,  "'200',    " 4
        new       TYPE int1 VALUE 1,  "'100',    " 1
        preparing TYPE int1 VALUE 2,  "'110',    " 2
        sent      TYPE int1 VALUE 3,  "'150',    " 3
      END OF so_status.
    METHODS:
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR Header RESULT result,

      get_instance_authorizations FOR INSTANCE AUTHORIZATION
        IMPORTING keys REQUEST requested_authorizations FOR Header RESULT result,

      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING REQUEST requested_authorizations FOR Header RESULT result,

      precheck_create FOR PRECHECK
        IMPORTING entities FOR CREATE Header,

      precheck_update FOR PRECHECK
        IMPORTING entities FOR UPDATE Header,

      Resume FOR MODIFY
        IMPORTING keys FOR ACTION Header~Resume,

      setOrderID FOR DETERMINE ON SAVE
        IMPORTING keys FOR Header~setOrderID,

*      setInitialStatus FOR DETERMINE ON MODIFY
*        IMPORTING keys FOR Header~setInitialStatus,

      setInitialStatus FOR DETERMINE ON MODIFY "SAVE
        IMPORTING keys FOR Header~setInitialStatus,

      validateCountryCode FOR VALIDATE ON SAVE
        IMPORTING keys FOR Header~validateCountryCode,

      validateDeliveryDate FOR VALIDATE ON SAVE
        IMPORTING keys FOR Header~validateDeliveryDate,

      validateEmailAddress FOR VALIDATE ON SAVE
        IMPORTING keys FOR Header~validateEmailAddress,

      cancelOrder FOR MODIFY
        IMPORTING keys FOR ACTION Header~cancelOrder RESULT result,

      reCalculateTotalPrice FOR MODIFY
        IMPORTING keys FOR ACTION Header~reCalculateTotalPrice,
      calculateTotalPrice FOR DETERMINE ON MODIFY
            IMPORTING keys FOR Header~calculateTotalPrice.

ENDCLASS.

CLASS lhc_Header IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        FIELDS ( OrderID
                 OrderStatus )
        WITH CORRESPONDING #( keys )
        RESULT DATA(headers).

* Disable update and delete buttons if status is delivered and status is only read
    result = VALUE #( FOR header IN headers ( %tky = header-%tky
                                              %field-OrderStatus  = COND #( WHEN header-OrderStatus EQ so_status-delivered OR header-OrderID IS INITIAL " OR header-OrderStatus IS INITIAL
                                                                            THEN if_abap_behv=>fc-f-read_only
                                                                            ELSE if_abap_behv=>fc-f-unrestricted )
                                              %assoc-_Items       = if_abap_behv=>fc-o-enabled
                                              %action-cancelOrder = COND #( WHEN header-OrderStatus EQ so_status-cancelled OR header-OrderStatus EQ so_status-delivered
                                                                            THEN if_abap_behv=>fc-o-disabled
                                                                            ELSE if_abap_behv=>fc-o-enabled )
                                              %update             = COND #( WHEN header-OrderStatus EQ so_status-delivered
                                                                            THEN if_abap_behv=>fc-o-disabled
                                                                            ELSE if_abap_behv=>fc-o-enabled )
                                              %delete             = COND #( WHEN header-OrderStatus EQ so_status-delivered
                                                                            THEN if_abap_behv=>fc-o-disabled
                                                                            ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD precheck_create.
*    me->precheck_auth( exporting entities_create = entities
*                       changing  failed          = failed-header
*                                 reported        = reported-header ).
  ENDMETHOD.

  METHOD precheck_update.
*  me->precheck_auth( exporting entities_update = entities
*                       changing  failed          = failed-header
*                                 reported        = reported-header ).
  ENDMETHOD.

  METHOD Resume.
  ENDMETHOD.

  METHOD setOrderID.
    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        FIELDS ( OrderID )
        WITH CORRESPONDING #( keys )
        RESULT DATA(headers).

    DELETE headers WHERE OrderID IS NOT INITIAL.
    IF headers IS NOT INITIAL.
      SELECT SINGLE FROM zr_header_0932
          FIELDS MAX( OrderID )
          INTO @DATA(max_order_id).

      MODIFY ENTITIES OF zr_header_0932 IN LOCAL MODE
          ENTITY Header
          UPDATE FIELDS ( OrderID )
          WITH VALUE #( FOR header IN headers INDEX INTO i ( %tky    = header-%tky
                                                             OrderID = max_order_id + 1 ) ).
    ENDIF.
  ENDMETHOD.

  METHOD setInitialStatus.
    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        FIELDS ( OrderStatus CurrencyCode )
        WITH CORRESPONDING #( keys )
        RESULT DATA(headers).

    DELETE headers WHERE OrderStatus IS NOT INITIAL.
    IF headers IS NOT INITIAL.
      MODIFY ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        UPDATE FIELDS ( OrderStatus CurrencyCode )
        WITH VALUE #( FOR header IN headers ( %tky         = header-%tky
                                              OrderStatus  = so_status-new
                                              CurrencyCode = 'USD' ) ).
    ENDIF.
  ENDMETHOD.

  METHOD validateCountryCode.
    DATA countries TYPE SORTED TABLE OF I_Country WITH UNIQUE KEY Country.  " DEFAULT KEY.

    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        FIELDS ( Country )
        WITH CORRESPONDING #( keys )
        RESULT DATA(headers).

    countries = CORRESPONDING #( headers DISCARDING DUPLICATES MAPPING Country = Country EXCEPT * ).
    DELETE countries WHERE Country IS INITIAL.
    IF countries IS NOT INITIAL.
* AVOID FOR ALL ENTRIES (it is possible with just 1 internal table)
      SELECT FROM I_Country AS db
        INNER JOIN @countries AS it ON db~Country EQ it~Country
        FIELDS db~Country
        INTO TABLE @DATA(valid_countries).
    ENDIF.

    LOOP AT headers INTO DATA(header).
      IF header-Country IS NOT INITIAL.

*        APPEND VALUE #( %tky = header-%tky ) TO failed-header.
*
*        APPEND VALUE #( %tky             = header-%tky
*                        %state_area      = 'VALID_COUNTRY'
*                        %msg             = new_message( id       = 'ZMC_ORDER_0932'
*                                                        number   = '003'
*                                                        severity = if_abap_behv_message=>severity-error )
*                        %element-Country = if_abap_behv=>mk-on ) TO reported-header.
*
*      ELSEIF NOT line_exists( valid_countries[ Country = header-Country ] ).
*        APPEND VALUE #( %tky = header-%tky ) TO failed-header.
*
*        APPEND VALUE #( %tky             = header-%tky
*                        %state_area      = 'VALID_COUNTRY'
*                        %msg             = new_message( id       = 'ZMC_ORDER_0932'
*                                                        number   = '004'
*                                                        severity = if_abap_behv_message=>severity-error )
*                        %element-Country = if_abap_behv=>mk-on ) TO reported-header.
        IF NOT line_exists( valid_countries[ Country = header-Country ] ).
          APPEND VALUE #( %tky = header-%tky ) TO failed-header.

          APPEND VALUE #( %tky             = header-%tky
                          %state_area      = 'VALID_COUNTRY'
                          %msg             = new_message( id       = 'ZMC_ORDER_0932'
                                                          number   = '003'
                                                          severity = if_abap_behv_message=>severity-error )
                          %element-Country = if_abap_behv=>mk-on ) TO reported-header.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateDeliveryDate.
    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        FIELDS ( PostingDate DeliveryDate )
        WITH CORRESPONDING #( keys )
        RESULT DATA(headers).

    LOOP AT headers INTO DATA(header).
      IF header-PostingDate IS NOT INITIAL AND header-DeliveryDate IS NOT INITIAL.
        IF header-DeliveryDate LT header-PostingDate.
          APPEND VALUE #( %tky = header-%tky ) TO failed-header.

          APPEND VALUE #( %tky             = header-%tky
                          %state_area      = 'DELIVERY_DATE'
                          %msg             = new_message( id       = 'ZMC_ORDER_0932'
                                                          number   = '004'
                                                          severity = if_abap_behv_message=>severity-error )
                          %element-DeliveryDate = if_abap_behv=>mk-on ) TO reported-header.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateEmailAddress.
    DATA:
      lv_email   TYPE string,
      lo_matcher TYPE REF TO cl_abap_matcher.

    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        FIELDS ( Email )
        WITH CORRESPONDING #( keys )
        RESULT DATA(headers).

    LOOP AT headers INTO DATA(header).
      IF header-Email IS INITIAL.
        APPEND VALUE #( %tky = header-%tky ) TO failed-header.

        APPEND VALUE #( %tky             = header-%tky
                        %state_area      = 'VALID_EMAIL'
                        %msg             = new_message( id       = 'ZMC_ORDER_0932'
                                                        number   = '001'
                                                        severity = if_abap_behv_message=>severity-error )
                        %element-Email = if_abap_behv=>mk-on ) TO reported-header.
      ELSE.
        IF NOT matches( val   = header-Email
*                        regex = `\w+(\.\w+)*@(\w+\.)+(([a-z]|[A-Z]){2,4})` )  ##REGEX_POSIX.
                        regex = `\w+(\.\w+)*@(\w+\.)+(\w{2,4})` )  ##REGEX_POSIX.
          APPEND VALUE #( %tky = header-%tky ) TO failed-header.

          APPEND VALUE #( %tky             = header-%tky
                          %state_area      = 'VALID_EMAIL'
                          %msg             = new_message( id       = 'ZMC_ORDER_0932'
                                                          number   = '002'
                                                          severity = if_abap_behv_message=>severity-error )
                          %element-Email = if_abap_behv=>mk-on ) TO reported-header.
        ENDIF.
      ENDIF.

*        lo_matcher = cl_abap_matcher=>create(
**                       pattern       = `\w+(\.\w+)*@\w+(\.\w+)*`
*                       pattern       = `\w+(\.\w+)*@(\w+\.)+(\w{2,4})`
*                       text          = header-Email
*                       ignore_case   = abap_true
*                     ).
    ENDLOOP.
  ENDMETHOD.

  METHOD cancelOrder.
    MODIFY ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        UPDATE FIELDS ( OrderStatus )
        WITH VALUE #( FOR key IN keys ( %tky        = key-%tky
                                        OrderStatus = so_status-cancelled ) ).

    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(headers).

    result = VALUE #( FOR header IN headers ( %tky   = header-%tky
                                              %param = header ) ).
  ENDMETHOD.

  METHOD reCalculateTotalPrice.
    TYPES:
      BEGIN OF ts_amnt_curr,
        amount   TYPE zr_header_0932-TotalPrice,
        currency TYPE zr_header_0932-CurrencyCode,
      END OF ts_amnt_curr,

      tt_amnt_curr TYPE STANDARD TABLE OF ts_amnt_curr.

    DATA lt_amnt_curr TYPE tt_amnt_curr.

    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        FIELDS ( TotalPrice CurrencyCode )
        WITH CORRESPONDING #( keys )
        RESULT DATA(headers).

    DELETE headers WHERE CurrencyCode IS INITIAL.

    LOOP AT headers ASSIGNING FIELD-SYMBOL(<header>).
      lt_amnt_curr = VALUE #( ( amount   = <header>-TotalPrice
                                currency = <header>-CurrencyCode ) ).

      " Read Items
      READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header BY \_Items
        FIELDS ( Price CurrencyCode Quantity )
        WITH VALUE #(  ( %tky = <header>-%tky ) )
        RESULT DATA(items).

      LOOP AT items ASSIGNING FIELD-SYMBOL(<item>).
        COLLECT VALUE ts_amnt_curr( amount   = <item>-Price * <item>-Quantity
                                    currency = <item>-CurrencyCode ) INTO lt_amnt_curr.
      ENDLOOP.

      CLEAR <header>-TotalPrice.
      " Set USD as default currency code in Sales Order Header
      "<header>-CurrencyCode = 'USD'.
      LOOP AT lt_amnt_curr INTO DATA(ls_amnt_curr).
        IF ls_amnt_curr-currency = <header>-CurrencyCode.
          <header>-TotalPrice += ls_amnt_curr-amount.
        ELSE.
          IF ls_amnt_curr-amount GT 0.
            /dmo/cl_flight_amdp=>convert_currency(
              EXPORTING
                iv_amount               = ls_amnt_curr-amount
                iv_currency_code_source = ls_amnt_curr-currency
                iv_currency_code_target = <header>-CurrencyCode
                iv_exchange_rate_date   = cl_abap_context_info=>get_system_date( )
              IMPORTING
                ev_amount               = DATA(total_price_items_curr)
            ).
            <header>-TotalPrice += total_price_items_curr.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        UPDATE FIELDS ( TotalPrice )
        WITH CORRESPONDING #( headers ).
  ENDMETHOD.

  METHOD calculateTotalPrice.
    MODIFY ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        EXECUTE reCalculateTotalPrice
        FROM CORRESPONDING #( keys ).
  ENDMETHOD.

ENDCLASS.
