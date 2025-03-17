@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Booking Supplement'
@Metadata: {
    ignorePropagatedAnnotations: true,
    allowExtensions: true
}
define view entity zc_booksuppl_0932
  as projection on ZR_BOOKSUPPL_0932 // antes I
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      SupplementId,
      _SupplementText.Description as SupplementDesc : localized, // Descripción según Idioma
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      @Semantics.currencyCode: true
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Travel  : redirected to ZC_TRAVEL_0932,
      _Booking : redirected to parent ZC_BOOKING_0932,
      _Supplement,
      _SupplementText
}
