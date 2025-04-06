@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Sales Order: Items'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_items_0932
  as projection on zr_items_0932
{
  key id                as ID,
      name              as Name,
      description       as Description,
      release_date      as ReleaseDate,
      discontinued_date as DiscontinuedDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price             as Price,
      currency_code     as CurrencyCode,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      height            as Height,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      width             as Width,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      depth             as Depth,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      quantity          as Quantity,
      unit_of_measure   as UnitOfMeasure,
      /* Associations */
      _Header: redirected to parent zi_header_0932,
      _Currency,
      _UnitOfMeasure
}
