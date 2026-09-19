pragma Singleton

import QtQuick 2.7

QtObject {

    //
    // COLOURS
    //

    readonly property color background: "#121212"
    readonly property color card: "#1F1F1F"

    readonly property color accent: "#E95420"

    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#B5B5B5"

    readonly property color divider: "#303030"

    readonly property color success: "#4CAF50"
    readonly property color warning: "#FF9800"
    readonly property color error: "#E53935"

    //
    // SPACING
    //

    readonly property int tinySpacing: 4
    readonly property int smallSpacing: 8
    readonly property int spacing: 16
    readonly property int largeSpacing: 24
    readonly property int hugeSpacing: 32

    //
    // CORNERS
    //

    readonly property int radius: 8

    //
    // FONT SIZES
    //

    readonly property int titleSize: 28
    readonly property int headingSize: 20
    readonly property int bodySize: 16
    readonly property int captionSize: 13

    //
    // BUTTONS
    //

    readonly property int buttonHeight: 48

    //
    // ANIMATIONS
    //

    readonly property int animationSpeed: 200

    //
    //ICONS
    //

    readonly property int iconSize: 24
}