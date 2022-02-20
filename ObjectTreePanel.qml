import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    title: 'Object Tree Panel'
    width: 500
    height: 600
    visible: true

    property var targetItem: null
    property var selectionRect: null

    Component {
        id: selectionComp
        Rectangle {
            objectName: 'selectionRect'
            visible: false
            x: 0
            y: 0
            z: 2
            width: 0
            height: 0
            color: 'transparent'
            border.width: 3
            border.color: 'red'
        }
    }

    function createSelectionRectangle() {
        var topLevelWindow = targetItem.Window.window
        selectionRect = selectionComp.createObject(topLevelWindow)
    }

    function addEntityToList(entity, level) {
        if (entity.objectName === 'selectionRect') {
            return
        }

        lstModel1.append({
                             "entity": entity,
                             "level": level
                         })

        for (var i in entity.children) {
            var child = entity.children[i]
            addEntityToList(child, level + 1)
        }
    }

    Component.onCompleted: {
        createSelectionRectangle()
        addEntityToList(targetItem, 0)
    }

    onClosing: {
        selectionRect.destroy()
        destroy()
    }

    Button {
        height: 50
        text: 'refresh'
        onClicked: {
            lstModel1.clear()
            addEntityToList(targetItem, 0)
        }
    }

    ListModel {
        id: lstModel1
    }

    ListView {
        id: lst1
        anchors.fill: parent
        anchors.margins: 20
        anchors.topMargin: 60
        model: lstModel1
        spacing: 2
        focus: true
        currentIndex: -1
        highlight: Rectangle {
            //color: "lightsteelblue"
            color: "#c4e0f7" // "#e5f3ff" //"#d9d9d9"
            radius: 5
        }
        onCurrentIndexChanged: {
            if (currentIndex > -1) {
                var entity = model.get(currentIndex).entity
                selectionRect.visible = true
                selectionRect.x = entity.x
                selectionRect.y = entity.y
                selectionRect.width = entity.width
                selectionRect.height = entity.height
            } else {
                selectionRect.visible = false
            }
        }
        delegate: Text {
            width: ListView.width
            height: 30
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            leftPadding: level * 26
            rightPadding: 5
            //color: ListView.isCurrentItem ? "blue" : "black"
            color: "black"
            font.pixelSize: 12
            text: level + " : " + entity.toString()
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // @disable-check M325
                    if (lst1.currentIndex === index) {
                        lst1.currentIndex = -1
                    } else {
                        lst1.currentIndex = index
                    }
                }
            }
        }
    }
}
