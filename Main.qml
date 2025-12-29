import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: window
    width: 400
    height: 750
    visible: true
    title: "FoodTrack - Professional Fitness Tracker"
    color: "#000000"

    // State to toggle between Dashboard and History
    property bool showingHistory: false
    property int graphRange: 7

    // --- 1. CALORIE SELECTION DIALOG --- (Unchanged for brevity)
    Dialog { id: calorieGridDialog; /* ... same as your code ... */ }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // TOP NAVIGATION BAR
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: "#111"
            RowLayout {
                anchors.fill: parent; anchors.margins: 15
                Text { text: "TITAN TRACK"; color: "white"; font.bold: true; font.pixelSize: 18 }
                Item { Layout.fillWidth: true }
                Button {
                    text: showingHistory ? "BACK" : "HISTORY"
                    onClicked: showingHistory = !showingHistory
                    background: Rectangle { color: "#333"; radius: 5; implicitWidth: 80 }
                    contentItem: Text { text: parent.text; color: "#3498db"; horizontalAlignment: Text.AlignHCenter; font.bold: true }
                }
            }
        }

        // --- 2. SCROLLABLE CONTENT AREA ---
        // This allows the UI to handle any window height
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: contentColumn.height
            clip: true

            ColumnLayout {
                id: contentColumn
                width: parent.width
                spacing: 0

                // HEADER IMAGE (30% of window height)
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: window.height * 0.3
                    visible: !showingHistory // Hide header when looking at history

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

                // MAIN CONTENT CONTAINER
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.margins: 25
                    spacing: 20

                    // DASHBOARD VIEW
                    ColumnLayout {
                        visible: !showingHistory
                        Layout.fillWidth: true
                        spacing: 20

                        // Calorie Card
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 120
                            color: "#2980b9"; radius: 15
                            ColumnLayout {
                                anchors.centerIn: parent
                                Text { text: "CALORIES"; color: "#d0e4f2"; Layout.alignment: Qt.AlignHCenter }
                                Text { text: healthCtrl.consumedCalories + " / " + healthCtrl.dailyTarget; color: "white"; font.pixelSize: 26; font.bold: true }
                            }
                        }

                        // Water Bar
                        ColumnLayout {
                            Layout.fillWidth: true; spacing: 8
                            Text { text: "DAILY HYDRATION"; color: "#7f8c8d"; font.bold: true }
                            Rectangle {
                                Layout.fillWidth: true; height: 45; color: "#1a1a1a"; radius: 10
                                Rectangle {
                                    width: parent.width * healthCtrl.hydrationProgress
                                    height: parent.height; color: "#27ae60"; radius: 10
                                }
                            }
                        }

                        // Buttons
                        RowLayout {
                            Layout.fillWidth: true; Layout.preferredHeight: 60; spacing: 15
                            Button { text: "ADD WATER"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: healthCtrl.addWater(0.25) }
                            Button { text: "ADD MEAL"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: calorieGridDialog.open() }
                        }
                    }

                    // HISTORY VIEW (Graph)
                    ColumnLayout {
                        visible: showingHistory
                        Layout.fillWidth: true
                        spacing: 15

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            Button { text: "7D"; onClicked: graphRange = 7 }
                            Button { text: "31D"; onClicked: graphRange = 31 }
                        }

                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 200
                            color: "#111"; radius: 10
                            Row {
                                anchors.bottom: parent.bottom; anchors.bottomMargin: 10; anchors.horizontalCenter: parent.horizontalCenter
                                height: parent.height - 40; spacing: graphRange === 7 ? 10 : 2
                                Repeater {
                                    model: healthCtrl.history.slice(-graphRange)
                                    Rectangle {
                                        width: (parent.parent.width - 60) / graphRange
                                        height: Math.max(2, (parseInt(modelData.split(",")[1]) / 4000) * parent.height)
                                        color: "#3498db"; anchors.bottom: parent.bottom
                                    }
                                }
                            }
                        }
                    }

                    // SPACER to push footer down
                    Item { Layout.preferredHeight: 50 }

                    // --- 3. EXTENDABLE FOOTER ---
                    ColumnLayout {
                        id: footer
                        Layout.fillWidth: true
                        spacing: 4
                        Layout.bottomMargin: 20

                        Rectangle {
                            Layout.fillWidth: true; height: 1; color: "#222"
                            Layout.bottomMargin: 10
                        }

                        Text {
                            text: "TitanTrack Ltd.";
                            Layout.alignment: Qt.AlignHCenter
                            color: "#95a5a6"; font.bold: true
                        }
                        Text {
                            text: "100 Piotrkowska St, Lodz, Poland";
                            Layout.alignment: Qt.AlignHCenter
                            color: "#7f8c8d"; font.pixelSize: 10
                        }
                        Text {
                            text: "User: 105kg | 189cm | 33yo";
                            Layout.alignment: Qt.AlignHCenter
                            color: "#444"; font.pixelSize: 9
                        }
                    }
                }
            }
        }
    }
}
