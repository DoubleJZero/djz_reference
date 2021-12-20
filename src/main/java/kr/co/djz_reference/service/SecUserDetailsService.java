package kr.co.djz_reference.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

				List<Map<String, Object>> authList = mapper.selectList(serviceId+".selectUserAuthList", param);

				List<String> strList = new ArrayList<String>();
				Map<String, Object> userAuthMenu = new HashMap<String, Object>();

				if(authList == null || authList.size() == 0) {
					userDetails.setAuthorities(null);
					userDetails.setAuthList(null);
				}else {
					for(Map<String, Object> map : authList) {
						String authId = (String) map.get("authId");

						if(!StringUtils.isBlank(authId)) strList.add(authId);
					}

					userDetails.setAuthorities(strList);
					userAuthMenu.put("authList", strList);

					List<Map<String, Object>> authMenuList = mapper.selectList(serviceId+".selectUserAuthMenuList", userAuthMenu);

					for(Map<String, Object> authMenu : authMenuList) {
						String menuId = (String) authMenu.get("menuId");
						if(!StringUtils.isBlank(menuId)) userAuthMenu.put(menuId, authMenu);
					}

					userDetails.setUserAuthMenu(userAuthMenu);
				}

			}
		} else {
			userDetails = (SecUserDetailsVO) principal;
		}

		return userDetails;
	}
}
