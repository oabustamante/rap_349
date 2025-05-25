@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption - Sales Order: Header'
@Metadata: {
    ignorePropagatedAnnotations: true,
    allowExtensions: true
}
define root view entity zc_header_0932
  provider contract transactional_query
  as projection on zr_header_0932
{
  key     OrderUUID,
          OrderID,
          Email,
          FirstName,
          LastName,
          @Consumption.valueHelpDefinition: [ {
            entity: {
                name: 'I_CountryVH',
                element: 'Country'
            },
            useForValidation: true
          }]
          Country,
          PostingDate,
          DeliveryDate,
          @ObjectModel.text.element: [ 'StatusText' ]
          OrderStatus,
          _Status.Text as StatusText,
          ImageURL,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          TotalPrice,
          @EndUserText.label: 'VAT Included'
          @Semantics.amount.currencyCode: 'CurrencyCode'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_ORDER_VAT_0932'
  virtual PriceWithVAT : /dmo/total_price,
          CurrencyCode,
          @Semantics.systemDateTime.createdAt: true
          CreatedOn,
          @Semantics.user.createdBy: true
          CreatedBy,
          @Semantics.systemDateTime.lastChangedAt: true
          ChangedOn,
          @Semantics.user.lastChangedBy: true
          ChangedBy,
          /* Associations */
          _Items : redirected to composition child zc_items_0932,
          _Status,
          _Country,
          _Currency
}
