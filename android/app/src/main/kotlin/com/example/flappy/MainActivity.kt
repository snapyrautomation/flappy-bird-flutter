package com.example.flappy

import androidx.annotation.NonNull
import com.snapyr.sdk.Properties
import com.snapyr.sdk.Snapyr
import com.snapyr.sdk.Traits
import com.snapyr.sdk.http.ConnectionFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "snapyr.com/data"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val builder =
                Snapyr.Builder(this, "iUP1MlMXSeilS20TUUavq5vygVI8mDMT")
                        .experimentalNanosecondTimestamps()
                        .snapyrEnvironment(ConnectionFactory.Environment.DEV)
                        .trackApplicationLifecycleEvents()
                        .logLevel(Snapyr.LogLevel.DEBUG)
                        .flushQueueSize(1)
                        .recordScreenViews()
                        .build()
        Snapyr.setSingletonInstance(builder)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call,
                result ->
            if (call.method == "identify") {
                val userId = call.argument<String>("userId")
                val traitsMap = call.argument<HashMap<String, Any>>("traits")
                val traits = Traits()
                traitsMap?.forEach { entry -> traits.put(entry.key, entry.value) }
                Snapyr.with(this).identify(userId, traits, null)
                result.success(0)
            } else if (call.method == "track") {
                val event = call.argument<String>("event")
                if (event != null){
                    val propertiesMap = call.argument<HashMap<String, Any>>("properties")
                    val properties = Properties()
                    propertiesMap?.forEach { entry -> properties.put(entry.key, entry.value) }
                    Snapyr.with(this).track(event, properties)
                    result.success(0)
                } else {
                    result.error("NO_EVENT_SPECIFIED", "must supply an event", null)
                }
            } else if (call.method == "reset") {
                Snapyr.with(this).reset();
            }
        }
    }
}
