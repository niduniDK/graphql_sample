import ballerina/graphql;

public type CovidEntry record {|
    readonly string isoCode;
    string country;
    int cases?;
    int deaths?;
    int recovered?;
    int active?;
|};

final table<CovidEntry> key(isoCode) covidEntriesTable = table [
    {isoCode: "AFG", country: "Afghanistan", cases: 159303, deaths: 7386, recovered: 146084, active: 5833},
    {isoCode: "SL", country: "Sri Lanka", cases: 598536, deaths: 15243, recovered: 568637, active: 14656},
    {isoCode: "US", country: "USA", cases: 69808350, deaths: 880976, recovered: 43892277, active: 25035097}
];

public distinct service class CovidData {
    private final readonly & CovidEntry entryRecord;

    function init(CovidEntry entryRecord) {
        self.entryRecord = entryRecord.cloneReadOnly();
    }

    resource function get isoCode() returns string => self.entryRecord.isoCode;

    resource function get country() returns string => self.entryRecord.country;

    resource function get cases() returns int? => self.entryRecord.cases;

    resource function get deaths() returns int? => self.entryRecord.deaths;

    resource function get recovered() returns int? => self.entryRecord.recovered;

    resource function get active() returns int? => self.entryRecord.active;
}

service /covid19 on new graphql:Listener(9090) {

    resource function get all() returns CovidData[] {
        return from CovidEntry entry in covidEntriesTable select new (entry);
    }

    resource function get filter(string isoCode) returns CovidData? {
        if covidEntriesTable.hasKey(isoCode) {
            return new CovidData(covidEntriesTable.get(isoCode));
        }
        return;
    }

    remote function add(CovidEntry entry) returns CovidData {
        covidEntriesTable.add(entry);
        return new CovidData(entry);
    }
}