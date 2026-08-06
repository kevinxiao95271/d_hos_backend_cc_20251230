package com.hospital.indicator.service.dataentry.impl;

import com.hospital.indicator.dto.dataentry.ManualDataSaveDTO;
import com.hospital.indicator.entity.dataentry.ManualData;
import com.hospital.indicator.mapper.dataentry.ManualDataMapper;
import com.hospital.indicator.service.dataentry.ManualDataService;
import com.hospital.indicator.util.UserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ManualDataServiceImpl implements ManualDataService {

    private final ManualDataMapper manualDataMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long save(ManualDataSaveDTO dto) {
        ManualData entity = new ManualData();
        entity.setCaseNo(dto.getCaseNo());
        entity.setAdmissionSeq(dto.getAdmissionSeq());
        entity.setPatientName(dto.getPatientName());
        entity.setGender(dto.getGender());
        entity.setAge(dto.getAge());
        entity.setAdmissionDate(dto.getAdmissionDate());
        entity.setDischargeDate(dto.getDischargeDate());
        entity.setHospitalDays(dto.getHospitalDays());
        entity.setDeptCode(dto.getDeptCode());
        entity.setDeptName(dto.getDeptName());
        entity.setMainDiagnosisCode(dto.getMainDiagnosisCode());
        entity.setMainDiagnosisName(dto.getMainDiagnosisName());
        entity.setTotalCost(dto.getTotalCost());
        entity.setDataSource("MANUAL");

        // 获取当前登录用户
        try {
            String username = UserContext.getCurrentUsername();
            entity.setCreatedBy(username);
        } catch (Exception e) {
            entity.setCreatedBy("system");
        }

        manualDataMapper.insert(entity);
        return entity.getId();
    }

    @Override
    public boolean existsInDMR(String caseNo, String admissionSeq) {
        return manualDataMapper.existsInDMR(caseNo, admissionSeq);
    }

    @Override
    public boolean existsInManual(String caseNo, String admissionSeq) {
        return manualDataMapper.existsInManual(caseNo, admissionSeq);
    }
}
