CLASS lhc_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Header RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Header RESULT result.

    METHODS Resume FOR MODIFY
      IMPORTING keys FOR ACTION Header~Resume.

    METHODS setDocumentID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Header~setDocumentID.

    METHODS setInitialStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR Header~setInitialStatus.

*    METHODS releaseOrder.


    METHODS validateCountryCode FOR VALIDATE ON SAVE
      IMPORTING keys FOR Header~validateCountryCode.

    METHODS validateDeliveryDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Header~validateDeliveryDate.

    METHODS validateEmailAddress FOR VALIDATE ON SAVE
      IMPORTING keys FOR Header~validateEmailAddress.

ENDCLASS.

CLASS lhc_Header IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD Resume.
  ENDMETHOD.

  METHOD setDocumentID.
  ENDMETHOD.

  METHOD setInitialStatus.
  ENDMETHOD.

  METHOD validateCountryCode.
  ENDMETHOD.

  METHOD validateDeliveryDate.
  ENDMETHOD.

  METHOD validateEmailAddress.
  ENDMETHOD.

ENDCLASS.
