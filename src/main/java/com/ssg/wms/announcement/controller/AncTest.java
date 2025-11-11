package com.ssg.wms.announcement.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * JSP 테스트용 Controller
 */
@Controller
@RequestMapping("/announcement")
public class AncTest {

    // ============================================
    // 공지사항 (Notice)
    // ============================================

    @GetMapping("/notices/list")
    public String noticeList() {
        return "announcement/notice/list";
    }

    @GetMapping("/notices/detail")
    public String noticeDetail() {
        return "announcement/notice/detail";
    }

    // ============================================
    // 1:1 문의 (OneToOne)
    // ============================================

    @GetMapping("/onetoone/register")
    public String onetoonRegister() {
        return "announcement/onetoone/register";
    }

    @GetMapping("/onetoone/mylist")
    public String onetooneMyList() {
        return "announcement/onetoone/myList";
    }

    @GetMapping("/onetoone/detail")
    public String onetooneDetail() {
        return "announcement/onetoone/detail";
    }

    // ============================================
    // 게시판 (Board)
    // ============================================

    @GetMapping("/board/list")
    public String boardList() {
        return "announcement/board/list";
    }

    @GetMapping("/board/detail")
    public String boardDetail() {
        return "announcement/board/detail";
    }

    @GetMapping("/board/register")
    public String boardRegister() {
        return "announcement/board/register";
    }
}