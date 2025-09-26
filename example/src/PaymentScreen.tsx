import { useState, useEffect } from 'react';
import {
  View,
  Platform,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
} from 'react-native';
import {
  useHyper,
  type InitPaymentSessionParams,
  type InitPaymentSessionResult,
  type PresentPaymentSheetParams,
  type PresentPaymentSheetResult,
} from 'hyperswitch-sdk-react-native';

export default function PaymentScreen() {
  const { initPaymentSession, presentPaymentSheet } = useHyper();
  const [status, setStatus] = useState<string | null | undefined>(null);
  const [message, setMessage] = useState<string | null | undefined>(null);
  const [baseURL, setBaseURL] = useState<string>(
    Platform.OS === 'android' ? 'http://10.0.2.2:5252' : 'http://localhost:5252'
  );
  const createPaymentIntent = async (): Promise<string | undefined> => {
    try {
      const response = await fetch(`${baseURL}/create-payment-intent`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({}),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Failed to create payment intent');
      }

      return data.client_secret;
    } catch (error) {
      console.error('Error creating payment intent:', error);
      return undefined;
      // throw error;
    }
  };
  const setup = async (): Promise<void> => {
    try {
      const paymentIntent = await createPaymentIntent();

      const params: InitPaymentSessionParams = {
        paymentIntentClientSecret: paymentIntent,
      };

      const result: InitPaymentSessionResult = await initPaymentSession(params);

      if (result.error) {
        setStatus(`Initialization failed: ${result.error}`);
        console.error('Payment session initialization failed:', result.error);
      } else {
        setMessage('');
        setStatus('Ready to checkout');
      }
    } catch (error) {
      console.error('Setup failed:', error);
    }
  };
  useEffect(() => {
    setup();
  }, [initPaymentSession]);

  const checkout = async (): Promise<void> => {
    try {
      const options: PresentPaymentSheetParams = {
        appearance: {
          theme: 'Dark',
          // colors: {
          //   background: '#452061',
          //   componentBackground: 'black',
          //   componentText: 'white',
          //   primary: '#77DF95',
          //   primaryText: 'white',
          // },
          // primaryButton: {
          //   shapes: {
          //     borderRadius: 36,
          //     shadow: {
          //       color: '#378C46',
          //       opacity: 0.5,
          //       blurRadius: 10,
          //       offset: {
          //         x: 0,
          //         y: 4,
          //       },
          //     },
          //   },
          // },
          // shapes: {
          //   shadow: {
          //     color: '#378C46',
          //     opacity: 1,
          //     blurRadius: 10,
          //     offset: {
          //       x: 0,
          //       y: 6,
          //     },
          //   },
          // },
        },
        // primaryButtonLabel: 'Complete Purchase',
      };

      const result: PresentPaymentSheetResult =
        await presentPaymentSheet(options);
      let { error, paymentResult } = result;
      if (error) {
        console.error('Payment failed:', JSON.stringify(error));
        setStatus(`Payment failed: ${JSON.stringify(error)}`);
      } else {
        setStatus(paymentResult?.status);
        setMessage(`${paymentResult?.message}`);
        console.log('Payment completed with status:', paymentResult?.status);
        console.log('Message:', paymentResult?.message);
      }
    } catch (error: any) {
      setMessage(`${error.message}`);
      setStatus(`Checkout failed: ${JSON.stringify(error.message)}`);
      console.error('Checkout failed:', error);
    }
  };

  return (
    <View style={styles.container}>
      <TextInput
        style={styles.textInput}
        placeholder="Enter base URL"
        value={baseURL}
        onChangeText={(text) => setBaseURL(text)}
      />
      <TouchableOpacity style={styles.button} onPress={setup}>
        <Text style={{ color: 'white' }}>Reload client Secret</Text>
      </TouchableOpacity>
      <TouchableOpacity style={styles.button} onPress={checkout}>
        <Text style={{ color: 'white' }}>Checkout</Text>
      </TouchableOpacity>
      {message && <Text>{message}</Text>}
      <Text style={styles.statusText}>{status}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  textInput: {
    display: 'flex',
    flexDirection: 'column',
    height: 48,
    borderColor: 'gray',
    borderWidth: 1,
    marginBottom: 12,
    borderRadius: 8,
    fontSize: 24,
    paddingHorizontal: 8,
    width: '100%',
    gap: 20,
  },
  container: {
    height: '100%',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
  },
  statusText: {
    marginTop: 16,
    fontSize: 24,
    color: 'gray',
    textAlign: 'center',
  },
  button: {
    width: '100%',
    height: 48,
    backgroundColor: '#0355c9ff',
    alignItems: 'center',
    color: 'white',
    justifyContent: 'center',
    borderRadius: 8,
    marginBottom: 12,
  },
});
