# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Solid Shell is a minimal desktop shell for Hyprland built with Quickshell (QML/Qt). It provides a top bar with workspace indicators, clock, and system status, plus a window overview overlay.

## Running

Quickshell is already installed. Run with:

```
quickshell
```

Entry point is `shell.qml`. No build step — QML files are interpreted directly by the Quickshell runtime.

There is no test framework. Testing is done manually via the live shell.

## Architecture

```
shell.qml                    # Root: spawns one bar per monitor via Variants
Theme.qml                    # Singleton: Base16 color palette + layout constants
bar/
  Bar.qml                    # Panel layout with left/center/right sections
  WorkspaceIndicator.qml     # Workspace dots (click/scroll to switch)
  Clock.qml                  # Time/date display with icon
overview/
  Overview.qml               # Full-screen window overview/switcher overlay
  WindowCard.qml             # Individual window card with live preview
icons/
  Icon.qml                   # Reusable tinted SVG icon component
  download.sh                # Downloads Lucide icons into source/
  source/                    # SVG files (Lucide icons)
```

**Data flow:** `shell.qml` creates per-monitor `Bar` instances and one `Overview`. All components access `Theme` singleton for colors and dimensions. `WorkspaceIndicator` and `Overview` read from `Quickshell.Hyprland` for workspace/window state.

**Multi-monitor:** Bars are spawned reactively using `Variants { model: Quickshell.screens }`. Bars are created/destroyed automatically as monitors connect/disconnect.

**Theme system:** `Theme.qml` is a `Singleton` that reads colors from `$SOLID_SHELL_COLORS` or `~/.config/hyprland-shell/colors.conf` (key-value format with `#` comments). Missing keys fall back to hardcoded Base16 defaults. All layout dimensions (bar height, spacing, radii) are also defined here.

**Icon system:** `icons/Icon.qml` renders tinted SVG icons. Uses `QtQuick.Effects` `MultiEffect` with `brightness: 1.0` + `colorization: 1.0` to recolor SVGs (brightness is required because SVG `currentColor` renders as black). Usage: `Icons.Icon { name: "clock"; color: Theme.base05; width: 13; height: 13 }`. Import as `import "../icons" as Icons` from bar/, or `import "icons" as Icons` from root. Do NOT use `Qt5Compat.GraphicalEffects`.

**Overview:** Toggled via `GlobalShortcut` (appid: `hyprland-shell`, name: `overview`). Features search filtering by window title/appId, keyboard navigation (arrows/tab), live window previews via `ScreencopyView`, workspace dots, and close buttons. Grid layout auto-adjusts columns based on window count.

## Design Principles (from PROMPT.md)

These principles should guide all implementation decisions:

- **Quiet interface:** The bar should feel invisible when everything is normal. Color is a signal, not decoration. No animated indicators or bright colors in resting state.
- **Glanceability:** A user glances at the bar for less than a second. Left = navigation, center = time, right = system state.
- **Progressive disclosure:** Bar shows summaries; details appear on hover/interaction.
- **Healthy state = invisible:** `base0B` (green/healthy) never appears at rest. "Everything is fine" is communicated by absence of warning colors.
- **One accent color at a time:** Active workspace gets `base0D`; nothing else competes with it at rest.
- **No spatial animations.** Elements don't slide, bounce, or scale. 150ms ease-out for color/opacity transitions only.

## Color Semantics

| Role | Color | Usage |
|------|-------|-------|
| Background | `base00` | Bar background |
| Primary text | `base05` | Clock, active content |
| Muted/inactive | `base03` | Inactive workspaces, secondary info |
| Active accent | `base0D` | Active workspace, focused element, selection border |
| Warning | `base0A` | Battery low (<20%) |
| Critical | `base09` | Battery critical (<5%), close button hover |
| Healthy | `base0B` | Only on hover to confirm positive state |

## QML Conventions

- Files must use **PascalCase** — QML auto-registers files starting with uppercase as types.
- Import parent directory as `import ".." as Root` to access Theme and other root-level types.
- Import icons as `import "../icons" as Icons` (from bar/) or `import "icons" as Icons` (from root).
- New files are created only when they represent a distinct spatial region or interaction pattern; avoid artificial splitting.
- All spacing follows a **4px base unit** (4, 8, 12, 16).
- Bar height is 32px. Typography: 13px primary, 11px secondary. Regular weight only (bold reserved for active workspace).
- Glass backgrounds use `base00` with configurable opacity (`glassOpacity` for bar, `overviewGlassOpacity` for overview).
- `PopupWindow` sizing: use `implicitWidth`/`implicitHeight`, not `width`/`height` (deprecated in Quickshell).

## Quickshell Documentation

Quickshell docs are at `https://quickshell.org/docs/master/` (domain is allowed in WebFetch permissions).
