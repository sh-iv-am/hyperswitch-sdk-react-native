package hyperswitchsdkreactnative.example

// import android.os.Bundle
import com.facebook.react.ReactActivity
import com.facebook.react.ReactActivityDelegate
import com.facebook.react.defaults.DefaultNewArchitectureEntryPoint.fabricEnabled
import com.facebook.react.defaults.DefaultReactActivityDelegate

class MainActivity : ReactActivity() {

  /**
   * Returns the name of the main component registered from JavaScript. This is used to schedule
   * rendering of the component.
   */
  override fun getMainComponentName(): String = "HyperswitchSdkReactNativeExample"

  /**
   * Returns the instance of the [ReactActivityDelegate]. We use [DefaultReactActivityDelegate]
   * which allows you to enable New Architecture with a single boolean flags [fabricEnabled]
   */
  override fun createReactActivityDelegate(): ReactActivityDelegate {
    return object : DefaultReactActivityDelegate(this, mainComponentName, fabricEnabled) {
      // override fun getLaunchOptions(): Bundle? {

      //   val propsBundle = Bundle().apply {
      //     putString("type", "payment")
      //     putString("from", "rn")
      //     putString("publishableKey",  "pk_snd_3b33cd9404234113804aa1accaabe22f" )
      //     putString("clientSecret",  "pay_mMPDZBs0hJD9IjfVB5Ck_secret_Xay7LpZRwJnKA7fk8D1F")
      //   }

      //   val bundle = Bundle().apply {
      //     putBundle("props", propsBundle)
      //   }

      //   return bundle
      // }
    }
  }
}
