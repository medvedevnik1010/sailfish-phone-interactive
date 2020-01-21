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

    property var rotationModel: [{
            "text": qsTr("X-Rot"),
            "sliderStart": -270,
            "sliderEnd": 90,
            "currentValue": -90
        }, {
            "text": qsTr("Y-Rot"),
            "sliderStart": -180,
            "sliderEnd": 180,
            "currentValue": 0
        }, {
            "text": qsTr("Z-Rot"),
            "sliderStart": 0,
            "sliderEnd": 360,
            "currentValue": 180
        }]

    property var moveModel: [{
            "text": qsTr("X")
        }, {
            "text": qsTr("Y")
        }, {
            "text": qsTr("Z")
        }]

    CellphoneCanvas {
        id: canvas3d
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            bottom: radioRow.top
        }
    }

    Row {
        id: radioRow

        anchors {
            left: parent.left
            bottom: column.top
        }

        RadioButton {
            id: rotationRadio
            checked: true
            text: qsTr("Rotation")
        }
        RadioButton {
            text: qsTr("Move")
        }
    }

    Column {
        id: column
        visible: rotationRadio.checked

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Repeater {
            model: rotationModel
            delegate: Row {
                anchors {
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                }
                Label {
                    id: rotationLabel
                    anchors.verticalCenter: rotationSlider.verticalCenter
                    text: modelData.text
                }
                Slider {
                    id: rotationSlider
                    width: column.width/3
                    from: modelData.sliderStart
                    to: modelData.sliderEnd
                    value: modelData.currentValue

                    onValueChanged: switch (index) {
                                    case 0:
                                        canvas3d.xRotAnim = value
                                        break
                                    case 1:
                                        canvas3d.yRotAnim = value
                                        break
                                    case 2:
                                        canvas3d.zRotAnim = value
                                        break
                                    }
                }
                TextInput {
                    anchors.verticalCenter: rotationSlider.verticalCenter
                    validator: DoubleValidator{decimals: 2; notation: DoubleValidator.StandardNotation }
                    text: rotationSlider.value.toFixed(2).replace('.', ',')
                    onEditingFinished: rotationSlider.value = parseFloat(text)
                }
            }
        }
    }

    Column {
        id: moveColumn
        visible: !rotationRadio.checked

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        Repeater {
            id: moveSlidersRepeater
            model: moveModel

            delegate: Row {
                anchors {
                    left: parent.left
                    leftMargin: 10
                    right: parent.right
                }

                Label {
                    id: moveLabel
                    anchors.verticalCenter: moveSlider.verticalCenter
                    text: modelData.text
                }
                Slider {
                    id: moveSlider
                    width: column.width/3
                    from: -2
                    to: 2
                    value: 0
                    onValueChanged: switch (index) {
                                    case 0:
                                        canvas3d.xMoveAnim = value
                                        break
                                    case 1:
                                        canvas3d.yMoveAnim = value
                                        break
                                    case 2:
                                        canvas3d.zMoveAnim = value
                                        break
                                    }
                }
                TextInput {
                    anchors.verticalCenter: moveSlider.verticalCenter
                    validator: DoubleValidator{decimals: 2; notation: DoubleValidator.StandardNotation }
                    text: moveSlider.value.toFixed(2).replace('.', ',')
                    onEditingFinished: moveSlider.value = parseFloat(text)
                }
            }
        }
    }
}
