package com.ssg.wms.warehouse.controller;

import com.ssg.wms.warehouse.domain.WarehouseSaveDTO;
import com.ssg.wms.warehouse.domain.WarehouseUpdateDTO;
import com.ssg.wms.warehouse.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.function.Supplier;

@RestController
@RequiredArgsConstructor
@Log4j2
@RequestMapping("/api/warehouse")
public class WarehouseRestController {
    private final WarehouseService warehouseService;

    // 권한 체크
    private ResponseEntity<String> checkAdminPermission(String role) {
        if (role == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        if (!"ADMIN".equals(role)) return ResponseEntity.status(HttpStatus.FORBIDDEN).body("권한이 없습니다.");
        return null;
    }

    private ResponseEntity<String> executeProcess(String role, Supplier<Boolean> action,
                                                  String successMsg, String failMsg) {
        // 권한 체크
        ResponseEntity<String> permissionCheck = checkAdminPermission(role);
        if (permissionCheck != null) return permissionCheck;

        // 로직 실행 및 예외 처리
        try {
            boolean result = action.get();
            return result ? ResponseEntity.ok(successMsg)
                    : ResponseEntity.badRequest().body(failMsg);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            log.error("API 실행 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류 발생");
        }
    }

    // 창고 등록
    @PostMapping(produces = "text/plain; charset=UTF-8")
    public ResponseEntity<String> registerWarehouse(
            @SessionAttribute(value = "loginAdminRole", required = false) String role,
            @RequestBody WarehouseSaveDTO warehouseSaveDTO) {

        return executeProcess(role,
                () -> warehouseService.registerWarehouse(warehouseSaveDTO),
                "창고 등록 완료", "창고 등록 실패");
    }

    // 창고 수정
    @PutMapping(value = "/{id}", produces = "text/plain; charset=UTF-8")
    public ResponseEntity<String> updateWarehouse(
            @PathVariable Long id,
            @RequestBody WarehouseUpdateDTO warehouseUpdateDTO,
            @SessionAttribute(value = "loginAdminRole", required = false) String role) {

        return executeProcess(role, () -> {
            warehouseUpdateDTO.setWIndex(id); // ID 설정
            return warehouseService.modifyWarehouse(warehouseUpdateDTO);
        }, "창고 수정 완료", "창고 수정 실패");
    }

    // 창고 삭제(논리적 폐쇄)
    @DeleteMapping(value = "/{id}", produces = "text/plain; charset=UTF-8")
    public ResponseEntity<String> deleteWarehouse(
            @PathVariable Long id,
            @SessionAttribute(value = "loginAdminRole", required = false) String role) {

        return executeProcess(role,
                () -> warehouseService.removeWarehouse(id),
                "창고 폐쇄 완료", "창고 폐쇄 실패");
    }
}
