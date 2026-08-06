package com.hospital.indicator.controller;

import com.hospital.indicator.common.Result;
import com.hospital.indicator.dto.dataentry.ManualDataSaveDTO;
import com.hospital.indicator.service.dataentry.ManualDataService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.*;

/**
 * 数据补录管理接口
 */
@Tag(name = "数据补录管理", description = "病历数据手工补录")
@RestController
@RequestMapping("/api/data-entry")
@RequiredArgsConstructor
public class DataEntryController {

    private final ManualDataService manualDataService;

    @Operation(summary = "保存补录数据")
    @PostMapping("/save")
    public Result<Map<String, Object>> save(@RequestBody @Valid ManualDataSaveDTO dto) {
        String caseNo = dto.getCaseNo();
        String admissionSeq = dto.getAdmissionSeq();

        // 1. 检查 d_mr 是否已有（拒绝补录）
        boolean existsInDMR = manualDataService.existsInDMR(caseNo, admissionSeq);
        if (existsInDMR) {
            return Result.error(4002,
                String.format("病案号 %s 的第 %s 次住院记录已存在于 HIS 数据中，无法补录。如需修正数据，请联系 HIS 管理员",
                    caseNo, admissionSeq));
        }

        // 2. 检查 t_manual_data 是否已补录（拒绝重复）
        boolean existsInManual = manualDataService.existsInManual(caseNo, admissionSeq);
        if (existsInManual) {
            return Result.error(4001,
                String.format("病案号 %s 的第 %s 次住院记录已补录，不可重复", caseNo, admissionSeq));
        }

        // 3. 保存
        try {
            Long id = manualDataService.save(dto);
            Map<String, Object> result = new LinkedHashMap<>();
            result.put("id", id);
            result.put("message", "补录成功，下次指标计算将包含此数据");
            return Result.success(result);
        } catch (DuplicateKeyException e) {
            return Result.error(4001,
                String.format("病案号 %s 的第 %s 次住院记录已存在", caseNo, admissionSeq));
        }
    }

    @Operation(summary = "数据填报列表（不分页）- 占位接口")
    @GetMapping("/list")
    public Result<List<Object>> list(
            @RequestParam(required = false) Long taskId,
            @RequestParam(required = false) Long deptId) {
        return Result.success(Collections.emptyList());
    }

    @Operation(summary = "数据填报列表（分页）- 占位接口")
    @GetMapping("/page")
    public Result<Map<String, Object>> page(
            @RequestParam(required = false) Long taskId,
            @RequestParam(required = false) Long deptId,
            @RequestParam(required = false, defaultValue = "1")  int current,
            @RequestParam(required = false, defaultValue = "10") int size) {
        Map<String, Object> paged = new LinkedHashMap<>();
        paged.put("records", Collections.emptyList());
        paged.put("total",   0);
        paged.put("pages",   0);
        paged.put("current", current);
        paged.put("size",    size);
        return Result.success(paged);
    }
}
