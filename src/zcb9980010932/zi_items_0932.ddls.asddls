@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Sales Order: Items'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_items_0932
  as projection on zr_items_0932
{
  key ID,
  key ItemPos,
      Name,
      Description,
      ReleaseDate,
      DiscontinuedDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      Height,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      Width,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      Depth,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      Quantity,
      UnitOfMeasure,
      @Semantics.systemDateTime.lastChangedAt: true
      ChangedOn,
      /* Associations */
      _Header : redirected to parent zi_header_0932,
      _Currency,
      _UnitOfMeasure
}
