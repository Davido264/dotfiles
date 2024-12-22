import GLib from "gi://GLib";

const format = "%H:%M"; // 09:19
const formatAlt = "%a %d %b, %H:%M"; // tue 26 mar, 09:19

const cached = {
  hour: -1,
  min: -1,
  format: ["",""],
};

const clock = Variable(GLib.DateTime.new_now_local(), {
  poll: [5000, () => GLib.DateTime.new_now_local()],
});

export const Clock = () =>
  Widget.Label({
    classNames: ["clock", "indicator"],
    hpack: "start",
    vpack: "center",
  }).hook(clock, (self) => {
    const m = clock.value.get_minute();
    const h = clock.value.get_hour();
    if (cached.hour != h || cached.min != m) {
      cached.hour = h;
      cached.min = m;
      cached.format[0] = clock.value.format(format) || "";
      cached.format[1] = clock.value.format(formatAlt) || "";
    }

    self.label = cached.format[0];
    self.tooltip_text = cached.format[1];
  });
