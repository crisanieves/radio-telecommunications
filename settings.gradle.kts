pluginManagement {
  repositories {
    google {
      content {
        includeGroupByRegex("com\\.android.*")
        includeGroupByRegex("com\\.google.*")
        includeGroupByRegex("androidx.*")
      }
    }
    mavenCentral()
    gradlePluginPortal()
  }
}

plugins { id("org.gradle.toolchains.foojay-resolver-convention") version "1.0.0" }

dependencyResolutionManagement {
  repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
  repositories {
    google()
    mavenCentral()
  }
}

rootProject.name = "eRadio"

// Ensure root .env and .env.example files exist automatically
val rootEnv = File(rootDir, ".env")
val rootEnvExample = File(rootDir, ".env.example")
if (!rootEnvExample.exists()) {
  rootEnvExample.writeText(
    "# GEMINI_API_KEY: Required for Gemini AI API calls.\n" +
    "# This is a placeholder key.\n" +
    "# AI Studio automatically injects this at runtime from user secrets.\n" +
    "# Users configure this via the Secrets panel in the AI Studio UI.\n" +
    "# IMPORTANT: Uncomment the line below if your app uses the Gemini API.\n" +
    "# If left commented out, the key will NOT be packaged in the APK.\n" +
    "# GEMINI_API_KEY=MY_GEMINI_API_KEY\n"
  )
}
if (!rootEnv.exists()) {
  rootEnvExample.copyTo(rootEnv, overwrite = false)
}

include(":app")
