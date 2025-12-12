package com.ssg.wms.warehouse.service;

import com.ssg.wms.admin.domain.AdminDTO;
import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.warehouse.domain.*;
import com.ssg.wms.warehouse.mappers.SectionMapper;
import com.ssg.wms.warehouse.mappers.WarehouseMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class WarehouseServiceImpl implements WarehouseService {
    private final WarehouseMapper warehouseMapper;
    private final SectionMapper sectionMapper;
    private static final int BOXES_PER_PALLET = 50; // 1팔레트 = 50박스

    @Override
    public List<WarehouseDTO> getList(Criteria cri) {
        return warehouseMapper.getList(cri);
    }

    @Override
    public int getTotal(Criteria cri) {
        return warehouseMapper.getTotal(cri);
    }

    @Transactional
    @Override
    public boolean registerWarehouse(WarehouseSaveDTO warehouseSaveDTO) {

        // 중복 검사 (이름 or 주소)
        int duplicateCount = warehouseMapper.isDuplicate(
                warehouseSaveDTO.getWName(),
                warehouseSaveDTO.getWAddress()
        );

        if (duplicateCount > 0) {
            throw new IllegalArgumentException("동일한 이름 또는 주소의 창고가 이미 존재합니다.");
        }

        // 창고 code 생성 -> 1부터시작
        int warehouseCodeNum =  warehouseMapper.getNextCode();
        WarehouseDTO warehouseDTO = WarehouseDTO.builder()
                .wCode(warehouseCodeNum)
                .wName(warehouseSaveDTO.getWName())
                .wSize(warehouseSaveDTO.getWSize())
                .wLocation(warehouseSaveDTO.getWLocation())
                .wAddress(warehouseSaveDTO.getWAddress())
                .wZipcode(warehouseSaveDTO.getWZipcode())
                .wMasterId(warehouseSaveDTO.getWMasterId())
                .wStatus(EnumStatus.NORMAL)
                .build();

        warehouseMapper.insertWarehouse(warehouseDTO);

        return true;
    }

    // 관리자 목록 조회
    @Override
    public List<AdminDTO> getAvailableMasterList() {
        return warehouseMapper.getAvailableMasters();
    }

    @Transactional
    public void addSection(Long wIndex, SectionDTO sectionDTO) {
        WarehouseDTO warehouse = warehouseMapper.findWarehouse(wIndex);
        if (warehouse == null) {
            throw new IllegalArgumentException("창고가 존재하지 않습니다.");
        }

        // 이름 중복 검사
        int dupCount = sectionMapper.checkDuplicateSectionName(wIndex, sectionDTO.getSName());
        if (dupCount > 0) {
            throw new IllegalArgumentException("이미 존재하는 구역 이름입니다: " + sectionDTO.getSName());
        }

        // 용량 제한 검증
        int currentUsed = sectionMapper.getCurrentTotalCapacity(wIndex);
        int newCapacity = sectionDTO.getPalletCount() * BOXES_PER_PALLET;

        if (currentUsed + newCapacity > warehouse.getWSize()) {
            int remain = warehouse.getWSize() - currentUsed;
            int remainPallet = remain / BOXES_PER_PALLET;
            throw new IllegalArgumentException(
                    "창고 용량을 초과했습니다. (잔여: " + remainPallet + " 팔레트)"
            );
        }

        // 섹션 등록
        List<SectionDTO> sectionList = sectionMapper.getSectionsWithUsage(wIndex);

        int nextCode;
        if (sectionList.isEmpty()) {
            nextCode = warehouse.getWCode() * 100 + 1;
        } else {
            int maxCode = sectionList.stream()
                    .mapToInt(SectionDTO::getSCode)
                    .max()
                    .orElse(warehouse.getWCode() * 100);
            nextCode = maxCode + 1;
        }

        int sectionCode = nextCode;

        SectionDTO section = SectionDTO.builder()
                .wIndex(wIndex)
                .sCode(sectionCode)
                .sName(sectionDTO.getSName())
                .sCapacity(newCapacity)
                .sType(sectionDTO.getSType())
                .build();

        sectionMapper.insertSection(section);
    }

    @Transactional
    @Override
    public boolean modifyWarehouse(WarehouseUpdateDTO warehouseUpdateDTO) {
        WarehouseDTO exist = warehouseMapper.findWarehouse(warehouseUpdateDTO.getWIndex());
        if (exist == null) return false;

        String address = warehouseUpdateDTO.getWAddress();
        if (address != null && address.contains(" ")) {
            String location = address.substring(0, address.indexOf(" "));
            warehouseUpdateDTO.setWLocation(location);
        }

        WarehouseDTO dto = WarehouseDTO.builder()
                .wIndex(warehouseUpdateDTO.getWIndex())
                .wName(warehouseUpdateDTO.getWName())
                .wLocation(warehouseUpdateDTO.getWLocation())
                .wAddress(warehouseUpdateDTO.getWAddress())
                .wZipcode(warehouseUpdateDTO.getWZipcode())
                .wStatus(warehouseUpdateDTO.getWStatus())
                .build();

        int result = warehouseMapper.updateWarehouse(dto);

        return result == 1;
    }

    @Transactional
    @Override
    public boolean removeWarehouse(Long wIndex) {
        WarehouseDTO exist = warehouseMapper.findWarehouse(wIndex);
        if (exist == null) return false;
        int result = warehouseMapper.deactiveWarehouse(wIndex);
        return result == 1;
    }

    @Override
    public WarehouseDTO getWarehouse(Long wIndex) {
        WarehouseDTO warehouseDTO = warehouseMapper.findWarehouse(wIndex);
        if (warehouseDTO == null) {
            throw new IllegalArgumentException("존재하지 않는 창고입니다.");
        }

        // 섹션 리스트 조회
        List<SectionDTO> sectionList = sectionMapper.getSectionsWithUsage(wIndex);

        // 등록된 구역들의 용량 합계 계산
        int totalSectionCapacity = sectionList.stream()
                .mapToInt(SectionDTO::getSCapacity)
                .sum();

        warehouseDTO.setTotalSectionCapacity(totalSectionCapacity);
        warehouseDTO.setSections(sectionList);

        return warehouseDTO;
    }

}
