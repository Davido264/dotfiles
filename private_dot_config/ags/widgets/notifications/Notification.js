import GLib from "gi://GLib";

/** @param {number} time */
/** @param {string} format */
function time(time, format = "%H:%M") {
  return GLib.DateTime.new_from_unix_local(time).format(format);
}

function NotificationIcon(
  /** @param {Notification} notif */ { app_entry, app_icon, image },
) {
  if (image) {
    return Widget.Box({
      vpack: "start",
      hexpand: false,
      classNames: ["icon", "img"],
      css: `background-image: url("${image}");`,
    });
  }

  let icon = "dialog-information-symbolic";
  if (Utils.lookUpIcon(app_icon)) icon = app_icon;

  if (Utils.lookUpIcon(app_entry || "")) icon = app_entry || "";

  return Widget.Box({
    vpack: "start",
    hexpand: false,
    className: "icon",
    child: Widget.Icon({
      icon,
      size: 58,
      hpack: "center",
      hexpand: true,
      vpack: "center",
      vexpand: true,
    }),
  });
}

export default (/** @param {Notification} notification */ notification) => {
  const textContent = Widget.Box({
    setup: (self) => {
      if (notification.body.trim() !== "") {
        self.children = [
          Widget.Label({
            class_name: "title",
            xalign: 0,
            justification: "left",
            hexpand: true,
            max_width_chars: 24,
            truncate: "end",
            wrap: true,
            label: notification.summary.trim(),
            use_markup: true,
          }),
          Widget.Label({
            class_name: "description",
            hexpand: true,
            use_markup: true,
            xalign: 0,
            justification: "left",
            label: notification.body.trim(),
            max_width_chars: 24,
            wrap: true,
          }),
        ];
      } else {
        self.child = Widget.Label({
          class_name: "title",
          justification: "left",
          hexpand: true,
          vpack: "center",
          max_width_chars: 24,
          truncate: "end",
          wrap: true,
          label: notification.summary.trim(),
          use_markup: true,
        });
        self.vpack = "center";
        self.vexpand = true;
      }
    },
  });

  const content = Widget.Box({
    class_name: "content",
    children: [
      NotificationIcon(notification),
      Widget.Box({
        hexpand: true,
        vertical: true,
        children: [
          Widget.Box({
            children: [
              textContent,
              Widget.Label({
                class_name: "time",
                vpack: "start",
                label: time(notification.time),
              }),
              Widget.Button({
                className: "close-button",
                vpack: "start",
                child: Widget.Icon("window-close-symbolic"),
                on_clicked: notification.close,
              }),
            ],
          }),
        ],
      }),
    ],
  });

  const actionsbox =
    notification.actions.length > 0
      ? Widget.Revealer({
          transition: "slide_down",
          child: Widget.EventBox({
            child: Widget.Box({
              class_name: "actions horizontal",
              children: notification.actions.map((action) =>
                Widget.Button({
                  class_name: "action-button",
                  on_clicked: () => notification.invoke(action.id),
                  hexpand: true,
                  child: Widget.Label(action.label),
                }),
              ),
            }),
          }),
        })
      : null;

  const eventbox = Widget.EventBox({
    vexpand: false,
    on_primary_click: notification.dismiss,
    on_hover() {
      if (actionsbox) actionsbox.reveal_child = true;
    },
    on_hover_lost() {
      if (actionsbox) actionsbox.reveal_child = true;

      notification.dismiss();
    },
    child: Widget.Box({
      vertical: true,
      children: actionsbox ? [content, actionsbox] : [content],
    }),
  });

  return Widget.Box({
    classNames: ["notification", notification.urgency],
    child: eventbox,
  });
};
