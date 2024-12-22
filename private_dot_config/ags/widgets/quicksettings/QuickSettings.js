// wifi, bluetooth, profile, mute
import Gdk from "gi://Gdk";
import Gtk from "gi://Gtk?version=3.0";

import {
  PowerProfileToggle,
  PowerProfileSelector,
} from "./PowerProfileToggles.js";

import { NetworkToggle, WifiSelection } from "./NetworkToggles.js";

import { BluetoothToggle, BluetoothDevices } from "./BluetoothToggles.js";

const hyprland = await Service.import("hyprland");

/** @typedef {import("gi://Gtk?version=3.0").default.Widget} Gtk.Widget */

/** @param {Array<() => Gtk.Widget>} toggles */
/** @param {Array<() => Gtk.Widget>} menus */
const Row = (toggles = [], menus = []) =>
  Widget.Box({
    vertical: true,
    children: [
      Widget.Box({
        homogeneous: true,
        class_name: "row horizontal",
        children: toggles.map((w) => w()),
      }),
      ...menus.map((w) => w()),
    ],
  });

export const QuickSettings = () => {
  const QS = Widget.subclass(Gtk.Window);
  return QS({
    appPaintable: true,
    canFocus: true,
    name: "quick-settings",
    className: "popup-window",
    setup: (w) => w.keybind("Escape", () => App.closeWindow("quick-settings")),
    visible: false,
    // keymode: "exclusive",
    // exclusivity: "exclusive",
    // layer: "top",
    child: Widget.Scrollable({
      className: "quick-settings",
      child: Widget.Box({
        vertical: true,
        children: [
          Row(
            [NetworkToggle, BluetoothToggle],
            [WifiSelection, BluetoothDevices],
          ),
          Row([PowerProfileToggle], [PowerProfileSelector]),
        ],
      }),
    }),
  });
};
