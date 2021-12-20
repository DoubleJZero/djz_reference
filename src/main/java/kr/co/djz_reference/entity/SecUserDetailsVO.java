package kr.co.djz_reference.entity;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

/**
 * SecUserDetailsVO
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
public class SecUserDetailsVO implements UserDetails {

	private static final long serialVersionUID = 1L;

	private String username; // ID
	private String password; // PW
	private List<GrantedAuthority> authorities; // 권한
	private Map<String, Object> userInfo;
	private List<String> authList; // 메뉴용 권한
	private Map<String, Object> userAuthMenu; // 사용자별 메뉴 권한

	private boolean isAccountNonExpired; // 계정 만료여부
	private boolean isAccountNonLocked; // 계정 잠김여부
	private boolean isCredentialsNonExpired; // 비밀번호 만료여부
	private boolean isEnabled; // 계정 사용여부

	public SecUserDetailsVO() {
		this.isAccountNonExpired = true;
		this.isAccountNonLocked = true;
		this.isCredentialsNonExpired = true;
		this.isEnabled = true;
	}

	public List<String> getAuthList() {
		return authList;
	}

	public void setAuthList(List<String> authList) {
		this.authList = authList;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setIsAccountNonExpired(boolean isAccountNonExpired) {
		this.isAccountNonExpired = isAccountNonExpired;
	}

	public void setIsAccountNonLocked(boolean isAccountNonLocked) {
		this.isAccountNonLocked = isAccountNonLocked;
	}

	public void setIsCredentialsNonExpired(boolean isCredentialsNonExpired) {
		this.isCredentialsNonExpired = isCredentialsNonExpired;
	}

	public void setIsEnabled(boolean isEnabled) {
		this.isEnabled = isEnabled;
	}

	public void setUserInfo(Map<String, Object> userInfo) {
		this.userInfo = userInfo;
	}

	public void setAuthorities(List<String> authList) {

		List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();

		if(authList == null || authList.size() == 0) {
			authorities = null;
		} else {
			for(String auth : authList) authorities.add(new SimpleGrantedAuthority(auth));
		}

		this.authorities = authorities;
	}

	@Override
	public String getUsername() {

		return username;
	}

	@Override
	public String getPassword() {

		return password;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {

		return authorities;
	}

	@Override
	public boolean isAccountNonExpired() {

		return isAccountNonExpired;
	}

	@Override
	public boolean isAccountNonLocked() {

		return isAccountNonLocked;
	}

	@Override
	public boolean isCredentialsNonExpired() {

		return isCredentialsNonExpired;
	}

	@Override
	public boolean isEnabled() {

		return isEnabled;
	}

	public Map<String, Object> getUserInfo() {
		return userInfo;
	}

	public Map<String, Object> getUserAuthMenu() {
		return userAuthMenu;
	}

	public void setUserAuthMenu(Map<String, Object> userAuthMenu) {
		this.userAuthMenu = userAuthMenu;
	}
}
