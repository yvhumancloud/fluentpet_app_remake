package pet.fluent.fluentpet

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Dart's DateTime.timeZoneName is "IST"; the backend wants "Asia/Kolkata".
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "fluentpet/timezone")
            .setMethodCallHandler { _, result -> result.success(TimeZone.getDefault().id) }
    }
}
