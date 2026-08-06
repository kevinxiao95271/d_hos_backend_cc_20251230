package com.hospital.indicator.dto.dataentry;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import java.math.BigDecimal;

@Data
@Schema(description = "病历数据补录DTO")
public class ManualDataSaveDTO {

    @NotBlank(message = "病案号不能为空")
    @Schema(description = "病案号 (对应d_mr.A48)")
    private String caseNo;

    @NotBlank(message = "住院次数不能为空")
    @Schema(description = "住院次数 (对应d_mr.A49)")
    private String admissionSeq;

    @Schema(description = "姓名")
    private String patientName;

    @Schema(description = "性别")
    private String gender;

    @Schema(description = "年龄")
    private Integer age;

    @Schema(description = "入院时间")
    private String admissionDate;

    @NotBlank(message = "出院时间不能为空")
    @Schema(description = "出院时间 (必填)")
    private String dischargeDate;

    @Schema(description = "住院天数")
    private Integer hospitalDays;

    @NotBlank(message = "科室编码不能为空")
    @Schema(description = "科室编码")
    private String deptCode;

    @Schema(description = "科室名称")
    private String deptName;

    @Schema(description = "主诊断编码")
    private String mainDiagnosisCode;

    @Schema(description = "主诊断名称")
    private String mainDiagnosisName;

    @Schema(description = "总费用")
    private BigDecimal totalCost;
}
