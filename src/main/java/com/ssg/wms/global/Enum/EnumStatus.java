package com.ssg.wms.global.Enum;

public enum EnumStatus implements DBValueEnum {
    APPROVED("APPROVED"),
    PENDING("PENDING"),
    REJECTED("REJECTED"),

    ANSWERED("ANSWERED"),
    WORKING("WORKING"),

    EXIST("EXIST"),
    DELETED("DELETED"),

    OFFLINE("OFFLINE"),
    ONLINE("ONLINE"),

    IN_TRANSIT("IN_TRANSIT"),
    DELIVERED("DELIVERED"),

    ADMIN("ADMIN"),
    USER("USER"),

    MASTER("MASTER");


    private String dbValue;
    EnumStatus(String dbValue) {
        this.dbValue = dbValue;
    }

    @Override
    public String getDBValue() {
        return dbValue;
    }

    public static EnumStatus fromDb(String value) {
        for (EnumStatus s : values()) if (s.dbValue.equals(value)) return s;
        throw new IllegalArgumentException("Unknown UserStatus db value: " + value);
    }

}
