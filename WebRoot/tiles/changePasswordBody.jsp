<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
  
<c:if test='${sessionScope.Message!=null}'>
<p><h3><c:out value='${sessionScope.Message}' /></h3></p>
</c:if>
	<form name="changepassword"  action="/change/password.go" method="post"  >    
       
   
    <h2>Change Password</h2>
    <br/> 
    <table>
    <tr>
	<td class="TdField">Email:</td>
	<td class="TdValue">
	
	    	<input type="email" name="email"/>
	
	</td>
</tr>
			<tr>
			<td class="TdField">Old Password:</td>
			<td class="TdValue">
    			
			    	<input type="password" name="oldpassword"/>
		    	
			</td>
		</tr>
		<tr>
			<td class="TdField">New Password:</td>
			<td class="TdValue">
    			
			    	<input type="password" name="newpassword"/>
		    	
			</td>
		</tr>
		<tr>
			<td class="TdField">Retype New Password:</td>
			<td class="TdValue">
    			
			    	<input type="password" name="renewpassword"/>
		    	
			</td>
		</tr>
				
		<tr>
			<td></td>
			<td>
				<input type="submit" value="Change Password" />
			</td>
		</tr>
		</table>
		<br/>

	</form>
