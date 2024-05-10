---@diagnostic disable-next-line: undefined-field
local eq = assert.are.same
local selected = require("huez_manager.selected")
local colorscheme = require("huez.api.colorscheme")

describe("theme installation", function()
  before_each(function()
  local path = vim.fs.normalize(vim.fn.stdpath("data") --[[@as string]]) .. "/huez"
    os.execute("mkdir -p " .. path)
    require("lazy").setup({
      {
        "vague2k/huez.nvim",
        import = "huez_manager.manage",
        dev = true,
        dependencies = {
          "grapp-dev/nui-components.nvim",
          "MunifTanjim/nui.nvim",
        },
        opts = {},
      },
      {
        dev = {
          path = vim.fs.normalize(os.getenv("GITHUB_WORKSPACE") or "."),
        },
      },
    })
    require("lazy").install()
  end)

  it("can install theme and make it available", function()
    local before_themes = colorscheme.installed()
    eq(false, vim.tbl_contains(before_themes, "tokyonight"))

    selected.lazy_flush({ "nightfox" })
    vim.wait(10000)
    local after_themes = vim.fn.getcompletion("", "color", true)

    vim.print(vim.inspect(after_themes))

    eq(true, vim.tbl_contains(after_themes, "tokyonight"))
  end)
end)
