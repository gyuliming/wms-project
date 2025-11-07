use wms;

drop table admin;
create table admin(
                      admin_index Bigint primary key auto_increment,
                      admin_name varchar(50) not null,
                      admin_id varchar(50) not null UNIQUE,
                      admin_pw varchar(255) not null,
                      admin_role ENUM('마스터','관리자') NOT NULL DEFAULT '관리자',
                      admin_phone varchar(50) null,
                      admin_createdAt timestamp default current_timestamp() null,
                      admin_updateAt timestamp default current_timestamp() null,
                      admin_status ENUM('승인','대기','거절') NOT NULL DEFAULT '대기'
);

