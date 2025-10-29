import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';

interface NativeProps extends ViewProps {
  widgetType?: string;
  onEventFromWidget?: (event: { type: string; data: any }) => void;
}

export default codegenNativeComponent<NativeProps>('HyperswitchPaymentWidget');
