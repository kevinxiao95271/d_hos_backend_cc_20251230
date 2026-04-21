package com.hospital.indicator.service.sys;

import com.baomidou.mybatisplus.extension.service.IService;
import com.hospital.indicator.entity.sys.Dept;
import java.util.List;

public interface DeptService extends IService<Dept> {
    /**
     * 获取科室树
     */
    List<Dept> getDeptTree();

    /**
     * 根据当前用户权限获取可见科室列表
     */
    List<Dept> getVisibleDepts();
}
