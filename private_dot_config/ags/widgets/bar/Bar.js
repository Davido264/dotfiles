import {
  AudioIndicator,
  BateryIndicator,
  BluetoothIndicator,
  MicIndicator,
  NetworkIndicator,
  NotificationIndicator,
  ProfileIndicator,
} from "./Indicators.js";

import { Clock } from "./Clock.js";
import { Workspaces } from "./Workspaces.js";
import { SysTray } from "./Tray.js"

export const Bar = (/** @type {number} */ monitor) =>
  Widget.Window({
    monitor,
    name: `bar-${monitor}`,
    className: "bar",
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      startWidget: Widget.Box({
        children: [
          Clock(),
          SysTray(),
          NotificationIndicator(),
        ],
      }),
      centerWidget: Workspaces(),
      // TODO: game mode, privacy icons (camera, screen), iddle
      endWidget: Widget.Box({
        hpack: "end",
        children: [
          MicIndicator(),
          AudioIndicator(),
          BluetoothIndicator(),
          NetworkIndicator(),
          ProfileIndicator(),
          BateryIndicator(),
        ],
      }),
    }),
  });
