import React, { useEffect, useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { useHyper, type sessionParams } from 'hyperswitch-sdk-react-native';
import getSecrets from './utils/secrets';

export default function Screen({}: {}) {
  const [publishableKey, setPublishableKey] = useState<string>('');
  const [clientSecret, setClientSecret] = useState<string>('');
  const [ready, setReady] = useState<boolean>(false);
  const [status, setStatus] = useState<string>('');
  const { initPaymentSession, presentPaymentSheet } = useHyper();
  const [paymentSheetParams, setPaymentSheetParams] = React.useState({});
  const handleReloadClientSecret = async () => {
    const newClientSecret = await getSecrets();
    if (newClientSecret.error) {
      console.error('Error fetching client secret:', newClientSecret.error);
      setStatus('Reload Client Secret : ' + newClientSecret.error);
      return;
    }
    if (publishableKey === '' && newClientSecret.publishableKey !== '') {
      console.log('newClientSecret', newClientSecret);
      setPublishableKey(newClientSecret?.publishableKey || '');
    }
    setClientSecret((_) => newClientSecret?.clientSecret || '');
    try {
      const params = await initPaymentSession(
        {
          clientSecret: newClientSecret?.clientSecret || '',
          publishableKey: newClientSecret?.publishableKey || '',
        }
      );
      setPaymentSheetParams(params);
      console.log('initPaymentSession params', params);
      setStatus('Payment Session Initialized');
    } catch (error) {
      console.error('Error initializing payment session:', error);
      setStatus('Error initializing payment session');
      return;
    }
    setReady(true);
  };

  useEffect(() => {
    handleReloadClientSecret();
  }, []);

  const handleLaunchPaymentSheet = async () => {
    if (!ready) {
      console.warn('SDK is not ready');
      setStatus('Reload Client Secret');
      return;
    }

    let res = await presentPaymentSheet(
      {
        ...(paymentSheetParams as sessionParams),
        locale : "en",
        configuration :{
          appearance : {
            locale : "en"
          }
        }
      },
    );
    console.log('presentPaymentSheet result', typeof res);
    if (res.status === "success" || res.status === "succeeded") {
      setStatus('Payment Successful');
    } else if (res.status == "cancelled") {
      setStatus('Payment Canceled');
    }else{
        setStatus('Payment Failed: ' + JSON.stringify(res));
    }

    // Launch the payment sheet
  };

  return (
    <View style={styles.container}>
      <Text style={styles.titleText}>Hyperswitch SDK</Text>
      <TouchableOpacity
        style={styles.button}
        onPress={handleReloadClientSecret}
      >
        <Text style={styles.buttonText}>Reload Client Secret</Text>
      </TouchableOpacity>
      <TouchableOpacity
        disabled={!ready}
        style={[styles.button, !ready && { opacity: 0.8 }]}
        onPress={handleLaunchPaymentSheet}
      >
        <Text style={styles.buttonText}>Launch Payment Sheet</Text>
      </TouchableOpacity>
      <Text style={styles.statusText}>{status}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    textAlign: 'center',
    width: '100%',
    height: '100%',
    padding: 30,
    gap: 10,
  },
  titleText: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 20,
  },
  button: {
    backgroundColor: '#007bff',
    borderRadius: 5,
    padding: 16,
    width: '100%',
    justifyContent: 'center',
    display: 'flex',
  },
  buttonText: {
    color: '#fff',
    textAlign: 'center',
    fontSize: 16,
  },
  statusText: {
    marginTop: 20,
    fontSize: 18,
    color: '#666',
    textAlign: 'center',
  },
});
