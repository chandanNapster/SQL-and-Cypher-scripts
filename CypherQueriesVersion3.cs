//Movie node 
create(WizardOfOz:Movie{ title: "The Wizard of Oz", released: 1939})
//Person nodes 
create(Chandan:Person{
name: "Chandan",
						age: 29,
						nationality: "INDIAN"})
create(Dorthy:Person{
name: "Dorthy",
						age: 13,
						nationality: "AMERICAN"})
create(Scarecrow:Person{
name: "Scarecrow",
						  age: 20,
						  nationality: "BRITISH"})
create(Lion:Person{ name: "Lion",age: 10,nationality: "AFRICAN"})
create(Tinman:Person{ name: "Tinman",age: 40,nationality: "JAPANESE"})
create(Wizard:Person{ name: "Wizard",age: 100,nationality: "NEVERLAND"})
create(Alex:Person{ name: "Alex",age: 22,nationality: "BRITISH"})
create(Jeff:Person{ name: "Jeff",age: 43,nationality: "FRENCH"})
create(Sam:Person{ name: "Sam",age: 54,nationality: "GERMAN"})
create(Rohan:Person{ name: "Rohan",age: 12,nationality: "INDIAN"})
create(Emily:Person{ name: "Emily",age: 10,nationality: "AUSTRALIAN"})

//acted in edges for actors
create
    (Dorthy)-[:ACTED_IN]->(WizardOfOz),
    (Scarecrow)-[:ACTED_IN]->(WizardOfOz),
    (Lion)-[:ACTED_IN]->(WizardOfOz),
    (Tinman)-[:ACTED_IN]->(WizardOfOz),
    (Wizard)-[:ACTED_IN]->

(WizardOfOz)

//create edges for non actors 
create
(Chandan) -[:KNOW_ABOUT{hasWatched:"FALSE"}]->(WizardOfOz),
	(Alex) -[:KNOW_ABOUT{hasWatched:"TRUE"}]->(WizardOfOz),
	(Jeff) -[:KNOW_ABOUT{hasWatched:"TRUE"}]->(WizardOfOz),
	(Sam) -[:KNOW_ABOUT{hasWatched:"TRUE"}]->(WizardOfOz),
	(Rohan) -[:KNOW_ABOUT{hasWatched:"FALSE"}]->(WizardOfOz),
	(Emily) -[:KNOW_ABOUT{hasWatched:"TRUE"}]->WizardOfOz)

//create edges for friends
create
    (Chandan)-[:IS_FREIND_OF]->(Alex),
	(Alex)-[:IS_FREIND_OF]->(Chandan),
	(Jeff)-[:IS_FREIND_OF]->(Sam),
	(Rohan)-[:IS_FREIND_OF]->(Emily),
	(Emily)-[:IS_FREIND_OF]->

(Alex)

//conversation edges
create
(Lion)-[:CONVERSED_WITH{name:"hello", content:"Hello how was your weekend"}]->(Dorthy),
    (Wizard)-[:CONVERSED_WITH{name:"nice", content:"Nice day?"}]->(Dorthy),
    (Dorthy)-[:CONVERSED_WITH{name:"How", content:"How are you?"}]->(Scarecrow),
    (Dorthy)-[:CONVERSED_WITH{name:"It", content:"It was boring"}]->(Lion),
    (Tinman)-[:CONVERSED_WITH{name:"Good", content:"Good day to you sir"}]->(Lion),
    (Scarecrow)-[:CONVERSED_WITH{name:"Hi", content:"Hi"}]->

(Tinman)

//scene nodes
create(FIGHT:Scene{ name: "Fight",date: "1938-05-15"})
create(DREAM:Scene{ name: "Dream",date: "1938-05-24"})
create(INTHEMORNING:Scene{ name: "In the morning",date: "1938-05-30"})
create(SUNSET:Scene{ name: "Sunset",date: "1938-06-11"})
create(BEACH:Scene{ name: "Beach",date: "1938-07-18"})
	
//Scenes relations
create
    (Dorthy) -[:WAS_IN]-> (FIGHT),
	(Dorthy) -[:WAS_IN]-> (BEACH),
	(Dorthy) -[:WAS_IN]-> (INTHEMORNING),
	(Dorthy) -[:WAS_IN]-> (SUNSET),
	(Lion) -[:WAS_IN]-> (FIGHT),
	(Lion) -[:WAS_IN]-> (INTHEMORNING),
	(Scarecrow) -[:WAS_IN]-> (BEACH),
	(Scarecrow) -[:WAS_IN]-> (DREAM),
	(Scarecrow) -[:WAS_IN]-> (FIGHT),
	(Scarecrow) -[:WAS_IN]-> (INTHEMORNING),
	(Tinman) -[:WAS_IN]-> (FIGHT),
	(Tinman) -[:WAS_IN]-> (INTHEMORNING),
	(Wizard) -[:WAS_IN]-> (FIGHT),
	(Wizard) -[:WAS_IN]-> (INTHEMORNING)
	
	
	
----------------------------------------QUERY FOR DELTEING ALL NODES AND RELATIONSHIPS IN A DATABASE----------------------------------------------------
--To delete all nodes
match(n) detach delete n 

--To look at the schema
 call db.schema 

--------------------------------------------------------------------------------------------------------------------------------------------------------

Query equivalent to select * from

match(n) return 

match(m:Person) return count(m)

//people who have acted in movie
match(m:Movie)<-[a: ACTED_IN]-(p:Person)
return m,

p

match(m:Movie)<-[:ACTED_IN]-(p:Person)-[:WAS_IN]->(s:Scene) 

where m.title = "The Wizard of Oz"
	  AND p.age >=10 
      AND p.age<50 
      OR p.name = "Dorthy"
return m, s, p

match(m:Movie)<-[ACTED_IN]-(p:Person)-[:WAS_IN]->(s:Scene) 

where m.title = "The Wizard of Oz"
	  AND s.name = "Fight"
return m, s, p

match(m:Movie)<-[ACTED_IN]-(p:Person)-[:WAS_IN]->(s:Scene) 

where m.title = "The Wizard of Oz"
	  AND s.name<> "Fight"
return m, s, p

:play https://guides.neo4j.com/got

//filtering on relations
match(m:Movie)<-[a: ACTED_IN]-(p:Person)-[c: CONVERSED_WITH]->(s:Person)

where c.content = "Nice day?" 
return m, p, s

//execution plans
explain
match(m:Movie)<-[a: ACTED_IN]-(p:Person)-[:WAS_IN]->(s:Scene) 

where m.title = "The Wizard of Oz"
    //  AND a.content contains "Good day to you sir"
return m, p, s

//people who havent watched the movie
match (p:Person)-[k: KNOW_ABOUT]->(m:Movie)

where k.hasWatched = "FALSE"
return p, m