const bluetooth = await Service.import("bluetooth");
const audio = await Service.import("audio");
const network = await Service.import("network");
const powerprof = await Service.import("powerprofiles");
const battery = await Service.import("battery");
const notifications = await Service.import("notifications");

export const ProfileIndicator = () =>
  Widget.Revealer({
    vpack: "center",
    transition: "slide_right",
    classNames: ["power-profile-indicator", "indicator"],
    revealChild: powerprof.bind("active_profile").as((p) => p !== "balanced"),
    child: Widget.Icon({
      classNames: ["profile-indicator", "indicator"],
      tooltipText: powerprof.bind("active_profile"),
      icon: powerprof.bind("active_profile").as((p) => {
        switch (p) {
          case "balanced":
            return "power-profile-balanced-symbolic";
          case "power-saver":
            return "power-profile-power-saver-symbolic";
          case "performance":
            return "power-profile-performance-symbolic";
          default:
            return p;
        }
      }),
    }),
  });

export const MicIndicator = () =>
  Widget.Revealer({
    vpack: "center",
    classNames: ["mic-indicator", "indicator"],
    transition: "slide_right",
    child: Widget.Icon({
      icon: "audio-input-microphone-symbolic",
    }),
  }).hook(audio, (self) => {
    self.reveal_child = audio.recorders.length > 0;
  });

export const BluetoothIndicator = () =>
  Widget.Revealer({
    vpack: "center",
    classNames: ["bluetooth-indicator", "indicator"],
    transition: "slide_right",
    child: Widget.Icon({
      icon: "bluetooth-active-symbolic",
    }),
  }).hook(bluetooth, (self) => {
    self.reveal_child = bluetooth.enabled;
  });

export const NetworkIndicator = () =>
  Widget.Box({
    vpack: "center",
    classNames: ["network-indicator", "indicator"],
    children: [
      Widget.Revealer({
        transition: "slide_right",
        child: Widget.Icon({}),
      }).hook(network, (self) => {
        const icon = network[network.primary || "wifi"]?.icon_name;
        self.reveal_child = icon !== "";
        self.child.icon = icon || "";
        if (network.primary !== null) {
          self.tooltip_text = ``;
        }
      }),
      Widget.Revealer({
        transition: "slide_right",
        revealChild: network.vpn
          .bind("activated_connections")
          .as((c) => c.length > 0),
        child: Widget.Icon({
          icon: "network-vpn",
        }),
      }),
    ],
  });

export const AudioIndicator = () =>
  Widget.Revealer({
    vpack: "center",
    classNames: ["audio-indicator", "indicator"],
    transition: "slide_right",
    child: Widget.Icon({
      icon: "audio-volume-muted-symbolic",
    }),
  }).hook(audio, (self) => {
    self.reveal_child = audio.speaker.is_muted || false;
  });

export const BateryIndicator = () =>
  Widget.Box({
    classNames: ["battery-indicator", "indicator"],
    visible: battery.bind("available"),
    hpack: "center",
    vpack: "center",
    children: [
      Widget.Icon().hook(battery, (self) => {
        self.icon = battery.icon_name;
      }),
      Widget.Label({
        vpack: "center",
        label: battery.bind("percent").as((e) => {
          if (!battery.charging) {
            if (e == 45 || e == 30 || e == 20) {
              Utils.execAsync(`notify-send 'Low Battery' '${e}% of battery reminding' -u critical -i 'battery-empty-symbolic' -r 9991`);
            }
          }
          return `${e}%`;
        }),
      }),
    ],
  });

export const NotificationIndicator = () =>
  Widget.Revealer({
    vpack: "center",
    hpack: "center",
    classNames: ["notifications-indicator", "indicator"],
    revealChild: notifications.bind("notifications").as((n) => n.length > 0),
    tooltipText: notifications
      .bind("notifications")
      .as((n) => `${n.length} notification(s)`),
    child: Widget.Icon({ icon: "user-status-pending-symbolic" }),
  });
