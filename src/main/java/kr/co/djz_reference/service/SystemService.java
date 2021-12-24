package kr.co.djz_reference.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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

	/**
	 * 권한 조회
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getAuthList(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 705 : 조회결과 없음
    	 */
		List<Map<String, Object>> menuList = mapper.selectList(serviceId+".selectAuthList", param);

		if(menuList == null || menuList.size() == 0) return DjzComUtil.responseMap(DjzHttpStatus.DATA_EMPTY.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), menuList);
	}

	/**
	 * 권한 아이디 유효성 검사
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getIsValidAuthId(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 706 : 해당 메뉴ID 이미 사용중
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String authId = (String) param.get("authId");

		if(StringUtils.isBlank(authId)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int cnt = mapper.selectOne(serviceId+".selectIsValidAuthIdCnt", param);

		if(cnt != 0) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 권한 등록
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getInsertAuth(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String authId = (String) param.get("authId");
		String authDesc = (String) param.get("authDesc");

		if(StringUtils.isBlank(authId) || StringUtils.isBlank(authDesc)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("createUser", userInfo.get("userId"));
		param.put("updateUser", userInfo.get("userId"));

		mapper.insert(serviceId+".insertAuth", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 권한 수정
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getUpdateAuth(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String authId = (String) param.get("authId");
		String orgAuthId = (String) param.get("orgAuthId");
		String authDesc = (String) param.get("authDesc");


		if(DjzComUtil.isStrNull(authId) || StringUtils.isBlank(orgAuthId) || StringUtils.isBlank(authDesc)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("updateUser", userInfo.get("userId"));

		mapper.update(serviceId+".updateAuth", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 권한 삭제
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getDeleteAuth(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String authId = String.valueOf(param.get("authId"));

		if(DjzComUtil.isStrNull(authId)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		/* ■ 약어 deleteGroupAuthCasecadeAuthId, deleteAuthMenuCasecadeAuthId */
		mapper.delete(serviceId+".deleteGroupAuthCai", param);
		mapper.delete(serviceId+".deleteAuthMenuCai", param);
		mapper.delete(serviceId+".deleteAuth", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 그룹 조회
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getGroupList(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 705 : 조회결과 없음
    	 */
		List<Map<String, Object>> list = mapper.selectList(serviceId+".selectGroupList", param);

		if(list == null || list.size() == 0) return DjzComUtil.responseMap(DjzHttpStatus.DATA_EMPTY.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), list);
	}

	/**
	 * 그룹 등록
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getInsertGroup(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String groupName = (String) param.get("groupName");

		if(StringUtils.isBlank(groupName)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("createUser", userInfo.get("userId"));
		param.put("updateUser", userInfo.get("userId"));

		mapper.insert(serviceId+".insertGroup", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 그룹 수정
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getUpdateGroup(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String groupId = String.valueOf(param.get("groupId"));
		String groupName = (String) param.get("groupName");

		if(DjzComUtil.isStrNull(groupId) || StringUtils.isBlank(groupName)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("updateUser", userInfo.get("userId"));

		mapper.update(serviceId+".updateGroup", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 그룹 삭제
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getDeleteGroup(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String groupId = String.valueOf(param.get("groupId"));

		if(DjzComUtil.isStrNull(groupId)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		/* ■ 약어 deleteGroupAuthCasecadeGroupId, deleteGroupMemberCasecadeGroupId */
		mapper.delete(serviceId+".deleteGroupAuthCgi", param);
		mapper.delete(serviceId+".deleteGroupMemberCgi", param);
		mapper.delete(serviceId+".deleteGroup", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 그룹권한조회
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getGroupAuthList(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 705 : 조회결과 없음
    	 */
		List<Map<String, Object>> list = mapper.selectList(serviceId+".selectGroupAuthList", param);

		if(list == null || list.size() == 0) return DjzComUtil.responseMap(DjzHttpStatus.DATA_EMPTY.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), list);
	}

	/**
	 * 그룹 권한 등록
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getInsertGroupAuth(Map<String, Object> param, HttpServletRequest request) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 * 704 : 중복
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String authId = (String) param.get("authId");

		if(StringUtils.isBlank(authId)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int isDupCnt = mapper.selectOne(serviceId+".selectIsDupGroupAuthCnt", param);

		if(isDupCnt != 0) return DjzComUtil.responseMap(DjzHttpStatus.DUPLICATE.getStatusCode());

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("createUser", userInfo.get("userId"));
		param.put("updateUser", userInfo.get("userId"));

		mapper.insert(serviceId+".insertGroupAuth", param);

		setSessionUserAuthMenu(request);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 그룹 권한 삭제
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getDeleteGroupAuth(Map<String, Object> param, HttpServletRequest request) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 706 : 삭제할 데이터 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String authIds = (String) param.get("authIds");
		String isDels = (String) param.get("isDels");

		if(StringUtils.isBlank(authIds) || StringUtils.isBlank(isDels)) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		String[] authIdArr = authIds.split(",");
		String[] isDelArr = isDels.split(",");

		boolean isNotDel = true;

		for(int i = 0; i < authIdArr.length; i++) {
			if("Y".equals(isDelArr[i])) {
				param.put("authId", authIdArr[i]);
				mapper.delete(serviceId+".deleteGroupAuth", param);
				isNotDel = false;
			}
		}

		if(isNotDel) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		setSessionUserAuthMenu(request);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 그룹 멤버 사용자 조회
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getUserSearchList(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 705 : 조회결과 없음
    	 */
		List<Map<String, Object>> userList = mapper.selectList(serviceId+".selectUserSearchList", param);

		if(userList == null || userList.size() == 0) return DjzComUtil.responseMap(DjzHttpStatus.DATA_EMPTY.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), userList);
	}

	/**
	 * 그룹멤버조회
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getGroupMemberList(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 705 : 조회결과 없음
    	 */
		List<Map<String, Object>> list = mapper.selectList(serviceId+".selectGroupMemberList", param);

		if(list == null || list.size() == 0) return DjzComUtil.responseMap(DjzHttpStatus.DATA_EMPTY.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), list);
	}

	/**
	 * 그룹 멤버 등록
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getInsertGroupMember(Map<String, Object> param, HttpServletRequest request) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 * 704 : 중복
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String userId = (String) param.get("userId");

		if(StringUtils.isBlank(userId)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int isDupCnt = mapper.selectOne(serviceId+".selectIsDupGroupMemberCnt", param);

		if(isDupCnt != 0) return DjzComUtil.responseMap(DjzHttpStatus.DUPLICATE.getStatusCode());

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("createUser", userInfo.get("userId"));
		param.put("updateUser", userInfo.get("userId"));

		mapper.insert(serviceId+".insertGroupMember", param);

		setSessionUserAuthMenu(request);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 그룹 멤버 삭제
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getDeleteGroupMember(Map<String, Object> param, HttpServletRequest request) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 706 : 삭제할 데이터 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String userIds = (String) param.get("userIds");
		String isDels = (String) param.get("isDels");

		if(StringUtils.isBlank(userIds) || StringUtils.isBlank(isDels)) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		String[] userIdArr = userIds.split(",");
		String[] isDelArr = isDels.split(",");

		boolean isNotDel = true;

		for(int i = 0; i < userIdArr.length; i++) {
			if("Y".equals(isDelArr[i])) {
				param.put("userId", userIdArr[i]);
				mapper.delete(serviceId+".deleteGroupMember", param);
				isNotDel = false;
			}
		}

		if(isNotDel) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		setSessionUserAuthMenu(request);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 메뉴권한관리 조회
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getAuthMenuList(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 705 : 조회결과 없음
    	 */
		int cnt = mapper.selectOne(serviceId+".selectAuthMenuCnt", param);

		List<Map<String, Object>> list = null;

		if(cnt == 0) list = mapper.selectList(serviceId+".selectAuthMenuList1", param);
		else list = mapper.selectList(serviceId+".selectAuthMenuList2", param);

		if(list == null || list.size() == 0) return DjzComUtil.responseMap(DjzHttpStatus.DATA_EMPTY.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), list);
	}

	/**
	 * 메뉴권한관리 수정
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getUpdateAuthMenu(Map<String, Object> param, HttpServletRequest request) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String authId = (String) param.get("authId");
		String useYn = (String) param.get("useYn");
		String menuId = (String) param.get("menuId");
		String roleC = (String) param.get("roleC");
		String roleR = (String) param.get("roleR");
		String roleU = (String) param.get("roleU");
		String roleD = (String) param.get("roleD");
		String roleE = (String) param.get("roleE");
		String roleP = (String) param.get("roleP");

		if(StringUtils.isBlank(useYn) || StringUtils.isBlank(menuId) || StringUtils.isBlank(roleC) || StringUtils.isBlank(roleR)
				|| StringUtils.isBlank(roleU) || StringUtils.isBlank(roleD) || StringUtils.isBlank(roleE)
				|| StringUtils.isBlank(roleP) || StringUtils.isBlank(authId))
			return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		String[] useYnArr = useYn.split(",");
		String[] menuIdArr = menuId.split(",");
		String[] roleCArr = roleC.split(",");
		String[] roleRArr = roleR.split(",");
		String[] roleUArr = roleU.split(",");
		String[] roleDArr = roleD.split(",");
		String[] roleEArr = roleE.split(",");
		String[] rolePArr = roleP.split(",");

		Map<String, Object> saveMap = new HashMap<String, Object>();

		saveMap.put("authId", param.get("authId"));

		for(int i = 0; i < useYnArr.length; i++) {
			saveMap.put("useYn", useYnArr[i]);
			saveMap.put("menuId", menuIdArr[i]);
			saveMap.put("roleC", roleCArr[i]);
			saveMap.put("roleR", roleRArr[i]);
			saveMap.put("roleU", roleUArr[i]);
			saveMap.put("roleD", roleDArr[i]);
			saveMap.put("roleE", roleEArr[i]);
			saveMap.put("roleP", rolePArr[i]);

			mapper.delete(serviceId+".deleteAuthMenu", saveMap);
			mapper.insert(serviceId+".insertAuthMenu", saveMap);
		}

		setSessionUserAuthMenu(request);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 권한 변경으로 인한 세션 권한정보 변경
	 *
	 * @param request
	 */
	void setSessionUserAuthMenu(HttpServletRequest request) {
		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();

		List<Map<String, Object>> authList = mapper.selectList("LOGINSERVICE.selectUserAuthList", userInfo);

		List<String> strList = new ArrayList<String>();
		Map<String, Object> userAuthMenu = new HashMap<String, Object>();

		if(authList != null && authList.size() != 0) {
			for(Map<String, Object> map : authList) {
				String authId = (String) map.get("authId");

				if(!StringUtils.isBlank(authId)) strList.add(authId);
			}

			userAuthMenu.put("authList", strList);

			List<Map<String, Object>> authMenuList = mapper.selectList("LOGINSERVICE.selectUserAuthMenuList", userAuthMenu);

			for(Map<String, Object> authMenu : authMenuList) {
				String menuId = (String) authMenu.get("menuId");
				if(!StringUtils.isBlank(menuId)) userAuthMenu.put(menuId, authMenu);
			}

		}

		request.getSession().setAttribute("userAuthInfo", userAuthMenu);
	}

	/**
	 * 코드그룹 조회
	 *
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> getCodeGroupList(Map<String, Object> param) {

		return mapper.selectList(serviceId+".selectCodeGroupList", param);
	}

	/**
	 * 코드 조회
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getCodeList(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 705 : 조회결과 없음
    	 */
		List<Map<String, Object>> codeList = mapper.selectList(serviceId+".selectCodeList", param);

		if(codeList == null || codeList.size() == 0) return DjzComUtil.responseMap(DjzHttpStatus.DATA_EMPTY.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), codeList);
	}

	/**
	 * 코드 등록
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getInsertCode(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 * 704 : 해당코드그룹에 코드아이디 중복
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String codeGroup = (String) param.get("codeGroup");
		String codeId = (String) param.get("codeId");
		String codeData = (String) param.get("codeData");
		String codeOrder = (String) param.get("codeOrder");

		if(StringUtils.isBlank(codeGroup) || StringUtils.isBlank(codeId)
				|| StringUtils.isBlank(codeData) || StringUtils.isBlank(codeOrder))
			return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int cnt = mapper.selectOne(serviceId+".selectCodeIdCnt", param);

		if(cnt != 0) return DjzComUtil.responseMap(DjzHttpStatus.DUPLICATE.getStatusCode());

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("createUser", userInfo.get("userId"));
		param.put("updateUser", userInfo.get("userId"));

		mapper.insert(serviceId+".insertCode", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 코드 수정
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getUpdateCode(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String codeSeq = String.valueOf(param.get("codeSeq"));
		String codeData = (String) param.get("codeData");
		String codeOrder = (String) param.get("codeOrder");

		if(DjzComUtil.isStrNull(codeSeq)
				|| StringUtils.isBlank(codeData) || StringUtils.isBlank(codeOrder))
			return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("updateUser", userInfo.get("userId"));

		mapper.update(serviceId+".updateCode", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}
}