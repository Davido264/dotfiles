import Gdk from "gi://Gdk";

const systemtray = await Service.import("systemtray");

function trayItem(/** @param {TraiItem} item */ item) {
  return Widget.Button({
    className: "tray-icon",
    tooltip_markup: item.bind("tooltip_markup"),
    image: Widget.Icon({
      icon: item.bind("icon"),
    }),

    on_primary_click: (btn) =>
      item.menu?.popup_at_widget(
        btn,
        Gdk.Gravity.SOUTH,
        Gdk.Gravity.NORTH,
        null,
      ),

    on_secondary_click: (btn) =>
      item.menu?.popup_at_widget(
        btn,
        Gdk.Gravity.SOUTH,
        Gdk.Gravity.NORTH,
        null,
      ),

    setup: (self) => {
      const { menu } = item;
      if (!menu) {
        return;
      }

      const id = menu.connect("popped-up", () => {
        self.toggleClassName("active");
        menu.connect("notify::visible", () => {
          self.toggleClassName("active", menu.visible);
        });
        menu.disconnect(id);
      });

      self.connect("destroy", () => menu.disconnect(id));
    },
  });
}

export const SysTray = () =>
  Widget.Revealer({
    hpack: "start",
    vpack: "center",
    transition: "slide_right",
    className: "systemtray",
    revealChild: systemtray.bind("items").as((i) => i.length > 0),
    child: Widget.Box({
      children: systemtray
        .bind("items")
        .as((items) => items.map((i) => trayItem(i))),
    }),
  });
