use northwind; 

select * from orders; 

select * from orders
order by rand()
limit 10; 

create database trials;
CREATE TABLE posts (
  user_id INT,
  post_id INT,
  post_content TEXT,
  post_date DATETIME,
  difference VARCHAR(50)
);

INSERT INTO posts (user_id, post_id, post_content, post_date, difference) VALUES
  (151652, 111766, "it's always winter, but never Christmas.", '2021-12-01 11:00:00', NULL),
  (661093, 442560, "Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then class 6-10. Another day that's gonna fly by. I miss my girlfriend", '2021-09-08 10:00:00', NULL),
  (661093, 624356, "Happy valentines!", '2021-02-14 00:00:00', NULL),
  (151652, 599415, "Need a hug", '2021-01-28 00:00:00', NULL),
  (178425, 157336, "I'm so done with these restrictions - I want to travel!!!", '2021-03-24 11:00:00', NULL),
  (423967, 784254, "Just going to cry myself to sleep after watching Marley and Me.", '2021-05-05 00:00:00', NULL),
  (151325, 613451, "Happy new year all my friends!", '2022-01-01 11:00:00', NULL),
  (151325, 987562, "The global surface temperature for June 2022 was the sixth-highest in the 143-year record. This is definitely global warming happening.", '2022-07-01 10:00:00', NULL),
  (661093, 674356, "Can't wait to start my freshman year - super excited!", '2021-08-18 10:00:00', NULL),
  (151325, 451464, "Garage sale this Saturday 1 PM. All welcome to check out!", '2021-10-25 10:00:00', NULL),
  (151652, 994156, "Does anyone have an extra iPhone charger to sell?", '2021-04-01 10:00:00', NULL);

select * from posts
where user_id = 151325; 

SELECT user_id, DATEDIFF(MAX(CAST(post_date AS DATE)), MIN(CAST(post_date AS DATE))) AS days_between
FROM posts
WHERE YEAR(post_date) = 2021
GROUP BY user_id
HAVING COUNT(DISTINCT DATE(post_date)) > 1
ORDER BY user_id;