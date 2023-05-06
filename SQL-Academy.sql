TASK 1
Вывести имена всех людей, которые есть в базе данных авиакомпаний
SELECT name
FROM passenger

TASK 2
Вывести названия всеx авиакомпаний
SELECT name
FROM Company

TASK 3
Вывести все рейсы, совершенные из Москвы
SELECT *
FROM Trip
WHERE town_from = 'Moscow'

TASK 4
Вывести имена людей, которые заканчиваются на "man"
SELECT name
FROM Passenger
WHERE name LIKE '% %man'

TASK 5
Вывести количество рейсов, совершенных на TU-134
SELECT COUNT(*) AS count
FROM TRIP
GROUP BY plane
HAVING plane = 'TU-134'

TASK 6
Какие компании совершали перелеты на Boeing
SELECT DISTINCT c.name
FROM Company c
	JOIN Trip t ON c.id = t.company
WHERE t.plane = 'Boeing'

TASK 7
Вывести все названия самолётов, на которых можно улететь в Москву (Moscow)
SELECT DISTINCT plane
FROM trip
WHERE town_to = 'Moscow'

TASK 8
В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?
SELECT town_to,
	TIMEDIFF(time_in, time_out) AS flight_time
FROM trip
WHERE town_from = 'Paris'

TASK 9
Какие компании организуют перелеты из Владивостока (Vladivostok)?
SELECT c.name
FROM Company c
	JOIN Trip t ON c.id = t.company
WHERE t.town_from = 'Vladivostok'

TASK 10
Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г.
SELECT *
FROM Trip
WHERE time_out BETWEEN '1900-01-01T10:00' AND '1900-01-01T14:00'

TASK 11
Вывести пассажиров с самым длинным именем
SELECT name
FROM Passenger
WHERE LENGTH(name) = (
		SELECT MAX(LENGTH(name))
		from Passenger
	)

TASK 12
Вывести id и количество пассажиров для всех прошедших полётов
SELECT trip,
	COUNT(passenger) as count
FROM Pass_in_trip
GROUP BY trip

TASK 13
Вывести имена людей, у которых есть полный тёзка среди пассажиров
SELECT DISTINCT name
FROM Passenger
WHERE name in (
		SELECT name
		FROM Passenger
		GROUP BY name
		HAVING COUNT(name) > 1
	)

TASK 14
В какие города летал Bruce Willis
SELECT t.town_to
FROM Trip t
	JOIN Pass_in_trip pt ON pt.trip = t.id
	JOIN Passenger p ON p.id = pt.passenger
WHERE p.name = 'Bruce Willis'

TASK 15
Выведите дату и время прилёта пассажира Стив Мартин (Steve Martin) в Лондон (London)
SELECT time_in
FROM Trip t
	JOIN Pass_in_trip pt ON pt.trip = t.id
	JOIN Passenger p ON p.id = pt.passenger
WHERE p.name = 'Steve Martin'
	AND town_to = 'London'

TASK 16
Вывести отсортированный по количеству перелетов (по убыванию) и имени (по возрастанию) список пассажиров, совершивших хотя бы 1 полет.
SELECT ps.name,
	COUNT(*) as count
FROM passenger ps
	JOIN Pass_in_trip pt ON ps.id = pt.passenger
GROUP BY ps.name
ORDER BY count DESC,
	ps.name ASC
	
TASK 17
Определить, сколько потратил в 2005 году каждый из членов семьи. В результирующей выборке не выводите тех членов семьи, которые ничего не потратили.
SELECT f.member_name,
	f.status,
	SUM(p.amount * p.unit_price) AS costs
FROM FamilyMembers f
	JOIN Payments p ON f.member_id = p.family_member
WHERE YEAR(p.date) = 2005
GROUP BY f.member_name,
	f.status

TASK 18
Узнать, кто старше всех в семьe
SELECT member_name
FROM FamilyMembers
WHERE birthday = (
		SELECT min(birthday)
		FROM FamilyMembers
	)

TASK 19
Определить, кто из членов семьи покупал картошку (potato)
SELECT DISTINCT status
FROM FamilyMembers f
	JOIN Payments p on p.family_member = f.member_id
	JOIN Goods god on p.good = god.good_id
WHERE god.good_name = 'potato'

TASK 20
Сколько и кто из семьи потратил на развлечения (entertainment). Вывести статус в семье, имя, сумму
SELECT fm.status,
	fm.member_name,
	SUM(p.amount * p.unit_price) AS costs
FROM FamilyMembers fm
	JOIN Payments p ON fm.member_id = p.family_member
	JOIN Goods g ON g.good_id = p.good
	JOIN GoodTypes gt ON gt.good_type_id = g.type
WHERE gt.good_type_name = 'entertainment'
GROUP BY family_member

TASK 21
Определить товары, которые покупали более 1 раза
SELECT good_name
FROM Goods g
	JOIN Payments p ON g.good_id = p.good
GROUP BY p.good
HAVING COUNT(amount) > 1 #(SELECT amount FROM Payments 
	#GROUP BY good
	#HAVING COUNT(amount) > 1)

TASK 22
Найти имена всех матерей (mother)
SELECT member_name
FROM FamilyMembers
WHERE status = 'mother'

TASK 23
Найдите самый дорогой деликатес (delicacies) и выведите его цену
SELECT g.good_name,
	pt.unit_price
FROM Goods g
	JOIN GoodTypes gt ON g.type = gt.good_type_id
	JOIN Payments pt ON pt.good = g.good_id
WHERE gt.good_type_name = 'delicacies'
ORDER BY pt.unit_price DESC
LIMIT 1

TASK 24
Определить кто и сколько потратил в июне 2005
SELECT member_name,
	SUM(amount * unit_price) AS costs
FROM FamilyMembers f
	JOIN Payments p ON f.member_id = p.family_member
WHERE p.date LIKE '2005-06%'
GROUP BY member_name

TASK 25
Определить, какие товары не покупались в 2005 году
SELECT good_name
FROM Goods
	LEFT JOIN Payments ON Goods.good_id = Payments.good
	AND YEAR(Payments.date) = 2005
WHERE Payments.good IS NULL
GROUP BY good_id;

TASK 26
Определить группы товаров, которые не приобретались в 2005 году
SELECT gt.good_type_name
FROM GoodTypes gt
WHERE gt.good_type_name NOT IN (
		SELECT gt.good_type_name
		FROM GoodTypes gt
			JOIN Goods g ON g.type = gt.good_type_id
			JOIN Payments pt ON g.good_id = pt.good
		WHERE YEAR(pt.date) = 2005
		GROUP BY gt.good_type_name
	)

TASK 27
Узнать, сколько потрачено на каждую из групп товаров в 2005 году. Вывести название группы и сумму
SELECT gt.good_type_name,
	SUM(pt.unit_price * pt.amount) AS costs
FROM GoodTypes gt
	JOIN Goods g ON gt.good_type_id = g.type
	JOIN Payments pt ON pt.good = g.good_id
WHERE YEAR(pt.date) = 2005
GROUP BY gt.good_type_name

TASK 28
Сколько рейсов совершили авиакомпании из Ростова (Rostov) в Москву (Moscow) ?
SELECT COUNT(*) AS count
FROM Trip
WHERE town_from = 'Rostov'
	AND town_to = 'Moscow'

TASK 29
Выведите имена пассажиров улетевших в Москву (Moscow) на самолете TU-134
SELECT DISTINCT name
FROM Passenger p
	JOIN Pass_in_trip pt ON p.id = pt.passenger
	JOIN Trip tr ON tr.id = pt.trip
WHERE tr.town_to = 'Moscow'
	AND tr.plane = 'TU-134'

TASK 30
Выведите нагруженность (число пассажиров) каждого рейса (trip). Результат вывести в отсортированном виде по убыванию нагруженности.
SELECT trip,
	COUNT(passenger) as count
FROM Pass_in_trip
GROUP BY trip
ORDER BY count DESC

TASK 31
Вывести всех членов семьи с фамилией Quincey.
SELECT *
FROM FamilyMembers
WHERE member_name LIKE '% Quincey'

TASK 32
Вывести средний возраст людей (в годах), хранящихся в базе данных. Результат округлите до целого в меньшую сторону.
SELECT FLOOR(AVG(2022 - YEAR(birthday))) AS age
FROM FamilyMembers

TASK 33
Найдите среднюю стоимость икры. В базе данных хранятся данные о покупках красной (red caviar) и черной икры (black caviar).
SELECT AVG(unit_price) AS cost
FROM Payments pt
	JOIN Goods g ON pt.good = g.good_id
WHERE g.good_name LIKE '% caviar'

TASK 34
Сколько всего 10-ых классов
SELECT COUNT(*) AS count
FROM Class
WHERE name LIKE '10%'

TASK 35
Сколько различных кабинетов школы использовались 2.09.2019 в образовательных целях ?
SELECT COUNT(DISTINCT classroom) AS count
FROM Schedule
WHERE date = '2019.09.02'

TASK 36
Выведите информацию об обучающихся живущих на улице Пушкина (ul. Pushkina)?
SELECT *
FROM Student
WHERE address LIKE 'ul. Pushkina%'

TASK 37
Сколько лет самому молодому обучающемуся ?
SELECT ROUND(MIN(DATEDIFF(NOW(), birthday) / 365)) AS year
FROM Student;

TASK 38
Сколько Анн (Anna) учится в школе ?
SELECT COUNT(*) AS count
FROM Student
WHERE first_name LIKE 'Anna'

TASK 39
Выведите название предметов, которые преподает Ромашкин П.П. (Romashkin P.P.) ?
SELECT sb.name as subjects
FROM Schedule sc
	JOIN Teacher t ON sc.teacher = t.id
	JOIN Subject sb ON sc.subject = sb.id
WHERE t.last_name LIKE 'Romashkin'

TASK 40
Выведите название предметов, которые преподает Ромашкин П.П. (Romashkin P.P.) ?
SELECT sb.name as subjects
FROM Schedule sc
	JOIN Teacher t ON sc.teacher = t.id
	JOIN Subject sb ON sc.subject = sb.id
WHERE t.last_name LIKE 'Romashkin'

TASK 41
Во сколько начинается 4-ый учебный предмет по расписанию ?
SELECT start_pair
FROM Timepair t
WHERE id = 4

TASK 42
Сколько времени обучающийся будет находиться в школе, учась со 2-го по 4-ый уч. предмет ?
SELECT DISTINCT TIMEDIFF(
		(
			SELECT end_pair
			FROM Timepair
			WHERE id = 4
		),
		(
			SELECT start_pair
			FROM Timepair
			WHERE id = 2
		)
	) as time
FROM Timepair

TASK 43
Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). Отcортируйте преподавателей по фамилии.
SELECT last_name
FROM Teacher t
	JOIN Schedule sc ON t.id = sc.teacher
	JOIN Subject s ON s.id = sc.subject
WHERE s.name = 'Physical Culture'
ORDER by last_name

TASK 44
Найдите максимальный возраст (колич. лет) среди обучающихся 10 классов ?
SELECT ROUND(MAX((DATEDIFF(NOW(), birthday) / 365))) AS max_year
FROM Student st
	JOIN Student_in_class sc ON st.id = sc.student
	JOIN Class c ON sc.class = c.id
WHERE c.name LIKE '10%'

TASK 45
Какие кабинеты чаще всего использовались для проведения занятий? Выведите те, которые использовались максимальное количество раз.
SELECT classroom
FROM Schedule
GROUP BY classroom
HAVING COUNT(classroom) = max(
		(
			SELECT COUNT(classroom) as cnt
			FROM Schedule
			GROUP BY classroom
			ORDER BY cnt DESC
			LIMIT 1
		)
	)
	
TASK 46
В каких классах введет занятия преподаватель "Krauze" ?
SELECT DISTINCT cls.name
FROM Class cls
	JOIN Schedule sch on cls.id = sch.class
	JOIN Teacher t on t.id = sch.teacher
WHERE t.last_name LIKE 'Krauze'

TASK 47
Сколько занятий провел Krauze 30 августа 2019 г.?
SELECT count(1) AS count
FROM Schedule sch
	JOIN Teacher t ON sch.teacher = t.id
WHERE t.last_name = 'Krauze'
	AND sch.date = '2019.08.30'
	
TASK 48
Выведите заполненность классов в порядке убывания
SELECT name,
	COUNT(1) as count
FROM Class cls
	JOIN Student_in_class st On cls.id = st.class
GROUP BY name
ORDER BY count DESC

TASK 49
Какой процент обучающихся учится в 10 A классе ?
SELECT (
		COUNT(*) * 100 /(
			SELECT COUNT(Student.id) as count
			FROM Student
				JOIN Student_in_class ON Student.id = Student_in_class.student
		)
	) AS percent
FROM Student_in_class
	JOIN Class ON Class.id = Student_in_class.class
	AND name = '10 A';
	
TASK 50
Какой процент обучающихся родился в 2000 году? Результат округлить до целого в меньшую сторону.
SELECT FLOOR(
		(
			COUNT(*) * 100 /(
				SELECT COUNT(Student.id) as count
				FROM Student
					JOIN Student_in_class ON Student.id = Student_in_class.student
			)
		)
	) AS percent
FROM Student
WHERE YEAR(birthday) = 2000;

TASK 51
Добавьте товар с именем "Cheese" и типом "food" в список товаров (Goods).
INSERT INTO Goods
SELECT COUNT(*) + 1,
	'Cheese',
	2
FROM Goods

TASK 52
Добавьте в список типов товаров (GoodTypes) новый тип "auto".
INSERT INTO GoodTypes
SELECT COUNT(*) + 1,
	'auto'
FROM GoodTypes;

TASK 53
Измените имя "Andie Quincey" на новое "Andie Anthony".
UPDATE FamilyMembers
SET member_name = 'Andie Anthony'
WHERE member_name = 'Andie Quincey'

TASK 54
Удалить всех членов семьи с фамилией "Quincey".
DELETE FROM FamilyMembers
WHERE member_name LIKE '% Quincey'

TASK 55
Удалить компании, совершившие наименьшее количество рейсов.

TASK 56
Удалить все перелеты, совершенные из Москвы (Moscow).
DELETE FROM Trip
WHERE town_from = 'Moscow'

TASK 57
Перенести расписание всех занятий на 30 мин. вперед.
UPDATE Timepair
SET start_pair = DATE_ADD(start_pair, INTERVAL 30 MINUTE),
	end_pair = DATE_ADD(end_pair, INTERVAL 30 MINUTE);
	
TASK 58
Добавить отзыв с рейтингом 5 на жилье, находящиеся по адресу "11218, Friel Place, New York", от имени "George Clooney"
INSERT INTO Reviews
SELECT COUNT(id) + 1,
	2,
	5
FROM Reviews

TASK 59
Вывести пользователей,указавших Белорусский номер телефона ? Телефонный код Белоруссии +375.
SELECT *
FROM Users
WHERE phone_number LIKE '+375%'

TASK 61
Выведите список комнат, которые были зарезервированы в течение 12 недели 2020 года.
SELECT Rooms.*
FROM Rooms
	JOIN Reservations ON Rooms.id = Reservations.room_id
	AND YEAR(start_date) = 2020
	AND YEAR(end_date) = 2020
WHERE WEEK(start_date, 1) = 12
	OR WEEK(end_date, 1) = 12;
	
TASK 62
Вывести в порядке убывания популярности доменные имена 2-го уровня, используемые пользователями для электронной почты. Полученный результат необходимо дополнительно отсортировать по возрастанию названий доменных имён.
SELECT SUBSTRING_INDEX(email, '@', -1) as domain,
	COUNT(*) AS count
FROM Users
GROUP BY domain
ORDER BY count DESC,
	domain ASC
	
TASK 63
Выведите отсортированный список (по возрастанию) фамилий и имен студентов в виде Фамилия.И.
SELECT CONCAT(last_name, '.', LEFT(first_name, 1), '.') AS name
FROM Student
ORDER BY name ASC

TASK 64
Вывести количество бронирований по каждому месяцу каждого года, в которых было хотя бы 1 бронирование. Результат отсортируйте в порядке возрастания даты бронирования.
SELECT YEAR(start_date) as year,
	MONTH(start_date) as month,
	COUNT(*) as amount
FROM Reservations
GROUP BY year,
	month
ORDER BY year ASC,
	month ASC

TASK 65
Необходимо вывести рейтинг для комнат, которые хоть раз арендовали, как среднее значение рейтинга отзывов округленное до целого вниз.
SELECT res.room_id,
	FLOOR(AVG(rating)) as rating
FROM Reservations res
	JOIN Reviews r ON res.id = r.reservation_id
GROUP BY res.room_id


