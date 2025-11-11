package com.ssg.wms.inbound.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/inbound")
public class InboundView {
    // JSP 뷰 반환 메서드 (화면 이동)
    /** 입고 요청 등록 화면 */
    @GetMapping("/register")
    public String showInboundRegisterForm() {
        return "inbound/register";
    }

    /** 입고 요청 목록 화면 */
    @GetMapping("/list")
    public String showInboundList() {
        return "inbound/list";
    }

    /** 입고 요청 상세 화면 */
    @GetMapping("/detail/{inbound_index}")
    public String showInboundDetail(@PathVariable("inbound_index") Long inboundIndex, Model model) {
        model.addAttribute("inboundIndex", inboundIndex);
        return "inbound/detail";
    }

    /** QR 조회 화면 */
    @GetMapping("/qr")
    public String showQrSearch() {
        return "inbound/qr";
    }

    /** 관리자 입고 관리 화면 */
    @GetMapping("/Form")
    public String showAdminInbound() {
        // 실제 View 경로가 admin/inbound/list라고 가정하고 반환합니다.
        return "inbound/Form";
    }
}