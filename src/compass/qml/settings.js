
var db = openDatabaseSync("CompassDb", "1.0", "Compass database", 100000);


function resetDB()
{
    db.transaction(function(tx) {
                       //tx.executeSql('DROP TABLE IF EXISTS settings');
                       var createSql;
                       createSql  = 'CREATE TABLE IF NOT EXISTS settings(';
                       createSql += 'name TEXT PRIMARY KEY,';
                       createSql += 'value NUMERIC)';
                       tx.executeSql(createSql);
                   });

    try {
        db.transaction(function(tx) {
                           tx.executeSql('INSERT INTO settings VALUES(?, ?)', ['AutoNorthInMap', 0]);
                           tx.executeSql('INSERT INTO settings VALUES(?, ?)', ['BearingTurnInTrackMode', 0]);
                           tx.executeSql('INSERT INTO settings VALUES(?, ?)', ['MapMode', 0]);
                           tx.executeSql('INSERT INTO settings VALUES(?, ?)', ['ScreenSaverInhibited', 0]);
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

    var model = Qt.createQmlObject('import QtQuick 1.0; ListModel {}', pane);

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
