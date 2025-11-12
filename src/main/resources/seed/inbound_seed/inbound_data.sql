-- 4. inbound_request 테이블 데이터 (5개 항목 삽입)

INSERT INTO inbound_request (inbound_index, inbound_receive_quantity, planned_receive_date, approval_status, user_index, warehouse_index, item_index, inbound_request_date)
VALUES
    (10001, 300, '2025-12-01', 'PENDING', 1, 1, 1, '2025-11-10 10:00:00'),
    (10002, 150, '2025-11-20', 'APPROVED', 2, 2, 3, '2025-11-11 12:00:00'),
    (10003, 80, '2025-11-10', 'APPROVED', 3, 1, 2, '2025-11-08 09:00:00'),
    (10004, 200, '2025-12-05', 'REJECTED', 4, 3, 4, '2025-11-10 15:00:00'),
    (10005, 50, '2025-11-25', 'CANCELED', 5, 2, 5, '2025-11-11 18:00:00');


-- 상세 필드 업데이트
UPDATE inbound_request SET approve_date = '2025-11-11 15:00:00' WHERE inbound_index IN (10002, 10003);
UPDATE inbound_request SET cancel_reason = '재고 부족으로 인한 거부' WHERE inbound_index = 10004;
UPDATE inbound_request SET cancel_reason = '상품 모델 변경으로 인한 취소' WHERE inbound_index = 10005;


-- 5. inbound_detail 테이블 데이터 (5개 항목 삽입)

INSERT INTO inbound_detail (detail_index, request_index, qr_code, received_quantity, complete_date, inbound_index, warehouse_index, section_index)
VALUES
    (1, 10002, 'INB-QR-A9F43', 0, NULL, 10002, 2, 10),
    (2, 10002, 'INB-QR-B8E54', 0, NULL, 10002, 2, 20),
    (3, 10003, 'INB-QR-C7D65', 50, '2025-11-10 11:30:00', 10003, 1, 30),
    (4, 10003, 'INB-QR-D6C78', 30, '2025-11-10 11:45:00', 10003, 1, 10),
    (5, 10002, 'INB-QR-E7G65', 0, NULL, 10002, 2, 10);

