-dontwarn org.chromium.**
-keep class org.chromium.** { *; }

# General rules to avoid other potential conflicts
-ignorewarnings
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
