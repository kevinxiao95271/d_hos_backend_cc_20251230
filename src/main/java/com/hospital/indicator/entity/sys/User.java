package com.hospital.indicator.entity.sys;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 用户实体类
 */
@Data
@TableName("sys_user")
@Schema(description = "用户")
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "user_id", type = IdType.AUTO)
    private Long userId;

    @TableField("username")
    private String username;

    @JsonIgnore
    @TableField("password")
    private String password;

    @TableField("real_name")
    private String realName;

    @TableField("dept_id")
    private Long deptId;

    @TableField("role_id")
    private Long roleId;

    @TableField("data_scope")
    private Integer dataScope;

    @TableField("business_direction_preference")
    private String businessDirectionPreference;

    @TableField("status")
    private String status;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
