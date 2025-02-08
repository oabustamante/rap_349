@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS - Detalle Libro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_DET_LIBRO_0932
  as select from ztb_libros_0932
{
  key id_libro  as IdLibro,
  key bi_categ  as Categoria,
      titulo    as Titulo,
      autor     as Autor,
      editorial as Editorial,
      idioma    as Idioma,
      paginas   as Paginas,
      @Semantics.amount.currencyCode: 'Moneda'
      precio    as Precio,
      moneda    as Moneda,
      formato   as Formato,
      url       as Url
}
