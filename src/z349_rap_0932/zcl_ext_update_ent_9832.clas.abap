CLASS zcl_ext_update_ent_9832 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_ext_update_ent_9832 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    MODIFY ENTITIES OF zr_travel_0932
        ENTITY Travel
        UPDATE FIELDS ( AgencyId Description )
        WITH VALUE #( ( TravelId = '00000057'
                        AgencyId = '070033'
                        Description = 'New External Update' ) )
        FAILED DATA(failed)
        REPORTED DATA(reported).

    READ ENTITIES OF zr_travel_0932
       ENTITY Travel
       FIELDS ( AgencyId Description )
       WITH VALUE #( ( TravelId = '00000057' ) )
       RESULT DATA(lt_result_data)
       FAILED failed
       REPORTED reported.

    COMMIT ENTITIES.
    IF failed IS INITIAL.
      out->write( 'Commit Succesfull' ).
    ELSE.
      out->write( 'Commit Failed' ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
