package com.hospital.indicator.service.report;

import com.hospital.indicator.dto.report.FillSheetVO;
import com.hospital.indicator.dto.report.ReportDataSaveDTO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public interface ReportDataService {

    /** 获取科室填报页面数据（含已填内容） */
    FillSheetVO getFillSheet(Long taskId, Long deptId);

    /** 科室保存/更新某个指标的填报数据（草稿，可反复保存） */
    void saveOrUpdateItemData(ReportDataSaveDTO dto);

    /** 科室提交填报（整个任务-科室维度提交） */
    void submitFill(Long taskId, Long deptId);

    /** 导入Excel回填数据（科室上传已填写的模板） */
    void importFromExcel(Long taskId, Long deptId, HttpServletRequest request) throws IOException;

    /** 导出已审核通过的填报结果（管理员用） */
    void exportApprovedData(Long taskId, HttpServletResponse response) throws IOException;
}
