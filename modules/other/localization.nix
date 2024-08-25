{ config, lib, ... }:

{

 #====<< Internationalisation properties. >>===================================>
  options.extraLocaleSettings = lib.mkOption {
    default                   = "en_GB.UTF-8";
  };

  config.i18n = {
    extraLocaleSettings = {
      LC_ADDRESS         = "${config.extraLocaleSettings}";
      LC_IDENTIFICATION  = "${config.extraLocaleSettings}";
      LC_MEASUREMENT     = "${config.extraLocaleSettings}";
      LC_MONETARY        = "${config.extraLocaleSettings}";
      LC_NAME            = "${config.extraLocaleSettings}";
      LC_NUMERIC         = "${config.extraLocaleSettings}";
      LC_PAPER           = "${config.extraLocaleSettings}";
      LC_TELEPHONE       = "${config.extraLocaleSettings}";
      LC_TIME            = "${config.extraLocaleSettings}"; 
    };
  };

}
