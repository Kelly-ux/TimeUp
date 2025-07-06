plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // Changed from "kotlin-android" for full clarity
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // FIX: Add the Google Services plugin - CRUCIAL for Firebase
    id("com.google.gms.google-services")
}
fun getProjectProperty(propertyName: String, defaultValue: Any): String {
    return if (project.hasProperty(propertyName)) {
        project.property(propertyName).toString()
    } else {
        defaultValue.toString()
    }
}

android {
    namespace = "com.example.myapp" // Ensure this matches your actual package name
    compileSdk = flutter.compileSdkVersion // Keep this aligned with Flutter's SDK

    // FIX: Set the NDK version here as required by Firebase
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.myapp" // Ensure this matches your actual application ID
        // FIX: Explicitly set minSdkVersion to 23 as required by Firebase
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Removed redundant ndkVersion here, it's set at the top-level 'android' block
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Ensure you have the Firebase BoM (Bill of Materials) if using multiple Firebase products
    // This helps manage compatible versions of Firebase Android SDKs
    // FIX: Updated Firebase BOM version to 33.1.0 (latest stable at time of writing)
    implementation(platform("com.google.firebase:firebase-bom:33.1.0"))
    // Explicitly adding Firebase SDKs, which is fine
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.android.gms:play-services-auth:21.1.0") // Keep this version if specifically needed
    implementation("com.google.firebase:firebase-storage")
}
compileOptions {
 sourceCompatibility = JavaVersion.VERSION_11
 targetCompatibility = JavaVersion.VERSION_11
}

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

flutter {
    source = "../.."
}