CLASS lcl_buffer DEFINITION.
  PUBLIC SECTION.
    CONSTANTS:
      co_created TYPE c LENGTH 1 VALUE 'C',
      co_deleted TYPE c LENGTH 1 VALUE 'D',
      co_updated TYPE c LENGTH 1 VALUE 'U'.

    TYPES:
      BEGIN OF ts_buffer_master.
        INCLUDE TYPE zhcm_master_0932 AS data.
    TYPES:
        mode TYPE c LENGTH 1,
      END OF ts_buffer_master,

      tt_master TYPE SORTED TABLE OF ts_buffer_master WITH UNIQUE KEY e_number.

    CLASS-DATA mt_buffer_master TYPE tt_master.

ENDCLASS.

CLASS lhc_HCMMaster DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS:
      get_instance_authorizations FOR INSTANCE AUTHORIZATION
        IMPORTING keys REQUEST requested_authorizations FOR HCMMaster RESULT result,

*      get_global_authorizations FOR INSTANCE AUTHORIZATION
*        IMPORTING REQUEST

*      get_global_features FOR GLOBAL FEATURES
*        IMPORTING REQUEST requested_features FOR HCMMaster RESULT result,

      create FOR MODIFY IMPORTING entities FOR CREATE HCMMaster,

      update FOR MODIFY IMPORTING entities FOR UPDATE HCMMaster,

      delete FOR MODIFY IMPORTING keys     FOR DELETE HCMMaster,

      read   FOR READ   IMPORTING keys     FOR READ HCMMaster RESULT result,

      lock   FOR LOCK   IMPORTING keys     FOR LOCK HCMMaster.

ENDCLASS.

CLASS lhc_HCMMaster IMPLEMENTATION.

  METHOD get_instance_authorizations.

    DATA(lv_auth) = COND #( WHEN cl_abap_context_info=>get_user_technical_name(  ) EQ 'CB9980010932'
                                 THEN if_abap_behv=>auth-allowed
                                 ELSE if_abap_behv=>auth-unauthorized ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<ls_result>).
      <ls_result> = VALUE #( %key                           = <ls_key>-%key
                             %op-%update                    = lv_auth
                             %delete                        = lv_auth ).
    ENDLOOP.

  ENDMETHOD.

*  METHOD get_global_features.
*    result-%create = if_abap_behv=>fc-o-enabled.
*  ENDMETHOD.

  METHOD create.

    DATA(lv_uname) = cl_abap_context_info=>get_user_technical_name( ).  " sy-uname.
    GET TIME STAMP FIELD DATA(lv_time_stamp).

    SELECT MAX( e_number ) FROM zhcm_master_0932 INTO @DATA(lv_max_employee_number).

    LOOP AT entities INTO DATA(ls_entity).
      ls_entity-%data-crea_date_time = lv_time_stamp.
      ls_entity-%data-crea_uname     = lv_uname.
      ls_entity-%data-e_number       = lv_max_employee_number + 1.

      INSERT VALUE #( mode = lcl_buffer=>co_created
                      data = CORRESPONDING #( ls_entity-%data )
                    ) INTO TABLE lcl_buffer=>mt_buffer_master.
* Indicarle al framework lo que hemos mapeado
      IF NOT ls_entity-%cid IS INITIAL.
        INSERT VALUE #( %cid     = ls_entity-%cid
                        e_number = ls_entity-e_number
                      ) INTO TABLE mapped-hcmmaster.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD update.

    DATA(lv_uname) = cl_abap_context_info=>get_user_technical_name( ).  " sy-uname.
    GET TIME STAMP FIELD DATA(lv_time_stamp).

    LOOP AT entities INTO DATA(ls_entity).
      SELECT SINGLE * FROM zhcm_master_0932 WHERE e_number EQ @ls_entity-e_number
          INTO @DATA(ls_db).

      ls_entity-%data-lchg_date_time = lv_time_stamp.
      ls_entity-%data-lchg_uname     = lv_uname.

      INSERT VALUE #( mode = lcl_buffer=>co_updated
                      data = VALUE #( e_number       = ls_entity-e_number
                                      e_name         = COND #( WHEN ls_entity-%control-e_name EQ if_abap_behv=>mk-on
                                                       THEN ls_entity-%data-e_name
                                                       ELSE ls_db-e_name )
                                      e_department   = COND #( WHEN ls_entity-%control-e_department EQ if_abap_behv=>mk-on
                                                       THEN ls_entity-%data-e_department
                                                       ELSE ls_db-e_department )
                                      status         = COND #( WHEN ls_entity-%control-status EQ if_abap_behv=>mk-on
                                                       THEN ls_entity-%data-status
                                                       ELSE ls_db-status )
                                      job_title      = COND #( WHEN ls_entity-%control-job_title EQ if_abap_behv=>mk-on
                                                       THEN ls_entity-%data-job_title
                                                       ELSE ls_db-job_title )
                                      start_date     = COND #( WHEN ls_entity-%control-start_date EQ if_abap_behv=>mk-on
                                                       THEN ls_entity-%data-start_date
                                                       ELSE ls_db-start_date )
                                      end_date       = COND #( WHEN ls_entity-%control-end_date EQ if_abap_behv=>mk-on
                                                       THEN ls_entity-%data-end_date
                                                       ELSE ls_db-end_date )
                                      email          = COND #( WHEN ls_entity-%control-email EQ if_abap_behv=>mk-on
                                                       THEN ls_entity-%data-email
                                                       ELSE ls_db-email )
                                      m_number       = COND #( WHEN ls_entity-%control-m_number EQ if_abap_behv=>mk-on
                                                       THEN ls_entity-%data-m_number
                                                       ELSE ls_db-m_number )
                                      m_name         = COND #( WHEN ls_entity-%control-m_name EQ if_abap_behv=>mk-on
                                                       THEN ls_entity-%data-m_name
                                                       ELSE ls_db-m_name )
                                      m_department   = COND #( WHEN ls_entity-%control-m_department EQ if_abap_behv=>mk-on
                                                       THEN ls_entity-%data-m_department
                                                       ELSE ls_db-m_department )
                                      crea_date_time = ls_db-crea_date_time
                                      crea_uname     = ls_db-crea_uname
                                      lchg_date_time = ls_db-lchg_date_time
                                      lchg_uname     = ls_db-lchg_uname
                                    )
                    ) INTO TABLE lcl_buffer=>mt_buffer_master.
* Indicarle al framework lo que hemos mapeado
      IF NOT ls_entity-e_number IS INITIAL.
        INSERT VALUE #( %cid     = ls_entity-e_number
                        e_number = ls_entity-e_number
                      ) INTO TABLE mapped-hcmmaster.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD delete.

    LOOP AT keys INTO DATA(ls_key).
      INSERT VALUE #( mode = lcl_buffer=>co_deleted
                      data = VALUE #( e_number = ls_key-e_number )
                    ) INTO TABLE lcl_buffer=>mt_buffer_master.
* Informar al framework
      IF NOT ls_key-e_number IS INITIAL.
        INSERT VALUE #( %cid     = ls_key-%key-e_number
                        e_number = ls_key-%key-e_number
                      ) INTO TABLE mapped-hcmmaster.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZR_HCMMASTER_0932 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS:
      finalize          REDEFINITION,   " 3

      check_before_save REDEFINITION,   " 1

      save              REDEFINITION,   " 2

      cleanup           REDEFINITION,

      cleanup_finalize  REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_HCMMASTER_0932 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    DATA:
      lt_data_created TYPE STANDARD TABLE OF zhcm_master_0932,
      lt_data_updated TYPE STANDARD TABLE OF zhcm_master_0932,
      lt_data_deleted TYPE STANDARD TABLE OF zhcm_master_0932.

    lt_data_created = VALUE #( FOR <ls_row> IN lcl_buffer=>mt_buffer_master
                                    WHERE ( mode = lcl_buffer=>co_created )
                                    ( <ls_row>-data )
                             ).
    IF NOT lt_data_created IS INITIAL.
      INSERT zhcm_master_0932 FROM TABLE @lt_data_created.
    ENDIF.

    lt_data_updated = VALUE #( FOR <ls_row> IN lcl_buffer=>mt_buffer_master
                                    WHERE ( mode = lcl_buffer=>co_updated )
                                    ( <ls_row>-data )
                             ).
    IF NOT lt_data_updated IS INITIAL.
      UPDATE zhcm_master_0932 FROM TABLE @lt_data_updated.
    ENDIF.

    lt_data_deleted = VALUE #( FOR <ls_row> IN lcl_buffer=>mt_buffer_master
                                    WHERE ( mode = lcl_buffer=>co_deleted )
                                    ( <ls_row>-data )
                             ).
    IF NOT lt_data_deleted IS INITIAL.
      DELETE zhcm_master_0932 FROM TABLE @lt_data_deleted.
    ENDIF.

    CLEAR lcl_buffer=>mt_buffer_master.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
