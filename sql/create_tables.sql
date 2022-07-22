CREATE TABLE award(
    lv VARCHAR(50),
    amount DECIMAL(9, 2),
    PRIMARY KEY (lv)
);

CREATE TABLE salary(
    occupation VARCHAR(50) CHECK(occupation IN ('经理', '仓库管理员', '后厨人员', '服务员', '保洁人员', '搬运工', '前台')),
    amount DECIMAL(9, 2),
    PRIMARY KEY (occupation)
);

CREATE TABLE employee(
    id INT,
    name VARCHAR(50),
    gender VARCHAR(6) CHECK(gender IN ('男', '女', '未定义')),
    occupation VARCHAR(50),

    PRIMARY KEY (id),

    FOREIGN KEY (occupation) REFERENCES salary(occupation) ON
DELETE CASCADE

);

CREATE TABLE work_plan(
    id INT,
    time_start DATE,
    time_end DATE,
    place VARCHAR(50),
    occupation VARCHAR(50),
    no INT,

    PRIMARY KEY (id),
    FOREIGN KEY (occupation) REFERENCES salary(occupation) ON
DELETE CASCADE

);

CREATE TABLE attend(
    plan_id INT,
    employee_id INT,
    attendance NUMBER(1),

    PRIMARY KEY (plan_id, employee_id),
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON
DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES work_plan(id) ON
DELETE CASCADE
);

CREATE TABLE payroll(
    pay_datetime DATE,
    employee_id INT,

    PRIMARY KEY (pay_datetime, employee_id),
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE prize(
    prize_datetime DATE,
    employee_id INT,
    lv VARCHAR(50),

    PRIMARY KEY (prize_datetime, employee_id, lv),
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON
DELETE CASCADE,
    FOREIGN KEY (lv) REFERENCES award(lv) ON
DELETE CASCADE
);

CREATE TABLE assets(
    assets_id VARCHAR(50) NOT NULL,
    assets_type VARCHAR(50) NOT NULL,
    employee_id INT NOT NULL,
    assets_status INT NOT NULL,
    PRIMARY KEY (assets_id),
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON
DELETE CASCADE
);

CREATE TABLE manage(
    employee_id INT NOT NULL,
    assets_id VARCHAR(50) NOT NULL,
    manage_type VARCHAR(1000) NOT NULL,
    manage_date DATE NOT NULL,
    manage_reason VARCHAR(50),
    manage_cost VARCHAR(1000) NOT NULL,
    PRIMARY KEY (assets_id, manage_type, manage_date, manage_reason, manage_cost),
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON
DELETE CASCADE ,
    FOREIGN key (assets_id) REFERENCES assets(assets_id) ON
DELETE CASCADE
);

CREATE TABLE Dishes(
    dish_id INT,
    dish_name VARCHAR(50) NOT NULL,
    dish_price DECIMAL(9,2) NOT NULL,
    dish_description VARCHAR(1000) NOT NULL,
    PRIMARY KEY(dish_id)
);

CREATE TABLE DishTags(
    dtag_id INT,
    dtag_name VARCHAR(50) NOT NULL,
    PRIMARY KEY(dtag_id)
);

CREATE TABLE Ingredients(
    ingr_id INT,
    ingr_name VARCHAR(50) NOT NULL,
    ingr_description VARCHAR(1000) NOT NULL,
    ingr_type VARCHAR(50),
    PRIMARY KEY(ingr_id)
);


CREATE TABLE Sensors(
    sens_id INT,
    sens_type VARCHAR(50) NOT NULL,
    sens_model VARCHAR(50) NOT NULL,
    sens_location VARCHAR(50) NOT NULL,
    PRIMARY KEY(sens_id)
);

CREATE TABLE dish_has_tag(
    dish_id INT,
    dtag_id INT,

    PRIMARY KEY(dish_id, dtag_id),

    FOREIGN KEY (dish_id)
    REFERENCES Dishes(dish_id) ON DELETE CASCADE,

    FOREIGN KEY (dtag_id)
    REFERENCES DishTags(dtag_id) ON DELETE CASCADE
);

CREATE TABLE chef_cancook_dish(
    dish_id INT,
    chef_id INT,

    PRIMARY KEY(dish_id, chef_id),

    FOREIGN KEY (dish_id)
    REFERENCES Dishes(dish_id) ON
DELETE CASCADE,

    FOREIGN KEY (chef_id)
    REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE dishe_need_ingr(
    dish_id INT,
    ingr_id INT,

    PRIMARY KEY(dish_id, ingr_id),

    FOREIGN KEY (dish_id)
    REFERENCES Dishes(dish_id) ON DELETE CASCADE,

    FOREIGN KEY (ingr_id)
    REFERENCES Ingredients(ingr_id) ON DELETE CASCADE
);

CREATE TABLE SensorLog(
    slog_id INT,
    sens_id INT,
    slog_time TIMESTAMP NOT NULL,
    slog_value DECIMAL(8,2)  NOT NULL,
    PRIMARY KEY(slog_id),

    FOREIGN KEY (sens_id)
    REFERENCES Sensors(sens_id) ON
DELETE CASCADE
);

CREATE TABLE ingredient_record(
        record_id INT NOT NULL,
        ingr_id INT,
        purchasing_date DATE,
        surplus DECIMAL(8,2),
        purchases DECIMAL(8,2),
        measure_unit VARCHAR(10),
        shelf_life INT,
        produced_date DATE,
        price DECIMAL(8,2),
        director_id INT,

        PRIMARY KEY (record_id),
        FOREIGN KEY (director_id) REFERENCES employee(id) ON
DELETE CASCADE ,
        FOREIGN KEY (ingr_id) REFERENCES ingredients ON
DELETE CASCADE
);

CREATE TABLE supplier(
        s_id INT NOT NULL,
        s_name VARCHAR(50),
        address VARCHAR(256),
        contact VARCHAR(256),
        director_id INT,

        PRIMARY KEY (s_id),
        FOREIGN KEY (director_id) REFERENCES employee(id) ON
DELETE CASCADE
);

CREATE TABLE provide(
        record_id INT NOT NULL,
        s_id INT NOT NULL,
        PRIMARY KEY (record_id),
        FOREIGN KEY (record_id) REFERENCES ingredient_record ON
DELETE CASCADE ,
        FOREIGN KEY (s_id) REFERENCES supplier ON
DELETE CASCADE
);

CREATE TABLE DinningTable(
    table_id INT NOT NULL,
    customer_number INT,
    table_capacity INT,
    occupied VARCHAR2(20) CHECK(occupied = '是' OR occupied = '否'),
    PRIMARY KEY (table_id)
);

CREATE TABLE OrderList (
  order_id VARCHAR(50) NOT NULL,
  creation_time DATE NOT NULL,
  table_id INT NOT NULL,
  order_status VARCHAR(20) NOT NULL CHECK(order_status = '待处理' OR order_status = '制作中' OR order_status = '已完成' OR order_status = '已支付'),
  PRIMARY KEY (order_id),
  FOREIGN KEY (table_id) REFERENCES DINNINGTABLE ON
DELETE CASCADE
  );

 CREATE TABLE DishOrderList (
  dish_order_id VARCHAR(50) NOT NULL,
  order_id VARCHAR(50) NOT NULL,
  dish_id INT NOT NULL,
  final_payment DECIMAL(6,2) NOT NULL,
  dish_status VARCHAR(20) NOT NULL CHECK(dish_status = '待处理' OR dish_status = '制作中' OR dish_status = '已完成'),
  PRIMARY KEY (dish_order_id),
  FOREIGN KEY (order_id) REFERENCES OrderList ON
DELETE CASCADE ,
  FOREIGN KEY (dish_id) REFERENCES Dishes ON
DELETE CASCADE
);

CREATE TABLE VIP(
    user_name VARCHAR(50) NOT NULL ,
    password VARCHAR(50) NOT NULL CHECK(length(password) >= 5 and length(password) <= 16),
    birthday DATE,
    gender VARCHAR(20) CHECK(gender in('男', '女', '未定义')),
    balance DECIMAL(8, 2) DEFAULT(0.0) NOT NULL ,
    credit INT DEFAULT(0) NOT NULL ,
    is_default VARCHAR(20) DEFAULT('是') NOT NULL CHECK(is_default = '是' OR is_default = '否'),
    PRIMARY KEY (user_name)
);

CREATE TABLE order_number(
    order_date DATE NOT NULL,
    order_number VARCHAR(20) NOT NULL,
    user_name VARCHAR(50) REFERENCES VIP(user_name) ON DELETE CASCADE,
    order_id VARCHAR(50) REFERENCES OrderList(order_id) ON DELETE CASCADE,
    PRIMARY KEY (order_date, order_number)
);

CREATE TABLE Promotion(
    promotion_id INT NOT NULL,
    start_time DATE,
    end_time DATE,
    description VARCHAR(256),
    PRIMARY KEY (promotion_id)
);

CREATE TABLE hasDish(
    promotion_id INT NOT NULL,
    dish_id INT NOT NULL,
    discount DECIMAL(8,2) CHECK(discount BETWEEN 0 AND 1),
    PRIMARY KEY (promotion_id,dish_id),
    FOREIGN KEY (promotion_id) REFERENCES Promotion(promotion_id) ON DELETE CASCADE,
    FOREIGN KEY (dish_id) REFERENCES Dishes(dish_id) ON DELETE CASCADE
);

create table origin_chef(
    dish_order_id VARCHAR(50) NOT NULL,
    chef_id INT,

    FOREIGN KEY (dish_order_id)
    REFERENCES OrderList(order_id) ON DELETE CASCADE,

    FOREIGN KEY (chef_id)
    REFERENCES employee(id) ON DELETE CASCADE
);

create table origin_ingr_record(
    dish_order_id VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,

    FOREIGN KEY (dish_order_id)
    REFERENCES OrderList(order_id) ON DELETE CASCADE,

    FOREIGN KEY (record_id)
    REFERENCES ingredient_record(record_id) ON DELETE CASCADE
);

CREATE TABLE comment_on_dish(
    comment_id VARCHAR(50) NOT NULL,
    user_name VARCHAR(50) NOT NULL,
    dish_id INT NOT NULL,
    comment_time TIMESTAMP,
    stars SMALLINT CHECK(stars BETWEEN  0 AND 5),
    comment_content VARCHAR(256),
    PRIMARY KEY (comment_id),
    FOREIGN KEY (user_name) REFERENCES VIP ON
DELETE CASCADE ,
    FOREIGN KEY (dish_id) REFERENCES dishes(dish_id) ON
DELETE CASCADE
);

CREATE TABLE comment_on_service(
    comment_id VARCHAR(50) NOT NULL,
    user_name VARCHAR(50) NOT NULL,
    comment_time TIMESTAMP,
    stars SMALLINT CHECK(stars BETWEEN  0 AND 5),
    comment_content VARCHAR(256),
    PRIMARY KEY (comment_id),
    FOREIGN KEY (user_name) REFERENCES VIP ON
DELETE CASCADE
);
