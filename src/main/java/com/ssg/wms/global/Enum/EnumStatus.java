package com.ssg.wms.global.Enum;

public enum EnumStatus implements DBValueEnum {
    APPROVED("승인"),
    PENDING("대기"),
    REJECTED("거절"),

    ANSWERED("답변완료"),
    WORKING("작업중"),

    EXIST("존재"),
    DELETED("삭제"),

    OFFLINE("오프라인"),
    ONLINE("온라인"),

    IN_TRANSIT("배송중"),
    DELIVERED("배송완료"),

    ADMIN("관리자"),
    USER("회원"),

    MASTER("마스터");


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
