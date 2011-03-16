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
                           if(result.rows.length == 0) {
                               tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)', [1, 'Auto north in map', 0]);
                           }

                           result = tx.executeSql('SELECT * FROM setting WHERE id = 2');
                           if(result.rows.length == 0) {
                               tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)', [2, 'Bearing turnable in Compass mode', 0]);
                           }

                           result = tx.executeSql('SELECT * FROM setting WHERE id = 3');
                           if(result.rows.length == 0) {
                               tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)', [3, 'Satellite map', 0]);
                           }

                           result = tx.executeSql('SELECT * FROM setting WHERE id = 4');
                           if(result.rows.length == 0) {
                               tx.executeSql('INSERT INTO setting VALUES(?, ?, ?)', [4, 'Prevent screensaver', 0]);
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
                       tx.executeSql('INSERT INTO route VALUES(?, ?, ?, ?)', [time, latitude, longitude, accuracyInMeters]);
                   });
}
*/


function readSettings()
{
    createDB();

    var result;

    try {
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
    }
    catch(err) {
        console.log("DB error in readSettings: " + err)
        return 0
    }

    return model;
}


function updateProperties(item) {
    if(item.id == 1) {
        pane.autoNorthInMap = item.value
    }
    else if(item.id == 2) {
        pane.bearingTurnInTrackMode = item.value
    }
    else if(item.id == 3) {
        pane.satelliteMap = item.value
    }
    else if(item.id == 4) {
        pane.screenSaverInhibited = item.value
    }
}


function saveSetting(name, value)
{
    try {
        db.transaction(function(tx) {
                           tx.executeSql('UPDATE setting SET value = ? WHERE name = ?', [value, name]);
                       });
    }
    catch(err) {
        console.log("DB error in saveSetting: " + err)
    }
}
