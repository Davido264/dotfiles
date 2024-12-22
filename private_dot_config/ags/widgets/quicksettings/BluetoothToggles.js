// TODO: Test

import { Menu, ArrowToggleButton } from "./ToggleButton.js";

/** @typedef {import("types/service/bluetooth").BluetoothDevice} BluetoothDevice */

const bluetooth = await Service.import("bluetooth");

export const BluetoothToggle = () =>
  ArrowToggleButton({
    name: "bluetooth",
    icon: bluetooth
      .bind("enabled")
      .as((p) =>
        p ? "bluetooth-active-symbolic" : "bluetooth-disabled-symbolic",
      ),
    label: Utils.watch("Disabled", bluetooth, () => {
      if (!bluetooth.enabled) return "Disabled";

      if (bluetooth.connected_devices.length === 1)
        return bluetooth.connected_devices[0].alias;

      return `${bluetooth.connected_devices.length} Connected`;
    }),
    connection: [bluetooth, () => bluetooth.enabled],
    deactivate: () => (bluetooth.enabled = false),
    activate: () => (bluetooth.enabled = true),
  });

const DeviceItem = (/** @param {BluetoothDevice} device */ device) =>
  Widget.Box({
    children: [
      Widget.Icon({
        className: "icon",
        icon: device.icon_name + "-symbolic"
      }),
      Widget.Label(device.name),
      Widget.Label({
        label: `${device.battery_percentage}%`,
        visible: device.bind("battery_percentage").as((p) => p > 0),
      }),
      Widget.Box({ hexpand: true }),
      Widget.Spinner({
        active: device.bind("connecting"),
        visible: device.bind("connecting"),
      }),
      Widget.Switch({
        active: device.connected,
        visible: device.bind("connecting").as((p) => !p),
        setup: (self) =>
          self.on("notify::active", () => {
            device.setConnection(self.active);
          }),
      }),
    ],
  });

export const BluetoothDevices = () =>
  Menu({
    name: "bluetooth",
    icon: "bluetooth-disabled-symbolic",
    title: "Bluetooth",
    content: [
      Widget.Box({
        class_name: "bluetooth-devices",
        hexpand: true,
        vertical: true,
        children: bluetooth
          .bind("devices")
          .as((ds) => ds.filter((d) => d.name).map(DeviceItem)),
      }),
    ],
  });
