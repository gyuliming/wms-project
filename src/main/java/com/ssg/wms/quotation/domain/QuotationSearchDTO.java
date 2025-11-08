package com.ssg.wms.quotation.domain;

import java.time.LocalDate;

public class QuotationSearchDTO {
    private LocalDate start_date;
    private LocalDate end_date;
    private String qrequest_status;
    private String sort;
    private String type;
    private String keyword;
}
