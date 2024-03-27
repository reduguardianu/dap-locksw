/*
    SPDX-FileCopyrightText: 2011 Sebastian Kügler <sebas@kde.org>
    SPDX-FileCopyrightText: 2011 Viranch Mehta <viranch.mehta@gmail.com>
    SPDX-FileCopyrightText: 2013-2015 Kai Uwe Broulik <kde@privat.broulik.de>
    SPDX-FileCopyrightText: 2021-2022 ivan tkachenko <me@ratijas.tk>
    SPDX-FileCopyrightText: 2023 Natalie Clarius <natalie.clarius@kde.org

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts

import org.kde.coreaddons as KCoreAddons
import org.kde.kcmutils // KCMLauncher
import org.kde.config // KAuthorized
import org.kde.notification
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.kitemmodels as KItemModels


PlasmoidItem {
    id: main

    property QtObject pmSource: P5Support.DataSource {
        id: pmSource
        engine: "powermanagement"
        connectedSources: sources
        onSourceAdded: source => {
            disconnectSource(source);
            connectSource(source);
        }
        onSourceRemoved: source => {
            disconnectSource(source);
        }
        onDataChanged: {
            if (typeof pmSource.data["Inhibitions"] !== "undefined") {
                main.hasInhibitions = false
                for(var key in pmSource.data["Inhibitions"]) {
                    main.hasInhibitions = true
                }
            }

        }
    }

    switchWidth: Kirigami.Units.gridUnit * 10
    switchHeight: Kirigami.Units.gridUnit * 10
    property bool inhibitated: false
    property bool hasInhibitions: false
    property int cookie: -1

    Plasmoid.icon: {
        let iconName = "system-lock-screen";
        if (inhibitated) {
            return "ace"
        }
        if (hasInhibitions) {
            return "agenda"
        }
        return iconName;
    }

    function toggleInhibition() {
        const service = pmSource.serviceForSource("PowerDevil");
        var operation = undefined
        if (!inhibitated) {
            operation = service.operationDescription("beginSuppressingScreenPowerManagement");
            operation.reason = "User-requested inhibition"
            inhibitated = true
        }
        else {
            operation = service.operationDescription("stopSuppressingScreenPowerManagement");
            operation.cookie = cookie;
            inhibitated = false
        }
        service.startOperationCall(operation);
    }


    compactRepresentation: CompactRepresentation {

        onClicked: mouse => {
            if (mouse.button == Qt.LeftButton) {
                toggleInhibition();
            }
        }
    }

    fullRepresentation: CompactRepresentation {

        onClicked: mouse => {
            if (mouse.button == Qt.LeftButton) {
                toggleInhibition();
            }
        }
    }

    Component.onCompleted: {
        Plasmoid.removeInternalAction("configure");
    }
}
