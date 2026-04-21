package com.hospital.indicator.service.sys.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.indicator.entity.sys.User;
import com.hospital.indicator.mapper.sys.UserMapper;
import com.hospital.indicator.service.sys.UserService;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {
}
