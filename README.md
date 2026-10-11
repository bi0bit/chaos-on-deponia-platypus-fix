# Chaos on Deponia: Earth Platypus Minigame Fix

An unofficial Windows patch for the Earth Platypus puzzle's corrupted
saved-state problem: a missing egg/platypus, disappearing stones, or
unclickable holes caused by missing puzzle tables or a stale puzzle lock.

**[Download EarthPlatypusFix-v2.zip](https://github.com/bi0bit/chaos-on-deponia-platypus-fix/releases/download/v2/EarthPlatypusFix-v2.zip)**
([release notes](https://github.com/bi0bit/chaos-on-deponia-platypus-fix/releases/tag/v2))

## Requirements

- Windows version of Chaos on Deponia, supported build **3.3.2351 /
  Visionaire player 4.2**, with the exact original archive checksum.
- Windows PowerShell 5.1 and .NET; no Python or additional runtime installation
  was needed on the tested Windows setup.
- A writable game folder and space for original archive and save backups.

The version label alone is insufficient: other editions, languages with a
different archive, and modified game archives are safely refused.

## Install

1. Close the game and extract the downloaded ZIP.
2. In Steam, right-click **Chaos on Deponia > Manage > Browse local files**.
3. Copy the entire **EarthPlatypusFix** folder beside `deponia2.exe` and `data.vis`.
4. Open that folder and double-click **Install.cmd**.
5. Wait for the success message, start through Steam, and load your save.
6. Play the puzzle normally and save in a new slot after confirming it works.

Use the named release asset above. GitHub's automatically generated
**Source code (zip)** is a separate repository download.

The installer backs up and verifies the original archive and existing saves
in **EarthPlatypusFixBackup** inside the game folder. Saves are never edited.

## Uninstall

Close the game and double-click **Uninstall.cmd**. It restores the verified
original archive, retaining current saves and all backups. Keep the backup
folder; uninstall refuses to overwrite an archive changed by a mod or update.

## Behavior and scope

The repair restores missing coordinate and sprite constants and clears the
stale lock only while the unsolved puzzle is active. If the egg's position
has been lost, only this puzzle's layout is restarted. Valid positions are
retained, and the puzzle is not automatically completed.

This release contains the minigame repair only. It includes no FPS limiter,
resolution changes, personal saves, or full game archive. It does not fix
every possible high-refresh-rate input issue. It is not an official
Daedalic release.

## Validation

- The affected player confirmed the version 2 repair worked in-game.
- The saved-state failure and repair were tested under Lua 5.1.
- Install/uninstall and both CMD launchers passed tests on an isolated game
  copy using Windows PowerShell 5.1, including verified backups and refusal
  of modified archives, damaged downloads, and damaged original backups.
- The delta reconstructs exactly the verified version 2 archive. Only three
  puzzle script strings change; the other 2,628 archive resources are unchanged.
- Wider compatibility across editions and language archives is unverified.

ZIP SHA-256:

```text
51fb29e111216d0667876a35eb9882a0eba55a94be6bbaa9f3dcc87eb09e93f4
```

Readable installer source and the binary delta are in [EarthPlatypusFix](EarthPlatypusFix).
