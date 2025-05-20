CLASS lhc_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF so_status,
        cancelled TYPE int1 VALUE '250',
        completed TYPE int1 VALUE '200',
        open      TYPE int1 VALUE '100',
        partially TYPE int1 VALUE '150',
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

      setInitialStatus FOR DETERMINE ON SAVE
        IMPORTING keys FOR Header~setInitialStatus,

      validateCountryCode FOR VALIDATE ON SAVE
        IMPORTING keys FOR Header~validateCountryCode,

      validateDeliveryDate FOR VALIDATE ON SAVE
        IMPORTING keys FOR Header~validateDeliveryDate,

      validateEmailAddress FOR VALIDATE ON SAVE
        IMPORTING keys FOR Header~validateEmailAddress.

ENDCLASS.

CLASS lhc_Header IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        FIELDS ( OrderStatus )
        WITH CORRESPONDING #( keys )
        RESULT DATA(headers).

*    result = VALUE #( FOR header IN headers ( %tky = header-%tky
*                                              %field-OrderStatus = COND #( WHEN header-OrderStatus = so_status-completed
*                                                                           THEN if_abap_behv=>fc-f-read_only
*                                                                           ELSE if_abap_behv=>fc-f-unrestricted ) ) ).

    result = VALUE #( FOR header IN headers ( %tky = header-%tky
                                              %field-OrderStatus = COND #( WHEN header-OrderStatus EQ so_status-completed OR header-OrderStatus IS INITIAL
                                                                           THEN if_abap_behv=>fc-f-read_only
                                                                           ELSE if_abap_behv=>fc-f-unrestricted )
                                              %update            = COND #( WHEN header-OrderStatus EQ so_status-completed
                                                                           THEN if_abap_behv=>fc-o-disabled
                                                                           ELSE if_abap_behv=>fc-o-enabled )
                                              %delete            = COND #( WHEN header-OrderStatus EQ so_status-completed
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
        FIELDS ( OrderStatus )
        WITH CORRESPONDING #( keys )
        RESULT DATA(headers).

    DELETE headers WHERE OrderStatus IS NOT INITIAL.
    IF headers IS NOT INITIAL.
      MODIFY ENTITIES OF zr_header_0932 IN LOCAL MODE
        ENTITY Header
        UPDATE FIELDS ( OrderStatus )
        WITH VALUE #( FOR header IN headers ( %tky        = header-%tky
                                              OrderStatus = so_status-open ) ).
    ENDIF.
  ENDMETHOD.

*  METHOD deductDiscount.
*  ENDMETHOD.

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

ENDCLASS.
