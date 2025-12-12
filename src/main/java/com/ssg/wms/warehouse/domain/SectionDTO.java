package com.ssg.wms.warehouse.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SectionDTO {
    @JsonProperty("sIndex")
    private Long sIndex;

    @JsonProperty("sCode")
    private int sCode;

    @JsonProperty("sName")
    private String sName;

    @JsonProperty("sCapacity")
    private int sCapacity;

    @JsonProperty("wIndex")
    private Long wIndex;

    @JsonProperty("sType")
    private String sType;

    @JsonProperty("currentUsed")
    private int currentUsed;

    @JsonProperty("palletCount")
    private int palletCount;

    // 팔레트 단위 변환(1팔레트 = 50박스)
    public int getMaxPallet() {
        if (this.sCapacity > 0) {
            return this.sCapacity / 50;
        }
        return this.palletCount;
    }

    // 2. 현재 사용량 팔레트 환산
    public int getUsedPallet() {
        return this.currentUsed / 50;
    }

    // 3. 적재율 (%) 계산
    public int getUsageRate() {
        if (sCapacity == 0) return 0;
        return (int) Math.round((double) currentUsed / sCapacity * 100);
    }

    // 4. 상태 색상 (Bootstrap 클래스)
    public String getStatusColorClass() {
        int rate = getUsageRate();
        if (rate >= 90) return "bg-danger";   // 90% 이상 위험
        if (rate >= 70) return "bg-warning";  // 70% 이상 주의
        return "bg-success";                  // 그 외 양호
    }
}
