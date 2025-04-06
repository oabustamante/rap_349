@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Sales Order: Items'
@Metadata: {
    ignorePropagatedAnnotations: true,
    allowExtensions: true
}
define view entity zc_items_0932
  as projection on zr_items_0932
{
  key id                as ID,
      name              as Name,
      description       as Description,
      release_date      as ReleaseDate,
      discontinued_date as DiscontinuedDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price             as Price,
      @Semantics.currencyCode: true
      @Consumption.valueHelpDefinition: [ {
        entity: {
            name: 'I_CurrencyStdVH',
            element: 'Currency'
        },
        useForValidation: true
      }]
      currency_code     as CurrencyCode,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      height            as Height,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      width             as Width,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      depth             as Depth,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      quantity          as Quantity,
      @Consumption.valueHelpDefinition: [ {
        entity: {
            name: 'I_UnitOfMeasureStdVH',
            element: 'UnitOfMeasure'
        },
        useForValidation: true
      }]
      unit_of_measure   as UnitOfMeasure,
      /* Associations */
      _Header : redirected to parent zc_header_0932,
      _Currency,
      _UnitOfMeasure
}
