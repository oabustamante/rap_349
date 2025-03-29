@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Travel'
@Metadata: {
    ignorePropagatedAnnotations: true,
    allowExtensions: true
}
define root view entity ZC_TRAVEL_0932
  provider contract transactional_query
  as projection on ZR_TRAVEL_0932
{
  key     TravelId,
          AgencyId,
          CustomerId,
          BeginDate,
          EndDate,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          BookingFee,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          TotalPrice,
          @Semantics.currencyCode: true
          CurrencyCode,
          Description,
          OverallStatus,
          CreatedBy,
          CreatedAt,
          LastChangedBy,
          LastChangedAt,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_VIRT_ELEM_0932'
  virtual DiscountPrice : /dmo/total_price,
          /* Associations */
          _Agency,
          _Booking : redirected to composition child ZC_BOOKING_0932,
          _Currency,
          _Customer



          //  key     TravelId,
          //          AgencyId,
          //          CustomerId,
          //          BeginDate,
          //          EndDate,
          //          @Semantics.amount.currencyCode: 'CurrencyCode'
          //          BookingFee,
          //          @Semantics.amount.currencyCode: 'CurrencyCode'
          //          TotalPrice,
          //          @Semantics.currencyCode: true
          //          CurrencyCode,
          //          Description,
          //          OverallStatus,
          //          CreatedBy,
          //          CreatedAt,
          //          LastChangedBy,
          //          LastChangedAt,
          //          @Semantics.amount.currencyCode: 'CurrencyCode'
          //          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_VIRT_ELEM_0932'
          //  virtual DiscountPrice : /dmo/total_price,
          //          /* Associations */
          //          _Agency,
          //          _Booking : redirected to composition child ZC_BOOKING_0932,
          //          _Currency,
          //          _Customer
}
