package com.vehiclerental.service;

public class User {
    //private fields
    private String userId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String role;

    //constructor
    public User(String userId, String username, String password, String fullName, String email, String role) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
    }

    //getters to read private fields

    public String getUserId() {
        return userId;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getFullName() {
        return fullName;
    }

    public String getEmail() {
        return email;
    }

    public String getRole() {
        return role;
    }

    //setters to update private classes

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setRole(String role) {
        this.role = role;
    }

    //convert user object -> line for users.txt
    public String toFileString() {
        return userId + "," + username + "," + password + "," + fullName + "," + email + "," + role;
    }

    //convert a line from users.txt -> user object
    public static User fromFileString(String line) {
        String[] parts = line.split(",");
        return new User(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5]);
    }

    //checking if the given password matches the users password
    public boolean validateLogin(String inputPassword) {
        return this.password.equals(inputPassword);
    }
}
