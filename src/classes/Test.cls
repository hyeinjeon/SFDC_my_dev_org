Map<Id, Account> mapAccount = Map<Id, Account>([
        SELECT Id, Name
        FROM Account
        WHERE Name =: ''
]);


// Populate map from SOQL query
Map<Id, Account> m = new Map<Id, Account>([SELECT Id, Name FROM Account LIMIT 10]);
// After populating the map, iterate through the map entries
for (Id idKey : m.keySet()) {
        Account a = m.get(idKey);
        System.debug(a);
}
