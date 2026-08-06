package com.hospital.indicator.entity.dataentry;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("t_manual_data")
@Schema(description = "手工补录病历数据")
public class ManualData implements Serializable {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "病案号 (对应d_mr.A48)")
    @TableField("case_no")
    private String caseNo;

    @Schema(description = "住院次数 (对应d_mr.A49)")
    @TableField("admission_seq")
    private String admissionSeq;

    @Schema(description = "姓名")
    @TableField("patient_name")
    private String patientName;

    @Schema(description = "性别")
    @TableField("gender")
    private String gender;

    @Schema(description = "年龄")
    @TableField("age")
    private Integer age;

    @Schema(description = "入院时间")
    @TableField("admission_date")
    private String admissionDate;

    @Schema(description = "出院时间")
    @TableField("discharge_date")
    private String dischargeDate;

    @Schema(description = "住院天数")
    @TableField("hospital_days")
    private Integer hospitalDays;

    @Schema(description = "科室编码")
    @TableField("dept_code")
    private String deptCode;

    @Schema(description = "科室名称")
    @TableField("dept_name")
    private String deptName;

    @Schema(description = "主诊断编码")
    @TableField("main_diagnosis_code")
    private String mainDiagnosisCode;

    @Schema(description = "主诊断名称")
    @TableField("main_diagnosis_name")
    private String mainDiagnosisName;

    @Schema(description = "其他诊断1")
    @TableField("other_diagnosis_1")
    private String otherDiagnosis1;

    @Schema(description = "其他诊断2")
    @TableField("other_diagnosis_2")
    private String otherDiagnosis2;

    @Schema(description = "总费用")
    @TableField("total_cost")
    private BigDecimal totalCost;

    @Schema(description = "数据来源")
    @TableField("data_source")
    private String dataSource;

    @Schema(description = "录入人")
    @TableField("created_by")
    private String createdBy;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
