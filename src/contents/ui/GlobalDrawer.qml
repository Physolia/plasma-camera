/****************************************************************************
**
** Copyright (C) 2018 Jonah Brüchert
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
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

import org.kde.kirigami 2.0 as Kirigami
import QtQuick 2.7
import QtMultimedia 5.8

Kirigami.GlobalDrawer {
    Component {
        id: devicesSubAction

        Kirigami.Action {
            property string value

            onTriggered: {
                settings.cameraDeviceId = value
            }
        }
    }

    Component {
        id: resolutionSubAction

        Kirigami.Action {
            property size value

            onTriggered: {
                settings.resolution = value
            }
        }
    }

    actions: [
        Kirigami.Action {
            id: devicesAction
            text: qsTr("Camera")
            iconName: "camera-photo"
            Component.onCompleted: {
                var cameras = QtMultimedia.availableCameras
                var childrenList = []

                for (var i in cameras) {
                    childrenList[i] = devicesSubAction.createObject(devicesAction, {
                        value: cameras[i].deviceId,
                        text: "%1".arg(cameras[i].displayName)
                    })
                    devicesAction.children = childrenList
                }
            }
        },
        Kirigami.Action {
            id: resolutionAction
            text: qsTr("Resolution")
            iconName: "ratiocrop"
            Component.onCompleted: {
                var resolutions = camera.imageCapture.supportedResolutions
                var childrenList = []

                for (var i in resolutions) {
                    var pixels = resolutions[i].width * resolutions[i].height
                    var megapixels = Math.round(pixels / 10000) / 100

                    childrenList[i] = resolutionSubAction.createObject(resolutionAction, {
                        value: resolutions[i],
                        text: "%1 x %2 (%3 MP)".arg(resolutions[i].width).arg(resolutions[i].height).arg(megapixels)
                    })
                    resolutionAction.children = childrenList

                }
            }
        },
        Kirigami.Action {
	    id: wbaction
            text: qsTr("White balance")
            iconName: "whitebalance"
            Kirigami.Action {
            iconName: "camera_auto_mode"
                onTriggered: settings.whiteBalanceMode = CameraImageProcessing.WhiteBalanceAuto
                text: qsTr("Auto")
            }
            Kirigami.Action {
                iconName: "camera_white_balance_sunny"
                onTriggered: settings.whiteBalanceMode = CameraImageProcessing.WhiteBalanceSunlight
                text: qsTr("Sunlight")
            }
            Kirigami.Action {
                iconName: "camera_white_balance_cloudy"
                onTriggered: settings.whiteBalanceMode = CameraImageProcessing.WhiteBalanceCloudy
                text: qsTr("Cloudy")
            }
            Kirigami.Action {
                iconName: "camera_white_balance_incandescent"
                onTriggered: settings.whiteBalanceMode = CameraImageProcessing.WhiteBalanceTungsten
                text: qsTr("Tungsten")
            }
            Kirigami.Action {
                iconName: "camera_white_balance_flourescent"
                onTriggered: settings.whiteBalanceMode = CameraImageProcessing.WhiteBalanceFluorescent
                text: qsTr("Fluorescent")
            }
    },
    Kirigami.Action {
        text: qsTr("About")
            iconName: "help-about"
            onTriggered: {
                    aboutDialog.open();
            }
        }
    ]

    Camera {
        id: camera
        deviceId: settings.cameraDeviceId
    }
}