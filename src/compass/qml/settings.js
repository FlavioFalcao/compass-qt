
var db = openDatabaseSync("CompassDb", "1.0", "Compass database", 100000);
var model = null

function resetDB()
{
    db.transaction(function(tx) {
                       //tx.executeSql('DROP TABLE IF EXISTS settings');
                       var createSql;
                       createSql  = 'CREATE TABLE IF NOT EXISTS settings(';
                       createSql += 'id NUMERIC PRIMARY KEY,';
                       createSql += 'name TEXT UNIQUE,';
                       createSql += 'value NUMERIC NOT NULL)';
                       tx.executeSql(createSql);
                   });

    try {
        db.transaction(function(tx) {
                           tx.executeSql('INSERT INTO settings VALUES(?, ?, ?)', [1, 'AutoNorthInMap', 0]);
                           tx.executeSql('INSERT INTO settings VALUES(?, ?, ?)', [2, 'BearingTurnInTrackMode', 0]);
                           tx.executeSql('INSERT INTO settings VALUES(?, ?, ?)', [3, 'MapMode', 0]);
                           tx.executeSql('INSERT INTO settings VALUES(?, ?, ?)', [4, 'ScreenSaverInhibited', 0]);
                       });
    }
    catch(err) {
        // The rows already existed in settings table
    }
}


function readSettings()
{
    var result;
    db.transaction(function(tx) {
                       result = tx.executeSql('SELECT * FROM settings ORDER BY name');
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
    else if(item.name == 'MapMode') {
        pane.mapMode = item.value
    }
    else if(item.name == 'ScreenSaverInhibited') {
        pane.screenSaverInhibited = item.value
    }
}


function saveSetting(name, value)
{
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE settings SET value = ? WHERE name = ?', [value, name]);
                   });
}
