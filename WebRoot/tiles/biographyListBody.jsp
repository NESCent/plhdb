<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>   
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/fmt.tld"%>
<%@ page import="org.nescent.plhdb.util.NoCache" %>
<%@ page import="org.nescent.plhdb.util.SearchBiographyForm" %>
<%@ page import="java.lang.Integer" %>

<%       
NoCache.nocache(response);
SearchBiographyForm form=(SearchBiographyForm)request.getAttribute("searchForm");
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
    var f=document.searchBiographyForm;
    f.download.value="true";
    f.submit();
}
function gotoFirstPage(){
    var f=document.searchBiographyForm;
    f.page.value=0;
    f.download.value="";
    f.submit();
}

function gotoPrevPage(){
    var f=document.searchBiographyForm;
    f.page.value=parseInt(f.page.value)-1;
    f.download.value="";
    f.submit();
}


function gotoNextPage(){
    var f=document.searchBiographyForm;
    f.page.value=parseInt(f.page.value)+1;
    f.download.value="";
    f.submit();
}


function gotoLastPage(){
    var f=document.searchBiographyForm;
    f.page.value=<%= totalPage %>;
    f.download.value="";
    f.submit();
}

function headerClicked(field){
    var f=document.searchBiographyForm;
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
<form action="/plhdb/search/biography.go" method="post" name="searchBiographyForm">
<input type='hidden' name='show_studyid' value='<%= form.getShow_studyid()==null?"":form.getShow_studyid() %>' />
<input type='hidden' name='show_animname' value='<%= form.getShow_animname()==null?"":form.getShow_animname() %>' />
<input type='hidden' name='show_birthgroup' value='<%= form.getShow_birthgroup()==null?"":form.getShow_birthgroup() %>' />
<input type='hidden' name='show_bgqual' value='<%= form.getShow_bgqual()==null?"":form.getShow_bgqual() %>' />
<input type='hidden' name='show_sex' value='<%= form.getShow_sex()==null?"":form.getShow_sex() %>' />
<input type='hidden' name='show_momid' value='<%= form.getShow_momid()==null?"":form.getShow_momid() %>' />
<input type='hidden' name='show_firstborn' value='<%= form.getShow_firstborn()==null?"":form.getShow_firstborn() %>' />
<input type='hidden' name='show_birthdate' value='<%= form.getShow_birthdate()==null?"":form.getShow_birthdate() %>' />
<input type='hidden' name='show_bdmin' value='<%= form.getShow_bdmin()==null?"":form.getShow_bdmin() %>' />
<input type='hidden' name='show_bdmax' value='<%= form.getShow_bdmax()==null?"":form.getShow_bdmax() %>' />
<input type='hidden' name='show_bddist' value='<%= form.getShow_bddist()==null?"":form.getShow_bddist() %>' />
<input type='hidden' name='show_entrydate' value='<%= form.getShow_entrydate()==null?"":form.getShow_entrydate() %>' />
<input type='hidden' name='show_entrytype' value='<%= form.getShow_entrytype()==null?"":form.getShow_entrytype() %>' />
<input type='hidden' name='show_departdate' value='<%= form.getShow_departdate()==null?"":form.getShow_departdate() %>' />
<input type='hidden' name='show_departdateerror' value='<%= form.getShow_departdateerror()==null?"":form.getShow_departdateerror() %>' />
<input type='hidden' name='show_departtype' value='<%= form.getShow_departtype()==null?"":form.getShow_departtype() %>' />
<input type='hidden' name='show_animid' value='<%= form.getShow_animid()==null?"":form.getShow_animid() %>' />

<input type='hidden' name='op_studyid' value='<%= form.getOp_studyid()==null?"":form.getOp_studyid() %>' />
<input type='hidden' name='op_animname' value='<%= form.getOp_animname()==null?"":form.getOp_animname() %>' />
<input type='hidden' name='op_birthgroup' value='<%= form.getOp_birthgroup()==null?"":form.getOp_birthgroup() %>' />
<input type='hidden' name='op_bgqual' value='<%= form.getOp_bgqual()==null?"":form.getOp_bgqual() %>' />
<input type='hidden' name='op_sex' value='<%= form.getOp_sex()==null?"":form.getOp_sex() %>' />
<input type='hidden' name='op_momid' value='<%= form.getOp_momid()==null?"":form.getOp_momid() %>' />
<input type='hidden' name='op_firstborn' value='<%= form.getOp_firstborn()==null?"":form.getOp_firstborn() %>' />
<input type='hidden' name='op_birthdate' value='<%= form.getOp_birthdate()==null?"":form.getOp_birthdate() %>' />
<input type='hidden' name='op_bdmin' value='<%= form.getOp_bdmin()==null?"":form.getOp_bdmin() %>' />
<input type='hidden' name='op_bdmax' value='<%= form.getOp_bdmax()==null?"":form.getOp_bdmax() %>' />
<input type='hidden' name='op_bddist' value='<%= form.getOp_bddist()==null?"":form.getOp_bddist() %>' />

<input type='hidden' name='op_entrydate' value='<%= form.getOp_entrydate()==null?"":form.getOp_entrydate() %>' />
<input type='hidden' name='op_entrytype' value='<%= form.getOp_entrytype()==null?"":form.getOp_entrytype() %>' />
<input type='hidden' name='op_departdate' value='<%= form.getOp_departdate()==null?"":form.getOp_departdate() %>' />
<input type='hidden' name='op_departdateerror' value='<%= form.getOp_departdateerror()==null?"":form.getOp_departdateerror() %>' />
<input type='hidden' name='op_departtype' value='<%= form.getOp_departtype()==null?"":form.getOp_departtype() %>' />
<input type='hidden' name='op_animid' value='<%= form.getOp_animid()==null?"":form.getOp_animid() %>' />

<input type='hidden' name='value_studyid' value='<%= form.getValue_studyid()==null?"":form.getValue_studyid() %>' />
<input type='hidden' name='value_animname' value='<%= form.getValue_animname()==null?"":form.getValue_animname() %>' />
<input type='hidden' name='value_birthgroup' value='<%= form.getValue_birthgroup()==null?"":form.getValue_birthgroup() %>' />
<input type='hidden' name='value_bgqual' value='<%= form.getValue_bgqual()==null?"":form.getValue_bgqual() %>' />
<input type='hidden' name='value_sex' value='<%= form.getValue_sex()==null?"":form.getValue_sex() %>' />
<input type='hidden' name='value_momid' value='<%= form.getValue_momid()==null?"":form.getValue_momid() %>' />
<input type='hidden' name='value_firstborn' value='<%= form.getValue_firstborn()==null?"":form.getValue_firstborn() %>' />
<input type='hidden' name='value_birthdate' value='<%= form.getValue_birthdate()==null?"":form.getValue_birthdate() %>' />
<input type='hidden' name='value_bdmin' value='<%= form.getValue_bdmin()==null?"":form.getValue_bdmin() %>' />
<input type='hidden' name='value_bdmax' value='<%= form.getValue_bdmax()==null?"":form.getValue_bdmax() %>' />
<input type='hidden' name='value_bddist' value='<%= form.getValue_bddist()==null?"":form.getValue_bddist() %>' />

<input type='hidden' name='value_entrydate' value='<%= form.getValue_entrydate()==null?"":form.getValue_entrydate() %>' />
<input type='hidden' name='value_entrytype' value='<%= form.getValue_entrytype()==null?"":form.getValue_entrytype() %>' />
<input type='hidden' name='value_departdate' value='<%= form.getValue_departdate()==null?"":form.getValue_departdate() %>' />
<input type='hidden' name='value_departdateerror' value='<%= form.getValue_departdateerror()==null?"":form.getValue_departdateerror() %>' />
<input type='hidden' name='value_departtype' value='<%= form.getValue_departtype()==null?"":form.getValue_departtype() %>' />
<input type='hidden' name='value_animid' value='<%= form.getValue_animid()==null?"":form.getValue_animid() %>' />
<input type='hidden' name='sortBy' value='<%= form.getSortBy()==null?"":form.getSortBy() %>' />
<input type='hidden' name='page' value='<%= form.getPage()==null?"":form.getPage() %>' />
<input type='hidden' name='order' value='<%= form.getOrder()==null?"":form.getOrder() %>' />
<input type='hidden' name='numPerPage' value='<%= form.getNumPerPage()==null?"":form.getNumPerPage() %>' />
<input type='hidden' name='searchDistribution' value='<%= form.getSearchDistribution()==null?"":form.getSearchDistribution() %>' />
<input type='hidden' name='download' value='<%= form.getDownload()==null?"":form.getDownload() %>' />
</form>

<h2>Biography List</h2>
<h3>Total: <%= total %></h3>
<c:if test='${message!=null && message!=""}'>
Note: <c:out value="${message}" />
<c:set var="message" value="${null}" /> 
</c:if>
<h3>search criteria
    <%= (form.getOp_studyid().indexOf("NULL")>-1 || form.getValue_studyid()!=null)?", Study Id "+form.getOp_studyid()+(form.getValue_studyid()!=null?" '"+form.getValue_studyid()+"'":""):"" %>
    <%= (form.getOp_animid().indexOf("NULL")>-1 || form.getValue_animid()!=null)?", Animal Id "+form.getOp_animid()+(form.getValue_animid()!=null?" '"+form.getValue_animid()+"'":""):"" %>
    <%= (form.getOp_animname().indexOf("NULL")>-1 || form.getValue_animname()!=null)?", Animal Name "+form.getOp_animname()+(form.getValue_animname()!=null?" '"+form.getValue_animname()+"'":""):"" %>
    <%= (form.getOp_birthgroup().indexOf("NULL")>-1 || form.getValue_birthgroup()!=null)?", Birth Group "+form.getOp_birthgroup()+(form.getValue_birthgroup()!=null?" '"+form.getValue_birthgroup()+"'":""):"" %>
    <%= (form.getOp_bgqual().indexOf("NULL")>-1 || form.getValue_bgqual()!=null)?", Certainty of Birth Group "+form.getOp_bgqual()+(form.getValue_bgqual()!=null?" '"+form.getValue_bgqual()+"'":""):"" %>
    <%= (form.getOp_sex().indexOf("NULL")>-1 || form.getValue_sex()!=null)?", Sex "+form.getOp_sex()+(form.getValue_sex()!=null?" '"+form.getValue_sex()+"'":""):"" %>
    <%= (form.getOp_momid().indexOf("NULL")>-1 || form.getValue_momid()!=null)?", Mom "+form.getOp_momid()+(form.getValue_momid()!=null?" '"+form.getValue_momid()+"'":""):"" %>
    <%= (form.getOp_firstborn().indexOf("NULL")>-1 || form.getValue_firstborn()!=null)?", Is First Born "+form.getOp_firstborn()+(form.getValue_firstborn()!=null?" '"+form.getValue_firstborn()+"'":""):"" %>
    <%= (form.getOp_birthdate().indexOf("NULL")>-1 || form.getValue_birthdate()!=null)?", Birth Date "+form.getOp_birthdate()+(form.getValue_birthdate()!=null?" '"+form.getValue_birthdate()+"'":""):"" %>
    <%= (form.getOp_bdmin().indexOf("NULL")>-1 || form.getValue_bdmin()!=null)?", Min Birth Date "+form.getOp_bdmin()+(form.getValue_bdmin()!=null?" '"+form.getValue_bdmin()+"'":""):"" %>
    <%= (form.getOp_bdmax().indexOf("NULL")>-1 || form.getValue_bdmax()!=null)?", Max Birth Date "+form.getOp_bdmax()+(form.getValue_bdmax()!=null?" '"+form.getValue_bdmax()+"'":""):"" %>
    <%= (form.getOp_bddist().indexOf("NULL")>-1 || form.getValue_bddist()!=null)?", Birth Date Distribution "+form.getOp_bddist()+(form.getValue_bddist()!=null?" '"+form.getValue_bddist()+"'":""):"" %>
    <%= (form.getOp_entrydate().indexOf("NULL")>-1 || form.getValue_entrydate()!=null)?", Entry Date "+form.getOp_entrydate()+(form.getValue_entrydate()!=null?" '"+form.getValue_entrydate()+"'":""):"" %>
    <%= (form.getOp_entrytype().indexOf("NULL")>-1 || form.getValue_entrytype()!=null)?", Entry Type "+form.getOp_entrytype()+(form.getValue_entrytype()!=null?" '"+form.getValue_entrytype()+"'":""):"" %>
    <%= (form.getOp_departdate().indexOf("NULL")>-1 || form.getValue_departdate()!=null)?", Depart Date "+form.getOp_departdate()+(form.getValue_departdate()!=null?" '"+form.getValue_departdate()+"'":""):"" %>
    <%= (form.getOp_departdateerror().indexOf("NULL")>-1 || form.getValue_departdateerror()!=null)?", Depart Date Error "+form.getOp_departdateerror()+(form.getValue_departdateerror()!=null?" '"+form.getValue_departdateerror()+"'":""):"" %>
    <%= (form.getOp_departtype().indexOf("NULL")>-1 || form.getValue_departtype()!=null)?", Depart Type "+form.getOp_departtype()+(form.getValue_departtype()!=null?" '"+form.getValue_departtype()+"'":""):"" %>

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
<c:forEach items="${biographies}" var="record" varStatus="status">
	<c:set var="rowStyle" value="TrOdd" />
	<c:if test='${status.count%2==0}'>
		<c:set var="rowStyle" value="TrEven" />
	</c:if>
	<tr class="<c:out value='${rowStyle}'/>">
		<c:forEach items="${record}" var="field" varStatus="fieldStatus">
		<c:choose>
		
		<c:when test='${showFields[fieldStatus.count-1]=="Birth Date" || showFields[fieldStatus.count-1]=="Entry Date" || showFields[fieldStatus.count-1]=="Depart Date"|| showFields[fieldStatus.count-1]=="Min Birth Date"|| showFields[fieldStatus.count-1]=="Max Birth Date"}'>	
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

