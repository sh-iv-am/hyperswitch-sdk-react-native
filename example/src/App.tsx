import { Button, View, StyleSheet } from 'react-native';
import { launchPaymentSheet, HyperswitchReactNativeView } from 'hyperswitch-sdk-react-native';

export default function App() {
  return (
    <View style={styles.container}>
      <Button title='Launch Payment Sheet' onPress={() => launchPaymentSheet()} />
      <HyperswitchReactNativeView color="#32a852" style={styles.box} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
