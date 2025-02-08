@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS - Ventas Libro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_VENTAS_LIB_0932
  as select from ZV_CLNTS_LIB_0932
{
  key IdLibro,
      count(distinct(IdCliente)) as Vendido
}
group by
  IdLibro
