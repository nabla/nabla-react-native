package com.nabla.sdk.reactnative.scheduling.nablaschedulingui


import android.app.Activity
import android.content.Intent
import android.util.SparseArray
import com.benasher44.uuid.Uuid
import com.facebook.react.bridge.*
import com.nabla.sdk.core.NablaClient
import com.nabla.sdk.core.annotation.NablaInternal
import com.nabla.sdk.core.domain.entity.InternalException.Companion.asNablaInternal
import com.nabla.sdk.reactnative.core.models.toCoreMap
import com.nabla.sdk.reactnative.core.nablaclient.CoreLogger
import com.nabla.sdk.scheduling.domain.entity.AppointmentId
import com.nabla.sdk.scheduling.scene.details.AppointmentDetailsActivity
import com.nabla.sdk.scheduling.schedulingClient
import kotlin.random.Random

@OptIn(NablaInternal::class)
internal class NablaSchedulingUIModule(
    private val reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext), ActivityEventListener {
    override fun getName() = "NablaSchedulingUIModule"

    private val resultCallbacks: SparseArray<Callback> = SparseArray()

    override fun initialize() {
        super.initialize()
        reactContext.addActivityEventListener(this)
    }

    override fun invalidate() {
        reactContext.removeActivityEventListener(this)
        super.invalidate()
    }

    @ReactMethod
    fun navigateToScheduleAppointmentScreen() {
        if (currentActivity == null) {
            CoreLogger.error("Missing current activity in `NablaSchedulingUIModule`")
            return
        }
        NablaClient.getInstance().schedulingClient.openScheduleAppointmentActivity(currentActivity!!)
    }

    @ReactMethod
    fun navigateToAppointmentDetailScreen(
        appointIdString: String,
        callback: Callback,
    ) {
        val appointmentId = try {
            AppointmentId(uuid = Uuid.fromString(appointIdString))
        } catch (e: Exception) {
            callback(e.asNablaInternal().toCoreMap())
            return
        }
        try {
            requireNotNull(currentActivity).let { currentActivity ->
                val requestCode = randomPositiveInt()
                resultCallbacks.put(requestCode, callback)

                currentActivity.startActivityForResult(
                    AppointmentDetailsActivity.newIntent(
                        context = currentActivity,
                        appointmentId = appointmentId
                    ),
                    requestCode,
                )
            }
        } catch (e: Exception) {
            CoreLogger.error("An error occurred while navigating to the AppointmentDetailScreen", e)
            callback(e.asNablaInternal().toCoreMap())
            return
        }
    }

    private fun randomPositiveInt(): Int = Random.nextInt(from = 0, until = Int.MAX_VALUE)

    override fun onActivityResult(
        activity: Activity,
        requestCode: Int,
        resultCode: Int,
        data: Intent?,
    ) {
        val callback = resultCallbacks.get(requestCode) ?: return

        resultCallbacks.remove(requestCode)
        callback.invoke(null)
    }

    override fun onNewIntent(intent: Intent?) {
        // No-op
    }
}
