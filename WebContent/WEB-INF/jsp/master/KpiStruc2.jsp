<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ page contentType="text/html; charset=utf-8" %> 
<%@ page import="javax.portlet.PortletURL" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="chandraFn" uri="http://localhost:8080/web/function" %>

<portlet:actionURL var="formActionInsert">
	<portlet:param name="action" value="doInsert"/>
</portlet:actionURL> 
<portlet:actionURL var="formActionEdit">
	<portlet:param name="action" value="doEdit"/>
</portlet:actionURL> 
<portlet:actionURL var="formActionDelete">
	<portlet:param name="action" value="doDelete"/>
</portlet:actionURL> 
<portlet:actionURL var="formActionFilter">
	<portlet:param name="action" value="doFilter"/>
</portlet:actionURL> 
<portlet:actionURL var="formActionSearch">
	<portlet:param name="action" value="doSearch"/>
</portlet:actionURL> 
<portlet:actionURL var="formActionListPage">
	<portlet:param name="action" value="doListPage"/>
</portlet:actionURL> 
<portlet:actionURL var="formActionPageSize"> <portlet:param name="action" value="doPageSize"/> </portlet:actionURL>
<portlet:resourceURL var="getPlan" id="getPlan" ></portlet:resourceURL>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <!-- Bootstrap core CSS --> 
    <link rel="stylesheet" href="<c:url value="/resources/bootstrap/css/bootstrap.min.css"/>" type="text/css"/>
    <link rel="stylesheet" href="<c:url value="/resources/bootstrap/css/bootstrap-responsive.min.css"/>" type="text/css"/>
    <link rel="stylesheet" href="<c:url value="/resources/css/common-element.css"/>" type="text/css"/>
    <script src="<c:url value="/resources/js/jquery-1.11.2.min.js"/>"></script> 
    <script  src="<c:url value="/resources/js/jquery-ui.min.js"/>"></script>
    <link rel="stylesheet" href="<c:url value="/resources/css/jquery-ui.min.css"/>"/>
    <script src="<c:url value="/resources/bootstrap/js/bootstrap.min.js"/>"></script>
	<script  src="<c:url value="/resources/bootstrap/js/bootstrap-typeahead.min.js"/>"></script>
	<script src="<c:url value="/resources/js/confirm-master/jquery.confirm.min.js"/>"></script>
	

	<style>

		select.listStatus{
			width:100px;
			height:30px;
			vertical-align: middle;
			margin-bottom: 0px;
		}
	</style>


    <script type="text/javascript"> 
   	  	var dialog,dialog2, gobalStucName, gobalGroupVal, gobalCriVal,gobalActive;
    	$( document ).ready(function() {
    		setDefault();
    		paging();
    		$('.numPage').val(${PageCur});
    		$('.pageSize').val(${pageSize});
    		$('div.paging button:contains('+ ${PageCur} +')').css({'color':'#009ae5','text-decoration':'underline','border':'0.5px solid #009ae5'});
    		pageMessage();
    	});
    	function setDefault(){
    		$('#filterGroup').val(${groupId});
    	}
    	function pageMessage(){
    		if($("#messageMsg").val()){
    			if($("#messageMsg").val() == 100){ //ok
    				$("#msgAlert").removeClass().addClass("alert");
    				$("span#headMsg").html("");
    				$("#msgAlert").fadeTo(1000, 100).slideUp(500, function(){
                	    $("#msgAlert").alert('close');
                	});
    			}else{
    				$("#msgAlert").removeClass().addClass("alert alert-danger");
    				$("span#headMsg").append("<strong> ผิดพลาด! </strong>");    				
    				$("#msgAlert").fadeTo(1000, 100).slideUp(500, function(){
                	    $("#msgAlert").alert('close');
                	});
    			}
            }
    	}
    	/* bind element event*/
    	function actFilter(){
        	$('#kpiStrucForm').attr("action","<%=formActionFilter%>");
        	$('#keySearch').val($('#textSearch').val());
        	$('#kpiStrucForm').submit();
    	}
    	function actSearch(el){
    		$('#kpiStrucForm').attr("action","<%=formActionSearch%>");
    		$('#keySearch').val($('#textSearch').val());
    		$('#keyListStatus').val($('#listStatus').val());
    		$('#kpiStrucForm').submit();
    	}
        function changeKpiGroup(current){
        	$("#fGroupId").val($(current).val());
        	actFilter();
        }
    	function actChangePageSize(el){
    		var numPage = $('.numPage').val();
    		var sizePage = $(el).val();
    		$('#kpiStrucForm '+'#pageNo').val(numPage);
    		$('#kpiStrucForm '+'#PageSize').val(sizePage);
    		$('#kpiStrucForm').attr("action","<%=formActionPageSize%>");
    		$('#kpiStrucForm').submit();
    	}
   	 	function actSelectPage(el){
   	 		var numPage = el.innerHTML;
   	 		var sizePage = $('.pageSize').val();
	   	 	$('#kpiStrucForm '+'#pageNo').val(numPage);	   	 	
	   	 	$('#kpiStrucForm '+'#PageSize').val(sizePage);
			$('#kpiStrucForm').attr("action","<%=formActionListPage%>");
			$('#kpiStrucForm').submit();
   	 	}
   	 	function actAdd(el){   	 		
   	 		renderDialog('#formActStruc',1,'','');
   	 	}
   	 	function actEdit(el){
   	 		var dataId = parseInt($(el).parent('td').parent('tr').children('tbody tr td:nth-child(8)').html());
   	 		var dataDesc = [];
   	 		dataDesc["name"] = $.trim($(el).parent('td').parent('tr').children('tbody tr td:nth-child(2)').html());
   	 		dataDesc["createDate"] = $(el).parent('td').parent('tr').children('tbody tr td:nth-child(12)').html();
   	 		dataDesc["createBy"] = $(el).parent('td').parent('tr').children('tbody tr td:nth-child(13)').html();
   	 		dataDesc["typeID"] = $(el).parent('td').parent('tr').children('tbody tr td:nth-child(10)').html();
   	 		dataDesc["groupID"] = $(el).parent('td').parent('tr').children('tbody tr td:nth-child(11)').html();
   	 		dataDesc["active"] = $(el).parent('td').parent('tr').children('tbody tr td:nth-child(14)').html();
   	 		renderDialog('#formActStruc',2,dataId,dataDesc);
   	 	}
   	 	function actDelete(el){   	
   	 		var dataId = parseInt($(el).parent('td').parent('tr').children('tbody tr td:nth-child(8)').html());
	    	var dataName = $(el).parent('td').parent('tr').children('tbody tr td:nth-child(2)').text();
	   	 	$.confirm({
		   	     text: "ยืนยันการลบองค์ประกอบ \"".concat(dataName, "\""),
		   	     title: "ลบองค์ประกอบ",
		   	     confirm: function(button) {		   	    	
		   	 		$('#kpiStrucForm').attr("action","<%=formActionDelete%>");
			 		$('#kpiStrucForm '+'#fStrucId').val(dataId);
			 		$('#kpiStrucForm').submit();
		   	     },
		   	     cancel: function(button) {
		   	         // nothing to do
		   	     },
		   	     confirmButton: "ตกลง",
		   	     cancelButton: "ยกเลืก",
		   	     post: true,
		   	     confirmButtonClass: "btn-primary",
		   	     cancelButtonClass: "btn-danger",
		   	     dialogClass: "modal-dialog modal-lg" // Bootstrap classes for large modal
		   	 });
   	 	}
   	 	function actSaveInsert(){
   	 		if($.trim($('#fStrucName').val()) == ""){
   	 			$('label#ckInputText').css( "display", "block" ).fadeOut( 5000 );
   	 		}else{
	   	 		$('#kpiStrucForm').attr('action',"<%=formActionInsert%>");   	 		
	   	 		$("#fGroupId").val($('#fGroupType').val());
	   	 		$('#kpiStrucForm').submit();
   	 		}
   	 	}
   	 	function actSaveEdit(){
   	 		if($.trim(gobalStucName) == $.trim($("input#fStrucName").val())
   	 			&& $.trim(gobalGroupVal) == $.trim($("select#fGroupType").val())
   	 			&& $.trim(gobalCriVal) == $.trim($("form#kpiStrucForm input[type=radio]:checked").val())
   	 			&& $.trim(gobalActive) == $.trim($("input.active:checked").val())
   	 			 ){
   	 			actCancel();
   	 		}else{
		 		$('#kpiStrucForm').attr("action","<%=formActionEdit%>");
		 		$("#fGroupId").val($('#fGroupType').val());
		 		$('#kpiStrucForm').submit();
   	 		}
	 	}
	 	function actCancel(el){
	  		//dialog.dialog( "close" );
	  		$('#fStrucName').val("");
	  		$('#formActStruc').slideToggle('slow');     	  		
	  	}
   	 	function renderDialog(d1,mode,dataId,dataDesc){
   	 		/*mode 1:insert 2:edit*/
   	 		var head,event;
   	 		if(mode==1){
	 			head = 'เพิ่ม';
	 			event= 'actSaveInsert()';
	 			$(d1).trigger( "reset" );
	 			$(d1).find('input[type=text]#fStrucName').val("");
	 			$(d1).find('select#fGroupType').removeAttr('selected').find('option:first').attr('selected', 'selected');
	 			$(".ST1").prop('checked', true);
	 			
	 		}else if(mode==2){
	 			head = 'แก้ไข';
	 			event='actSaveEdit()';
	 			$(d1).find('input[type=text]#fStrucName').val(dataDesc["name"]);
	 			$(d1).find('select#fGroupType').val(dataDesc["groupID"]);
	 			$("#ST"+dataDesc["typeID"]).prop('checked', true);


	 			gobalStucName = dataDesc["name"];
	 			gobalGroupVal = dataDesc["groupID"];
	 			gobalCriVal = dataDesc["typeID"];
	 			gobalActive =dataDesc["active"];

	 			//check from database
	 			//alert(dataDesc["active"]);
	   			if(dataDesc["active"]==0){

	   				$(d1).find('input[type=radio]#fNotActive').prop( "checked", true );
	   				$(d1).find('input[type=radio]#fActive').prop( "checked", false );

	   			}else if(dataDesc["active"]==1){

	   				$(d1).find('input[type=radio]#fNotActive').prop( "checked", false );	
	   				$(d1).find('input[type=radio]#fActive').prop( "checked", true );

	   			}else{
	   				$(d1).find('input[type=radio]#fNotActive').prop( "checked", false );	
	   				$(d1).find('input[type=radio]#fActive').prop( "checked", true );
	   			}
	   			//check from database



	 		}
   	 		$(d1).find('span').html(head);
   	 		$(d1).find('input[type=hidden]#fStrucId').val(dataId);
   	 		$(d1).find('input[type=hidden]#fStrucCreateBy').val(dataDesc["createBy"]);
   			$(d1).find('input[type=hidden]#fStrucCreateDate').val(dataDesc["createDate"]);	
   			$(d1).find('button.save').attr('onClick',event);

   			


		   	if ( $(d1).is(':visible')) {

		   		return false ;
		   	}else{
		   		$(d1).slideToggle("slow");
		   	} 
   	 	} 
   	 	function paging(){
	   	 	if(${not empty strucs}){
	   	 		var totalPage = parseInt(${lastPage});
	   	 		$('div.buttonPage').empty();
	   	 		for(var i=1;i<=totalPage;i++){
	   	 			$('div.buttonPage').append($('<button class="btnPag" onClick="actSelectPage(this)">'+i+'</button>'));
	   	 		}
	 		}
   	 	}
   	 	function goPrev(){
        	if(${PageCur}!=1){
        		var numPage = parseInt($('.numPage').val())-1;
        		var sizePage = $('.pageSize').val();
        		$('#kpiStrucForm '+'#pageNo').val(numPage);
        		$('#kpiStrucForm '+'#PageSize').val(sizePage);
        		$('#kpiStrucForm').attr("action","<%=formActionListPage%>");
        		$('#kpiStrucForm').submit();
        	}
   	 	}
        function goNext(){
        	if(${PageCur} < ${lastPage}){
        		var numPage = parseInt($('.numPage').val())+1;
        		var sizePage = $('.pageSize').val();
        		$('#kpiStrucForm '+'#pageNo').val(numPage);
        		$('#kpiStrucForm '+'#PageSize').val(sizePage);
        		$('#kpiStrucForm').attr("action","<%=formActionListPage%>");
        		$('#kpiStrucForm').submit();
        	}
        }
   	</script>  
  
   	<style type="text/css">
   		div.boxAct{
			padding: 20px 20px 20px 20px;
			border: thin solid #CDCDCD;
			border-radius: 10px;
			display: block; 
		}
		
   		table.tableGridTp{
   			background-color:#FFFFFF;
    		border:1px solid #999999;
    		overflow:hidden;
    		width:100%;
   			padding-top:10px;
   			font-size:14px;
   		}   		
   		table.tableGridTp th:nth-child(1){ width:5%; }
   		table.tableGridTp th:nth-child(2){ width:35%; }
   		table.tableGridTp th:nth-child(3){ width:15%; }
   		table.tableGridTp th:nth-child(4){ width:15%; }
   		table.tableGridTp th:nth-child(5){ width:10%; }
   		table.tableGridTp th:nth-child(6){ width:10%; }
   		table.tableGridTp th:nth-child(7){ width:10%; }
   		table.tableGridTp th:nth-child(8), table.tableGridTp td:nth-child(8){ width:0%; display:none;}
   		table.tableGridTp th:nth-child(9), table.tableGridTp td:nth-child(9){ width:0%; display:none;}
   		table.tableGridTp th:nth-child(10), table.tableGridTp td:nth-child(10){ width:0%; display:none;}
   		table.tableGridTp th:nth-child(11), table.tableGridTp td:nth-child(11){ width:0%; display:none;}
   		table.tableGridTp th:nth-child(12), table.tableGridTp td:nth-child(12){ width:0%; display:none;}
   		table.tableGridTp th:nth-child(13), table.tableGridTp td:nth-child(13){ width:0%; display:none;}
   		table.tableGridTp th:nth-child(14), table.tableGridTp td:nth-child(14){ width:0%; display:none;}
   		/* table.tableGridTp tbody td:nth-child(1){
   			text-align:center;$("#success-alert").alert('close');
   			border-color:#acacac;
   			border-width:0px 0px 0px 0px;
   			border-style:inset;
   			background: linear-gradient(white, #efefef,#e2e2e2,#f7f7f7);
   		} */
   		table.tableGridTp thead th{
   			height: 30px;
   			text-align:center;
   			border-color:#acacac;
   			border-width:0px 1px 1px 1px;
   			border-style:inset;
   			background: linear-gradient(white, #efefef,#e2e2e2,#f7f7f7);
   		}
   		table.tableGridTp tbody td {
			border: none;
			padding: 1px 2px 2px 2px;
		}
   		table.tableGridTp tr:nth-child(2n){ background-color:rgba(244,244,244,1); }				
		.numPage{width:40px; margin-bottom: 0px;}
	
   	</style>
  </head>
  
<body> 
	<input type="hidden" id="messageMsg" value="${messageCode}"> 
	<div id="msgAlert" style="display:none">
	    <button type="button" class="close" data-dismiss="alert">x</button>
	    <span id="headMsg"> </span> ${messageDesc} 
	</div>
	
	<div class="box">
		<div id="formActStruc" class="boxAct" style="display:none">
			<form:form id="kpiStrucForm" modelAttribute="kpiStrucForm" action="${formAction}" method="POST" enctype="multipart/form-data">
				<fieldset>
					<legend style="font:16px bold;">
						<span></span>องค์ประกอบ
					</legend>
					<div style="text-align: center;">
						<form:input type="hidden" id="pageNo" path="pageNo" value="${PageCur}"/>
						<form:input type="hidden" id="PageSize" path="pageSize" />
						<form:input type="hidden" id="keySearch" path="keySearch" />
						<form:input type="hidden" id="keyListStatus" path="keyListStatus" />
						<form:input type="hidden" id="fStrucId" path="kpiStrucModel.strucId" />
						<form:input type="hidden" id="fGroupId" path="kpiStrucModel.groupId" />
						<form:input type="hidden" id="fStrucCreateBy" path="kpiStrucModel.createdBy" />
						<form:input type="hidden" id="fStrucCreateDate" path="createDate" />
						
						<table style="margin:auto"> 
							<tr>
								<td style="text-align:right">เกณฑ์องค์ประกอบ : </td>
								<td style="text-align:left">
									<form:input id="fStrucName" path="kpiStrucModel.strucName" maxlength="255"/> (ตัวอักษร)
								</td>
							</tr>
							<tr>
								<td style="text-align:right">กลุ่มตัวบ่งชี้ : </td>
								<td style="text-align:left">
									<select id="fGroupType" >
										<c:forEach items="${groups}" var="group" varStatus="loop">
										<option value="${group.groupId}">${group.groupShortName}</option>
										</c:forEach>
									</select>
								</td>
							</tr>

							



							<tr>
								<td style="text-align: right">เกณฑ์องค์ประกอบ :</td>
								<td style="text-align: left;"><c:forEach
										items="${strucTypes}" var="type" varStatus="loop">
										<form:radiobutton id="ST${type.strucTypeId}" class="ST${loop.count}"
											path="kpiStrucModel.structureType"
											value="${type.strucTypeId}" name="${type.strucTypeName}" />
										 ${type.strucTypeName} &nbsp									
									</c:forEach>
								</td>
							</tr>


							<tr >
								<td style='text-align: right'></td>
								<td style='text-align: left;'>
								
								<form:radiobutton id="fActive" checked="checked"  class="widt active" path="kpiStrucModel.active" value="1" name="active" />
								<div style="margin-right: 17px; display: inline;">
								เปิดใช้งาน
								</div>
								<form:radiobutton id="fNotActive" class="widt active" path="kpiStrucModel.active" value="0" name="active" />
								ปิดใช้งาน
								
								</td>
							</tr>
						</table>
						
						<label id="ckInputText" style="color:red; display:none;">*กรุณากรอกข้อมูลให้ครบถ้วน</label> <br/>				
						<button class="save btn btn-primary" type="button" onClick="actSaveInsert()">บันทึก</button>
						<button class="cancel btn btn-danger" type="button" onClick="actCancel()">ยกเลิก</button>
					</div>
				</fieldset>
			</form:form>
		</div><br/>
		
		<div class="row-fluid">
			<div class="span3">
				<span>กลุ่มตัวบ่งชี้</span>
				<select id="filterGroup" onchange="changeKpiGroup(this)" style="width:100px;">
					<c:forEach items="${groups}" var="group" varStatus="loop">
						<option value="${group.groupId}">${group.groupShortName}</option>
					</c:forEach>
				</select>
			</div>
			<div class="span6">
				<span>ค้นหาองค์ประกอบ : </span>
				<input type="text" id="textSearch" value="${keySearch}"  placeholder="ค้นหาจากชื่อ" style="margin-bottom: 0px;"/>
				<!--
				<select name='listStatus' id='listStatus'  class="listStatus">

				   		<option selected='selected' value='99'>ทั้งหมด</option>
		    			<option value='1'>เปิดใช้งาน</option>
		    			<option value='0'>ปิดใช้งาน</option>

				</select>
				-->
				<select name='listStatus' id='listStatus'  class="listStatus">
				
				<c:choose>
				   <c:when test="${keyListStatus=='0'}">
					    <option value='99'>ทั้งหมด</option>
		    			<option value='1'>เปิดใช้งาน</option>
		    			<option selected='selected' value='0'>ปิดใช้งาน</option>
				   </c:when>
				   <c:when test="${keyListStatus=='1'}">
				   
				   		<option value='99'>ทั้งหมด</option>
		    			<option selected='selected' value='1'>เปิดใช้งาน</option>
		    			<option value='0'>ปิดใช้งาน</option>
		    			
				   </c:when> 
				   <c:otherwise>
				   		<option selected='selected' value='99'>ทั้งหมด</option>
		    			<option value='1'>เปิดใช้งาน</option>
		    			<option value='0'>ปิดใช้งาน</option>
				   </c:otherwise>  
				</c:choose>

	    			
	  			</select>



					<img src="<c:url value="/resources/images/search.png"/>" width="20" height="20" onClick="actSearch(this)" style="cursor: pointer;">
					<img src="<c:url value="/resources/images/add.png"/>" width="18" height="18" onClick="actAdd(this)" style="cursor: pointer;">	
			</div>
		
			<div class="paging span3" align="right">
				<li style="display: inline-block;" onclick='goPrev()'>
					<a style="cursor: pointer;"><u>&lt;&nbsp;</u></a>
				</li>
				<div class="buttonPage"> 
					<!-- Generate from paging(). -->
					<button class="btnPag btnPagDummy" onClick="actSelectPage(this)"> 1 </button> 
				</div> 
				<li style="display: inline-block;" onclick='goNext()'>
					<a style="cursor: pointer;"><u>&nbsp;&gt;</u></a>
				</li>
				&nbsp&nbsp&nbsp&nbsp
				<input type="hidden" class="numPage" style="width:60px"/>
				<span>จำนวนแถว: </span> 
				<select class="pageSize" onchange="actChangePageSize(this)">
	    			<option>10</option>
	    			<option>20</option>
	    			<option>30</option>
	    			<option>40</option>
	    			<option>50</option>
	  			</select>
			</div>
		</div>
		
		<div class="boxTable table-responsive">
			<table class="tableGridTp hoverTable">
				<thead>
					<tr>
						<th>ลำดับ</th>						
						<th>ชื่อองค์ประกอบ</th>
						<th>เกณฑ์องค์ประกอบ</th>
						<th>กลุ่มตัวบ่งชี้</th>			
						<th>สถานะ</th>	
						<th>แก้ไข</th>
						<th>ลบ</th>
						<th>รหัส(ซ้อน)</th>
						<th>ปี (ซ้อน)</th>
						<th>structureTypeId (ซ้อน)</th>
						<th>groupId (ซ้อน)</th>
						<th>createDate (ซ้อน)</th>
						<th>createBy (ซ้อน)</th>
					</tr>
				</thead>
				<tbody> 
					<c:if test="${not empty strucs}">
						<c:forEach items="${strucs}" var="struc" varStatus="loop">
							<tr>
								<td style="text-align:center;">${(loop.count+((PageCur-1)*pageSize))}</td>
								<td>${chandraFn:nl2br(struc.strucName)} </td>
								<td>${chandraFn:nl2br(struc.strucTypeName)}</td>
								<td>${chandraFn:nl2br(struc.groupName)}</td>

								<td align="center">

									<!--<img src="<c:url value="/resources/images/button-turn-on.jpg"/>" width="22" height="22">-->
									<c:if test="${struc.active=='0'}">
									<img data-toggle="tooltip" data-placement="top" title="Tooltip on top" src="<c:url value="/resources/images/button-turn-off.jpg"/>" width="22" height="22"  style="cursor: pointer;">
									</c:if>
									<c:if test="${struc.active=='1'}">
									<img data-toggle="tooltip" data-placement="top" title="Tooltip on top" src="<c:url value="/resources/images/button-turn-on.jpg"/>" width="22" height="22"  style="cursor: pointer;">
									</c:if>

								</td>
								
								<td align="center">
									<img src="<c:url value="/resources/images/edited.png"/>" width="22" height="22" onClick="actEdit(this)" style="cursor: pointer;">
								</td>

								<td align="center">
									<img src="<c:url value="/resources/images/delete.png"/>" width="22" height="22" onClick="actDelete(this)">
								</td>
								<td>${struc.strucId}</td>
								<td>${struc.academicYear}</td>
								<td>${struc.structureType}</td>
								<td>${struc.groupId}</td>
								<td> <fmt:formatDate value="${struc.createdDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
								<td> ${struc.createdBy} </td>
								<td> ${struc.active} </td>
							</tr> 
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		</div>
		
		<div class="row-fluid" style="margin-top: 10px">		
			<div class="paging span12" align="right">
				<li style="display: inline-block;" onclick='goPrev()'>
					<a style="cursor: pointer;"><u>&lt;&nbsp;</u></a>
				</li>
				<div class="buttonPage"> 
					<!-- Generate from paging(). --> 
					<button class="btnPag btnPagDummy" onClick="actSelectPage(this)"> 1 </button>
				</div> 
				<li style="display: inline-block;" onclick='goNext()'>
					<a style="cursor: pointer;"><u>&nbsp;&gt;</u></a>
				</li>
				&nbsp&nbsp&nbsp&nbsp
				<input type="hidden" class="numPage" style="width:60px"/>
				<span>จำนวนแถว: </span> 
				<select class="pageSize" onchange="actChangePageSize(this)">
	    			<option>10</option>
	    			<option>20</option>
	    			<option>30</option>
	    			<option>40</option>
	    			<option>50</option>
	  			</select>
			</div>
		</div>
		
	</div>
</body>
</html>	
   