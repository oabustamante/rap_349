@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Sales Order: Items'
@Metadata: {
    ignorePropagatedAnnotations: true,
    allowExtensions: true
}
define view entity zc_items_0932
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
      @Semantics.currencyCode: true
      @Consumption.valueHelpDefinition: [ {
        entity: {
            name: 'I_CurrencyStdVH',
            element: 'Currency'
        },
        useForValidation: true
      }]
      CurrencyCode,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      Height,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      Width,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      Depth,
      @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
      Quantity,
      @Consumption.valueHelpDefinition: [ {
        entity: {
            name: 'I_UnitOfMeasureStdVH',
            element: 'UnitOfMeasure'
        },
        useForValidation: true
      }]
      UnitOfMeasure,
      @Semantics.systemDateTime.lastChangedAt: true
      ChangedOn,
      /* Associations */
      _Header : redirected to parent zc_header_0932,
      _Currency,
      _UnitOfMeasure
}
