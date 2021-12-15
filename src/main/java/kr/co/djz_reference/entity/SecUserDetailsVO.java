package kr.co.djz_reference.entity;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

public class SecUserDetailsVO implements UserDetails {

	private static final long serialVersionUID = 1L;

	private String username; // ID
	private String password; // PW
	private List<GrantedAuthority> authorities; // 권한
	private Map<String, Object> userInfo;

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

		for (int i = 0; i < authList.size(); i++) {
			authorities.add(new SimpleGrantedAuthority(authList.get(i)));
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
}
