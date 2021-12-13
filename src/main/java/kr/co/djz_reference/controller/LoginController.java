package kr.co.djz_reference.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.djz.common.DjzHttpSessionBindingListener;
import kr.co.djz.common.DjzMultiLoginPreventor;
import kr.co.djz.utility.DjzComUtil;
import kr.co.djz_reference.common.UserDetailsHelper;
import kr.co.djz_reference.service.CommonService;
import kr.co.djz_reference.service.LoginService;

/**
 * LoginController
 *
 * @author DoubleJZero
 * @since 2021.12.09
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.12.09    DoubleJZero      최초생성
 *
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */

@Controller
public class LoginController {

	/** Logger */
    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

	/** loginService */
	@Resource(name = "loginService")
	protected LoginService loginService;

	/** commonService */
	@Resource(name = "commonService")
	protected CommonService commonService;

	/**
	 * 로그인화면
	 * Mapping Address : /login.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/login.do")
	public String login(HttpServletRequest request, ModelMap model) {
		String statusCode = request.getParameter("statusCode");
		String searchUserId = request.getParameter("searchUserId");

		/* ■ 세션이 존재한다면 메인으로 이동 */
		if(UserDetailsHelper.isAuthenticated()) {
			model.addAttribute("statusCode", statusCode);
			return "redirect:/main/main.do";
		}

		model.addAttribute("statusCode", statusCode);
		model.addAttribute("searchUserId", StringUtils.isBlank(searchUserId) ? "" :searchUserId);

		return "login/login";
	}

	/**
	 * 로그인 유효성 검사
     * Mapping Address : /loginValidation.do
	 *
	 * @param userVO
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/loginValidation.do")
    public @ResponseBody void loginValidation(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, loginService.getLoginValidation(param));
    }

	/**
	 * 비밀번호변경화면
	 * Mapping Address : /pwdChange.do
	 *
	 * @param userVO
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/pwdChange.do")
	public String pwdChange(@RequestParam Map<String, Object> param, HttpServletRequest request, ModelMap model) {

		model.addAttribute("userId", param.get("userId"));

		return "login/pwdChange";
	}

	/**
	 * 비밀번호 변경
     * Mapping Address : /changePassword.do
	 *
	 * @param userVO
	 * @param request
	 * @param response
	 */
    @RequestMapping(value = "/getChangePassword.do")
    public @ResponseBody void getChangePassword(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, loginService.getChangePassword(param));
    }

    /**
     * 중복로그인 확인
     * Mapping Address : /dupLoginCheck.do
     *
     * @param userVO
     * @param request
     * @return
     */
    @RequestMapping(value = "/dupLoginCheck.do")
    public @ResponseBody String dupLoginCheck(@RequestParam Map<String, Object> param, HttpServletRequest request) {

    	String userId = (String) param.get("userId");

		if(DjzMultiLoginPreventor.findByLoginId(userId)) return "Y";

		return "N";
    }

    /**
     * 로그인 한다.
	 * Mapping Address : /actionLogin.do
     *
     * @param userVO
     * @param request
     * @param model
     * @param ratts
     * @return
     */
	@RequestMapping(value = "/actionLogin.do")
	public String actionLogin(@RequestParam Map<String, Object> param, HttpServletRequest request, ModelMap model, RedirectAttributes ratts) {

		if(param == null) {
			ratts.addFlashAttribute("statusCode", 888);
			return "redirect:/login.do";
		}

		/* ■ 로그인 이력에 들어갈 값 */
		param.put("ip", DjzComUtil.getClientIpAddr(request));

		Map<String, Object> resMap = loginService.selectUserInfo(param);

		int status = Integer.parseInt(String.valueOf(resMap.get("statusCode")));

		if(status != 700) {
			ratts.addFlashAttribute("statusCode", 888);
			return "redirect:/login.do";
		}

		@SuppressWarnings("unchecked")
		Map<String, Object> loginInfo = (Map<String, Object>) resMap.get("data");

		request.getSession().setAttribute("loginInfo", loginInfo);

		/* ■ 중복로그인 방지 */
		DjzHttpSessionBindingListener listener = new DjzHttpSessionBindingListener();
		request.getSession().setAttribute((String) loginInfo.get("userId"), listener);

		return "redirect:/main/main.do";
	}

	/**
	 * 로그아웃 한다.
     * Mapping Address : /actionLogout.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
    @RequestMapping(value = "/actionLogout.do")
    public String actionLogout(HttpServletRequest request, ModelMap model) {

    	/* ■ 현재 언어 정보 가져오기 */
    	String lang = "ko";
    	Object obj = request.getSession().getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME);
    	if(obj != null) lang = obj.toString();

    	/* ■ 세션 제거 */
    	removeSession(request);

    	/* ■ 원래의 언어설정 다시 세션에 넣기 */
    	request.getSession().setAttribute("lang", lang);

		return "redirect:/login.do";
    }

    /**
     * 아이디 찾기 화면
     * Mapping Address : /idSearch.do
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(value = "/idSearch.do")
    public String idSearch(HttpServletRequest request, ModelMap model) {

		return "login/idSearch";
    }

    /**
     * 아이디 찾기
     * Mapping Address : /getIdSearch.do
     *
     * @param userVO
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getIdSearch.do")
    public @ResponseBody void getIdSearch(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, loginService.getIdSearch(param));
    }

    /**
     * 비밀번호 초기화 화면
     * Mapping Address : /pwSearch.do
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(value = "/pwSearch.do")
    public String pwSearch(HttpServletRequest request, ModelMap model) {

		return "login/pwSearch";
    }

    /**
     * 비밀번호 초기화 유효성 검사 및 인증번호 발송
     * Mapping Address : /getPwSearch.do
     *
     * @param userVO
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getPwSearch.do")
    public @ResponseBody void getPwSearch(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, loginService.getPwSearch(param));
    }

    /**
     * 비밀번호 초기화 인증번호 확인
     * Mapping Address : /getPwcCertiConfirm.do
     *
     * @param userVO
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getPwcCertiConfirm.do")
    public @ResponseBody void getPwcCertiConfirm(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, loginService.getPwcCertiConfirm(param));
    }

    /**
     * 비밀번호 초기화 비밀번호 변경
     * Mapping Address : /getPwcInit.do
     *
     * @param userVO
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getPwcInit.do")
    public @ResponseBody void getPwcInit(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, loginService.getPwcInit(param));
    }

    /**
     * 회원가입 약관 화면
     * Mapping Address : /agreement.do
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(value = "/agreement.do")
    public String agreement(HttpServletRequest request, ModelMap model) {

		return "login/agreement";
    }

    /**
     * 회원가입 약관 유효성 검사 및 key 발급
     * Mapping Address : /getAgreement.do
     *
     * @param userVO
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getAgreement.do")
    public @ResponseBody void getAgreement(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, loginService.getAgreement(param));
    }

    /**
     * 회원가입 화면
     * Mapping Address : /joinMembership.do
     *
     * @param userVO
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(value = "/joinMembership.do")
    public String joinMembership(@RequestParam Map<String, Object> param, HttpServletRequest request, ModelMap model) {

    	int authKey = 0;
    	if(param != null) authKey = Integer.parseInt(String.valueOf(param.get("authKey")));

    	/* ■ key가 유효하지 않을 경우 다시 약관페이지로 보냄. */
    	if(!DjzComUtil.isPrime(authKey)) {
    		logger.warn("########## 회원가입 비 정상 접근 IP : {} ##########", DjzComUtil.getClientIpAddr(request));
    		return "redirect:/agreement.do";
    	}

		return "login/joinMembership";
    }

    /**
     * 회원가입
     * Mapping Address : /getJoinMembership.do
     *
     * @param userVO
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getJoinMembership.do")
    public @ResponseBody void getJoinMembership(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, loginService.getJoinMembership(param));
    }

    /**
     * 세션을 제거한다.
     */
    public void removeSession(HttpServletRequest request) {
    	request.getSession().setAttribute("loginInfo", null);
    	request.getSession().removeAttribute("loginInfo");
    	request.getSession().invalidate();
    }
}
