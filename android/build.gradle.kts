allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Global project evaluation listener to fix common plugin issues (Namespace and JVM Target)
gradle.addProjectEvaluationListener(object : ProjectEvaluationListener {
    override fun beforeEvaluate(project: Project) {}

    override fun afterEvaluate(project: Project, state: ProjectState) {
        if (project != rootProject && project.name != "app") {
            try {
                // 1. Force JVM Target 17 for both Java and Kotlin in Android extensions
                val android = project.extensions.findByName("android")
                if (android != null) {
                    val compileOptions = android.javaClass.getMethod("getCompileOptions").invoke(android)
                    val setSourceCompatibility = compileOptions.javaClass.getMethod("setSourceCompatibility", JavaVersion::class.java)
                    val setTargetCompatibility = compileOptions.javaClass.getMethod("setTargetCompatibility", JavaVersion::class.java)
                    
                    setSourceCompatibility.invoke(compileOptions, JavaVersion.VERSION_17)
                    setTargetCompatibility.invoke(compileOptions, JavaVersion.VERSION_17)
                    
                    // 2. Inject Namespace if missing
                    val getNamespace = android.javaClass.methods.find { it.name == "getNamespace" }
                    val setNamespace = android.javaClass.methods.find { it.name == "setNamespace" && it.parameterCount == 1 }

                    if (getNamespace != null && setNamespace != null) {
                        val currentNamespace = getNamespace.invoke(android)
                        if (currentNamespace == null) {
                            val manifestFile = project.file("src/main/AndroidManifest.xml")
                            if (manifestFile.exists()) {
                                val manifestText = manifestFile.readText()
                                val packageRegex = Regex("""package\s*=\s*["']([^"']+)["']""")
                                val match = packageRegex.find(manifestText)
                                if (match != null) {
                                    val packageName = match.groupValues[1]
                                    setNamespace.invoke(android, packageName)
                                }
                            }
                        }
                    }
                }
                
                // 3. Force Kotlin JVM Target 17 across all Kotlin tasks using reflection to avoid import issues
                project.tasks.matching { it.javaClass.name.contains("KotlinCompile") }.all {
                    try {
                        val kotlinOptions = this.javaClass.getMethod("getKotlinOptions").invoke(this)
                        kotlinOptions.javaClass.getMethod("setJvmTarget", String::class.java).invoke(kotlinOptions, "17")
                    } catch (e: Exception) {
                        // ignore
                    }
                }
            } catch (e: Exception) {
                // Ignore failures to avoid breaking the build
            }
        }
    }
})

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
