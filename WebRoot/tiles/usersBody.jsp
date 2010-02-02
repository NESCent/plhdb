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

</script>

<h2>User List</h2>
<table><tr>
<th>Last Name</th>
<th>First Name</th>
<th>Email</th>
<th>Is Admin?</th>
<th>Permissions</th>
<th>Action</th>
</tr>
<c:forEach items="${users}" var="user" varStatus="status">
	<c:set var="rowStyle" value="TrOdd" />
	<c:if test='${status.count%2==0}'>
		<c:set var="rowStyle" value="TrEven" />
	</c:if>
	<tr class="<c:out value='${rowStyle}'/>">
		<td><c:out value='${user.lastName}' /></td>
		<td><c:out value='${user.firstName}' /></td>
		<td><c:out value='${user.email}' /></td>
		<td><c:out value='${user.admin}' /></td>
		<td>
		<table border=1><tr><th>access</th><th>study</th></tr>
		<c:forEach items="${user.permissions}" var="perm">
		<tr><td><c:out value='${perm.access}' /></td>
		<td><c:out value='${perm.study}' /></td></tr>
		
		</c:forEach>
		</table>
		</td>
		<td>
		
			<table>
			<tr>
				<td class="abutton"><a href="/plhdb/edit/user.go?id=<c:out value='${user.userAccountOid}' />">Edit</a></td>
				<td class="abutton"><a href="javascript: deleteUser('<c:out value='${user.userAccountOid}' />')">Delete</a></td>
			</tr>
			</table>
			
		</td>
	</tr>	
</c:forEach>
</table>

