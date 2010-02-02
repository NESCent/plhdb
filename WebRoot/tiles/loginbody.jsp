<%@ taglib uri="/WEB-INF/spring.tld" prefix="spring" %>


<h2>Login</h2>
<%
     boolean loggedIn=(request.getSession().getAttribute("permission_manager")!=null);

 %>

    <%
    
	String message=(String)request.getSession().getAttribute("Message");
	if(message==null || message.trim().equals(""))
		message=(String)request.getAttribute("message");
    if(message!=null)
    {
    %>
    	<br/><font color="red"><%=message %></font><br/>
    <%
    	request.getSession().setAttribute("Message",null);
    	message=null;
    }
    String usertype = "newuser";
	request.setAttribute("usertype",usertype);
	String Applicant = "Applicant";
	request.setAttribute("Applicant",Applicant);
    %>
    
     
    <form method="post" action="login.go">
    
    <table>

	    <tr>
	    	<td class="TdField">Username</td>
	    	<td class="TdValue">

		    		<input type="text" name="email" value=""/>

			</td>
		</tr>
		<tr>
			<td class="TdField">Password</td>
			<td class="TdValue">
    			
			    	<input type="password" name="password" value=""/>
		    	
			</td>
		</tr>
				
		<tr>
			<td></td>
			<td>
				<input type="submit" value="login" />
			</td>
		</tr>
		</table>
		
 
		<h4>Forgot your username and password? <a href="/plhdb/jsp/resetpassword.jsp">Please retrieve it.</a></h4> 

		<h4>To report bugs, please contact <a href="ma&#105;l&#116;&#111;:&#112;lhdb&#x40;nes&#x63;&#101;&#x6e;&#116;.&#x6f;&#114;g">&#112;lh&#100;&#x62;&#x40;ne&#x73;&#99;&#x65;nt&#46;&#111;&#114;g</a></h4> 

	</form>

