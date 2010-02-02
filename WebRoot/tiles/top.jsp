
<%@page import="java.io.File" %>
<%@page import="java.io.FileInputStream" %>
<%@page import="org.nescent.plhdb.util.PlhdbConfiguration" %>
<%
String version = "";
String built="";

PlhdbConfiguration plhdbConfig=(PlhdbConfiguration)request.getSession().getServletContext().getAttribute("plhdb_config");
if(plhdbConfig==null)
{
	plhdbConfig=new PlhdbConfiguration();
	String configFile="config/plhdb.conf";
	try
	{
		String file=getServletContext().getRealPath(configFile);
			
		FileInputStream in=new FileInputStream(new File(file));
		plhdbConfig.load(in);
		this.getServletContext().setAttribute("plhdb_config", plhdbConfig);
	}
	catch(Exception e)
	{
		out.write("Error: "+e);
	}
}		
if(plhdbConfig!=null)
{
	if(plhdbConfig.getProperty("Version")!=null)
		version=plhdbConfig.getProperty("Version");
	if(plhdbConfig.getProperty("Deploy_Date")!=null)
		built=plhdbConfig.getProperty("Deploy_Date");
}
String username="";
boolean loggedIn=(request.getSession().getAttribute("permission_manager")!=null);
if(loggedIn){	 
	 username= (String)request.getSession().getAttribute("username");
}


%>
<div id="logo"><img src="/images/plhdb_logo.jpg" width="172" height="45" alt="Primate Life Histories" /></div>
<div id="user_info">Version: <%=version %>&nbsp;&nbsp;Built: <%=built %>
<% if(loggedIn){ %>
    <br/>Logged in as: <%=username %>  &nbsp;&nbsp;[ <a href="/jsp/changepassword.jsp">Change Password</a> | <a href="/jsp/logout.jsp">Logout</a> ] 
<% } %>
</div>