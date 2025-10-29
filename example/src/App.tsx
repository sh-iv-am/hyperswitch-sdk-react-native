import { HyperProvider } from 'hyperswitch-sdk-react-native';
import PaymentScreen from './PaymentScreen';
import { useState } from 'react';
import HyperPaymentWidgetExample from './HyperPaymentWidgetExample';
export default function App() {
  const [page, setPage] = useState<'payment' | 'widget'>('payment');
  return (
    <HyperProvider
      publishableKey={process.env.HYPERSWITCH_PUBLISHABLE_KEY || ''}
    >
      {page === 'payment' ? (
        <PaymentScreen setPage={setPage} page={page} />
      ) : null}
      {page === 'widget' ? (
        <HyperPaymentWidgetExample setPage={setPage} page={page} />
      ) : null}
    </HyperProvider>
  );
}
