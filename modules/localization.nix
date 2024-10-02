{ config
, lib
, ...
}:

let
  inherit (lib) mkOption;
  # inherit (patt) language formatting timezone;
  # name = "formatting";
  cfg = config.localization;
in {

  options.localization = {
    language = mkOption {
      default = "en_GB";
    };
    formatting = mkOption {
      default = "en_GB";
    };
    timezone = mkOption {
      default = "Europe/London";
    };
  };

  config = {
    i18n.defaultLocale  = "${cfg.language}";
    i18n.extraLocaleSettings = {
      LC_ADDRESS        = "${cfg.formatting}";
      LC_IDENTIFICATION = "${cfg.formatting}";
      LC_MEASUREMENT    = "${cfg.formatting}";
      LC_MONETARY       = "${cfg.formatting}";
      LC_NAME           = "${cfg.formatting}";
      LC_NUMERIC        = "${cfg.formatting}";
      LC_PAPER          = "${cfg.formatting}";
      LC_TELEPHONE      = "${cfg.formatting}";
      LC_TIME           = "${cfg.formatting}";
    };
    time.timeZone = "${cfg.timezone}";
  };

}
