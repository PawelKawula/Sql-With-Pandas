BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "basketitems" (
	"basketItemId"	integer NOT NULL,
	"basketId"	integer NOT NULL,
	"productId"	integer NOT NULL,
	"quantity"	integer NOT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime DEFAULT current_timestamp,
	PRIMARY KEY("basketItemId" AUTOINCREMENT),
	CONSTRAINT "userbasketFK" FOREIGN KEY("basketId") REFERENCES "baskets"("basketId"),
	CONSTRAINT "userproductFK" FOREIGN KEY("productId") REFERENCES "products"("productId")
);
CREATE TABLE IF NOT EXISTS "baskets" (
	"basketId"	integer NOT NULL,
	"userId"	integer NOT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime DEFAULT current_timestamp,
	PRIMARY KEY("basketId" AUTOINCREMENT),
	CONSTRAINT "basketuserFK" FOREIGN KEY("userId") REFERENCES "users"("userId")
);
CREATE TABLE IF NOT EXISTS "categories" (
	"categoryId"	integer NOT NULL,
	"name"	varchar(255) DEFAULT NULL,
	"parentCategoryId"	integer DEFAULT NULL,
	"description"	varchar(1023) DEFAULT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime DEFAULT current_timestamp,
	PRIMARY KEY("categoryId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "invoiceitems" (
	"invoiceItemId"	integer NOT NULL,
	"invoiceId"	integer NOT NULL,
	"productId"	integer NOT NULL,
	"vatrate"	decimal(2, 0) NOT NULL,
	"brutto"	decimal(10, 2) NOT NULL,
	"netto"	decimal(10, 2) NOT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime NOT NULL DEFAULT current_timestamp,
	PRIMARY KEY("invoiceItemId" AUTOINCREMENT),
	CONSTRAINT "vatratePositive" CHECK("vatrate" > 0),
	CONSTRAINT "productId_FK" FOREIGN KEY("productId") REFERENCES "products"("productId"),
	CONSTRAINT "invoiceId_FK" FOREIGN KEY("invoiceId") REFERENCES "invoices"("invoiceId")
);
CREATE TABLE IF NOT EXISTS "invoices" (
	"invoiceId"	integer NOT NULL,
	"orderId"	integer NOT NULL,
	"vatrate"	decimal(2, 0) NOT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime DEFAULT current_timestamp,
	PRIMARY KEY("invoiceId" AUTOINCREMENT),
	CONSTRAINT "positiveVatRate" CHECK("vatrate" > 0),
	CONSTRAINT "invoiceorderFK" FOREIGN KEY("orderId") REFERENCES "orders"("orderId")
);
CREATE TABLE IF NOT EXISTS "logs" (
	"logId"	integer NOT NULL,
	"message"	varchar(255) NOT NULL,
	PRIMARY KEY("logId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "orderitems" (
	"orderItemId"	integer NOT NULL,
	"orderId"	integer NOT NULL,
	"productId"	integer NOT NULL,
	"quantity"	integer NOT NULL,
	"vatRate"	integer NOT NULL DEFAULT 23,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime DEFAULT current_timestamp,
	CONSTRAINT "positiveVat" CHECK("vatRate" > 0),
	CONSTRAINT "orderitemorderFK" FOREIGN KEY("orderId") REFERENCES "orders"("orderId"),
	CONSTRAINT "positiveQuantity" CHECK("quantity" > 0),
	CONSTRAINT "orderitemproductFK" FOREIGN KEY("productId") REFERENCES "products"("productId"),
	PRIMARY KEY("orderItemId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "orders" (
	"orderId"	integer NOT NULL,
	"userId"	integer NOT NULL,
	"orderDate"	date NOT NULL,
	"shippingDate"	datetime DEFAULT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	PRIMARY KEY("orderId" AUTOINCREMENT),
	CONSTRAINT "orderuserFK" FOREIGN KEY("userId") REFERENCES "users"("userId")
);
CREATE TABLE IF NOT EXISTS "paymentmethods" (
	"paymentMethodId"	integer NOT NULL,
	"userId"	integer NOT NULL,
	"cardNumber"	decimal(11, 0) NOT NULL,
	"expireDate"	date NOT NULL,
	"CVCnumber"	decimal(3, 0) NOT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime DEFAULT current_timestamp,
	PRIMARY KEY("paymentMethodId" AUTOINCREMENT),
	CONSTRAINT "userpaymentmethodFK" FOREIGN KEY("userId") REFERENCES "users"("userId")
);
CREATE TABLE IF NOT EXISTS "producents" (
	"producentId"	integer NOT NULL,
	"name"	varchar(255) DEFAULT NULL,
	"description"	varchar(1023) DEFAULT NULL,
	"NIP"	varchar(11) NOT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime DEFAULT current_timestamp,
	PRIMARY KEY("producentId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "productratings" (
	"productId"	integer NOT NULL,
	"userId"	integer NOT NULL,
	"rating"	decimal(5, 0) NOT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime DEFAULT current_timestamp,
	CONSTRAINT "productratinguserFK" FOREIGN KEY("userId") REFERENCES "users"("userId"),
	CONSTRAINT "productratingproductFK" FOREIGN KEY("productId") REFERENCES "products"("productId"),
	PRIMARY KEY("productId")
);
CREATE TABLE IF NOT EXISTS "products" (
	"productId"	integer NOT NULL,
	"producentId"	integer DEFAULT NULL,
	"categoryId"	integer DEFAULT NULL,
	"name"	varchar(255) DEFAULT NULL,
	"price"	decimal(10, 2) NOT NULL,
	"stock"	integer NOT NULL,
	"description"	varchar(255) DEFAULT NULL,
	"modificationDate"	timestamp DEFAULT current_timestamp,
	"creationDate"	timestamp DEFAULT current_timestamp,
	PRIMARY KEY("productId" AUTOINCREMENT),
	CONSTRAINT "pricePositive" CHECK("price" > 0),
	CONSTRAINT "categoryFK" FOREIGN KEY("categoryId") REFERENCES "categories"("categoryId"),
	CONSTRAINT "producentFK" FOREIGN KEY("producentId") REFERENCES "producents"("producentId")
);
CREATE TABLE IF NOT EXISTS "shipments" (
	"shipmentId"	integer NOT NULL,
	"orderItemId"	integer NOT NULL,
	"trackingNumber"	integer NOT NULL,
	"shipmentDate"	datetime(6) NOT NULL,
	"sendDate"	datetime(6) NOT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime DEFAULT current_timestamp,
	CONSTRAINT "shipmentorderitemFK" FOREIGN KEY("orderItemId") REFERENCES "orderitems"("orderItemId"),
	PRIMARY KEY("shipmentId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "useraddresses" (
	"userAddressId"	integer NOT NULL,
	"userId"	integer NOT NULL,
	"country"	varchar(255) NOT NULL,
	"region"	text DEFAULT 'Małopolskie',
	"city"	varchar(255) NOT NULL,
	"zipcode"	varchar(255) NOT NULL,
	"street"	varchar(255) NOT NULL,
	"housenumber"	integer NOT NULL,
	"apartmentnumber"	integer DEFAULT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime DEFAULT current_timestamp,
	PRIMARY KEY("userAddressId" AUTOINCREMENT),
	CONSTRAINT "useraddressuserFK" FOREIGN KEY("userId") REFERENCES "users"("userId")
);
CREATE TABLE IF NOT EXISTS "users" (
	"userId"	integer NOT NULL,
	"email"	varchar(255) NOT NULL,
	"password"	varchar(255) NOT NULL,
	"lastLogin"	datetime(6) DEFAULT NULL,
	"name"	varchar(255) NOT NULL,
	"surname"	varchar(255) NOT NULL,
	"birthDate"	date NOT NULL,
	"avatar"	longblob DEFAULT NULL,
	"gender"	text DEFAULT NULL,
	"modificationDate"	datetime DEFAULT NULL,
	"creationDate"	datetime NOT NULL DEFAULT current_timestamp,
	PRIMARY KEY("userId" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "sessions" (
	"sessionId"	integer NOT NULL,
	"userId"	integer NOT NULL,
	"token"	varchar(36) NOT NULL DEFAULT (uuid4()),
	CONSTRAINT "userId_FK" FOREIGN KEY("userId") REFERENCES "users"("userId"),
	PRIMARY KEY("sessionId" AUTOINCREMENT)
);
INSERT INTO "basketitems" VALUES (6,1,5,2,NULL,'2022-06-08 15:05:06');
INSERT INTO "basketitems" VALUES (7,1,6,1,NULL,'2022-06-08 15:05:06');
INSERT INTO "basketitems" VALUES (8,2,7,1,NULL,'2022-06-08 15:05:06');
INSERT INTO "basketitems" VALUES (9,2,8,3,NULL,'2022-06-08 15:05:06');
INSERT INTO "basketitems" VALUES (10,2,12,1,NULL,'2022-06-08 15:05:06');
INSERT INTO "basketitems" VALUES (11,3,14,1,NULL,'2022-06-08 15:05:06');
INSERT INTO "basketitems" VALUES (12,3,6,4,NULL,'2022-06-08 15:05:06');
INSERT INTO "basketitems" VALUES (14,4,7,1,NULL,'2022-06-08 15:05:06');
INSERT INTO "baskets" VALUES (1,2,NULL,'2022-06-08 15:05:42');
INSERT INTO "baskets" VALUES (2,3,NULL,'2022-06-08 15:05:42');
INSERT INTO "baskets" VALUES (3,4,NULL,'2022-06-08 15:05:42');
INSERT INTO "baskets" VALUES (4,5,NULL,'2022-06-08 15:05:42');
INSERT INTO "categories" VALUES (1,'Computers',NULL,'All the hardware for your PC!',NULL,'2022-03-30 09:27:38');
INSERT INTO "categories" VALUES (2,'Graphics Cards',1,'GPU for your games and entertainment',NULL,'2022-03-30 09:27:38');
INSERT INTO "categories" VALUES (3,'CPUs',1,'All the processing power you will ever need',NULL,'2022-03-30 09:27:38');
INSERT INTO "categories" VALUES (4,'RAM memory',1,NULL,'2022-04-05 20:32:26','2022-04-05 20:20:33');
INSERT INTO "categories" VALUES (5,'Hard Drives',1,'','2022-04-05 20:32:29','2022-04-05 20:22:17');
INSERT INTO "categories" VALUES (6,'Motherboards',1,NULL,NULL,'2022-04-05 20:33:07');
INSERT INTO "categories" VALUES (7,'Solid State Drives',1,NULL,NULL,'2022-04-05 21:05:06');
INSERT INTO "logs" VALUES (1,'password changed for user with id 2');
INSERT INTO "logs" VALUES (2,'user with id 2 revisited our shop');
INSERT INTO "orderitems" VALUES (2,4,9,1,23,'2022-06-07 16:17:40','2022-03-30 09:53:48');
INSERT INTO "orderitems" VALUES (3,4,14,1,23,'2022-03-30 09:54:50','2022-03-30 09:54:11');
INSERT INTO "orderitems" VALUES (4,5,6,1,23,NULL,'2022-03-30 09:55:38');
INSERT INTO "orderitems" VALUES (5,5,9,1,23,'2022-06-07 16:29:31','2022-03-30 09:55:49');
INSERT INTO "orderitems" VALUES (6,6,12,1,23,NULL,'2022-03-30 09:56:33');
INSERT INTO "orderitems" VALUES (7,6,16,1,23,NULL,'2022-03-30 09:56:44');
INSERT INTO "orderitems" VALUES (8,7,5,1,23,NULL,'2022-06-05 15:15:30');
INSERT INTO "orderitems" VALUES (9,7,35,2,23,'2022-06-05 15:39:05','2022-06-05 15:38:32');
INSERT INTO "orderitems" VALUES (15,16,9,2,23,NULL,'2022-06-07 17:19:28');
INSERT INTO "orderitems" VALUES (16,16,14,1,23,NULL,'2022-06-07 17:19:28');
INSERT INTO "orderitems" VALUES (18,17,9,2,23,NULL,'2022-06-07 17:20:07');
INSERT INTO "orderitems" VALUES (19,17,14,1,23,NULL,'2022-06-07 17:20:07');
INSERT INTO "orders" VALUES (4,2,'2022-03-22','2022-03-23 09:51:26',NULL);
INSERT INTO "orders" VALUES (5,3,'2022-03-21','2022-03-22 09:51:55',NULL);
INSERT INTO "orders" VALUES (6,7,'2022-03-22','2022-03-24 09:52:27',NULL);
INSERT INTO "orders" VALUES (7,5,'2022-06-05',NULL,NULL);
INSERT INTO "orders" VALUES (9,8,'2022-06-07',NULL,NULL);
INSERT INTO "orders" VALUES (10,8,'2022-06-07',NULL,NULL);
INSERT INTO "orders" VALUES (11,8,'2022-06-07',NULL,NULL);
INSERT INTO "orders" VALUES (12,8,'2022-06-07',NULL,NULL);
INSERT INTO "orders" VALUES (13,8,'2022-06-07',NULL,NULL);
INSERT INTO "orders" VALUES (14,8,'2022-06-07',NULL,NULL);
INSERT INTO "orders" VALUES (15,8,'2022-06-07',NULL,NULL);
INSERT INTO "orders" VALUES (16,8,'2022-06-07',NULL,NULL);
INSERT INTO "orders" VALUES (17,8,'2022-06-07',NULL,NULL);
INSERT INTO "orders" VALUES (19,2,'2022-06-07',NULL,NULL);
INSERT INTO "paymentmethods" VALUES (2,2,123456789,'2024-03-12',323,'2022-06-08 15:08:07','2022-06-08 15:07:31');
INSERT INTO "paymentmethods" VALUES (3,3,987654321,'2024-07-04',833,'2022-06-08 15:17:56','2022-06-08 15:07:58');
INSERT INTO "paymentmethods" VALUES (4,4,567891234,'2025-03-14',522,NULL,'2022-06-08 15:18:25');
INSERT INTO "producents" VALUES (1,'Nvidia','Graphics Manufacturing Company','5252658115',NULL,'2022-03-30 09:31:04');
INSERT INTO "producents" VALUES (2,'AMD','CPU and Graphics Manufacturing Company','	7392965657',NULL,'2022-03-30 09:31:04');
INSERT INTO "producents" VALUES (3,'Intel','CPU Manufacturing Company','9570752316',NULL,'2022-03-30 09:31:04');
INSERT INTO "producents" VALUES (4,'Crucial','SSD and RAM Manufacturing Company','7850014635',NULL,'2022-04-05 20:36:46');
INSERT INTO "producents" VALUES (5,'WD','HDD, SSD Manufacturing Company','4622318954',NULL,'2022-04-05 20:38:02');
INSERT INTO "producents" VALUES (6,'Seagate','HDD Manufacturing Company','4279786150',NULL,'2022-04-05 20:39:52');
INSERT INTO "producents" VALUES (7,'GOODRAM','RAM and HDD Manufacturing Company','1968772001',NULL,'2022-04-05 20:40:49');
INSERT INTO "producents" VALUES (8,'Kingstone','RAM Manufacturing Company','2149678854',NULL,'2022-04-05 20:41:20');
INSERT INTO "producents" VALUES (9,'Patriot','RAM and HDD Manufacturing Company','8745081432',NULL,'2022-04-05 20:42:00');
INSERT INTO "producents" VALUES (10,'Gigabyte','Motherboard Manufacturing Company','5285764917',NULL,'2022-04-05 20:42:59');
INSERT INTO "producents" VALUES (11,'MSI','Motherboard Manufacturing Company','7618374905',NULL,'2022-04-05 20:43:30');
INSERT INTO "producents" VALUES (12,'ASUS','Motherboard Manufacturing Company','4185739023',NULL,'2022-04-05 20:44:25');
INSERT INTO "productratings" VALUES (5,2,5,'2022-03-30 09:57:58','2022-03-30 09:57:28');
INSERT INTO "productratings" VALUES (10,2,5,NULL,'2022-03-30 09:58:20');
INSERT INTO "productratings" VALUES (12,7,2,NULL,'2022-03-30 09:58:55');
INSERT INTO "products" VALUES (5,1,2,'RTX 3090',10490,0,'Ray Tracing Boost','2022-03-30 09:25:21','2022-03-30 09:25:21');
INSERT INTO "products" VALUES (6,1,2,'GTX 1070',2499,3,'Pascal','2022-03-30 09:34:02','2022-03-30 09:34:02');
INSERT INTO "products" VALUES (7,1,2,'GTX 1080',2999,2,'Pascal','2022-03-30 09:34:25','2022-03-30 09:34:25');
INSERT INTO "products" VALUES (8,1,2,'GTX 1660',1999,7,NULL,'2022-03-30 09:36:02','2022-03-30 09:36:02');
INSERT INTO "products" VALUES (9,3,3,'i7 4790k',1490,0,'Discontinued','2022-03-30 09:37:41','2022-03-30 09:37:41');
INSERT INTO "products" VALUES (10,3,3,'Xeon e31231v3',1299,2,'For servers','2022-03-30 09:38:44','2022-03-30 09:38:44');
INSERT INTO "products" VALUES (11,2,3,'Ryzen 5 5600X',1479,4,NULL,'2022-03-30 09:39:44','2022-03-30 09:39:44');
INSERT INTO "products" VALUES (12,2,3,'Ryzen 5 3600 OEM',1099,5,'No cooling','2022-03-30 09:40:59','2022-03-30 09:40:59');
INSERT INTO "products" VALUES (13,3,3,'Celeron G5900',259,20,NULL,'2022-03-30 09:41:40','2022-03-30 09:41:40');
INSERT INTO "products" VALUES (14,3,3,'Core i9-10920X',3799,2,'Beast','2022-03-30 09:42:27','2022-03-30 09:42:27');
INSERT INTO "products" VALUES (15,2,2,'Radeon Pro WX 7100 8GB GDDR5',3589,3,NULL,'2022-03-30 09:43:34','2022-03-30 09:43:34');
INSERT INTO "products" VALUES (16,2,2,'Radeon RX 6500 XT MECH 2X OC 4GB GDDR6',1249,12,NULL,'2022-03-30 09:44:26','2022-03-30 09:44:26');
INSERT INTO "products" VALUES (17,2,2,'RX 6900 XT Ultimate Liquid Devil 16GB GDDR6',6999,1,NULL,'2022-03-30 09:46:41','2022-03-30 09:46:41');
INSERT INTO "products" VALUES (18,12,6,'TUF GAMING B550-PLUS',779,23,NULL,'2022-04-05 20:46:29','2022-04-05 20:45:41');
INSERT INTO "products" VALUES (19,12,6,'PRIME B560M-K',459,16,NULL,'2022-04-05 20:46:25','2022-04-05 20:46:25');
INSERT INTO "products" VALUES (20,12,6,'TUF GAMING Z690-PLUS DDR4',1599,4,NULL,'2022-04-05 20:47:06','2022-04-05 20:47:06');
INSERT INTO "products" VALUES (21,11,6,'PRO B660-M-A WIFi DDR4',889,14,NULL,'2022-04-05 20:47:52','2022-04-05 20:47:52');
INSERT INTO "products" VALUES (22,11,6,'MPG Z590 GAMING PLUS',1199,2,NULL,'2022-04-05 20:48:19','2022-04-05 20:48:19');
INSERT INTO "products" VALUES (23,11,6,'MAG B560M BAZOOKA',579,31,NULL,'2022-04-05 20:48:59','2022-04-05 20:48:59');
INSERT INTO "products" VALUES (24,10,6,'B550 AORUS ELITE V2',619,9,NULL,'2022-04-05 20:49:33','2022-04-05 20:49:33');
INSERT INTO "products" VALUES (25,10,6,'H410M H V3',279,40,NULL,'2022-04-05 20:50:05','2022-04-05 20:50:05');
INSERT INTO "products" VALUES (26,10,6,'B660 GAMING X DDR4',799,27,NULL,'2022-04-05 20:52:44','2022-04-05 20:52:44');
INSERT INTO "products" VALUES (27,10,6,'B450 AORUS PRO',429,18,NULL,'2022-04-05 20:53:14','2022-04-05 20:53:14');
INSERT INTO "products" VALUES (28,4,4,'16GB (2x8GB) 3200MHz CL16 Ballistix Black',349,31,NULL,'2022-04-05 20:55:21','2022-04-05 20:54:35');
INSERT INTO "products" VALUES (29,4,4,'32GB (2x16GB) 3200MHz CL16 Ballistix Black',679,5,NULL,'2022-04-05 20:55:17','2022-04-05 20:55:17');
INSERT INTO "products" VALUES (30,7,4,'8GB (1x8GB) 2666MHz CL19',159,50,NULL,'2022-04-05 20:56:33','2022-04-05 20:56:33');
INSERT INTO "products" VALUES (31,7,4,'32GB (2x16GB) 3600MHz CL18 PRO Deep Black',619,12,NULL,'2022-04-05 20:57:06','2022-04-05 20:57:06');
INSERT INTO "products" VALUES (32,7,4,'16GB (2x8GB) 3200MHz Cl16 IRDM X Black',335,21,NULL,'2022-04-05 20:57:51','2022-04-05 20:57:51');
INSERT INTO "products" VALUES (33,8,4,'FURY 32GB (2x16GB) 3600MHz CL16 Renegade Black',859,0,NULL,'2022-04-05 20:59:26','2022-04-05 20:59:26');
INSERT INTO "products" VALUES (34,6,5,'BARRACUDA 2TB',249,13,NULL,'2022-04-05 21:01:23','2022-04-05 21:00:55');
INSERT INTO "products" VALUES (35,6,5,'IRONWOLF CMR 3TB',479,21,NULL,'2022-04-05 21:02:13','2022-04-05 21:02:13');
INSERT INTO "products" VALUES (36,6,5,'IRONWOLF CMR 10TB',1669,14,NULL,'2022-04-05 21:02:42','2022-04-05 21:02:42');
INSERT INTO "products" VALUES (37,6,5,'SKYHAWK CMR 1TB',225,6,NULL,'2022-04-05 21:03:01','2022-04-05 21:03:01');
INSERT INTO "products" VALUES (38,5,5,'PURPLE 1TB',235,33,NULL,'2022-04-05 21:04:08','2022-04-05 21:04:08');
INSERT INTO "products" VALUES (39,5,5,'BLUE 1TB',195,22,NULL,'2022-04-05 21:04:25','2022-04-05 21:04:25');
INSERT INTO "products" VALUES (40,5,7,'1TB 2,5'''' SATA SSD Red SA500',699,13,NULL,'2022-04-05 21:05:52','2022-04-05 21:05:52');
INSERT INTO "products" VALUES (41,5,7,'1TB 2,5'''' SATA SSD Blue',549,1,NULL,'2022-04-05 21:06:22','2022-04-05 21:06:22');
INSERT INTO "products" VALUES (42,11,6,'MSI Z390',499,2,'Gaming Motherboard','2022-06-10 20:06:47','2022-06-10 20:06:47');
INSERT INTO "useraddresses" VALUES (1,2,'Polska','Podkarpackie','Tarnobrzeg','83-122','Wróblewskiego',3,21,'2022-06-08 15:50:51','2022-03-30 09:32:24');
INSERT INTO "useraddresses" VALUES (2,3,'Polska','Małopolskie','Zielona Góra','78-696','Podmiejska',112,NULL,NULL,'2022-03-30 09:32:24');
INSERT INTO "useraddresses" VALUES (3,4,'Polska','Lubuskie','Skierniewice','10-808','Pomorska',20,31,'2022-06-08 15:51:31','2022-03-30 09:32:24');
INSERT INTO "useraddresses" VALUES (4,5,'Polska','Łódzkie','Sopot','94-750','Zduńska',56,NULL,'2022-06-08 15:51:34','2022-03-30 09:32:24');
INSERT INTO "useraddresses" VALUES (5,6,'Polska','Pomorskie','Płock','43-455','Tulipanowa',11,2,'2022-06-08 15:51:38','2022-03-30 09:32:24');
INSERT INTO "useraddresses" VALUES (6,7,'Polska','Mazowieckie','Siedlce','51-925','Parkowa',11,26,'2022-06-08 15:51:42','2022-03-30 09:32:24');
INSERT INTO "useraddresses" VALUES (7,8,'Polska','Mazowieckie','Zabrze','61-047','Krzywoń',33,17,'2022-06-08 15:51:48','2022-03-30 09:32:24');
INSERT INTO "useraddresses" VALUES (8,9,'Polska','Śląskie','Olsztyn','79-944','Witosa',28,45,'2022-06-08 15:51:52','2022-03-30 09:32:24');
INSERT INTO "useraddresses" VALUES (11,11,'Polska','Warmińsko-mazurskie','Olsztyn','79-944','Witosa',28,46,'2022-06-08 15:51:55','2022-06-08 15:43:24');
INSERT INTO "users" VALUES (2,'hubert.gawczynski@student.pk.edu.pl','12343','2022-03-16 20:24:46.000000','Hubert','Gawczynski','2022-03-03',NULL,'m','2022-06-07 18:15:44','2022-03-30 09:32:51');
INSERT INTO "users" VALUES (3,'adam.malysz@gmail.com','323232','2022-03-23 20:34:51.000000','Adam','Małysz','2022-03-02',NULL,'m',NULL,'2022-03-30 09:32:51');
INSERT INTO "users" VALUES (4,'lucjan.szczepanski@gmail.com','nzycXDL','2022-03-19 22:03:23.000000','Lucjan','Szczepański','2000-06-14',NULL,'m',NULL,'2022-03-30 09:32:51');
INSERT INTO "users" VALUES (5,'aleks.kwiatkowski@onet.pl','bWxrAFF','2022-03-27 22:05:34.000000','Aleks','Kwiatkowski','1996-10-18',NULL,'m',NULL,'2022-03-30 09:32:51');
INSERT INTO "users" VALUES (6,'robert.mroz@gmail.com','WyjdHyA','2022-01-13 22:06:46.000000','Robert','Mróz','2000-04-27',NULL,'m',NULL,'2022-03-30 09:32:51');
INSERT INTO "users" VALUES (7,'jan.marciniak@wp.pl','BUhP8nU','2022-03-04 22:08:17.000000','Jan','Marciniak','2001-07-20',NULL,'m',NULL,'2022-03-30 09:32:51');
INSERT INTO "users" VALUES (8,'kinga.przybylska@gmail.com','yhtkhsW','2021-10-12 22:13:43.000000','Kinga','Przybylska','2003-02-28',NULL,'k',NULL,'2022-03-30 09:32:51');
INSERT INTO "users" VALUES (9,'luiza.tomaszewska@onet.pl','Ev8fR67','2022-01-17 22:15:03.000000','Luiza','Tomaszewska','2003-10-25',NULL,'k',NULL,'2022-03-30 09:32:51');
INSERT INTO "users" VALUES (11,'damian.tomaszewski@onet.pl','abcdef','2022-06-08 15:42:08.000000','Damian','Tomaszewski','2002-12-03',NULL,'m',NULL,'2022-06-08 15:42:13');
INSERT INTO "sessions" VALUES (1,4,'df1577dd-daf4-4d46-97db-9cf7d26ae169');
COMMIT;
