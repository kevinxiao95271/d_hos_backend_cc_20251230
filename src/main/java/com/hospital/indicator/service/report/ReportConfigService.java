package com.hospital.indicator.service.report;

import com.hospital.indicator.dto.report.ReportConfigDTO;
import com.hospital.indicator.entity.report.ReportConfig;

public interface ReportConfigService {

    /** 获取全局填报配置（始终返回第一行） */
    ReportConfig getConfig();

    /** 更新全局填报配置 */
    ReportConfig updateConfig(ReportConfigDTO dto, String operator);
}
