import { View, TouchableOpacity, Text } from 'react-native';
import {
  PaymentWidget,
  type PaymentWidgetHandle,
} from 'hyperswitch-sdk-react-native';
import { styles } from './styles';
import { useRef } from 'react';
const HyperPaymentWidgetExample = ({
  page,
  setPage,
}: {
  setPage: React.Dispatch<React.SetStateAction<'payment' | 'widget'>>;
  page: 'payment' | 'widget';
}) => {
  // const {handleBackPress} =useHyper();
  const widgetRef = useRef<PaymentWidgetHandle>(null);
  const backPress = async () => {
    if (!widgetRef.current) {
      return;
    }
    let shouldBackPress = await widgetRef.current.goBack();
    // console.log('Should back press:',typeof shouldBackPress);
    if (!shouldBackPress) {
      setPage(page === 'payment' ? 'widget' : 'payment');
    }
  };

  const handleConfirm = async () => {
    if (!widgetRef.current) {
      return;
    }
    let result = await widgetRef.current.confirmPayment();
    console.log('Payment confirmation result:', result);
  };

  return (
    <View style={styles.container}>
      {/* <TouchableOpacity
        style={styles.closeButton}
        // disabled={!shouldBackPress}
      >
        <Text style={styles.closeButtonText}>X</Text>
      </TouchableOpacity> */}
      <PaymentWidget ref={widgetRef} />
      <TouchableOpacity style={styles.button} onPress={() => {}}>
        <Text style={styles.buttonText}>Reload Payment Widget</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.button} onPress={handleConfirm}>
        <Text style={styles.buttonText}>Confirm Payment</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.button} onPress={backPress}>
        <Text style={styles.buttonText}>Go Back</Text>
      </TouchableOpacity>
    </View>
  );
};

export default HyperPaymentWidgetExample;
