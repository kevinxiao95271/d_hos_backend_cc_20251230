package com.hospital.indicator.service.report;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.hospital.indicator.dto.report.*;
import com.hospital.indicator.entity.report.ReportTask;

import com.hospital.indicator.dto.report.MyTaskVO;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public interface ReportTaskService {

    /** 创建任务（含科室分配） */
    ReportTask createTask(ReportTaskCreateDTO dto, String operator);

    /** 从模板一键下发：复用模板中的科室-指标分配 */
    ReportTask createFromTemplate(Long templateId, ReportTaskCreateDTO baseInfo, String operator);

    /** 查询任务列表（分页） */
    IPage<ReportTask> pageTask(int current, int size, String name, String status, String timeDimension);

    /** 查询任务详情（含科室范围） */
    ReportTaskDetailVO getTaskDetail(Long taskId);

    /** 发布任务（DRAFT → PUBLISHED） */
    void publishTask(Long taskId, String operator);

    /** 关闭任务（PUBLISHED → CLOSED） */
    void closeTask(Long taskId, String operator);

    /** 将当前任务的分配关系另存为模板 */
    Long saveAsTemplate(Long taskId, String templateName, String operator);

    /** 获取所有可用模板列表 */
    List<ReportTaskDetailVO.ScopeVO> listTemplateScopes(Long templateId);

    /** 管理员审核科室填报 */
    void reviewDeptFill(ReviewActionDTO dto, String reviewer);

    /** 填报人员查看本科室所有待办/进行中任务 */
    List<MyTaskVO> getMyTasks(Long deptId);

    /** 导出填报模板（空白） */
    void exportFillTemplate(Long taskId, Long deptId, HttpServletResponse response) throws IOException;
}
