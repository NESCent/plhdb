<%
String message = (String)request.getSession().getAttribute("Message");
%>
    
<form name="resetpassword"  action="/reset/password.go" method="post"  >    
       
   
    <h2>Change Password</h2>
    <br/> 
    <table>
	<tr>
		<td class="TdField">Your email address:</td>
			<td class="TdValue">
    			
			    	<input type="text" name="emailAddress"/>
		    	
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<input type="submit" value="Reset Password" />
			</td>
		</tr>
		</table>
		<br/>
		If you reset your password, a random password will be created and mailed to the above email address.   

	</form>
	<%
	if(message!=null && !message.trim().equals(""))
	{
	%>
		<br/><br/><br/><h2><%= message %></h2>
	<%
	}
	%>