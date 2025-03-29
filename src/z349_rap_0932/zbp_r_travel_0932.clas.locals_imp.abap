CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS:
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR Travel RESULT result,

      get_instance_authorizations FOR INSTANCE AUTHORIZATION
        IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result,

      acceptTravel FOR MODIFY
        IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result,

      createTravelByTemplate FOR MODIFY
        IMPORTING keys FOR ACTION Travel~createTravelByTemplate RESULT result,

      rejectTravel FOR MODIFY
        IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result,

      validateCustomer FOR VALIDATE ON SAVE IMPORTING keys FOR Travel~validateCustomer,

      validateDates    FOR VALIDATE ON SAVE IMPORTING keys FOR Travel~validateDates,

      validateStatus   FOR VALIDATE ON SAVE IMPORTING keys FOR Travel~validateStatus.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zr_travel_0932 "IN LOCAL MODE
        ENTITY Travel
        FIELDS (  TravelId OverallStatus )
        WITH VALUE #( FOR key_row_read IN keys ( %key = key_row_read-%key ) )
        RESULT DATA(lt_travel_result).

    result = VALUE #( FOR ls_travel IN lt_travel_result (
                        %key                 = ls_travel-%key
                        %field-TravelId      = if_abap_behv=>fc-f-read_only
                        %field-OverallStatus = if_abap_behv=>fc-f-read_only
                        %assoc-_Booking      = if_abap_behv=>fc-o-enabled   " Corrección a bugs en la navegación
                        %action-acceptTravel = COND #( WHEN ls_travel-OverallStatus = 'A'
                                                            THEN if_abap_behv=>fc-o-disabled
                                                            ELSE if_abap_behv=>fc-o-enabled )
                        %action-rejectTravel = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                            THEN if_abap_behv=>fc-o-disabled
                                                            ELSE if_abap_behv=>fc-o-enabled )
                        ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
    DATA(lv_auth) = COND #( WHEN cl_abap_context_info=>get_user_technical_name(  ) EQ 'CB9980010932'
                                 THEN if_abap_behv=>auth-allowed
                                 ELSE if_abap_behv=>auth-unauthorized ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<ls_result>).
      <ls_result> = VALUE #( %key                           = <ls_key>-%key
                             %op-%update                    = lv_auth
                             %delete                        = lv_auth
                             %action-acceptTravel           = lv_auth
                             %action-rejectTravel           = lv_auth
                             %action-createTravelByTemplate = lv_auth
                             %assoc-_Booking                = lv_auth ).
    ENDLOOP.
  ENDMETHOD.

  METHOD acceptTravel.
    " Modify in local mode - BO related updates there are not relevant for authorization objects
    MODIFY ENTITIES OF zr_travel_0932 IN LOCAL MODE
        ENTITY Travel
        UPDATE FIELDS ( OverallStatus )
        WITH VALUE #( FOR key_row_mod IN keys ( TravelId      = key_row_mod-TravelId
                                                OverallStatus = 'A' ) )
        FAILED failed
        REPORTED reported.

    READ ENTITIES OF zr_travel_0932 IN LOCAL MODE
        ENTITY Travel
        FIELDS ( AgencyId
                 CustomerId
                 BeginDate
                 EndDate
                 BookingFee
                 TotalPrice
                 CurrencyCode
                 OverallStatus
                 Description
                 CreatedBy
                 CreatedAt
                 LastChangedBy
                 LastChangedAt )
         WITH VALUE #( FOR key_row_rea IN keys ( TravelId = key_row_rea-TravelId ) )
         RESULT DATA(lt_travel).
    result = VALUE #( FOR ls_travel IN lt_travel ( TravelId = ls_travel-TravelId
                                                   %param   = ls_Travel ) ).
    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      DATA(lv_travelId) = <ls_travel>-TravelId.
      SHIFT lv_travelId LEFT DELETING LEADING '0'.
      APPEND VALUE #( TravelId            = <ls_travel>-TravelId
                        %msg                = new_message( id       = 'ZMC_TRAVEL_0932'
                                                           number   = '005'
                                                           v1       = lv_travelId
                                                           severity = if_abap_behv_message=>severity-success )
                        %element-CustomerId = if_abap_behv=>mk-on
                      ) TO reported-travel.
    ENDLOOP.
  ENDMETHOD.

  METHOD createTravelByTemplate.
    " Opt 1
    READ ENTITIES OF zr_travel_0932 ENTITY Travel
        FIELDS (  TravelId AgencyId CustomerId BookingFee TotalPrice CurrencyCode )
        WITH VALUE #( FOR row_key IN keys ( %key = row_key-%key ) )
        RESULT DATA(lt_entity_travel)
        FAILED failed
        REPORTED reported.

*    " Opt 2
*    READ ENTITY zr_travel_0932
*        FIELDS (  TravelId AgencyId CustomerId BookingFee TotalPrice CurrencyCode )
*        WITH VALUE #( FOR row_key IN keys ( %key = row_key-%key ) )
*        RESULT lt_entity_travel
*        FAILED failed
*        REPORTED reported.

    DATA lt_create_travel TYPE TABLE FOR CREATE zr_travel_0932\\Travel.

    DATA(lv_today) = cl_abap_context_info=>get_system_date(  ).

    SELECT MAX( travel_id ) FROM ztb_travel_0932 INTO @DATA(lv_travel_id).


    lt_create_travel = VALUE #( FOR create_row IN lt_entity_travel INDEX INTO idx
                        (
                            TravelId      = lv_travel_id + idx
                            AgencyId      = create_row-AgencyId
                            CustomerId    = create_row-CustomerId
                            BeginDate     = lv_today
                            EndDate       = lv_today + 30
                            BookingFee    = create_row-BookingFee
                            TotalPrice    = create_row-TotalPrice
                            CurrencyCode  = create_row-CurrencyCode
                            Description   = 'Add comments'
                            OverallStatus = 'O' ) ).
    MODIFY ENTITIES OF zr_travel_0932
        IN LOCAL MODE ENTITY Travel
        CREATE FIELDS (
            TravelId
            AgencyId
            CustomerId
            BeginDate
            EndDate
            BookingFee
            TotalPrice
            CurrencyCode
            Description
            OverallStatus
        )
        WITH lt_create_travel
        MAPPED mapped
        FAILED failed
        REPORTED reported.

    result = VALUE #( FOR result_row IN lt_create_travel INDEX INTO idx
             (
                %cid_ref = keys[ idx ]-%cid_ref
                %key     = keys[ idx ]-%key
                %param   = CORRESPONDING #( result_row ) ) ).

  ENDMETHOD.

  METHOD rejectTravel.
    " Modify in local mode - BO related updates there are not relevant for authorization objects
    MODIFY ENTITIES OF zr_travel_0932 IN LOCAL MODE
        ENTITY Travel
        UPDATE FIELDS ( OverallStatus )
        WITH VALUE #( FOR key_row_mod IN keys ( TravelId      = key_row_mod-TravelId
                                                OverallStatus = 'X' ) )
        FAILED failed
        REPORTED reported.

    READ ENTITIES OF zr_travel_0932 IN LOCAL MODE
        ENTITY Travel
        FIELDS ( AgencyId
                 CustomerId
                 BeginDate
                 EndDate
                 BookingFee
                 TotalPrice
                 CurrencyCode
                 OverallStatus
                 Description
                 CreatedBy
                 CreatedAt
                 LastChangedBy
                 LastChangedAt )
         WITH VALUE #( FOR key_row_rea IN keys ( TravelId = key_row_rea-TravelId ) )
         RESULT DATA(lt_travel).
    result = VALUE #( FOR ls_travel IN lt_travel ( TravelId = ls_travel-TravelId
                                                   %param   = ls_Travel ) ).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      DATA(lv_travelId) = <ls_travel>-TravelId.
      SHIFT lv_travelId LEFT DELETING LEADING '0'.
      APPEND VALUE #( TravelId            = <ls_travel>-TravelId
                        %msg                = new_message( id       = 'ZMC_TRAVEL_0932'
                                                           number   = '006'
                                                           v1       = lv_travelId
                                                           severity = if_abap_behv_message=>severity-warning )
                        %element-CustomerId = if_abap_behv=>mk-on
                      ) TO reported-travel.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCustomer.
    READ ENTITIES OF zr_travel_0932 IN LOCAL MODE
        ENTITY Travel
        FIELDS ( CustomerId )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel).

    DATA lt_customer TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    lt_customer = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId EXCEPT * ). " Quita duplicados e ignora los demás campos

    DELETE lt_customer WHERE customer_id IS INITIAL.

    SELECT FROM /dmo/customer FIELDS customer_id
        FOR ALL ENTRIES IN @lt_customer
        WHERE customer_id EQ @lt_customer-customer_id
        INTO TABLE @DATA(lt_customer_db).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      IF <ls_travel>-CustomerId IS INITIAL OR
        NOT line_exists( lt_customer_db[ customer_id = <ls_travel>-CustomerId ] ).
        APPEND VALUE #( TravelId            = <ls_travel>-TravelId ) TO failed-travel.
        APPEND VALUE #( TravelId            = <ls_travel>-TravelId
                        %msg                = new_message( id       = 'ZMC_TRAVEL_0932'
                                                           number   = '001'
                                                           v1       = <ls_travel>-CustomerId
                                                           severity = if_abap_behv_message=>severity-error )
                        %element-CustomerId = if_abap_behv=>mk-on
                      ) TO reported-travel.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateDates.
    READ ENTITY zr_travel_0932\\Travel
        FIELDS ( BeginDate EndDate )
        WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
        RESULT DATA(lt_travel_result).

    LOOP AT lt_travel_result INTO DATA(ls_travel_result).
      IF ls_travel_result-EndDate LT ls_travel_result-BeginDate.
        APPEND VALUE #( %key    = ls_travel_result-%key
                        TravelId = ls_travel_result-TravelId ) TO failed-travel.

        APPEND VALUE #( %key               = ls_travel_result-%key
                        %msg               = new_message( id       = 'ZMC_TRAVEL_0932'
                                                          number   = '003'
                                                          v1       = ls_travel_result-BeginDate
                                                          v2       = ls_travel_result-EndDate
                                                          v3       = ls_travel_result-TravelId
                                                          severity = if_abap_behv_message=>severity-error )
                        %element-BEginDate = if_abap_behv=>mk-on
                        %element-EndDate   = if_abap_behv=>mk-on ) TO reported-travel.
      ELSEIF ls_travel_result-BeginDate < cl_abap_context_info=>get_system_date(  ).
        APPEND VALUE #( %key    = ls_travel_result-%key
                        TravelId = ls_travel_result-TravelId ) TO failed-travel.

        APPEND VALUE #( %key               = ls_travel_result-%key
                        %msg               = new_message( id       = 'ZMC_TRAVEL_0932'
                                                          number   = '002'
                                                          v1       = ls_travel_result-BeginDate
                                                          severity = if_abap_behv_message=>severity-error )
                        %element-BEginDate = if_abap_behv=>mk-on
                        %element-EndDate   = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateStatus.
    READ ENTITIES OF zr_travel_0932 IN LOCAL MODE
        ENTITY Travel
        FIELDS ( OverallStatus )
        WITH VALUE #( FOR <row_key> IN keys ( %key = <row_key>-%key ) )
        RESULT DATA(lt_travel_result).

    LOOP AT lt_travel_result ASSIGNING FIELD-SYMBOL(<ls_travel_result>).
      CASE <ls_travel_result>-OverallStatus.
        WHEN 'O'.
        WHEN 'X'.
        WHEN 'A'.
        WHEN OTHERS.
          APPEND VALUE #( %key    = <ls_travel_result>-%key ) TO failed-travel.

          APPEND VALUE #( %key                   = <ls_travel_result>-%key
                          %msg                   = new_message( id       = 'ZMC_TRAVEL_0932'
                                                                number   = '004'
                                                                v1       = <ls_travel_result>-OverallStatus
                                                                severity = if_abap_behv_message=>severity-success )
                          %element-OverallStatus = if_abap_behv=>mk-on ) TO reported-travel.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZR_TRAVEL_0932 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    CONSTANTS:
      co_create TYPE string VALUE 'CREATE',
      co_update TYPE string VALUE 'UPDATE',
      co_delete TYPE string VALUE 'DELETE'.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_TRAVEL_0932 IMPLEMENTATION.

  METHOD save_modified.
*  with additional save/ with unmanaged en la entidad del behavior

    DATA:
      lt_log     TYPE STANDARD TABLE OF ztb_log_0932,
      lt_log_upd TYPE STANDARD TABLE OF ztb_log_0932.

    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    IF NOT create-travel IS INITIAL.
*      lt_log = CORRESPONDING #( create-travel ).
      lt_log = VALUE #( FOR <ls_travel_ins> IN create-travel ( travel_id = <ls_travel_ins>-TravelId ) ).
      LOOP AT lt_log ASSIGNING FIELD-SYMBOL(<ls_log>).
        GET TIME STAMP FIELD <ls_log>-created_at.
        <ls_log>-changing_operation = lsc_ZR_TRAVEL_0932=>co_create.
        READ TABLE create-travel WITH TABLE KEY entity COMPONENTS TravelId = <ls_log>-travel_id
            INTO DATA(ls_travel).
        IF ls_travel-%control-BookingFee EQ cl_abap_behv=>flag_changed.
          <ls_log>-changed_field_name = 'booking_fee'.
          <ls_log>-changed_value      = ls_travel-BookingFee.
          <ls_log>-user_mod           = lv_user.
          TRY.
              <ls_log>-change_id      = cl_system_uuid=>create_uuid_x16_static( ).
            CATCH cx_uuid_error.
          ENDTRY.
          APPEND <ls_log> TO lt_log_upd.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF NOT update-travel IS INITIAL.
      "lt_log = CORRESPONDING #( update-travel ).
      lt_log = VALUE #( FOR <ls_travel_upd> IN update-travel ( travel_id = <ls_travel_upd>-TravelId ) ).
      LOOP AT update-travel INTO DATA(ls_update_travel).
        ASSIGN lt_log[ travel_id = ls_update_travel-TravelId ] TO FIELD-SYMBOL(<ls_log_upd>).

        GET TIME STAMP FIELD <ls_log_upd>-created_at.
        <ls_log_upd>-changing_operation   = lsc_ZR_TRAVEL_0932=>co_update.
        IF ls_update_travel-%control-CustomerId EQ cl_abap_behv=>flag_changed.
          <ls_log_upd>-changed_field_name = 'customer_id'.
          <ls_log_upd>-changed_value      = ls_update_travel-CustomerId.
          <ls_log_upd>-user_mod           = lv_user.
          TRY.
              <ls_log_upd>-change_id      = cl_system_uuid=>create_uuid_x16_static( ).
            CATCH cx_uuid_error.
          ENDTRY.
          APPEND <ls_log_upd> TO lt_log_upd.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF NOT delete-travel IS INITIAL.
*      lt_log = CORRESPONDING #( delete-travel ).
      lt_log = VALUE #( FOR <ls_travel_del> IN delete-travel ( travel_id = <ls_travel_del>-TravelId ) ).
      LOOP AT lt_log ASSIGNING FIELD-SYMBOL(<ls_log_del>).
        GET TIME STAMP FIELD <ls_log_del>-created_at.
        <ls_log_del>-changing_operation = lsc_ZR_TRAVEL_0932=>co_delete.
        <ls_log_del>-user_mod           = lv_user.
        TRY.
            <ls_log_del>-change_id      = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_uuid_error.
        ENDTRY.
        APPEND <ls_log_del> TO lt_log_upd.
      ENDLOOP.
    ENDIF.
    IF NOT lt_log_upd IS INITIAL.
      INSERT ztb_log_0932 FROM TABLE @lt_log_upd.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
