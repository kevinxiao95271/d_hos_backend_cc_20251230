package com.hospital.indicator.mapper.report;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hospital.indicator.entity.report.ReportTaskScope;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ReportTaskScopeMapper extends BaseMapper<ReportTaskScope> {

    List<ReportTaskScope> listByTaskId(@Param("taskId") Long taskId);

    ReportTaskScope getByTaskAndDept(@Param("taskId") Long taskId, @Param("deptId") Long deptId);
}
