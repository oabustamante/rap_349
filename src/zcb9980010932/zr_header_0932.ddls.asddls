@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root - Sales Order: Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zr_header_0932
  as select from zso_header_0932 as Header

  composition [0..*] of zr_items_0932 as _Items

  association [1..1] to I_Country     as _Country on $projection.country = _Country.Country
{
  key id,
      email,
      first_name,
      last_name,
      country,
      delivery_date,
      order_status,
      image_url,
      // Audit fields
      @Semantics.systemDateTime.createdAt: true
      crea_date_time,
      @Semantics.user.createdBy: true
      crea_uname,
      @Semantics.systemDateTime.lastChangedAt: true
      lchg_date_time,
      @Semantics.user.lastChangedBy: true
      lchg_uname,

      _Items, // Make association public
      _Country
}
