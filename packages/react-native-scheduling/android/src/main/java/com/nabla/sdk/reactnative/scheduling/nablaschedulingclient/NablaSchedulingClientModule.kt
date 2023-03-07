package com.nabla.sdk.reactnative.scheduling.nablaschedulingclient

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.nabla.sdk.core.NablaClient
import com.nabla.sdk.core.domain.boundary.Module
import com.nabla.sdk.reactnative.core.nablaclient.CoreLogger
import com.nabla.sdk.reactnative.core.nablaclient.NablaClientModule
import com.nabla.sdk.reactnative.scheduling.CustomPaymentStepReactActivity
import com.nabla.sdk.reactnative.scheduling.models.toMap
import com.nabla.sdk.scheduling.NablaSchedulingModule
import com.nabla.sdk.scheduling.PaymentActivityContract
import com.nabla.sdk.scheduling.domain.entity.PendingAppointment
import com.nabla.sdk.scheduling.schedulingClient
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.launch

class NablaSchedulingClientModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext),
    CoroutineScope by CoroutineScope(SupervisorJob() + Dispatchers.Default) {

    override fun getName() = "NablaSchedulingClientModule"

    @ReactMethod
    fun initializeSchedulingModule(promise: Promise) {
        NablaClientModule.addModule(NablaSchedulingModule())
        promise.resolve(null)
    }

    @ReactMethod
    fun didFailPaymentStep() {
        launch {
            PAYMENT_RESULT_FLOW.emit(Activity.RESULT_CANCELED)
        }
    }

    @ReactMethod
    fun didSucceedPaymentStep() {
        launch {
            PAYMENT_RESULT_FLOW.emit(Activity.RESULT_OK)
        }
    }

    @ReactMethod
    fun setupCustomPaymentStep(componentName: String) {
        COMPONENT_NAME = componentName
        NablaClientModule.addPostInitializeAction {
            NablaClient.getInstance().schedulingClient.registerPaymentActivityContract(
                object : PaymentActivityContract() {
                    override fun createIntent(context: Context, input: PendingAppointment): Intent {
                        return Intent(context, CustomPaymentStepReactActivity::class.java).apply {
                            putExtra("APPOINTMENT", Arguments.toBundle(input.toMap()))
                        }
                    }

                    override fun parseResult(resultCode: Int, intent: Intent?): Result {
                        return if (resultCode == Activity.RESULT_OK) Result.Succeeded else Result.ShouldRetry
                    }
                }
            )
        }
    }

    companion object {
        var PAYMENT_RESULT_FLOW = MutableSharedFlow<Int>()
        var COMPONENT_NAME: String? = null
    }
}
