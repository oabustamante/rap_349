@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Sales Order: Header'
@Metadata: {
    ignorePropagatedAnnotations: true,
    allowExtensions: true
}
define root view entity zc_header_0932
  provider contract transactional_query
  as projection on zr_header_0932
{
  key id             as ID,
      email          as Email,
      first_name     as FirstName,
      last_name      as LastName,
      @Consumption.valueHelpDefinition: [ {
        entity: {
            name: 'I_CountryVH',
            element: 'Country'
        },
        useForValidation: true
      }]
      country        as Country,
      delivery_date  as DeliveryDate,
      order_status   as OrderStatus,
      image_url      as ImageURL,
      @Semantics.systemDateTime.createdAt: true
      crea_date_time as CreatedOn,
      @Semantics.user.createdBy: true
      crea_uname     as CreatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      lchg_date_time as ChangedOn,
      @Semantics.user.lastChangedBy: true
      lchg_uname     as ChangedBy,
      /* Associations */
      _Items : redirected to composition child zc_items_0932,
      _Country
}
