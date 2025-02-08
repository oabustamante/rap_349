@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS - Libro Clientes'
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
define view entity ZV_LIB_CLNTS_0932
  as select from ZV_CLNTS_LIB_0932 as ClienteLibro
  association [0..*] to ZV_DET_CLIENTE_0932 as _DetalleCliente on $projection.IdCliente = _DetalleCliente.IdCliente
{
  key IdLibro,
  key IdCliente,

      _DetalleCliente.Nombre,
      _DetalleCliente.Apellidos,
      _DetalleCliente.Email,
      _DetalleCliente.Url
      //_DetalleCliente
}
