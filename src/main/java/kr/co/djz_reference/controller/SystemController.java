package kr.co.djz_reference.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import kr.co.djz.common.DjzMessageSource;
import kr.co.djz.utility.DjzComUtil;
import kr.co.djz.utility.DjzDateUtil;
import kr.co.djz_reference.service.SystemService;

/**
 * SystemController
 *
 * @author yjjung
 * @since 2021.12.16
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.12.16    yjjung      최초생성
 *
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */

@Controller
public class SystemController {

	/** systemService */
	@Resource(name = "systemService")
	protected SystemService systemService;

	/** djzMessageSource */
	@Resource(name = "djzMessageSource")
	protected DjzMessageSource djzMessageSource;

	/**
	 * 메뉴 관리
	 * Mapping Address : /system/menu.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/system/menu.do")
	public String menu(HttpServletRequest request, ModelMap model) {

		return "system/menu";
	}

	/**
	 * 메뉴 조회
	 * Mapping Address : /system/getMenuList.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getMenuList.do")
    public @ResponseBody void getMenuList(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getMenuList(param));
    }

	/**
	 * 메뉴 아이디 유효성
	 * Mapping Address : /system/popValidMenuId.do
	 *
	 * @param param
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/system/popValidMenuId.do")
	public String popUserMobileModify(@RequestParam Map<String, Object> param, HttpServletRequest request, ModelMap model) {

		return "system/popValidMenuId";
	}

	/**
	 * 메뉴 아이디 유효성 검사
	 * Mapping Address : /system/getIsValidMenuId.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getIsValidMenuId.do")
    public @ResponseBody void getIsValidMenuId(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getIsValidMenuId(param));
    }

	/**
	 * 메뉴 등록
	 * Mapping Address : /system/getInsertMenu.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getInsertMenu.do")
    public @ResponseBody void getInsertMenu(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getInsertMenu(param));
    }

	/**
	 * 메뉴 수정
	 * Mapping Address : /system/getUpdateMenu.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getUpdateMenu.do")
    public @ResponseBody void getUpdateMenu(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getUpdateMenu(param));
    }

	/**
	 * 메뉴 삭제
	 * Mapping Address : /system/getDeleteMenu.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getDeleteMenu.do")
    public @ResponseBody void getDeleteMenu(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getDeleteMenu(param));
    }

	/**
	 * 메뉴 엑셀 다운
	 * Mapping Address : /system/getMenuExcel.do
	 *
	 * @param param
	 * @param model
	 * @param request
	 * @return
	 */
    @RequestMapping(value = "/system/getMenuExcel.do")
	public ModelAndView getProgramExcel(@RequestParam Map<String, Object> param, ModelMap model, HttpServletRequest request) {

    	@SuppressWarnings("unchecked")
		List<Map<String, Object>> resultList = (List<Map<String, Object>>) systemService.getMenuList(param).get("data");

		String[] headerList = {
				djzMessageSource.getMessageArgsLocale("system.msg3",null,new SessionLocaleResolver().resolveLocale(request))
				, djzMessageSource.getMessageArgsLocale("system.msg4",null,new SessionLocaleResolver().resolveLocale(request))
				, djzMessageSource.getMessageArgsLocale("system.msg5",null,new SessionLocaleResolver().resolveLocale(request))
				, djzMessageSource.getMessageArgsLocale("system.msg6",null,new SessionLocaleResolver().resolveLocale(request))
				, djzMessageSource.getMessageArgsLocale("system.msg2",null,new SessionLocaleResolver().resolveLocale(request))
				, djzMessageSource.getMessageArgsLocale("system.msg7",null,new SessionLocaleResolver().resolveLocale(request))};

		String[] colList = {"menuGroup", "parentMenuGroup", "menuDepth", "menuId", "menuName", "menuDescription"};

		String today = DjzDateUtil.getToday();

		ModelAndView mav = new ModelAndView();
		mav.addObject("LIST", resultList);
		mav.addObject("HEADER", headerList);
		mav.addObject("COLS", colList);
		mav.addObject("FILENAME", djzMessageSource.getMessageArgsLocale("system.msg1",null,new SessionLocaleResolver().resolveLocale(request)) + "_" + today + ".xls");
	    mav.setViewName("excelView");

		return mav;
	}
}
