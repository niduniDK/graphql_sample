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

table<User> key(id) Users = table [
    {id: 1, name: "Amal", city: "Kandy", age: 20},
    {id: 2, name: "Sunil", city: "Colombo", age: 30},
    {id: 3, name: "Upali", city: "Wattala", age: 40}
];

listener graphql:Listener graphqlListener = new (9090);

service /graphql on graphqlListener {
    resource function get all() returns UserDetails[] {
        return from User user in Users select new (user);
    }

    resource function get filter(int id) returns UserDetails? {
        if Users.hasKey(id) {
            return new UserDetails(Users.get(id));
        }
        return;
    }

}
