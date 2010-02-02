<%@ taglib uri="/WEB-INF/spring.tld" prefix="spring" %>
<%@ page import = "java.util.*" %> 
<%       
request.setAttribute("active_menu","home");
%>
<%

	for(Enumeration e=request.getSession().getAttributeNames(); e.hasMoreElements();)
	{
		String attrName=(String)e.nextElement();
		out.write(attrName+"\n");
		Object o=request.getSession().getAttribute(attrName);
		if(o instanceof List)
		{
			List l=(List)o;
			l.clear();
		}
		else if(o instanceof HashMap)
		{
			HashMap m=(HashMap)o;
			m.clear();
		}

		
		request.getSession().setAttribute(attrName,null);
	}
    try{
    	response.sendRedirect("home.jsp");
    }catch(Exception e){
    	out.write(e.getMessage());
    }
	%>

