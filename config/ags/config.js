const { Gtk } = imports.gi;
const Hyprland = await Service.import("hyprland");

// App launcher button
const AppLauncher = () => Widget.Button({
    className: "launcher",
    label: "󰀻",
    onClicked: () => Utils.execAsync(["wofi", "--show", "drun"]),
});

// Audio control button
const AudioButton = () => Widget.Button({
    className: "audio-button",
    label: "",
    onClicked: () => Utils.execAsync(["pavucontrol"]),
});

// Clock with date
const Clock = () => Widget.Box({
    className: "clock",
    vertical: true,
    children: [
        Widget.Label({
            className: "time",
            setup: self => self.poll(1000, self => {
                const time = new Date();
                self.label = time.toLocaleTimeString('en-US', { 
                    hour: '2-digit', 
                    minute: '2-digit',
                    hour12: false 
                }).replace(':', '\n');
            }),
        }),
        Widget.Label({
            label: "",
        }),
        Widget.Label({
            className: "date",
            setup: self => self.poll(60000, self => {
                const date = new Date();
                const day = String(date.getDate()).padStart(2, '0');
                const month = String(date.getMonth() + 1).padStart(2, '0');
                self.label = `${day}\n${month}`;
            }),
        }),
    ],
});

// System tray
const SystemTray = await Service.import("systemtray");

const SysTray = () => Widget.Box({
    className: "tray",
    vertical: true,
    children: SystemTray.bind("items").as(items => items.map(item => 
        Widget.Button({
            child: Widget.Icon({ icon: item.bind("icon") }),
            tooltipMarkup: item.bind("tooltip_markup"),
            onPrimaryClick: (_, event) => item.activate(event),
            onSecondaryClick: (_, event) => item.openMenu(event),
        })
    )),
});

// Main bar
const Bar = (monitor = 0) => Widget.Window({
    name: `bar${monitor}`,
    className: "bar-window",
    monitor,
    anchor: ["left", "top", "bottom"],
    exclusivity: "normal",
    layer: "top",
    child: Widget.EventBox({
        onHover: self => {
            self.get_parent().className = "bar-window visible";
        },
        onHoverLost: self => {
            self.get_parent().className = "bar-window";
        },
        child: Widget.CenterBox({
            className: "bar",
            vertical: true,
            startWidget: Widget.Box({
                vertical: true,
                className: "top-modules",
                children: [
                    AppLauncher(),
                    AudioButton(),
                ],
            }),
            centerWidget: Widget.Box({
                vertical: true,
            }),
            endWidget: Widget.Box({
                vertical: true,
                className: "bottom-modules",
                children: [
                    SysTray(),
                    Clock(),
                ],
            }),
        }),
    }),
});

App.config({
    style: "./style.css",
    windows: [
        Bar(0),
    ],
});
