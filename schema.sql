/*
Anthony Pensak
Cesar Herrera
Samuel Jefferson
Christopher Ghatas
*/
CREATE DATABASE 336db;
USE 336db;

CREATE TABLE User
	(username varchar(20) primary key,
	alias varchar(20),
    balance float,
    password varchar(20),
    email_address varchar(40),
    bank_account_number integer);

CREATE TABLE Admin
	(admin_username varchar(20) primary key,
    foreign key (admin_username) references User(username));

CREATE TABLE End_user
	(end_user_username varchar(20) primary key,
    foreign key (end_user_username) references User(username));

CREATE TABLE Customer_rep
	(customer_rep_username varchar(20) primary key,
    foreign key (customer_rep_username) references User(username));

# CHECK BOTTOM OF misc_queries on how to drop all three tables Alert,create_alert,receive_alert
CREATE TABLE Alert
	(alert_id INTEGER AUTO_INCREMENT PRIMARY KEY,
	 model VARCHAR(40),
     make VARCHAR(40),
     color VARCHAR(25),
     car_type VARCHAR(20),
	 alert_date DATETIME
    );

CREATE TABLE change_account_info
	(customer_rep_username varchar(20),
    username varchar(20),
    primary key (customer_rep_username, username),
    foreign key (customer_rep_username) references Customer_rep(customer_rep_username),
    foreign key (username) references User(username));

CREATE TABLE create_alert
	(username varchar(20),
	 alert_id integer,
     primary key (username, alert_id),
     foreign key (username) references User(username) ON UPDATE CASCADE ON DELETE CASCADE,
     foreign key (alert_id) references Alert(alert_id) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE receive_alert
	(username varchar(20),
    alert_id integer,
    primary key (username, alert_id),
    foreign key (username) references User(username) ON UPDATE CASCADE ON DELETE CASCADE,
    foreign key (alert_id) references Alert(alert_id) ON UPDATE CASCADE ON DELETE CASCADE);

create table Email
	(email_id integer AUTO_INCREMENT primary key,
	subject_ varchar(140),
	content TEXT,
	date_time	datetime,
	from_ varchar(20),
	to_ varchar(20),
	foreign key (from_) references User(username),
	foreign key (to_) references User(username));

create table Question
	(question_id integer primary key,
	answer_id integer,
	foreign key (question_id) references Email(email_id),
	foreign key (answer_id) references Email(email_id)
	);

create table Auction
	(auction_id integer AUTO_INCREMENT primary key,
	end_date DATETIME,
	initial_price FLOAT,
	bid_increment FLOAT,
	minimum_price FLOAT
	);

# amount is is Bid
# if the Bid is an Automatic_Bid then amount is the upper limit
# if the Bid is a Manual_bid then amount is the bid amount
create table Bid
	(bid_id integer AUTO_INCREMENT primary key,
	amount float,
	winning_bid boolean,
	time_ datetime);


create table Automatic_Bid
	(bid_id	integer primary key,
	upper_limit float,
	foreign key (bid_id) references Bid(bid_id) ON UPDATE CASCADE ON DELETE CASCADE);

create table Manual_Bid
	(bid_id integer primary key,
	foreign key (bid_id) references Bid(bid_id) ON UPDATE CASCADE ON DELETE CASCADE);

create table on_
	(bid_id integer primary key,
	auction_id integer,
	foreign key (bid_id) references Bid(bid_id) ON UPDATE CASCADE ON DELETE CASCADE,
	foreign key (auction_id) references Auction(auction_id) ON UPDATE CASCADE ON DELETE CASCADE);

create table creates_Auc
	(auction_id integer primary key,
	username varchar(20),
	foreign key (auction_id) references Auction(auction_id) ON UPDATE CASCADE ON DELETE CASCADE,
	foreign key (username) references User(username) ON UPDATE CASCADE ON DELETE CASCADE);

create table creates_Bid
	(bid_id integer primary key,
	username varchar(20),
	foreign key (bid_id) references Bid(bid_id) ON UPDATE CASCADE ON DELETE CASCADE,
	foreign key (username) references User(username));

create table send
	(username varchar(20),
	email_id integer,
	primary key (username,email_id),
	foreign key (username) references User(username),
	foreign key (email_id) references Email(email_id)
	);

create table recieve
	(username varchar(20),
	email_id integer,
	primary key (username,email_id),
	foreign key (username) references User(username),
	foreign key (email_id) references Email(email_id)
	);

CREATE TABLE Car
	(VIN INTEGER PRIMARY KEY,
    model VARCHAR(40),
    make VARCHAR(40),
    color VARCHAR(25),
    mileage INTEGER
    );

CREATE TABLE updates
	( auction_id INTEGER,
    alert_id INTEGER,
    PRIMARY KEY (auction_id, alert_id),
    FOREIGN KEY (auction_id) REFERENCES Auction(auction_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (alert_id) REFERENCES Alert(alert_id)
    );

create table for_
	(auction_id integer primary key,
	VIN integer,
	foreign key (auction_id) references Auction(auction_id) ON UPDATE CASCADE ON DELETE CASCADE,
	foreign key (VIN) references Car(VIN));

CREATE TABLE Sedan
	(VIN INTEGER,
    FOREIGN KEY(VIN) REFERENCES Car(VIN),
    PRIMARY KEY(VIN)
    );

CREATE TABLE Minivan
	(VIN INTEGER,
    FOREIGN KEY(VIN) REFERENCES Car(VIN),
    PRIMARY KEY(VIN)
    );

CREATE TABLE SUV
	(VIN INTEGER,
    FOREIGN KEY(VIN) REFERENCES Car(VIN),
    PRIMARY KEY(VIN)
    );

CREATE TABLE Report
	(report_id INTEGER AUTO_INCREMENT PRIMARY KEY,
	report_type VARCHAR(100),
	report_date DATETIME,
	report_data TEXT);

CREATE TABLE generates
	(
	report_id INTEGER,
	 admin_username varchar(20),
	 PRIMARY KEY(report_id),
	 FOREIGN KEY (report_id) REFERENCES Report(report_id),
	 FOREIGN KEY (admin_username) REFERENCES Admin(admin_username)
 	);

# create admin account
INSERT INTO User VALUES("admin", null, 0, "admin", "admin@admin.admin", 0);
INSERT INTO Admin(admin_username)
	SELECT username
	FROM User
	Where username="admin";

# create question customer rep account
INSERT INTO User VALUES("question", null, 0, "default", "question@question.question", 0);
INSERT INTO Customer_rep VALUES("question");

# create default customer rep
INSERT INTO User VALUES("rep1", null, 0, "rep1", "rep1@rep1.rep1", 0);
INSERT INTO Customer_rep VALUES("rep1");
