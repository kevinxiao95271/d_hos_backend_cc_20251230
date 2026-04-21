package com.hospital.indicator.context;

import lombok.Data;

/**
 * 用户上下文信息
 */
@Data
public class UserContext {
    private Long userId;
    private String username;
    private Long deptId;
    private Integer dataScope;
    private String businessDirections;

    private static final ThreadLocal<UserContext> THREAD_LOCAL = new ThreadLocal<>();

    public static void set(UserContext context) {
        THREAD_LOCAL.set(context);
    }

    public static UserContext get() {
        return THREAD_LOCAL.get();
    }

    public static void remove() {
        THREAD_LOCAL.remove();
    }
}
