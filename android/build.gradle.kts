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

// Global project evaluation listener to inject namespace into plugins that lack it
gradle.addProjectEvaluationListener(object : ProjectEvaluationListener {
    override fun beforeEvaluate(project: Project) {}

    override fun afterEvaluate(project: Project, state: ProjectState) {
        if (project != rootProject && project.name != "app") {
            try {
                val android = project.extensions.findByName("android")
                if (android != null) {
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
            } catch (e: Exception) {
                // Ignore failures to avoid breaking the build
            }
        }
    }
})

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
