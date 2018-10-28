# Melty Launcher

A controller configuration UI so players can quickly configure their controllers and launch right into **Melty Blood**.

## Installing/Using Melty Launcher

#### Requirements

- Have **Melty Blood** installed.
- Download `MeltyLauncher.zip` from the [our Latest Release](https://github.com/MeltyLauncher/MeltyLauncher/releases/latest).
- Extract `MeltyLauncher.exe` anywhere on your computer.

#### Usage
- Run `MeltyLauncher.exe` to run **Melty Blood** through this launcher.
  - If it is your first-time using **MeltyLauncher**, it will ask you to locate the **MBAA.exe** file. This can be found in your Melty Blood installation, usually here: `C:\Program Files (x86)\Steam\steamapps\common\MELTY BLOOD Actress Again Current Code\MBAA.exe`
- With your controller plugged in, follow the on-screen prompts to set your bindings.
- Press `SPACE` on your keyboard when done configuring bindings.

## Building From Source

#### Install and Configure AutoIt

- Download [AutoIt](https://www.autoitscript.com/site/) from their website.
- Make sure the **Aut2Exe** module is selected for installation.

The compile script assumes `Aut2exe.exe` is in your Windows `PATH`. To configure this, follow these steps:

- Open the windows Start Menu
- Type `env` and select `Edit the system environment variables`
- In `System Variables` select `Path` and press `Edit...`
- Click `New` and write `C:\Program Files (x86)\AutoIt3\Aut2Exe` for the value.

#### Building the Executable

- Run `compile.bat` from this project's directory.
- `MeltyLauncher.exe` will be compiled and save in the `dist` directory.
