# Flutter Proguard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# TensorFlow Lite / tflite_flutter
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**
-dontwarn org.tensorflow.lite.gpu.**
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# SQLite / Drift / SQLite3
-keep class org.sqlite.** { *; }
-dontwarn org.sqlite.**

# Media / Audio / Camera
-dontwarn com.arthenica.ffmpegkit.**
-dontwarn io.flutter.plugins.camera.**


