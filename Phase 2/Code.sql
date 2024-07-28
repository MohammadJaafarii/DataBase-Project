1.
use Phase_2;
SELECT postID, NumOfComments, NumOfLikes
FROM (
    SELECT Post.postID, COUNT(DISTINCT Comment.commentID) AS NumOfComments, COUNT(DISTINCT Likes.userID) AS NumOfLikes
    FROM Post LEFT JOIN Comment ON Post.postID = Comment.postID LEFT JOIN Likes ON Post.postID = Likes.postID
    GROUP BY Post.postID) as NumOfCommentsLikes
WHERE NumOfComments > NumOfLikes;


2.
use phase_2;
with g1 as (
select *
from GroupMembership g
join `groups` using (groupID)),
g2 as (
select *
from GroupMembership g1
join `groups` using (groupID))
SELECT g1.groupID, g1.groupName, g2.groupID, g2.groupName, COUNT(*) AS CommonUsers
FROM g1
JOIN g2 ON g1.userID = g2.userID AND g1.groupID <> g2.groupID
GROUP BY g1.groupID, g2.groupID
HAVING COUNT(*) =
  (SELECT MAX(common_persons)
   FROM (
     SELECT g1.groupID as groupID1, g1.groupName as groupName1, g2.groupID as groupID2, g2.groupName as groupName2, COUNT(*) AS common_persons
     FROM g1
     JOIN g2 ON g1.userID = g2.userID AND g1.groupID <> g2.groupID
     GROUP BY g1.groupID, g2.groupID
   ) AS subquery
  )
  limit 1;
  
  
  3.
use Phase_2;

with NumOfCommunityMembership as(
select communityID, count(userID) as numofmembers
from community join communitymembership using(communityID)
group by communityID
order by communityID),
CommunityPostUser as(
select user.userID, post.postID, communityposts.communityID
from user join post on userID = creatorUserID join communityposts using(postID)),
FindCommunityUser as(
select communityID, userID
from community join communitymembership using(communityID)),
UsersPostForEachCommunity as(
select CommunityPostUser.communityID, count(distinct communitypostuser.userID) as numofposts
from communitypostuser
join FindCommunityUser using(communityID, userID)
group by CommunityPostUser.communityID)
select *
from NumOfCommunityMembership 
join UsersPostForEachCommunity using (communityID)
where NumOfCommunityMembership.numofmembers = UsersPostForEachCommunity.numofposts


4.
use Phase_2;

SELECT 
    groupID, 
    groupName, 
    ((CAST(count(MessageID) AS real) / CAST((SELECT count(MessageID) FROM message) AS real)) * 100) AS Percentage
FROM 
    `groups`
LEFT JOIN 
    message USING (groupID)
GROUP BY 
    groupID
ORDER BY 
    groupName;


5.
use Phase_2;
select followedID,username, count(followerID) as NumberOfFollowers 
from follow join user on followedID = userID
group by followedID
order by count(followerID) desc
limit 3;


6.
use Phase_2;
select postID, count(userID) as NumberOfLikes
from post
left join likes using(postID)
group by postID 
order by NumberOfLikes desc
limit 3;


7.
with NumOfFollowers as(
select followedID,username, count(followerID) as NumberOfFollowers 
from follow join user on followedID = userID
group by followedID
order by count(followerID) desc 
limit 1)
select *
from likes join post using(postID)
where likes.userID = (select followedID from NumOfFollowers)


8.
use Phase_2;
with NumOfCommentsPerUser as(
select userID,username, count(commentID) as NumComment
from user
left join comment using(userID)
group by userID),
NumOfLikesPerUser as(
select userID, count(postID) as NumLike
from user
left join likes using(userID)
group by userID)
select userID, username, (NumComment + NumLike) as NumberOfCommentsAndLikes
from NumOfCommentsPerUser join NumOfLikesPerUser using(userID)
order by NumberOfCommentsAndLikes desc
limit 1;


9.
use Phase_2;

with NumOfAdminsForEachUser as(
select userID, count(userID) as AdminNum
from groupmembership
where role = "Admin"
group by userID
order by count(userID) desc)
select * from NumOfAdminsForEachUser join user using(userID)
limit 1;



10.
use Phase_2;


select distinct userID, username, email, password
from groupmembership
join user using(userID)
where role = "Admin" and userID in (select userID 
									from communitymembership
                                    where role = "Admin")
									

11.
use Phase_2;

select hashtagID, context, count(userID) as NumberOfLikes
from likes
left join posthashtag using(postID)
join hashtag using(hashtagID)
group by hashtagID
order by NumberOfLikes desc, hashtagID 
limit 1;


12.
use Phase_2;

with NumberOfOwnerPosts as(
select creatorUserID, community.communityID, count(post.postID)
from community 
join communityposts using (communityID)
join post on post.postID = communityposts.postID and post.creatorUserID = community.ownerID
group by creatorUserID, community.communityID)
select communityID, communityName
from community
where communityID not in (select communityID from NumberOfOwnerPosts)
order by communityName


13.
use Phase_2;

with blockers as (
select groupID, groupName, blockerID, BlockedID
from blacklist
join groupmembership on blockerID = userID
join `groups` using(groupID)),
blocked as(
select groupID, groupName, blockerID, BlockedID
from blacklist
join groupmembership on blockedID = userID
join `groups` using(groupID))
select distinct b1.groupName
from blockers as b1 
join blocked as b2 
where b1.groupID = b2.groupID and b1.blockedID = b2.blockedID


14.
use Phase_2;

with UserWithMostPost as(
select creatorUserID as UserWithMostPost, count(postID) as NumberOfPosts
from post
group by creatorUserID
order by NumberOfPosts desc
limit 1)
select (select UserWithMostPost from UserWithMostPost) as UserWithMostPost , count(postID) as NumberOfBlockerPosts 
from post
where creatorUserID in (select blockerID
						from blacklist, UserWithMostPost as t
                        where blockedID = t.UserWithMostPost)
group by creatorUserID


15.
use Phase_2;


select groupID, groupName, count(userID) as NumberOfAdmins
from groupmembership
join `groups` using(groupID)
where role = "Admin"
group by groupID
order by NumberOfAdmins desc
limit 1


16.
use Phase_2;

with NumOfPostsPerCommunity as(
select CommunityID, count(postID) as NumOfPosts 
from communitymembership 
left join communityposts using (communityID)
group by communityID),
NumOfUsersPerCommunity as(
select communityID, count(userID) as NumOfUsers
from communitymembership
group by communityID)
select communityID, communityName, (NumOfposts/NumOfUsers) as `Post/User`
from NumOfPostsPerCommunity 
join NumOfUsersPerCommunity using(communityID)
join community using(communityID)
order by `Post/User` desc, communityName
limit 3;


Emtiazi:
use Phase_2;

with UserWithMostFollower(userID,number) as (
    select followerID,count(followedID) from Follow group by followerID order by count(followedID)  Desc LIMIT 1),
Followinginfo(userid) as (
    select followedID from Follow where followerID in ( select userID from  UserWithMostFollower)),
LikedByFollowing(postID) as (
    select postID from Likes where userID in ( select userid from Followinginfo)),
CommentedByFollowing(postID) as (
    select postID from Comment where userID in ( select userid from Followinginfo)),
PostedByFollowing(postID) as (
    select postID from Post where creatorUserID in ( select userid from Followinginfo)),
AllPost(postID) as (
    select postID from PostedByFollowing
    union
    select postID from CommentedByFollowing
    union
    select postID from LikedByFollowing
)
select * from Post where postId in (select postID from AllPost) order by createTime
