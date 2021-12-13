package kr.co.djz_reference.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.property.EgovPropertyService;
import kr.co.djz.entity.DjzHttpStatus;
import kr.co.djz.service.DjzCbsService;
import kr.co.djz.utility.DjzComUtil;

/**
 * LoginService
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
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */

@Service("loginService")
@Transactional(rollbackFor = Exception.class, readOnly = true)
public class LoginService extends DjzCbsService {
	String serviceId = "LOGINSERVICE";

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** FileService */
	@Resource(name = "fileService")
	private FileService fileService;

	/** Logger */
    private static final Logger logger = LoggerFactory.getLogger(LoginService.class);

	/**
	 * 로그인 유효성 검사
	 *
	 * @param params
	 * @return
	 */
    @Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getLoginValidation(Map<String, Object> param) {
    	Map<String, Object> res = mapper.selectOne(serviceId+".selectUserInfo", param);

		String encPw = DjzComUtil.shaEncrypt((String) param.get("userPw"));

		/* ■ 비민번호 변경일
		 * 비밀번호 변경일이 null 또는 "" 일 경우 무조건 변경 하도록 하드코딩
		 */
		String changePwDate = "20200101";

		if(res != null) {
			changePwDate = (String) res.get("changePwDate");
			changePwDate = StringUtils.isBlank(changePwDate) ? "20200101" : changePwDate;
		}

		if(changePwDate.length() != 8) changePwDate = changePwDate.replaceAll("-", "");

		int statusCode = DjzHttpStatus.NORMAL.getStatusCode();

		/* ■ 상태코드
		 * 700 : 정상
    	 * 705 : 해당 아이디로 조회결과 없음
    	 * 706 : 비밀번호 불일치
    	 * 707 : 비밀번호 변경 후 12개월 경과
    	 */
		if(res == null) statusCode = DjzHttpStatus.DATA_EMPTY.getStatusCode();
		else if(!((String) res.get("userPw")).equals(encPw)) statusCode = DjzHttpStatus.ETC_FIRST.getStatusCode();
		else if(DjzComUtil.dateDiff(changePwDate) > 365) statusCode = DjzHttpStatus.ETC_SECOND.getStatusCode();

		return DjzComUtil.responseMap(statusCode, res);
	}

	/**
	 * 비밀번호 변경
	 *
	 * @param params
	 * @return
	 */
    @Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getChangePassword(Map<String, Object> param) {
    	Map<String, Object> res = mapper.selectOne(serviceId+".selectUserInfo", param);

		String userPw = (String) param.get("userPw");
		String newPw = (String) param.get("newPw");
		String conPw = (String) param.get("conPw");
		String encPw = DjzComUtil.shaEncrypt(userPw);

		int statusCode = DjzHttpStatus.NORMAL.getStatusCode();

		/* ■ 상태코드
		 * 700 : 정상
    	 * 705 : 해당 아이디로 조회결과 없음
    	 * 706 : 비밀번호 불일치
    	 * 707 : 기존비밀번호랑 동일
    	 * 708 : 새로운 비밀번호랑 비밀번호 확인이랑 불일치
    	 */
		if(res == null) {
			statusCode = DjzHttpStatus.DATA_EMPTY.getStatusCode();
		} else if(!((String) res.get("userPw")).equals(encPw)) {
			statusCode = DjzHttpStatus.ETC_FIRST.getStatusCode();
		} else if(userPw.equals(newPw)) {
			statusCode = DjzHttpStatus.ETC_SECOND.getStatusCode();
		} else if(!conPw.equals(newPw)) {
			statusCode = DjzHttpStatus.ETC_THIRD.getStatusCode();
		} else {
			param.put("newPw", DjzComUtil.shaEncrypt(newPw));
			mapper.update(serviceId+".updateUserPassword", param);
		}

		return DjzComUtil.responseMap(statusCode);
	}

	/**
	 * 회원정보를 조회한다.
	 * @param params - 조회할 정보가 담긴 param
	 * @return 회원정보
	 */
    @Transactional(rollbackFor = Exception.class)
	public Map<String, Object> selectUserInfo(Map<String, Object> param) {
    	Map<String, Object> res = getLoginValidation(param);

		int statusCode = (int) res.get("statusCode");

		/* ■ 현재로그인시간 update */
		if(statusCode == 700) mapper.update(serviceId+".updateUserLastLoginDate", param);

		return res;
	}

	/**
	 * 아이디 찾기
	 *
	 * @param params
	 * @return
	 */
	public Map<String, Object> getIdSearch(Map<String, Object> param) {
		Map<String, Object> userInfo = mapper.selectOne(serviceId+".selectSearchUserId", param);

		/* ■ 상태코드
		 * 700 : 정상
    	 * 706 : 해당 정보(이름,휴대폰번호)로 조회결과 없음
    	 */
		int statusCode = DjzHttpStatus.NORMAL.getStatusCode();

		if(userInfo == null) statusCode = DjzHttpStatus.ETC_FIRST.getStatusCode();

		return DjzComUtil.responseMap(statusCode, userInfo);
	}

	/**
	 * 약관동의
	 *
	 * @param params
	 * @return
	 */
	public Map<String, Object> getAgreement(Map<String, Object> param) {

		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : param의 값이 없음. 비정상 접근
    	 * 706 : 인터넷 이용약관에 동의함 체크 안됨(비정상 접근)
    	 * 707 : 개인정보 취급지침에 동의함 체크 안됨(비정상 접근)
    	 */
		int statusCode = DjzHttpStatus.NORMAL.getStatusCode();

		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		/* ■
		 * reqCk1 : 인터넷 이용약관에 동의함 체크될경우 "Y" 그렇지 않으면 "N"
    	 * reqCk2 : 개인정보 취급지침에 동의함 체크될경우 "Y" 그렇지 않으면 "N"
    	 * 정상적으로 프로세스진행했다면 무조건 "Y" 이지만 비정상적으로 접근 시 처리하기 위함.
    	 */
		String reqCk1 = (String) param.get("reqCk1");
		String reqCk2 = (String) param.get("reqCk2");

		if(StringUtils.isBlank(reqCk1) || "N".equals(reqCk1)) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());
		else if(StringUtils.isBlank(reqCk2) || "N".equals(reqCk2)) return DjzComUtil.responseMap(DjzHttpStatus.ETC_SECOND.getStatusCode());
		else param.put("authKey", DjzComUtil.getPrime());

		return DjzComUtil.responseMap(statusCode, param);
	}

	/**
	 * 회원가입
	 *
	 * @param params
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getJoinMembership(Map<String, Object> param) {

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

		/* ■ 사용자 테이블 insert */
		mapper.insert("USERSERVICE.insertUser", param);

		return DjzComUtil.responseMap(statusCode, param);
	}

	/**
	 * 비밀번호 초기화 유효성 검사 및 인증번호 발송
	 *
	 * @param params
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getPwSearch(Map<String, Object> param) {

		/* ■ 상태코드
		 * 700 : 정상
		 * 701 : param null
		 * 702 : 필수 항목의 값이 없음
		 * 705 : 조회결과 없음
		 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String userId = (String) param.get("userId");
		String mobile = (String) param.get("mobile");

		if(StringUtils.isBlank(userId) || StringUtils.isBlank(mobile)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int cnt = mapper.selectOne(serviceId+".selectIsPwcValidCnt", param);

		if(cnt == 0) return DjzComUtil.responseMap(DjzHttpStatus.DATA_EMPTY.getStatusCode());

		String certificationNumber = DjzComUtil.getRdNum(6);

		param.put("certificationNumber", certificationNumber);

		mapper.insert("USERSERVICE.insertUserCertificationNumber", param);

		Map<String, Object> sms = new HashMap<String, Object>();

		sms.put("smsToPhone", mobile.replaceAll("-", ""));
		sms.put("smsFromPhone", "0200000000");
		sms.put("smsMsg", "n본인확인인증번호는"+certificationNumber+"입니다.\n“타인노출금지”");

		mapper.insert("USERSERVICE.insertSmsQue", sms);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 비밀번호 초기화 인증번호 확인
	 *
	 * @param params
	 * @return
	 */
	public Map<String, Object> getPwcCertiConfirm(Map<String, Object> param) {

		/* ■ 상태코드
		 * 700 : 정상
		 * 701 : param null
		 * 702 : 필수 항목의 값이 없음
		 * 706 : 인증번호 불일치
		 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String userId = (String) param.get("userId");
		String certificationNumber = (String) param.get("certificationNumber");

		if(StringUtils.isBlank(userId) || StringUtils.isBlank(certificationNumber)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		Map<String, Object> certiInfo = mapper.selectOne("USERSERVICE.selectUserCertificationNumber", param);

		if(certiInfo == null) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		String ciCertificationNumber = (String) certiInfo.get("certificationNumber");

		if(StringUtils.isBlank(ciCertificationNumber) || !certificationNumber.equals(ciCertificationNumber)) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 비밀번호 초기화 비밀번호 변경
	 *
	 * @param params
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getPwcInit(Map<String, Object> param) {

		/* ■ 상태코드
		 * 700 : 정상
		 * 701 : param null
		 * 702 : 필수 항목의 값이 없음
		 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String userPw = (String) param.get("userPw");
		String conPw = (String) param.get("conPw");
		String userId = (String) param.get("userId");

		if(!userPw.equals(conPw) || StringUtils.isBlank(userId)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		/* ■ 암호화 */
		param.put("newPw", DjzComUtil.shaEncrypt(userPw));

		mapper.update(serviceId+".updateUserPassword", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}
}