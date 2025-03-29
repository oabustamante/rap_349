@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Booking'
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
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'CustomerName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer_StdVH',
                                                     element: 'CustomerID'},
                                           useForValidation: true }]
      CustomerId,
      _Customer.LastName        as CustomerNAme,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'CarrierName' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Flight_StdVH',
                                                     element: 'AirlineID'},
                                           additionalBinding: [{ localElement: 'FlightDate',
                                                                 element: 'FlightDate',
                                                                 usage: #RESULT },

                                                               { localElement: 'ConnectionId',
                                                                 element: 'ConnectionID',
                                                                 usage: #RESULT },

                                                               { localElement: 'FlightPrice',
                                                                 element: 'Price',
                                                                 usage: #RESULT },

                                                               { localElement: 'CurrencyCode',
                                                                 element: 'CurrencyCode',
                                                                 usage: #RESULT } ],
                                           useForValidation: true }]
      CarrierId,
      _Carrier.Name             as CarrierName,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      @Semantics.currencyCode: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH',
                                                     element: 'Currency'},
                                           useForValidation: true }]
      CurrencyCode,
      @ObjectModel.text.element: ['BookingStatusText']
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Booking_Status_VH',
                                                     element: 'BookingStatus' },
                                           useForValidation: true }]
      BookingStatus,
      _BookingStatus._Text.Text as BookingStatusText : localized,
      LastChangedAt,
      /* Associations */
      _Travel            : redirected to parent ZC_TRAVEL_0932,
      _BookingSupplement : redirected to composition child zc_booksuppl_0932,
      _Carrier,
      _Connection,
      _Customer,
      _BookingStatus
}
