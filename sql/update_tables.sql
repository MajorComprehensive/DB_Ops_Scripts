alter table EMPLOYEE add BIRTHDAY DATE;

alter table MANAGE add REPAIR INT;
alter table MANAGE add constraint fk_repair foreign key(REPAIR) references REPAIR(REPAIR_ID);

alter table DISHES add VIDEO VARCHAR(50);
alter table DISHORDERLIST add REMARK VARCHAR (150);