@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS - Detalle Cliente'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata: {
    ignorePropagatedAnnotations: true,
    allowExtensions: true
}
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_DET_CLIENTE_0932
  as select from ztb_cltes_0932
{
  key id_cliente  as IdCliente,
  key tipo_acceso as TipoAcceso,
      nombre      as Nombre,
      apellidos   as Apellidos,
      email       as Email,
      url         as Url
}
