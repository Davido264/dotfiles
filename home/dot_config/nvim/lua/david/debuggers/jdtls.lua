require("jdtls").setup_dap()

require("dap").configurations.java = {
  javaExec = os.getenv "JAVA_HOME" .. "/bin/javaw.exe",
}
