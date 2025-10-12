CREATE SCHEMA ksiegowosc;

CREATE TABLE ksiegowosc.pracownicy (
	id_pracownika INT PRIMARY KEY,
	imie VARCHAR(50),
	nazwisko VARCHAR(50),
	adres VARCHAR(50),
	telefon INT
);

CREATE TABLE ksiegowosc.godziny (
	id_godziny INT PRIMARY KEY,
	data DATE,
	liczba_godzin INT,
	id_pracownika INT
);

CREATE TABLE ksiegowosc.pensja (
	id_pensji INT PRIMARY KEY,
	stanowisko VARCHAR(50),
	kwota int
);

CREATE TABLE ksiegowosc.premia (
	id_premii INT PRIMARY KEY,
	rodzaj VARCHAR(50),
	kwota int
);

CREATE TABLE ksiegowosc.wynagrodzenie (
	id_wynagrodzenia INT PRIMARY KEY,
	data DATE,
	id_pracownika INT,
	id_godziny INT,
	id_pensji INT,
	id_premii INT
);

COMMENT ON TABLE ksiegowosc.pracownicy IS 'Tabela przechowująca dane pracowników';
COMMENT ON TABLE ksiegowosc.godziny IS 'Tabela przechowująca dane przepacowanych godzin';
COMMENT ON TABLE ksiegowosc.pensja IS 'Tabela przechowująca pensje pracowników';
COMMENT ON TABLE ksiegowosc.premia IS 'Tabela przechowująca premie pracowników';
COMMENT ON TABLE ksiegowosc.wynagrodzenie IS 'Tabela przechowująca dane dotyczące łącznego wynagrodzenia pracowników';

INSERT INTO ksiegowosc.pracownicy VALUES(1, 'Jan', 'Kowalski', 'ul. Konwaliowa 8, Kraków', 609495354),
	(2, 'Tobiasz', 'Malinowski', 'ul. Adama Małysza 10, Wisła', 406372953),
	(3, 'Iwona', 'Piotrowicz', 'ul. Reymonta 17A, Kraków', 603845924),
	(4, 'Bożena', 'Sypniewska', 'ul. Pszczółki Mai 2, Olsztyn', 583593345),
	(5, 'Antoni', 'Krajewski', 'ul. Juliana Fałata 73, Warszawa', 943834834),
	(6, 'Teresa', 'Wachowicz', 'ul. Królewska 8, Kraków', 703953835),
	(7, 'Robert', 'Wokulski', 'ul. Stańczyka 20, Kraków', 503503775),
	(8, 'Monika', 'Nowak', 'al. Adama Mickiewicza, Kraków', 523603823),
	(9, 'Elżbieta', 'Grochowska', 'ul. Długa 4, Rzeszów', 843174253),
	(10, 'Janusz', 'Kowalski', 'ul. Chabrowa 10, Katowice', 684984456);

INSERT INTO ksiegowosc.godziny VALUES(11, '2025-09-24', 160, 1),
	(12, '2025-09-23', 142, 2),
	(13, '2025-09-21', 91, 3),
	(14, '2025-08-12', 40, 4),
	(15, '2025-08-24', 189, 5),
	(16, '2025-09-12', 160, 6),
	(17, '2025-07-29', 12, 7),
	(18, '2025-09-15', 170, 8),
	(19, '2025-08-09', 150, 9),
	(20, '2025-09-01', 193, 10);

INSERT INTO ksiegowosc.pensja VALUES(21, 'kierownik', 12394),
	(22, 'kierownik', 8504),
	(23, 'stażysta', 1945),
	(24, 'młodszy księgowy', 1804),
	(25, 'młodszy księgowy', 7656),
	(26, 'starszy księgowy', 9010),
	(27, 'starszy księgowy', 604),
	(28, 'stażysta', 2950),
	(29, 'młodszy księgowy', 6105),
	(30, 'fakturzysta', 10056);

INSERT INTO ksiegowosc.premia VALUES(31, 'dodatek stażowy', 2000),
	(33, 'premia motywacyjna', 500),
	(35, 'nadgodziny', 500),
	(36, 'dodatek stażowy', 1000),
	(38, 'nadgodziny', 400),
	(40, 'nadgodziny', 600);

INSERT INTO ksiegowosc.wynagrodzenie VALUES(101, '2025-09-24', 1, 11, 21, 31),
	(102, '2025-09-23', 2, 12, 22, NULL),
	(103, '2025-09-21', 3, 13, 23, 33),
	(104, '2025-08-12', 4, 14, 24, NULL),
	(105, '2025-08-24', 5, 15, 25, 35),
	(106, '2025-09-12', 6, 16, 26, 36),
	(107, '2025-07-29', 7, 17, 27, NULL),
	(108, '2025-09-15', 8, 18, 28, 38),
	(109, '2025-08-09', 9, 19, 29, NULL),
	(200, '2025-09-01', 10, 20, 30, 40);