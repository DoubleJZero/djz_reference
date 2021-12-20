package kr.co.djz_reference.common;

import java.util.Map;

import kr.co.djz_reference.service.UserDetailService;

/**
 * UserDetailsHelper
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
public class UserDetailsHelper {

    /** UserDetailService */
    static UserDetailService userDetailService;

    /**
     * getUserDetailService
     * @return userDetailService
     */
    public UserDetailService getUserDetailService() {
    	return userDetailService;
    }

    /**
     * setUserDetailService
     * @param userDetailService
     */
    public void setUserDetailService(UserDetailService userDetailService) {
    	UserDetailsHelper.userDetailService = userDetailService;
    }

    /**
     * 인증된 사용자객체를 가져온다.
     *
     * @return 사용자객체
     */
    public static Map<String, Object> getAuthenticatedUser() {
    	return userDetailService.getAuthenticatedUser();
    }

    /**
     * 로그인여부
     *
     * @return boolean
     */
    public static Boolean isAuthenticated() {
    	return userDetailService.isAuthenticated();
    }

    /**
     * 메뉴별 기능정보를 가져온다.
     *
     * @return 메뉴별 기능정보
     */
    public static Map<String, Object> getUserAuthMenu() {
    	return userDetailService.getUserAuthMenu();
    }
}
