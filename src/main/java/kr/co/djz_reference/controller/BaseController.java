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

import kr.co.djz.common.DjzMessageSource;
import kr.co.djz.utility.DjzComUtil;
import kr.co.djz_reference.service.BaseService;

/**
 * SystemController
 *
 * @author DoubleJZero
 * @since 2021.12.21
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.12.21    DoubleJZero      최초생성
 *
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */

@Controller
public class BaseController {

	/** systemService */
	@Resource(name = "baseService")
	protected BaseService baseService;

	/** djzMessageSource */
	@Resource(name = "djzMessageSource")
	protected DjzMessageSource djzMessageSource;

	/**
	 * 사용자 관리
	 * Mapping Address : /base/userManage.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/base/userManage.do")
	public String userManage(HttpServletRequest request, ModelMap model) {

		return "base/userManage";
	}

	/**
	 * 사용자 목록 조회
	 * Mapping Address : /base/getUserList.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/base/getUserList.do")
    public @ResponseBody void getUserList(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, baseService.getUserList(param));
    }

	/**
	 * 사용자 등록
	 * Mapping Address : /base/getInsertUser.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/base/getInsertUser.do")
    public @ResponseBody void getInsertUser(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, baseService.getInsertUser(param));
    }

	/**
	 * 사용자 수정
	 * Mapping Address : /base/getUpdateUser.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/base/getUpdateUser.do")
    public @ResponseBody void getUpdateUser(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, baseService.getUpdateUser(param));
    }

	/**
	 * 사용자 삭제
	 * Mapping Address : /base/getDeleteUser.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/base/getDeleteUser.do")
    public @ResponseBody void getDeleteUser(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, baseService.getDeleteUser(param));
    }

}
