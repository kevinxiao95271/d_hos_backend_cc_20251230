package com.hospital.indicator.common;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import java.time.format.DateTimeParseException;
import java.util.Set;

/**
 * 全局异常处理器
 * <p>
 * 业务错误码均使用 30xxx / 304xxx 段，不与 HTTP 状态码（4xx/5xx）重叠。
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 业务异常（透传 code）
     */
    @ExceptionHandler(BusinessException.class)
    public Result<Void> handleBusinessException(BusinessException e) {
        log.warn("业务异常 [{}]：{}", e.getCode(), e.getMessage());
        return Result.error(e.getCode(), e.getMessage());
    }

    /**
     * 缺少必填请求参数 → 30400
     */
    @ExceptionHandler(MissingServletRequestParameterException.class)
    public Result<Void> handleMissingParam(MissingServletRequestParameterException e) {
        log.warn("缺少必填参数：{}", e.getParameterName());
        return Result.error(30400, "缺少必填参数：" + e.getParameterName());
    }

    /**
     * HTTP 方法不支持 → 30405
     */
    @ResponseStatus(HttpStatus.METHOD_NOT_ALLOWED)
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public Result<Void> handleMethodNotSupported(HttpRequestMethodNotSupportedException e) {
        return Result.error(30405, "不支持的请求方式：" + e.getMethod() + "，请检查接口文档");
    }

    /**
     * @Valid 参数校验失败 → 30400 / 304001（itemCode 字段专属）
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<Void> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        FieldError fieldError = e.getBindingResult().getFieldError();
        String message = fieldError != null ? fieldError.getDefaultMessage() : "参数校验失败";
        log.error("参数校验异常：{}", message, e);
        if (fieldError != null && "itemCode".equals(fieldError.getField())) {
            return Result.error(ErrorCode.ITEM_CODE_INVALID, message);
        }
        return Result.error(30400, message);
    }

    /**
     * 参数绑定失败 → 30400
     */
    @ExceptionHandler(BindException.class)
    public Result<Void> handleBindException(BindException e) {
        FieldError fieldError = e.getFieldError();
        String message = fieldError != null ? fieldError.getDefaultMessage() : "参数绑定失败";
        log.error("参数绑定异常：{}", message, e);
        return Result.error(30400, message);
    }

    /**
     * 约束违反 → 30400
     */
    @ExceptionHandler(ConstraintViolationException.class)
    public Result<Void> handleConstraintViolationException(ConstraintViolationException e) {
        Set<ConstraintViolation<?>> violations = e.getConstraintViolations();
        String message = violations.isEmpty() ? "参数校验失败" : violations.iterator().next().getMessage();
        log.error("约束违反异常：{}", message, e);
        return Result.error(30400, message);
    }

    /**
     * 日期格式错误 → 30400
     */
    @ExceptionHandler(DateTimeParseException.class)
    public Result<Void> handleDateTimeParseException(DateTimeParseException e) {
        log.warn("日期格式错误：{}", e.getMessage());
        return Result.error(30400, "日期格式错误，请使用 yyyy-MM-dd 格式（例如 2020-01-01）");
    }

    /**
     * 空指针 → 30500
     */
    @ExceptionHandler(NullPointerException.class)
    public Result<Void> handleNullPointerException(NullPointerException e) {
        log.error("空指针异常", e);
        return Result.error(30500, "系统异常，请联系管理员");
    }

    /**
     * 其他未知异常 → 30500
     */
    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception e) {
        log.error("系统异常", e);
        return Result.error(30500, "系统异常，请联系管理员");
    }
}
