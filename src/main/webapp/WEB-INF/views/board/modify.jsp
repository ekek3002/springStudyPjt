<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Modify/Delete</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board Modify/Delete
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
	                        <form role="form" action="/board/modify" method="post">
	                        	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		                        <input type="hidden" name="pageNum" value='${cri.pageNum}'>
		                        <input type="hidden" name="amount" value='${cri.amount}'>
                            	<input type="hidden" name="type" value='<c:out value="${cri.type}"/>' />
                            	<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>' />
	                            <div class="form-group">
	                                <label>BNO</label>
	                                <input class="form-control" name="bno" readonly="readonly" value="<c:out value="${board.bno}"/>">
	                            </div>
	                            <div class="form-group">
	                                <label>Title</label>
	                                <input class="form-control" name="title" value="<c:out value="${board.title}"/>">
	                            </div>
	                            <div class="form-group">
	                                <label>Content</label>
	                                <textarea class="form-control" rows="5" cols="50" name="content"><c:out value="${board.content}"/></textarea>
	                            </div>
	                            <div class="form-group">
	                                <label>Writer</label>
	                                <input class="form-control" name="writer"  value="<c:out value="${board.writer}"/>">
	                            </div>
	                           	<sec:authentication property="principal" var="pinfo"/>
	                           	<sec:authorize access="isAuthenticated()">
	                           		<c:if test="${pinfo.username eq board.writer }">
			                            <button class="btn btn-default" data-oper="modify">Modify</button>
			                            <button class="btn btn-danger" data-oper="remove">Remove</button>
	                           		</c:if>
	                           	</sec:authorize>
	                            <button class="btn btn-info" data-oper="list">List</button>
	                        </form>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <div class="bigPictureWrapper">
                <div class="bigPicture">

                </div>
            </div>

<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
    align-content: center;
    text-align: center;
}

.uploadResult ul li img {
	width: 100px;
}

.uploadResult ul li span {
	color: white;
}

.bigPictureWrapper {
  position: absolute;
  display: none;
  justify-content: center;
  align-items: center;
  top:0%;
  width:100%;
  height:100%;
  background-color: gray; 
  z-index: 100;
  background: rgba(255, 255, 255, 0.5);
}

.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}

.bigPicture img{
    width: 600px;
}
</style>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Files
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
							<div class="form-group uploadDiv">
								<input type="file" name='uploadFile' multiple>
							</div>
                            <div class="uploadResult">
                                <ul>

                                </ul>
                            </div>
                        </div>
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            
			<script type="text/javascript">
				$(document).ready(function() {
					
					// var formObj = $("form");
					
					// $('.btn').click(function(e) {
					// 	e.preventDefault();
						
					// 	var operation = $(this).data("oper");
						
					// 	console.log(operation);
						
					//     if(operation === 'remove'){
					// 	      formObj.attr("action", "/board/remove");
						      
					// 	    }else if(operation === 'list'){
					// 	      //move to list
					// 	      formObj.attr("action", "/board/list").attr("method","get");
						      
					// 	      var pageNumTag = $("input[name='pageNum']").clone();
					// 	      var amountTag = $("input[name='amount']").clone();
					// 	      var keywordTag = $("input[name='keyword']").clone();
					// 	      var typeTag = $("input[name='type']").clone();      
						      
					// 	      formObj.empty();
						      
					// 	      formObj.append(pageNumTag);
					// 	      formObj.append(amountTag);
					// 	      formObj.append(keywordTag);
					// 	      formObj.append(typeTag);	       
					// 	    }
						    
					// 	    formObj.submit();
					// })
					var formObj = $("form");
					$("button").on("click", function (e) {
						console.log("button clicked");
						e.preventDefault();
						var operation = $(this).data("oper");
						console.log(operation);

						if (operation === 'remove') {
							formObj.attr("action", "/board/remove")
						} else if (operation === 'list') {
							formObj.attr("action", "/board/list").attr("method","get");
							
							var pageNumTag = $("input[name='pageNum']").clone();
							var amountTag = $("input[name='amount']").clone();
							var keywordTag = $("input[name='keyword']").clone();
							var typeTag = $("input[name='type']").clone();      
							
							formObj.empty();
							
							formObj.append(pageNumTag);
							formObj.append(amountTag);
							formObj.append(keywordTag);
							formObj.append(typeTag);
						} else if (operation === 'modify') {
							var str = "";
							$(".uploadResult ul li").each(function (i, obj) {
								var jobj = $(obj);
								console.dir(jobj);
								
								str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
								str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
								str+="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
								str+="<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
								console.log(str);
							});
							formObj.append(str).submit();
						}
						formObj.submit();
					});
				});
			</script>

			<script>
				$(document).ready(function () {
					(function(){
						var bno = '<c:out value = "${board.bno}"/>';
						$.getJSON("/board/getAttachList", {bno : bno},
							function (arr) {
								console.log(arr);
								var str = "";
								$(arr).each(function (i, attach) {
									if (attach.fileType) {
										var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
										str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>";
										str += "    <div>";
										str += "        <span>"+attach.fileName+"</span><br>";	
										str += "        <button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
										str += "        <img src='/display?fileName="+fileCallPath+"'>";
										str += "    </div>";
										str += "</li>";   
									} else {
										var fileCallPath = encodeURIComponent(attach.uploadPath+"/"+attach.uuid+"_"+attach.fileName);
										str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>";
										str += "    <a href='/download?fileName="+fileCallPath+"'>";
										str += "        <div>";
										str += "            <span>"+attach.fileName+"</span>";
										str += "        	<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
										str += "            <img src='/resources/img/attach.png'>";
										str += "        </div>";
										str += "    </a>";
										str += "</li>";     
									}
								});
								$(".uploadResult ul").html(str);
							}
						); 
					})();
					var regex = new RegExp("(.*?)\(exe|sh|zip|alz)$");
					var maxSize = 5242880; //5MB

					function checkExtension(fileName, fileSize) {
						if (fileSize >= maxSize) {
							alert("파일 사이즈 초과");
							return false;
						}
						if (regex.test(fileName)) {
							alert("해당 종류의 파일은 업로드할 수 없습니다.");
							return false;
						}
						return true;
					}

					var csrfHeaderName = "${_csrf.headerName}";
					var csrfTokenValue = "${_csrf.token}";
					$("input[type='file']").change(function (e) { 
						var formData = new FormData();
						var inputFile = $("input[name='uploadFile']");
						var files = inputFile[0].files;
						console.log(files);
						for (var i = 0; i < files.length; i++) {
							if (!checkExtension(files[i].name, files[i].size)) {
								return false;
							}
							formData.append("uploadFile", files[i]);            
						}
				
						$.ajax({
							url: "/uploadAjaxAction",
							processData: false,
							contentType: false,
							data: formData,
							type: "POST",
							dataType: "json",
							beforeSend: function (xhr) {
								xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
							},
							success: function (result) {
								console.log(result);

								showUploadedResult(result);

								// $(".uploadDiv").html(cloneObj.html());
							}
						});   
					});
					$(".uploadResult").on("click", "button", function (e) {
						console.log("delete file");

						if (confirm("Remove this file? ")) {
							var targetLi = $(this).closest("li");
							targetLi.remove();
						}
					});
					function showUploadedResult(uploadResultArr) {
						
						if (!uploadResultArr || uploadResultArr.length == 0) {
							return;
						}
						var uploadUL = $(".uploadResult ul");
						var str = "";
						$(uploadResultArr).each(function (i, obj) {
							if (obj.image) {
								var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
								str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
								str += "    <div>";
								str += "        <span>"+obj.fileName+"</span>";
								str += "        <button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
								str += "        <img src='/display?fileName="+fileCallPath+"'>";
								str += "    </div>";
								str += "</li>";
							} else {
								var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);			      
								var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
								str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
								str += "    <div>";
								str += "        <span>"+obj.fileName+"</span>";
								str += "        <button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
								str += "        <img src='/resources/img/attach.png'>";
								str += "    </div>";
								str += "</li>";
							}
						});

						uploadUL.append(str);
					}
				});
			</script>
    <%@include file="../includes/footer.jsp" %>