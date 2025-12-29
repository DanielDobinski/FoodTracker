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

    ColumnLayout
    {
        anchors.fill: parent // Flexible layout based on window
        spacing: 0

        // --- 1. HEADER SECTION (30% OF HEIGHT) ---
        Item {
            id: headerSection
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.3
            clip: true

            Image {
                id: headerImage
                source: "images/athlete_background.png"
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                opacity: 1.0
            }

            // Gradient to blend the image into the black background below
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
                font.pixelSize: parent.height * 0.15
                font.bold: true
                color: "white"
                style: Text.Outline
                styleColor: "black"
            }
        }

        // --- 2. INTERACTIVE SECTION (70% OF HEIGHT) ---
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 25
                spacing: 20

                // CALORIE CARD (Scalable layout)
                Rectangle {
                    id: calorieCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.maximumHeight: 140
                    Layout.minimumHeight: 100
                    color: "#2980b9"
                    radius: 15
                    border.color: "#3498db"
                    border.width: 2

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 2

                        Text {
                            text: "CALORIES CONSUMED"
                            color: "#d0e4f2"
                            font.pixelSize: parent.height * 0.18
                            font.letterSpacing: 1
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            id: mainCalorieText
                            text: healthCtrl.consumedCalories + " / " + healthCtrl.dailyTarget + " kcal"
                            color: "white"
                            // Minimum value + scaling to ensure readability
                            font.pixelSize: Math.max(24, parent.height * 0.35)
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // HYDRATION PROGRESS BAR
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text {
                        text: "DAILY HYDRATION"
                        color: "#7f8c8d"
                        font.pixelSize: 14
                        font.bold: true
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        height: 45
                        color: "#1a1a1a"
                        radius: 10
                        border.color: "#333333"

                        Rectangle {
                            id: progressBar
                            width: parent.width * healthCtrl.hydrationProgress
                            height: parent.height
                            color: "#27ae60"
                            radius: 10
                            Behavior on width { NumberAnimation { duration: 600; easing.type: Easing.OutCubic } }
                        }
                        Text {
                            anchors.centerIn: parent
                            text: (healthCtrl.hydrationProgress * 3.5).toFixed(1) + " L / 3.5 L"
                            color: "white"
                            font.bold: true
                            font.pixelSize: 16
                        }
                    }
                }

                // ACTION BUTTONS (Dynamic scaling)
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.maximumHeight: 90
                    spacing: 15

                    Button {
                        id: waterBtn
                        text: "ADD WATER"
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        background: Rectangle {
                            color: parent.pressed ? "#1f5d85" : "#3498db"
                            radius: 10
                            border.color: "#ffffff"
                            border.width: parent.hovered ? 2 : 0
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.pixelSize: parent.height * 0.25
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: healthCtrl.addWater(0.5)
                    }

                    Button {
                        id: foodBtn
                        text: "ADD MEAL"
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        background: Rectangle {
                            color: parent.pressed ? "#d35400" : "#e67e22"
                            radius: 10
                            border.color: "#ffffff"
                            border.width: parent.hovered ? 2 : 0
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.pixelSize: parent.height * 0.25
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: healthCtrl.addMeal(200)
                    }
                }

                // RESET BUTTON (High contrast)
                Button {
                    text: "RESET DAILY PROGRESS"
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.maximumHeight: 55

                    background: Rectangle {
                        color: parent.pressed ? "#bdc3c7" : "#ecf0f1"
                        radius: 10
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#c0392b"
                        font.pixelSize: parent.height * 0.3
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: healthCtrl.resetDay()
                }

                // SPACER ELEMENT
                Item { Layout.fillHeight: true }

                // --- FOOTER SECTION ---
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    Layout.bottomMargin: 10

                    Text {
                        text: "Download more on App Store"
                        Layout.alignment: Qt.AlignHCenter
                        color: "#3498db"
                        font.pixelSize: 14
                        font.underline: true

                        TapHandler {
                            onTapped: console.log("App Store Link clicked")
                        }
                    }

                    Text {
                        text: "TitanTrack Ltd."
                        Layout.alignment: Qt.AlignHCenter
                        color: "#95a5a6"
                        font.pixelSize: 12
                        font.bold: true
                    }

                    Text {
                        text: "100 Piotrkowska St, 90-001 Lodz"
                        Layout.alignment: Qt.AlignHCenter
                        color: "#7f8c8d"
                        font.pixelSize: 11
                    }
                }
            }
        }
    }
}
