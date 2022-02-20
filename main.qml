import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    width: 800
    height: 700
    visible: true
    title: qsTr("Hello World")
    id: root

    Rectangle {
        width: 500
        height: 300
        color: 'green'

        Rectangle {
            width: 400
            height: 200
            color: 'yellow'
        }
    }

    ListView {
        id: lstTest
        anchors.fill: parent
        anchors.topMargin: 330
        model: 5
        spacing: 6

        delegate: Rectangle {
            height: 100
            width: 200
            color: 'blue'
        }
    }

    Button {
        text: 'create window'
        onClicked: {

            var component = Qt.createComponent("ObjectTreePanel.qml")
            var w = component.createObject(null, {
                                               "targetItem": root.contentItem
                                           })
            w.show()
        }
    }
}
