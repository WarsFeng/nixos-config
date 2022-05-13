#
#  Sway Home manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./sway
#               └─ home.nix *
#

{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;                          # Enable sway-session.target to link to graphical-session.target for systemd
    config = rec {                                      # Sway configuration
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.rofi}/bin/rofi -show drun";

      startup = [                                       # Run commands on Sway startup
        {command = "${pkgs.autotiling}/bin/autotiling"; always = true;} # Tiling Script
        {command = ''
          ${pkgs.swayidle}/bin/swayidle -w \
              before-sleep '${pkgs.swaylock-fancy}/bin/swaylock-fancy'
        ''; always = true;}                             # Lock on lid close
        #{command = ''
        #  ${pkgs.swayidle}/bin/swayidle \
        #    timeout 120 '${pkgs.swaylock-fancy}/bin/swaylock-fancy' \
        #    timeout 240 'swaymsg "output * dpms off"' \
        #    resume 'swaymsg "output * dpms on"' \
        #    before-sleep '${pkgs.swaylock-fancy}/bin/swaylock-fancy'
        #''; always = true;}                            # Auto lock\
      ];

      bars = [];                                        # No bar because using Waybar

      fonts = {                                         # Font usedfor window tiles, navbar, ...
        names = [ "Source Code Pro" ];
        size = 10.0;
      };

      gaps = {                                          # Gaps for containters
        inner = 3;
        outer = 3;
      };

      input = {                                         # Input modules: $ man sway-input
        "type:touchpad" = {
          tap = "disabled";
          dwt = "enabled";
          scroll_method = "two_finger";
          middle_emulation = "enabled";
          natural_scroll = "enabled";
        };
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_numlock = "enabled";
        };
      };

      output = {
        "*".bg = "~/.config/wall fill";
        "*".scale = "1";
      };

      keybindings = {                                   # Hotkeys
        "${modifier}+Escape" = "exec swaymsg exit";     # Exit Sway
        "${modifier}+Return" = "exec ${terminal}";      # Open terminal
        "${modifier}+space" = "exec ${menu}";           # Open menu
        "${modifier}+e" = "exec ${pkgs.pcmanfm}/bin/pcmanfm"; # File Manager
        "${modifier}+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy"; # Lock Screen

        "${modifier}+r" = "reload";                     # Reload environment
        "${modifier}+q" = "kill";                       # Kill container
        "${modifier}+f" = "fullscreen toggle";          # Fullscreen
        "${modifier}+h" = "floating toggle";            # Floating

        "${modifier}+Left" = "focus left";              # Focus container in workspace
        "${modifier}+Right" = "focus right";
        "${modifier}+Up" = "focus up";
        "${modifier}+Down" = "focus down";
        
        "${modifier}+Shift+Left" = "move left";         # Move container in workspace
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Down" = "move down";

        "Alt+Left" = "workspace prev";                  # Navigate to previous or next workspace if it exists
        "Alt+Right" = "workspace next";

        "Alt+1" = "workspace number 1";                 # Open workspace x
        "Alt+2" = "workspace number 2";
        "Alt+3" = "workspace number 3";
        "Alt+4" = "workspace number 4";
        "Alt+5" = "workspace number 5";

        "Alt+Shift+Left" = "move container to workspace prev, workspace prev";    # Move container to next available workspace and focus
        "Alt+Shift+Right" = "move container to workspace next, workspace next";

        "Alt+Shift+1" = "move container to workspace number 1";     # Move container to specific workspace
        "Alt+Shift+2" = "move container to workspace number 2";
        "Alt+Shift+3" = "move container to workspace number 3";
        "Alt+Shift+4" = "move container to workspace number 4";
        "Alt+Shift+5" = "move container to workspace number 5";

        "Control+Up" = "resize shrink height 20px";     # Resize container
        "Control+Down" = "resize grow height 20px";
        "Control+Left" = "resize shrink width 20px";
        "Control+Right" = "resize grow width 20px";

        "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui"; # Screenshots

        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 10";   #Volume control
        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 10";
        "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";             #Media control
        "XF86AudioMicMute" = "exec ${pkgs.pamixer}/bin/pamixer --default-source -t";
        #"XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        #"XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        #"XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        #
        "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U  5";      # Display brightness control
        "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
      };
    };
    extraConfig = ''
      set $opacity 0.8
      for_window [app_id="pcmanfm"] opacity 0.95, floating enable
      for_window [app_id="Alacritty"] opacity $opacity
      for_window [title="drun"] opacity $opacity
      for_window [class="Google-chrome"] move container to workspace number 2, workspace number 2
      for_window [class="Emacs"] opacity $opacity, move container to workspace number 3, workspace number 3
      for_window [app_id="pavucontrol"] floating enable, sticky
      for_window [app_id=".blueman-manager-wrapped"] floating enable
      for_window [title="Picture in picture"] floating enable, move position 1205 634, resize set 700 400, sticky enable
    '';                                    # $ swaymsg -t get_tree or get_outputs
    extraSessionCommands = ''
      #export WLR_NO_HARDWARE_CURSORS="1";  # Needed for cursor in vm
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
    '';
  };

  #services = {                             # Dynamic display configuration
  #  kanshi = {
  #    enable = true;
  #    profiles = {
  #      screen1 = {                        # Profile 1
  #        outputs = [{
  #          criteria = "<display> or wildcard *";
  #          mode = "1920x1080@60Hz";
  #        }];
  #      };
  #      screen2 = {                        # Profile 2
  #        outputs = [
  #          {
  #            criteria = "<display1>";
  #            mode = "1920x1080@60Hz";
  #          }
  #          {
  #            criteria = "<display2";
  #            mode = "1920x1080@60Hz";
  #          }
  #        ];
  #      };
  #    };
  #  };
  #};
}
