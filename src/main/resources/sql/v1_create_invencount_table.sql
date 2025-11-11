use wms;

create table invencount(
    count_index Bigint primary key not null auto_increment,
    inven_index BIGINT not null,
    inven_quantity int not null,
    inven_change int not null,
    actual_quantity int not null,
    count_updateAt DATETIME
);