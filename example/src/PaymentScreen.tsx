import React from 'react';
import { View, Button, Platform, StyleSheet } from 'react-native';
import {
  useHyper,
  type InitPaymentSessionParams,
  type InitPaymentSessionResult,
  type PresentPaymentSheetResult,
} from 'hyperswitch-sdk-react-native';

export default function PaymentScreen() {
  const { initPaymentSession, presentPaymentSheet } = useHyper();

  const createPaymentIntent = async (): Promise<string> => {
    try {
      const baseUrl =
        Platform.OS === 'android'
          ? 'http://10.0.2.2:3000'
          : 'http://localhost:3000';
      const response = await fetch(`${baseUrl}/create-payment-intent`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          amount: 2000, // $20.00 in cents
          currency: 'USD',
          description: 'Example payment',
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Failed to create payment intent');
      }

      return data.client_secret;
    } catch (error) {
      console.error('Error creating payment intent:', error);
      throw error;
    }
  };

  React.useEffect(() => {
    const setup = async (): Promise<void> => {
      try {
        const paymentIntent = await createPaymentIntent();

        const params: InitPaymentSessionParams = {
          paymentIntentClientSecret: paymentIntent,
        };

        const result: InitPaymentSessionResult =
          await initPaymentSession(params);

        if (result.error) {
          console.error('Payment session initialization failed:', result.error);
        }
      } catch (error) {
        console.error('Setup failed:', error);
      }
    };

    setup();
  }, [initPaymentSession]);

  const checkout = async (): Promise<void> => {
    try {
      const result: PresentPaymentSheetResult = await presentPaymentSheet();

      if (result.error) {
        console.error('Payment failed:', result.error);
      } else {
        console.log('Payment completed with status:', result.status);
        console.log('Message:', result.message);
      }
    } catch (error) {
      console.error('Checkout failed:', error);
    }
  };

  return (
    <View style={styles.container}>
      <Button title="Checkout" onPress={checkout} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    height: '100%',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
  },
});
