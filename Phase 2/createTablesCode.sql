-- Create Table
create table User(
userID varchar(25) not null,
username varchar(25),
email varchar(50),
password varchar(50),
phoneNumber varchar(13),
primary key (userID)
);

create table USerProfile(
userID varchar(25) not null,
firstName varchar(25),
lastName varchar(25),
bio text,
profilePictureUrl varchar(200),
primary key (userID),
foreign key (userID) references User(userID)
); 

create table Post(
postID varchar(25),
creatorUserID varchar(25),
caption text,
createTime datetime,
mediaUrl varchar(200),
primary key (postID),
foreign key (creatorUserID) references User (userID)
);

create table Comment(
commentID varchar(25),
postID varchar(25),
userID varchar(25),
context text,
createTime datetime,
primary key (commentID),
foreign key (postID) references Post(postID),
foreign key (userID) references User(userID)
);

create table likes(
postID varchar(25),
userID varchar(25),
likeTime datetime,
primary key(postID, userID),
foreign key (postID) references Post (postID),
foreign key (userID) references User(userID)
);

create table Groups(
groupID varchar(25),
ownerID varchar(25),
groupName varchar(30),
groupDescription text,
groupPictureUrl varchar(200),
primary key(groupID),
foreign key(ownerID) references User(userID)
);

create table Message(
messageID varchar(25),
groupID varchar(25),
senderID varchar(25),
sendTime datetime,
mediaUrl varchar(200),
context text,
primary key (messageID),
foreign key (groupID) references Groupp(groupID),
foreign key (senderID) references user(userID)
);

create table GroupMembership(
userID varchar(25),
groupID varchar(25),
role varchar(10),
joinTime datetime,
primary key(userID, groupID),
foreign key (userID) references user(userID),
foreign key (groupID) references groupp (groupID)
);

create table Community(
communityID varchar(25),
ownerID varchar(25),
communityName varchar(25),
communityDescription text,
communityPictureUrl varchar(200),
primary key (communityID),
foreign key (ownerID) references User (userID)
);

create table CommunityMembership(
userID varchar(25),
communityID varchar(25),
role varchar(10),
joinTime datetime,
primary key (userID, communityID),
foreign key (userID) references user (userID),
foreign key(communityID) references community (communityID)
);

create table CommunityPosts(
postID varchar(25),
communityID varchar(25),
postTime datetime,
primary key (postID, communityID),
foreign key (postID) references post (postID),
foreign key (communityID) references community(communityID)
);

create table Hashtag(
hashtagID varchar(25),
context text,
primary key(hashtagID)
);

create table PostHashtag(
postID varchar(25),
hashtagID varchar(25),
primary key (postID, hashtagID),
foreign key (postID) references post(postID),
foreign key (hashtagID) references Hashtag(hashtagID)
);

create table Follow(
followerID varchar(25),
followedID varchar(25),
followTime datetime,
primary key (followerID, followedID),
foreign key (followerID) references user(userID),
foreign key (followedID) references user(userID)
);

create table BlackList(
blockerID varchar(25),
blockedID varchar(25),
blockTime datetime,
primary key (blockerID, blockedID),
foreign key (blockerID) references user(userID),
foreign key (blockedID) references user(userID)
);