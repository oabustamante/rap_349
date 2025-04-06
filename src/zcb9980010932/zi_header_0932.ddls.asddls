@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Sales Order: Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_header_0932
  provider contract transactional_interface
  as projection on zr_header_0932
{
  key id             as ID,
      email          as Email,
      first_name     as FirstName,
      last_name      as LastName,
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
      _Items : redirected to composition child zi_items_0932,
      _Country
}
