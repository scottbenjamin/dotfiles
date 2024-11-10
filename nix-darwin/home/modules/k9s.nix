{...}: {
  programs.k9s = {
    enable = true;
    # https://github.com/derailed/k9s/tree/master/plugins
    plugin = {};
  };
}
