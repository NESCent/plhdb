<%@ taglib uri="/WEB-INF/spring.tld" prefix="spring" %>


    <%
	String message=(String)request.getSession().getAttribute("Message");
    if(message!=null)
    {
    %>
    
    <h2>Error</h2><br/><br/>
    <span classs="error"><%=message %></span><br/>
    <%
    request.getSession().setAttribute("Message",null);
    }
    %>

