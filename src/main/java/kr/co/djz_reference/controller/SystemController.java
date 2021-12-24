package kr.co.djz_reference.controller;

import java.util.HashMap;
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
 * @author DoubleJZero
 * @since 2021.12.16
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.12.16    DoubleJZero      최초생성
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

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("searchCodeGroup", "USE_YN");
		model.addAttribute("useYnList", systemService.getCodeList(param).get("data"));

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
	public String popValidMenuId(@RequestParam Map<String, Object> param, HttpServletRequest request, ModelMap model) {

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

    /**
	 * 권한 관리
	 * Mapping Address : /system/auth.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/system/auth.do")
	public String auth(HttpServletRequest request, ModelMap model) {

		return "system/auth";
	}

	/**
	 * 권한 조회
	 * Mapping Address : /system/getAuthList.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getAuthList.do")
    public @ResponseBody void getAuthList(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getAuthList(param));
    }

	/**
	 * 권한 아이디 유효성
	 * Mapping Address : /system/popValidAuthId.do
	 *
	 * @param param
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/system/popValidAuthId.do")
	public String popValidAuthId(@RequestParam Map<String, Object> param, HttpServletRequest request, ModelMap model) {

		return "system/popValidAuthId";
	}

	/**
	 * 권한 아이디 유효성 검사
	 * Mapping Address : /system/getIsValidAuthId.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getIsValidAuthId.do")
    public @ResponseBody void getIsValidAuthId(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getIsValidAuthId(param));
    }

	/**
	 * 권한 등록
	 * Mapping Address : /system/getInsertAuth.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getInsertAuth.do")
    public @ResponseBody void getInsertAuth(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getInsertAuth(param));
    }

	/**
	 * 권한 수정
	 * Mapping Address : /system/getUpdateAuth.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getUpdateAuth.do")
    public @ResponseBody void getUpdateAuth(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getUpdateAuth(param));
    }

	/**
	 * 권한 삭제
	 * Mapping Address : /system/getDeleteAuth.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getDeleteAuth.do")
    public @ResponseBody void getDeleteAuth(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getDeleteAuth(param));
    }

	/**
	 * 그룹 관리
	 * Mapping Address : /system/group.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/system/group.do")
	public String group(HttpServletRequest request, ModelMap model) {

		return "system/group";
	}

	/**
	 * 그룹 조회
	 * Mapping Address : /system/getGroupList.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getGroupList.do")
    public @ResponseBody void getGroupList(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getGroupList(param));
    }

	/**
	 * 그룹 등록
	 * Mapping Address : /system/getInsertGroup.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getInsertGroup.do")
    public @ResponseBody void getInsertGroup(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getInsertGroup(param));
    }

	/**
	 * 그룹 수정
	 * Mapping Address : /system/getUpdateGroup.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getUpdateGroup.do")
    public @ResponseBody void getUpdateGroup(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getUpdateGroup(param));
    }

	/**
	 * 그룹 삭제
	 * Mapping Address : /system/getDeleteGroup.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getDeleteGroup.do")
    public @ResponseBody void getDeleteGroup(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getDeleteGroup(param));
    }

	/**
	 * 그룹 권한 관리
	 * Mapping Address : /system/groupAuth.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/system/groupAuth.do")
	public String groupAuth(HttpServletRequest request, ModelMap model) {
		Map<String, Object> param = new HashMap<String, Object>();

		model.addAttribute("groupList", systemService.getGroupList(param).get("data"));

		return "system/groupAuth";
	}

	/**
	 * 그룹 권한 조회
	 * Mapping Address : /system/getGroupAuthList.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getGroupAuthList.do")
    public @ResponseBody void getGroupAuthList(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getGroupAuthList(param));
    }

	/**
	 * 그룹 권한 등록
	 * Mapping Address : /system/getInsertGroupAuth.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getInsertGroupAuth.do")
    public @ResponseBody void getInsertGroupAuth(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getInsertGroupAuth(param, request));
    }

	/**
	 * 그룹 권한 삭제
	 * Mapping Address : /system/getDeleteGroupAuth.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getDeleteGroupAuth.do")
    public @ResponseBody void getDeleteGroupAuth(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getDeleteGroupAuth(param, request));
    }

	/**
	 * 그룹 멤버 관리
	 * Mapping Address : /system/groupMember.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/system/groupMember.do")
	public String groupMember(HttpServletRequest request, ModelMap model) {
		Map<String, Object> param = new HashMap<String, Object>();

		model.addAttribute("groupList", systemService.getGroupList(param).get("data"));

		return "system/groupMember";
	}

	/**
	 * 그룹 멤버 사용자 조회
	 * Mapping Address : /system/getUserSearchList.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getUserSearchList.do")
    public @ResponseBody void getUserSearchList(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getUserSearchList(param));
    }

	/**
	 * 그룹 멤버 조회
	 * Mapping Address : /system/getGroupMemberList.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getGroupMemberList.do")
    public @ResponseBody void getGroupMemberList(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getGroupMemberList(param));
    }

	/**
	 * 그룹 멤버 등록
	 * Mapping Address : /system/getInsertGroupMember.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getInsertGroupMember.do")
    public @ResponseBody void getInsertGroupMember(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getInsertGroupMember(param, request));
    }

	/**
	 * 그룹 멤버 삭제
	 * Mapping Address : /system/getDeleteGroupMember.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getDeleteGroupMember.do")
    public @ResponseBody void getDeleteGroupMember(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getDeleteGroupMember(param, request));
    }

	/**
     * 메뉴권한관리
	 * Mapping Address : /system/authMenu.do
     *
     * @param request
     * @param model
     * @return
     */
	@RequestMapping(value = "/system/authMenu.do")
	public String authMenu(HttpServletRequest request, ModelMap model) {

		Map<String, Object> param = new HashMap<String, Object>();

		model.addAttribute("authList", systemService.getAuthList(param).get("data"));

		return "system/authMenu";
	}

	/**
	 * 메뉴권한관리 조회
	 * Mapping Address : /system/getAuthMenuList.do
	 *
	 * @param functionVO
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getAuthMenuList.do")
    public @ResponseBody void getAuthMenuList(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getAuthMenuList(param));
    }

	/**
	 * 메뉴권한관리 수정
	 * Mapping Address : /system/getUpdateAuthMenu.do
	 *
	 * @param functionVO
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getUpdateAuthMenu.do")
    public @ResponseBody void getUpdateAuthMenu(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getUpdateAuthMenu(param, request));
    }

	/**
	 * 코드 관리
	 * Mapping Address : /system/code.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/system/code.do")
	public String code(HttpServletRequest request, ModelMap model) {

		Map<String, Object> param = new HashMap<String, Object>();

		model.addAttribute("codeGroupList", systemService.getCodeGroupList(param));

		return "system/code";
	}

	/**
	 * 코드 조회
	 * Mapping Address : /system/getCodeList.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getCodeList.do")
    public @ResponseBody void getCodeList(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getCodeList(param));
    }

	/**
	 * 코드 등록
	 * Mapping Address : /system/getInsertCode.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getInsertCode.do")
    public @ResponseBody void getInsertCode(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getInsertCode(param));
    }

	/**
	 * 코드 수정
	 * Mapping Address : /system/getUpdateCode.do
	 *
	 * @param param
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/system/getUpdateCode.do")
    public @ResponseBody void getUpdateCode(@RequestParam Map<String, Object> param
    		, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, systemService.getUpdateCode(param));
    }
}
