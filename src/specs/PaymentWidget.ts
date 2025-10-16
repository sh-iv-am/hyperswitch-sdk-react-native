import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps, CodegenTypes } from 'react-native';

interface NativeProps extends ViewProps {
  expandable?: boolean;
  initialHeight?: CodegenTypes.Double;
  initialWidth?: CodegenTypes.Double;
  maxHeight?: CodegenTypes.Double;
  maxWidth?: CodegenTypes.Double;
  minHeight?: CodegenTypes.Double;
  minWidth?: CodegenTypes.Double;
  borderRadius?: CodegenTypes.Double;
  backgroundColor?: string;
  onWidgetEvent?: CodegenTypes.DirectEventHandler<{
    type: string;
    data?: string;
    error?: string | null;
  }>;
}

export default codegenNativeComponent<NativeProps>('PaymentWidget');
