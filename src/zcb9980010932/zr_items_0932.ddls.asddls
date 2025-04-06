@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root - Sales Order: Items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zr_items_0932
  as select from zso_items_0932 as Items

  association        to parent zr_header_0932 as _Header        on $projection.id = _Header.id

  association [1..1] to I_Currency            as _Currency      on $projection.currency_code = _Currency.Currency
  association [1..1] to I_UnitOfMeasure       as _UnitOfMeasure on $projection.unit_of_measure = _UnitOfMeasure.UnitOfMeasure
{
  key id,
      name,
      description,
      release_date,
      discontinued_date,
      @Semantics.amount.currencyCode: 'currency_code'
      price,
      currency_code,
      @Semantics.quantity.unitOfMeasure: 'unit_of_measure'
      height,
      @Semantics.quantity.unitOfMeasure: 'unit_of_measure'
      width,
      @Semantics.quantity.unitOfMeasure: 'unit_of_measure'
      depth,
      quantity,
      unit_of_measure,
      // Associations
      _Header,
      _Currency,
      _UnitOfMeasure
}
