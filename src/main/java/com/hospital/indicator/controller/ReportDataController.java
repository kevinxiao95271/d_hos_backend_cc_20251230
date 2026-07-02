package com.hospital.indicator.controller;

import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.common.ErrorCode;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.dto.report.FillSheetVO;
import com.hospital.indicator.dto.report.ReportDataSaveDTO;
import com.hospital.indicator.service.report.ReportDataService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.IOException;

@Tag(name = "填报数据操作", description = "科室填报数据查看、保存、提交、导入导出")
@RestController
@RequestMapping("/api/report/data")
public class ReportDataController {

    @Autowired
    private ReportDataService dataService;

    @Operation(summary = "获取科室填报页面数据（指标+已填内容）")
    @GetMapping("/sheet")
    public Result<FillSheetVO> getFillSheet(
            @Parameter(description = "任务ID") @RequestParam Long taskId,
            @Parameter(description = "科室ID（不传则取当前登录科室）") @RequestParam(required = false) Long deptId) {
        Long effectiveDeptId = resolveDeptId(deptId);
        return Result.success(dataService.getFillSheet(taskId, effectiveDeptId));
    }

    @Operation(summary = "保存/更新某指标的填报数据（草稿，可反复调用）")
    @PostMapping("/save")
    public Result<Void> saveItemData(@RequestBody @Valid ReportDataSaveDTO dto) {
        dto.setDeptId(resolveDeptId(dto.getDeptId()));
        dataService.saveOrUpdateItemData(dto);
        return Result.success();
    }

    @Operation(summary = "科室提交填报（整个任务维度一次性提交）")
    @PostMapping("/submit")
    public Result<Void> submitFill(
            @Parameter(description = "任务ID") @RequestParam Long taskId,
            @Parameter(description = "科室ID（不传则取当前登录科室）") @RequestParam(required = false) Long deptId) {
        Long effectiveDeptId = resolveDeptId(deptId);
        dataService.submitFill(taskId, effectiveDeptId);
        return Result.success();
    }

    @Operation(summary = "导入Excel填报数据（科室上传已填写的模板）")
    @PostMapping("/import")
    public Result<Void> importFromExcel(
            @RequestParam Long taskId,
            @RequestParam(required = false) Long deptId,
            HttpServletRequest request) throws IOException {
        Long effectiveDeptId = resolveDeptId(deptId);
        dataService.importFromExcel(taskId, effectiveDeptId, request);
        return Result.success();
    }

    @Operation(summary = "导出已审核通过的填报结果（管理员用）")
    @GetMapping("/export-approved")
    public void exportApprovedData(
            @RequestParam Long taskId,
            HttpServletResponse response) throws IOException {
        dataService.exportApprovedData(taskId, response);
    }

    /**
     * 解析实际生效的 deptId，并做权限校验：
     * - dataScope=50（超管）：可指定任意 deptId，不传则用自身
     * - 其他角色：强制使用自身 deptId，传入其他 deptId 直接拒绝
     */
    private Long resolveDeptId(Long paramDeptId) {
        UserContext ctx = UserContext.get();
        if (ctx == null || ctx.getDeptId() == null) {
            throw new BusinessException("无法获取当前科室信息，请登录后重试");
        }
        Long myDeptId = ctx.getDeptId();
        Integer dataScope = ctx.getDataScope();
        // dataScope=50 才是超管（可跨科室），70/90 只能操作本科室
        boolean isAdmin = (dataScope != null && dataScope == 50);

        if (paramDeptId == null) {
            return myDeptId;
        }
        // 非超管：只能操作自己科室
        if (!isAdmin && !paramDeptId.equals(myDeptId)) {
            throw new BusinessException(ErrorCode.CROSS_DEPT_DENIED,
                    "无权访问其他科室的填报数据，当前科室ID=" + myDeptId + "，请求科室ID=" + paramDeptId);
        }
        return paramDeptId;
    }
}
