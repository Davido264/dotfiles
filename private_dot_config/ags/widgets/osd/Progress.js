import GLib from "gi://GLib?version=2.0";

const transition = 200;

/** @typedef {import("gi://Gtk?version=3.0").default["Widget"]} Gtk.Widget */

/** @typedef ProgressProps
 * @prop {Gtk.Widget} child
 */

export default (
  /** @param {ProgressProps} props */ {
    child,
  },
) => {
  const fill = Widget.Box({
    className: "fill",
    hexpand: true,
    vexpand: false,
    hpack: "fill",
    vpack: "end",
    child,
  });

  const container = Widget.Box({
    className: "progress",
    child: fill,
  });

  let fill_size = 0;
  /** @type {number[]} */
  let animations = [];

  return Object.assign(container, {
    setValue(/** @param {number} value */ value) {
      if (value < 0) return;

      if (animations.length > 0) {
        for (const id of animations) GLib.source_remove(id);

        animations = [];
      }

      const axis = "height";
      const axisv = 200;
      const min = 20;
      const preferred = (axisv - min) * value + min;

      if (!fill_size) {
        fill_size = preferred;
        fill.css = `min-${axis}: ${preferred}px;`;
        return;
      }

      const frames = transition / 10;
      const goal = preferred - fill_size;
      const step = goal / frames;

      for (let i = 0; i < frames; i++) {
        animations.push(
          Utils.timeout(5 * i, () => {
            fill_size += step;
            fill.css = `min-${axis}: ${fill_size}px`;
            animations.shift();
          }),
        );
      }
    },
  });
};
