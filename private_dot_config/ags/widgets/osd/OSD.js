import Progress from "./Progress.js";
import brightness from "../../services/brightness.js";

const audio = await Service.import("audio");
const hyprland = await Service.import("hyprland");

const DELAY = 2500;

function OnScreenProgress() {
  const indicator = Widget.Icon({
    className: "icon",
    hpack: "center",
    hexpand: true,
    vpack: "start",
    size: 20,
  });
  const progress = Progress({
    child: indicator,
  });

  const revealer = Widget.Revealer({
    className: "osd-progress",
    transition: "slide_left",
    child: progress,
  });

  let count = 0;
  function show(/** @param {number} */ value, /** @param {string} */ icon) {
    revealer.reveal_child = true;
    indicator.icon = icon;
    progress.setValue(value);
    count++;
    Utils.timeout(DELAY, () => {
      count--;

      if (count === 0) revealer.reveal_child = false;
    });
  }

  return revealer
    .hook(
      brightness,
      () => show(brightness.screen, "display-brightness-symbolic"),
      "notify::screen",
    )
    .hook(
      brightness,
      () => show(brightness.kbd, "keyboard-brightness-symbolic"),
      "notify::kbd",
    )
    .hook(
      audio.speaker,
      () =>
        show(
          audio.speaker.volume,
          "audio-speakers-symbolic",
        ),
      "notify::volume",
    );
}

function MicrophoneMute() {
  const icon = Widget.Icon({
    class_name: "microphone",
  });

  const revealer = Widget.Revealer({
    transition: "slide_up",
    child: icon,
  });

  let count = 0;
  let mute = audio.microphone.stream?.is_muted ?? false;

  return revealer.hook(audio.microphone, () =>
    Utils.idle(() => {
      if (mute !== audio.microphone.stream?.is_muted) {
        mute = audio.microphone.stream?.is_muted || false;
        icon.icon = mute ? "microphone-disabled-symbolic" : "microphone-sensitivity-high-symbolic";
        revealer.reveal_child = true;
        count++;

        Utils.timeout(DELAY, () => {
          count--;
          if (count === 0) revealer.reveal_child = false;
        });
      }
    }),
  );
}

export default () =>
  Widget.Window({
    monitor: hyprland.active.bind("monitor").as(m => m.id),
    name: `indicator`,
    className: "osd-indicator",
    layer: "overlay",
    click_through: true,
    anchor: ["right"],
    child: Widget.Box({
      css: "padding: 8px;",
      expand: true,
      child: Widget.Overlay(
        // @ts-ignore
        { child: Widget.Box({ expand: true }) }, 
        Widget.Box({
          hpack: "end",
          vpack: "center",
          child: OnScreenProgress(),
        }),
        // Widget.Box({
        //   hpack: "center",
        //   vpack: "end",
        //   child: MicrophoneMute(),
        // }),
      ),
    }),
  });
