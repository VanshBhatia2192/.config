return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  config = function()
    local jdtls = require("jdtls")

    local home = os.getenv("HOME")
    local current_dir = vim.fn.getcwd()
    local workspace_dir = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(current_dir, ":p:h:t")

    local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
    local root_dir = require("jdtls.setup").find_root(root_markers)

    if not root_dir then
      root_dir = current_dir
    end

    local config = {
      cmd = { "jdtls" },
      root_dir = root_dir,
      init_options = {
        jvm_args = { "--enable-preview=false" },
      },
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-22",
                -- path = "", -- optional: update this if you use multiple JDKs
              },
            },
          },
        },
      },
    }

    jdtls.start_or_attach(config)
  end,
}
