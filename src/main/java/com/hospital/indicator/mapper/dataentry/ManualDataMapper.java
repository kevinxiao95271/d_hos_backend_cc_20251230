package com.hospital.indicator.mapper.dataentry;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hospital.indicator.entity.dataentry.ManualData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface ManualDataMapper extends BaseMapper<ManualData> {

    /**
     * 检查 t_manual_data 中是否存在指定病案号+住院次数
     */
    @Select("SELECT EXISTS(SELECT 1 FROM t_manual_data WHERE case_no = #{caseNo} AND admission_seq = #{admissionSeq})")
    boolean existsInManual(@Param("caseNo") String caseNo, @Param("admissionSeq") String admissionSeq);

    /**
     * 检查 d_mr 中是否存在指定病案号+住院次数
     */
    @Select("SELECT EXISTS(SELECT 1 FROM d_mr WHERE A48 = #{caseNo} AND A49 = #{admissionSeq})")
    boolean existsInDMR(@Param("caseNo") String caseNo, @Param("admissionSeq") String admissionSeq);
}
