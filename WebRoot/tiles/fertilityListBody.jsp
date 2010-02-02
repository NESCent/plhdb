<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>   
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/fmt.tld"%>
<%@ page import="org.nescent.plhdb.util.NoCache" %>
<%@ page import="org.nescent.plhdb.util.SearchFertilityForm" %>
<%@ page import="java.lang.Integer" %>

<%       
NoCache.nocache(response);
SearchFertilityForm form=(SearchFertilityForm)request.getAttribute("searchForm");
int total=((Integer)request.getAttribute("totalRecord")).intValue();
int numPerPage=Integer.parseInt(form.getNumPerPage());
int totalPage=total/numPerPage;
int rest=total%numPerPage;
if(rest>0)
    totalPage++;
int currentPage=Integer.parseInt(form.getPage());

%>

<script language="javascript">

function download(){
    var f=document.searchFertilityForm;
    f.download.value="true";
    f.submit();
}
function gotoFirstPage(){
    var f=document.searchFertilityForm;
    f.page.value=0;
    f.download.value="";
    f.submit();
}

function gotoPrevPage(){
    var f=document.searchFertilityForm;
    f.page.value=parseInt(f.page.value)-1;
    f.download.value="";
    f.submit();
}


function gotoNextPage(){
    var f=document.searchFertilityForm;
    f.page.value=parseInt(f.page.value)+1;
    f.download.value="";
    f.submit();
}


function gotoLastPage(){
    var f=document.searchFertilityForm;
    f.page.value=<%= totalPage %>;
    f.download.value="";
    f.submit();
}

function headerClicked(field){
    var f=document.searchFertilityForm;
    var prevField=f.sortBy.value;
    var prevOrder=f.order.value;

    f.sortBy.value=field;
    if(prevField==field){
	if(prevOrder=="asc")
	    f.order.value="desc";
	else
	    f.order.value="asc";
    }else{
	f.order.value="asc";
    }
    f.download.value="";
    f.submit();
}

</script>
<form action="/search/fertility.go" method="post" name="searchFertilityForm">
<input type='hidden' name='show_studyid' value='<%= form.getShow_studyid()==null?"":form.getShow_studyid() %>' />
<input type='hidden' name='show_animid' value='<%= form.getShow_animid()==null?"":form.getShow_animid() %>' />
<input type='hidden' name='show_startdate' value='<%= form.getShow_startdate()==null?"":form.getShow_startdate() %>' />
<input type='hidden' name='show_starttype' value='<%= form.getShow_starttype()==null?"":form.getShow_starttype() %>' />
<input type='hidden' name='show_stopdate' value='<%= form.getShow_stopdate()==null?"":form.getShow_stopdate() %>' />
<input type='hidden' name='show_stoptype' value='<%= form.getShow_stoptype()==null?"":form.getShow_stoptype() %>' />

<input type='hidden' name='op_studyid' value='<%= form.getOp_studyid()==null?"":form.getOp_studyid() %>' />
<input type='hidden' name='op_animid' value='<%= form.getOp_animid()==null?"":form.getOp_animid() %>' />
<input type='hidden' name='op_startdate' value='<%= form.getOp_startdate()==null?"":form.getOp_startdate() %>' />
<input type='hidden' name='op_starttype' value='<%= form.getOp_starttype()==null?"":form.getOp_starttype() %>' />
<input type='hidden' name='op_stopdate' value='<%= form.getOp_stopdate()==null?"":form.getOp_stopdate() %>' />
<input type='hidden' name='op_stoptype' value='<%= form.getOp_stoptype()==null?"":form.getOp_stoptype() %>' />


<input type='hidden' name='value_studyid' value='<%= form.getValue_studyid()==null?"":form.getValue_studyid() %>' />
<input type='hidden' name='value_animid' value='<%= form.getValue_animid()==null?"":form.getValue_animid() %>' />
<input type='hidden' name='value_startdate' value='<%= form.getValue_startdate()==null?"":form.getValue_startdate() %>' />
<input type='hidden' name='value_starttype' value='<%= form.getValue_starttype()==null?"":form.getValue_starttype() %>' />
<input type='hidden' name='value_stopdate' value='<%= form.getValue_stopdate()==null?"":form.getValue_stopdate() %>' />
<input type='hidden' name='value_stoptype' value='<%= form.getValue_stoptype()==null?"":form.getValue_stoptype() %>' />

<input type='hidden' name='sortBy' value='<%= form.getSortBy()==null?"":form.getSortBy() %>' />
<input type='hidden' name='page' value='<%= form.getPage()==null?"":form.getPage() %>' />
<input type='hidden' name='order' value='<%= form.getOrder()==null?"":form.getOrder() %>' />
<input type='hidden' name='numPerPage' value='<%= form.getNumPerPage()==null?"":form.getNumPerPage() %>' />
<input type='hidden' name='searchDistribution' value='<%= form.getSearchDistribution()==null?"":form.getSearchDistribution() %>' />
<input type='hidden' name='download' value='<%= form.getDownload()==null?"":form.getDownload() %>' />
</form>

<h2>Fertility List</h2>
<h3>Total: <%= total %></h3>
<c:if test='${message!=null && message!=""}'>
Note: <c:out value="${message}" />
<c:set var="message" value="${null}" /> 
</c:if>
<h3>search criteria
    <%= (form.getOp_studyid().indexOf("NULL")>-1 || form.getValue_studyid()!=null)?", Study Id "+form.getOp_studyid()+(form.getValue_studyid()!=null?" '"+form.getValue_studyid()+"'":""):"" %>
    <%= (form.getOp_animid().indexOf("NULL")>-1 || form.getValue_animid()!=null)?", Animal Id "+form.getOp_animid()+(form.getValue_animid()!=null?" '"+form.getValue_animid()+"'":""):"" %>
    <%= (form.getOp_startdate().indexOf("NULL")>-1 || form.getValue_startdate()!=null)?", Entry Date "+form.getOp_startdate()+(form.getValue_startdate()!=null?" '"+form.getValue_startdate()+"'":""):"" %>
    <%= (form.getOp_starttype().indexOf("NULL")>-1 || form.getValue_starttype()!=null)?", Entry Type "+form.getOp_starttype()+(form.getValue_starttype()!=null?" '"+form.getValue_starttype()+"'":""):"" %>
    <%= (form.getOp_stopdate().indexOf("NULL")>-1 || form.getValue_stopdate()!=null)?", Depart Date "+form.getOp_stopdate()+(form.getValue_stopdate()!=null?" '"+form.getValue_stopdate()+"'":""):"" %>
    <%= (form.getOp_stoptype().indexOf("NULL")>-1 || form.getValue_stoptype()!=null)?", Depart Type "+form.getOp_stoptype()+(form.getValue_stoptype()!=null?" '"+form.getValue_stoptype()+"'":""):"" %>

</h3>
<table><tr>
<%
if(currentPage>0)
{
    out.write("<td class=\"TdAction\"><a href=\"javascript: gotoFirstPage();\">first</a></td>");
    out.write("<td class=\"TdAction\"><a href=\"javascript: gotoPrevPage();\">prev</a></td>");
}
%>
<td>Current page:<b> <%= currentPage+1 %></b></td>
<%
if(currentPage<totalPage-1)
{
    out.write("<td class=\"TdAction\"><a href=\"javascript: gotoNextPage();\">next</a></td>");
    out.write("<td class=\"TdAction\"><a href=\"javascript: gotoLastPage();\">last</a></td>");
}
%>
<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td class="abutton"><a href="javascript:download()">Download</a></td>
</tr>
</table>
<table><tr>
<c:forEach items="${showFields}" var="field" varStatus="status">
<th class="abutton"><a href="javascript: headerClicked('<c:out value='${status.count}' />')"><c:out value='${field}' /></a></th>
</c:forEach>
</tr>
<c:forEach items="${fertilities}" var="record" varStatus="status">
	<c:set var="rowStyle" value="TrOdd" />
	<c:if test='${status.count%2==0}'>
		<c:set var="rowStyle" value="TrEven" />
	</c:if>
	<tr class="<c:out value='${rowStyle}'/>">
		<c:forEach items="${record}" var="field" varStatus="fieldStatus">
		<c:choose>
		
		<c:when test='${showFields[fieldStatus.count-1]=="Start Date" || showFields[fieldStatus.count-1]=="Stop Date"}'>	
			<td><fmt:formatDate value='${field}' type='both' pattern='dd-MMM-yyyy' /></td>
		</c:when>
		<c:otherwise>
			<td><c:out value='${field}' /></td>
		</c:otherwise>
		</c:choose>
		</c:forEach>
	</tr>	
</c:forEach>
</table>



