package com.ssg.wms.warehouse.controller;

import com.ssg.wms.admin.domain.AdminDTO;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.global.domain.PageDTO;
import com.ssg.wms.warehouse.domain.WarehouseDTO;
import com.ssg.wms.warehouse.domain.WarehouseSaveDTO;
import com.ssg.wms.warehouse.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/warehouse")
public class WarehouseController {
    private final WarehouseService warehouseService;

    // 권한 체크(ADMIN or MASTER)
    private String checkReadPermission(String role, RedirectAttributes rttr) {
        if (role == null) return "redirect:/login/loginForm";
        if (!"ADMIN".equals(role) && !"MASTER".equals(role)) {
            rttr.addFlashAttribute("msg", "접근 권한이 없습니다.");
            return "redirect:/login/loginForm";
        }
        return null;
    }

    // 권한 체크(ONLY ADMIN)
    private String checkWritePermission(String role, RedirectAttributes rttr) {
        if (role == null) return "redirect:/login/loginForm";
        if (!"ADMIN".equals(role)) {
            rttr.addFlashAttribute("accessDenied", "접근 권한이 없습니다. (총 관리자 전용)");
            return "redirect:/warehouse/list";
        }
        return null;
    }

    // 창고 조회 시, 필터 조건 검색창, 창고 리스트, 지도 화면 출력 페이지
    // 요청 : /warehouses/list
    // /WEB-INF/views/warehouse/list.jsp
    @GetMapping("/list")
    public String getWarehouses(@ModelAttribute("cri") Criteria cri,
                                @RequestParam(value = "typeStr", required = false, defaultValue = "") String typeStr,
                                @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
                                @SessionAttribute(value = "loginAdminRole", required = false) String role,
                                RedirectAttributes rttr,
                                Model model) {

        // 권한 체크
        String redirect = checkReadPermission(role, rttr);
        if (redirect != null) return redirect;

        model.addAttribute("warehouses", warehouseService.getList(cri));
        model.addAttribute("pageMaker", new PageDTO(cri, warehouseService.getTotal(cri)));

        return "warehouse/list";
    }

    // 상세 조회 페이지
    // 요청 : /warehouses/{id}
    // /WEB-INF/views/warehouse/detail.jsp
    @GetMapping("/{id}")
    public String getWarehouse(@PathVariable Long id,
                               @SessionAttribute(value = "loginAdminRole", required = false) String role,
                               RedirectAttributes rttr,
                               Model model) {
        // 권한 체크
        String redirect = checkReadPermission(role, rttr);
        if (redirect != null) return redirect;

        model.addAttribute("warehouse", warehouseService.getWarehouse(id));
        return "warehouse/detail";
    }

    // 창고 수정 폼 페이지
    // 요청 : /warehouse/{id}/update
    // /WEB-INF/views/warehouse/updateForm
    @GetMapping("/{id}/update")
    public String updateWarehouseForm(@PathVariable Long id,
                                      @SessionAttribute(value = "loginAdminRole", required = false) String role,
                                      RedirectAttributes rttr,
                                      Model model) {
        // 권한 체크(ONLY ADMIN)
        String redirect = checkWritePermission(role, rttr);
        if (redirect != null) return redirect;

        WarehouseDTO dto = warehouseService.getWarehouse(id);
        model.addAttribute("id", dto.getWIndex());
        model.addAttribute("warehouse", dto);
        return "warehouse/updateForm";
    }

    // 창고 등록 폼 페이지
    // 요청 : /warehouse/register
    // /WEB-INF/views/warehouse/register
    @GetMapping("/register")
    public String registerWarehouseForm(Model model,
                                        @SessionAttribute(value = "loginAdminRole", required = false) String role,
                                        RedirectAttributes rttr) {

        // 권한 체크(ONLY ADMIN)
        String redirect = checkWritePermission(role, rttr);
        if (redirect != null) return redirect;

        // 배정 가능한 관리자 목록을 가져와서 JSP로 전달
        List<AdminDTO> masters = warehouseService.getAvailableMasterList();
        model.addAttribute("masters", masters);

        model.addAttribute("warehouse", new WarehouseSaveDTO());
        return "warehouse/registerForm";
    }
}
