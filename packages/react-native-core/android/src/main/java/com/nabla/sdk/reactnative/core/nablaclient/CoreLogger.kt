package com.nabla.sdk.reactnative.core.nablaclient

import com.nabla.sdk.core.domain.boundary.Logger
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.MutableSharedFlow

object CoreLogger : Logger,
    CoroutineScope by CoroutineScope(SupervisorJob() + Dispatchers.Default) {

    internal class Log(
        val logLevel: LogLevel,
        val domain: String?,
        val message: String,
        val error: Throwable?,
    )

    private var logLevel: LogLevel = LogLevel.WARN
    internal val logsFlow = MutableSharedFlow<Log>()

    fun setLogLevel(level: String) {
        when (level.lowercase()) {
            LogLevel.DEBUG.name.lowercase() -> logLevel = LogLevel.DEBUG
            LogLevel.INFO.name.lowercase() -> logLevel = LogLevel.INFO
            LogLevel.WARN.name.lowercase() -> logLevel = LogLevel.WARN
            LogLevel.ERROR.name.lowercase() -> logLevel = LogLevel.ERROR
            else -> warn("Incorrect log level input `$level`", null, null)
        }
    }

    override fun debug(message: String, error: Throwable?, domain: String) {
        this.launch {
            if (logLevel.isAtLeast(LogLevel.DEBUG)) {
                logsFlow.emit(Log(LogLevel.DEBUG, domain, message, error))
            }
        }
    }

    override fun info(message: String, error: Throwable?, domain: String?) {
        this.launch {
            if (logLevel.isAtLeast(LogLevel.INFO)) {
                logsFlow.emit(Log(LogLevel.INFO, domain, message, error))
            }
        }
    }

    override fun warn(message: String, error: Throwable?, domain: String?) {
        this.launch {
            if (logLevel.isAtLeast(LogLevel.WARN)) {
                logsFlow.emit(Log(LogLevel.WARN, domain, message, error))
            }
        }
    }

    override fun error(message: String, error: Throwable?, domain: String?) {
        this.launch {
            if (logLevel.isAtLeast(LogLevel.ERROR)) {
                logsFlow.emit(Log(LogLevel.ERROR, domain, message, error))
            }
        }
    }

    internal enum class LogLevel(internal val value: Int) {
        DEBUG(0),
        INFO(1),
        WARN(2),
        ERROR(3)
    }

    private fun LogLevel.isAtLeast(level: LogLevel) = value <= level.value
}
