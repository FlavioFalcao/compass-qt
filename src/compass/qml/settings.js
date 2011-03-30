/*
 * Copyright (c) 2011 Nokia Corporation.
 */

var db = openDatabaseSync("CompassDb", "1.0", "Compass database", 100000);
var model = null


function createDB()
{
    try {
        db.transaction(function(tx) {
            var createSql;
            createSql  = 'CREATE TABLE IF NOT EXISTS setting(';
            createSql += 'id NUMERIC PRIMARY KEY,';
            createSql += 'name TEXT UNIQUE,';
            createSql += 'value NUMERIC NOT NULL)';
            tx.executeSql(createSql);

            /*
            createSql  = 'CREATE TABLE IF NOT EXISTS route(';
            createSql += 'time NUMERIC PRIMARY KEY,';
            createSql += 'latitude REAL,';
            createSql += 'longitude REAL,';
            createSql += 'accuracyInMeters REAL)'
            tx.executeSql(createSql);
            */
        });


        db.transaction(function(tx) {
            var result;
            result = tx.executeSql('SELECT * FROM setting WHERE id = 1');
            if (result.rows.length == 0) {
                tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)',
                              [1, 'Auto north in map', 0]);
            }

            result = tx.executeSql('SELECT * FROM setting WHERE id = 2');
            if (result.rows.length == 0) {
                tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)',
                              [2, 'Bearing turnable in Compass mode', 1]);
            }

            result = tx.executeSql('SELECT * FROM setting WHERE id = 3');
            if (result.rows.length == 0) {
                tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)',
                              [3, 'Satellite map', 0]);
            }

            result = tx.executeSql('SELECT * FROM setting WHERE id = 4');
            if (result.rows.length == 0) {
                tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)',
                              [4, 'Prevent screensaver', 0]);
            }

            result = tx.executeSql('SELECT * FROM setting WHERE id = 5');
            if (result.rows.length == 0) {
                tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)',
                              [5, 'Use feedback in calibration', 1]);
            }
        });
    }
    catch(err) {
        console.log("DB error in createDB: " + err)
        return false;
    }

    return true;
}


function dropTables()
{
    try {
        db.transaction(function(tx) {
            tx.executeSql('DROP TABLE IF EXISTS setting');
            //tx.executeSql('DROP TABLE IF EXISTS route');
        });
    }
    catch(err) {
        console.log("DB error in resetDB: " + err)
    }
}


/*
function removeRoute()
{
    db.transaction(function(tx) {
        tx.executeSql('DELETE route');
    });
}


function insertRouteCoordinate(time, latitude, longitude, accuracyInMeters)
{
    db.transaction(function(tx) {
        tx.executeSql('INSERT INTO route VALUES(?, ?, ?, ?)',
                      [time, latitude, longitude, accuracyInMeters]);
    });
}
*/


function readSettings()
{
    createDB();

    var result;

    try {
        db.readTransaction(function(tx) {
            result = tx.executeSql('SELECT * FROM setting ORDER BY id');
        });

        if (model != null) {
            model.destroy()
            model = null
        }

        model = Qt.createQmlObject('import QtQuick 1.0; ListModel {}', pane);

        for (var i = 0; i < result.rows.length; i++) {
            var item = result.rows.item(i);
            console.log("id: " + item.id + " name: " + item.name +
                        " value: " + item.value)
            updateProperty(item);
            model.append(item);
        }
    }
    catch(err) {
        console.log("DB error in readSettings: " + err)
        return 0
    }

    return model;
}


function updateProperty(item) {
    if (item.id == 1) {
        pane.autoNorthInMap = item.value
    }
    else if (item.id == 2) {
        pane.bearingTurnInTrackMode = item.value
    }
    else if (item.id == 3) {
        pane.satelliteMap = item.value
    }
    else if (item.id == 4) {
        pane.screenSaverInhibited = item.value
    }
    else if (item.id == 5) {
        pane.feedbackEnabled = item.value
    }
}


function saveSetting(item)
{
    try {
        db.transaction(function(tx) {
            tx.executeSql('UPDATE setting SET value = ? WHERE id = ?',
                          [item.value, item.id]);
        });
    }
    catch(err) {
        console.log("DB error in saveSetting: " + err)
    }
}


function toggleSetting(index, value)
{
    var item = model.get(index);
    item.value = value

    saveSetting(item);
    updateProperty(item);

    if (item.id == 1 && item.value == 1) {
        // If "Auto north in map" is enabled, disable
        // "Bearing turnable in Compass mode"
        var setting = model.get(1);
        setting.value = 0;
        saveSetting(setting);
        updateProperty(setting);
    }
    else if (item.id == 2 && item.value == 1) {
        // If "Bearing turnable in Compass mode" is enabled, disable
        // "Auto north in map" is enabled, disable
        var setting = view.model.get(0);
        setting.value = 0;
        saveSetting(setting);
        updateProperty(setting);
    }
}
