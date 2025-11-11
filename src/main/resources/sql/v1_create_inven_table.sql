use wms;

drop table inventory;
create table inventory(
    inven_index BIGINT primary key auto_increment not null,
    inven_quantity int not null,
    inbound_date DATETIME null,
    shipping_date DATETIME null,
    section_index Bigint not null,
    warehouse_index Bigint not null,
    item_index Bigint not null,
    detail_inbound Bigint not null,
    detail_outbound Bigint null
);

ALTER TABLE inventory
    ADD UNIQUE KEY uq_inventory_item_wh_sec (item_index, warehouse_index, section_index);