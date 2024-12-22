const hyprland = await Service.import("hyprland");

function onClientChanged(
  /** @param {Button} button */ button,
  /** @param {number} num */ num,
) {
  button.toggleClassName(
    "occupied",
    (hyprland.getWorkspace(num)?.windows || 0) > 0,
  );
}

function workspace(/** @param {number} num */ num) {
  return Widget.Button({
    attribute: num,
    vpack: "center",
    hpack: "center",
    onClicked: () => {
      hyprland.messageAsync(`dispatch focusworkspaceoncurrentmonitor ${num}`);
    },
    setup: (self) => {
      onClientChanged(self, num);

      hyprland.connect("client-added", (_) => {
        onClientChanged(self, num);
      });
      hyprland.connect("client-removed", (_) => {
        onClientChanged(self, num);
      });
      hyprland.connect("urgent-window", (hypr, address) => {
        print(hypr);
        print(address);
        self.toggleClassName(
          "urgent",
          (hyprland.getClient(address)?.workspace || 0) === num,
        );
      });
    },
  }).hook(hyprland.active, (self) => {
    self.toggleClassName("active", hyprland.active.workspace.id === num);
    self.toggleClassName("urgent", false);
  });
}

export const Workspaces = () => {
  const arr = new Array(5);

  for (let i = 0; i < 5; i++) {
    arr[i] = workspace(i + 1);
  }

  return Widget.Box({
    className: "workspaces",
    children: arr,
  });
};
