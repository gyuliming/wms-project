use wms;


create table inven_count(
    count_index Bigint primary key not null auto_increment,
    inven_index BIGINT not null,
    inven_quantity int not null,
    actual_quantity int not null,
    count_updateAt DATETIME
);