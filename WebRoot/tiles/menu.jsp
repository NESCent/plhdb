<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>   
    <%-- I18N Formatting with EL --%>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
    
    <%-- SQL with EL --%>
<%@ taglib uri="/WEB-INF/sql.tld" prefix="sql" %>
    
    <%-- XML with EL --%>
<%@ taglib uri="/WEB-INF/x.tld" prefix="x" %>
    
      <%-- functions with EL --%>
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>
     <%-- core tags --%>
<%@ page import="org.nescent.plhdb.util.NoCache" %>

<%       
NoCache.nocache(response);
boolean loggedIn=(request.getSession().getAttribute("permission_manager")!=null);
if(loggedIn)
	 request.setAttribute("loggedin","yes");
else
	 request.setAttribute("loggedin","no");	 
 

 String personOID = (String)request.getAttribute("personOID");
 request.setAttribute("personOID",personOID);

	
 String loginuserRole = (String)request.getSession().getAttribute("loginuserRole");
 request.setAttribute("loginuserRole",loginuserRole);
 
 %>
 <table cellpadding="0" cellspacing="0">
 <tr><td> 

<c:choose>
	<c:when test="${active_menu==null || active_menu=='home'}">	
        <a href="/"><img src="/images/active_home.jpg" alt="Home" /></a>
    </c:when>
    <c:otherwise>
        <a href="/"><img src="/images/inactive_home.jpg" alt="Home"  onmouseover="this.src='/images/active_home.jpg'" onmouseout="this.src='/images/inactive_home.jpg'"/></a>
    </c:otherwise>
</c:choose>
</td><td>
<c:choose>
<c:when test="${active_menu=='biography'}">	
 <a href="/jsp/searchData.jsp"><img src="/images/active_biography.jpg" alt="Search Biography" style="margin:0;lapping:0;border:0;" /></a>
</c:when>
<c:otherwise>
<a href="/jsp/searchData.jsp"><img src="/images/inactive_biography.jpg" alt="Search Biography"   onmouseover="this.src='/images/active_biography.jpg'" onmouseout="this.src='/images/inactive_biography.jpg'" /></a>
</c:otherwise>
</c:choose>
</td><td>
<c:choose>
<c:when test="${active_menu=='fertility'}">	
   <a href="/jsp/searchFertility.jsp"><img src="/images/active_fertility.jpg" alt="Search Fertility" /></a>
</c:when>
<c:otherwise>
    <a href="/jsp/searchFertility.jsp"><img src="/images/inactive_fertility.jpg"  alt="Search Fertility"   onmouseover="this.src='/images/active_fertility.jpg'" onmouseout="this.src='/images/inactive_fertility.jpg'" /></a>
</c:otherwise>
</c:choose>
</td><td>
<c:choose>
<c:when test="${active_menu=='about'}">	
<a href="/jsp/about.jsp"><img src="/images/active_about.jpg"  alt="About" /></a>
</c:when>
<c:otherwise>
<a href="/jsp/about.jsp"><img src="/images/inactive_about.jpg"  alt="About"  onmouseover="this.src='/images/active_about.jpg'" onmouseout="this.src='/images/inactive_about.jpg'"/></a>
</c:otherwise>
</c:choose>
</td><td>
</tr>
</table>

