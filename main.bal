import ballerina/graphql;

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
}
