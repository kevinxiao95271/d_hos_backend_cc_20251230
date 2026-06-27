package com.hospital.indicator.mapper.report;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hospital.indicator.entity.report.ReportData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ReportDataMapper extends BaseMapper<ReportData> {

    List<ReportData> listByTaskAndDept(@Param("taskId") Long taskId,
                                       @Param("deptId") Long deptId);

    List<ReportData> listByTaskAndMetric(@Param("taskId") Long taskId,
                                         @Param("metricCode") String metricCode);

    void deleteByTaskAndDeptAndMetric(@Param("taskId") Long taskId,
                                      @Param("deptId") Long deptId,
                                      @Param("metricCode") String metricCode);
}
