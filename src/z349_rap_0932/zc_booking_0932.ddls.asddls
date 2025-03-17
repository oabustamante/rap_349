@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Booking'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata: {
    ignorePropagatedAnnotations: true,
    allowExtensions: true
}
define view entity ZC_BOOKING_0932
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
      @Semantics.currencyCode: true
      CurrencyCode,
      BookingStatus,
      LastChangedAt,
      /* Associations */
      _Travel            : redirected to parent ZC_TRAVEL_0932,
      _BookingSupplement : redirected to composition child zc_booksuppl_0932,
      _Carrier,
      _Connection,
      _Customer
}
