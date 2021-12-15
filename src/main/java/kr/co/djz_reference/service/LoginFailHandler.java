package kr.co.djz_reference.service;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.authentication.AccountExpiredException;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Service;

@Service
public class LoginFailHandler implements AuthenticationFailureHandler {
	/** Logger */
    private static final Logger logger = LoggerFactory.getLogger(LoginFailHandler.class);

	@Override
	public void onAuthenticationFailure(HttpServletRequest request,
		HttpServletResponse response, AuthenticationException exception)
		throws IOException, ServletException {

		if (exception instanceof AuthenticationServiceException) {
			request.setAttribute("statusCode", "705");

			logger.warn("AuthenticationServiceException");
		} else if(exception instanceof BadCredentialsException) {
			request.setAttribute("statusCode", "706");
			request.setAttribute("searchUserId", exception.getMessage());

			logger.warn("BadCredentialsException : {}", exception.getMessage());
		} else if(exception instanceof LockedException) {

			logger.warn("LockedException");
		} else if(exception instanceof DisabledException) {

			logger.warn("DisabledException");
		} else if(exception instanceof AccountExpiredException) {

			logger.warn("AccountExpiredException");
		} else if(exception instanceof CredentialsExpiredException) {
			request.setAttribute("statusCode", "707");

			logger.warn("CredentialsExpiredException");
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher("/login.do");
		dispatcher.forward(request, response);
	}
}
