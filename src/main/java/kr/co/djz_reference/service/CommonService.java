package kr.co.djz_reference.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.property.EgovPropertyService;
import kr.co.djz.common.DjzStreamPrintThread;
import kr.co.djz.entity.DjzHttpStatus;
import kr.co.djz.service.DjzCbsService;
import kr.co.djz.utility.DjzComUtil;
import kr.co.djz.utility.DjzDateUtil;
import kr.co.djz_reference.common.UserDetailsHelper;
import kr.co.djz_reference.entity.SecUserDetailsVO;

/**
 * CommonService
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
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */

@Service("commonService")
@Transactional(rollbackFor = Exception.class, readOnly = true)
public class CommonService extends DjzCbsService {
	String serviceId = "COMMONSERVICE";

	private static final Logger logger = LoggerFactory.getLogger(CommonService.class);

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/**
	 * 메뉴목록을 조회한다.
	 * @param params - 조회할 정보가 담긴 param
	 * @return 메뉴목록
	 */
	public List<Map<String, Object>> getMenuInfo(Map<String, Object> param) {

		if(SecurityContextHolder.getContext().getAuthentication() != null) {
			SecUserDetailsVO principal = (SecUserDetailsVO) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			if(principal != null) {
				param.put("authList", principal.getAuthList());
			} else {
				logger.warn("########## 권한 또는 그룹설정이 되지 않음 ##########");
				return new ArrayList<Map<String, Object>>();
			}
		} else {
			logger.warn("########## 권한 또는 그룹설정이 되지 않음 ##########");
			return new ArrayList<Map<String, Object>>();
		}

		return mapper.selectList(serviceId+".selectMenuInfo", param);
	}

	/**
	 * 아이디 중복체크
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getIsIdDupCheck(Map<String, Object> param) {

		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : param is null
    	 * 702 : userId is null
    	 * 704 : is duplicate
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String userId = (String) param.get("userId");

		if(StringUtils.isBlank(userId)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int dupCnt = mapper.selectOne(serviceId+".selectIsIdDupCheck", param);

		if(dupCnt > 0) return DjzComUtil.responseMap(DjzHttpStatus.DUPLICATE.getStatusCode());

		param.put("userIdDupCheckKey", DjzComUtil.getPrime());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), param);
	}

	/**
	 * 휴대폰번호 중복체크
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getIsMobileDupCheck(Map<String, Object> param) {

		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : param is null
    	 * 702 : mobile is null
    	 * 704 : is duplicate
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String mobile = (String) param.get("mobile");

		if(StringUtils.isBlank(mobile)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int dupCnt = mapper.selectOne(serviceId+".selectIsMobileDupCheck", param);

		if(dupCnt > 0) return DjzComUtil.responseMap(DjzHttpStatus.DUPLICATE.getStatusCode());

		param.put("mobileDupCheckKey", DjzComUtil.getPrime());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), param);
	}

	/**
	 * 이메일 중복체크
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getIsEmailDupCheck(Map<String, Object> param) {

		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : param is null
    	 * 702 : email is null
    	 * 704 : is duplicate
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String email = (String) param.get("email");

		if(StringUtils.isBlank(email)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int dupCnt = mapper.selectOne(serviceId+".selectIsEmailDupCheck", param);

		if(dupCnt > 0) return DjzComUtil.responseMap(DjzHttpStatus.DUPLICATE.getStatusCode());

		param.put("emailDupCheckKey", DjzComUtil.getPrime());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), param);
	}

	/**
	 * pdf 변환
	 *
	 * @param param
	 * @param response
	 */
	@Transactional(rollbackFor = Exception.class)
	public void getConvertPdf(Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) {
		String filePath = propertiesService.getString("file.root.path")+File.separator+"pdf";

		File saveFolder = new File(filePathBlackList(filePath));

		if (!saveFolder.exists() || saveFolder.isFile()) {
			if (saveFolder.mkdirs()) logger.debug("####### [file.mkdirs] saveFolder : Creation Success #######");
			else logger.error("#######[file.mkdirs] saveFolder : Creation Fail #######");
		}

		String reportGbn = (String) param.get("reportGbn");
		String reportId = (String) param.get("reportId");
		String targetUrl = (String) param.get("targetUrl");

		String fileName = reportGbn + "(" + reportId + ")";

		if(StringUtils.isBlank(reportGbn)) fileName = reportId;
		if(StringUtils.isBlank(reportGbn) && StringUtils.isBlank(reportId)) fileName = DjzDateUtil.getToday("yyyyMMddHHmmss");
		if(targetUrl.indexOf("popPrintSendNotification") != -1) fileName = reportId + "_notice";

		String rootPath = request.getSession().getServletContext().getRealPath("");
		rootPath += "\\pdf\\wkhtmltopdf\\wkhtmltopdf.exe";

		String option = "-B 12 --header-font-name gulim --header-font-size 9 --header-spacing 5 --header-line --footer-font-name gulim --footer-font-size 8 --footer-spacing 5 --footer-line --footer-left [date]([time]) --footer-right [page]/[topage]";
		String strCmd = rootPath + " --disable-smart-shrinking " + option + " " + targetUrl+"?projectId="+(String)param.get("projectId")+"&reportId="+(String) param.get("reportId")+"&reportState="+(String) param.get("reportState")+"&reportGbn="+reportGbn+"&memberId="+param.get("memberId")+"&meetingId="+(String)param.get("meetingId")+"&irbId="+(String)param.get("irbId")+"&agendaId="+(String)param.get("agendaId")+"&agendaWriteGbn="+(String)param.get("agendaWriteGbn")+"&meetingDocumentId="+(String)param.get("meetingDocumentId")+"&meetingDocumentWriteGbn="+(String)param.get("meetingDocumentWriteGbn")+"&isConvertPdf=Y" + " " + filePath + File.separator + fileName + ".pdf";

		Runtime run = Runtime.getRuntime();
		Process p = null;
		BufferedInputStream bin = null;
		BufferedOutputStream bos = null;
		File file = null;

		try {
			p = run.exec(strCmd);
			DjzStreamPrintThread errprint = new DjzStreamPrintThread(p.getErrorStream());
			DjzStreamPrintThread okprint = new DjzStreamPrintThread(p.getInputStream());
			p.getOutputStream().close();
			errprint.start();
			okprint.start();

			int rst = p.waitFor();

			if (rst == 0) {
				logger.info("RunProgram success : {}", strCmd);
				if(targetUrl.indexOf("popPrintSendNotification") == -1) {
					Map<String, Object> printMap = new HashMap<String, Object>();
					printMap.put("docGbn", "02");
					printMap.put("docSubGbn", reportGbn);
					printMap.put("printGbn", "02");
					printMap.put("reportId", param.get("reportId"));

					Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
					printMap.put("userId", userInfo.get("userId"));

					mapper.insert(serviceId+".insertPrint", printMap);

					file = new File(filePath, String.valueOf(fileName) + ".pdf");

					String fileName1 = file.getName().replace(" ", "_");
					String fileName2 = new String(fileName1.getBytes("euc-kr"), "8859_1");

					response.setContentType("application/octet-stream");
					response.setHeader("Content-Disposition", "attachment; filename=" + fileName2 + ";");
					response.setHeader("Content-Length", file.length()+"");

					bin = new BufferedInputStream(new FileInputStream(file));
					bos = new BufferedOutputStream((OutputStream)response.getOutputStream());

					byte[] buf = new byte[2048];
					int read = 0;
					while ((read = bin.read(buf)) != -1) bos.write(buf, 0, read);
				}
			} else {
				logger.warn("RunProgram fail (rst:{}) : {}", rst, strCmd);

				response.setContentType("text/html; charset=utf-8");
				PrintWriter out = response.getWriter();

				out.println("<script>");
				out.println("alert('처리중  오류가  발생하였습니다!!');");
				out.println("window.close();");
				out.println("</script>");
				out.close();
			}

			if (p != null) p.destroy();

			if (bos != null) bos.close();
			if (bin != null) bin.close();

			if (file != null && file.isFile()) file.delete();
		} catch (InterruptedException e) {
			logger.warn(e.getMessage());
			if (p != null) p.destroy();
		} catch (IOException e) {
			logger.warn(e.getMessage());
			if (p != null) p.destroy();

			try {
				if (bos != null) bos.close();
				if (bin != null) bin.close();
			}catch(IOException e1) {
				logger.warn(e1.getMessage());
			}

			if (file != null && file.isFile()) file.delete();
		}
	}

	/**
	 * 파일경로 유효성
	 *
	 * @param value
	 * @return
	 */
	public String filePathBlackList(String value) {
		String returnValue = value;
		if (returnValue == null || returnValue.trim().equals("")) return "";
		returnValue = returnValue.replaceAll("\\.\\.", "");

		return returnValue;
	}

	/**
	 * 여러개의 파일을 zip으로 압축해 다운
	 *
	 * @param reportVO
	 * @param request
	 * @param response
	 */
	public void getZipFile(Map<String, Object> param, HttpServletResponse response) {
		response.setContentType("application/zip;charset=UTF-8");
		response.setHeader("Content-disposition", "attachment; filename=" + (String) param.get("reportId") + ".zip");

		String folderPath = propertiesService.getString("file.root.path")+File.separator+(String) param.get("projectId");

		ZipArchiveOutputStream zos = null;

		try {
			zos = new ZipArchiveOutputStream((OutputStream)response.getOutputStream());
			String fileNames = (String) param.get("fileNames");

			if(!StringUtils.isBlank(fileNames)) {
				String[] fileNameArr = fileNames.split(",");
				File folder = new File(folderPath);

				if(fileNameArr.length > 0 && folder.exists()) {
					for(String fileName : fileNameArr) {
						File file = new File(folderPath + File.separator + fileName);

						try {
							FileInputStream in = new FileInputStream(file);
							zos.putArchiveEntry(new ZipArchiveEntry(File.separator + file.getName()));

							byte[] buf = new byte[2048];
							int len;
							while ((len = in.read(buf)) > 0) zos.write(buf, 0, len);

							zos.closeArchiveEntry();
							in.close();
						}catch (IOException e1) {
							logger.warn(e1.getMessage());
						}
					}
				}
			}

			zos.flush();
			zos.close();
		} catch (Exception e) {
			logger.warn(e.getMessage());
			if(zos != null) {
				try {
					zos.close();
				} catch (IOException e1) {
					logger.warn(e1.getMessage());
				}
			}
		}
	}

}