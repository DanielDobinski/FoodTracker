import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: window
    width: 400
    height: 750
    visible: true
    title: "FoodTrack - TitanTrack Pro"
    color: "#000000"

    // View States
    property bool showingHistory: false
    property int graphRange: 7

    // --- 1. CALORIE SELECTION DIALOG ---
    Dialog {
        id: calorieGridDialog
        anchors.centerIn: parent
        modal: true
        header: null
        footer: null
        property int tempSum: 0

        background: Rectangle {
            color: "#1a1a1a"
            radius: 20
            border.color: "#e67e22"
            border.width: 2
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            width: 300

            Text {
                text: "ADD MEAL"
                color: "white"
                font.pixelSize: 18
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: calorieGridDialog.tempSum + " kcal"
                color: "#e67e22"
                font.pixelSize: 36
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            GridLayout {
                columns: 3
                rowSpacing: 10
                columnSpacing: 10
                Layout.fillWidth: true
                Button { text: "+50";  Layout.fillWidth: true; onClicked: calorieGridDialog.tempSum += 50 }
                Button { text: "+250"; Layout.fillWidth: true; onClicked: calorieGridDialog.tempSum += 250 }
                Button { text: "+500"; Layout.fillWidth: true; onClicked: calorieGridDialog.tempSum += 500 }
                Button { text: "-50";  Layout.fillWidth: true; onClicked: calorieGridDialog.tempSum = Math.max(0, calorieGridDialog.tempSum - 50) }
                Button { text: "-250"; Layout.fillWidth: true; onClicked: calorieGridDialog.tempSum = Math.max(0, calorieGridDialog.tempSum - 250) }
                Button { text: "-500"; Layout.fillWidth: true; onClicked: calorieGridDialog.tempSum = Math.max(0, calorieGridDialog.tempSum - 500) }
            }

            RowLayout {
                spacing: 15
                Button {
                    text: "DECLINE"
                    Layout.fillWidth: true
                    onClicked: { calorieGridDialog.tempSum = 0; calorieGridDialog.close() }
                }
                Button {
                    text: "ACCEPT"
                    Layout.fillWidth: true
                    onClicked: {
                        healthCtrl.addMeal(calorieGridDialog.tempSum)
                        calorieGridDialog.tempSum = 0
                        calorieGridDialog.close()
                    }
                }
            }
        }
    }

    // --- 2. MAIN APP STRUCTURE ---
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // TOP NAVIGATION BAR
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: "#111"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                Text {
                    text: "TITAN TRACK"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 18
                }

                Item { Layout.fillWidth: true } // Spacer

                // Small Reset Button
                Button {
                    text: "RESET"
                    onClicked: healthCtrl.resetDay()
                    background: Rectangle {
                        implicitWidth: 65
                        implicitHeight: 32
                        color: parent.pressed ? "#442222" : "#221111"
                        radius: 5
                        border.color: "#c0392b"
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#e74c3c"
                        font.pixelSize: 10
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                // History Toggle Button
                Button {
                    text: showingHistory ? "BACK" : "HISTORY"
                    onClicked: showingHistory = !showingHistory
                    background: Rectangle {
                        color: "#333"
                        radius: 5
                        implicitWidth: 80
                        implicitHeight: 32
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#3498db"
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // SCROLLABLE CONTENT AREA
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: contentColumn.height
            clip: true

            ColumnLayout {
                id: contentColumn
                width: parent.width
                spacing: 0

                // Header Image (Hidden in History View)
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: window.height * 0.3
                    visible: !showingHistory

                    Image {
                        source: "images/athlete_background.png"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                    }
                    Rectangle {
                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop { position: 0.7; color: "transparent" }
                            GradientStop { position: 1.0; color: "#000000" }
                        }
                    }
                }

                // Main Data Section
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.margins: 25
                    spacing: 20

                    // DASHBOARD VIEW
                    ColumnLayout {
                        visible: !showingHistory
                        Layout.fillWidth: true
                        spacing: 20

                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 120
                            color: "#2980b9"; radius: 15
                            ColumnLayout {
                                anchors.centerIn: parent
                                Text { text: "CALORIES CONSUMED"; color: "#d0e4f2"; Layout.alignment: Qt.AlignHCenter; font.pixelSize: 12 }
                                Text {
                                    text: healthCtrl.consumedCalories + " / " + healthCtrl.dailyTarget + " kcal"
                                    color: "white"; font.pixelSize: 26; font.bold: true
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true; spacing: 8
                            Text { text: "DAILY HYDRATION"; color: "#7f8c8d"; font.bold: true; font.pixelSize: 12 }
                            Rectangle {
                                Layout.fillWidth: true; height: 45; color: "#1a1a1a"; radius: 10
                                Rectangle {
                                    width: parent.width * healthCtrl.hydrationProgress
                                    height: parent.height; color: "#27ae60"; radius: 10
                                    Behavior on width { NumberAnimation { duration: 500 } }
                                }
                                Text {
                                    anchors.centerIn: parent; color: "white"; font.bold: true
                                    text: (healthCtrl.hydrationProgress * 3.5).toFixed(1) + " L / 3.5 L"
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true; Layout.preferredHeight: 60; spacing: 15
                            Button {
                                text: "ADD WATER"; Layout.fillWidth: true; Layout.fillHeight: true
                                onClicked: healthCtrl.addWater(0.25)
                            }
                            Button {
                                text: "ADD MEAL"; Layout.fillWidth: true; Layout.fillHeight: true
                                onClicked: calorieGridDialog.open()
                            }
                        }
                    }

                    // HISTORY VIEW
                    ColumnLayout {
                        visible: showingHistory
                        Layout.fillWidth: true
                        spacing: 15

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 10
                            Button {
                                text: "7 DAYS";
                                onClicked: graphRange = 7
                                background: Rectangle { color: graphRange === 7 ? "#3498db" : "#222"; radius: 4 }
                            }
                            Button {
                                text: "31 DAYS";
                                onClicked: graphRange = 31
                                background: Rectangle { color: graphRange === 31 ? "#3498db" : "#222"; radius: 4 }
                            }
                        }

                        Rectangle {
                            id: graphCanvas
                            Layout.fillWidth: true; Layout.preferredHeight: 250
                            color: "#111"; radius: 12; border.color: "#222"

                            Row {
                                anchors.bottom: parent.bottom; anchors.bottomMargin: 15
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: parent.height - 60
                                spacing: graphRange === 7 ? 12 : 2

                                Repeater {
                                    model: healthCtrl.history.slice(-graphRange)
                                    Rectangle {
                                        width: (graphCanvas.width - 60) / graphRange
                                        height: Math.max(2, (parseInt(modelData.split(",")[1]) / 4500) * parent.height)
                                        color: "#3498db"; radius: 2; anchors.bottom: parent.bottom

                                        Text {
                                            visible: graphRange === 7
                                            text: modelData.split(",")[1]
                                            color: "#7f8c8d"; font.pixelSize: 8; anchors.bottom: parent.top; anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // SPACER
                    Item { Layout.preferredHeight: 40 }

                    // EXTENDABLE FOOTER
                    ColumnLayout {
                        id: footer
                        Layout.fillWidth: true
                        spacing: 4
                        Layout.bottomMargin: 20

                        Rectangle { Layout.fillWidth: true; height: 1; color: "#222"; Layout.bottomMargin: 5 }

                        Text {
                            text: "TitanTrack Ltd.";
                            Layout.alignment: Qt.AlignHCenter; color: "#95a5a6"; font.bold: true; font.pixelSize: 12
                        }
                        Text {
                            text: "100 Piotrkowska St, Lodz, Poland";
                            Layout.alignment: Qt.AlignHCenter; color: "#555"; font.pixelSize: 10
                        }
                        Text {
                            text: "Athlete Profile: 105kg | 189cm | 33yo";
                            Layout.alignment: Qt.AlignHCenter; color: "#333"; font.pixelSize: 9
                        }
                    }
                }
            }
        }
    }
}
