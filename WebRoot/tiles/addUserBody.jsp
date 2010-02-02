<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>   
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/fmt.tld"%>
<%@ page import="org.nescent.plhdb.util.NoCache" %>

<%       
NoCache.nocache(response);
request.setAttribute("active_menu","users");
%>

<script language="javascript">

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
<form method="post" action="/save/user.go" name="user_form" >
<input type="hidden" name="user" value="-1" />
<table><tr>
<td class="TdField">Last Name</td><td class="TdValue"><input type="text" name="lastName" value="" /></td></tr><tr>
<td class="TdField">First Name</td><td class="TdValue"><input type="text" name="firstName" value="" /></td></tr><tr>
<td class="TdField">Email</td><td class="TdValue"><input type="text" name="email" value="" /></td></tr>
<td class="TdField">Is Admin?</td><td class="TdValue">
<select name="isAdmin">
	<option value="no">No</option>
	<option value="yes">Yes</option>
</select>
</td>
</tr>
</table>
<p>An admin can have full access right to all of the records in the database. </p>
<h3>Access to studies</h3>
<table id="accessForm" name="accessForm"><tr><th>access</th><th>study</th></tr>
</table>
<table>
<tr><td class="abutton"><a href="javascript: addAccess();">add</a></td></tr>
</table>
<br/><br/>
<table>
<tr><td><input type="submit" value="Save" /></td></tr>
</table>
</form>

