/* Adapted from Omarchy's workspace widget.

Copyright (c) David Heinemeier Hansson

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.workspaces"

  readonly property var monitor: {
    var window = root.QsWindow.window
    var screen = window ? window.screen : null
    return screen ? Hyprland.monitorFor(screen) : Hyprland.focusedMonitor
  }
  readonly property string monitorName: root.monitor ? root.monitor.name : ""

  property var entries: []
  onMonitorNameChanged: {
    root.entries = []
    root.lastSnapshot = ""
    root.refreshModel()
  }
  Component.onCompleted: refreshTimer.restart()

  // Coalesce the workspace and window events from each compositor action.
  Timer {
    id: refreshTimer
    interval: 20
    onTriggered: {
      if (snapshot.running || !root.monitorName) return
      snapshot.monitorName = root.monitorName
      snapshot.running = true
    }
  }

  Process {
    id: snapshot
    property string monitorName
    command: ["hyprctl", "repl", "return o.dynamic_workspace_model(" + JSON.stringify(monitorName) + ")"]
    stdout: StdioCollector { id: modelOutput }

    onExited: function(exitCode) {
      if (exitCode === 0 && monitorName === root.monitorName) {
        try {
          var entries = JSON.parse(modelOutput.text)
          if (Array.isArray(entries) && modelOutput.text !== root.lastSnapshot) {
            root.lastSnapshot = modelOutput.text
            root.entries = entries
          }
        } catch (error) {
          console.warn("Workspaces: could not read Hyprland workspace list")
        }
      }
      if (root.refreshPending) {
        root.refreshPending = false
        refreshTimer.restart()
      }
    }
  }

  property string lastSnapshot: ""
  property bool refreshPending: false

  function refreshModel() {
    if (snapshot.running) root.refreshPending = true
    else if (!refreshTimer.running) refreshTimer.start()
  }

  function focusWorkspace(key) {
    if (!root.bar) return
    var expression = "o.focus_dynamic_workspace(" + JSON.stringify(root.monitorName) + ", " + JSON.stringify(key) + ")"
    root.bar.run("hyprctl dispatch " + Util.shellQuote(expression))
  }

  // A wheel notch moves one entry along the row, and a touchpad adds up its
  // smaller deltas until they make a notch's worth.
  property real wheelAccumulator: 0

  function scrollWorkspaces(delta) {
    var wheel = Util.wheelSteps(root.wheelAccumulator, delta)
    root.wheelAccumulator = wheel.remainder
    if (wheel.steps === 0) return

    // Holds at either end rather than wrapping, so a touchpad swipe that runs
    // long stops on the last workspace.
    var entries = root.entries
    var index = entries.findIndex(function(entry) { return entry.active })
    if (index === -1) return
    var target = entries[Util.clamp(index - wheel.steps, 0, entries.length - 1)]
    if (!target.active) root.focusWorkspace(target.key)
  }

  // The layout commands act on the focused workspace, so a click on another
  // monitor's bar focuses that monitor first.
  function cycleLayout() {
    if (!root.bar) return
    var command = "omarchy-hyprland-workspace-layout-toggle"
    if (root.monitor && !root.monitor.focused) {
      command = "hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ monitor = \"" + root.monitorName + "\" })") + " >/dev/null && " + command
    }
    root.bar.run(command)
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      var name = event ? String(event.name) : ""
      if (/^(workspacev2|createworkspacev2|destroyworkspacev2|moveworkspacev2|changeworkspaceid|renameworkspace|openwindow|closewindow|movewindowv2|pin|focusedmon|monitoraddedv2|monitorremoved|configreloaded)$/.test(name)) {
        root.refreshModel()
      }
    }
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : Math.max(1, root.entries.length)
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.entries

      WidgetButton {
        id: button
        required property var modelData
        required property int index

        readonly property bool occupied: modelData.occupied
        readonly property bool shown: modelData.active
        readonly property bool firstGuest: modelData.guest && index > 0 && !root.entries[index - 1].guest

        // A gap sets visiting workspaces apart from the monitor's own.
        Layout.leftMargin: firstGuest && !root.vertical ? Style.space(6) : 0
        Layout.topMargin: firstGuest && root.vertical ? Style.space(6) : 0

        bar: root.bar
        hasVisualContent: true
        labelVisible: false
        dimmed: !occupied && !shown
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() {
          if (shown) root.cycleLayout()
          else root.focusWorkspace(modelData.key)
        }
        onWheelMoved: function(delta) { root.scrollWorkspaces(delta) }

        Rectangle {
          anchors.centerIn: parent
          width: Style.space(10)
          height: width
          radius: width / 2
          antialiasing: true
          color: button.shown ? button.foreground : "transparent"
          border.color: button.foreground
          border.width: Style.space(1)
          scale: button.pressScale
        }
      }
    }
  }
}
