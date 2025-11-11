package com.ssg.wms.inventory.controller;

import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.inventory.domain.InvenItemViewDTO;
import com.ssg.wms.inventory.service.InvenService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.EnumSet;
import java.util.List;
import java.util.Set;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/api/inventory")
public class InventoryController {

    private static final Set<String> ITEM_CATEGORIES =
            Set.of("HEALTH","BEAUTY","PERFUME","CARE","FOOD");

    private final InvenService inventoryService;

    @GetMapping
    public List<InvenItemViewDTO> getInventory(
            @RequestParam(name = "category", required = false) String category
    ) {
        if (category == null) {
            return inventoryService.getInventoryAll();
        }
        String normalized = category.toUpperCase();
        if (!ITEM_CATEGORIES.contains(normalized)) {
            throw new InvalidCategoryException("category must be one of: " + ITEM_CATEGORIES);
        }
        return inventoryService.getInventoryByCategory(normalized);
    }

    @GetMapping("/category/{category}")
    public List<InvenItemViewDTO> getInventoryByCategoryPath(@PathVariable String category) {
        String normalized = category.toUpperCase();
        if (!ITEM_CATEGORIES.contains(normalized)) {
            throw new InvalidCategoryException("category must be one of: " + ITEM_CATEGORIES);
        }
        return inventoryService.getInventoryByCategory(normalized);
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(InvalidCategoryException.class)
    public String handleInvalidCategory(InvalidCategoryException e) {
        return e.getMessage();
    }

    static class InvalidCategoryException extends RuntimeException {
        public InvalidCategoryException(String msg) { super(msg); }
    }
}