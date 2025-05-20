@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root - Sales Order: Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zr_header_0932
  as select from zso_header_0932 as Header

  composition [0..*] of zr_items_0932 as _Items

  association [1..1] to ZI_SO_STAT_VH_0932 as _Status on $projection.OrderStatus = _Status.Status
  association [0..1] to I_Country     as _Country  on $projection.Country = _Country.Country
  association [1..1] to I_Currency    as _Currency on $projection.CurrencyCode = _Currency.Currency
{
  key    order_uuid     as OrderUUID,
         id             as OrderID,
         email          as Email,
         first_name     as FirstName,
         last_name      as LastName,
         country        as Country,
         posting_date   as PostingDate,
         delivery_date  as DeliveryDate,
         order_status   as OrderStatus,
         image_url      as ImageURL,
         @Semantics.amount.currencyCode: 'CurrencyCode'
         total_price    as TotalPrice,
         currency_code  as CurrencyCode,
         // Audit fields
         @Semantics.systemDateTime.createdAt: true
         crea_date_time as CreatedOn,
         @Semantics.user.createdBy: true
         crea_uname     as CreatedBy,
         @Semantics.systemDateTime.lastChangedAt: true
         lchg_date_time as ChangedOn,
         @Semantics.user.lastChangedBy: true
         lchg_uname     as ChangedBy,

         _Items, // Make association public
         _Status,
         _Country,
         _Currency
}
