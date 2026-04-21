package com.hospital.indicator.service.sys.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.entity.sys.Dept;
import com.hospital.indicator.mapper.sys.DeptMapper;
import com.hospital.indicator.service.sys.DeptService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class DeptServiceImpl extends ServiceImpl<DeptMapper, Dept> implements DeptService {

    @Override
    public List<Dept> getDeptTree() {
        List<Dept> allDepts = this.list(new LambdaQueryWrapper<Dept>().orderByAsc(Dept::getSortOrder));
        return buildDeptTree(allDepts, 0L);
    }

    @Override
    public List<Dept> getVisibleDepts() {
        UserContext user = UserContext.get();
        if (user == null) return new ArrayList<>();

        if (user.getDataScope() == 50) {
            // 全院权限
            return this.list();
        } else if (user.getDataScope() == 30) {
            // 本部门及下属
            return this.list(new LambdaQueryWrapper<Dept>()
                    .eq(Dept::getDeptId, user.getDeptId())
                    .or()
                    .eq(Dept::getParentId, user.getDeptId()));
        } else {
            // 仅本人/本部门（不含下属）
            return this.list(new LambdaQueryWrapper<Dept>().eq(Dept::getDeptId, user.getDeptId()));
        }
    }

    private List<Dept> buildDeptTree(List<Dept> depts, Long parentId) {
        // 简化实现，实际可增加 children 字段到 Entity
        return depts.stream()
                .filter(d -> d.getParentId().equals(parentId))
                .collect(Collectors.toList());
    }
}
