package kr.co.djz_reference.common;

import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.co.djz.utility.DjzComUtil;
/**
 * AuthInterceptor
 *
 * @author DoubleJZero
 * @since 2021.12.01
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.12.01     DoubleJZero      최초생성
 *
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */
public class AuthInterceptor extends HandlerInterceptorAdapter {
    /** Logger */
    private static final Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);

    /**
     * 로그인여부, 권한을 체크한다.
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		String uri = request.getRequestURI().toString();

		if(uri.indexOf("popPrint") == -1) {
			if (!UserDetailsHelper.isAuthenticated()) {
				logger.warn("########## 미로그인 사용자 {} 호출 ##########", uri);

				request.setAttribute("statusCode", "888");

				RequestDispatcher dispatcher = request.getRequestDispatcher("/login.do");
				dispatcher.forward(request, response);

			    return false;
			}
		}

		Map<String, Object> param = DjzComUtil.convertReqToMap(request);

		String curMenuId = (String) param.get("curMenuId");

		if(!DjzComUtil.isWhiteListUri(uri)) {
			if(StringUtils.isBlank(curMenuId)) {
				logger.warn("########## 사용자 비정상 접근 menuId : {} ##########", curMenuId);
				response.sendRedirect("/accessDeny1.do");
				return false;
			}

			Map<String, Object> userAuthMenu = UserDetailsHelper.getUserAuthMenu();
			if(userAuthMenu.get(curMenuId) == null) {
				logger.warn("########## 사용자 접근권한 없음 curMenuId : {} ##########", curMenuId);
				response.sendRedirect("/accessDeny2.do");
				return false;
			}

			/* ■ 현재 메뉴의 권한정보를 setting */
			request.getSession().setAttribute("curAuthInfo", userAuthMenu.get(curMenuId));
		}

		if(param.get("curMenuGroup") != null) {
			/* ■ 현재 속한 메인메뉴 */
			request.getSession().setAttribute("curMenuGroup", param.get("curMenuGroup"));
		}else{
			request.getSession().setAttribute("curMenuGroup", null);
		}

		if(param.get("curMenuSeq") != null) {
			/* ■ 현재 속한 서브메뉴 */
			request.getSession().setAttribute("curMenuSeq", param.get("curMenuSeq"));
		}else{
			request.getSession().setAttribute("curMenuSeq", null);
		}

		return true;
    }
}
