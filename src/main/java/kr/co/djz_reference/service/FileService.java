package kr.co.djz_reference.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.rte.fdl.property.EgovPropertyService;
import kr.co.djz.service.DjzCbsService;
import kr.co.djz.utility.DjzComUtil;
import kr.co.djz_reference.common.UserDetailsHelper;

/**
 * FileService
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
@Service("fileService")
@Transactional(rollbackFor = Exception.class, readOnly = true)
public class FileService extends DjzCbsService {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileService.class);

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	String serviceId = "FILESERVICE";

	/**
	 * 여러 개의 파일에 대한 정보를 등록한다.
	 *
	 * @param request
	 * @param code
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public String insertFileInfos(HttpServletRequest request) {
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
		Map<String, MultipartFile> files = multiRequest.getFileMap();

		String atchflGrpId = request.getParameter("atchflGrpId");

		String userId = "";
		if (UserDetailsHelper.isAuthenticated()) {
			Map<String, Object> loginInfo = UserDetailsHelper.getAuthenticatedUser();

			userId = (String) loginInfo.get("userId");
		}

		if(!files.isEmpty()) {
			List<Map<String, Object>> list = parseFileInfo(files, atchflGrpId);

			for (Map<String, Object> map : list) {
				if(!StringUtils.isBlank(userId)) map.put("userId", userId);

				mapper.insert(serviceId+".insertFile", map);
			}

			if(list.size() != 0) atchflGrpId = (String) list.get(0).get("atchflGrpId");
		}

		return atchflGrpId;
	}

	/**
	 * 파일목록을 조회한다.
	 *
	 * @param param
	 * @return 파일목록
	 */
	public List<Map<String, Object>> getFileList(Map<String, Object> param) {

		return mapper.selectList(serviceId+".selectFileList", param);
	}

	/**
	 * 파일 정보를 조회한다.
	 *
	 * @param param
	 * @return 파일 상세정보
	 */
	public Map<String, Object> getFileInfo(Map<String, Object> param) {

		return mapper.selectOne(serviceId+".selectFileInfo", param);
	}

	/**
	 * 파일정보를 삭제한다.
	 *
	 * @param param
	 */
	@Transactional(rollbackFor = Exception.class)
	public void deleteFileInfo(Map<String, Object> param) {
		Map<String, Object> fileInfo = getFileInfo(param);
		String atchflRoute = (String) fileInfo.get("atchflRoute");
		String atchflId = (String) fileInfo.get("atchflId");

		if(!StringUtils.isBlank(atchflRoute)) {
			File file = new File(atchflRoute);

			if(file.exists()){
				if(file.delete()) LOGGER.debug("####### 파일삭제 완료. FILE PATH : {}, FILE ID : {} #######", atchflRoute, atchflId);
				else LOGGER.warn("####### 파일삭제 실패. FILE PATH : {}, FILE ID : {} #######", atchflRoute, atchflId);
			}else{
				LOGGER.warn("####### 파일이 존재하지 않습니다. FILE PATH : {}, FILE ID : {} #######", atchflRoute, atchflId);
			}
		}else {
			LOGGER.warn("####### 파일이 존재하지 않습니다. FILE ID : {} #######", atchflId);
		}

		mapper.delete(serviceId+".deleteFileInfo", param);
	}

	/**
	 * 파일그룹 전체를 삭제한다.
	 *
	 * @param param
	 */
	public void deleteFileList(Map<String, Object> param) {
		List<Map<String, Object>> fileList = getFileList(param);

		for (Map<String, Object> map : fileList) deleteFileInfo(map);
	}

	/**
	 * 첨부파일에 대한 목록 정보를 취득한다.
	 *
	 * @param files
	 * @return
	 */
	public List<Map<String, Object>> parseFileInfo(Map<String, MultipartFile> files, String atchflGrpId) {
		Map<String, Object> loginInfo = UserDetailsHelper.getAuthenticatedUser();

		String storePathString = propertiesService.getString("file.root.path");
		atchflGrpId = StringUtils.isBlank(atchflGrpId) ? DjzComUtil.getGnrUUID() : atchflGrpId;
		File saveFolder = new File(filePathBlackList(storePathString));

		if (!saveFolder.exists() || saveFolder.isFile()) {
			if (saveFolder.mkdirs()) LOGGER.debug("####### [file.mkdirs] saveFolder : Creation Success #######");
			else LOGGER.error("#######[file.mkdirs] saveFolder : Creation Fail #######");
		}

		MultipartFile file;
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		Map<String, Object> map;

		for(Map.Entry<String, MultipartFile> e : files.entrySet()){
			file = e.getValue();
			String orginFileName = file.getOriginalFilename();

			if(!DjzComUtil.isStrNull(orginFileName)) {
				int index = orginFileName.lastIndexOf(".");
				String atchflNm = "";
				String atchflExtnsnNm = "";
				if(index == 0) {
					atchflNm = orginFileName;
				}else {
					atchflNm = orginFileName.substring(0, index);
					atchflExtnsnNm = orginFileName.substring(index + 1);
				}

				String atchflPhscNm = DjzComUtil.getGnrUUID();

				String atchflRoute = storePathString + File.separator + atchflPhscNm;
				File saveFile = new File(atchflRoute);
				try {
					file.transferTo(saveFile);
				} catch (IllegalStateException e1) {
					LOGGER.warn(e1.getMessage());
				} catch (IOException e1) {
					LOGGER.warn(e1.getMessage());
				}

				map = new HashMap<String, Object>();
				map.put("atchflId", atchflPhscNm);
				map.put("atchflGrpId", atchflGrpId);
				map.put("atchflNm", atchflNm);
				map.put("atchflPhscNm", atchflPhscNm);
				map.put("atchflRoute", atchflRoute);
				map.put("atchflExtnsnNm", atchflExtnsnNm);
				map.put("atchflSize", saveFile.length());

				if (loginInfo != null) {
					map.put("createUser", loginInfo.get("userId"));
					map.put("updateUser", loginInfo.get("userId"));
				}

				result.add(map);
			}
		}

		return result;
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
}
