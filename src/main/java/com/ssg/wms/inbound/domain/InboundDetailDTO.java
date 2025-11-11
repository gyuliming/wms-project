package com.ssg.wms.inbound.domain;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InboundDetailDTO {

    // 입고 상세 기본 정보
    private Integer detailIndex;                    // 입고 상세 번호 (PK)
    private Long requestIndex;                      // 요청 번호 =
    private String qrCode;                          // QR 코드 값
    private Integer receivedQuantity;               // 실제 입고 수량
    private LocalDateTime completeDate;             // 실제 입고 일시
    private Long inboundIndex;
    private Long sectionIndex;

}