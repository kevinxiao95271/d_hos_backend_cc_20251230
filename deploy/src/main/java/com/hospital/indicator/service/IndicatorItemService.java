package com.hospital.indicator.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.hospital.indicator.dto.IndicatorItemExecuteResultDTO;
import com.hospital.indicator.dto.IndicatorItemSaveDTO;
import com.hospital.indicator.entity.IndicatorItem;

import java.util.Map;

/**
 * 指标项服务接口
 *
 * @author Claude
 * @date 2025-12-30
 */
public interface IndicatorItemService extends IService<IndicatorItem> {

    /**
     * 保存或更新指标项
     *
     * @param dto 指标项保存DTO
     * @return 保存后的指标项
     */
    IndicatorItem saveOrUpdateIndicatorItem(IndicatorItemSaveDTO dto);

    /**
     * 执行指标项查询
     * 该方法根据指标项编码查找对应的指标项配置，
     * 替换SQL中的参数占位符（如#{startDate}、#{endDate}），
     * 然后执行SQL查询并返回结果
     *
     * @param itemCode  指标项编码
     * @param startDate 开始日期（格式：yyyy-MM-dd）
     * @param endDate   结束日期（格式：yyyy-MM-dd）
     * @param params    其他扩展参数（可选）
     * @return 查询结果
     */
    IndicatorItemExecuteResultDTO executeQuery(String itemCode, String startDate, String endDate, Map<String, Object> params);

    /**
     * 校验指标项SQL的有效性
     * 用于前端保存指标项时验证SQL语法是否正确
     *
     * @param sql SQL语句
     * @return 是否有效
     */
    boolean validateSql(String sql);

}
