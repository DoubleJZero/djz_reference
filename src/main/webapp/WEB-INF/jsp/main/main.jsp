<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/include/head.jsp" %>
    <style>


    	.noneStyleTag:link {text-decoration:none; color:#646464;}
		.noneStyleTag:visited {text-decoration:none; color:#646464;}
		.noneStyleTag:active {text-decoration:none; color:#646464;}
		.noneStyleTag:hover {text-decoration:none; color:#646464;}
    </style>
</head>

<body>

    <!-- [Left] start -->
	<jsp:include page="/left.do" />
    <!-- [Left] end -->

    <!-- [Header] start -->
	<jsp:include page="/header.do" />
    <!-- [Header] end -->

    <!-- [ Main Content ] start -->
    <section class="pcoded-main-container">
        <div class="pcoded-wrapper">
            <div class="pcoded-content01">
                <div class="pcoded-inner-content">
                    <div class="main-body">
                        <div class="page-wrapper">
                        	<div class="rows">
								<div class="col-sm-12">
									<div class="card">
										<div class="card-header">
				                            <h5>메인1</h5>
				                        </div>

										<div class="card-body">
											<div class="alert alert-light" style="padding-bottom:0px;">
												<p><a href="javascript:void(0);" class="noneStyleTag">메인 1-1</a></p>
												<p><a href="javascript:void(0);" class="noneStyleTag">메인 1-2</a></p>
												<p><a href="javascript:void(0);" class="noneStyleTag">메인 1-3</a></p>
						                    </div>
					                    </div>
				                    </div>
								</div>

								<div class="col-sm-12">
									<div class="card">
										<div class="card-header">
				                            <h5>메인2</h5>
				                        </div>

										<div class="card-body">
											<div class="alert alert-light" style="padding-bottom:0px;">
												<p><a href="javascript:void(0);" class="noneStyleTag">메인 2-1</a></p>
												<p><a href="javascript:void(0);" class="noneStyleTag">메인 2-2</a></p>
												<p><a href="javascript:void(0);" class="noneStyleTag">메인 2-3</a></p>
						                    </div>
					                    </div>
				                    </div>
								</div>

								<div class="col-sm-12">
									<div class="card">
										<div class="card-header">
				                            <h5>메인3</h5>
				                        </div>

										<div class="card-body">
											<div class="alert alert-light" style="padding-bottom:0px;">
												<p><a href="javascript:void(0);" class="noneStyleTag">메인 3-1</a></p>
												<p><a href="javascript:void(0);" class="noneStyleTag">메인 3-2</a></p>
												<p><a href="javascript:void(0);" class="noneStyleTag">메인 3-3</a></p>
						                    </div>
					                    </div>
				                    </div>
								</div>

							</div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- [ Main Content ] end -->
</body>

</html>