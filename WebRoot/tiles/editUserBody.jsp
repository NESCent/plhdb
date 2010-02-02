<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>   
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/fmt.tld"%>
<%@ page import="org.nescent.plhdb.util.NoCache" %>

<%       
NoCache.nocache(response);
%>

<script language="javascript">

function deleteUser(id){
    if (confirm("Do you really want to delete the user?")) { 
	if (confirm("Before deleting the user, please make sure it really should be deleted. Do you still want to delete the user?")){
	    var url="/plhdb/delete/user.go?id="+id;
	    window.location.href=url;
	}
    }
}
var access_types=new Array();
access_types[0]="Search";
access_types[1]="Edit";
access_types[2]="Add";
access_types[3]="Delete";
access_types[4]="All";

var access_type_codes=new Array();
access_type_codes[0]="search";
access_type_codes[1]="edit";
access_type_codes[2]="add";
access_type_codes[3]="delete";
access_type_codes[4]="all";

var studies=new Array();
<c:forEach items="${studies}" var="study" varStatus="status">
studies[<c:out value='${status.count-1}' />]="<c:out value='${study.studyId}' />";
</c:forEach>

var newid=0;
function addAccess(){
    var tb;
    var tr;
    var td_access;
    var td_study;
    
    tb=document.getElementById("accessForm");
    var input_id=document.createElement("input");
    input_id.setAttribute("type","hidden");
    input_id.setAttribute("value",newid);
    input_id.setAttribute("name","newid"+newid);
    
    if(!dojo.isIE){
	tr=document.createElement("tr");
    	td_access=document.createElement("td");
   	td_study=document.createElement("td");
    } else{
	var lastRow = tb.rows.length;
	var iteration = lastRow;
	tr = tb.insertRow(lastRow);
	td_access=tr.insertCell(0);
   	td_study=tr.insertCell(1);
    }
    tr.appendChild(input_id);
    
    var access_id="newaccess"+newid;
    var study_id="newstudy"+newid;
    td_access.setAttribute("class","TdValue");
    
    var select=document.createElement("select");
    var empopt=document.createElement("option");
    empopt.appendChild(document.createTextNode(""));
    empopt.setAttribute("value","");
    select.appendChild(empopt);
    for(var i=0;i<access_types.length;i++){
	var opt=document.createElement("option");
	opt.appendChild(document.createTextNode(access_types[i]));
	opt.setAttribute("value",access_type_codes[i]);
	select.appendChild(opt);
    }
    select.setAttribute("name",access_id);
    select.setAttribute("id", access_id);
    td_access.appendChild(select);
    
    var select1=document.createElement("select");
    var empopt1=document.createElement("option");
    empopt1.appendChild(document.createTextNode(""));
    empopt1.setAttribute("value","");
    select1.appendChild(empopt1);
    for(var i=0;i<studies.length;i++){
	var opt=document.createElement("option");
	opt.appendChild(document.createTextNode(studies[i]));
	opt.setAttribute("value",studies[i]);
	select1.appendChild(opt);
    }
    var allopt=document.createElement("option");
    allopt.appendChild(document.createTextNode("All"));
    allopt.setAttribute("value","all");
    select1.appendChild(allopt);
    
    select1.setAttribute("name",study_id);
    select1.setAttribute("id", study_id);
    td_study.appendChild(select1);
    
    
    td_access.setAttribute("class","TdValue");
    td_study.setAttribute("class","TdValue");
  
    if(!dojo.isIE){
	
	tr.appendChild(td_access);
	tr.appendChild(td_study);
	tb.appendChild(tr);
    }
    newid=newid+1;
     
}

</script>

<h2>User </h2>
<form method="post" action="/plhdb/save/user.go?user=<c:out value='${user.userAccountOid}' />" name="user_form" >
<table><tr>
<td class="TdField">Last Name</td><td class="TdValue"><input name="lastName" value="<c:out value='${user.lastName}' />" /></td></tr><tr>
<td class="TdField">First Name</td><td class="TdValue"><input name="firstName" value="<c:out value='${user.firstName}' />" /></td></tr><tr>
<td class="TdField">Email</td><td class="TdValue"><input name="email" value="<c:out value='${user.email}' />" /></td></tr>
<td class="TdField">Is Admin?</td><td class="TdValue">
<select name="isAdmin">
<c:choose>
	<c:when test='${user.admin==true}'>
		<option value="no">No</option>
		<option value="yes" selected>Yes</option>
	</c:when>
	<c:otherwise>
		<option value="no" selected>No</option>
		<option value="yes">Yes</option>
	</c:otherwise>
</c:choose>
</select>
</td>
</tr>
</table>
<p>An admin can have full access right to all of the records in the database.</p>

<h3>Access to studies</h3>
<table id="accessForm" name="accessForm"><tr><th>access</th><th>study</th></tr>
<c:forEach items="${user.permissions}" var="perm" varStatus="status">
<input type="hidden" name="id<c:out value='${perm.permissionOid}' />" value="<c:out value='${perm.permissionOid}' />">
	<tr><td>
		<select name="access<c:out value='${perm.permissionOid}' />">
			<option value=""></option>
			<c:choose>
				<c:when test='${perm.access=="search"}'>
					<option value="search" selected>Search</option>
					<option value="edit">Edit</option>
					<option value="insert">Add</option>
					<option value="delete">Delete</option>
					<option value="all">All</option>
				</c:when>
					<c:when test='${perm.access=="edit"}'>
					<option value="search">Search</option>
					<option value="edit"  selected>Edit</option>
					<option value="insert">Add</option>
					<option value="delete">Delete</option>
					<option value="all">All</option>
				</c:when>
				<c:when test='${perm.access=="insert"}'>
					<option value="search">Search</option>
					<option value="edit">Edit</option>
					<option value="insert" selected>Add</option>
					<option value="delete">Delete</option>
					<option value="all">All</option>
				</c:when>
				<c:when test='${perm.access=="delete"}'>
					<option value="search">Search</option>
					<option value="edit">Edit</option>
					<option value="insert">Add</option>
					<option value="delete" selected>Delete</option>
					<option value="all">All</option>
				</c:when>
				<c:when test='${perm.access=="all"}'>
					<option value="search">Search</option>
					<option value="edit">Edit</option>
					<option value="insert">Add</option>
					<option value="delete">Delete</option>
					<option value="all" selected>All</option>
				</c:when>
				<c:otherwise>
					<option value="search">Search</option>
					<option value="edit">Edit</option>
					<option value="insert">Add</option>
					<option value="delete">Delete</option>
					<option value="all">All</option>
				</c:otherwise>
			</c:choose>
		</select>
	</td>
	<td>
		<select name="study<c:out value='${perm.permissionOid}' />">
			<option value=""></option>
			<c:forEach items="${studies}" var="study">
			<c:choose>
				<c:when test='${perm.study==study.studyId}'>
					<option value="<c:out value='${study.studyId}' />" selected><c:out value='${study.studyId}' /></option>
				</c:when>
				<c:otherwise>
					<option value="<c:out value='${study.studyId}' />"><c:out value='${study.studyId}' /></option>
				</c:otherwise>
			</c:choose>
			</c:forEach>
			<c:choose>
				<c:when test='${perm.study=="all"}'>
					<option value="all" selected>All</option>
				</c:when>
				<c:otherwise>
					<option value="all">All</option>
				</c:otherwise>
			</c:choose>
		</select>	
	</td>
	</tr>
</c:forEach>
</table>
<table>
<tr><td class="abutton"><a href="javascript: addAccess();">add</a></td></tr>
</table>

<br/><br/>
<table>
<tr><td><input type="submit" value="Save" /></td></tr>
</table>
</form>




