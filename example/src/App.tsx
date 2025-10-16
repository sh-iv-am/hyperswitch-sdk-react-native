import { HyperProvider } from 'hyperswitch-sdk-react-native';
import PaymentScreen from './PaymentScreen';
import { useState } from 'react';
export default function App() {
  const [page, setPage] = useState<'payment'>('payment');
  return (
    <HyperProvider
      publishableKey={process.env.HYPERSWITCH_PUBLISHABLE_KEY || ''}
    >
      {
        page === 'payment' ? (
          <PaymentScreen />
        ) : null
      }
    </HyperProvider>
  );
}
