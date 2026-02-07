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
Overview.qml                 # Full-screen window overview/switcher overlay
bar/
  Bar.qml                    # Panel layout with left/center/right sections
  WorkspaceIndicator.qml     # Workspace dots (Hyprland integration)
  Clock.qml                  # Time/date display
```

**Data flow:** `shell.qml` creates per-monitor `Bar` instances and one `Overview`. All components access `Theme` singleton for colors and dimensions. `WorkspaceIndicator` and `Overview` read from `Quickshell.Hyprland` for workspace/window state.

**Multi-monitor:** Bars are spawned reactively using `Variants { model: Quickshell.screens }`. Bars are created/destroyed automatically as monitors connect/disconnect.

**Theme system:** `Theme.qml` is a `Singleton` that reads colors from `$SOLID_SHELL_COLORS` or `~/.config/solid-shell/colors.conf` (key-value format with `#` comments). Missing keys fall back to hardcoded Base16 defaults. All layout dimensions (bar height, spacing, radii) are also defined here.

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
| Active accent | `base0D` | Active workspace, focused element |
| Warning | `base0A` | Battery low (<20%) |
| Critical | `base09` | Battery critical (<5%), disconnected |
| Healthy | `base0B` | Only on hover to confirm positive state |

## QML Conventions

- Files must use **PascalCase** — QML auto-registers files starting with uppercase as types.
- Import parent directory as `import ".." as Root` to access Theme and other root-level types.
- New files are created only when they represent a distinct spatial region or interaction pattern; avoid artificial splitting.
- All spacing follows a **4px base unit** (4, 8, 12, 16).
- Bar height is 32px. Typography: 13px primary, 11px secondary. Regular weight only (bold reserved for active workspace).

## Quickshell Documentation

Quickshell docs are at `https://quickshell.org/docs/master/` (domain is allowed in WebFetch permissions).
