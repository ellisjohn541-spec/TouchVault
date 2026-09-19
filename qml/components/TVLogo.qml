import QtQuick 2.7
import Lomiri.Components 1.3

Item {

    id: root

    implicitWidth: units.gu(12)
    implicitHeight: units.gu(12)

    Image {

        anchors.fill: parent

        source: "../../assets/splash.png"

        fillMode: Image.PreserveAspectFit

        smooth: true
    }
}