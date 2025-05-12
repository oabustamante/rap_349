@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root - Sales Order: Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zr_header_0932
  as select from zso_header_0932 as Header

  composition [0..*] of zr_items_0932 as _Items

  association [0..1] to I_Country     as _Country  on $projection.Country = _Country.Country
  association [1..1] to I_Currency    as _Currency on $projection.CurrencyCode = _Currency.Currency
{
  key id             as ID,
      email          as Email,
      first_name     as FirstName,
      last_name      as LastName,
      country        as Country,
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
      _Country,
      _Currency
}
