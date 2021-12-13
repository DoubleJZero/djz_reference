<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- [Header] start -->
<header class="navbar pcoded-header navbar-expand-lg navbar-light headerpos-fixed" style="background: #f4f7fa;">
    <div class="m-header">
        <a class="mobile-menu" id="mobile-collapse1" href="#!"><span></span></a>
        <a href="/main/main.do" class="b-brand">
           <div class="b-bg">
               <i class="feather icon-trending-up"></i>
           </div>
           <span class="b-title"> </span>
       </a>
    </div>
    <a class="mobile-menu" id="mobile-header" href="#!">
        <i class="feather icon-more-horizontal"></i>
    </a>
    <div class="collapse navbar-collapse">
        <ul class="navbar-nav ml-auto">
            <li><spring:message code="header.msg1" /> : <span id="timer"></span></li>
            <li><a href="javascript:fn_changeLang('ko');">ko</a>|<a href="javascript:fn_changeLang('en');">en</a></li>
            <li>
                <div class="dropdown drp-user">
                    <a href="#" class="dropdown-toggle2" data-toggle="dropdown">
                        <i class="icon feather icon-settings"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right profile-notification">
                        <div class="pro-head">
                            <span><c:out value='${sessionScope.loginInfo.userName}'/></span>
                            <a href="javascript:void(0)" onclick="fn_actionLogout()" class="dud-logout" title="Logout">
                                <i class="feather icon-log-out"></i>
                            </a>
                        </div>
                        <ul class="pro-body">
                            <li><a href="javascript:void(0)" onclick="fn_createFormSubmit('/user/userModify.do', 'post')" class="dropdown-item"><i class="feather icon-user"></i> <spring:message code="header.userInfoModify" /></a></li>
                        </ul>
                    </div>
                </div>
            </li>
        </ul>
    </div>
    <div class="noErrorMsgDiv" style="display:none;"></div>
</header>
<!-- [Header] end -->
<script>

Lpad=function(str, len) {
	str = str + "";
	while(str.length < len) {
		str = "0"+str;
	}

	return str;
};

// 사용자로부터 마우스 또는 키보드 이벤트가 없을경우의 자동로그아웃까지의 대기시간, 분단위
var iMinute = 60;

// 자동로그아웃 처리 몇초전에 경고를 보여줄지 설정하는 부분, 초단위
var noticeSecond = 10;

var iSecond = iMinute * 60 ;
var timerchecker = null;

initTimer=function() {
	rMinute = parseInt(iSecond / 60);
	rSecond = iSecond % 60;
	if(iSecond > 0) {
		// 자동로그아웃 경고레이어에 경고문+남은 시간 보여주는 부분
		if (document.getElementById("timer") != null){
			$("#timer").html(Lpad(rMinute, 2)+"분"+Lpad(rSecond, 2)+"초");
		}

	    iSecond--;
	 	timerchecker = setTimeout("initTimer()", 1000); // 1초 간격으로 체크
	} else {
	 	clearTimeout(timerchecker);
	 	fn_actionLogout();
	}
}
window.onload = initTimer;// 현재 페이지 대기시간
document.onclick = reset;
document.onkeypress = reset;

function reset(){
	iSecond = iMinute * 60 ;
	clearTimeout(timerchecker);
	initTimer();
}

function fn_actionLogout(){
	fn_createFormSubmit("/actionLogout.do", "post");
}

function fn_changeGroupId(groupId){
	var curGroupCode = "<c:out value='${curGroupCode}'/>";

	/* ■ 현재와 변경된 코드가 같으면 동작 안함. */
	if(curGroupCode == groupId){
		return;
	}

	fn_createFormSubmit("/changeGroupId.do", "post","","groupId",groupId,1);
}

function fn_changeWB(){
	fn_createFormSubmit("/fn_changeWB.do", "post","","","",1);
}
</script>