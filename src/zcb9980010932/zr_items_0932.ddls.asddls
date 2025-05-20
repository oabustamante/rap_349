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

  association        to parent zr_header_0932 as _Header        on $projection.ParentUUID = _Header.OrderUUID

  association [1..1] to I_Currency            as _Currency      on $projection.CurrencyCode = _Currency.Currency
  association [1..1] to I_UnitOfMeasure       as _UnitOfMeasure on $projection.UnitOfMeasure = _UnitOfMeasure.UnitOfMeasure
{
  key item_uuid         as ItemUUID,
      parent_uuid       as ParentUUID,
      item_pos          as ItemPos,
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
      quantity          as Quantity,
      unit_of_measure   as UnitOfMeasure,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_on        as ChangedOn,
      // Associations
      _Header,
      _Currency,
      _UnitOfMeasure
}
