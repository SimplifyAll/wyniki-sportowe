--Skrypt tworzy bazę i nowego użytkownika o określonym hasle
--Skrypt odpalic wewnatrz dowolnej istniejacej bazy na serwerze lub z terminala via psql

DROP DATABASE basketball;
DROP USER kndatascience;

CREATE USER KNDataScience
ENCRYPTED PASSWORD 'dataScience';

CREATE DATABASE basketball OWNER kndatascience;