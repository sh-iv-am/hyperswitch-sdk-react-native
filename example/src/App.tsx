import {
  HyperProvider,
} from 'hyperswitch-sdk-react-native';
import Screen from './Screen';

export default function App() {

  return (
    <HyperProvider publishableKey={process.env.PUBLISHABLE_KEY || ''}>
      <Screen/>
    </HyperProvider>
  );
}
