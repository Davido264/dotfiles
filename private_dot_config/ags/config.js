import Gtk from "gi://Gtk?version=3.0";
import Gdk from "gi://Gdk";
import { Bar } from "./widgets/bar/Bar.js";
import { NotificationPopups } from "./widgets/notifications/Popup.js";
import { QuickSettings } from "./widgets/quicksettings/QuickSettings.js";
import OSD from "./widgets/osd/OSD.js";

/**
 * For Monitors func
 * @callback WidgetComponentFunc
 * @param {number} monitor
 * @returns {Gtk.Window}
 */

/** @param {WidgetComponentFunc} widget */
function forMonitors(widget) {
  const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
  const arr = new Array(n);
  for (let i = 0; i < n; i++) {
    arr[i] = widget(i);
  }
  return arr;
}

function updateBars() {
  const nw = App.windows.length;

  for (let i = nw - 1; i >= 0; i--) {
    App.remove_window(App.windows[i]);
  }

  const newBars = forMonitors(Bar);

  newBars.push(NotificationPopups());
  newBars.push();
  newBars.push(OSD());

  App.config({
    style: "./style.css",
    windows: newBars,
    gtkTheme: "adw-gtk3-dark",
  });
}

// const hyprland = await Service.import("hyprland");
// hyprland.connect("monitor-added", (_) => {
//   updateBars();
// });
// 
// hyprland.connect("monitor-removed", (_) => {
//   updateBars();
// });

const notifications = await Service.import("notifications");
await notifications.clear();

const qs = QuickSettings();
const windows = forMonitors(Bar);
windows.push(NotificationPopups());
windows.push();
windows.push(OSD());

qs.show_all();

App.config({
  style: "./style.css",
  windows: windows,
  gtkTheme: "adw-gtk3-dark",
});
