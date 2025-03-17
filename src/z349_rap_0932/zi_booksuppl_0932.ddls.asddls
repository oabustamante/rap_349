@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Booking Supplement'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKSUPPL_0932
  as projection on ZR_BOOKSUPPL_0932
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LastChangedAt,

      _Booking : redirected to parent ZI_BOOKING_0932,
      _Travel  : redirected to ZI_TRAVEL_0932,
      _Supplement,
      _SupplementText
}
