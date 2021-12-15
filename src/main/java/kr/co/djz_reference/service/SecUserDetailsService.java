package kr.co.djz_reference.service;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;

import kr.co.djz.service.DjzCbsService;
import kr.co.djz.utility.DjzComUtil;
import kr.co.djz_reference.entity.SecUserDetailsVO;

public class SecUserDetailsService extends DjzCbsService implements UserDetailsService {
	String serviceId = "LOGINSERVICE";

	@Override
	public UserDetails loadUserByUsername(String inputUserId) {

		Object principal = null;

		if(SecurityContextHolder.getContext().getAuthentication() != null) principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

		SecUserDetailsVO userDetails = null;

		if(principal == null) {
			userDetails = new SecUserDetailsVO();

			Map<String, Object> param = new HashMap<String, Object>();
			param.put("userId", inputUserId);

			Map<String, Object> userInfo = mapper.selectOne(serviceId+".selectUserInfo", param);

			if (userInfo == null) {

				return null;
			} else {
				userDetails.setUsername((String) userInfo.get("userId"));
				userDetails.setPassword((String) userInfo.get("userPw"));

				String changePwDate = (String) userInfo.get("changePwDate");

				if(StringUtils.isAllBlank(changePwDate)) changePwDate = "20200101";

				if(changePwDate.length() != 8) changePwDate = changePwDate.replaceAll("-", "");

				if(DjzComUtil.dateDiff(changePwDate) > 365) userDetails.setIsCredentialsNonExpired(false);

				userDetails.setUserInfo(userInfo);

				// 사용자 권한 select해서 받아온 List<String> 객체 주입
				//userDetails.setAuthorities(mapper.selectUserAuthOne(inputUserId));
			}
		} else {
			userDetails = (SecUserDetailsVO) principal;
		}

		return userDetails;
	}
}
