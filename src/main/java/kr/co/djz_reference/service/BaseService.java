package kr.co.djz_reference.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.djz.entity.DjzHttpStatus;
import kr.co.djz.service.DjzCbsService;
import kr.co.djz.utility.DjzComUtil;
import kr.co.djz_reference.common.UserDetailsHelper;

/**
 * BaseService
 *
 * @author DoubleJZero
 * @since 2021.12.21
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.12.21    DoubleJZero      최초생성
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */

@Service("baseService")
@Transactional(rollbackFor = Exception.class, readOnly = true)
public class BaseService extends DjzCbsService {
	String serviceId = "BASESERVICE";

	/** Logger */
    private static final Logger logger = LoggerFactory.getLogger(SystemService.class);

	/**
	 * 사용자 조회
	 *
	 * @param param
	 * @return
	 */
	public Map<String, Object> getUserList(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 705 : 조회결과 없음
    	 */
		List<Map<String, Object>> menuList = mapper.selectList(serviceId+".selectUserList", param);

		if(menuList == null || menuList.size() == 0) return DjzComUtil.responseMap(DjzHttpStatus.DATA_EMPTY.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), menuList);
	}

	/**
	 * 사용자 등록
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getInsertUser(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : params의 값이 없음. 비정상 접근
    	 * 702 : 필수항목 유효하지 않음.
    	 * 706 : 중복체크 key값이 유효하지 않음.
    	 */
		int statusCode = DjzHttpStatus.NORMAL.getStatusCode();

		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String[] keys = {"userId", "userIdDupCheckKey", "userPw", "conPw", "userName", "zipcode"
				, "address", "addressDetail", "mobile", "mobileDupCheckKey", "email", "emailDupCheckKey"};

		if(DjzComUtil.isEssentialItemsEmpty(param, keys)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int userIdDupCheckKey = Integer.parseInt(String.valueOf(param.get("userIdDupCheckKey")));
		int mobileDupCheckKey = Integer.parseInt(String.valueOf(param.get("mobileDupCheckKey")));
		int emailDupCheckKey = Integer.parseInt(String.valueOf(param.get("emailDupCheckKey")));

		if(!DjzComUtil.isPrime(userIdDupCheckKey)) {
			logger.warn("########## 중복체크 key값이 유효하지 않음 itemName : userIdDupCheckKey ##########");

			return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());
		}

		if(!DjzComUtil.isPrime(mobileDupCheckKey)) {
			logger.warn("########## 중복체크 key값이 유효하지 않음 itemName : mobileDupCheckKey ##########");

			return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());
		}

		if(!DjzComUtil.isPrime(emailDupCheckKey)) {
			logger.warn("########## 중복체크 key값이 유효하지 않음 itemName : emailDupCheckKey ##########");

			return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());
		}

		/* ■ 필수 항목이 아닌경우 초기값 세팅 */
		if(StringUtils.isBlank((String) param.get("smsYn"))) param.put("smsYn", "N");
		if(StringUtils.isBlank((String) param.get("emailYn"))) param.put("emailYn", "N");
		if(StringUtils.isBlank((String) param.get("phone"))) param.put("phone", "");
		if(StringUtils.isBlank((String) param.get("positionName"))) param.put("positionName", "");

		/* ■ 암호화 */
		param.put("userPw", DjzComUtil.shaEncrypt((String) param.get("userPw")));

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("createUser", userInfo.get("userId"));
		param.put("updateUser", userInfo.get("userId"));

		/* ■ 사용자 테이블 insert */
		mapper.insert(serviceId+".insertUser", param);

		return DjzComUtil.responseMap(statusCode, param);
	}

	/**
	 * 사용자 수정
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getUpdateUser(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : params의 값이 없음. 비정상 접근
    	 * 702 : 필수항목 유효하지 않음.
    	 * 706 : 비밀번호 와 비밀번호 확인이 일치하지 않음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String[] keys = {"userName", "zipcode", "address", "addressDetail"};

		if(DjzComUtil.isEssentialItemsEmpty(param, keys)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		/* ■ 필수 항목이 아닌경우 초기값 세팅 */
		if(StringUtils.isBlank((String) param.get("smsYn"))) param.put("smsYn", "N");
		if(StringUtils.isBlank((String) param.get("emailYn"))) param.put("emailYn", "N");
		if(StringUtils.isBlank((String) param.get("pwModifyYn"))) param.put("pwModifyYn", "N");

		String userPw = (String) param.get("userPw");

		if(!StringUtils.isBlank(userPw)) {
			String conPw = (String) param.get("conPw");

			if(!userPw.equals(conPw)) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

			param.put("pwModifyYn", "Y");

			param.put("newPw", DjzComUtil.shaEncrypt(userPw));
		}

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();
		param.put("updateUser", userInfo.get("userId"));

		mapper.update(serviceId+".updateUser", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 사용자 삭제
	 *
	 * @param param
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getDeleteUser(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : 비정상 접근 - param null
    	 * 702 : 필수값 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String userId = String.valueOf(param.get("userId"));

		if(DjzComUtil.isStrNull(userId)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		mapper.delete(serviceId+".deleteUser", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}
}