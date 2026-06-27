package com.hospital.indicator.mapper.report;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hospital.indicator.entity.report.ReportTask;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ReportTaskMapper extends BaseMapper<ReportTask> {

    IPage<ReportTask> pageByCondition(Page<ReportTask> page,
                                     @Param("name") String name,
                                     @Param("status") String status,
                                     @Param("timeDimension") String timeDimension);
}
