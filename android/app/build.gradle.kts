import java.io.FileInputStream
import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "org.projectsolutus.pomozen"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "org.projectsolutus.pomozen"
        minSdkVersion(23)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Access properties using .get() or direct access (like propertyName.toString())
            storeFile = file(keystoreProperties.get("storeFile").toString())
            storePassword = keystoreProperties.get("storePassword").toString()
            keyAlias = keystoreProperties.get("keyAlias").toString()
            keyPassword = keystoreProperties.get("keyPassword").toString()
        }
    }

    buildTypes {
        release {
            // IMPORTANT: Changed from "debug" to "release" signingConfig
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = false // Keep false for now, re-enable later if needed
            isShrinkResources = false // Keep false for now, re-enable later if needed
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }

    // --- NEW: ABI Splits Configuration ---
    splits {
        abi {
            isEnable = true
            reset()
            include("armeabi-v7a", "arm64-v8a", "x86_64")
            isUniversalApk = true
        }
    }
    // --- END NEW ---
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
