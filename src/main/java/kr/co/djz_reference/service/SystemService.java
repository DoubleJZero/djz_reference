package kr.co.djz_reference.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.djz.entity.DjzHttpStatus;
import kr.co.djz.service.DjzCbsService;
import kr.co.djz.utility.DjzComUtil;
import kr.co.djz_reference.common.UserDetailsHelper;

/**
 * SystemService
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
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */

@Service("systemService")
@Transactional(rollbackFor = Exception.class, readOnly = true)
public class SystemService extends DjzCbsService {
	String serviceId = "SYSTEMSERVICE";

	/** Logger */
    //private static final Logger logger = LoggerFactory.getLogger(SystemService.class);

	/**
	 * 메뉴 조회
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getMenuList(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 705 : 조회결과 없음
    	 */
		List<Map<String, Object>> menuList = mapper.selectList(serviceId+".selectMenuList", param);

		if(menuList == null || menuList.size() == 0) return DjzComUtil.responseMap(DjzHttpStatus.DATA_EMPTY.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), menuList);
	}

	/**
	 * 메뉴 아이디 유효성 검사
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getIsValidMenuId(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 706 : 해당 메뉴ID 이미 사용중
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String menuId = (String) param.get("menuId");

		if(StringUtils.isBlank(menuId)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int cnt = mapper.selectOne(serviceId+".selectIsValidMenuIdCnt", param);

		if(cnt != 0) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 메뉴 등록
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getInsertMenu(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String menuGroup = (String) param.get("menuGroup");
		String menuDepth = (String) param.get("menuDepth");
		String menuId = (String) param.get("menuId");
		String menuName = (String) param.get("menuName");
		String menuDescription = (String) param.get("menuDescription");

		if(StringUtils.isBlank(menuGroup) || StringUtils.isBlank(menuDepth) || StringUtils.isBlank(menuId)
				|| StringUtils.isBlank(menuName) || StringUtils.isBlank(menuDescription)) {

			return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());
		}

		String menuOrder = (String) param.get("menuOrder");
		if(StringUtils.isBlank(menuOrder)) param.put("menuOrder", 0);

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("createUser", userInfo.get("userId"));
		param.put("updateUser", userInfo.get("userId"));

		mapper.insert(serviceId+".insertMenu", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 메뉴 수정
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getUpdateMenu(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String menuSeq = String.valueOf(param.get("menuSeq"));
		String menuGroup = (String) param.get("menuGroup");
		String menuDepth = (String) param.get("menuDepth");
		String menuId = (String) param.get("menuId");
		String menuName = (String) param.get("menuName");
		String menuDescription = (String) param.get("menuDescription");

		if(DjzComUtil.isStrNull(menuSeq) || StringUtils.isBlank(menuGroup) || StringUtils.isBlank(menuDepth)
				|| StringUtils.isBlank(menuId) || StringUtils.isBlank(menuName) || StringUtils.isBlank(menuDescription)) {

			return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());
		}

		String menuOrder = (String) param.get("menuOrder");
		if(StringUtils.isBlank(menuOrder)) param.put("menuOrder", 0);

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("updateUser", userInfo.get("userId"));

		mapper.update(serviceId+".updateMenu", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 메뉴 삭제
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getDeleteMenu(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String menuSeq = String.valueOf(param.get("menuSeq"));

		if(DjzComUtil.isStrNull(menuSeq)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		mapper.delete(serviceId+".deleteMenu", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}
}