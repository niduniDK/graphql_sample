import ballerina/graphql;

service class UserDetails {
    private final int userId;
    private final string userName;
    private final string userCity;
    private final int userAge;

    function init(User user) {
        self.userId = user.id;
        self.userName = user.name;
        self.userCity = user.city;
        self.userAge = user.age;
    }

    resource function get id() returns @graphql:ID int {
        return self.userId;
    }

    resource function get name() returns string {
        return self.userName;
    }

    resource function get city() returns string {
        return self.userCity;
    }

    resource function get age() returns int {
        return self.userAge;
    }
}

type User record {|
    readonly int id;
    string name;
    string city;
    int age;
|};
