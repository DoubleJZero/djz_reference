<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>404 Dash Able Bootstrap Admin Template</title>
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<link rel="icon" href="images/favicon.ico" type="image/x-icon"/>
	<!-- Google font-->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,700" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="/extra-pages/404/css/style.css"/>
</head>
<body>
	<div id="container" class="container">
		<ul id="scene" class="scene">
			<li class="layer" data-depth="1.00"><img src="/extra-pages/404/images/404-01.png"></li>
			<li class="layer" data-depth="0.60"><img src="/extra-pages/404/images/shadows-01.png"></li>
			<li class="layer" data-depth="0.20"><img src="/extra-pages/404/images/monster-01.png"></li>
			<li class="layer" data-depth="0.40"><img src="/extra-pages/404/images/text-01.png"></li>
			<li class="layer" data-depth="0.10"><img src="/extra-pages/404/images/monster-eyes-01.png"></li>
		</ul>
		<h1><spring:message code="error.notFound" /></h1>
		<a href="/main/main.do" class="btn"><spring:message code="error.movetohome" /></a>
	</div>
	<!-- Scripts -->
	<script src="/extra-pages/404/js/parallax.js"></script>
	<script>
	// Pretty simple huh?
	var scene = document.getElementById('scene');
	var parallax = new Parallax(scene);
	</script>

</body>
</html>