package kr.co.djz_reference.service;

import java.util.Map;

import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

/**
 * UserDetailService
 * @author DoubleJZero
 * @since 2021.06.21
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.06.21    DoubleJZero      최초생성
 *
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */

public class UserDetailService {

    /**
     * 인증된 사용자객체를 가져온다.
     *
     * @return 사용자객체
     */
    @SuppressWarnings("unchecked")
	public Map<String, Object> getAuthenticatedUser() {
    	if (RequestContextHolder.getRequestAttributes() == null) return null;

    	return (Map<String, Object>) RequestContextHolder.getRequestAttributes().getAttribute("loginInfo", RequestAttributes.SCOPE_SESSION);
    }

    /**
     * 로그인여부
     *
     * @return
     */
    public Boolean isAuthenticated() {
		if (RequestContextHolder.getRequestAttributes() == null) {
		    return false;
		} else {
			if(RequestContextHolder.getRequestAttributes().getAttribute("loginInfo", RequestAttributes.SCOPE_SESSION) == null) return false;
			else return true;
		}
    }

    /**
     * 메뉴별 기능정보를 가져온다.
     *
     * @return
     */
    @SuppressWarnings("unchecked")
	public Map<String, Object> getUserAuthMenu() {
    	if (RequestContextHolder.getRequestAttributes() == null) return null;

    	return (Map<String, Object>) RequestContextHolder.getRequestAttributes().getAttribute("userAuthInfo", RequestAttributes.SCOPE_SESSION);
    }
}
