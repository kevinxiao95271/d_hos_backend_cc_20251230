package com.hospital.indicator.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.Map;

/**
 * 指标项执行查询结果DTO
 *
 * @author Claude
 * @date 2025-12-30
 */
@Data
@Schema(description = "指标项执行查询结果DTO")
public class IndicatorItemExecuteResultDTO {

    @Schema(description = "是否执行成功")
    private Boolean success;

    @Schema(description = "查询结果（包含result_value等字段）")
    private Map<String, Object> result;

    @Schema(description = "实际执行的SQL语句")
    private String querySql;

    @Schema(description = "错误信息（失败时返回）")
    private String errorMessage;

}
