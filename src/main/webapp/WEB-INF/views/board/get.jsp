<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Read</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board Read
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div class="form-group">
                                <label>BNO</label>
                                <input class="form-control" name="bno" readonly="readonly" value="<c:out value="${board.bno}"/>">
                            </div>
                            <div class="form-group">
                                <label>Title</label>
                                <input class="form-control" name="title" readonly="readonly" value="<c:out value="${board.title}"/>">
                            </div>
                            <div class="form-group">
                                <label>Content</label>
                                <textarea class="form-control" rows="5" cols="50" name="content"><c:out value="${board.content}"/></textarea>
                            </div>
                            <div class="form-group">
                                <label>Writer</label>
                                <input class="form-control" name="writer"  value="<c:out value="${board.writer}"/>">
                            </div>
					         <form id="actionForm" action="/board/list" method="get">
					         	<input type="hidden" name="pageNum" value='${cri.pageNum}'>
					         	<input type="hidden" name="amount" value='${cri.amount}'>
					         	<input type="hidden" name="bno" value='${board.bno}'>
                            	<input type="hidden" name="type" value='<c:out value="${cri.type}"/>' />
                            	<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>' />
					         </form>
                            <button type="button" class="btn btn-default listBtn"><a href='/board/list'>List</a></button>
                            <button type="button" class="btn btn-default modBtn"><a href='/board/modify?bno=<c:out value="${board.bno}"/>'>Modify</a></button>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <i class="fa fa-comments fa-fw"></i>Reply
                            <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <ui class="chat">
                            </ui>
                        </div>
                        <!-- /.panel-body -->
                        <div class="panel-footer">

                        </div>
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>

            <!-- Modal -->
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <label>Reply</label> 
                                <input class="form-control" name='reply' value='New Reply!!!!'>
                            </div>      
                            <div class="form-group">
                                <label>Replyer</label> 
                                <input class="form-control" name='replyer' value='replyer'>
                            </div>
                            <div class="form-group">
                                <label>Reply Date</label> 
                                <input class="form-control" name='replyDate' value='2018-01-01 13:13'>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
                            <button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
                            <button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
                            <button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
                        </div>          
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
        <script type="text/javascript" src="/resources/js/reply.js"></script>
        <script type="text/javascript">
        
        console.log("=================");
        console.log("JS TEST");
        $(document).ready(function () {
            var bnoValue = '<c:out value = "${board.bno}"/>';
            var replyUL = $(".chat");

            showList(1);

            function showList(page) {
                replyService.getList(
                    {bno : bnoValue, page : page || 1},
                    function(replyCnt, list) {
                        console.log("list: " + list);
                        console.log(list);

                        if (page == -1) {
                            pageNum = Math.ceil(replyCnt/10.0);
                            showList(pageNum);
                            return;
                        }

                        var str = "";

                        if (list == null || list.length == 0) {
                            return;
                        }
                        for (var i = 0,  len = list.length || 0; i < len; i++) {
                            str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
                            str += "<div><div class='header'><strong class='primary-font'>["+list[i].rno+"]"+list[i].replyer+"</strong>";
                            str += "<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
                            str += "<p>"+list[i].reply+"</p></div></li>";
                        }
                        replyUL.html(str);

                        showReplyPage(replyCnt);
                    }
                );
            }

            var pageNum = 1;
            var replyPageFooter = $(".panel-footer");

            function showReplyPage(replyCnt) {
                var endNum = Math.ceil(pageNum / 10.0) * 10;
                var startNum = endNum - 9;

                var prev = startNum != 1;
                var next = false;
                if (endNum * 10 >= replyCnt) {
                    endNum = Math.ceil(replyCnt / 10.0);
                }
                if (endNum * 10 < replyCnt) {
                    next = true;
                }

                var str ="<ul class='pagination pull-right'>";
                
                if (prev) {
                    str += "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
                }

                for (let i = startNum; i <= endNum; i++) {
                    var active = pageNum == i? "active" : "";

                    str += "<li class='page-item "+active+"'><a class='page-link' href='"+i+"'>"+i+"</a></li>";
                }

                if (next) {
                    str += "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
                }

                str += "</ul></div>";

                console.log(str);

                replyPageFooter.html(str);
            }

            var modal = $(".modal");
            var modalInputReply = modal.find("input[name='reply']");
            var modalInputReplyer = modal.find("input[name='replyer']");
            var modalInputReplyDate = modal.find("input[name='replyDate']");

            var modalModBtn = $("#modalModBtn");
            var modalRemoveBtn = $("#modalRemoveBtn");
            var modalRegisterBtn = $("#modalRegisterBtn");

            $("#addReplyBtn").on("click", function (e) {
                modal.find("input").val("");
                modalInputReplyDate.closest("div").hide();
                modalRegisterBtn.show();
                $(".modal").modal("show");
            });

            modalRegisterBtn.on("click", function(e) {
                var reply = {
                    reply : modalInputReply.val(),
                    replyer : modalInputReplyer.val(),
                    bno : bnoValue
                };
                replyService.add(reply, function(result) {
                    alert(result);

                    modal.find("input").val("");
                    modal.modal("hide");

                    //showList(1);
                    showList(-1);
                })
            });

            $(".chat").on("click", "li", function (e) {
                var rno = $(this).data("rno");
                console.log(rno);
                replyService.get(rno, function(reply) {
                    modalInputReply.val(reply.reply);
                    modalInputReplyer.val(reply.replyer);
                    modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
                    modal.data("rno", reply.rno);

                    modal.find("button[id != 'modalCloseBtn']").hide();
                    modalModBtn.show();
                    modalRemoveBtn.show();

                    $(".modal").modal("show");
                });
            });

            modalModBtn.on("click", function(e) {
                var reply = {rno:modal.data("rno"), reply : modalInputReply.val()};

                replyService.update(reply, function(result) {
                    alert(result);
                    modal.modal("hide");
                    showList(pageNum);
                })
            });
            modalRemoveBtn.on("click", function(e) {
                var rno = modal.data("rno");

                replyService.remove(rno, function(result) {
                    alert(result);
                    modal.modal("hide");
                    showList(pageNum);
                })
            });
            replyPageFooter.on("click", "li a", function(e) {
                e.preventDefault();
                console.log("page click");

                var targetPageNum = $(this).attr("href");

                console.log("targetPageNum: "+targetPageNum);

                pageNum = targetPageNum;

                showList(pageNum);
            });
        });
        /*
        var bnoValue = '<c:out value = "${board.bno}"/>';
        
        replyService.add(
        	{reply:"JS TEST", replyer:"tester", bno : bnoValue},
        	function(result) {
				alert("RESULT : " + result)
			}
        );
        replyService.getList(
        	{bno : bnoValue, page : 1},
        	function(list) {
        		
        		for (var i = 0,  len = list.length || 0; i < len; i++) {
					console.log(list[i]);
				}
			}
        );
        replyService.remove(
        	23,
        	function(count) {
        		console.log(count);
        		if (count === "success") {
					alert("REMOVED");
				}
			}, function(err) {
				alert("ERROR.....")
			}
        );
        
        replyService.update(
        	{rno : 22, bno : bnoValue, reply : "Modified Reply...."},
        	function(result) {
				alert("수정 완료......");
			}
        );
        replyService.get(
        	10,
        	function(data) {
				console.log(data);
			}
        );
        */
		</script>
        <script>
        $(document).ready(function() {
	        var actionForm = $("#actionForm");
	        $(".listBtn").click(function(e) {
	    		e.preventDefault();
	    		actionForm.find("input[name='bno']").remove();
	    		actionForm.submit();
			});
	        $(".modBtn").click(function(e) {
	    		e.preventDefault();
	    		actionForm.attr("action", "/board/modify");
	    		actionForm.submit();
			});
		});
        </script>
    <%@include file="../includes/footer.jsp" %>