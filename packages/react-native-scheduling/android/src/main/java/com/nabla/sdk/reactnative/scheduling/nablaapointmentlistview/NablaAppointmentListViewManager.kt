package com.nabla.sdk.reactnative.scheduling.nablaapointmentlistview

import androidx.fragment.app.FragmentActivity
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.nabla.sdk.reactnative.scheduling.utils.NativeViewWrapper
import com.nabla.sdk.scheduling.scene.appointments.AppointmentsFragment

internal class NablaAppointmentListViewManager(
    private val reactContext: ReactApplicationContext,
) : ViewGroupManager<NativeViewWrapper>() {

    override fun getName() = REACT_CLASS

    override fun createViewInstance(reactContext: ThemedReactContext): NativeViewWrapper {
        return NativeViewWrapper(reactContext)
    }

    override fun getCommandsMap() = mapOf("create" to COMMAND_CREATE)

    override fun receiveCommand(
        root: NativeViewWrapper,
        commandId: String,
        args: ReadableArray?,
    ) {
        super.receiveCommand(root, commandId, args)

        val reactNativeViewId = requireNotNull(args).getInt(0)
        when (commandId.toInt()) {
            COMMAND_CREATE -> createFragment(reactNativeViewId)
        }
    }

    private fun createFragment(reactNativeViewId: Int) {
        val fragment = AppointmentsFragment.newInstance()
        (reactContext.currentActivity as FragmentActivity).supportFragmentManager
            .beginTransaction()
            .replace(
                reactNativeViewId,
                fragment,
                reactNativeViewId.toString()
            )
            .commit()
    }

    companion object {
        private const val REACT_CLASS = "NablaAppointmentListView"
        private const val COMMAND_CREATE = 1
    }
}
