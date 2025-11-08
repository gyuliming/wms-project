package com.ssg.wms.outbound.mappers;

import com.ssg.wms.admin.domain.AdminDTO;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.outbound.domain.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OutboundMapper {
    int	insertOutboundRequest ( OutboundRequestDTO outboundRequestDTO );
    int updateOutboundRequest ( OutboundRequestDTO outboundRequestDTO );
    int	deleteOutboundRequest ( Long or_index );
    OutboundRequestDTO selectOutboundRequest ( Long or_index );
    int updateOutboundResponse ( OutboundRequestDTO outboundRequestDTO );
    List<OutboundRequestDTO>	selectOutbountRequestList ( @Param("cri") Criteria criteria, @Param("search") OutboundSearchDTO outboundSearchDTO );
    int selectOutboundRequestTotalCount( @Param("search") OutboundSearchDTO outboundSearchDTO );


    List<ShippingInstructionDTO> selectShippingInstructionList (@Param("cri") Criteria criteria, @Param("search") OutboundSearchDTO outboundSearchDTO );
    int selectShippingInstructionTotalCount( @Param("search") OutboundSearchDTO outboundSearchDTO );
    ShippingInstructionDTO selectShippingInstruction ( Long si_index );
    int insertShippingInstruction ( ShippingInstructionDTO shippingInstructionDTO );
    int updateShippingInstruction ( ShippingInstructionDTO shippingInstructionDTO );
    int deleteShippingInstruction ( Long si_index );


    //List<VehicleDTO> selectVehicleList (OutboundRequestDTO outboundRequestDTO );
    List<VehicleDTO> selectVehicleList(Long or_index);
    int selectUsedVolumeOfVehicle(Long vehicle_index);


    int insertDispatch ( DispatchDTO dispatchDTO );
    DispatchDTO	selectDispatch ( Long or_index );
    int updateDispatch ( DispatchDTO dispatchDTO );
    int deleteDispatch ( Long dispatch_index );


    int	insertWaybill ( WaybillDTO waybillDTO );
    int	updateWaybill ( WaybillDTO waybillDTO );
    WaybillDTO selectWaybill ( Long si_index );


    int insertVehicle ( VehicleDTO vehicleDTO );
    int updateVehicle ( VehicleDTO vehicleDTO );
    int deleteVehicle( Long vehicle_index );


    int insertVehicleLocation ( VehicleLocationDTO vehicleLocationDTO );
    int updateVehicleLocation ( VehicleLocationDTO vehicleLocationDTO );
    int deleteVehicleLocation( Long vl_index );


    /*
    * 타 기능에서 필요한 mapper 들
    *
    * Inventory Mapper
    *
    * int selectTotalStockByUserAndItem(@Param("user_index") Long user_index, @Param("item_index") Long item_index);
    *
    * */
}
