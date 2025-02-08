@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS - Acceso a cateorías'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_ACC_CATEG_0932
  as select from ztb_acccate_0932
{
  key bi_categ    as Categoria,
  key tipo_acceso as TipoAcceso
}
