package kr.co.djz_reference.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.rte.fdl.property.EgovPropertyService;
import kr.co.djz.common.DjzMail;
import kr.co.djz.entity.DjzHttpStatus;
import kr.co.djz.service.DjzCbsService;
import kr.co.djz.utility.DjzComUtil;
import kr.co.djz_reference.common.UserDetailsHelper;

/**
 * UserService
 *
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

@Service("userService")
@Transactional(rollbackFor = Exception.class, readOnly = true)
public class UserService extends DjzCbsService {
	String serviceId = "USERSERVICE";

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** commonService */
	@Resource(name = "commonService")
	protected CommonService commonService;

	/** fileService */
	@Resource(name = "fileService")
	protected FileService fileService;

	/** Logger */
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    /**
     * 회원정보 수정
     *
     * @param params
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getUserModify(Map<String, Object> param, HttpServletRequest request) {

    	/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : params의 값이 없음. 비정상 접근
    	 * 702 : 필수항목 유효하지 않음.
    	 * 706 : 비밀번호 불일치
    	 * 707 : 기존비밀번호와 동일
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String[] keys = {"userPw", "userName", "zipcode", "address", "addressDetail"};

		if(DjzComUtil.isEssentialItemsEmpty(param, keys)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		/* ■ 필수 항목이 아닌경우 초기값 세팅 */
		if(StringUtils.isBlank((String) param.get("smsYn"))) param.put("smsYn", "N");
		if(StringUtils.isBlank((String) param.get("emailYn"))) param.put("emailYn", "N");
		if(StringUtils.isBlank((String) param.get("pwModifyYn"))) param.put("pwModifyYn", "N");

		/* ■ 원래의 사용자 정보 */
		Map<String, Object> loginInfo = UserDetailsHelper.getAuthenticatedUser();

		String encPw = DjzComUtil.shaEncrypt((String) param.get("userPw"));
		String userPw = (String) loginInfo.get("userPw");

		if(!userPw.equals(encPw)) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		String pwModifyYn = (String) param.get("pwModifyYn");

		if("Y".equals(pwModifyYn)) {
			if(DjzComUtil.isStrNull((String) param.get("newPw"))) {
				logger.warn("########## 필수항목 유효하지 않음 itemName : {} ##########", "newPw");

				return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());
			}

			if(DjzComUtil.isStrNull((String) param.get("conPw"))) {
				logger.warn("########## 필수항목 유효하지 않음 itemName : {} ##########", "conPw");

				return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());
			}

			/* ■ 암호화 */
			String newPw = DjzComUtil.shaEncrypt((String) param.get("newPw"));
			param.put("newPw", newPw);

			if(userPw.equals(newPw)) return DjzComUtil.responseMap(DjzHttpStatus.ETC_SECOND.getStatusCode());
		}

		mapper.update(serviceId+".updateUser", param);

		Map<String, Object> newLoginInfo = mapper.selectOne("LOGINSERVICE.selectUserInfo", param);

		/* ■ 변경된 회원정보로 세션 교체 */
		request.getSession().setAttribute("loginInfo", newLoginInfo);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

    /**
     * 자기소개서 등록
     *
     * @param request
     * @param param
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> getInsertIntr(HttpServletRequest request, Map<String, Object> param) {
    	/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : params의 값이 없음. 비정상 접근
    	 * 702 : userId 미확인
    	 * 706 : 첨부파일 없음.
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String userId = (String) param.get("userId");

		if(StringUtils.isBlank(userId)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		String atchflGrpId = fileService.insertFileInfos(request);

		if(StringUtils.isBlank(atchflGrpId)) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		param.put("atchflGrpId", atchflGrpId);

		Map<String, Object> userInfo = UserDetailsHelper.getAuthenticatedUser();

		param.put("createUser", userInfo.get("userId"));
		param.put("updateUser", userInfo.get("userId"));

		/* ■ 자기소개서 등록 */
		mapper.insert(serviceId+".deleteIntr", param);
		mapper.insert(serviceId+".insertIntr", param);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), param);
	}

    /**
     * 자기소개서 조회
     *
     * @param param
     * @return
     */
	public Map<String, Object> getIntr(Map<String, Object> param) {
		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : param null
    	 * 702 : userId 미확인
    	 * 705 : 데이터 없음
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM	.getStatusCode());

		String userId = (String) param.get("userId");

		if(StringUtils.isBlank(userId)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		Map<String, Object> res = mapper.selectOne(serviceId+".selectIntr", param);

		if(res == null) return DjzComUtil.responseMap(DjzHttpStatus.DATA_EMPTY.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode(), res);
	}

    /**
     * 휴대폰 인증번호 생성 및 발송
     *
     * @param param
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getCreateCertiMobileNum(Map<String, Object> param) {

    	/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : param is null
    	 * 702 : 필수값 null
    	 * 706 : 이미 사용중인 휴대폰번호
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String userId = (String) param.get("userId");
		String mobile = (String) param.get("mobile");

		if(StringUtils.isBlank(userId) || StringUtils.isBlank(mobile)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int isDupCnt = mapper.selectOne(serviceId+".selectIsDupUserMobileCnt", param);

		if(isDupCnt != 0) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		String certificationNumber = DjzComUtil.getRdNum(6);

		param.put("certificationNumber", certificationNumber);

		mapper.insert(serviceId+".insertUserCertificationNumber", param);

		Map<String, Object> sms = new HashMap<String, Object>();

		sms.put("smsToPhone", mobile.replaceAll("-", ""));
		sms.put("smsFromPhone", "0200000000");
		sms.put("smsMsg", "본인확인인증번호는"+certificationNumber+"입니다.\n“타인노출금지”");

		mapper.insert(serviceId+".insertSmsQue", sms);

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

    /**
     * 인증번호 확인
     *
     * @param param
     * @return
     */
	public Map<String, Object> getCheckCertiNum(Map<String, Object> param) {

		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : param is null
    	 * 702 : 필수값 null
    	 * 706 : 인증번호 불일치
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String userId = (String) param.get("userId");
		String certificationNumber = (String) param.get("certificationNumber");

		if(StringUtils.isBlank(userId) || StringUtils.isBlank(certificationNumber)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		Map<String, Object> certiInfo = mapper.selectOne(serviceId+".selectUserCertificationNumber", param);

		if(certiInfo == null) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		String ciCertificationNumber = (String) certiInfo.get("certificationNumber");

		if(StringUtils.isBlank(ciCertificationNumber) || !certificationNumber.equals(ciCertificationNumber)) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	/**
	 * 이메일 인증번호 생성 및 발송
	 *
	 * @param userVO
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> getCreateCertiEmailNum(Map<String, Object> param) {

		/* ■ 상태코드
		 * 700 : 정상
    	 * 701 : param is null
    	 * 702 : 필수값 null
    	 * 706 : 이미 존재하는 이메일
    	 * 707 : 인증번호 발송실패
    	 */
		if(param == null) return DjzComUtil.responseMap(DjzHttpStatus.INVALID_PARAM.getStatusCode());

		String userId = (String) param.get("userId");
		String email = (String) param.get("email");

		if(StringUtils.isBlank(userId) || StringUtils.isBlank(email)) return DjzComUtil.responseMap(DjzHttpStatus.EMPTY_ESSENTIAL.getStatusCode());

		int isDupCnt = mapper.selectOne(serviceId+".selectIsDupUserEmailCnt", param);

		if(isDupCnt != 0) return DjzComUtil.responseMap(DjzHttpStatus.ETC_FIRST.getStatusCode());

		String certificationNumber = DjzComUtil.getRdNum(6);

		param.put("certificationNumber", certificationNumber);

		mapper.insert(serviceId+".insertUserCertificationNumber", param);

		Map<String, Object> mailInfo = new HashMap<String, Object>();
		mailInfo.put("subject", "이메일 인증번호");
		mailInfo.put("receptionAddress", email);
		mailInfo.put("contents", getEmailHtml(certificationNumber));

		if(!DjzMail.sendMail(mailInfo)) return DjzComUtil.responseMap(DjzHttpStatus.ETC_SECOND.getStatusCode());

		return DjzComUtil.responseMap(DjzHttpStatus.NORMAL.getStatusCode());
	}

	String getEmailHtml(String certiNum) {
		String contents = "";

		contents += "<!DOCTYPE html>";
		contents += "<html lang='ko'>";
		contents += "<head>";
		contents += "<title>Reference Title</title>";
  		contents += "<meta charset='utf-8'>";
  		contents += "<meta http-equiv='X-UA-Compatible' content='IE=edge'>";
  		contents += "<meta name='viewport' content='width=device-width, initial-scale=1'>";
  		contents += "<style>";
  		contents += "* {box-sizing: border-box;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;}";
     	contents += "body, html { margin:0;padding: 0;   color: #535454 !important;}";
		contents += "table { border-collapse: collapse; border:1px solid #cccccc; width:570px;}";
		contents += ".zone_1 {width:100%;height:auto;margin:0; padding:0;margin-top:50px;margin-bottom:20px;}";
		contents += ".zone_2 {width:605px; height:auto; margin:0 auto;/* border:1px solid #e2e1e1;*/border-bottom:0;padding-bottom:0px;background-color: #f0f1f1;box-shadow: 1px 2px 5px #cacaca;}";
		contents += ".tit_zone {width:100%;text-align:center;padding-top:13px; padding-bottom:13px;font-size:21px; color:#1a54aa;";
		contents += "font-family: 'Noto Sans KR', sans-serif;font-weight:510;letter-spacing:-0.5px;border-top: 2px solid #0052cd;border-bottom:1px solid #d2d1d1;";
		contents += "background-color: #fff;}";
		contents += ".zone_3 {width:605px;height:250px;box-sizing:border-box;padding: 0; margin-top:0px;background:#2c66bd;	position:relative;}";
		contents += ".te_zone {box-sizing:border-box;width:605px;height:250px;padding:25px 24px 24px 24px;margin:0;text-align:left; ";
		contents += "text-shadow: 2px 2px 3px rgb(45, 78, 126);}";
		contents += "p {margin:0;padding:0;box-sizing:border-box;}";
	    contents += ".te2_zone {font-size:17px; color: #fff;font-family: 'Noto Sans KR', sans-serif;font-weight:400;letter-spacing:-0.3px;}";
		contents += "a.noticebtn_01:hover {display:block;border-radius: 80px;padding:4px 5px;width:318px;letter-spacing:-1px;";
		contents += "text-align:center;font-size:15px;background: rgb(255, 255, 255);color:#1a54aa !important;border:1px solid #ffffff;";
		contents += "margin-top:18px;margin-bottom:14px;text-decoration: none !important; text-shadow: 2px 2px 3px rgb(255, 255, 255);}";
		contents += "a.noticebtn_01 {background:#2c66bd;color:#fff;border:1px solid #bed2ee;border-radius:80;margin-top:18px;margin-bottom:14px;font-size:15px;";
		contents += "display:block;border-radius: 80px;padding:4px 5px;width:318px;letter-spacing:-1px; text-align:center;}";
		contents += "table.box_1 {margin-top:18px;margin-left:auto;margin-right:auto;border-top:2px solid #0086cd;background-color: #fff;}";
		contents += "td.box_2 {width:140px;text-align:center;padding:10px; text-align:center;border-right:1px solid #cccccc;";
		contents += "font-weight:600;font-size:17px !important;letter-spacing:-1px;color:#033177;box-sizing:border-box;}";
		contents += "td.box_3 {padding:9px 8px 9px 9px; text-align:left;border-bottom:1px solid #cccccc;height:25px;font-size:13px !important;box-sizing:border-box;}";
		contents += ".footerzone_1 {margin-top:18px; margin-bottom:0; width:100%; height:34px;background:#2c66bd;border:none;padding-top:1px 0;}";
		contents += ".footerzone_2 {text-align:center;font-size:12px; color:#e5eef3;margin-left:auto; margin-right:auto;margin:0;padding:0;";
		contents += "width:100%;padding-top:9px;line-height:1.3;font-weight:300;}";
		contents += "</style>";
		contents += "</head>";
  		contents += "<body>";
		contents += "<div class='zone_1'>";
		contents += "<div class='zone_2' >";
		contents += "<div class='tit_zone'>";
		contents += "Reference Administrator";
		contents += "</div>";
		contents += "<div class='zone_3'>";
		contents += "<div class='te_zone'>";
		contents += "<p class='te2_zone'>";
		contents += "안녕하십니까?<br>";
		contents += "Reference Administrator 입니다.<br><br>";
		contents += "회원정보 수정을 위한 인증번호를 알려드립니다.<br><br>";
		contents += "<span style='font-weight:500;font-size:18px;'>인증번호:"+certiNum+"</span><br><br>";
		contents += "본 메일은 보안을 위해 확인 후 삭제 하시기 바랍니다.<br>";
		contents += "본 메일은 발신 전용이며, 회신하실 경우 답변되지 않습니다.";
		contents += "</p>";
		contents += "</div>";
		contents += "</div>";
		contents += "</div>";
		contents += "</div>";
		contents += "</body>";
		contents += "</html>";

		return contents;
	}
}