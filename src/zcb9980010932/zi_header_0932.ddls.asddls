@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Sales Order: Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_header_0932
  provider contract transactional_interface // Create, Update, Delete
  as projection on zr_header_0932
{
  key  OrderUUID,
       OrderID,
       Email,
       FirstName,
       LastName,
       Country,
       PostingDate,
       DeliveryDate,
       OrderStatus,
       ImageURL,
       @Semantics.amount.currencyCode: 'CurrencyCode'
       TotalPrice,
       CurrencyCode,
       @Semantics.systemDateTime.createdAt: true
       CreatedOn,
       @Semantics.user.createdBy: true
       CreatedBy,
       @Semantics.systemDateTime.lastChangedAt: true
       ChangedOn,
       @Semantics.user.lastChangedBy: true
       ChangedBy,
       /* Associations */
       _Items : redirected to composition child zi_items_0932,
       _Status,
       _Country,
       _Currency
}
