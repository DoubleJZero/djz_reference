package kr.co.djz_reference.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.djz.utility.DjzComUtil;
import kr.co.djz_reference.service.FileService;

/**
 * FileController
 *
 * @author DoubleJZero
 * @since 2021.12.10
 * @version 1.0
 * @see
 *
 *      <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.12.10    DoubleJZero      최초생성
 *
 *
 * Copyright (C) by Djz All right reserved.
 *      </pre>
 */
@Controller
public class FileController {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileController.class);

	public static final String FIREFOX = "Firefox";
	public static final String SAFARI = "Safari";
	public static final String CHROME = "Chrome";
	public static final String OPERA = "Opera";
	public static final String MSIE = "MSIE";
	public static final String EDGE = "Edge";
	public static final String OTHER = "Other";
	public static final String TYPEKEY = "type";
	public static final String VERSIONKEY = "version";

	/** FileService */
	@Resource(name = "fileService")
	private FileService fileService;

	/**
	 * 브라우저 정보를 얻는다.
	 *
	 * @param userAgent
	 * @return
	 */
	public static HashMap<String, String> getBrowser(String userAgent) {
		HashMap<String, String> result = new HashMap<String, String>();
		Pattern pattern = null;
		Matcher matcher = null;

		pattern = Pattern.compile("MSIE ([0-9]{1,2}.[0-9])");
		matcher = pattern.matcher(userAgent);
		if (matcher.find()) {
			result.put(TYPEKEY, MSIE);
			result.put(VERSIONKEY, matcher.group(1));
			return result;
		}

		if (userAgent.indexOf("Trident/7.0") > -1) {
			result.put(TYPEKEY, MSIE);
			result.put(VERSIONKEY, "11.0");
			return result;
		}

		pattern = Pattern.compile("Edge/([0-9]{1,3}.[0-9]{1,5})");
		matcher = pattern.matcher(userAgent);
		if (matcher.find()) {
			result.put(TYPEKEY, EDGE);
			result.put(VERSIONKEY, matcher.group(1));
			return result;
		}

		pattern = Pattern.compile("Firefox/([0-9]{1,3}.[0-9]{1,3})");
		matcher = pattern.matcher(userAgent);
		if (matcher.find()) {
			result.put(TYPEKEY, FIREFOX);
			result.put(VERSIONKEY, matcher.group(1));
			return result;
		}

		pattern = Pattern.compile("OPR/([0-9]{1,3}.[0-9]{1,3})");
		matcher = pattern.matcher(userAgent);
		if (matcher.find()) {
			result.put(TYPEKEY, OPERA);
			result.put(VERSIONKEY, matcher.group(1));
			return result;
		}

		pattern = Pattern.compile("Chrome/([0-9]{1,3}.[0-9]{1,3})");
		matcher = pattern.matcher(userAgent);
		if (matcher.find()) {
			result.put(TYPEKEY, CHROME);
			result.put(VERSIONKEY, matcher.group(1));
			return result;
		}

		pattern = Pattern.compile("Version/([0-9]{1,2}.[0-9]{1,3})");
		matcher = pattern.matcher(userAgent);
		if (matcher.find()) {
			result.put(TYPEKEY, SAFARI);
			result.put(VERSIONKEY, matcher.group(1));
			return result;
		}

		result.put(TYPEKEY, OTHER);
		result.put(VERSIONKEY, "0.0");
		return result;
	}

	/**
	 * encoding된 파일 이름을 얻는다.
	 *
	 * @param filename
	 * @param userAgent
	 * @param charSet
	 * @return
	 */
	public static String getDisposition(String filename, String userAgent, String charSet) {
		String encodedFilename = null;
		HashMap<String, String> result = getBrowser(userAgent);
		float version = Float.parseFloat(result.get(VERSIONKEY));
		try {
			if (MSIE.equals(result.get(TYPEKEY)) && version <= 8.0f) encodedFilename = "Content-Disposition: attachment; filename=" + URLEncoder.encode(filename, charSet).replaceAll("\\+", "%20");
			else if (OTHER.equals(result.get(TYPEKEY))) throw new RuntimeException("Not supported browser");
			else encodedFilename = "attachment; filename*=" + charSet + "''" + URLEncoder.encode(filename, charSet);
		} catch (UnsupportedEncodingException e) {
			LOGGER.warn(e.getMessage());
		}
		return encodedFilename;
	}

	/**
	 * 첨부파일 다운로드
	 * Mapping Address : /fileDown.do
	 *
	 * @param atchflVO
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/fileDown.do")
	public void fileDownload(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> fileInfo = fileService.getFileInfo(param);

		if (fileInfo != null) {
			String atchflExtnsnNm = (String) fileInfo.get("atchflExtnsnNm");
			String fileFullName = (String) fileInfo.get("atchflNm");
			if(!DjzComUtil.isStrNull(atchflExtnsnNm)) fileFullName += "." + atchflExtnsnNm;

			File file = new File(String.valueOf(fileInfo.get("atchflRoute")));

			String mimetype = "application/x-msdownload";
			String userAgent = request.getHeader("User-Agent");

			HashMap<String, String> result = getBrowser(userAgent);
			if (MSIE.equals(result.get(TYPEKEY))) mimetype = "application/x-stuff";

			String contentDisposition = getDisposition(fileFullName, userAgent, "UTF-8");
			response.setContentType(mimetype);
			response.setHeader("Content-Disposition", contentDisposition);

			try(BufferedInputStream in = new BufferedInputStream(new FileInputStream(file));
					BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream())){
				FileCopyUtils.copy(in, out);
				out.flush();
			} catch (IOException ex) {
				LOGGER.warn("IO Exception");
			}
		} else {
			response.setContentType("application/x-msdownload");
			PrintWriter printwriter = null;
			try {
				printwriter = response.getWriter();
			} catch (IOException e) {
				LOGGER.warn(e.getMessage());
			}
			printwriter.println("<html>");
			printwriter.println("<br><br><br><h2>Could not get file name<br></h2>");
			printwriter.println("<br><br><br><center><h3><a href='javascript: history.go(-1)'>Back</a></h3></center>");
			printwriter.println("<br><br><br>&copy; webAccess");
			printwriter.println("</html>");
			printwriter.flush();
			printwriter.close();
		}
	}

	/**
	 * 첨부파일 정보
	 * Mapping Address : /getFileInfoAjax.do
	 *
	 * @param atchflVO
	 * @param request
	 * @param response
	 */
	@RequestMapping("/getFileInfoAjax.do")
	public @ResponseBody void updateFileInfoAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {

		DjzComUtil.responseJSON(response, fileService.getFileList(param));
	}

	/**
	 * 첨부파일 삭제
	 * Mapping Address : /deleteFileInfo.do
	 *
	 * @param atchflVO
	 * @param request
	 * @return
	 */
	@RequestMapping("/deleteFileInfo.do")
	public @ResponseBody String deleteFileInfo(@RequestParam Map<String, Object> param, HttpServletRequest request) {

		fileService.deleteFileInfo(param);

		return "success";
	}
}
