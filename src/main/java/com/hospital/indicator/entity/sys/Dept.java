package com.hospital.indicator.entity.sys;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 科室实体类
 */
@Data
@TableName("sys_dept")
@Schema(description = "科室")
public class Dept implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "dept_id", type = IdType.AUTO)
    private Long deptId;

    @TableField("dept_code")
    private String deptCode;

    @TableField("dept_name")
    private String deptName;

    @TableField("parent_id")
    private Long parentId;

    @TableField("dept_level")
    private Integer deptLevel;

    @TableField("dept_type")
    private String deptType;

    @TableField("is_mgmt_dept")
    private Integer isMgmtDept;

    @TableField("default_business_direction")
    private String defaultBusinessDirection;

    @TableField("std_dept_code")
    private String stdDeptCode;

    @TableField("status")
    private String status;

    @TableField("sort_order")
    private Integer sortOrder;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
