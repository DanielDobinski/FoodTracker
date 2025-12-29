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
            border.width: 3
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            width: 300

            Text {
                text: "ADD MEAL"
                color: "white"
                font.pixelSize: 22
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: calorieGridDialog.tempSum + " kcal"
                color: "#e67e22"
                font.pixelSize: 42
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
                    font.pixelSize: 20
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "RESET"
                    onClicked: healthCtrl.resetDay()
                    background: Rectangle {
                        implicitWidth: 70
                        implicitHeight: 35
                        color: parent.pressed ? "#442222" : "#221111"
                        radius: 5
                        border.color: "#c0392b"
                        border.width: 2
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#e74c3c"
                        font.pixelSize: 12
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    text: showingHistory ? "BACK" : "HISTORY"
                    onClicked: showingHistory = !showingHistory
                    background: Rectangle {
                        color: "#333"
                        radius: 5
                        implicitWidth: 90
                        implicitHeight: 35
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#3498db"
                        font.bold: true
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: contentColumn.height
            clip: true

            ColumnLayout {
                id: contentColumn
                width: parent.width
                spacing: 0

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: window.height * 0.3
                    visible: !showingHistory
                    Image {
                        source: "images/athlete_background.png"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.margins: 25
                    spacing: 20

                    // DASHBOARD
                    ColumnLayout {
                        visible: !showingHistory
                        Layout.fillWidth: true
                        spacing: 20

                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredHeight: 130
                            color: "#2980b9"; radius: 15
                            ColumnLayout {
                                anchors.centerIn: parent
                                Text { text: "CALORIES CONSUMED"; color: "#d0e4f2"; Layout.alignment: Qt.AlignHCenter; font.pixelSize: 14; font.bold: true }
                                Text {
                                    text: healthCtrl.consumedCalories + " / " + healthCtrl.dailyTarget + " kcal"
                                    color: "white"; font.pixelSize: 32; font.bold: true
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true; spacing: 10
                            Text { text: "DAILY HYDRATION"; color: "#bdc3c7"; font.bold: true; font.pixelSize: 14 }
                            Rectangle {
                                Layout.fillWidth: true; height: 50; color: "#1a1a1a"; radius: 10
                                Rectangle {
                                    width: parent.width * healthCtrl.hydrationProgress
                                    height: parent.height; color: "#27ae60"; radius: 10
                                }
                                Text {
                                    anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 16
                                    text: (healthCtrl.hydrationProgress * 3.5).toFixed(1) + " L / 3.5 L"
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true; Layout.preferredHeight: 70; spacing: 15
                            Button { text: "ADD WATER"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: healthCtrl.addWater(0.25) }
                            Button { text: "ADD MEAL"; Layout.fillWidth: true; Layout.fillHeight: true; onClicked: calorieGridDialog.open() }
                        }
                    }

                    // --- ENHANCED HISTORY VIEW ---
                    ColumnLayout {
                        visible: showingHistory
                        Layout.fillWidth: true
                        spacing: 20

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 15
                            Button {
                                text: "7 DAYS"
                                onClicked: graphRange = 7
                                background: Rectangle { color: graphRange === 7 ? "#3498db" : "#222"; radius: 6; implicitWidth: 100; implicitHeight: 40 }
                            }
                            Button {
                                text: "31 DAYS"
                                onClicked: graphRange = 31
                                background: Rectangle { color: graphRange === 31 ? "#3498db" : "#222"; radius: 6; implicitWidth: 100; implicitHeight: 40 }
                            }
                        }

                        Rectangle {
                            id: graphCanvas
                            Layout.fillWidth: true; Layout.preferredHeight: 320
                            color: "#111"; radius: 15; border.color: "#333"; border.width: 2
                            clip: true

                            // --- TARGET LINE (Solid Red) ---
                            Rectangle {
                                z: 4
                                width: parent.width - 40
                                height: 3
                                color: "#ff4d4d"
                                anchors.horizontalCenter: parent.horizontalCenter
                                y: parent.height - 45 - (healthCtrl.dailyTarget / 4500) * (parent.height - 100)

                                Text {
                                    text: "TARGET: " + healthCtrl.dailyTarget
                                    color: "#ff4d4d"; font.pixelSize: 14; font.bold: true
                                    anchors.right: parent.right; anchors.bottom: parent.top; anchors.bottomMargin: 2
                                }
                            }

                            // --- AVERAGE LINE (Green Dotted) ---
                            Canvas {
                                id: avgLinePainter
                                anchors.fill: parent; z: 3
                                onPaint: {
                                    var ctx = getContext("2d"); ctx.reset();
                                    ctx.strokeStyle = "#2ecc71"; ctx.lineWidth = 3; ctx.setLineDash([10, 8]);
                                    let data = healthCtrl.history ? healthCtrl.history.slice(-graphRange) : [];
                                    if (data.length === 0) return;
                                    let sum = 0;
                                    for(let i=0; i<data.length; i++) sum += (parseInt(data[i].split(",")[1]) || 0);
                                    let avg = sum / data.length;
                                    let yPos = parent.height - 45 - (avg / 4500) * (parent.height - 100);
                                    ctx.beginPath(); ctx.moveTo(20, yPos); ctx.lineTo(parent.width - 20, yPos); ctx.stroke();

                                    avgText.y = yPos - 22; // Position the "AVERAGE" label
                                }
                            }

                            Text {
                                id: avgText
                                text: "AVERAGE"
                                color: "#2ecc71"; font.pixelSize: 16; font.bold: true
                                x: 25; z: 5
                            }

                            Row {
                                anchors.bottom: parent.bottom; anchors.bottomMargin: 45
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: parent.height - 100
                                spacing: graphRange === 7 ? 15 : 2

                                Repeater {
                                    model: healthCtrl.history ? healthCtrl.history.slice(-graphRange) : []
                                    delegate: Rectangle {
                                        width: Math.max(3, (graphCanvas.width - 80) / graphRange)
                                        height: Math.max(4, (parseInt(modelData.split(",")[1]) || 0) / 4500 * parent.height)
                                        color: "#3498db"; radius: 3; anchors.bottom: parent.bottom

                                        Text {
                                            visible: graphRange === 7 || (index % 5 === 0)
                                            text: modelData.split(",")[0].substring(5)
                                            color: "#f39c12"; font.pixelSize: 12; font.bold: true
                                            anchors.top: parent.bottom; anchors.topMargin: 8
                                            anchors.horizontalCenter: parent.horizontalCenter
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Item { Layout.preferredHeight: 30 }

                    // --- LIGHTER & BIGGER FOOTER ---
                    ColumnLayout {
                        id: footer
                        Layout.fillWidth: true; spacing: 6; Layout.bottomMargin: 30
                        Rectangle { Layout.fillWidth: true; height: 2; color: "#444"; Layout.bottomMargin: 10 }

                        Text {
                            text: "TITAN TRACK LTD.";
                            Layout.alignment: Qt.AlignHCenter; color: "#ecf0f1"; font.bold: true; font.pixelSize: 16
                        }
                        Text {
                            text: "100 Piotrkowska St, Lodz, Poland";
                            Layout.alignment: Qt.AlignHCenter; color: "#bdc3c7"; font.pixelSize: 14; font.bold: true
                        }
                        Text {
                            text: "105 kg | 189 cm | 33 years old";
                            Layout.alignment: Qt.AlignHCenter; color: "#95a5a6"; font.pixelSize: 13; font.bold: true
                        }
                    }
                }
            }
        }
    }
}
