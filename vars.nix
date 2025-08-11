{
  lib,
  ...
}:
{
  options.home_network_url = lib.options.mkOption {
    default = "ngodag.com";
    description = "A url which points to main home network";
    type = lib.types.str;
  };
}
