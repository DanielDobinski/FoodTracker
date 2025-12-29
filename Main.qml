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

    // --- 1. CALORIE SELECTION DIALOG (CUSTOM BUTTONS) ---
    Dialog {
        id: calorieGridDialog
        anchors.centerIn: parent
        modal: true

        // Remove standard headers/footers to avoid system-translated buttons
        header: null
        footer: null

        // Temporary variable to stack calories before saving
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

            // Quick Selection Grid
            GridLayout {
                columns: 3
                rowSpacing: 10
                columnSpacing: 10
                Layout.fillWidth: true

                Button { text: "+50";  Layout.fillWidth: true; onClicked: calorieGridDialog.tempSum += 50 }
                Button { text: "+250"; Layout.fillWidth: true; onClicked: calorieGridDialog.tempSum += 250 }
                Button { text: "+500"; Layout.fillWidth: true; onClicked: calorieGridDialog.tempSum += 500 }

                Button {
                    text: "-50"
                    Layout.fillWidth: true
                    onClicked: calorieGridDialog.tempSum = Math.max(0, calorieGridDialog.tempSum - 50)
                }
                Button {
                    text: "-250"
                    Layout.fillWidth: true
                    onClicked: calorieGridDialog.tempSum = Math.max(0, calorieGridDialog.tempSum - 250)
                }
                Button {
                    text: "-500"
                    Layout.fillWidth: true
                    onClicked: calorieGridDialog.tempSum = Math.max(0, calorieGridDialog.tempSum - 500)
                }
            }

            // Custom Action Buttons (Replaces Save/Discard)
            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                Button {
                    text: "DECLINE"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    onClicked: {
                        calorieGridDialog.tempSum = 0
                        calorieGridDialog.close()
                    }
                    background: Rectangle { color: "#333333"; radius: 10 }
                    contentItem: Text { text: "DECLINE"; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }

                Button {
                    text: "ACCEPT"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 45
                    onClicked: {
                        if (calorieGridDialog.tempSum > 0) {
                            healthCtrl.addMeal(calorieGridDialog.tempSum)
                            calorieGridDialog.tempSum = 0
                            calorieGridDialog.close()
                        }
                    }
                    background: Rectangle { color: "#27ae60"; radius: 10 }
                    contentItem: Text { text: "ACCEPT"; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                }
            }
        }
    }

    // --- 2. MAIN APPLICATION LAYOUT ---
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header Section
        Item {
            id: headerSection
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.3
            clip: true

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

            Text {
                text: "Health Tracker"
                anchors.centerIn: parent
                font.pixelSize: 32
                font.bold: true
                color: "white"
                style: Text.Outline
                styleColor: "black"
            }
        }

        // Dashboard Content
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 25
                spacing: 20

                // Calorie Display
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    color: "#2980b9"
                    radius: 15
                    border.color: "#3498db"
                    border.width: 2

                    ColumnLayout {
                        anchors.centerIn: parent
                        Text {
                            text: "CALORIES CONSUMED"
                            color: "#d0e4f2"
                            font.pixelSize: 14
                            font.letterSpacing: 1
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Text {
                            text: healthCtrl.consumedCalories + " / " + healthCtrl.dailyTarget + " kcal"
                            color: "white"
                            font.pixelSize: 26
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // Water Progress
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text { text: "DAILY HYDRATION"; color: "#7f8c8d"; font.pixelSize: 12; font.bold: true }
                    Rectangle {
                        Layout.fillWidth: true; height: 45; color: "#1a1a1a"; radius: 10
                        Rectangle {
                            width: parent.width * healthCtrl.hydrationProgress
                            height: parent.height; color: "#27ae60"; radius: 10
                            Behavior on width { NumberAnimation { duration: 600; easing.type: Easing.OutCubic } }
                        }
                        Text {
                            anchors.centerIn: parent
                            text: (healthCtrl.hydrationProgress * 3.5).toFixed(1) + " L / 3.5 L"
                            color: "white"; font.bold: true
                        }
                    }
                }

                // Action Buttons Row
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    spacing: 15

                    Button {
                        text: "ADD WATER"
                        Layout.fillWidth: true; Layout.fillHeight: true
                        onClicked: healthCtrl.addWater(0.25)
                        background: Rectangle { color: "#3498db"; radius: 10 }
                        contentItem: Text { text: "ADD WATER"; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter }
                    }

                    Button {
                        text: "ADD MEAL"
                        Layout.fillWidth: true; Layout.fillHeight: true
                        onClicked: calorieGridDialog.open()
                        background: Rectangle { color: "#e67e22"; radius: 10 }
                        contentItem: Text { text: "ADD MEAL"; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter }
                    }
                }

                // Global Reset
                Button {
                    text: "RESET ALL PROGRESS"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    onClicked: healthCtrl.resetDay()
                    background: Rectangle { color: "#ecf0f1"; radius: 10 }
                    contentItem: Text { text: "RESET ALL PROGRESS"; color: "#c0392b"; font.bold: true; horizontalAlignment: Text.AlignHCenter }
                }

                Item { Layout.fillHeight: true } // Bottom Spacer

                // Footer
                ColumnLayout {
                    Layout.fillWidth: true; spacing: 2; Layout.bottomMargin: 10
                    Text { text: "TitanTrack Ltd."; Layout.alignment: Qt.AlignHCenter; color: "#95a5a6"; font.bold: true; font.pixelSize: 12 }
                    Text { text: "100 Piotrkowska St, Lodz, Poland"; Layout.alignment: Qt.AlignHCenter; color: "#7f8c8d"; font.pixelSize: 10 }
                }
            }
        }
    }
}
