/*
 * Copyright (c) 2011 Nokia Corporation.
 */

var db = openDatabaseSync("CompassDb", "1.0", "Compass database", 100000);
var model = null


function createDB()
{
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

    try {
        db.transaction(function(tx) {
                           tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)', [1, 'AutoNorthInMap', 0]);
                           tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)', [2, 'BearingTurnInTrackMode', 0]);
                           tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)', [3, 'SatelliteMap', 0]);
                           tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)', [4, 'ScreenSaverInhibited', 0]);
                       });
    }
    catch(err) {
        // The rows already existed in settings table
    }
}


function resetDB()
{
    db.transaction(function(tx) {
                       tx.executeSql('DROP TABLE IF EXISTS setting');
                       tx.executeSql('DROP TABLE IF EXISTS route');
                   });
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
                       tx.executeSql('INSERT INTO route VALUES(?, ?, ?, ?)', [time, latitude, longitude, accuracyInMeters]);
                   });
}
*/

function readSettings()
{
    createDB();

    var result;
    db.transaction(function(tx) {
                       result = tx.executeSql('SELECT * FROM setting ORDER BY name');
                   });

    if(model != null) {
        model.destroy()
        model = null
    }

    model = Qt.createQmlObject('import QtQuick 1.0; ListModel {}', pane);

    for(var i = 0; i < result.rows.length; i++) {
        var item = result.rows.item(i);
        updateProperties(item);
        model.append(item);
    }

    return model;
}


function updateProperties(item) {
    if(item.name == 'AutoNorthInMap') {
        pane.autoNorthInMap = item.value
    }
    else if(item.name == 'BearingTurnInTrackMode') {
        pane.bearingTurnInTrackMode = item.value
    }
    else if(item.name == 'SatelliteMap') {
        pane.satelliteMap = item.value
    }
    else if(item.name == 'ScreenSaverInhibited') {
        pane.screenSaverInhibited = item.value
    }
}


function saveSetting(name, value)
{
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE setting SET value = ? WHERE name = ?', [value, name]);
                   });
}
