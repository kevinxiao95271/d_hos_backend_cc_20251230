package com.hospital.indicator.service.dataentry;

import com.hospital.indicator.dto.dataentry.ManualDataSaveDTO;

public interface ManualDataService {

    /**
     * 保存补录数据（包含去重校验）
     * @param dto 补录数据
     * @return 保存后的记录ID
     */
    Long save(ManualDataSaveDTO dto);

    /**
     * 检查是否存在于 d_mr
     */
    boolean existsInDMR(String caseNo, String admissionSeq);

    /**
     * 检查是否已补录
     */
    boolean existsInManual(String caseNo, String admissionSeq);
}
