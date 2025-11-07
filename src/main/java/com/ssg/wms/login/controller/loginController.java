package com.ssg.wms.login.controller;

import com.ssg.wms.admin.service.AdminService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/login")
@Log4j2
@RequiredArgsConstructor
public class loginController {

    private final AdminService adminService;

    /** 로그인 폼 */
    @GetMapping("/loginForm")
    public void loginForm() {
    }

    /** 로그인 처리 */
    @PostMapping("/loginForm")
    public String doLogin(@RequestParam String adminId,
                          @RequestParam String adminPw,
                          HttpSession session,
                          RedirectAttributes rttr) {
        boolean ok = adminService.authenticate(adminId, adminPw);
        if (!ok) {
            rttr.addFlashAttribute("loginError", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "redirect:/admin/user_list";
        }
        session.setAttribute("loginAdminId", adminId);
        return "redirect:/admin/user_list";
    }

    /** 로그아웃 */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login/loginForm";
    }
}
