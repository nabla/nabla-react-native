package com.nabla.sdk.reactnative.messaging.ui.utils

import android.content.Context
import android.view.View
import android.widget.FrameLayout

// This class used as a workaround for an issue in the layout of the native conversation list view.
// Without this, react would not re-render the view when its content changes (changes of visibility of subviews)
// Related Github issue: `Android native UI components are not re-layout on dynamically added views` https://github.com/facebook/react-native/issues/17968
// and more specifically this comment https://github.com/facebook/react-native/issues/17968#issuecomment-721958427
internal class NativeViewWrapper(context: Context) : FrameLayout(context) {

    constructor(context: Context, view: View) : this(context) {
        addView(view)
    }

    override fun requestLayout() {
        super.requestLayout()
        post(measureAndLayout)
    }

    private val measureAndLayout = Runnable {
        measure(MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY),
            MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY))
        layout(left, top, right, bottom)
    }
}
