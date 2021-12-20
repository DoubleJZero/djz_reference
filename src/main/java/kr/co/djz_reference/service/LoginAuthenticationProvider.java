package kr.co.djz_reference.service;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AccountExpiredException;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;

import kr.co.djz.utility.DjzComUtil;
import kr.co.djz_reference.entity.SecUserDetailsVO;

/**
 * LoginAuthenticationProvider
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
public class LoginAuthenticationProvider implements AuthenticationProvider {

	/** Logger */
    private static final Logger logger = LoggerFactory.getLogger(LoginAuthenticationProvider.class);

	@Autowired
	SecUserDetailsService userDetailsService;

	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {

		/* ■ 사용자가 입력한 정보 */
		String userId = authentication.getName();
		String userPw = (String) authentication.getCredentials();

		String encUserPw = "";

		if(!StringUtils.isBlank(userPw)) encUserPw = DjzComUtil.shaEncrypt(userPw);

		/* ■ DB에서 가져온 정보 */
		SecUserDetailsVO userDetails = (SecUserDetailsVO) userDetailsService.loadUserByUsername(userId);

		/* ■ 인증 진행 */
		if(userDetails == null) {
			/* ■ 사용자 없음 */
			logger.warn("AuthenticationServiceException");

			throw new AuthenticationServiceException(userId);
		} else if (StringUtils.isBlank(encUserPw) || !userDetails.getPassword().equals(encUserPw)) {
			/* ■ 비밀번호 불일치 */
			logger.warn("BadCredentialsException");

			throw new BadCredentialsException(userId);
		} else if (!userDetails.isAccountNonLocked()) {
			/* ■ 잠긴 계정(미사용) */

			throw new LockedException(userId);
		} else if (!userDetails.isEnabled()) {
			/* ■ 미사용 계정(미사용) */

			throw new DisabledException(userId);
		} else if (!userDetails.isAccountNonExpired()) {
			/* ■ 만료된 계정(미사용) */

			throw new AccountExpiredException(userId);
		} else if (!userDetails.isCredentialsNonExpired()) {
			/* ■ 현재 비밀번호 사용 1년 경과 */
			logger.warn("CredentialsExpiredException");

			throw new CredentialsExpiredException(userId);
		}

		/* ■ 비밀번호 null처리, 사용하는 경우가 있어서 주석 */
		//userDetails.setPassword(null);

		return new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
	}

	@Override
	public boolean supports(Class<?> authentication) {

		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}
}
