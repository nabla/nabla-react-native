package com.nabla.sdk.reactnative.messaging.core.nablamessagingclient

import androidx.annotation.CheckResult

typealias ToUnitResult = (@CheckResult suspend () -> Result<Unit>)?
