-- Type 1: A single-table query => Selection + Projection
-- Q1. 레시피의 제목에 비빔밥이 들어가는 레시피의 작성시간과 제목 조회
SELECT
	R.WRITE_TIME,
	R.TITLE
FROM
	RECIPE R
WHERE
	R.TITLE LIKE '%비빔밥%';

-- Q2. 유저의 성별이 여자이면서 1991년도에 태어난 유저의 이름과 생년월일을 조회
SELECT
	U.NAME,
	U.BIRTH
FROM
	USERS U
WHERE
	    U.sex = 'F'
	AND U.BIRTH BETWEEN TO_DATE('19910101', 'YYYYMMDD') AND TO_DATE('19911231', 'YYYYMMDD');


-- Type 2: Multi-way join with join predicates in WHERE
-- Q3. 레시피의 제목에 오이가 들어간 레시피에 좋아요를 누른 유저의 이름을 조회
SELECT
	U.NAME
FROM
	RECIPE   R,
	USERS    U,
	FAVORITE F
WHERE
	    F.LIKE_USER_ID = U.USER_ID
	AND F.LIKE_RECIPE_ID = R.RECIPE_ID
	AND R.title LIKE '%오이%';

-- Q4. 레시피의 제목에 오이가 들어간 레시피에 댓글을 단 유저의 이름과 유저의 성별을 조회
SELECT
	U.NAME,
	U.SEX
FROM
	RECIPE   R,
	COMMENTS C,
	USERS    U
WHERE
	R.Title LIKE '%오이%'
	AND C.RECIPE_ID = R.RECIPE_ID
	AND C.USER_ID = U.USER_ID;

-- Q5.나물비빔밥 요리의 레시피를 작성한 유저의 이름 조회
SELECT
	U.NAME
FROM
	USERS   U,
	CUISINE C,
	RECIPE  R
WHERE
	    U.USER_ID = R.WRITER_ID
	AND R.CUISINE_ID = C.CUISINE_ID
	AND C.CUISINE_NAME = '나물비빔밥';
	
-- Q21. 특정 사용자가 가지고 있는 특정 재료에 대한 정보를 조회
SELECT 
	O.* 
FROM 
	USERS U, 
	OWN O, 
	INGREDIENT I 
WHERE 
		U.USER_ID = O.USER_ID 
	AND O.INGREDIENT_ID = I.INGREDIENT_ID 
	AND U.USER_ID = ? 
	AND O.INGREDIENT_ID = ?

-- Type 3: Aggregation + multi-way join with join predicates + with GROUP BY (e.g. TPC-H Q5)
-- Q6. '밥'이 제목에 들어간 레시피에 각 성별이 단 댓글의 수 조회
SELECT
	U.SEX,
	COUNT(C.COMMENT_ID) AS COMMENT_CNT
FROM
	USERS    U,
	COMMENTS C,
	RECIPE   R
WHERE
	    U.USER_ID = C.USER_ID
	AND R.RECIPE_ID = C.RECIPE_ID
	AND R.TITLE LIKE '%밥%'
GROUP BY
	U.SEX;


-- Type 4: Subquery
-- Q7.'user9'로 시작하는 아이디를 가진 유저가 쓴 레시피의 요리 이름과 레시피의 제목을 조회
SELECT
	(
		SELECT
			C.CUISINE_NAME
		FROM
			CUISINE C
		WHERE
			R.CUISINE_ID = C.CUISINE_ID
	) AS CUISINE_NAME,
	R.TITLE
FROM
	RECIPE R
WHERE
	R.WRITER_ID LIKE 'user9%';
	
-- Q8. 댓글 내용에 1이 들어가는 사람이 쓴 레시피 제목 조회
SELECT
	R.Title
FROM
	RECIPE R
WHERE
	R.Writer_id IN (
		SELECT
			U.user_id
		FROM
			COMMENTS C, USERS    U
		WHERE
			c.comment_content LIKE '%1%'
			AND c.user_id = u.user_id
	);

-- Type 5: EXISTS
-- Q9. Recipe를 한 번도 작성하지 않은 User 조회
SELECT
	U.USER_ID
FROM
	USERS U
WHERE
	NOT EXISTS (
		SELECT
			*
		FROM
			RECIPE R
		WHERE
			R.WRITER_ID = U.USER_ID
	)
ORDER BY
	USER_ID;
	
-- Q10. 댓글을 작성한 User 아이디 조회
SELECT
	U.User_id
FROM
	USERS U
WHERE
	EXISTS (
		SELECT
			*
		FROM
			COMMENTS C
		WHERE
			c.User_id = U.User_id
	);
	
-- Type 6: Selection + Projection + IN predicates
-- Q11. 나물비빔밥에 필요한 재료 조회
SELECT
	I.INGREDIENT_NAME
FROM
	INGREDIENT I
WHERE
	I.INGREDIENT_ID IN (
		SELECT
			REQUIRE.INGREDIENT_ID
		FROM
			REQUIRE, RECIPE, CUISINE
		WHERE
			    REQUIRE.RECIPE_ID = RECIPE.RECIPE_ID
			AND RECIPE.CUISINE_ID = CUISINE.CUISINE_ID
			AND CUISINE.CUISINE_NAME = '나물비빔밥'
	);

-- Q12. RECIPE 게시물에 FAVORITE을 등록한 적이 있는 사람들 중 남자 회원의 id, 이름, 이메일을 조회하는 쿼리
SELECT
	U.User_ID,
	U.name,
	U.email
FROM
	USERS U
WHERE
	    U.Sex = 'M'
	AND U.User_ID IN (
		SELECT
			F.Like_User_ID
		FROM
			FAVORITE F
	);

-- Type 7: In-line View
-- Q13. 나이대별 유저 수 조회
SELECT
	AGE_GROUP,
	COUNT(*) CNT
FROM
	(
		SELECT
			CASE
			    WHEN Age < 10              THEN
			        '9세 이하'
			    WHEN Age BETWEEN 10 AND 19 THEN
			        '10대'
			    WHEN Age BETWEEN 20 AND 29 THEN
			        '20대'
			    WHEN Age BETWEEN 30 AND 39 THEN
			        '30대'
			    WHEN Age BETWEEN 40 AND 49 THEN
			        '40대'
			    WHEN Age BETWEEN 50 AND 59 THEN
			        '50대'
			    WHEN Age >= 60             THEN
			        '60대 이상'
			END AS AGE_GROUP
		FROM
			(
				SELECT
					User_ID,
					Sex,
					Birth,
					TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE),
					                     BIRTH) / 12) AS Age
				FROM
					USERS
			)
	)
GROUP BY
	AGE_GROUP
ORDER BY
	CNT DESC;
	
-- Q14. 유저들 중에서 댓글 작성 수, 좋아요 등록 수의 합이 가장 큰 사람의 아이디 조회
SELECT
	id
FROM
	(
		SELECT
			SUM(Ccnt + Fcnt) AS S,
			T1.id
		FROM
			     (
				SELECT
					COUNT(*)  AS Ccnt,
					C.User_id AS id
				FROM
					COMMENTS C
				GROUP BY
					C.User_id
			) T1
			JOIN (
				SELECT
					COUNT(*)       AS Fcnt,
					F.Like_user_id AS id
				FROM
					FAVORITE F
				GROUP BY
					F.Like_user_id
			) T2 ON T1.id = T2.id
		GROUP BY
			T1.id
		ORDER BY
			S DESC
	)
WHERE
	ROWNUM = 1;
	
-- Type 8: Multi-way join with join predicates in WHERE + ORDER BY
-- Q15.'user3'으로 시작하는 유저의 이름, 생년월일, 해당 유저가 보유한 재료의 이름을 생년월일을 기준 오름차순으로 조회
SELECT
	U.NAME,
	U.BIRTH,
	I.INGREDIENT_NAME
FROM
	USERS      U,
	OWN        O,
	INGREDIENT I
WHERE
	    U.USER_ID = O.USER_ID
	AND I.INGREDIENT_ID = O.INGREDIENT_ID
	AND U.User_ID LIKE 'user3%'
ORDER BY
	U.BIRTH;

-- Q16. 요리 이름에 비빔밥이 들어가는 레시피에 필요한 모든 재료의 ID와 재료 이름을 중복 없이 조회
SELECT DISTINCT
	REQUIRE.INGREDIENT_ID,
	(
		SELECT
			INGREDIENT.INGREDIENT_NAME
		FROM
			INGREDIENT
		WHERE
			INGREDIENT.INGREDIENT_ID = REQUIRE.INGREDIENT_ID
	) AS INGREDIENT_NAME
FROM
	CUISINE C,
	RECIPE,
	REQUIRE
WHERE
	    C.CUISINE_ID = RECIPE.CUISINE_ID
	AND RECIPE.RECIPE_ID = REQUIRE.RECIPE_ID
	AND C.CATEGORY = '한식'
	AND C.CUISINE_NAME LIKE '%비빔밥%'
ORDER BY
	REQUIRE.INGREDIENT_ID;

-- Type 9: Aggregation + multi-way join with join predicates + with GROUP BY + ORDER BY (e.g. TPC-H Q3)
-- Q17. 생수을 소유한 유저의 북마크 수를 북마크 수를 기준으로 내림차순 정렬하여 조회
SELECT
	U.NAME,
	COUNT(
		CASE
		    WHEN B.BOOKMARK_USER_ID = U.USER_ID THEN
		        1
		END
	) AS bookmark_cnt
FROM
	Users      U,
	BOOKMARK   B,
	OWN        O,
	INGREDIENT I
WHERE
	    I.INGREDIENT_NAME = '생수'
	AND I.Ingredient_id = O.INGREDIENT_ID
	AND O.USER_ID = U.USER_ID
GROUP BY
	U.NAME
ORDER BY
	bookmark_cnt DESC;

-- Q18. 요리 시간이 1시간 미만인 레시피에 각 성별이 단 좋아요의 개수를 좋아요의 개수를 기준 오름차순으로 조회
SELECT
	U.SEX,
	COUNT(F.LIKE_USER_ID) AS LIKE_COUNT
FROM
	USERS    U,
	FAVORITE F,
	RECIPE   R
WHERE
	    U.USER_ID = F.LIKE_USER_ID
	AND R.RECIPE_ID = F.LIKE_RECIPE_ID
	AND R.COOKING_TIME < INTERVAL '1' HOUR
GROUP BY
	U.SEX
ORDER BY
	LIKE_COUNT;

-- TYPE 10: SET operation (UNION, SET DIFFERENCE, INTERSECT 등 중 하나)를 활용한 query
-- Q19. 소금과 생수 둘 중 하나를 소유하고 있는 유저의 이름을 조회
SELECT
	U.Name
FROM
	Users U
WHERE
	U.User_id IN (
		(
			SELECT
				U.User_id
			FROM
				USERS      U, INGREDIENT I, OWN        O
			WHERE
				    I.Ingredient_name = '소금'
				AND I.Ingredient_id = O.Ingredient_id
				AND O.User_id = U.User_id
		)
		UNION
		(
			SELECT
				U.User_id
			FROM
				USERS      U, INGREDIENT I, OWN        O
			WHERE
				    I.Ingredient_name = '생수'
				AND I.Ingredient_id = O.Ingredient_id
				AND O.User_id = U.User_id
		)
	);
	
-- Q20. 레시피의 제목에 오이가 들어간 레시피를 작성하고 오이를 소유하고 있는 유저의 이름과 유저 아이디를 조회
SELECT
	U.NAME,
	U.User_id
FROM
	USERS U
WHERE
	U.User_id IN (
		(
			SELECT
				U.User_id
			FROM
				RECIPE R
			WHERE
				    R.Writer_id = U.User_id
				AND R.Title LIKE '%오이%'
		)
		INTERSECT
		(
			SELECT
				U.User_id
			FROM
				OWN O
			WHERE
				O.User_id = U.User_id
		)
	);