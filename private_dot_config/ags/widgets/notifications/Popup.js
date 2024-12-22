import { gc } from "system";
import Notification from "./Notification.js";

const notifications = await Service.import("notifications");
const hyprland = await Service.import("hyprland");

const timeout = 100;

/** Animates a popup from the top
 * @param {number} id
 */
function Animated(id) {
  const n = notifications.getNotification(id);
  const widget = Notification(n);

  const outer = Widget.Revealer({
    transition: "slide_down",
    transition_duration: timeout,
    child: widget,
  });

  const box = Widget.Box({
    hpack: "end",
    child: outer,
  });

  Utils.idle(() => {
    outer.reveal_child = true;
  });

  return box;
}

/** Manages the popup list. 
 * Originally, on https://github.com/Aylur/dotfiles/blob/main/ags/widget/notifications/NotificationPopups.ts
 * this manages a timeout independently for every popup, and If multiple popups appear, it stacks them resulting
 * in a list of popup that eventually hide themself.
 * I didn't want that because I'm trying to squeeze the memory I have, and I don't want to create to much objects,
 * plus, I don't see too much benefit of all those popups, I rather have a notification center where I can see all
 * notifications if I cannot read them from the popup.
 * And I know its probably better to have this working and then profile it, but hey! I have it working this way.
 * Currently, on new notifications, the previous popup is destroyed, so I only have one popup at the time 
 * (can I reuse the popup?)
 * */
function PopupList() {
  /** @type {Map<number, ReturnType<typeof Animated>>} map */
  const map = new Map();
  const box = Widget.Box({
    hpack: "end",
    vertical: true,
    className: "popup-container",
  });

  const remove = (_, /** @param {number} id */ id) => {
    const b = map.get(id);

    if (b) {
      Utils.timeout(timeout, () => {
        if (!b.is_destroyed) {
          b.child.reveal_child = false;
          Utils.timeout(timeout, () => {
            b.destroy();
          });
        }
        // Trigger GC to collect the destroyed window
        gc();
      });
    }
    map.delete(id);
  };

  return box
    .hook(
      notifications,
      (_, /** @param {number} id */ id) => {
        if (id !== undefined) {
          if (map.has(id)) remove(null, id);

          if (notifications.dnd) return;

          const w = Animated(id);
          map.set(id, w);
          box.child?.destroy();
          box.child = w;
        }
      },
      "notified",
    )
    .hook(notifications, remove, "dismissed")
    .hook(notifications, remove, "closed");
}

export const NotificationPopups = () =>
  Widget.Window({
    monitor: hyprland.active.bind("monitor").as(m => m.id),
    name: `notifications`,
    anchor: ["top"],
    className: "notifications-popup",
    child: Widget.Box({
      css: "padding: 2px;",
      child: PopupList(),
    }),
  });
