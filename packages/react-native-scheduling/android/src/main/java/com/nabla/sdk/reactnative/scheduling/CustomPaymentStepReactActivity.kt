package com.nabla.sdk.reactnative.scheduling

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.facebook.react.ReactApplication
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactRootView
import com.facebook.react.bridge.Arguments
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler
import com.facebook.soloader.SoLoader
import com.nabla.sdk.reactnative.scheduling.nablaschedulingclient.NablaSchedulingClientModule
import kotlinx.coroutines.launch

internal class CustomPaymentStepReactActivity: AppCompatActivity(), DefaultHardwareBackBtnHandler {

    private lateinit var reactRootView: ReactRootView
    private lateinit var reactInstanceManager: ReactInstanceManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        SoLoader.init(this, false)
        reactRootView = ReactRootView(this)

        reactInstanceManager = (application as ReactApplication).reactNativeHost.reactInstanceManager

        val appointmentMap = intent.extras?.getBundle("APPOINTMENT")?.let { Arguments.fromBundle(it) }
        val initialParams = Arguments.createMap().apply {
            appointmentMap?.let { putMap("appointment", it) }
        }
        reactRootView.startReactApplication(
            reactInstanceManager,
            NablaSchedulingClientModule.COMPONENT_NAME,
            Arguments.toBundle(initialParams))
        setContentView(reactRootView)


        lifecycleScope.launch {
            NablaSchedulingClientModule.PAYMENT_RESULT_FLOW.collect {
                setResult(it)
                finish()
            }
        }
    }

    override fun invokeDefaultOnBackPressed() {
        super.onBackPressed()
    }
}
