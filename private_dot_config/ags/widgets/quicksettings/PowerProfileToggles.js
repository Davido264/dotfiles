import { Menu, ArrowToggleButton } from "./ToggleButton.js";

const pp = await Service.import("powerprofiles");

const profile = pp.bind("active_profile");
const profiles = pp.profiles.map((p) => p.Profile);

function pretty(/** @param {string} str */ str) {
  return str
    .split("-")
    .map((str) => `${str.at(0)?.toUpperCase()}${str.slice(1)}`)
    .join(" ");
}

function icon(/** @param {string} str */ str) {
  switch (str) {
    case "balanced":
      return "power-profile-balanced-symbolic";
    case "power-saver":
      return "power-profile-power-saver-symbolic";
    case "performance":
      return "power-profile-performance-symbolic";
    default:
      return str;
  }
}

export const PowerProfileToggle = () =>
  ArrowToggleButton({
    name: "asusctl-profile",
    icon: profile.as(icon),
    label: profile.as(pretty),
    connection: [pp, () => pp.active_profile !== profiles[1]],
    activate: () => (pp.active_profile = profiles[0]),
    deactivate: () => (pp.active_profile = profiles[1]),
    activateOnArrow: false,
  });

export const PowerProfileSelector = () =>
  Menu({
    name: "asusctl-profile",
    icon: profile.as(icon),
    title: "Profile Selector",
    content: [
      Widget.Box({
        vertical: true,
        hexpand: true,
        child: Widget.Box({
          vertical: true,
          children: profiles.map((prof) =>
            Widget.Button({
              on_clicked: () => (pp.active_profile = prof),
              child: Widget.Box({
                children: [
                  Widget.Icon({
                    className: "icon",
                    icon: icon(prof),
                  }),
                  Widget.Label({
                    className: "label",
                    label: pretty(prof),
                  }),
                ],
              }),
            }),
          ),
        }),
      }),
    ],
  });
