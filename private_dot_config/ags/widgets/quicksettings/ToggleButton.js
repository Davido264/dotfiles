import GObject from "gi://GObject?version=2.0";
import Gtk from "gi://Gtk?version=3.0";

export const opened = Variable("");

/** @callback VoidCallback
 */

/** @callback BoolCallback
 *  @return {boolean}
 */

/** @typedef {import("types/widgets/icon").IconProps} IconProps */
/** @typedef {import("types/widgets/label").LabelProps} LabelProps */

/** @typedef ArrowToggleButtonProps
 *  @prop {string} name
 *  @prop {IconProps["icon"]} icon
 *  @prop {LabelProps["label"]} label
 *  @prop {VoidCallback} activate
 *  @prop {VoidCallback} deactivate
 *  @prop {boolean} activateOnArrow
 *  @prop {[GObject.Object,BoolCallback]} connection
 */

/** @typedef MenuProps
 *  @prop {string} name
 *  @prop {IconProps["icon"]} icon
 *  @prop {LabelProps["label"]} label
 *  @prop {Gtk.Widget[]} content
 */

/** @typedef SimpleToggleButtonProps
 *  @prop {IconProps["icon"]} icon
 *  @prop {LabelProps["label"]} label
 *  @prop {VoidCallback} toggle
 *  @prop {[GObject.Object, () => boolean]} connection
 */

App.connect(
  "window-toggled",
  (
    _,
    /** @param {string} name */ name,
    /** @param {boolean} visible*/ visible,
  ) => {
    if (name === "quicksettings" && !visible)
      Utils.timeout(500, () => (opened.value = ""));
  },
);

export const Arrow = (
  /** @param {string} name */ name,
) => {
  let deg = 0;
  let iconOpened = false;
  const icon = Widget.Icon("pan-end-symbolic").hook(opened, () => {
    if (
      (opened.value === name && !iconOpened) ||
      (opened.value !== name && iconOpened)
    ) {
      const step = opened.value === name ? 10 : -10;
      iconOpened = !iconOpened;
      for (let i = 0; i < 9; ++i) {
        Utils.timeout(15 * i, () => {
          deg += step;
          icon.setCss(`-gtk-icon-transform: rotate(${deg}deg);`);
        });
      }
    }
  });
  return Widget.Button({
    child: icon,
    class_name: "arrow",
    on_clicked: () => {
      opened.value = opened.value === name ? "" : name;
    },
  });
};

export const ArrowToggleButton = (
  /** @param {ArrowToggleButtonProps} props */ {
    name,
    icon,
    label,
    activate,
    deactivate,
    activateOnArrow = true,
    connection: [service, condition],
  },
) =>
  Widget.Box({
    classNames: ["toggle-button", "arrow-toggle"],
    setup: (self) =>
      self.hook(service, () => {
        self.toggleClassName("active", condition());
      }),
    children: [
      Widget.Button({
        child: Widget.Box({
          hexpand: true,
          children: [
            Widget.Icon({
              className: "icon",
              icon,
            }),
            Widget.Label({
              className: "label",
              max_width_chars: 10,
              truncate: "end",
              label,
            }),
          ],
        }),
        on_clicked: () => {
          if (condition()) {
            deactivate();
            if (opened.value === name) opened.value = "";
          } else {
            activate();
          }
        },
      }),
      Arrow(name),
    ],
  });

export const Menu = (
  /** @param {MenuProps} props */ { name, icon, title, content },
) =>
  Widget.Revealer({
    transition: "slide_down",
    reveal_child: opened.bind().as((v) => v === name),
    child: Widget.Box({
      classNames: ["menu", name],
      vertical: true,
      children: [
        Widget.Box({
          className: "title-box",
          children: [
            Widget.Icon({
              className: "icon",
              icon,
            }),
            Widget.Label({
              className: "label",
              truncate: "end",
              label: title,
            }),
          ],
        }),
        Widget.Separator(),
        Widget.Box({
          vertical: true,
          classNames: ["content", "vertical"],
          children: content,
        }),
      ],
    }),
  });

export const SimpleToggleButton = (
  /** @param {SimpleToggleButtonProps} props */ {
    icon,
    label,
    toggle,
    connection: [service, condition],
  },
) =>
  Widget.Button({
    on_clicked: toggle,
    classNames: ["toggle-button", "simple-toggle"],
    setup: (self) =>
      self.hook(service, () => {
        self.toggleClassName("active", condition());
      }),
    child: Widget.Box([
      Widget.Icon({ icon }),
      Widget.Label({
        max_width_chars: 10,
        truncate: "end",
        label,
      }),
    ]),
  });
