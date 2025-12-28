import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 400
    height: 700
    visible: true
    title: "TitanTrack MCU"
    color: "#f4f4f4"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Header Section
        Text {
            text: "Witaj, Athlete"
            font.pixelSize: 28
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        // Stats Card
        Rectangle {
            Layout.fillWidth: true
            height: 120
            color: "white"
            radius: 10
            border.color: "#ddd"

            Column {
                anchors.centerIn: parent
                spacing: 5
                Text { text: "Current BMI: " + healthCtrl.bmi.toFixed(1); font.pixelSize: 18 }
                Text {
                    text: healthCtrl.consumedCalories + " / " + healthCtrl.dailyTarget + " kcal"
                    font.pixelSize: 22
                    color: "#2c3e50"
                    font.bold: true
                }
            }
        }

        // Hydration Widget
        Text { text: "Hydration (Liters)"; font.bold: true }
        ProgressBar {
            Layout.fillWidth: true
            value: healthCtrl.hydrationProgress
            // The color changes as you drink more
            contentItem: Item {
                Rectangle {
                    width: parent.visualPosition * parent.width
                    height: parent.height
                    color: "#3498db"
                    radius: 5
                }
            }
        }

        // Action Buttons
        RowLayout {
            spacing: 10
            Button {
                text: "Add Snack (200kcal)"
                Layout.fillWidth: true
                onClicked: healthCtrl.addMeal(200)
            }
            Button {
                text: "Drink Water (0.5L)"
                Layout.fillWidth: true
                onClicked: healthCtrl.addWater(0.5)
            }
        }

        Button {
            text: "Reset Stats"
            palette.buttonText: "red"
            Layout.fillWidth: true
            onClicked: healthCtrl.resetDay()
        }

        Item { Layout.fillHeight: true } // Spacer
    }
}
