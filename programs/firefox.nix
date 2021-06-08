{ config, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        enableUgetIntegrator = true;
        pipewireSupport = true;
        ffmpegSupport = true;
        enablePlasmaBrowserIntegration = true;
        enableGnomeExtensions = true;
      };
    };
    profiles = {
      homeNix = {
        isDefault = true;
        id = 0;
        settings = {
          "browser.startup.homepage" = "https://duckduckgo.com";
          "browser.search.region" = "US";
          "browser.search.isUS" = true;
          "distribution.searchplugins.defaultLocale" = "en-US";
          "general.useragent.locale" =
            "${"distribution.searchplugins.defaultLocale"}";
          "browser.bookmarks.showMobileBookmarks" = true;
        };
      };
    };
  };
}
