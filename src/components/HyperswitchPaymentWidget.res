module PaymentWidget = {
  @module("../specs/HyperswitchPaymentWidgetNativeComponent") @react.component
  external make: (~widgetType: string=?, ~style: ReactNative.Style.t=?,
  ~onEventFromWidget: JSON.t => unit=?) => React.element = "default"
}
open NativeHyperswitchSdk

@react.component
let make = React.forwardRef((~widgetType=?, ~style: ReactNative.Style.t, ~onEvent=?, ref) => {
  let {handleBackPress, confirmPayment} = UseHyper.useHyper()
  let id = React.useId()
  React.useImperativeHandle(
    ref,
    () => {
      {
        goBack: async () => {
          await handleBackPress(id)
        },
        confirmPayment: async () => {
          await confirmPayment(id)
        }
      }
    },
    (id, handleBackPress, confirmPayment),
  )

  <PaymentWidget ?widgetType style onEventFromWidget=?onEvent />
})
