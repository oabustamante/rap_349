@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH Interface - Sales Order Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SO_STAT_VH_0932
  as select from zso_stat_0932
{
      @ObjectModel.text.element: [ 'Text' ]
  key status as Status,
      crit   as Criticality,
      text   as Text
}
