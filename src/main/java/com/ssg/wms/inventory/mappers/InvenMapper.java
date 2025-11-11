package com.ssg.wms.inventory.mappers;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.inventory.domain.InvenItemViewDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface InvenMapper {

    List<InvenItemViewDTO> selectInventoryPage(@Param("cri") Criteria cri);

    int selectInventoryTotal(@Param("cri") Criteria cri);

}
