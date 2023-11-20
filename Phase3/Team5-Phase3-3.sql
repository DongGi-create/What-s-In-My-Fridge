-- Type 1: A single-table query => Selection + Projection
-- Q1. �������� ���� ������� ���� �������� �ۼ��ð��� ���� ��ȸ
SELECT
	R.WRITE_TIME,
	R.TITLE
FROM
	RECIPE R
WHERE
	R.TITLE LIKE '%�����%';

-- Q2. ������ ������ �����̸鼭 1991�⵵�� �¾ ������ �̸��� ��������� ��ȸ
SELECT
	U.NAME,
	U.BIRTH
FROM
	USERS U
WHERE
	    U.sex = 'F'
	AND U.BIRTH BETWEEN TO_DATE('19910101', 'YYYYMMDD') AND TO_DATE('19911231', 'YYYYMMDD');


-- Type 2: Multi-way join with join predicates in WHERE
-- Q3. �������� ���� ���̰� �� �����ǿ� ���ƿ並 ���� ������ �̸��� ��ȸ
SELECT
	U.NAME
FROM
	RECIPE   R,
	USERS    U,
	FAVORITE F
WHERE
	    F.LIKE_USER_ID = U.USER_ID
	AND F.LIKE_RECIPE_ID = R.RECIPE_ID
	AND R.title LIKE '%����%';

-- Q4. �������� ���� ���̰� �� �����ǿ� ����� �� ������ �̸��� ������ ������ ��ȸ
SELECT
	U.NAME,
	U.SEX
FROM
	RECIPE   R,
	COMMENTS C,
	USERS    U
WHERE
	R.Title LIKE '%����%'
	AND C.RECIPE_ID = R.RECIPE_ID
	AND C.USER_ID = U.USER_ID;

-- Q5.��������� �丮�� �����Ǹ� �ۼ��� ������ �̸� ��ȸ
SELECT
	U.NAME
FROM
	USERS   U,
	CUISINE C,
	RECIPE  R
WHERE
	    U.USER_ID = R.WRITER_ID
	AND R.CUISINE_ID = C.CUISINE_ID
	AND C.CUISINE_NAME = '���������';
	
-- Q21. Ư�� ����ڰ� ������ �ִ� Ư�� ��ῡ ���� ������ ��ȸ
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
-- Q6. '��'�� ���� �� �����ǿ� �� ������ �� ����� �� ��ȸ
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
	AND R.TITLE LIKE '%��%'
GROUP BY
	U.SEX;


-- Type 4: Subquery
-- Q7.'user9'�� �����ϴ� ���̵� ���� ������ �� �������� �丮 �̸��� �������� ������ ��ȸ
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
	
-- Q8. ��� ���뿡 1�� ���� ����� �� ������ ���� ��ȸ
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
-- Q9. Recipe�� �� ���� �ۼ����� ���� User ��ȸ
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
	
-- Q10. ����� �ۼ��� User ���̵� ��ȸ
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
-- Q11. ��������信 �ʿ��� ��� ��ȸ
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
			AND CUISINE.CUISINE_NAME = '���������'
	);

-- Q12. RECIPE �Խù��� FAVORITE�� ����� ���� �ִ� ����� �� ���� ȸ���� id, �̸�, �̸����� ��ȸ�ϴ� ����
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
-- Q13. ���̴뺰 ���� �� ��ȸ
SELECT
	AGE_GROUP,
	COUNT(*) CNT
FROM
	(
		SELECT
			CASE
			    WHEN Age < 10              THEN
			        '9�� ����'
			    WHEN Age BETWEEN 10 AND 19 THEN
			        '10��'
			    WHEN Age BETWEEN 20 AND 29 THEN
			        '20��'
			    WHEN Age BETWEEN 30 AND 39 THEN
			        '30��'
			    WHEN Age BETWEEN 40 AND 49 THEN
			        '40��'
			    WHEN Age BETWEEN 50 AND 59 THEN
			        '50��'
			    WHEN Age >= 60             THEN
			        '60�� �̻�'
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
	
-- Q14. ������ �߿��� ��� �ۼ� ��, ���ƿ� ��� ���� ���� ���� ū ����� ���̵� ��ȸ
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
-- Q15.'user3'���� �����ϴ� ������ �̸�, �������, �ش� ������ ������ ����� �̸��� ��������� ���� ������������ ��ȸ
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

-- Q16. �丮 �̸��� ������� ���� �����ǿ� �ʿ��� ��� ����� ID�� ��� �̸��� �ߺ� ���� ��ȸ
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
	AND C.CATEGORY = '�ѽ�'
	AND C.CUISINE_NAME LIKE '%�����%'
ORDER BY
	REQUIRE.INGREDIENT_ID;

-- Type 9: Aggregation + multi-way join with join predicates + with GROUP BY + ORDER BY (e.g. TPC-H Q3)
-- Q17. ������ ������ ������ �ϸ�ũ ���� �ϸ�ũ ���� �������� �������� �����Ͽ� ��ȸ
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
	    I.INGREDIENT_NAME = '����'
	AND I.Ingredient_id = O.INGREDIENT_ID
	AND O.USER_ID = U.USER_ID
GROUP BY
	U.NAME
ORDER BY
	bookmark_cnt DESC;

-- Q18. �丮 �ð��� 1�ð� �̸��� �����ǿ� �� ������ �� ���ƿ��� ������ ���ƿ��� ������ ���� ������������ ��ȸ
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

-- TYPE 10: SET operation (UNION, SET DIFFERENCE, INTERSECT �� �� �ϳ�)�� Ȱ���� query
-- Q19. �ұݰ� ���� �� �� �ϳ��� �����ϰ� �ִ� ������ �̸��� ��ȸ
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
				    I.Ingredient_name = '�ұ�'
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
				    I.Ingredient_name = '����'
				AND I.Ingredient_id = O.Ingredient_id
				AND O.User_id = U.User_id
		)
	);
	
-- Q20. �������� ���� ���̰� �� �����Ǹ� �ۼ��ϰ� ���̸� �����ϰ� �ִ� ������ �̸��� ���� ���̵� ��ȸ
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
				AND R.Title LIKE '%����%'
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