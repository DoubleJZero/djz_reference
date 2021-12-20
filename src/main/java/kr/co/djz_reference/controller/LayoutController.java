package kr.co.djz_reference.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.djz_reference.common.UserDetailsHelper;
import kr.co.djz_reference.service.CommonService;

/**
 * LayoutController
 * @author DoubleJZero
 * @since 2021.12.08
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.12.08    DoubleJZero      최초생성
 *
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */
@Controller
public class LayoutController {

	/** commonService */
	@Resource(name = "commonService")
	protected CommonService commonService;

	/**
	 * layout header
     * Mapping Address : /header.do
	 *
	 * @param request
	 * @param model
	 * @return
	 */
    @RequestMapping(value = "/header.do")
    public String header(HttpServletRequest request, ModelMap model) {

        return "include/header";
    }

    /**
     * layout left
     * Mapping Address : /left.do
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping("/left.do")
    public String left(HttpServletRequest request, ModelMap model) {
    	Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();

		model.addAttribute("menuList", commonService.getMenuInfo(userInfo));

        return "include/left";
    }
}
