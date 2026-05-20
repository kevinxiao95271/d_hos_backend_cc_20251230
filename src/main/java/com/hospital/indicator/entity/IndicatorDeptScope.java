package com.hospital.indicator.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 指标科室可见范围绑定实体
 */
@Data
@TableName("t_indicator_dept_scope")
@Schema(description = "指标-科室可见范围绑定")
public class IndicatorDeptScope {

    @TableId(type = IdType.AUTO)
    @Schema(description = "主键ID")
    private Long id;

    @Schema(description = "指标编码")
    private String metricCode;

    @Schema(description = "科室ID（根科室）")
    private Long rootDeptId;

    @Schema(description = "是否主负责科室：1-是，0-否")
    private Integer isPrimaryOwner;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
