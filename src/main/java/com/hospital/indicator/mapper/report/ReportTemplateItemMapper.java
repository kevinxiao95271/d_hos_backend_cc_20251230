package com.hospital.indicator.mapper.report;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hospital.indicator.entity.report.ReportTemplateItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ReportTemplateItemMapper extends BaseMapper<ReportTemplateItem> {

    List<ReportTemplateItem> listByTemplateId(@Param("templateId") Long templateId);
}
