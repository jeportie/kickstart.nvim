return {
  "Civitasv/cmake-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    cmake_command = "cmake",
    ctest_command = "ctest",
    cmake_regenerate_on_save = false,
    cmake_generate_options = { "-G", "Ninja" },
    cmake_build_directory = "build",
  },
}
