use wms;

drop table users;
create table users(
                     user_index Bigint primary key auto_increment,
                     user_name varchar(50) not null,
                     user_id varchar(50) not null UNIQUE,
                     user_pw varchar(255) not null,
                     user_email varchar(50) null,
                     user_phone varchar(50) null,
                     user_createdAt timestamp default current_timestamp() null,
                     user_updateAt timestamp default current_timestamp() null,
                     user_status ENUM('승인','대기','거절') NOT NULL DEFAULT '대기'
);


