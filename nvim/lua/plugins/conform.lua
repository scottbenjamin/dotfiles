return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        hcl = { "terragrunt_hclfmt" },
        tofu = { "tofu_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        terraform = { "terraform_fmt" },
        ["yaml.ansible"] = { "ansible-lint" },
      },
    },
  },
}
