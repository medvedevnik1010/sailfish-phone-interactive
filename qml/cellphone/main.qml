/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtCanvas3D module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

Window {
    property int initialWidth: 800
    property int initialHeight: 600
    id: mainView
    width: initialWidth
    height: initialHeight
    visible: true
    title: "Sailfish Phone"
    color: "white"

    property var slidersModel: [{
            "visible": rotationRadio.checked,
            "text": qsTr("X-Rot"),
            "sliderStart": -270,
            "sliderEnd": 90,
            "baseValue": -90
        }, {
            "visible": rotationRadio.checked,
            "text": qsTr("Y-Rot"),
            "sliderStart": -180,
            "sliderEnd": 180,
            "baseValue": 0
        }, {
            "visible": rotationRadio.checked,
            "text": qsTr("Z-Rot"),
            "sliderStart": 0,
            "sliderEnd": 360,
            "baseValue": 180
        }, {
            "visible": !rotationRadio.checked,
            "text": "X",
            "sliderStart": -2,
            "sliderEnd": 2,
            "baseValue": 0
        }, {
            "visible": !rotationRadio.checked,
            "text": "Y",
            "sliderStart": -2,
            "sliderEnd": 2,
            "baseValue": 0
        }, {
            "visible": !rotationRadio.checked,
            "text": "Z",
            "sliderStart": -2,
            "sliderEnd": 2,
            "baseValue": 0
        }]

    property var iconsModel: [{
            "iconSource": "phone_1.png"
        }, {
            "iconSource": "phone_2.png"
        }, {
            "iconSource": "phone_3.png"
        }, {
            "iconSource": "phone_4.png"
        }]

    CellphoneCanvas {
        id: canvas3d
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            bottom: slidersColumn.top
        }
    }

    Column {
        id: slidersColumn
        anchors {
            bottom: parent.bottom
            top: column.top
            bottomMargin: 10
            left: parent.left
            right: parent.horizontalCenter
        }
        spacing: 10

        Row {
            id: radioRow
            anchors.left: parent.left
            RadioButton {
                id: rotationRadio
                checked: true
                text: qsTr("Rotation")
            }
            RadioButton {
                text: qsTr("Move")
            }
        }

        Repeater {
            model: slidersModel
            delegate: Row {
                visible: modelData.visible
                anchors {
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                }
                Label {
                    id: sliderLabel
                    anchors.verticalCenter: slider.verticalCenter
                    text: modelData.text
                }
                Slider {
                    id: slider
                    width: slidersColumn.width - 100
                    from: modelData.sliderStart
                    to: modelData.sliderEnd
                    value: currentValue(index, modelData.baseValue)
                    onValueChanged: setPositioningValues(index, value)
                }
                TextInput {
                    anchors.verticalCenter: slider.verticalCenter
                    validator: DoubleValidator {
                        locale: "C"
                        decimals: 2
                        notation: DoubleValidator.StandardNotation
                    }
                    text: (slider.value - modelData.baseValue).toFixed(2)
                    onEditingFinished: {
                        slider.value = parseFloat(text.replace(',', '.')) + modelData.baseValue
                        text = (slider.value - modelData.baseValue).toFixed(2)
                    }
                }
            }
        }
    }

    Column {
        id: column
        anchors {
            left: parent.horizontalCenter
            right: parent.right
            topMargin: 10
            bottomMargin: 10
            bottom: groupBox.top
        }
        spacing: 10

        Label {
            anchors.left: parent.left
            text: qsTr("Device Rotation")
        }
        Row {
            spacing: 10
            anchors {
                right: parent.right
                rightMargin: 10
                left: parent.left
            }
            Repeater {
                model: iconsModel
                delegate: Button {
                    height: name.height + 10
                    width: name.height + 10
                    Image {
                        id: name
                        anchors.centerIn: parent
                        source: modelData.iconSource
                    }
                    onClicked: switchOrientation(index)
                }
            }
        }
        Label {
            anchors.left: parent.left
            text: qsTr("Resulting Values")
        }
    }

    GroupBox {
        id: groupBox
        anchors {
            right: parent.right
            left: parent.horizontalCenter
            bottom: parent.bottom
            rightMargin: 10
            bottomMargin: 10
        }
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Label {
                text: qsTr("Accelerometer (m/s2):")
            }
            Label {
                text: qsTr("Gyroscope (rad/s):")
            }
            Label {
                text: qsTr("Magnetometer (μT):")
            }
        }
    }

    function switchOrientation(index) {
        canvas3d.xRotValue = slidersModel[0].baseValue
        canvas3d.zRotValue = slidersModel[2].baseValue
        switch (index) {
        case 0:
            canvas3d.yRotValue = slidersModel[1].baseValue
            break
        case 1:
            canvas3d.yRotValue = slidersModel[1].baseValue + 90
            break
        case 2:
            canvas3d.yRotValue = slidersModel[1].baseValue + 180
            break
        case 3:
            canvas3d.yRotValue = slidersModel[1].baseValue - 90
            break
        }
    }

    function setPositioningValues(index, value) {
        switch (index) {
        case 0:
            canvas3d.xRotValue = value
            break
        case 1:
            canvas3d.yRotValue = value
            break
        case 2:
            canvas3d.zRotValue = value
            break
        case 3:
            canvas3d.xMoveValue = value
            break
        case 4:
            canvas3d.yMoveValue = value
            break
        case 5:
            canvas3d.zMoveValue = value
            break
        }
    }

    function currentValue(index, value) {
        switch (index) {
        case 0:
            return canvas3d.xRotValue === value ? value : canvas3d.xRotValue
        case 1:
            return canvas3d.yRotValue === value ? value : canvas3d.yRotValue
        case 2:
            return canvas3d.zRotValue === value ? value : canvas3d.zRotValue
        case 3:
            return canvas3d.xMoveValue === value ? value : canvas3d.xMoveValue
        case 4:
            return canvas3d.yMoveValue === value ? value : canvas3d.yMoveValue
        case 5:
            return canvas3d.zMoveValue === value ? value : canvas3d.zMoveValue
        }
    }
}
