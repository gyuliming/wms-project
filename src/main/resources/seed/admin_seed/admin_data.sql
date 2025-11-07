use wms;

-- 마스터 1명 생성
INSERT INTO admin
(admin_name, admin_id, admin_pw, admin_role, admin_phone, admin_status)
VALUES
    ('시스템마스터', 'master',
     'master', -- 예시 해시
     '마스터', '010-0000-0000', '승인');


select * from admin;