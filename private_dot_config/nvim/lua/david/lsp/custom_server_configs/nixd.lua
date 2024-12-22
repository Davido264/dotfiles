return {
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixpkgs-fmt" },
      },
      options = {
        -- For option autocomplete. 'options' will have all options defined by modules
        nixos = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.laptop.options',
        },

        -- For flake-parts opitons.
        -- Firstly read the docs here to enable "debugging", exposing declarations for nixd.
        -- https://flake.parts/debug
        ["flake-parts"] = {
          expr = '(builtins.getFlake "/path/to/your/flake").currentSystem.options',
        },
      },
    },
  },
}
