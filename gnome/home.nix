{ config, lib, pkgs, username, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.launch-new-instance
    gnomeExtensions.gesture-improvements
    #gnomeExtensions.pano
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.vitals
    gnomeExtensions.gsconnect
    gnomeExtensions.app-icons-taskbar
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.nothing-to-say
    # Do not disturb while screen sharing or recording ?
    gnomeExtensions.no-overview
    gnomeExtensions.expandable-notifications
    gnomeExtensions.just-perfection
    gnomeExtensions.material-you-color-theming
    gnomeExtensions.date-menu-formatter
    # fly pie ?
    gnomeExtensions.transparent-top-bar-adjustable-transparency
    gnomeExtensions.blur-my-shell
    gnomeExtensions.desktop-icons-ng-ding
    # emoji copy ?
    
    simp1e-cursors
  ];
  
  
  # https://www.reddit.com/r/NixOS/comments/ytr2h7/set_system_icons_with_homemanager/
  # https://discourse.nixos.org/t/trouble-setting-gtk-and-qt-themes-with-hm-options/21227
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      package = pkgs.simp1e-cursors;
      name = "Simp1e";
    };
  };
  
  nixpkgs.config.firefox.enableGnomeExtensions = true; 
    
  # https://rycee.gitlab.io/home-manager/options.html#opt-dconf.settings
  # https://github.com/gvolpe/dconf2nix#introduction
  dconf.settings = {
    
    # =============== Default settings ===============
  
    # Enable tap to click by default
    # https://askubuntu.com/a/403115
    # https://github.com/NixOS/nixpkgs/issues/66554#issuecomment-520897373
    # https://discourse.nixos.org/t/gnome3-settings-via-configuration-nix/5121
    # To reset: gsettings reset org.gnome.desktop.peripherals.touchpad tap-to-click
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      natural-scroll=false;
    };
    
    "org/gnome/desktop/interface" = {
      # Enable dark mode by default
      # https://askubuntu.com/a/1403780
      color-scheme = "prefer-dark";
      # Disable default hot corner
      # https://askubuntu.com/a/1097397
      enable-hot-corners = false;
      clock-show-seconds=true;
    };
    
    # Enable dark mode in root apps by default
    # To reset: gsettings reset org.gnome.desktop.interface gtk-theme
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
    };
    
    # https://askubuntu.com/a/1481560
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };
    
    # Bring back minimize and maximize buttons by default
    # https://askubuntu.com/a/651349
    # To reset: gsettings reset org.gnome.desktop.wm.preferences button-layout
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
      num-workspaces = 4;
    };

    # Show seconds and weekday
    "org/gnome/desktop/interface" = {
      clock-show-seconds = false;
      clock-show-weekday = true;
    };
      
    # prevent showing poweroff / reboot / logout confirmation
    "org/gnome/gnome-session" = {
      logout-prompt=false;
    };
    
    # =============== Key bindings ===============
    
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = ["<Super>Tab"];
      switch-windows = ["<alt>Tab"];
      close = ["<Shift><Alt>q"];
    };
    
    "org/gnome/shell/keybindings" = {
      screenshot = [];			# use flameshot instead
      show-screenshot-ui = [];		# use flameshot instead
      focus-active-notification = [];
      toggle-message-tray = ["<Super>n"];
    };
   
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = ["<Super>e"];
      custom-keybindings= [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding="<Alt><Super>f";
      command="firefox --private-window";
      name="Incognito Firefox";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding="<Super>f";
      command="firefox";
      name="Firefox";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding="<Super><Shift>f";
      command="firefox -p /e/";
      name="Firefox /e/";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding="<Super>t";
      command="kgx";
      name="Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding="<Super>w";
      command="epiphany";
      name="Gnome web (epiphany)";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      binding="Print";
      command="flameshot full -p /home/${username}/Pictures -c";
      name="Fullscreen screenshot";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      binding="<Shift>Print";
      command="flameshot gui -p /home/${username}/Pictures -c";
      name="Partial screenshot";
    };
      
    # =============== Application settings ===============
      
    "org/gnome/TextEditor" = {
      show-line-numbers=true;
    };
      
    "org/gnome/epiphany" = {
      search-engine-providers = with lib.hm.gvariant; [
        [ 
          (mkDictionaryEntry["url" (mkVariant "https://www.startpage.com/search?q=%s")])
          (mkDictionaryEntry["bang" (mkVariant "!s")])
          (mkDictionaryEntry["name" (mkVariant "Startpage")])
        ]
        [ 
          (mkDictionaryEntry["url" (mkVariant "https://search.nixos.org/packages?query=%s")])
          (mkDictionaryEntry["bang" (mkVariant "!np")])
          (mkDictionaryEntry["name" (mkVariant "Nix Packages")])
        ]
        [ 
          (mkDictionaryEntry["url" (mkVariant "https://search.nixos.org/options?query=%s")])
          (mkDictionaryEntry["bang" (mkVariant "!no")])
          (mkDictionaryEntry["name" (mkVariant "Nix Options")])
        ]
        [ 
          (mkDictionaryEntry["url" (mkVariant "https://search.nixos.org/flakes?query=%s")])
          (mkDictionaryEntry["bang" (mkVariant "!nf")])
          (mkDictionaryEntry["name" (mkVariant "Nix Flakes")])
        ]
      ];
      default-search-engine="Startpage";
      ask-for-default=false;
      start-in-incognito-mode=true;
      use-google-search-suggestions=true;
    };
      
    "org/gnome/epiphany/web" = {
      remember-passwords=false;
    };
      
    "org/gnome/desktop/notifications/application/firefox" = {
      application-id="firefox.desktop";
    };
      
    # =============== shell and extensions ===============
    
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "window-list@gnome-shell-extensions.gcampax.github.com"
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
      ];
      enabled-extensions = [
        "gestureImprovements@gestures"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        #"pano@elhan.io"
        "clipboard-indicator@tudmotu.com"
        "Vitals@CoreCoding.com"
        "gsconnect@andyholmes.github.io"
        "aztaskbar@aztaskbar.gitlab.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
        "nothing-to-say@extensions.gnome.wouter.bolsterl.ee"
        "do-not-disturb-while-screen-sharing-or-recording@marcinjahn.com"
        "no-overview@fthx"
        "expandable-notifications@kaan.g.inam.org"
        "just-perfection-desktop@just-perfection"
        #"material-you-theme@asubbiah.com"
        "flypie@schneegans.github.com"
        "transparent-top-bar@ftpix.com"
        "blur-my-shell@aunetx"
        "ding@rastersoft.com"
        "emoji-copy@felipeftn"
        #"gnome-shell-screenshot@ttll.de"
      ];
      favorite-apps=["org.gnome.Epiphany.desktop" "firefox.desktop" "org.gnome.Console.desktop" "org.gnome.Nautilus.desktop" "org.gnome.TextEditor.desktop"];
    };
      
    "org/gnome/shell/extensions/gestureImprovements" = {
      allow-minimize-window=true;
      default-overview-gesture-direction=true;
      enable-alttab-gesture=true;
      enable-forward-back-gesture=true;
      follow-natural-scroll=false;
      overview-navifation-states="CYCLIC";
      pinch-3-finger-gesture="CLOSE_DOCUMENT";
      pinch-4-finger-gesture="CLOSE_WINDOW";
      
      # Using dictionaries
      # https://discourse.nixos.org/t/write-key-value-using-lib-hm-gvariant-for-home-manager/31234/7?u=line0174
      forward-back-application-keyboard-shortcuts = with lib.hm.gvariant; [ 
        (mkDictionaryEntry["firefox.desktop" (mkTuple[5 true])])
        (mkDictionaryEntry["org.gnome.Epiphany.desktop" (mkTuple[5 true])])
        (mkDictionaryEntry["org.gnome.TextEditor.desktop" (mkTuple[5 true])])
        (mkDictionaryEntry["org.gnome.Nautilus.desktop" (mkTuple[1 true])])
        (mkDictionaryEntry["org.gnome.Console.desktop" (mkTuple[5 true])])
      ];
    };
    
    #"org/gnome/shell/extensions/pano" = {
    #  global-shortcut=["<Super>v"];
    #  history-length=50;
    #  paste-on-select=false;
    #  play-audio-on-copy=false;
    #  send-notification-on-copy=false;
    #  window-height=300;
    #  link-previews=false;
    #  open-links-in-browser=false;
    #};
    
    "org/gnome/shell/extensions/clipboard-indicator" = {
      cache-size=16384;
      clear-history=[];
      disable-down-arrow=true;
      history-size=30;
      next-entry=[];
      prev-entry=[];
      preview-size=100;
      toggle-menu=["<Super>v"];
    };
      
    "org/gnome/shell/extensions/vitals" = {
      alphabetize=true;
      fixed-widths=true;
      hide-icons=false;
      hot-sensors=["__network-rx_max__" "_temperature_acpi_thermal zone_" "_memory_usage_"];
      include-static-info=false;
      show-battery=true;
      show-fan=true;
      show-processor=true;
      show-system=true;
      update-time=1;
    };
      
    "org/gnome/shell/extensions/aztaskbar" = {
      click-action="CYCLE";
      dance-urgent=true;
      favorites=true;
      icon-size=24;
      icon-style="REGULAR";
      isolate-workspaces=false;
      main-panel-height=lib.hm.gvariant.mkTuple[true 40];
      multi-window-indicator-style="MULTI_DASH";
      panel-location="TOP";
      peek-windows=true;
      position-in-panel="LEFT";
      show-apps-button=lib.hm.gvariant.mkTuple[true 0];
    };
      
    "org/gnome/shell/extensions/caffeine" = {
      indicator-position-max=1;
      show-indicator="only-active";
    };
      
    "org/gnome/shell/extensions/nothing-to-say" = {
      keybinding-toggle-mute=["<Super>AudioMute"];
      show-osd=true;
    };
      
    "org/gnome/shell/extensions/just-perfection" = {
      activities-button=true;
      app-menu=false;
      app-menu-icon=true;
      app-menu-label=false;
      show-apps-button=true;
      weather=false;
      window-demands-attention-focus=true;
      world-clock=false;
    };
    
    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness=0.80;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur=false;
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur=true;
    };
      
    "org/gnome/shell/extensions/ding" = {
      check-x11wayland=true;
      dark-text-in-labels=false;
      show-home=false;
      show-network-volumes=false;
      show-trash=false;
      show-volumes=true;
      start-corner="bottom-left";
    };
      
    "org/gnome/shell/extensions/emoji-copy" = {
      always-show=true;
      emoji-keybinding=["<Super>period"];
      use-keybinding=true;
    };

  };  
}
