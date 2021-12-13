package kr.co.djz_reference.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.djz.utility.DjzComUtil;
import kr.co.djz_reference.common.UserDetailsHelper;
import kr.co.djz_reference.service.CommonService;
import kr.co.djz_reference.service.UserService;

/**
 * UserController
 * @author DoubleJZero
 * @since 2021.12.10
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.12.10    DoubleJZero      최초생성
 *
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */

@Controller
public class UserController {

	/** userService */
	@Resource(name = "userService")
	protected UserService userService;

	/** commonService */
	@Resource(name = "commonService")
	protected CommonService commonService;

	/**
	 * 회원정보수정 페이지
	 * Mapping Address : /user/userModify.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/user/userModify.do")
	public String login(HttpServletRequest request, ModelMap model) {

    	/* ■ 사용자 정보 */
    	model.addAttribute("info", UserDetailsHelper.getAuthenticatedUser());

		return "user/userModify";
	}

	/**
	 * 회원정보수정
	 * Mapping Address : /user/getUserModify.do
	 *
	 * @param userVO
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/user/getUserModify.do")
    public @ResponseBody void getUserModify(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, userService.getUserModify(param, request));
    }

	/**
     * 자기소개서 등록
     * Mapping Address : /user/getInsertIntr.do
     *
     * @param userResumeVO
     * @param request
     * @param response
     */
    @RequestMapping(value = "/user/getInsertIntr.do")
    public @ResponseBody void getInsertIntr(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, userService.getInsertIntr(request, param));
    }

    /**
     * 자기소개서 조회
     * Mapping Address : /user/getIntr.do
     *
     * @param userResumeVO
     * @param request
     * @param response
     */
    @RequestMapping(value = "/user/getIntr.do")
    public @ResponseBody void getResume(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, userService.getIntr(param));
    }

	/**
	 * 휴대폰번호 변경
	 * Mapping Address : /user/popUserMobileModify.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/user/popUserMobileModify.do")
	public String popUserMobileModify(@RequestParam Map<String, Object> param, HttpServletRequest request, ModelMap model) {
    	/* ■ 사용자 정보 */
    	model.addAttribute("info", param);

		return "user/popUserMobileModify";
	}

	/**
	 * 휴대폰 인증번호 생성 및 발송
	 * Mapping Address : /user/getCreateCertiMobileNum.do
	 *
	 * @param userVO
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/user/getCreateCertiMobileNum.do")
    public @ResponseBody void getcreateCertiMobileNum(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, userService.getCreateCertiMobileNum(param));
    }

	/**
	 * 인증번호 확인
	 * Mapping Address : /user/getCheckCertiNum.do
	 *
	 * @param userVO
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/user/getCheckCertiNum.do")
    public @ResponseBody void getCheckCertiNum(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

		DjzComUtil.responseJSON(response, userService.getCheckCertiNum(param));
    }

	/**
	 * 이메일 변경
	 * Mapping Address : /user/popUserMobileModify.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/user/popUserEmailModify.do")
	public String popUserEmailModify(@RequestParam Map<String, Object> param, HttpServletRequest request, ModelMap model) {
    	/* ■ 사용자 정보 */
    	model.addAttribute("info", param);

		return "user/popUserEmailModify";
	}

	/**
	 * 이메일 인증번호 생성 및 발송
	 * Mapping Address : /user/getCreateCertiEmailNum.do
	 *
	 * @param userVO
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/user/getCreateCertiEmailNum.do")
    public @ResponseBody void getCreateCertiEmailNum(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

		DjzComUtil.responseJSON(response, userService.getCreateCertiEmailNum(param));
    }
}
