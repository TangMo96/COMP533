-- 1 Functions
-- 1.
use A5;
-- use database A5
drop function if exists numProductsAtEvent;
DELIMITER //
CREATE FUNCTION numProductsAtEvent(id int)
	RETURNS int
  	BEGIN  
		if (select count(*) from sale where sale.eventId = id) = 0 then return -1;
			-- If there is no event with the specified eventId, return -1.
		else return (select count(*) from sale where sale.eventId = id);
		end if;
END //
DELIMITER;

select numProductsAtEvent(3);
-- 40

--2.
drop view if exists unique;
create view unique as select distinct xtraCode as ccode from xtra;
drop function if exists fractionXtra;

DELIMITER //
CREATE FUNCTION fractionXtra(id int)
	RETURNS decimal(10, 3)
-- FractionXtra should take an eventId as an argument and return a decimal,
	BEGIN
		declare up int;
		declare down int;
		set up = (select count(*) from sale, unique where sale.productCode = unique.ccode and sale.eventId = id);
	    set down = (select count(*) from sale, xtra where sale.productCode = xtra.productCode and sale.eventId = id);
       	return up/down;
	END //
DELIMITER;
select fractionXtra (4);
-- 0.818


-- 2. Triggers
-- 1.
drop trigger if exists afterEvent;
DELIMITER |
CREATE TRIGGER afterEvent after INSERT ON eventLog FOR EACH ROW BEGIN
	declare curId int;
	declare id int;
	declare done INT DEFAULT FALSE;
	declare curso CURSOR FOR SELECT maintId FROM Maintenance where beforeFlag = '0' and triggerUnit = 'event';
    declare CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    -- the done attribute value will be set to TRUE by the person who completes the task.
    open curso;
    	read_loop: LOOP
			FETCH curso INTO curId;
			IF done THEN
			  LEAVE read_loop;
			END IF;
				INSERT INTO toDo (id, toDoType, recorded, done) VALUES (curId, 'maint', now(), false);
	  	END LOOP;

	  	CLOSE curso;
 	END;
|
DELIMITER;
truncate toDo;
truncate eventLog;
INSERT INTO eventLog(eventId, actualStart, minutesDuration)
VALUES (1,'2017-01-19 13:05:00' , 67);
SELECT * FROM toDo;
/*
'1','4','maint','2018-04-07 16:36:53','0'
'2','11','maint','2018-04-07 16:36:53','0'
'3','12','maint','2018-04-07 16:36:53','0'
*/

-- 2.
drop trigger if exists afterDelivery;
DELIMITER|
CREATE TRIGGER afterDelivery after update ON delivery FOR EACH ROW BEGIN
    declare da int;
	set da = DATEDIFF(new.deliveryDate, new.orderDate);
	IF da > 14 THEN 
		BEGIN
			INSERT INTO toDo (id, toDoType, recorded, done) 
			VALUES (new.deliveryId, 'late delivery', now(), false);
		END; 
	END IF;
  END;
|
DELIMITER;
TRUNCATE TABLE toDo;
UPDATE delivery SET deliveryDate = '2018-01-16' WHERE deliveryID = 2;
SELECT * FROM toDo;
TRUNCATE TABLE toDo;
UPDATE delivery SET deliveryDate = '2018-02-16' WHERE deliveryID = 2;
SELECT * FROM toDo;
-- '1','2','late delivery','2018-04-07 16:39:30','0'



-- 3. Stored Procedures

drop procedure if exists productChains;
DELIMITER $$
create PROCEDURE productChains () 
BEGIN
    declare curE int;
    declare curS int;
	declare c int;
    declare lastE int default -1;
    declare lastS int default -10;
    declare t varchar(20);
    declare code varchar(20);
	declare done INT DEFAULT FALSE;
    declare le varchar(20) default 'null';
    declare lastP varchar(20) default 'null';
	declare cur CURSOR FOR 
		SELECT sale.saleId, sale.eventId, productType.productCode, productType.productType FROM sale, productType 
        where sale.productCode = productType.productCode group by saleId;      
    declare CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    open cur;
    read_loop: LOOP
		FETCH cur INTO curS, curE, code, t;
		IF done THEN
		  LEAVE read_loop;
		END IF;
        if lastE != curE then 
        	set lastS = -1;
			set lastP = 'null';
            set le = 'null';
        end if;
        set lastE = curE; 
        if t = 'extra'  then
			if le != 'null' and curS <= lastS+2 then
				set c = (select count(*) from productTypePairs 
					where productType1 = 'extra' and productType2 = 'extra');
				if c = 0 then
					insert into productTypePairs (productType1, productType2, productCount) 
						values ('extra', 'extra', 1);
                else
					UPDATE productTypePairs SET productCount = productCount+1 where productType1 = 'extra' and productType2 = 'extra';
				end if;    
			end if;
            set lastS = curS;
			set le = 'extra'; 
        else
			if lastP != 'null' then
				set c = ( select count(*) from productTypePairs 
					where productType1 = lastP and productType2 = t);
				if c = 0 then
					insert into productTypePairs (productType1, productType2, productCount) 
						values (lastP, t, 1);
                else	
					UPDATE productTypePairs SET productCount = productCount+1 where productType1 = lastP and productType2 = type;
				end if;
			end if;
			set lastP = t; 
        end if;
	  END LOOP;
	  CLOSE cur;    
  END;
$$
DELIMITER ;
truncate table productTypePairs;
CALL productChains (); 
select * from productTypePairs;
/*
'beverage','beverage','12'
'beverage','cone','32'
'beverage','dish','15'
'beverage','ice cream beverage','24'
'beverage','novelty','14'
'beverage','pint','8'
'beverage','slush','40'
'beverage','sundae','60'
'cone','beverage','23'
'cone','cone','197'
'cone','dish','130'
'cone','ice cream beverage','86'
'cone','novelty','53'
'cone','pint','35'
'cone','slush','175'
'cone','sundae','218'
'dish','beverage','30'
'dish','cone','106'
'dish','dish','90'
'dish','ice cream beverage','69'
'dish','novelty','29'
'dish','pint','26'
'dish','slush','132'
'dish','sundae','153'
'extra','extra','922'
'ice cream beverage','beverage','26'
'ice cream beverage','cone','87'
'ice cream beverage','dish','71'
'ice cream beverage','ice cream beverage','59'
'ice cream beverage','novelty','23'
'ice cream beverage','pint','21'
'ice cream beverage','slush','79'
'ice cream beverage','sundae','151'
'novelty','beverage','8'
'novelty','cone','44'
'novelty','dish','28'
'novelty','ice cream beverage','29'
'novelty','novelty','3'
'novelty','pint','15'
'novelty','slush','42'
'novelty','sundae','49'
'pint','beverage','8'
'pint','cone','38'
'pint','dish','31'
'pint','ice cream beverage','21'
'pint','novelty','5'
'pint','pint','6'
'pint','slush','44'
'pint','sundae','52'
'slush','beverage','44'
'slush','cone','180'
'slush','dish','103'
'slush','ice cream beverage','101'
'slush','novelty','44'
'slush','pint','33'
'slush','slush','187'
'slush','sundae','236'
'sundae','beverage','52'
'sundae','cone','233'
'sundae','dish','162'
'sundae','ice cream beverage','130'
'sundae','novelty','45'
'sundae','pint','63'
'sundae','slush','235'
'sundae','sundae','323'
*/

 
