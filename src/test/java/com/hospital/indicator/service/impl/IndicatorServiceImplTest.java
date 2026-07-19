package com.hospital.indicator.service.impl;

import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.common.ErrorCode;
import com.hospital.indicator.dto.IndicatorSaveDTO;
import com.hospital.indicator.entity.Indicator;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.spy;

class IndicatorServiceImplTest {

    @Test
    void shouldRejectDuplicateMetricCode() {
        IndicatorServiceImpl service = spy(new IndicatorServiceImpl());
        Indicator duplicate = new Indicator();
        duplicate.setId(1L);
        duplicate.setMetricCode("DUPLICATE");
        doReturn(duplicate).when(service).getOne(any());

        BusinessException error = assertThrows(BusinessException.class,
                () -> service.saveOrUpdateIndicator(autoLeaf("DUPLICATE", null)));

        assertEquals(ErrorCode.INDICATOR_CODE_DUPLICATE, error.getCode());
    }

    @Test
    void shouldRejectMissingParent() {
        IndicatorServiceImpl service = spy(new IndicatorServiceImpl());
        doReturn(null).when(service).getOne(any());

        BusinessException error = assertThrows(BusinessException.class,
                () -> service.saveOrUpdateIndicator(autoLeaf("CHILD", "NOT_EXISTS")));

        assertEquals(ErrorCode.NOT_FOUND, error.getCode());
    }

    @Test
    void shouldPersistBusinessDirectionAndDeriveLevel() {
        IndicatorServiceImpl service = spy(new IndicatorServiceImpl());
        Indicator parent = new Indicator();
        parent.setMetricCode("PARENT");
        parent.setIndicatorLevel(2);
        parent.setIsLeaf(0);
        parent.setMetricPool("POOL_NATIONAL");
        doReturn(null, parent).when(service).getOne(any());
        doReturn(true).when(service).saveOrUpdate(any(Indicator.class));

        IndicatorSaveDTO dto = autoLeaf("CHILD", "PARENT");
        dto.setBusinessDirection("INPATIENT,OUTPATIENT");
        dto.setIndicatorLevel(99);
        Indicator saved = service.saveOrUpdateIndicator(dto);

        assertEquals(3, saved.getIndicatorLevel());
        assertEquals("INPATIENT,OUTPATIENT", saved.getBusinessDirection());
    }

    @Test
    void shouldRejectManualIndicatorWithExpressionCalculation() {
        IndicatorServiceImpl service = spy(new IndicatorServiceImpl());
        doReturn(null).when(service).getOne(any());
        IndicatorSaveDTO dto = autoLeaf("MANUAL", null);
        dto.setInputType("MANUAL");
        dto.setCalculationType("EXPRESSION");

        BusinessException error = assertThrows(BusinessException.class,
                () -> service.saveOrUpdateIndicator(dto));

        assertEquals(ErrorCode.INDICATOR_CONFIG_CONFLICT, error.getCode());
    }

    private IndicatorSaveDTO autoLeaf(String code, String parentCode) {
        IndicatorSaveDTO dto = new IndicatorSaveDTO();
        dto.setMetricCode(code);
        dto.setMetricName("测试指标");
        dto.setParentCode(parentCode);
        dto.setIsLeaf(1);
        dto.setMetricType("QUANTITATIVE");
        dto.setCalculationType("ITEM");
        dto.setExpression("a0050");
        dto.setRelatedItems("[\"a0050\"]");
        dto.setInputType("AUTO");
        dto.setMetricPool("POOL_NATIONAL");
        dto.setStatus(1);
        return dto;
    }
}
