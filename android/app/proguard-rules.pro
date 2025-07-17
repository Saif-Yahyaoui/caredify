# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options$GpuBackend
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options
# Keep all TensorFlow Lite classes (including GPU delegate)
-keep class org.tensorflow.** { *; }
-keep class org.tensorflow.lite.** { *; }
