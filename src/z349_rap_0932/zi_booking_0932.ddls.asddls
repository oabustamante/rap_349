@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'Interface - Booking'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKING_0932
  as projection on ZR_BOOKING_0932
{
  key TravelId,
  key BookingId,
      BookingDate,
      CustomerId,
      CarrierId,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      BookingStatus,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LastChangedAt,

      _Travel            : redirected to parent ZI_TRAVEL_0932,
      _BookingSupplement : redirected to composition child ZI_BOOKSUPPL_0932,
      _Customer,
      _Carrier,
      _Connection
}
