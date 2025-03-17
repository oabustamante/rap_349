@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS - Avisos'
@Metadata: {
    ignorePropagatedAnnotations: true,
    allowExtensions: true
}
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_VIQMEL_0932
  as select from ztb_viqmel_0932 as Aviso
  association [1] to zv_tq80_0932 as _ClsAviso on $projection.ClaseAviso = _ClsAviso.ClaseAviso
  association [1] to ZV_T024I_0932 as _GpoPlan on $projection.GrupoPlan = _GpoPlan.GrupoPlan
{
  key qmnum      as NumeroAviso,
      qmart      as ClaseAviso,
      qmtxt      as Descripcion,
      qmdat      as FechaAviso,
      qmgrp      as GpoCodigo,
      qmcod      as Codificacion,
      ingrp      as GrupoPlan,
      street     as Calle,
      house_num1 as Numero,
      str_suppl3 as EntreCalles,
      city2      as Distrito,
      post_code1 as CodigoPostal,
      city1      as Poblacion,
      location   as Calle5,
      
      _ClsAviso,
      _GpoPlan
}
