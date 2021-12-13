package kr.co.djz_reference.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.djz_reference.service.MainService;

/**
 * MainController
 * @author DoubleJZero
 * @since 2021.11.08
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.11.08    DoubleJZero      최초생성
 *
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */

@Controller
public class MainController {

	/** mainService */
	@Resource(name = "mainService")
	protected MainService mainService;

	/**
	 * 메인화면
	 * Mapping Address : /main/main.do
	 *
	 * @param request
	 * @param model
	 * @return 메인 페이지
	 */
	@RequestMapping(value = "/main/main.do")
	public String main(HttpServletRequest request, ModelMap model)  {

		model.addAttribute("res", mainService.getMain());

		return "main/main";
	}
}
