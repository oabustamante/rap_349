@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS - Listado de Libros'
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
define view entity ZV_LST_LIBROS_0932
  as select from ZV_DET_LIBRO_0932 as Libros
  left outer join ZV_VENTAS_LIB_0932 as _VentaLibro on _VentaLibro.IdLibro = Libros.IdLibro
  association [1] to ZV_CATEGO_0932 as _Categoria on $projection.Categoria = _Categoria.Categoria
  //association [0..*] to ZV_DET_LIBRO_0932 as _DetalleLibro on Libros.IdLibro = _DetalleLibro.IdLibro
  //association [0..*] to ZV_VENTAS_LIB_0932 as _VentaLibro on $projection.IdLibro = _VentaLibro.IdLibro
  association [0..*] to ZV_LIB_CLNTS_0932 as _LibroCliente on $projection.IdLibro = _LibroCliente.IdLibro
{
  key Libros.IdLibro as IdLibro,
  key Libros.Categoria as Categoria,
      Libros.Titulo as Titulo,
      Libros.Autor as Autor,
      Libros.Editorial as Editorial,
      Libros.Idioma as Idioma,
      Libros.Paginas as Paginas,
      @Semantics.amount.currencyCode: 'Moneda'
      Libros.Precio as Precio,
      Libros.Moneda as Moneda,
      
      //_VentaLibro.Vendido as Vendido,
      
      case
      when _VentaLibro.Vendido < 1 then 0
      when _VentaLibro.Vendido = 1 then 1
      when _VentaLibro.Vendido = 2 then 2
      when _VentaLibro.Vendido >= 3 then 3
      else 0
      end as Ventas,
      
      '' as Estado,
      
      Libros.Formato as Formato,
      Libros.Url as Url,
      
      _Categoria.Descripcion,
      _LibroCliente
}
