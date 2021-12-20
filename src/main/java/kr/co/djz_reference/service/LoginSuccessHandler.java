package kr.co.djz_reference.service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Service;

import kr.co.djz_reference.entity.SecUserDetailsVO;

@Service
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request,
			HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {

		SecUserDetailsVO userDetail = (SecUserDetailsVO) authentication.getPrincipal();

		request.getSession().setAttribute("loginInfo", userDetail.getUserInfo());
		request.getSession().setAttribute("userAuthInfo", userDetail.getUserAuthMenu());

		response.sendRedirect("/main/main.do");
	}
}
