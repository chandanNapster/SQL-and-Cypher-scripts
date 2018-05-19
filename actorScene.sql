BEGIN TRAN
CREATE TABLE #person(
	person_id    INT,
	person_name  VARCHAR(30),
	age		    INT,
	nationality VARCHAR(30)
)

CREATE TABLE #actor(
	actor_id INT,
	movie_acted VARCHAR(30),
	person_id INT
)

CREATE TABLE #scene(
	scene_id   INT,
	scene_name VARCHAR(MAX),
	scene_date DATETIME,
)

CREATE TABLE #actorScene(
	actor_id INT,
	scene_id INT
)

CREATE TABLE #conversations(
	actor_id1 INT,
	actor_id2 INT,
	scene_id  INT,
	conversation1 VARCHAR(MAX)
)

INSERT #person 
VALUES
(1001,'CHANDAN',	29,	'INDIAN'),
(2012,'DORTHY',	13,	'AMERICAN'),
(3230,'SCARECROW',	20,	'BRITISH'),
(4781,'LION',		10,	'AFRICAN'),
(5332,'TINMAN',	40,	'JAPANESE'),
(6981,'WIZRAD',	100,'NEVERLAND'),
(691,'ALEX',	22,'BRITISH'),
(981,'JEFF',	43,'FRENCH'),
(1981,'SAM',	54,'GERMAN'),
(2081,'ROHAN',	12,'INDIAN'),
(3081,'EMILY',	10,'AUSTRALIAN')


INSERT #scene
VALUES
(101,'FIGHT', '1938-05-15'),
(102,'DREAM', '1938-05-24'),
(103,'IN THE MORNING', '1938-05-30'),
(104,'SUNSET','1938-06-11'),
(105,'BEACH', '1938-07-18')

INSERT #actorScene
VALUES
(2,101),(4,101),(3,101),(6,101),(5,101),(3,102),(2,104),(2,105),(2,103),(2,103),
(4,103),(4,103),(5,103),(6,103),(6,103),(4,103),(4,103),(5,103),(2,103),(2,103),
(3,103),(2,103),(4,103),(3,103),(5,103),(3,103),(4,103),(3,103),(5,103),(3,103),
(2,103),(2,104),(2,105),(3,105),(2,105),(2,105),(2,105),(2,105),(2,105),(2,105)

INSERT #conversations
VALUES
(2,3,101, 'Hello How are you.'),
(3,5,102, 'Nice Day.'),
(2,4,103, 'How was your weekend.'),
(4,2,103, 'It was boring.'),
(6,2,105, 'Good day to you sir.'),
(5,4,104, 'Hi.')

INSERT #actor
VALUES 
(2,'WIZRAD OF OZ',2012),
(3,'WIZRAD OF OZ',3230),
(4,'WIZRAD OF OZ',4781),
(5,'WIZRAD OF OZ',5332),
(6,'WIZRAD OF OZ',6981)
------------------------------- JOIN------------------------------
-- GIVE ME INFORMATION ABOUT PEOPLE WHO ARE ACTORS AND NUMBER OF SCENES THEY HAVE ACTED
SELECT 'INFORMATION ABOUT PEOPLE WHO ARE ACTORS AND NUMBER OF SCENES THEY HAVE ACTED IN'
SELECT	p.person_name [Name],
		p.age [Age],
		p.nationality [Nationality],
		a.movie_acted [Movie Acted], 
		sceneCounts	  [Number of Scenes Acted]
  FROM #person p 
  JOIN #actor  a			 ON p.person_id = a.person_id
  JOIN (SELECT a.actor_id, 
			   sceneCounts = COUNT(*)
		  FROM #actor		a
		  JOIN #actorScene	acts ON a.actor_id = acts.actor_id
		  JOIN #scene		s	 ON acts.scene_id = s.scene_id
		 GROUP BY
			   a.actor_id) X ON a.actor_id = X.actor_id



------------------------------LEFT JOIN----------------------------------------
--GIVE ME INFORMATION ABOUT PEOPLE WHO ARE NOT ACTORS
SELECT 'INFORMATION ABOUT PEOPLE WHO ARE NOT ACTORS'
SELECT	p.person_name [Name],
		p.age [Age],
		p.nationality [Nationality],
		ISNULL(a.movie_acted, 'NONE') [Movies Acted] 
  FROM #person		p
  LEFT JOIN 
	   #actor		a  ON p.person_id = a.person_id				
  LEFT JOIN 
	   #actorScene	acts ON a.actor_id = acts.actor_id
 WHERE acts.actor_id IS NULL

 ---------------------------------------TO CAPTURE CONVERSATIONS---------------------------
 SELECT 'CONVERSATIONS'
 DECLARE @actorID TABLE(
	actorID  INT,
	personID INT
 ); 
 INSERT @actorID
 SELECT	DISTINCT actor_id,person_id
   FROM #actor 

SELECT s.scene_id,
	   X.actor_id1,
	   X.Person1Name,
	   X.Person1Age,
	   X.actor_id2,
	   X.Person2Name,
	   X.Person2Age,
	   X.Person2Nationality,
	   X.conversation1,
	   s.scene_name
  FROM #actor a1
  JOIN(SELECT a.actorID,
			  c.actor_id1,
			  c.actor_id2,
			  c.conversation1,
			  c.scene_id,
			  p1.person_name [Person1Name],
			  p2.person_name [Person2Name],
			  p1.age [Person1Age],
			  p2.age [Person2Age],
			  p1.nationality [Person1Nationality],
			  p2.nationality [Person2Nationality] 
		 FROM @actorID		  a
		 JOIN #conversations  c  ON a.actorID = c.actor_id1
		 JOIN @actorID        a1 ON a1.actorID = c.actor_id2 
		 JOIN #person		  p1 ON a.personID = p1.person_id
		 JOIN #person		  p2 ON a1.personID = p2.person_id) X ON a1.actor_id = X.actorID 
  JOIN #scene													s ON X.scene_id = s.scene_id  
 ORDER BY
	   s.scene_id


	   select * from #actor
	   select * from #person
	   select * from #scene
	   select * from #conversations

-----------------------------PEOPLE INVOLVED IN SCENES------------------------------------
SELECT * 
  FROM #person p 
  JOIN #actor a ON p.person_id = a.person_id
  JOIN #actorScene acts ON a.actor_id = acts.actor_id
 ORDER BY
	   acts.scene_id, p.person_name

SELECT distinct *
  FROM #person p 
  JOIN #actor a ON p.person_id = a.person_id
  JOIN #actorScene acts ON a.actor_id = acts.actor_id
  JOIN #scene s ON acts.scene_id = s.scene_id
 ORDER BY 
	   s.scene_id

SELECT p.person_name, p2.person_name, * 
  FROM #person p
  JOIN #actor a ON p.person_id = a.person_id
  JOIN #conversations c ON a.actor_id = c.actor_id1
  JOIN #actor a1 ON a1.actor_id = c.actor_id2
  JOIN #person p2 ON a1.person_id = p2.person_id

SELECT DISTINCT p.person_name, s.scene_name
  FROM #person		p
  JOIN #actor		a		ON p.person_id = a.person_id
  JOIN #actorScene	acts	ON a.actor_id = acts.actor_id
  JOIN #scene		s		ON acts.scene_id = s.scene_id
 ORDER BY
	   p.person_name 

DROP TABLE #actor
DROP TABLE #scene
DROP TABLE #actorScene
DROP TABLE #conversations
DROP TABLE #person
ROLLBACK

--select * from sys.tables