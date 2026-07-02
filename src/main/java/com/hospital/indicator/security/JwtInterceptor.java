package com.hospital.indicator.security;

import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.utils.JwtUtils;
import io.jsonwebtoken.Claims;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * JWT 拦截器
 */
@Component
public class JwtInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtUtils jwtUtils;

    @Value("${jwt.prefix}")
    private String prefix;

    /** 不需要鉴权的路径片段（URI 包含其中任一即放行） */
    private static final String[] PASS_CONTAINS = {
        "swagger", "api-docs", "druid"
    };

    /** 不需要鉴权的路径后缀（context-relative URI endsWith 即放行） */
    private static final String[] PASS_ENDS = {
        "/auth/login", "/auth/register", "/error"
    };

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 放行 OPTIONS 预检请求（CORS）
        if ("OPTIONS".equals(request.getMethod())) {
            return true;
        }

        String uri = request.getRequestURI();

        // 放行文档/监控关键词
        for (String keyword : PASS_CONTAINS) {
            if (uri.contains(keyword)) {
                return true;
            }
        }

        // 放行登录/注册/error
        for (String suffix : PASS_ENDS) {
            if (uri.endsWith(suffix)) {
                return true;
            }
        }

        // 获取 token
        String token = request.getHeader(jwtUtils.getHeader());

        if (StringUtils.isBlank(token)) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, 30401, "Token 未提供，请先登录");
            return false;
        }

        if (token.startsWith(prefix)) {
            token = token.substring(prefix.length());
        }

        try {
            Claims claims = jwtUtils.parseToken(token);

            UserContext context = new UserContext();
            context.setUserId(Long.valueOf(claims.get("userId").toString()));
            context.setUsername(claims.getSubject());
            context.setDeptId(Long.valueOf(claims.get("deptId").toString()));
            context.setDataScope(Integer.valueOf(claims.get("dataScope").toString()));
            context.setBusinessDirections((String) claims.get("businessDirections"));

            UserContext.set(context);
            return true;

        } catch (Exception e) {
            writeJson(response, HttpServletResponse.SC_UNAUTHORIZED, 30401, "Token 无效或已过期，请重新登录");
            return false;
        }
    }

    /** 统一写出 JSON 格式的鉴权失败响应 */
    private void writeJson(HttpServletResponse response, int httpStatus, int code, String message) throws Exception {
        response.setStatus(httpStatus);
        response.setContentType("application/json;charset=UTF-8");
        String body = String.format(
            "{\"code\":%d,\"message\":\"%s\",\"data\":null,\"timestamp\":%d}",
            code, message, System.currentTimeMillis()
        );
        response.getWriter().write(body);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        // 清理线程上下文，防止内存泄漏
        UserContext.remove();
    }
}
