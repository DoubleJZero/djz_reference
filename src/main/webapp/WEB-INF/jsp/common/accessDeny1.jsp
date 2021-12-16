<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp"%>
</head>
<body>
	<div class="auth-wrapper">
		<div class="auth-content subscribe">
			<div class="auth-bg">
				<span class="r"></span> <span class="r s"></span> <span class="r s"></span>
				<span class="r"></span>
			</div>
			<div class="card">
				<div class="card-body text-center">
					<div class="mb-4">
						<i class="feather icon-alert-triangle auth-icon"></i>
					</div>
					<h3 class="mb-4">
						<spring:message code='login.errMsg12' />
						<br>
						<spring:message code='system.msg11' />
					</h3>

					<button class="btn btn-primary shadow-2 mb-4" onclick="dynamicSubmit.createFormSubmit('/login.do', 'post');"><spring:message code="error.movetohome" /></button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
