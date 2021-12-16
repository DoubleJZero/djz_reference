package kr.co.djz_reference.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import egovframework.rte.fdl.property.EgovPropertyService;
import kr.co.djz.utility.DjzComUtil;
import kr.co.djz_reference.service.CommonService;

/**
 * CommonController
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
public class CommonController {
	/** Logger */
    //private static final Logger logger = LoggerFactory.getLogger(CommonController.class);

    /** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

    /** commonService */
	@Resource(name = "commonService")
	protected CommonService commonService;

	/**
	 * language 변경
     * Mapping Address : /changeLang.do
	 *
	 * @param request
	 * @return
	 */
    @RequestMapping(value = "/changeLang.do")
    public @ResponseBody String changeLang(HttpServletRequest request) {
		String lang = request.getParameter("lang").toString();

		if(StringUtils.isBlank(lang) || lang.equals("ko")) request.getSession().setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, new Locale("ko"));
		else request.getSession().setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, new Locale("en"));

		request.getSession().setAttribute("lang", request.getSession().getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME));

		return "success";
    }

    /**
     * 아이디 중복체크
     * Mapping Address : /getIsIdDupCheck.do
     *
     * @param param
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getIsIdDupCheck.do")
    public @ResponseBody void getIsIdDupCheck(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, commonService.getIsIdDupCheck(param));
    }

    /**
     * 휴대폰번호 중복체크
     * Mapping Address : /getIsMobileDupCheck.do
     *
     * @param param
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getIsMobileDupCheck.do")
    public @ResponseBody void getIsMobileDupCheck(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, commonService.getIsMobileDupCheck(param));
    }

    /**
     * 이메일 중복체크
     * Mapping Address : /getIsEmailDupCheck.do
     *
     * @param param
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getIsEmailDupCheck.do")
    public @ResponseBody void getIsEmailDupCheck(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	DjzComUtil.responseJSON(response, commonService.getIsEmailDupCheck(param));
    }

    /**
     * 비정상 접근
     * Mapping Address : /accessDeny1.do
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(value = "/accessDeny1.do")
	public String accessDeny1(HttpServletRequest request, ModelMap model) {

		return "common/accessDeny1";
	}

    /**
     * 접근권한 없음
     * Mapping Address : /accessDeny2.do
     *
     * @param request
     * @param model
     * @return
     */
    @RequestMapping(value = "/accessDeny2.do")
	public String accessDeny2(HttpServletRequest request, ModelMap model) {

		return "common/accessDeny2";
	}

    /**
     * pdf 변환
     * Mapping Address : /getConvertPdf.do
     *
     * @param companyVO
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getConvertPdf.do")
    public void getConvertPdf(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	commonService.getConvertPdf(param, request, response);
    }

    /**
     * 여러개의 파일을 zip으로 압축해 다운
     * Mapping Address : /getZipFile.do
     *
     * @param companyVO
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getZipFile.do")
    public void getZipFile(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

    	commonService.getZipFile(param, response);
    }

    /**
     * 이미지 보여주기
     *
     * @param imagename
     * @return
     * @throws IOException
     */
    @GetMapping(value = "/getImage.do", produces = "image/png")
	public ResponseEntity<byte[]> userSearch(@RequestParam Map<String, Object> param) throws IOException {

		InputStream imageStream = new FileInputStream(propertiesService.getString("file.root.path")+ File.separator + (String)param.get("sealImageName"));

		byte[] imageByteArray = IOUtils.toByteArray(imageStream);

		imageStream.close();

		return new ResponseEntity<byte[]>(imageByteArray, HttpStatus.OK);
	}
}
