package com.hospital.indicator.entity.sys;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 菜单实体类
 */
@Data
@TableName("sys_menu")
@Schema(description = "菜单")
public class Menu implements Serializable {
    private static final long serialVersionUID = 1L;

    @TableId(value = "menu_id", type = IdType.AUTO)
    private Long menuId;

    @TableField("menu_name")
    private String menuName;

    @TableField("parent_id")
    private Long parentId;

    @TableField("order_num")
    private Integer orderNum;

    @TableField("path")
    private String path;

    @TableField("component")
    private String component;

    @TableField("is_frame")
    private Integer isFrame;

    @TableField("menu_type")
    private String menuType;

    @TableField("visible")
    private String visible;

    @TableField("status")
    private String status;

    @TableField("perms")
    private String perms;

    @TableField("icon")
    private String icon;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableField("remark")
    private String remark;
}
