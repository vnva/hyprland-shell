import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
	id: root

	LockContext {
		id: lockContext

		onUnlocked: {
			lock.locked = false;
		}
	}

	WlSessionLock {
		id: lock
		locked: false

		WlSessionLockSurface {
			LockSurface {
				anchors.fill: parent
				context: lockContext
			}
		}
	}

	GlobalShortcut {
		appid: "hyprland-shell"
		name: "lockscreen"
		description: "Lock screen"
		onPressed: lock.locked = true
	}
}
