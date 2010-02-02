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
<c:choose><c:when test="${active_menu==null || active_menu=='home'}"><a href="/"><img src="/images/active_home.jpg" width="66" height="41" alt="Home" /></a></c:when>
<c:otherwise><a href="/"><img src="/images/inactive_home.jpg" width="66" height="41" alt="Home"  onmouseover="this.src='/images/active_home.jpg'" onmouseout="this.src='/images/inactive_home.jpg'"/></a>
</c:otherwise></c:choose>
<c:if test='${loggedin == "no"}'>
<c:choose>
<c:when test="${active_menu=='login'}">	
<a href="/jsp/login.jsp"><img src="/images/active_login.jpg" width="70" height="41" alt="Login" /></a>
</c:when>
<c:otherwise>
<a href="/jsp/login.jsp"><img src="/images/inactive_login.jpg" width="66" height="41" alt="Login"  onmouseover="this.src='/images/active_login.jpg'" onmouseout="this.src='/images/inactive_login.jpg'"/></a>
</c:otherwise>
</c:choose>
</c:if>
<c:if test='${loggedin == "yes"}'>
<c:choose>
<c:when test="${active_menu=='edit'}">	
<a href="/edit.go"><img src="/images/active_edit.jpg" width="80" height="41" alt="Edit Data" /></a>
</c:when>
<c:otherwise>
<a href="/edit.go"><img src="/images/inactive_edit.jpg" width="80" height="41" alt="Edit Data"  onmouseover="this.src='/images/active_edit.jpg'" onmouseout="this.src='/images/inactive_edit.jpg'"/></a>
</c:otherwise>
</c:choose>
<c:choose>
<c:when test="${active_menu=='biography'}">	
<a href="/jsp/searchData.jsp"><img src="/images/active_biography.jpg" width="120" height="41" alt="Search Biography" /></a>
</c:when>
<c:otherwise>
<a href="/jsp/searchData.jsp"><img src="/images/inactive_biography.jpg" width="120" height="41" alt="Search Biography"   onmouseover="this.src='/images/active_biography.jpg'" onmouseout="this.src='/images/inactive_biography.jpg'" /></a>
</c:otherwise>
</c:choose>
<c:choose>
<c:when test="${active_menu=='fertility'}">	
<a href="/jsp/searchFertility.jsp"><img src="/images/active_fertility.jpg" width="110" height="41" alt="Search Fertility" /></a>
</c:when>
<c:otherwise>
<a href="/jsp/searchFertility.jsp"><img src="/images/inactive_fertility.jpg" width="110" height="41" alt="Search Fertility"   onmouseover="this.src='/images/active_fertility.jpg'" onmouseout="this.src='/images/inactive_fertility.jpg'" /></a>
</c:otherwise>
</c:choose>
<c:choose>
<c:when test="${active_menu=='users'}">	
<a href="/view/users.go"><img src="/images/active_users.jpg" width="70" height="41" alt="Users" /></a>
</c:when>
<c:otherwise>
<a href="/view/users.go"><img src="/images/inactive_users.jpg" width="70" height="41" alt="Users"  onmouseover="this.src='/images/active_users.jpg'" onmouseout="this.src='/images/inactive_users.jpg'"/></a>
</c:otherwise>
</c:choose>
</c:if>
<c:choose>
<c:when test="${active_menu=='about'}">	
<a href="/jsp/about.jsp"><img src="/images/active_about.jpg" width="77" height="41" alt="About" /></a>
</c:when>
<c:otherwise>
<a href="/jsp/about.jsp"><img src="/images/inactive_about.jpg" width="77" height="41" alt="About"  onmouseover="this.src='/images/active_about.jpg'" onmouseout="this.src='/images/inactive_about.jpg'"/></a>
</c:otherwise>
</c:choose>
   